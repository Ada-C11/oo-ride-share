require_relative "spec_helper"

describe RideShare::CsvRecord do
  describe "constructor" do
    it "takes and saves an id" do
      id = 7
      record = RideShare::CsvRecord.new(id)
      expect(record.id).must_equal id
    end

    it "validates the ID" do
      id = -7
      expect {
        RideShare::CsvRecord.new(id)
      }.must_raise ArgumentError
    end
  end

  describe "load_all" do
    it "raises an error if neither full_path nor directory is provided" do
      expect {
        RideShare::CsvRecord.load_all
      }.must_raise ArgumentError
    end

    it "raises an error if invoked directly (without subclassing)" do
      full_path = "specs/test_data/testrecords.csv"
      expect {
        RideShare::CsvRecord.load_all(full_path: full_path)
      }.must_raise NotImplementedError
    end
  end

  describe "validate_id" do
    it "accepts natural numbers" do
      [1, 10, 9999].each do |id|
        RideShare::CsvRecord.validate_id(id)
      end
    end

    it "raises for negative numbers and 0" do
      [0, -1, -10, -9999].each do |id|
        expect {
          RideShare::CsvRecord.validate_id(id)
        }.must_raise ArgumentError
      end
    end

    it "raises for nil" do
      expect {
        RideShare::CsvRecord.validate_id(nil)
      }.must_raise ArgumentError
    end
  end

  describe "extension" do
    class TestRecord < RideShare::CsvRecord
      attr_reader :name

      def initialize(id:, name:)
        super(id)
        @name = name
      end

      def self.load_all(*args, **kwargs)
        @call_count = 0
        super
      end

      def self.from_csv(record)
        new(**record)
        @call_count ||= 0
        @call_count += 1
      end

      class << self
        attr_reader :call_count
      end
    end

    describe "load_all" do
      let(:record_count) {
        %x{wc -l 'specs/test_data/testrecords.csv'}.split(" ").first.to_i - 1
      }
      it "finds data given just a directory" do
        directory = "specs/test_data"
        records = TestRecord.load_all(directory: directory)

        expect(records.length).must_equal record_count
      end

      it "finds data given a directory and filename" do
        directory = "specs/test_data"
        file_name = "custom_filename_test.csv"
        records = TestRecord.load_all(directory: directory, file_name: file_name)

        expect(records.length).must_equal record_count
      end

      it "finds data given a full path" do
        path = "specs/test_data/custom_filename_test.csv"
        records = TestRecord.load_all(full_path: path)

        expect(records.length).must_equal record_count
      end

      it "calls `from_csv` for each record in the file" do
        TestRecord.load_all(directory: "specs/test_data")

        expect(TestRecord.call_count).must_equal record_count
      end
    end
  end
end

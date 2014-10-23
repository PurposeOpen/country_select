require 'action_view'
require 'sort_alphabetical'

require 'purpose_country_select/purpose_country_select'
require 'purpose_country_select/version'

module PurposeCountrySelect
  NON_POST_CODE_COUNTRIES = ["af", "al", "ao", "ai", "aw", "bs", "bb", "bz", "bj", "bt", "bo", "bw", "bi", "ky", "cf", "td", "cn", "co", "km", "cg", "cd", "ck", "cr", "cu", "dm", "gq", "er", "et", "fo", "fj", "gm", "ge", "gh", "gd", "hk", "ie", "jm", "ki", "kg", "lr", "ly", "li", "mo", "mw", "mr", "mu", "yt", "mc", "ms", "mz", "mm", "nr", "nc", "ne", "nf", "mp", "kp", "pw", "pa", "re", "rw", "sh", "kn", "lc", "pm", "vc", "ws", "sm", "st", "sc", "sl", "so", "sr", "sy", "tj", "tz", "tl", "tg", "tk", "to", "tm", "tv", "ug", "ua", "ae", "vu", "vn", "wf", "eh", "zm", "zw"]

  COUNTRIES = {}
  DONATION_COUNTRIES = {}

  CSV_HEADERS = ['iso','en','es','pt','fr','de','nl','ca']
  USES_POSTCODE = 'uses-postcode'
  DEFAULT_LOCALE = 'en'
  LANGUAGES = CSV_HEADERS - ['iso']

  DATA_DIR = Pathname.new(__FILE__).join("..", "..", "data")
  SEPARATOR_STRING = "-------------"

  class << self
    def init
      CSV_HEADERS.each do |header|
        PurposeCountrySelect::COUNTRIES[header] = []
        PurposeCountrySelect::DONATION_COUNTRIES[header] = []
      end

      build_countries_hash_from_csv('countries.csv', PurposeCountrySelect::COUNTRIES, CSV_HEADERS)
      build_countries_hash_from_csv('donation_countries.csv', PurposeCountrySelect::DONATION_COUNTRIES, CSV_HEADERS)

      associate_country_iso_codes_with_international_names(PurposeCountrySelect::COUNTRIES, CSV_HEADERS)
      associate_country_iso_codes_with_international_names(PurposeCountrySelect::DONATION_COUNTRIES, CSV_HEADERS)
    end

    private

    def build_countries_hash_from_csv(filename, countries, csv_headers)
      countries[USES_POSTCODE] = []

      CSV.foreach(DATA_DIR.join(filename), :headers => true, :encoding => "UTF-8") do |row|
        CSV_HEADERS.each do |header|
          countries[header] << row[header]
        end
        iso_code = row[CSV_HEADERS.first]
        countries[USES_POSTCODE] << !NON_POST_CODE_COUNTRIES.include?(iso_code.to_s.strip.downcase)
      end
    end

    def associate_country_iso_codes_with_international_names(csv_rows, csv_headers)
      LANGUAGES.each do |lang|
        csv_rows[lang] = csv_rows[lang].zip(csv_rows[USES_POSTCODE], csv_rows['iso'])
      end
    end
  end
end

PurposeCountrySelect.init

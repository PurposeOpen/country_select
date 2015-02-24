require 'csv'

module CountryHelper
  def country_name(country_iso, locale)
    countries = PurposeCountrySelect::COUNTRIES[locale.to_s] || PurposeCountrySelect::COUNTRIES[PurposeCountrySelect::DEFAULT_LOCALE]
    country_info = countries.find do |country_iso_pair|
      country_iso_pair.last == country_iso.to_s
    end
    country_info ? country_info.first : country_iso
  end

  def is_non_post_code_country(country_iso)
    return false unless country_iso
    PurposeCountrySelect::NON_POST_CODE_COUNTRIES.include?(country_iso.to_s.downcase)
  end
end

# CountrySelect
module ActionView
  module Helpers
    module FormOptionsHelper

      # Return select and option tags for the given object and method, using country_options_for_select to generate the list of option tags.
      def country_select(object, method, options = {}, html_options = {})
        select_tag("#{object}[#{method}]",
          country_options_for_select(
            html_options.with_indifferent_access[:selected], options),
          html_options.stringify_keys)
      end

      # Returns a string of option tags for pretty much any country in the world. Supply a country name as +selected+ to
      # have it marked as the selected option tag. You can also supply an array of countries as +priority_countries+, so
      # that they will be listed above the rest of the (long) list.
      #
      # NOTE: Only the option tags are returned, you have to wrap this call in a regular HTML select tag.
      def country_options_for_select(selected = nil, options = nil)
        options ||= {}

        selected = if selected.present?
          selected
        elsif options[:placeholder]
          :placeholder
        elsif options[:priority_countries]
          :first_country
        else nil end

        [ optional_placeholder(options, selected),
          optional_priority_countries_list(options, selected),
          full_countries_list(options, selected)
        ].join.html_safe
      end

      private

      def optional_placeholder(options, selected)
        return '' unless options[:placeholder]

        html_options = { :disabled => '' }
        html_options[:selected] = '' if selected == :placeholder

        options_for_select [[ options[:placeholder], '' ]], html_options
      end

      def optional_priority_countries_list(options, selected)
        return '' unless options[:priority_countries]

        separator_string = options[:separator] || PurposeCountrySelect::SEPARATOR_STRING
        selected = ( selected == :first_country ) ? options[:priority_countries].first : selected
        full_list = options[:priority_countries] + [[ separator_string, '' ]]

        options_for_select full_list, :disabled => '', :selected => selected
      end

      def full_countries_list(options, selected)
        full_countries_list_for_locale = countries_for_locale(options[:donation], I18n.locale.to_s)
        options_for_select(full_countries_list_for_locale, selected)
      end

      def countries_for_locale(is_donation, locale)
        countries = is_donation ? PurposeCountrySelect::DONATION_COUNTRIES : PurposeCountrySelect::COUNTRIES
        by_locale = countries[locale] || countries[PurposeCountrySelect::DEFAULT_LOCALE]
        by_locale.map {|country| [country.first, country.last, {'data-uses-postcode' => country[1]}]}.sort_alphabetical_by(&:first)
      end
    end

    class FormBuilder
      def country_select(method, options = {}, html_options = {})
        @template.country_select(@object_name, method, options.merge(:object => @object), html_options)
      end
    end
  end
end

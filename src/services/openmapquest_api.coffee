qs      = require 'querystring'
request = require 'request'
log     = require '../../lib/logging'

class OpenMapquestApi

  constructor: () ->
    @

  _valFn: (val) ->
    () -> val

  reverseGeocode: (lat, lon, cb) ->
    host    = 'nominatim.openstreetmap.org'
    path    = 'reverse'
    url     = "http://#{host}/#{path}?format=json&lat=#{lat}&lon=#{lon}"
    options =
      url: url
      headers: { 'accept-language': 'de,en' }
    log.debug options
    request options, (err, resp, json) =>
      key = undefined
      if err
        log.error err
      else
        if resp.statusCode == 200
          try
            body     = JSON.parse json
            log.debug "openmapquest_api: received reverse geocoding: #{json}"
            address  = body.address
            if address
              country  = address.country_code?.toUpperCase()
              state    = address.state
              location = address.city || address.village || address.county || state
              throw "openmapquest_api: Failed to reverse geocode a country for (#{lat},#{lon})" if !country
              throw "openmapquest_api: Failed to reverse geocode a location for (#{lat},#{lon})" if !location
              key      =
                  countryName: country,
                  stateName: state,
                  cityName: location
          catch error
            log.notice "openmapquest_api: #{error}"
        else
          log.notice "openmapquest_api: status code #{resp.statusCode}"
      log.info "openmapquest_api: Resolved (#{lat},#{lon}) to #{JSON.stringify(key)}"
      if key
        key.countryName = @_valFn key.countryName
        key.stateName   = @_valFn key.stateName
        key.cityName    = @_valFn key.cityName
      cb key


module.exports         = OpenMapquestApi
module.exports.default = new OpenMapquestApi()

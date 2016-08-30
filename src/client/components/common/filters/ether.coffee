'use strict'

angular.module 'loopback-admin'

.filter 'ether', ->
  (input) ->
    if input == null
      return input
    x = new BigNumber(input)
    x.dividedBy 1e+18
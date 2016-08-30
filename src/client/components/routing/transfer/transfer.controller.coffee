'use strict'

angular.module 'loopback-admin'

.controller 'transferController', (User, $mdDialog, $rootScope, $log) ->
  vm = this

  vm.deferred = null

  vm.filter =
    options:
      debounce: 500

  vm.query =
    filter: null
    limit: 10
    orderPlain: 'id'
    orderDirection: 'DESC'
    page: 1

  vm.model = User
  vm.resource = User.resource
  vm.rows = []

  refreshRows = ->
    page = parseInt vm.query.page, 10

    filter =
      include: vm.model.relationNames
      skip: (page - 1) * vm.query.limit
      limit: vm.query.limit
      order: vm.query.orderPlain + ' ' + vm.query.orderDirection

    params =
      filter: filter

    vm.rows = vm.resource.find params, (data, headers) ->
      vm.count = parseInt headers('x-total-count')

    vm.deferred = vm.rows.$promise

    vm.deferred

  if vm.resource and angular.isFunction vm.resource.find
    refreshRows()
  
  vm.showTransferModal = (row, $event) ->
    $mdDialog.show
      locals:
        row: row
        model: vm.model
      templateUrl: "templates/modals/transfer.tpl.html"
      targetEvent: $event
      clickOutsideToClose: true
      controller: 'transferModel'
      controllerAs: 'modal'

  vm.removeFilter = ->
    vm.filter.show = false
    vm.query.filter = ''

    if vm.filter.form.$dirty
      vm.filter.form.$setPristine()

      refreshRows()

    return

  vm.onOrderChange = (order, $event) ->
    $log.info 'Scope Order: ' + vm.query.order
    $log.info 'Order: ' + order

    direction = 'ASC'

    if order.charAt(0) is '-'
      direction = 'DESC'
      orderPlain = order.slice 1

    vm.query.order = order
    vm.query.orderPlain = orderPlain or order
    vm.query.orderDirection = direction

    refreshRows()

    return

  vm.onPageChange = (page, limit) ->
    $log.info 'Scope Page: ' + vm.query.page + ' Scope Limit: ' + vm.query.limit
    $log.info 'Page: ' + page + ' Limit: ' + limit

    vm.query.page = page
    vm.query.limit = limit

    refreshRows()

    return

  vm.onFilterChange = (filter, $event) ->
    $log.info 'Scope Filter: ' + vm.query.filter
    $log.info 'Filter: ' + filter

    vm.query.page = 1

    refreshRows()

    return
  return


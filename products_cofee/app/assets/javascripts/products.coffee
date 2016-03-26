$(document).ready ->
  baseUrl = 'https://devpoint-ajax-example-server.herokuapp.com/api/v1'

  getProducts = ->
    $('#products').empty()
    $.ajax
      url: "#{baseUrl}/products"
      type: 'GET'
      success: (data) ->
        for product in data.products
          if product.quanity_on_hand > 0
            $.ajax
              url: '/product_card'
              type: 'GET'
              data:
                product: product
              success: (data) ->
                 $('#products').append data
              error: (data) ->
                console.log data
      error: (data) ->
        console.log data

  getProducts()

  $('#new_product').on 'click', ->
    $('#add_product').removeClass('hide')
    $('#new_product').addClass('hide')

  $('#add_product').on 'submit', (e) ->
    e.preventDefault()
    newProduct = $('#add_product')
    form = newProduct.children('input')
    $.ajax
      url: "#{baseUrl}/products"
      type: 'POST'
      data: $(this).serializeArray()
      success: (data) ->
        form.val('')
        newProduct.addClass('hide')
        $('#new_product').removeClass('hide')
        getProducts()
      error: (data) ->
        console.log data

  $(document).on 'click', '#show_product', (e) ->
    e.preventDefault()
    $.ajax
      url: "#{baseUrl}/products/#{$(this).attr('href')}"
      type: 'GET'
      success: (data) ->
        product = data.product
        $('#products').empty()
        $.ajax
          url: "/product_card"
          type: 'GET'
          data: product: product
          success: (data) ->
            $('#products').append data
            $('#new_product').addClass 'hide'
            $('#back').removeClass 'hide'
            $('.hidden').removeClass 'hide'
            $('#links').addClass 'hide'
          error: (data) ->
            console.log data
      error: (data) ->
        console.log(data)

  $('#back').on 'click', ->
    $('#newProduct').removeClass 'hide'
    $('.hidden').addClass 'hide'
    $('#links').removeClass 'hide'
    $('#back').addClass 'hide'
    getProducts()


  $(document).on 'click', '#edit_product', (e) ->
    e.preventDefault()
    editForm = $('#edit_product_form')
    editForm.removeClass 'hide'
    $('#new_product').addClass 'hide'
    $.ajax
      url: "#{baseUrl}/products/#{$(this).attr 'href'}"
      type: 'GET'
      success: (data) ->
        $('body').scrollTop(0)
        product = data.product
        editForm.find('#product_name').val(product.name)
        editForm.find('#product_price').val(product.base_price)
        editForm.find('#product_description').val(product.description)
        editForm.find('#product_quantity').val(product.quanity_on_hand)
        editForm.find('#product_color').val(product.color)
        editForm.find('#product_weight').val(product.weight)
        editForm.find('#product_attr').val(product.other_attributes)
        editForm.find('#product_id').val(product.id)
      error: (data) ->
        console.log data

  $('#edit_product_form').on 'submit', (e) ->
    e.preventDefault()
    productId = $(this).find('#product_id').val()
    $('#edit_product_form').addClass 'hide'
    $('#new_product').removeClass 'hide'
    $.ajax
      url: "#{baseUrl}/products/#{productId}"
      type: 'PUT'
      data: $(this).serializeArray()
      success: (data) ->
        getProducts()
      error: (data) ->
        console.log data


  $(document).on 'click', '#delete_product', (e) ->
    e.preventDefault()
    $.ajax
      url: "#{baseUrl}/products/#{$(this).attr('href')}"
      type: 'DELETE'
      success: (data) ->
        getProducts()
        alert data.message
      error: (data) ->
        console.log data


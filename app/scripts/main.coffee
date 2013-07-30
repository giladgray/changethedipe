require.config
  paths:
    jquery: '../bower_components/jquery/jquery'
    'jquery.transit': '../bower_components/jquery.transit/jquery.transit'
    bootstrap: 'vendor/bootstrap'
    handlebars: '../bower_components/handlebars/handlebars.runtime'

  shim:
    bootstrap:
      deps: ['jquery']
      exports: 'jquery'
    'jquery.transit':
      deps: ['jquery']
    handlebars:
      exports: 'Handlebars'
      init: ->
        @Handlebars = Handlebars

require ['templates', 'jquery', 'jquery.transit', 'helpers'], (Templates, $) ->
  TIMING = 800

  diapers = window.diapers =
    classic:
      image: 'pixel-dipe.png'
      background: '255,255,255'
      also: ['poo.gif']
    astro:
      image: 'orbital-dipe.png'
      background: '30,30,30'
      also: ['planet-1.png', 'planet-2.png', 'planet-3.png']
    bane:
      image: 'bane-dipe.png'
      background: '200,200,200'
    hipster:
      image: 'hipster-dipe.png'
      background: '128,0,128'
    enviro:
      image: 'forest-dipe.png'
      background: '168,199,252'
    fancy:
      image: 'fancy-dipe.png'
      background: '165,1,1'

  $(document).ready ->
    dipesChanged = 0
    oldDipe = ''
    $.fx.speeds._default = TIMING

    othersList = $('.others ul')
    for dipe, details of diapers
      othersList.append Templates.diaper
        dipe: dipe
        image: "images/#{details.image}"

    dipe = $('#diaper')

    $('.others img').bind 'click', (e) ->
      newDipe = $(this).takeClass('active').attr('alt')
      $('.stats').fadeIn()
      # move dipe offscreen, change image once transition completes
      dipe.transition { top: '150%'}, ->
        # change image and update margins to center
        loaded = false
        dipe.find('img').attr('src', 'images/' + diapers[newDipe].image).load ->
          return if loaded
          loaded = true
          dipe.css 'margin-top', -@height / 2

          # insert bonus elements
          $('#also').html('')
          if diapers[newDipe].also
            for bonus in diapers[newDipe].also
              bits = /^([^\.]+)\.(\w+)/.exec bonus
              $('#also').append Templates.bonus(name: bits[1], file: bits[0])

          # move it back onscreen
          dipe.transition({ top: '50%' }).swapClass(oldDipe, newDipe)
          # update score and pulse it
          $('.stats em').text(++dipesChanged)
            .transition({ scale: 1.5, color: 'orange' }, 300)
            .transition({ scale: 1, color: 'white', easing: 'snap' }, 300)
          # update tweet text
          $('#tw').attr('onclick', $('#tw').attr('onclick').replace(/%20\d+%20dipes/, "%20#{dipesChanged}%20dipes"))

          oldDipe = newDipe

      # change body background color
      $('body').transition({ background: "rgb(#{diapers[newDipe].background})" }, TIMING * 2)

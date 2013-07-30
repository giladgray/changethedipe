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

  diapers =
    classic:
      image: 'pixel-dipe.png'
      background: '255,255,255'
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
    kawaii:
      image: 'kawaii-dipe.png'
      background: '153,207,233'
      also: ['kawaii-bows.png']
    enviro:
      image: 'forest-dipe.png'
      background: '168,199,252'
    fancy:
      image: 'fancy-dipe.png'
      background: '165,1,1'
    angel:
      image: 'angel-dipe.png'
      background: '255,246,205'
      also: ['angel-dipe-wings.gif', 'angel-cloud.png', 'angel-cloud.png', 'angel-cloud.png']

  $(document).ready ->
    dipesChanged = -1
    oldDipe = ''
    $.fx.speeds._default = TIMING

    othersList = $('.others ul')
    for dipe, details of diapers
      othersList.append Templates.diaper
        dipe: dipe
        image: "images/#{details.image}"

    $dipe = $('#diaper')
    $audio = $('audio')
    audioType = if !!$audio[0].canPlayType('audio/ogg') then 'ogg' else 'mp3'

    $('.others img').bind 'click', (e) ->
      newDipe = $(this).takeClass('active').attr('alt')
      # bring the music volume down
      $audio.animate {volume: 0}, TIMING
      # move dipe offscreen, change image once transition completes
      $dipe.transition { top: '150%' }, ->
        loaded = false

        # change music and get it loading.
        # music files are named according to diaper object above
        $audio.attr('src', "audio/#{newDipe}-dipe.#{audioType}")
        $audio[0].load()

        $dipe.find('img').attr('src', 'images/' + diapers[newDipe].image).load ->
          # prevent load spamming -- one change seems to trigger the callback 4+ times
          return if loaded
          loaded = true
          # center dipe vertically, they're not all the same height
          $dipe.css 'margin-top', -@height / 2
          dipesChanged++

          # insert bonus elements
          $('#also').html('')
          if diapers[newDipe].also
            for bonus in diapers[newDipe].also
              bits = /^([^\.]+)\.(\w+)$/.exec bonus
              $('#also').append Templates.bonus(name: bits[1], file: bits[0])

          # now play the music and bring volume back up
          $audio[0].play()
          $audio.animate {volume: 1}, TIMING

          # move it back onscreen
          $dipe.transition({ top: '45%' }).swapClass(oldDipe, newDipe)
          # update score and pulse it
          if dipesChanged > 0
            $('.stats').fadeIn()
            $('.stats em').text(dipesChanged)
              .transition({ scale: 1.5, color: 'orange' }, 300)
              .transition({ scale: 1, color: 'white', easing: 'snap' }, 300)

            if dipesChanged % 10 is 0
              $('h1').addClass('levelup')
              $('#also').append Templates.bonus(name: 'poo', file: 'poo.gif')
            else
              $('h1').removeClass('levelup')

          # update tweet text
          $('#tw').attr('onclick', $('#tw').attr('onclick').replace(/%20\d+%20dipes/, "%20#{dipesChanged}%20dipes"))

          oldDipe = newDipe

      # change body background color
      $('body').transition({ background: "rgb(#{diapers[newDipe].background})" }, TIMING * 2)

    $('.others img').first().click()

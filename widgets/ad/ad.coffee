class Dashing.Ad extends Dashing.Widget
  @accessor 'timeMessage', ->
    if time = @get('time')
      timestamp = new Date(time * 1000)
      timestamp.toLocaleString()

  onData: (data) ->
    addMark = false
    addAkc = false

    # TODO: remove before checkin
    if data.ad_src && data.ad_src.startsWith('AKC ')
      addMark = true
      addAkc = true
     
    now = new Date()
    date = new Date(data.time * 1000)
    if now.toDateString() == date.toDateString()
      addMark = true

    if addMark
      $(@get('node')).addClass 'mark'
      if addAkc
        $(@get('node')).find('.mark').text('AKC')
    else
      $(@get('node')).find('.mark').text('Update!')
      $(@get('node')).removeClass('mark')

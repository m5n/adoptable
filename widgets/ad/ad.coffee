class Dashing.Ad extends Dashing.Widget
  @accessor 'timeMessage', ->
    if time = @get('time')
      timestamp = new Date(time * 1000)
      timestamp.toLocaleString()

  onData: (data) ->
    now = new Date()
    date = new Date(data.time * 1000)
    if now.toDateString() == date.toDateString()
      $(@get('node')).addClass 'mark'

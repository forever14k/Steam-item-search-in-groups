hook__FlipToTab = () ->
  if window.FlipToTab?
    window.hooked__FlipToTab = window.FlipToTab
    window.FlipToTab = ( tab ) ->
      window.hooked__FlipToTab arguments...

      message =
        hook__FlipToTab:
          tab: tab
      window.postMessage message, '*'

new injectHook hook__FlipToTab

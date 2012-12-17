program zgld25;
{$DEFINE STATIC}
{$R *.res}
uses zgl_main, zgl_window, zgl_screen, zgl_timers, zgl_utils;

begin
  wnd_SetCaption( 'hello world!' );
  scr_SetOptions( 800, 600,
                  REFRESH_MAXIMUM,
                  {fullscreen=} False,
                  {vsync=} False );
  zgl_Init;
end.


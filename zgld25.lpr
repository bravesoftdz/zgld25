program zgld25;
{$DEFINE STATIC}
{$R *.res}
uses
  sysutils,
  zgl_main, zgl_window, zgl_screen,
  zgl_timers, zgl_utils, zgl_textures_png,
  zgl_textures, zgl_sprite_2d;

type
  texture = zglptexture;

var
  assetdir : UTF8String = 'assets';
  spritesheet : texture;

procedure init;
begin
  spritesheet := tex_LoadFromFile( assetdir + '/invaders.png' );
  tex_SetFrameSize( spritesheet, 50, 50 );
end;


procedure render;
begin
   asprite2d_Draw(spritesheet, 100, 100, 50, 50, 30, 10 );
end;

begin
  wnd_SetCaption( 'hello world!' );
  scr_SetOptions( 800, 600,
                  REFRESH_MAXIMUM,
                  {fullscreen=} False,
                  {vsync=} False );
  zgl_Reg( SYS_LOAD, @init );
  zgl_Reg( SYS_DRAW, @render );
  zgl_Init;
end.


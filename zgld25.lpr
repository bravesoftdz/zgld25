program zgld25;

{$DEFINE STATIC}
{$R *.res}
uses
  SysUtils,
  zgl_main,
  zgl_keyboard,
  zgl_window,
  zgl_screen,
  zgl_timers,
  zgl_utils,
  zgl_textures_png,
  zgl_textures,
  zgl_sprite_2d;

type
  texture = zglptexture;

type
  sprite = object
    x, y : integer
  end;

var
  assetdir : UTF8String = 'assets';
  spritesheet : texture;
  alien : sprite;

  procedure init;
  begin
    spritesheet := tex_LoadFromFile( assetdir + '/invaders.png' );
    tex_SetFrameSize( spritesheet, 50, 50 );
  end;

  procedure update( dt : double );
  begin
    if key_press( K_RIGHT ) then Inc( alien.x );
    if key_Press( K_LEFT ) then Dec( alien.x );
    if key_Press( K_UP ) then Dec( alien.y );
    if key_press( k_down ) then Inc( alien.y );
    key_clearstate;
  end;

  procedure render;
  begin
    asprite2d_Draw( spritesheet, alien.x, alien.y, 50, 50, 30, 10 );
  end;

begin
  wnd_SetCaption( 'hello world!' );
  scr_SetOptions( 800, 600,
    refresh_default,
    {fullscreen=} False,
    {vsync=} False );
  zgl_reg( sys_load, @init );
  zgl_reg( sys_update, @update );
  zgl_reg( sys_draw, @render );
  zgl_init;
end.

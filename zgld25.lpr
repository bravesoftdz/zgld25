program zgld25;

{$DEFINE STATIC}
{$R *.res}
uses
  math,
  SysUtils,
  zgl_main,
  zgl_keyboard,
  zgl_window,
  zgl_screen,
  zgl_timers,
  zgl_utils,
  zgl_textures_png,
  zgl_textures,
  zgl_math_2d,
  zgl_sprite_2d;

type
  texture = zglptexture;
  real = single;
  vector2d = zglTPoint2D;

type
  sprite = object
    x, y   : real;
    dx, dy : real;
    accel : vector2d;
  end;

var
  assetdir : UTF8String = 'assets';
  spritesheet : texture;
  alien : sprite;

  procedure init;
  begin
    spritesheet := tex_LoadFromFile( assetdir + '/invaders.png' );
    tex_SetFrameSize( spritesheet, 50, 50 );
    alien.accel.x := 0.050;
    alien.accel.y := 0.025;
  end;

  procedure update( dt : double );
  begin
    if key_down( K_RIGHT ) then alien.dx += alien.accel.x;
    if key_down( K_LEFT ) then alien.dx -= alien.accel.x;
    if key_down( K_UP ) then alien.dy -= alien.accel.y;
    if key_down( k_down ) then alien.dy += alien.accel.y;
    key_clearstate;

    if abs(alien.dx) > 75 then alien.dx := sign( alien.dx ) * 7.5;
    if abs(alien.dy) > 75 then alien.dy := sign( alien.dy ) * 7.5;
    if alien.x < 0 then begin alien.x := 0; alien.dx := 0 end;
    if alien.x > 750 then begin alien.x := 750; alien.dx := 0 end;
    if alien.y < 0 then begin alien.y := 0; alien.dy := 0 end;
    if alien.y > 550 then begin alien.y := 550; alien.dy := 0 end;
    alien.x += alien.dx * dt / 100;
    alien.y += alien.dy * dt / 100;
    alien.dy += 0.001; // gravity
  end;

  procedure render;
  begin
    asprite2d_Draw( spritesheet, alien.x, alien.y, 50, 50, floor((alien.dx / 75) * 20), 10 );
  end;

begin
  wnd_SetCaption( 'hello world!' );
  scr_SetOptions( 800, 600,
    18,
    {fullscreen=} False,
    {vsync=} False );
  zgl_reg( sys_load, @init );
  zgl_reg( sys_update, @update );
  zgl_reg( sys_draw, @render );
  zgl_init;
end.

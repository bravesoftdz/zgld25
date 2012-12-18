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

const
  assetdir : UTF8String = 'assets';
  maxfps = 50;
  naplen = 1000 div maxfps;
  maxdx = 12.5;
  maxdy = 7.5;
  gravity = 0.075;
  friction = 0.0125;

var
  spritesheet : texture;
  alien : sprite;

  procedure init;
  begin
    spritesheet := tex_LoadFromFile( assetdir + '/invaders.png' );
    tex_SetFrameSize( spritesheet, 50, 50 );
    alien.accel.x := 0.50;
    alien.accel.y := 0.25;
  end;

  procedure update( dt : double );
  begin
    if key_down( K_RIGHT ) then alien.dx += alien.accel.x;
    if key_down( K_LEFT ) then alien.dx -= alien.accel.x;
    if key_down( K_UP ) then alien.dy -= alien.accel.y;
    if key_down( k_down ) then alien.dy += alien.accel.y * 1.50;
    key_clearstate;

    { speed checking }
    if abs(alien.dx) > maxdx then alien.dx := sign( alien.dx ) * maxdx;
    if abs(alien.dy) > maxdy then alien.dy := sign( alien.dy ) * maxdy;

    { bounds checking }
    if alien.x < 0 then begin alien.x := 0; alien.dx := 0 end;
    if alien.x > 750 then begin alien.x := 750; alien.dx := 0 end;
    if alien.y < 0 then begin alien.y := 0; alien.dy := 0 end;
    if alien.y > 550 then begin alien.y := 550; alien.dy := 0 end;

    alien.x += alien.dx * dt / maxfps;
    alien.y += alien.dy * dt / maxfps;
    alien.dy += gravity;
    alien.dx *= 1 - friction;

    sleep( naplen );
  end;

  procedure render;
  begin
    asprite2d_Draw( spritesheet, alien.x, alien.y, 50, 50, floor((alien.dx / maxdx) * 20), 10 );
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

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
  zgl_primitives_2d,
  zgl_camera_2d,
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
    w, h   : integer;
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
  chunkw = 50;
  chunks = 128;

  { palette }
  black = $ff000000;
  rgb_land_a = black + $663300;
  rgb_land_b = black + $cc6600;
  rgb_squid_color = black + $d4145a;
  rgb_squid_shade = black + $9e005d;


var
  spritesheet : texture;
  alien : sprite;
  landscape : array[ -chunks div 2 .. chunks div 2 - 1 ] of byte;
  camera : zglPCamera2D;

  function clamped( var n : single; const min, max : single ) : boolean;
  begin
    result := true;
    if n < min then n := min
    else if n > max then n := max
    else result := false
  end;

  procedure init;
    var i : Integer;
  begin
    spritesheet := tex_LoadFromFile( assetdir + '/invaders.png' );
    tex_SetFrameSize( spritesheet, 50, 50 );
    alien.w := 50; alien.h := 50;
    alien.accel.x := 0.50;
    alien.accel.y := 0.25;
    for i := low( landscape ) to high( landscape ) do
    begin
      landscape[ i ] := 45 + 5 * random( 8 );
    end;
    New( camera );
    cam2d_init( camera^ );
  end;

  procedure update( dt : double );
  begin
    { handle keyboard }
    if key_down( K_RIGHT ) then alien.dx += alien.accel.x;
    if key_down( K_LEFT ) then alien.dx -= alien.accel.x;
    if key_down( K_UP ) then alien.dy -= alien.accel.y;
    if key_down( k_down ) then alien.dy += alien.accel.y * 1.50;
    key_clearstate;

    { speed checking }
    if abs(alien.dx) > maxdx then alien.dx := sign( alien.dx ) * maxdx;
    if abs(alien.dy) > maxdy then alien.dy := sign( alien.dy ) * maxdy;
    alien.x += alien.dx * dt / maxfps;
    alien.y += alien.dy * dt / maxfps;

    { external forces }
    alien.dy += gravity;
    alien.dx *= 1 - friction;

    { bounds checking }
    if clamped( alien.x,
                low(landscape) * chunkw,
                high(landscape) * chunkw - alien.w )
       then  alien.dx := 0;
    if clamped( alien.y, 100, scrHeight - 150 )  { leave room for hud , ground }
       then alien.dy := 0;

    { limit frames per second }
    sleep( naplen );
  end;

  procedure render_hud;
    const width = chunks * 2; height = 50; ypos = 15;
    var xpos : integer;
  begin
    cam2d_set( @constCamera2D );

    { draw  the map }
    xpos := ( scrWidth - width ) div 2;
    pr2d_rect( xpos -2, ypos-2, width + 4, height + 4, rgb_squid_shade, 255, PR2D_FILL );
    pr2d_Rect( xpos, ypos, width, height, black, 255, PR2D_FILL );

    { draw the alien on the map }
    { the *2 is because we have 2pixels per landscape chunk }
    pr2d_rect( xpos + 2 * ( high( landscape ) + floor( alien.x / chunkw )),
               ypos + floor( alien.y / scrHeight * height ),
               4, 4, rgb_squid_color, 255, PR2D_FILL );

  end;

  procedure render_cam;
    var i : integer; color : longword;
  begin
    camera^.x := alien.x - scrWidth div 2 ;
    cam2d_Set( camera );

    { draw the alien }
    asprite2d_Draw( spritesheet, alien.x, alien.y, 50, 50,
                    floor((alien.dx / maxdx) * 20), 10 );

    { draw the terrain }
    for i := low( landscape ) to high( landscape ) do
    begin
       if odd( i ) then color := rgb_land_a else color := rgb_land_b;
       pr2d_rect( i * chunkw, scrHeight - landscape[ i ],
                  chunkw, landscape[ i ], color,  255, PR2D_FILL );
    end
  end;

  procedure render;
  begin
    render_hud;
    render_cam;
  end;

begin
  wnd_SetCaption( 'hello world!' );

  scr_SetOptions( zgl_get( DESKTOP_WIDTH ), zgl_get( DESKTOP_HEIGHT ),
    REFRESH_DEFAULT,
    {fullscreen=} True,
    {vsync=} False );
  zgl_reg( sys_load, @init );
  zgl_reg( sys_update, @update );
  zgl_reg( sys_draw, @render );
  zgl_init;
end.

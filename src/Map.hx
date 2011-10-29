package ;

import Html5Dom;
import utils.js.MutableImage;
import webgl.math.Mat4;
import webgl.sprites.Sprite;
import webgl.textures.RenderTarget2D;
import webgl.textures.Texture2D;

/**
 * ...
 * @author MikeC
 */

class Map 
{
	public var terrain : Sprite;
	
	public var gl:WebGLRenderingContext;	
	public var explSprite : Sprite;
	public var width : Int;
	public var height : Int;
	
	public function new(gl:WebGLRenderingContext, whenLoaded:Void->Void) 
	{
		this.gl = gl;
		
		terrain = new Sprite(gl);
		
		var rt = new RenderTarget2D(gl);
		rt.load('assets/fg03.png', gl.RGBA, function(t) { rt.setupFBO(); whenLoaded(); } );
		terrain.texture = rt;			
				
		//terrain = new MutableImage();
		//terrain.load('assets/test03_destr.png');
		
		explSprite = new Sprite(gl);
		explSprite.texture = new Texture2D(gl);
		explSprite.texture.load("assets/explosion128.png", gl.RGBA);
	}
	
	public function writeExplosion(x:Float, y:Float) : Void
	{
		var rt : RenderTarget2D = cast terrain.texture;
		
		explSprite.x = x - (rt.width / 2) - (explSprite.texture.width / 2);
		explSprite.y = (rt.height / 2) - y - (explSprite.texture.height / 2);
		
		var p = new Mat4();
		p.ortho(rt.width / - 2, rt.width / 2, rt.height / 2, rt.height / - 2, -10000, 10000);		
		explSprite.perspective = p;
		
		// Setup special plenging
		gl.blendEquation(gl.FUNC_REVERSE_SUBTRACT);
		
		// Render
		gl.enable(gl.BLEND);
		gl.viewport(0, 0, rt.width, rt.height);
		rt.bind();		
		explSprite.render();
		rt.unbind();
		gl.disable(gl.BLEND);	
		
		// Return things back to how they were
		gl.blendFunc(gl.SRC_ALPHA, gl.ONE);
		gl.blendEquation(gl.FUNC_ADD);
	}
	
}
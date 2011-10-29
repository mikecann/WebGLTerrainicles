package ;

import Html5Dom;
import js.Lib;
import shaders.RenderPointsShader;
import shaders.UpdatePositionsShader;
import shaders.UpdateVelocitiesShader;
import utils.ColorConverter;
import utils.js.MutableImage;
import webgl.geom.PointCloud2D;
import webgl.geom.FullscreenQuad;
import webgl.geom.PointCloud2D;
import webgl.math.Mat4;
import webgl.sprites.Sprite;
import webgl.textures.DoubleBufferedRenderTarget2D;
import webgl.textures.RenderTarget2D;
import webgl.textures.Texture2D;

/**
 * ...
 * @author 
 */

class GPUParticles2 
{			
	public var gl : WebGLRenderingContext;	
	
	public var particlesManger : ParticlesManager;
	public var canvasManager : CanvasManager;
	public var map : Map;	
	
	private var perspective : Mat4;
	private var isReady : Bool;
	
	public function new(gl:WebGLRenderingContext) 
	{
		this.gl = gl;			
		
		isReady = false;
		
		perspective = new Mat4();
		canvasManager = new CanvasManager(this);							
		map = new Map(gl, onMapLoaded);			
		particlesManger = new ParticlesManager(gl);
		particlesManger.terrainTexture = map.terrain.texture;
				
		reset();		
	}	
	
	private function onMapLoaded():Void 
	{
		isReady = true;
	}
	
	public function reset() : Void
	{				
		particlesManger.reset();		
		
		var parts : RGB = ColorConverter.toRGB(0xfdf3cb);			
		gl.clearColor(parts.r, parts.g, parts.b, 1);
	}	
	
	public function update(delta:Float):Void 
	{		
		if(isReady) particlesManger.update(delta);
		
		// Render
		drawScene(delta);		
	}	
	
	private function drawScene(delta:Float)
	{	
		// Set the viewport back to the full canvas size and clear
		gl.viewport(0, 0,  Std.int(canvasManager.canvas.width),  Std.int(canvasManager.canvas.height));
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);	
		
		// Setup perspective
		perspective.reset();
		perspective.ortho(canvasManager.canvas.width / - 2, canvasManager.canvas.width / 2, canvasManager.canvas.height / 2, canvasManager.canvas.height / - 2, -10000, 10000);
		particlesManger.perspective = perspective;
		map.terrain.perspective = perspective;
		
		// Setup the positions
		particlesManger.x = canvasManager.translateX;
		particlesManger.y = canvasManager.translateY;
		map.terrain.x = canvasManager.translateX;	
		map.terrain.y = canvasManager.translateY;			
	
		// Render the bits
		gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
		gl.enable(gl.BLEND);	
		map.terrain.render();		
		particlesManger.render();			
		gl.disable(gl.BLEND);	
		
		//explSprite.render();
		//explSprite.x = 200;
		//explSprite.y = 200;
		//explSprite.perspective = perspective;
		
	}	
}
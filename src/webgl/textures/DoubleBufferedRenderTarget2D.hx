package webgl.textures;

import Html5Dom;

/**
 * ...
 * @author MikeCann
 */

class DoubleBufferedRenderTarget2D
{
	public var bufferA : RenderTarget2D;
	public var bufferB : RenderTarget2D;
	public var front:RenderTarget2D;
	public var back:RenderTarget2D;
	
	private var gl : WebGLRenderingContext;
	
	public function new(gl:WebGLRenderingContext)
	{
		this.gl = gl;
		init();
	}
	
	public function init() : Void
	{
		bufferA = new RenderTarget2D(gl);
		bufferB = new RenderTarget2D(gl);	
		front = bufferA;
		back = bufferB;
	}
	
	public function swap():Void 
	{
		var tmp = front;
		front = back;
		back = tmp;
	}
	
	public function setupFBO():Void 
	{
		bufferA.setupFBO();
		bufferB.setupFBO();
	}
		
}
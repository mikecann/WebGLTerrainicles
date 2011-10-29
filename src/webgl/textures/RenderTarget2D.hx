package webgl.textures;

import Html5Dom;

/**
 * ...
 * @author MikeCann
 */

class RenderTarget2D extends Texture2D
{		
	public var frameBuffer(default, null) : WebGLFramebuffer;
	public var renderBuffer(default, null) : WebGLRenderbuffer;
	
	public function new(gl:WebGLRenderingContext) 
	{		
		super(gl);
	}		
	
	public function setupFBO():Void 
	{
		frameBuffer = gl.createFramebuffer();
		gl.bindFramebuffer(gl.FRAMEBUFFER, frameBuffer);
		gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture, 0);
		
		if( gl.checkFramebufferStatus(gl.FRAMEBUFFER) != gl.FRAMEBUFFER_COMPLETE)
			trace("cannot set FLOAT as the color attachment to an FBO");
			
		//renderBuffer = gl.createRenderbuffer();
        //gl.bindRenderbuffer(gl.RENDERBUFFER, renderBuffer);		
        //gl.renderbufferStorage(gl.RENDERBUFFER, gl.RGB, width, height);	        
		
		/*gl.bindTexture(gl.TEXTURE_2D, texture);
		
		frameBuffer = gl.createFramebuffer();
		gl.bindFramebuffer(gl.FRAMEBUFFER, frameBuffer);
		gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture, 0);
		
		renderBuffer = gl.createRenderbuffer();
        gl.bindRenderbuffer(gl.RENDERBUFFER, renderBuffer);		
        gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, width, height);	        
		
		gl.bindTexture(gl.TEXTURE_2D, null);
        gl.bindRenderbuffer(gl.RENDERBUFFER, null);
        gl.bindFramebuffer(gl.FRAMEBUFFER, null);*/
	}
	
	public function bind() : Void
	{
		gl.bindFramebuffer(gl.FRAMEBUFFER, frameBuffer);
		//gl.bindRenderbuffer(gl.RENDERBUFFER, renderBuffer);
		//gl.viewport(0, 0, width, height);
		//gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
	}
	
	public function unbind() : Void
	{
		gl.bindFramebuffer(gl.FRAMEBUFFER, null);
		//gl.bindRenderbuffer(gl.RENDERBUFFER, null);
	}
	
	
}
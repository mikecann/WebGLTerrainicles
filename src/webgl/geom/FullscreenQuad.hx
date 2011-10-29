package webgl.geom;

import Html5Dom;
import webgl.math.Mat4;

/**
 * ...
 * @author MikeCann
 */

class FullscreenQuad
{	
	// Publics
	public var vertexBuffer : WebGLBuffer;
	public var texCoordBuffer : WebGLBuffer;
	
	// Privates
	private var gl : WebGLRenderingContext;
	
	public function new(gl:WebGLRenderingContext)
	{
		this.gl = gl;
		init();
	}
	
	public function init() : Void
	{
		// Create the vertex buffer
        vertexBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 0, 1, -1, 0, -1, 1, 0, 1, 1, 0 ]), gl.STATIC_DRAW);
        vertexBuffer.itemSize = 3;
        vertexBuffer.numItems = 4;
		
		// Create the texture buffer
		texCoordBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([ 0, 0, 1, 0, 0, 1, 1, 1]), gl.STATIC_DRAW);
        texCoordBuffer.itemSize = 2;
        texCoordBuffer.numItems = 4;
	}
	
	public function render() : Void
	{		        
		// Finally draw
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
        gl.drawArrays(gl.TRIANGLE_STRIP, 0, vertexBuffer.numItems);
	}
	
}
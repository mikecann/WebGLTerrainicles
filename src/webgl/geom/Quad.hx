package webgl.geom;

import Html5Dom;

/**
 * ...
 * @author 
 */

class Quad 
{
	// Publics
	public var vertexBuffer : WebGLBuffer;
	public var texCoordBuffer : WebGLBuffer;
	public var width : Float;
	public var height : Float;	
	
	// Privates
	private var gl : WebGLRenderingContext;
	
	public function new(gl:WebGLRenderingContext)
	{
		this.gl = gl;
		width = 2048;
		height = 500;
		init();
	}
	
	public function init() : Void
	{
		var hw = width / 2;
		var hh = height / 2;
		
		// Create the vertex buffer
        vertexBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 0, 1, -1, 0, -1, 1, 0, 1, 1, 0 ]), gl.STATIC_DRAW);
        //gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-hw, -hh, 0, hh, -hw, 0, -hw, hh, 0, hh, hw, 0 ]), gl.STATIC_DRAW);
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
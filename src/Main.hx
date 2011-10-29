package ;

import Html5Dom;
import haxe.Timer;
import js.Lib;
import js.Dom;
import js.JQuery;
import utils.ConsoleTracing;
import utils.js.Framerate;
import utils.RequestAnimationFrame;
import webgl.textures.Texture2D;

/**
 * ...
 * @author MikeCann
 */

class Main 
{		
	// Privates
	inline private var gl(default, null) : WebGLRenderingContext;
	
	public var canvas : HTMLCanvasElement;		
	public var gpuParticles2 : GPUParticles2;	
	public var framerate : Framerate;
	public var gui : GUIManager;
	
	private var _lastTime : Float;
	
	public function new()
	{			
		Lib.window.onload = onWindowLoaded;
	}
	
	private function onWindowLoaded(e:Dynamic):Void 
	{		
		canvas = cast Lib.document.getElementById("canvas");
		if (!setupGL()) return;
		
		framerate = new Framerate();		
		gpuParticles2 = new GPUParticles2(gl);		
		gui = new GUIManager(this);
		
		_lastTime =  Date.now().getTime();
		tick();
	}
	
	private function setupGL() : Bool
	{
		try	{ gl = canvas.getContext("experimental-webgl"); } catch (e:DOMError){}					
		if ( gl == null) { trace("Unable to initialize WebGL. Your browser may not support it."); }		
		var ext = gl.getExtension("OES_texture_float");
		if ( !ext ) { Lib.alert("Your browser does not support OES_texture_float extension"); return false; }
		if (gl.getParameter(gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS) == 0) { Lib.alert("Your browser does not support Vertex texture"); return false; }	
		return true;
	}
	
	private function tick() 
	{
		RequestAnimationFrame.request(tick);	
		var now : Float =  Date.now().getTime();
		var delta = now - _lastTime;
		gpuParticles2.update(delta);	
		framerate.inc();	
		_lastTime = now;
	}
	
	static function main() 
	{
		ConsoleTracing.setRedirection();
		new Main();
	}
	
}
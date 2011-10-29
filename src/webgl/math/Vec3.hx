package webgl.math;

/**
 * ...
 * @author MikeCann
 */

class Vec3 
{
	public var x : Float;
	public var y : Float;
	public var z : Float;
	
	public function new(x:Float, y:Float, z:Float) 
	{
		this.x = x; this.y = y; this.z = z;
	}

	// Cross product, this = a x b.
	public function cross2(a:Vec3, b:Vec3) : Vec3
	{
		var ax = a.x, ay = a.y, az = a.z,
		bx = b.x, by = b.y, bz = b.z;

		this.x = ay * bz - az * by;
		this.y = az * bx - ax * bz;
		this.z = ax * by - ay * bx;

		return this;
	}

	// Cross product, this = this x b.
	public function cross(b:Vec3) : Vec3
	{
		return this.cross2(this, b);
	}

	// Returns the dot product, this . b.
	public function dot(b:Vec3) : Float
	{
		return this.x * b.x + this.y * b.y + this.z * b.z;
	}

	// Add two Vec3s, this = a + b.
	public function add2(a:Vec3, b:Vec3) : Vec3
	{
		this.x = a.x + b.x;
		this.y = a.y + b.y;
		this.z = a.z + b.z;

		return this;
	}

	function added2(a:Vec3, b:Vec3) : Vec3
	{
		return new Vec3(a.x + b.x,
		a.y + b.y,
		a.z + b.z);
	}

	// Add a Vec3, this = this + b.
	public function add(b:Vec3) : Vec3
	{
		return this.add2(this, b);
	}

	public function added(b:Vec3) : Vec3
	{
		return this.added2(this, b);
	}

	// Subtract two Vec3s, this = a - b.
	public function sub2(a:Vec3, b:Vec3) : Vec3
	{
		this.x = a.x - b.x;
		this.y = a.y - b.y;
		this.z = a.z - b.z;

		return this;
	}

	public function subbed2(a:Vec3, b:Vec3) : Vec3
	{
		return new Vec3(a.x - b.x,
		a.y - b.y,
		a.z - b.z);
	}

	// Subtract another Vec3, this = this - b.
	public function sub(b:Vec3) : Vec3
	{
		return this.sub2(this, b);
	}

	public function subbed(b:Vec3) : Vec3
	{
		return this.subbed2(this, b);
	}

	// Multiply by a scalar.
	public function scale(s:Float) : Vec3
	{
		this.x *= s; this.y *= s; this.z *= s;

		return this;
	}

	public function scaled(s:Float) : Vec3
	{
		return new Vec3(this.x * s, this.y * s, this.z * s);
	}

	// Interpolate between this and another Vec3 |b|, based on |t|.
	public function lerp(b, t) : Vec3
	{
		this.x = this.x + (b.x-this.x)*t;
		this.y = this.y + (b.y-this.y)*t;
		this.z = this.z + (b.z-this.z)*t;

		return this;
	}

	// Magnitude (length).
	public function length() : Float
	{
		return Math.sqrt(x*x + y*y + z*z);
	}

	// Magnitude squared.
	public function lengthSquared() : Float
	{
		return x*x + y*y + z*z;
	}

	// Normalize, scaling so the magnitude is 1.  Invalid for a zero vector.
	public function normalize() : Vec3
	{
		return this.scale(1/this.length());
	}

	public function normalized() : Vec3
	{
		return this.dup().normalize();
	}

	public function dup() : Vec3
	{
		return new Vec3(this.x, this.y, this.z);
	}

	public function debugString() : String
	{
		return 'x: ' + this.x + ' y: ' + this.y + ' z: ' + this.z;
	} 
	
}
package webgl.math;

import Html5Dom;

/**
 * ...
 * @author MikeCann
 */

class Mat4 
{
	private var a11 : Float;
	private var a12 : Float;
	private var a13 : Float;
	private var a14 : Float;
	private var a21 : Float;
	private var a22 : Float;
	private var a23 : Float;
	private var a24 : Float;
	private var a31 : Float;
	private var a32 : Float;
	private var a33 : Float;
	private var a34 : Float;
	private var a41 : Float;
	private var a42 : Float;
	private var a43 : Float;
	private var a44 : Float;
	

	// This represents an affine 4x4 matrix, using mathematical notation,
	// numbered (starting from 1) as aij, where i is the row and j is the column.
	//   a11 a12 a13 a14
	//   a21 a22 a23 a24
	//   a31 a32 a33 a34
	//   a41 a42 a43 a44
	//
	// Almost all operations are multiplies to the current matrix, and happen
	// in place.  You can use dup() to return a copy.
	//
	// Most operations return this to support chaining.
	//
	// It's common to use toFloat32Array to get a Float32Array in OpenGL (column
	// major) memory ordering.  NOTE: The code tries to be explicit about whether
	// things are row major or column major, but remember that GLSL works in
	// column major ordering, and PreGL generally uses row major ordering.
	public function new() 
	{
		reset();
	}

	// Set the full 16 elements of the 4x4 matrix, arguments in row major order.
	// The elements are specified in row major order.  TODO(deanm): set4x4c.
	public function set4x4r(a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44) :Mat4
	{
		this.a11 = a11; this.a12 = a12; this.a13 = a13; this.a14 = a14;
		this.a21 = a21; this.a22 = a22; this.a23 = a23; this.a24 = a24;
		this.a31 = a31; this.a32 = a32; this.a33 = a33; this.a34 = a34;
		this.a41 = a41; this.a42 = a42; this.a43 = a43; this.a44 = a44;
		return this;
	}

	// Reset the transform to the identity matrix.
	public function reset() :Mat4
	{
		this.set4x4r(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
		return this;
	}

	// Matrix multiply this = a * b
	public function mult2(a:Mat4, b:Mat4) :Mat4
	{
		var a11 = a.a11, a12 = a.a12, a13 = a.a13, a14 = a.a14,
		a21 = a.a21, a22 = a.a22, a23 = a.a23, a24 = a.a24,
		a31 = a.a31, a32 = a.a32, a33 = a.a33, a34 = a.a34,
		a41 = a.a41, a42 = a.a42, a43 = a.a43, a44 = a.a44;
		var b11 = b.a11, b12 = b.a12, b13 = b.a13, b14 = b.a14,
		b21 = b.a21, b22 = b.a22, b23 = b.a23, b24 = b.a24,
		b31 = b.a31, b32 = b.a32, b33 = b.a33, b34 = b.a34,
		b41 = b.a41, b42 = b.a42, b43 = b.a43, b44 = b.a44;

		this.a11 = a11*b11 + a12*b21 + a13*b31 + a14*b41;
		this.a12 = a11*b12 + a12*b22 + a13*b32 + a14*b42;
		this.a13 = a11*b13 + a12*b23 + a13*b33 + a14*b43;
		this.a14 = a11*b14 + a12*b24 + a13*b34 + a14*b44;
		this.a21 = a21*b11 + a22*b21 + a23*b31 + a24*b41;
		this.a22 = a21*b12 + a22*b22 + a23*b32 + a24*b42;
		this.a23 = a21*b13 + a22*b23 + a23*b33 + a24*b43;
		this.a24 = a21*b14 + a22*b24 + a23*b34 + a24*b44;
		this.a31 = a31*b11 + a32*b21 + a33*b31 + a34*b41;
		this.a32 = a31*b12 + a32*b22 + a33*b32 + a34*b42;
		this.a33 = a31*b13 + a32*b23 + a33*b33 + a34*b43;
		this.a34 = a31*b14 + a32*b24 + a33*b34 + a34*b44;
		this.a41 = a41*b11 + a42*b21 + a43*b31 + a44*b41;
		this.a42 = a41*b12 + a42*b22 + a43*b32 + a44*b42;
		this.a43 = a41*b13 + a42*b23 + a43*b33 + a44*b43;
		this.a44 = a41*b14 + a42*b24 + a43*b34 + a44*b44;

		return this;
	}

	// Matrix multiply this = this * b
	public function mult(b:Mat4) :Mat4
	{
		return this.mult2(this, b);
	}

	// Multiply the current matrix by 16 elements that would compose a Mat4
	// object, but saving on creating the object.  this = this * b.
	// The elements are specific in row major order.  TODO(deanm): mult4x4c.
	// TODO(deanm): It's a shame to duplicate the multiplication code.
	public function mult4x4r(b11:Float, b12:Float, b13:Float, b14:Float, b21:Float, b22:Float, b23:Float, b24:Float, b31:Float, b32:Float, b33:Float, b34:Float, b41:Float, b42:Float, b43:Float, b44:Float) 
	{
		var a11 = this.a11, a12 = this.a12, a13 = this.a13, a14 = this.a14,
		a21 = this.a21, a22 = this.a22, a23 = this.a23, a24 = this.a24,
		a31 = this.a31, a32 = this.a32, a33 = this.a33, a34 = this.a34,
		a41 = this.a41, a42 = this.a42, a43 = this.a43, a44 = this.a44;

		this.a11 = a11*b11 + a12*b21 + a13*b31 + a14*b41;
		this.a12 = a11*b12 + a12*b22 + a13*b32 + a14*b42;
		this.a13 = a11*b13 + a12*b23 + a13*b33 + a14*b43;
		this.a14 = a11*b14 + a12*b24 + a13*b34 + a14*b44;
		this.a21 = a21*b11 + a22*b21 + a23*b31 + a24*b41;
		this.a22 = a21*b12 + a22*b22 + a23*b32 + a24*b42;
		this.a23 = a21*b13 + a22*b23 + a23*b33 + a24*b43;
		this.a24 = a21*b14 + a22*b24 + a23*b34 + a24*b44;
		this.a31 = a31*b11 + a32*b21 + a33*b31 + a34*b41;
		this.a32 = a31*b12 + a32*b22 + a33*b32 + a34*b42;
		this.a33 = a31*b13 + a32*b23 + a33*b33 + a34*b43;
		this.a34 = a31*b14 + a32*b24 + a33*b34 + a34*b44;
		this.a41 = a41*b11 + a42*b21 + a43*b31 + a44*b41;
		this.a42 = a41*b12 + a42*b22 + a43*b32 + a44*b42;
		this.a43 = a41*b13 + a42*b23 + a43*b33 + a44*b43;
		this.a44 = a41*b14 + a42*b24 + a43*b34 + a44*b44;

		return this;
	}

	// TODO(deanm): Some sort of mat3x3.  There are two ways you could do it
	// though, just multiplying the 3x3 portions of the 4x4 matrix, or doing a
	// 4x4 multiply with the last row/column implied to be 0, 0, 0, 1.  This
	// keeps true to the original matrix even if it's last row is not 0, 0, 0, 1.

	// IN RADIANS, not in degrees like OpenGL.  Rotate about x, y, z.
	// The caller must supply a x, y, z as a unit vector.
	public function rotate(theta, x, y, z) 
	{
		// http://www.cs.rutgers.edu/~decarlo/428/gl_man/rotate.html
		var s = Math.sin(theta);
		var c = Math.cos(theta);
		this.mult4x4r(
		x*x*(1-c)+c, x*y*(1-c)-z*s, x*z*(1-c)+y*s, 0,
		y*x*(1-c)+z*s,   y*y*(1-c)+c, y*z*(1-c)-x*s, 0,
		x*z*(1-c)-y*s, y*z*(1-c)+x*s,   z*z*(1-c)+c, 0,
		0,             0,             0, 1);

		return this;
	}

	// Multiply by a translation of x, y, and z.
	public function translate(dx:Float, dy:Float, dz:Float) 
	{
		// TODO(deanm): Special case the multiply since most goes unchanged.
		this.mult4x4r(1, 0, 0, dx,
		0, 1, 0, dy,
		0, 0, 1, dz,
		0, 0, 0,  1);

		return this;
	}

	// Multiply by a scale of x, y, and z.
	public function scale(sx, sy, sz) 
	{
		// TODO(deanm): Special case the multiply since most goes unchanged.
		this.mult4x4r(sx,  0,  0, 0,
		0, sy,  0, 0,
		0,  0, sz, 0,
		0,  0,  0, 1);

		return this;
	}

	// Multiply by a look at matrix, computed from the eye, center, and up points.
	public function lookAt(ex, ey, ez, cx, cy, cz, ux, uy, uz) 
	{
		var z = new Vec3(ex - cx, ey - cy, ez - cz).normalize();
		var x = new Vec3(ux, uy, uz).cross(z).normalize();
		var y = z.dup().cross(x).normalize();
		// The new axis basis is formed as row vectors since we are transforming
		// the coordinate system (alias not alibi).
		this.mult4x4r(x.x, x.y, x.z, 0,
		y.x, y.y, y.z, 0,
		z.x, z.y, z.z, 0,
		0,   0,   0, 1);
		this.translate(-ex, -ey, -ez);

		return this;
	}

	// Multiply by a frustum matrix computed from left, right, bottom, top,
	// near, and far.
	public function frustum(l, r, b, t, n, f) 
	{
		this.mult4x4r(
		(n+n)/(r-l),           0, (r+l)/(r-l),             0,
		0, (n+n)/(t-b), (t+b)/(t-b),             0,
		0,           0, (f+n)/(n-f), (2*f*n)/(n-f),
		0,           0,          -1,             0);

		return this;
	}

	// Multiply by a perspective matrix, computed from the field of view, aspect
	// ratio, and the z near and far planes.
	public function perspective(fovy:Float, aspect:Float, znear:Float, zfar:Float)
	{
		// This could also be done reusing the frustum calculation:
		// var ymax = znear * Math.tan(fovy * kPI / 360.0);
		// var ymin = -ymax;
		//
		// var xmin = ymin * aspect;
		// var xmax = ymax * aspect;
		//
		// return makeFrustumAffine(xmin, xmax, ymin, ymax, znear, zfar);

		var f = 1.0 / Math.tan(fovy * Math.PI / 360.0);
		this.mult4x4r(
		f/aspect, 0,                         0,                         0,
		0, f,                         0,                         0,
		0, 0, (zfar+znear)/(znear-zfar), 2*znear*zfar/(znear-zfar),
		0, 0,                        -1,                         0);

		return this;
	}
	
	// Multiply by a orthographic matrix, computed from the clipping planes.
	public function ortho(left:Float, right:Float, bottom:Float, top:Float, nearVal:Float, farVal:Float) 
	{
		this.mult4x4r(2/(right-left),        0,        0,  (right+left)/(left-right),
		0,  2/(top-bottom),        0,  (top+bottom)/(bottom-top),
		0,        0,  2/(nearVal-farVal),  (farVal+nearVal)/(nearVal-farVal),
		0,        0,        0,            1);

		return this;
	}

	// Invert the matrix.  The matrix must be invertable.
	public function invert() 
	{
		// Based on the math at:
		//   http://www.geometrictools.com/LibMathematics/Algebra/Wm5Matrix4.inl
		var  x0 = this.a11,  x1 = this.a12,  x2 = this.a13,  x3 = this.a14,
		x4 = this.a21,  x5 = this.a22,  x6 = this.a23,  x7 = this.a24,
		x8 = this.a31,  x9 = this.a32, x10 = this.a33, x11 = this.a34,
		x12 = this.a41, x13 = this.a42, x14 = this.a43, x15 = this.a44;

		var a0 = x0*x5 - x1*x4,
		a1 = x0*x6 - x2*x4,
		a2 = x0*x7 - x3*x4,
		a3 = x1*x6 - x2*x5,
		a4 = x1*x7 - x3*x5,
		a5 = x2*x7 - x3*x6,
		b0 = x8*x13 - x9*x12,
		b1 = x8*x14 - x10*x12,
		b2 = x8*x15 - x11*x12,
		b3 = x9*x14 - x10*x13,
		b4 = x9*x15 - x11*x13,
		b5 = x10*x15 - x11*x14;

		// TODO(deanm): These terms aren't reused, so get rid of the temporaries.
		var invdet = 1 / (a0*b5 - a1*b4 + a2*b3 + a3*b2 - a4*b1 + a5*b0);

		this.a11 = ( x5*b5 - x6*b4 + x7*b3) * invdet;
		this.a12 = (- x1*b5 + x2*b4 - x3*b3) * invdet;
		this.a13 = ( x13*a5 - x14*a4 + x15*a3) * invdet;
		this.a14 = (- x9*a5 + x10*a4 - x11*a3) * invdet;
		this.a21 = (- x4*b5 + x6*b2 - x7*b1) * invdet;
		this.a22 = ( x0*b5 - x2*b2 + x3*b1) * invdet;
		this.a23 = (- x12*a5 + x14*a2 - x15*a1) * invdet;
		this.a24 = ( x8*a5 - x10*a2 + x11*a1) * invdet;
		this.a31 = ( x4*b4 - x5*b2 + x7*b0) * invdet;
		this.a32 = (- x0*b4 + x1*b2 - x3*b0) * invdet;
		this.a33 = ( x12*a4 - x13*a2 + x15*a0) * invdet;
		this.a34 = (- x8*a4 + x9*a2 - x11*a0) * invdet;
		this.a41 = (- x4*b3 + x5*b1 - x6*b0) * invdet;
		this.a42 = ( x0*b3 - x1*b1 + x2*b0) * invdet;
		this.a43 = (- x12*a3 + x13*a1 - x14*a0) * invdet;
		this.a44 = ( x8*a3 - x9*a1 + x10*a0) * invdet;

		return this;
	}

	// Transpose the matrix, rows become columns and columns become rows.
	public function transpose() 
	{
		var a11 = this.a11, a12 = this.a12, a13 = this.a13, a14 = this.a14,
		a21 = this.a21, a22 = this.a22, a23 = this.a23, a24 = this.a24,
		a31 = this.a31, a32 = this.a32, a33 = this.a33, a34 = this.a34,
		a41 = this.a41, a42 = this.a42, a43 = this.a43, a44 = this.a44;

		this.a11 = a11; this.a12 = a21; this.a13 = a31; this.a14 = a41;
		this.a21 = a12; this.a22 = a22; this.a23 = a32; this.a24 = a42;
		this.a31 = a13; this.a32 = a23; this.a33 = a33; this.a34 = a43;
		this.a41 = a14; this.a42 = a24; this.a43 = a34; this.a44 = a44;

		return this;
	}

	// Multiply Vec3 |v| by the current matrix, returning a Vec3 of this * v.
	public function multVec3(v) 
	{
		var x = v.x, y = v.y, z = v.z;
		return new Vec3(this.a14 + this.a11*x + this.a12*y + this.a13*z,
		this.a24 + this.a21*x + this.a22*y + this.a23*z,
		this.a34 + this.a31*x + this.a32*y + this.a33*z);
	}

	// Multiply Vec4 |v| by the current matrix, returning a Vec4 of this * v.
	/*public function multVec4(v) 
	{
		var x = v.x, y = v.y, z = v.z, w = v.w;
		return new Vec4(this.a14*w + this.a11*x + this.a12*y + this.a13*z,
		this.a24*w + this.a21*x + this.a22*y + this.a23*z,
		this.a34*w + this.a31*x + this.a32*y + this.a33*z,
		this.a44*w + this.a41*x + this.a42*y + this.a43*z);
	}
*/
	public function dup()
	{
		var m = new Mat4();  // TODO(deanm): This could be better.
		m.set4x4r(this.a11, this.a12, this.a13, this.a14,
		this.a21, this.a22, this.a23, this.a24,
		this.a31, this.a32, this.a33, this.a34,
		this.a41, this.a42, this.a43, this.a44);
		return m;
	}

	public function toFloat32Array() 
	{
		return new Float32Array([this.a11, this.a21, this.a31, this.a41,
		this.a12, this.a22, this.a32, this.a42,
		this.a13, this.a23, this.a33, this.a43,
		this.a14, this.a24, this.a34, this.a44]);
	}
	
}
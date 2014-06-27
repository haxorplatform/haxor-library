(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
var HxOverrides = function() { }
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
var Std = function() { }
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
var StringTools = function() { }
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
var ValueType = { __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var haxe = {}
haxe.Timer = function() { }
haxe.Timer.stamp = function() {
	return new Date().getTime() / 1000;
}
var js = {}
js.Browser = function() { }
var thelab = {}
thelab.haxor = {}
thelab.haxor.core = {}
thelab.haxor.core.Console = function() { }
thelab.haxor.core.Console.get__console = function() {
	return thelab.haxor.core.Console.m_console;
}
thelab.haxor.core.Console.SetStyle = function(p_size,p_color,p_background,p_font) {
	if(p_font == null) p_font = "'Lucida Console', Monaco, monospace";
	if(p_size == null) p_size = "12px";
	p_color = p_color == null?thelab.haxor.math.Color.black:p_color;
	p_background = p_background == null?thelab.haxor.math.Color.empty:p_background;
	thelab.haxor.core.Console.m_style = "background-color: " + p_background.get_css() + "; font-size: " + p_size + "; color: " + p_color.get_css() + "; font-family: " + p_font + ";";
}
thelab.haxor.core.Console.LogImage = function(p_url,p_height) {
	var s = "background: transparent url(" + p_url + ") no-repeat; font-size: " + (p_height - 3) + "px;";
	thelab.haxor.core.Console.get__console().log("%c                                                                                                                                                            ",s);
}
thelab.haxor.core.Console.ClearStyle = function() {
	thelab.haxor.core.Console.m_style = "";
}
thelab.haxor.core.Console.Clear = function() {
	if(thelab.haxor.core.Console.get__console() == null) return;
	thelab.haxor.core.Console.get__console().clear();
}
thelab.haxor.core.Console.ProfileStart = function(p_msg) {
	if(thelab.haxor.core.Console.get__console() == null) return;
	thelab.haxor.core.Console.get__console().profile(p_msg);
}
thelab.haxor.core.Console.ProfileEnd = function(p_msg) {
	if(thelab.haxor.core.Console.get__console() == null) return;
	thelab.haxor.core.Console.get__console().profileEnd(p_msg);
}
thelab.haxor.core.Console.Log = function(p_msg,p_obj) {
	if(thelab.haxor.core.Console.get__console() == null) return;
	if(p_obj == null) p_obj = [];
	var s = thelab.haxor.core.Console.m_style;
	p_msg = "%c" + p_msg;
	switch(p_obj.length) {
	case 0:
		thelab.haxor.core.Console.get__console().log(p_msg,s);
		break;
	case 1:
		thelab.haxor.core.Console.get__console().log(p_msg,p_obj[0],s);
		break;
	case 2:
		thelab.haxor.core.Console.get__console().log(p_msg,p_obj[0],p_obj[1],s);
		break;
	case 3:
		thelab.haxor.core.Console.get__console().log(p_msg,p_obj[0],p_obj[1],p_obj[2],s);
		break;
	case 4:
		thelab.haxor.core.Console.get__console().log(p_msg,p_obj[0],p_obj[1],p_obj[2],p_obj[3],s);
		break;
	case 5:
		thelab.haxor.core.Console.get__console().log(p_msg,p_obj[0],p_obj[1],p_obj[2],p_obj[3],p_obj[4],s);
		break;
	}
}
thelab.haxor.core.Console.LogWarning = function(p_msg,p_obj) {
	if(thelab.haxor.core.Console.get__console() == null) return;
	if(p_obj == null) p_obj = [];
	switch(p_obj.length) {
	case 0:
		thelab.haxor.core.Console.get__console().warn(p_msg);
		break;
	case 1:
		thelab.haxor.core.Console.get__console().warn(p_msg,p_obj[0]);
		break;
	case 2:
		thelab.haxor.core.Console.get__console().warn(p_msg,p_obj[0],p_obj[1]);
		break;
	case 3:
		thelab.haxor.core.Console.get__console().warn(p_msg,p_obj[0],p_obj[1],p_obj[2]);
		break;
	case 4:
		thelab.haxor.core.Console.get__console().warn(p_msg,p_obj[0],p_obj[1],p_obj[2],p_obj[3]);
		break;
	case 5:
		thelab.haxor.core.Console.get__console().warn(p_msg,p_obj[0],p_obj[1],p_obj[2],p_obj[3],p_obj[4]);
		break;
	}
}
thelab.haxor.core.Console.LogError = function(p_msg) {
	if(thelab.haxor.core.Console.get__console() != null) thelab.haxor.core.Console.get__console().error(p_msg);
}
thelab.haxor.core.Console.StackTrace = function() {
	if(thelab.haxor.core.Console.get__console() != null) thelab.haxor.core.Console.get__console().trace();
}
thelab.haxor.core.Console.Breakpoint = function() {
	debugger;
}
thelab.haxor.math = {}
thelab.haxor.math.Color = function(p_r,p_g,p_b,p_a) {
	if(p_a == null) p_a = 1;
	if(p_b == null) p_b = 0;
	if(p_g == null) p_g = 0;
	if(p_r == null) p_r = 0;
	this.r = p_r;
	this.g = p_g;
	this.b = p_b;
	this.a = p_a;
};
thelab.haxor.math.Color.FromHex = function(p_hex) {
	var c = new thelab.haxor.math.Color();
	if(p_hex.length == 10) c.set_argb(Std.parseInt(p_hex)); else c.set_rgb(Std.parseInt(p_hex));
	return c;
}
thelab.haxor.math.Color.Lerp = function(a,b,r) {
	return new thelab.haxor.math.Color(thelab.haxor.math.Mathf.Lerp(a.r,b.r,r),thelab.haxor.math.Mathf.Lerp(a.g,b.g,r),thelab.haxor.math.Mathf.Lerp(a.b,b.b,r),thelab.haxor.math.Mathf.Lerp(a.a,b.a,r));
}
thelab.haxor.math.Color.prototype = {
	set_rgb: function(v) {
		this.r = (v >> 16 & 255) * thelab.haxor.math.Mathf.Byte2Float;
		this.g = (v >> 8 & 255) * thelab.haxor.math.Mathf.Byte2Float;
		this.b = (v & 255) * thelab.haxor.math.Mathf.Byte2Float;
		return v;
	}
	,get_rgb: function() {
		var rb = this.r * thelab.haxor.math.Mathf.Float2Byte;
		var gb = this.g * thelab.haxor.math.Mathf.Float2Byte;
		var bb = this.b * thelab.haxor.math.Mathf.Float2Byte;
		return rb << 16 | gb << 8 | bb;
	}
	,set_rgba: function(v) {
		this.r = (v >> 24 & 255) * thelab.haxor.math.Mathf.Byte2Float;
		this.g = (v >> 16 & 255) * thelab.haxor.math.Mathf.Byte2Float;
		this.b = (v >> 8 & 255) * thelab.haxor.math.Mathf.Byte2Float;
		this.a = (v & 255) * thelab.haxor.math.Mathf.Byte2Float;
		return v;
	}
	,get_rgba: function() {
		var rb = this.r * thelab.haxor.math.Mathf.Float2Byte;
		var gb = this.g * thelab.haxor.math.Mathf.Float2Byte;
		var bb = this.b * thelab.haxor.math.Mathf.Float2Byte;
		var ab = this.a * thelab.haxor.math.Mathf.Float2Byte;
		return rb << 24 | gb << 16 | bb << 8 | ab;
	}
	,get_css: function() {
		return "rgba(" + (this.r * 255 | 0) + "," + (this.g * 255 | 0) + "," + (this.b * 255 | 0) + "," + this.a + ")";
	}
	,set_argb: function(v) {
		this.a = (v >> 24 & 255) * thelab.haxor.math.Mathf.Byte2Float;
		this.g = (v >> 16 & 255) * thelab.haxor.math.Mathf.Byte2Float;
		this.b = (v >> 8 & 255) * thelab.haxor.math.Mathf.Byte2Float;
		this.r = (v & 255) * thelab.haxor.math.Mathf.Byte2Float;
		return v;
	}
	,get_argb: function() {
		var rb = this.r * thelab.haxor.math.Mathf.Float2Byte;
		var gb = this.g * thelab.haxor.math.Mathf.Float2Byte;
		var bb = this.b * thelab.haxor.math.Mathf.Float2Byte;
		var ab = this.a * thelab.haxor.math.Mathf.Float2Byte;
		return ab << 24 | rb << 16 | gb << 8 | bb;
	}
	,get_xyzw: function() {
		return new thelab.haxor.math.Vector4(this.r,this.g,this.b,this.a);
	}
	,get_xyz: function() {
		return new thelab.haxor.math.Vector3(this.r,this.g,this.b);
	}
	,get_clone: function() {
		return new thelab.haxor.math.Color(this.r,this.g,this.b,this.a);
	}
}
thelab.haxor.math.Mathf = function() { }
thelab.haxor.math.Mathf.IsPOT = function(p_v) {
	return p_v > 0 && (p_v & p_v - 1) == 0;
}
thelab.haxor.math.Mathf.NextPOT = function(p_v) {
	--p_v;
	p_v |= p_v >> 1;
	p_v |= p_v >> 2;
	p_v |= p_v >> 4;
	p_v |= p_v >> 8;
	p_v |= p_v >> 16;
	return ++p_v;
}
thelab.haxor.math.Mathf.Sign = function(p_a) {
	return p_a < 0?-1.0:1.0;
}
thelab.haxor.math.Mathf.SignInt = function(p_a) {
	return p_a < 0?-1:1;
}
thelab.haxor.math.Mathf.Abs = function(p_a) {
	return p_a < 0?-p_a:p_a;
}
thelab.haxor.math.Mathf.AbsInt = function(p_a) {
	return p_a < 0?-p_a:p_a;
}
thelab.haxor.math.Mathf.Clamp = function(p_v,p_a,p_b) {
	return p_v <= p_a?p_a:p_v >= p_b?p_b:p_v;
}
thelab.haxor.math.Mathf.Clamp01 = function(p_v) {
	return p_v <= 0.0?0.0:p_v >= 1.0?1.0:p_v;
}
thelab.haxor.math.Mathf.ClampInt = function(p_v,p_a,p_b) {
	return (p_v <= p_a?p_a:p_v >= p_b?p_b:p_v) | 0;
}
thelab.haxor.math.Mathf.Min = function(p_v) {
	if(p_v.length <= 0) return 0;
	if(p_v.length <= 1) return p_v[0];
	var m = p_v[0];
	var i = 0;
	var _g1 = 1, _g = p_v.length;
	while(_g1 < _g) {
		var i1 = _g1++;
		m = m > p_v[i1]?p_v[i1]:m;
	}
	return m;
}
thelab.haxor.math.Mathf.MinInt = function(p_v) {
	if(p_v.length <= 0) return 0;
	if(p_v.length <= 1) return p_v[0];
	var m = p_v[0];
	var i = 0;
	var _g1 = 1, _g = p_v.length;
	while(_g1 < _g) {
		var i1 = _g1++;
		m = m > p_v[i1]?p_v[i1]:m;
	}
	return m | 0;
}
thelab.haxor.math.Mathf.Max = function(p_v) {
	if(p_v.length <= 0) return 0;
	if(p_v.length <= 1) return p_v[0];
	var m = p_v[0];
	var i = 0;
	var _g1 = 1, _g = p_v.length;
	while(_g1 < _g) {
		var i1 = _g1++;
		m = m < p_v[i1]?p_v[i1]:m;
	}
	return m;
}
thelab.haxor.math.Mathf.MaxInt = function(p_v) {
	if(p_v.length <= 0) return 0;
	if(p_v.length <= 1) return p_v[0];
	var m = p_v[0];
	var i = 0;
	var _g1 = 1, _g = p_v.length;
	while(_g1 < _g) {
		var i1 = _g1++;
		m = m < p_v[i1]?p_v[i1]:m;
	}
	return m | 0;
}
thelab.haxor.math.Mathf.SinDeg = function(p_v) {
	return thelab.haxor.math.Mathf.Sin(p_v * thelab.haxor.math.Mathf.Deg2Rad);
}
thelab.haxor.math.Mathf.CosDeg = function(p_v) {
	return thelab.haxor.math.Mathf.Cos(p_v * thelab.haxor.math.Mathf.Deg2Rad);
}
thelab.haxor.math.Mathf.Floor = function(p_v) {
	return p_v | 0;
}
thelab.haxor.math.Mathf.Ceil = function(p_v) {
	return p_v + (p_v < 0?-0.9999999:0.9999999) | 0;
}
thelab.haxor.math.Mathf.Round = function(p_v) {
	return p_v + (p_v < 0?-0.5:0.5) | 0;
}
thelab.haxor.math.Mathf.RoundPlaces = function(p_v,p_decimal_places) {
	if(p_decimal_places == null) p_decimal_places = 2;
	var d = p_decimal_places * 10;
	return thelab.haxor.math.Mathf.Round(p_v * d) / d;
}
thelab.haxor.math.Mathf.Lerp = function(p_a,p_b,p_ratio) {
	return p_a + (p_b - p_a) * p_ratio;
}
thelab.haxor.math.Mathf.LerpInt = function(p_a,p_b,p_ratio) {
	return js.Boot.__cast(thelab.haxor.math.Mathf.Lerp(js.Boot.__cast(p_a , Float),js.Boot.__cast(p_b , Float),p_ratio) , Int);
}
thelab.haxor.math.Mathf.Frac = function(p_v) {
	return p_v - (p_v | 0);
}
thelab.haxor.math.Mathf.Loop = function(p_v,p_v0,p_v1) {
	var vv0 = Math.min(p_v0,p_v1);
	var vv1 = Math.max(p_v0,p_v1);
	var dv = vv1 - vv0;
	if(dv <= 0) return vv0;
	var n = (p_v - p_v0) / dv;
	var r = p_v < 0?1.0 - thelab.haxor.math.Mathf.Frac(n < 0?-n:n):n - (n | 0);
	return p_v0 + (p_v1 - p_v0) * r;
}
thelab.haxor.math.Mathf.Linear2Gamma = function(p_v) {
	return thelab.haxor.math.Mathf.Pow(p_v,2.2);
}
thelab.haxor.math.Mathf.Oscilate = function(p_v,p_v0,p_v1) {
	var w = -thelab.haxor.math.Mathf.Abs(thelab.haxor.math.Mathf.Loop(p_v - 1.0,-1.0,1.0)) + 1.0;
	return w + (p_v0 - w) * p_v1;
}
thelab.haxor.math.Mathf.WrapAngle = function(p_angle) {
	if(p_angle < 360.0) {
		if(p_angle > -360.0) return p_angle;
	}
	return thelab.haxor.math.Mathf.Frac((p_angle < 0?-p_angle:p_angle) / 360.0) * 360.0;
}
thelab.haxor.math.Matrix4 = function(p_m00,p_m01,p_m02,p_m03,p_m10,p_m11,p_m12,p_m13,p_m20,p_m21,p_m22,p_m23,p_m30,p_m31,p_m32,p_m33) {
	if(p_m33 == null) p_m33 = 0;
	if(p_m32 == null) p_m32 = 0;
	if(p_m31 == null) p_m31 = 0;
	if(p_m30 == null) p_m30 = 0;
	if(p_m23 == null) p_m23 = 0;
	if(p_m22 == null) p_m22 = 0;
	if(p_m21 == null) p_m21 = 0;
	if(p_m20 == null) p_m20 = 0;
	if(p_m13 == null) p_m13 = 0;
	if(p_m12 == null) p_m12 = 0;
	if(p_m11 == null) p_m11 = 0;
	if(p_m10 == null) p_m10 = 0;
	if(p_m03 == null) p_m03 = 0;
	if(p_m02 == null) p_m02 = 0;
	if(p_m01 == null) p_m01 = 0;
	if(p_m00 == null) p_m00 = 0;
	this.m = new Float32Array(16);
	this.m00 = p_m00;
	this.m01 = p_m01;
	this.m02 = p_m02;
	this.m03 = p_m03;
	this.m10 = p_m10;
	this.m11 = p_m11;
	this.m12 = p_m12;
	this.m13 = p_m13;
	this.m20 = p_m20;
	this.m21 = p_m21;
	this.m22 = p_m22;
	this.m23 = p_m23;
	this.m30 = p_m30;
	this.m31 = p_m31;
	this.m32 = p_m32;
	this.m33 = p_m33;
};
thelab.haxor.math.Matrix4.get_identity = function() {
	return new thelab.haxor.math.Matrix4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
}
thelab.haxor.math.Matrix4.Parse = function(p_data,p_delimiter) {
	if(p_delimiter == null) p_delimiter = " ";
	var tk = p_data.split(p_delimiter);
	var res = thelab.haxor.math.Matrix4.get_identity();
	var _g1 = 0, _g = tk.length;
	while(_g1 < _g) {
		var i = _g1++;
		var n = Std.parseFloat(StringTools.trim(tk[i]));
		res.SetIndex(i,n);
	}
	return res;
}
thelab.haxor.math.Matrix4.FromArray = function(p_array) {
	var res = new thelab.haxor.math.Matrix4();
	var _g1 = 0, _g = p_array.length;
	while(_g1 < _g) {
		var i = _g1++;
		res.SetIndex(i,p_array[i]);
	}
	return res;
}
thelab.haxor.math.Matrix4.TRS = function(p_position,p_rotation,p_scale,p_result) {
	var sx = p_scale == null?1.0:p_scale.x;
	var sy = p_scale == null?1.0:p_scale.y;
	var sz = p_scale == null?1.0:p_scale.z;
	var px = p_position.x;
	var py = p_position.y;
	var pz = p_position.z;
	var r = p_rotation.get_matrix();
	var l = p_result == null?thelab.haxor.math.Matrix4.get_identity():p_result;
	l.m00 = r.m00 * sx;
	l.m01 = r.m01 * sy;
	l.m02 = r.m02 * sz;
	l.m03 = px;
	l.m10 = r.m10 * sx;
	l.m11 = r.m11 * sy;
	l.m12 = r.m12 * sz;
	l.m13 = py;
	l.m20 = r.m20 * sx;
	l.m21 = r.m21 * sy;
	l.m22 = r.m22 * sz;
	l.m23 = pz;
	l.m30 = l.m31 = l.m32 = 0.0;
	l.m33 = 1.0;
	return l;
}
thelab.haxor.math.Matrix4.GetInverseTransform = function(p_matrix,p_result) {
	var result = p_result == null?thelab.haxor.math.Matrix4.get_identity():p_result;
	var m = p_matrix;
	var l0x = m.m00;
	var l0y = m.m01;
	var l0z = m.m02;
	var l0w = m.m03;
	var l1x = m.m10;
	var l1y = m.m11;
	var l1z = m.m12;
	var l1w = m.m13;
	var l2x = m.m20;
	var l2y = m.m21;
	var l2z = m.m22;
	var l2w = m.m23;
	var vl0 = Math.sqrt(l0x * l0x + l0y * l0y + l0z * l0z);
	var vl1 = Math.sqrt(l1x * l1x + l1y * l1y + l1z * l1z);
	var vl2 = Math.sqrt(l2x * l2x + l2y * l2y + l2z * l2z);
	var sx = (vl0 < 0?-vl0:vl0) <= 0.0001?0.0:1.0 / vl0;
	var sy = (vl1 < 0?-vl1:vl1) <= 0.0001?0.0:1.0 / vl1;
	var sz = (vl2 < 0?-vl2:vl2) <= 0.0001?0.0:1.0 / vl2;
	l0x *= sx;
	l0y *= sx;
	l0z *= sx;
	l1x *= sy;
	l1y *= sy;
	l1z *= sy;
	l2x *= sz;
	l2y *= sz;
	l2z *= sz;
	result.Set(sx * l0x,sx * l1x,sx * l2x,sx * (l0x * -l0w + l1x * -l1w + l2x * -l2w),sy * l0y,sy * l1y,sy * l2y,sy * (l0y * -l0w + l1y * -l1w + l2y * -l2w),sz * l0z,sz * l1z,sz * l2z,sz * (l0z * -l0w + l1z * -l1w + l2z * -l2w),0,0,0,1);
	return result;
}
thelab.haxor.math.Matrix4.LookRotation = function(p_forward,p_up) {
	return thelab.haxor.math.Matrix4.LookAt(thelab.haxor.math.Vector3.get_zero(),p_forward,p_up);
}
thelab.haxor.math.Matrix4.LookAt = function(p_from,p_at,p_up) {
	p_up = p_up == null?thelab.haxor.math.Vector3.get_up():p_up;
	var vz = p_at.get_clone().Sub(p_from).Normalize();
	var vx = thelab.haxor.math.Vector3.Cross(p_up,vz).Normalize();
	var vy = thelab.haxor.math.Vector3.Cross(vz,vx);
	var m = new thelab.haxor.math.Matrix4();
	m.Set(vx.x,vx.y,vx.z,-thelab.haxor.math.Vector3.Dot(vx,p_from),vy.x,vy.y,vy.z,-thelab.haxor.math.Vector3.Dot(vy,p_from),vz.x,vz.y,vz.z,-thelab.haxor.math.Vector3.Dot(vz,p_from),0,0,0,1);
	return m;
}
thelab.haxor.math.Matrix4.prototype = {
	ToString: function(p_linear) {
		if(p_linear == null) p_linear = true;
		var a = this.ToArray();
		var s = [];
		var _g1 = 0, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			a[i] = (a[i] * 100.0 | 0) / 100;
			s.push(a[i] >= 0?" " + a[i]:a[i] + "");
		}
		var res = "";
		var _g = 0;
		while(_g < 4) {
			var i = _g++;
			var _g1 = 0;
			while(_g1 < 4) {
				var j = _g1++;
				res += s[j + i * 4] + (j < 3?",":"");
			}
			res += i == 3?"":p_linear?" |":"\n";
		}
		return res;
	}
	,ToBuffer: function() {
		this.m[0] = this.m00;
		this.m[1] = this.m01;
		this.m[2] = this.m02;
		this.m[3] = this.m03;
		this.m[4] = this.m10;
		this.m[5] = this.m11;
		this.m[6] = this.m12;
		this.m[7] = this.m13;
		this.m[8] = this.m20;
		this.m[9] = this.m21;
		this.m[10] = this.m22;
		this.m[11] = this.m23;
		this.m[12] = this.m30;
		this.m[13] = this.m31;
		this.m[14] = this.m32;
		this.m[15] = this.m33;
		return this.m;
	}
	,ToArray: function() {
		return [this.m00,this.m01,this.m02,this.m03,this.m10,this.m11,this.m12,this.m13,this.m20,this.m21,this.m22,this.m23,this.m30,this.m31,this.m32,this.m33];
	}
	,SetPerspectiveInverse: function(p_fov,p_aspect,p_near,p_far) {
		var t = thelab.haxor.math.Mathf.Tan(p_fov * 0.5 * thelab.haxor.math.Mathf.Deg2Rad) * p_near;
		var b = -t;
		var l = p_aspect * b;
		var r = p_aspect * t;
		return this.SetFrustumInverse(l,r,t,b,p_near,p_far);
	}
	,SetPerspective: function(p_fov,p_aspect,p_near,p_far) {
		var t = thelab.haxor.math.Mathf.Tan(p_fov * 0.5 * thelab.haxor.math.Mathf.Deg2Rad) * p_near;
		var b = -t;
		var l = p_aspect * b;
		var r = p_aspect * t;
		return this.SetFrustum(l,r,t,b,p_near,p_far);
	}
	,SetOrtho: function(p_left,p_right,p_top,p_bottom,p_near,p_far) {
		this.SetIdentity();
		var n2 = p_near * 2.0;
		var rml = 1.0 / (p_right - p_left);
		var tmb = 1.0 / (p_top - p_bottom);
		var fmn = 1.0 / (p_far - p_near);
		this.m00 = 2.0 * rml;
		this.m03 = -(p_right + p_left) * rml;
		this.m11 = 2.0 * tmb;
		this.m13 = -(p_top + p_bottom) * tmb;
		this.m22 = -2. * fmn;
		this.m23 = -(p_far + p_near) * fmn;
		return this;
	}
	,SetFrustumInverse: function(p_left,p_right,p_top,p_bottom,p_near,p_far) {
		this.SetIdentity();
		var n2 = p_near * 2.0;
		var rml = p_right - p_left;
		var tmb = p_top - p_bottom;
		var fmn = p_far - p_near;
		this.m00 = rml / n2;
		this.m03 = (p_right + p_left) / n2;
		this.m11 = tmb / n2;
		this.m13 = (p_top + p_bottom) / n2;
		this.m22 = 0.0;
		this.m23 = -1.0;
		this.m32 = fmn / (-n2 * p_far);
		this.m33 = (p_far + p_near) / (n2 * p_far);
		return this;
	}
	,SetFrustum: function(p_left,p_right,p_top,p_bottom,p_near,p_far) {
		this.SetIdentity();
		var n2 = p_near * 2.0;
		var rml = 1.0 / (p_right - p_left);
		var tmb = 1.0 / (p_top - p_bottom);
		var fmn = 1.0 / (p_far - p_near);
		this.m00 = n2 * rml;
		this.m02 = (p_right + p_left) * rml;
		this.m11 = n2 * tmb;
		this.m12 = (p_top + p_bottom) * tmb;
		this.m22 = -(p_near + p_far) * fmn;
		this.m23 = -n2 * p_far * fmn;
		this.m32 = -1.0;
		this.m33 = 0;
		return this;
	}
	,Transform2x2: function(p_point) {
		var vx = this.m00 * p_point.x + this.m01 * p_point.y;
		var vy = this.m10 * p_point.x + this.m11 * p_point.y;
		p_point.x = vx;
		p_point.y = vy;
	}
	,Transform2x3: function(p_point) {
		var vx = this.m00 * p_point.x + this.m01 * p_point.y + this.m03;
		var vy = this.m10 * p_point.x + this.m11 * p_point.y + this.m13;
		p_point.x = vx;
		p_point.y = vy;
	}
	,Transform3x3: function(p_point) {
		var vx = this.m00 * p_point.x + this.m01 * p_point.y + this.m02 * p_point.z;
		var vy = this.m10 * p_point.x + this.m11 * p_point.y + this.m12 * p_point.z;
		var vz = this.m20 * p_point.x + this.m21 * p_point.y + this.m22 * p_point.z;
		p_point.x = vx;
		p_point.y = vy;
		p_point.z = vz;
		return p_point;
	}
	,Transform3x4: function(p_point) {
		var vx = this.m00 * p_point.x + this.m01 * p_point.y + this.m02 * p_point.z + this.m03;
		var vy = this.m10 * p_point.x + this.m11 * p_point.y + this.m12 * p_point.z + this.m13;
		var vz = this.m20 * p_point.x + this.m21 * p_point.y + this.m22 * p_point.z + this.m23;
		p_point.x = vx;
		p_point.y = vy;
		p_point.z = vz;
		return p_point;
	}
	,Transform4x4: function(p_point) {
		var vx = this.m00 * p_point.x + this.m01 * p_point.y + this.m02 * p_point.z + this.m03 * p_point.w;
		var vy = this.m10 * p_point.x + this.m11 * p_point.y + this.m12 * p_point.z + this.m13 * p_point.w;
		var vz = this.m20 * p_point.x + this.m21 * p_point.y + this.m22 * p_point.z + this.m23 * p_point.w;
		var vw = this.m30 * p_point.x + this.m31 * p_point.y + this.m32 * p_point.z + this.m33 * p_point.w;
		p_point.x = vx;
		p_point.y = vy;
		p_point.z = vz;
		p_point.w = vw;
	}
	,Multiply: function(p_matrix) {
		var r00 = this.m00 * p_matrix.m00 + this.m01 * p_matrix.m10 + this.m02 * p_matrix.m20 + this.m03 * p_matrix.m30;
		var r01 = this.m00 * p_matrix.m01 + this.m01 * p_matrix.m11 + this.m02 * p_matrix.m21 + this.m03 * p_matrix.m31;
		var r02 = this.m00 * p_matrix.m02 + this.m01 * p_matrix.m12 + this.m02 * p_matrix.m22 + this.m03 * p_matrix.m32;
		var r03 = this.m00 * p_matrix.m03 + this.m01 * p_matrix.m13 + this.m02 * p_matrix.m23 + this.m03 * p_matrix.m33;
		var r10 = this.m10 * p_matrix.m00 + this.m11 * p_matrix.m10 + this.m12 * p_matrix.m20 + this.m13 * p_matrix.m30;
		var r11 = this.m10 * p_matrix.m01 + this.m11 * p_matrix.m11 + this.m12 * p_matrix.m21 + this.m13 * p_matrix.m31;
		var r12 = this.m10 * p_matrix.m02 + this.m11 * p_matrix.m12 + this.m12 * p_matrix.m22 + this.m13 * p_matrix.m32;
		var r13 = this.m10 * p_matrix.m03 + this.m11 * p_matrix.m13 + this.m12 * p_matrix.m23 + this.m13 * p_matrix.m33;
		var r20 = this.m20 * p_matrix.m00 + this.m21 * p_matrix.m10 + this.m22 * p_matrix.m20 + this.m23 * p_matrix.m30;
		var r21 = this.m20 * p_matrix.m01 + this.m21 * p_matrix.m11 + this.m22 * p_matrix.m21 + this.m23 * p_matrix.m31;
		var r22 = this.m20 * p_matrix.m02 + this.m21 * p_matrix.m12 + this.m22 * p_matrix.m22 + this.m23 * p_matrix.m32;
		var r23 = this.m20 * p_matrix.m03 + this.m21 * p_matrix.m13 + this.m22 * p_matrix.m23 + this.m23 * p_matrix.m33;
		var r30 = this.m30 * p_matrix.m00 + this.m31 * p_matrix.m10 + this.m32 * p_matrix.m20 + this.m33 * p_matrix.m30;
		var r31 = this.m30 * p_matrix.m01 + this.m31 * p_matrix.m11 + this.m32 * p_matrix.m21 + this.m33 * p_matrix.m31;
		var r32 = this.m30 * p_matrix.m02 + this.m31 * p_matrix.m12 + this.m32 * p_matrix.m22 + this.m33 * p_matrix.m32;
		var r33 = this.m30 * p_matrix.m03 + this.m31 * p_matrix.m13 + this.m32 * p_matrix.m23 + this.m33 * p_matrix.m33;
		this.Set(r00,r01,r02,r03,r10,r11,r12,r13,r20,r21,r22,r23,r30,r31,r32,r33);
		return this;
	}
	,Multiply3x4: function(p_matrix) {
		var r00 = this.m00 * p_matrix.m00 + this.m01 * p_matrix.m10 + this.m02 * p_matrix.m20 + this.m03 * p_matrix.m30;
		var r01 = this.m00 * p_matrix.m01 + this.m01 * p_matrix.m11 + this.m02 * p_matrix.m21 + this.m03 * p_matrix.m31;
		var r02 = this.m00 * p_matrix.m02 + this.m01 * p_matrix.m12 + this.m02 * p_matrix.m22 + this.m03 * p_matrix.m32;
		var r03 = this.m00 * p_matrix.m03 + this.m01 * p_matrix.m13 + this.m02 * p_matrix.m23 + this.m03 * p_matrix.m33;
		var r10 = this.m10 * p_matrix.m00 + this.m11 * p_matrix.m10 + this.m12 * p_matrix.m20 + this.m13 * p_matrix.m30;
		var r11 = this.m10 * p_matrix.m01 + this.m11 * p_matrix.m11 + this.m12 * p_matrix.m21 + this.m13 * p_matrix.m31;
		var r12 = this.m10 * p_matrix.m02 + this.m11 * p_matrix.m12 + this.m12 * p_matrix.m22 + this.m13 * p_matrix.m32;
		var r13 = this.m10 * p_matrix.m03 + this.m11 * p_matrix.m13 + this.m12 * p_matrix.m23 + this.m13 * p_matrix.m33;
		var r20 = this.m20 * p_matrix.m00 + this.m21 * p_matrix.m10 + this.m22 * p_matrix.m20 + this.m23 * p_matrix.m30;
		var r21 = this.m20 * p_matrix.m01 + this.m21 * p_matrix.m11 + this.m22 * p_matrix.m21 + this.m23 * p_matrix.m31;
		var r22 = this.m20 * p_matrix.m02 + this.m21 * p_matrix.m12 + this.m22 * p_matrix.m22 + this.m23 * p_matrix.m32;
		var r23 = this.m20 * p_matrix.m03 + this.m21 * p_matrix.m13 + this.m22 * p_matrix.m23 + this.m23 * p_matrix.m33;
		this.Set(r00,r01,r02,r03,r10,r11,r12,r13,r20,r21,r22,r23,this.m30,this.m31,this.m32,this.m33);
		return this;
	}
	,MultiplyTransform: function(p_matrix) {
		var r00 = this.m00 * p_matrix.m00 + this.m01 * p_matrix.m10 + this.m02 * p_matrix.m20;
		var r01 = this.m00 * p_matrix.m01 + this.m01 * p_matrix.m11 + this.m02 * p_matrix.m21;
		var r02 = this.m00 * p_matrix.m02 + this.m01 * p_matrix.m12 + this.m02 * p_matrix.m22;
		var r03 = this.m00 * p_matrix.m03 + this.m01 * p_matrix.m13 + this.m02 * p_matrix.m23 + this.m03;
		var r10 = this.m10 * p_matrix.m00 + this.m11 * p_matrix.m10 + this.m12 * p_matrix.m20;
		var r11 = this.m10 * p_matrix.m01 + this.m11 * p_matrix.m11 + this.m12 * p_matrix.m21;
		var r12 = this.m10 * p_matrix.m02 + this.m11 * p_matrix.m12 + this.m12 * p_matrix.m22;
		var r13 = this.m10 * p_matrix.m03 + this.m11 * p_matrix.m13 + this.m12 * p_matrix.m23 + this.m13;
		var r20 = this.m20 * p_matrix.m00 + this.m21 * p_matrix.m10 + this.m22 * p_matrix.m20;
		var r21 = this.m20 * p_matrix.m01 + this.m21 * p_matrix.m11 + this.m22 * p_matrix.m21;
		var r22 = this.m20 * p_matrix.m02 + this.m21 * p_matrix.m12 + this.m22 * p_matrix.m22;
		var r23 = this.m20 * p_matrix.m03 + this.m21 * p_matrix.m13 + this.m22 * p_matrix.m23 + this.m23;
		this.Set(r00,r01,r02,r03,r10,r11,r12,r13,r20,r21,r22,r23,0,0,0,1);
		return this;
	}
	,SetTRS: function(p_position,p_rotation,p_scale) {
		var sx = p_scale == null?1.0:p_scale.x;
		var sy = p_scale == null?1.0:p_scale.y;
		var sz = p_scale == null?1.0:p_scale.z;
		var px = p_position.x;
		var py = p_position.y;
		var pz = p_position.z;
		var r = p_rotation.get_matrix();
		var l = this;
		l.m00 = r.m00 * sx;
		l.m01 = r.m01 * sy;
		l.m02 = r.m02 * sz;
		l.m03 = px;
		l.m10 = r.m10 * sx;
		l.m11 = r.m11 * sy;
		l.m12 = r.m12 * sz;
		l.m13 = py;
		l.m20 = r.m20 * sx;
		l.m21 = r.m21 * sy;
		l.m22 = r.m22 * sz;
		l.m23 = pz;
		l.m30 = l.m31 = l.m32 = 0.0;
		l.m33 = 1.0;
		return l;
	}
	,Rotate: function(p_vector) {
		var tmp = new thelab.haxor.math.Vector3();
		tmp.Set(this.m00,this.m01,this.m02).Normalize();
		var vx = tmp.x * p_vector.x + tmp.y * p_vector.y + tmp.z * p_vector.z;
		tmp.Set(this.m10,this.m11,this.m12).Normalize();
		var vy = tmp.x * p_vector.x + tmp.y * p_vector.y + tmp.z * p_vector.z;
		tmp.Set(this.m20,this.m21,this.m22).Normalize();
		var vz = tmp.x * p_vector.x + tmp.y * p_vector.y + tmp.z * p_vector.z;
		p_vector.x = vx;
		p_vector.y = vy;
		p_vector.z = vz;
		return p_vector;
	}
	,ToRotation: function() {
		var tmp = new thelab.haxor.math.Vector3();
		tmp.Set(this.m00,this.m01,this.m02).Normalize();
		this.m00 = tmp.x;
		this.m01 = tmp.y;
		this.m02 = tmp.z;
		this.m03 = 0.0;
		tmp.Set(this.m10,this.m11,this.m12).Normalize();
		this.m10 = tmp.x;
		this.m11 = tmp.y;
		this.m12 = tmp.z;
		this.m13 = 0.0;
		tmp.Set(this.m20,this.m21,this.m22).Normalize();
		this.m20 = tmp.x;
		this.m21 = tmp.y;
		this.m22 = tmp.z;
		this.m23 = 0.0;
		this.m30 = this.m31 = this.m32 = 0.0;
		this.m33 = 1.0;
		return this;
	}
	,Transpose: function() {
		var t00 = this.m00;
		var t01 = this.m01;
		var t02 = this.m02;
		var t03 = this.m03;
		var t10 = this.m10;
		var t11 = this.m11;
		var t12 = this.m12;
		var t13 = this.m13;
		var t20 = this.m20;
		var t21 = this.m21;
		var t22 = this.m22;
		var t23 = this.m23;
		var t30 = this.m30;
		var t31 = this.m31;
		var t32 = this.m32;
		var t33 = this.m33;
		this.Set(t00,t10,t20,t30,t01,t11,t21,t31,t02,t12,t22,t32,t03,t13,t23,t33);
		return this;
	}
	,SwapRow: function(p_a,p_b) {
		var a0 = this.GetRowCol(p_a,0);
		var a1 = this.GetRowCol(p_a,1);
		var a2 = this.GetRowCol(p_a,2);
		var a3 = this.GetRowCol(p_a,3);
		this.SetRowCol(p_a,0,this.GetRowCol(p_b,0));
		this.SetRowCol(p_a,1,this.GetRowCol(p_b,1));
		this.SetRowCol(p_a,2,this.GetRowCol(p_b,2));
		this.SetRowCol(p_a,3,this.GetRowCol(p_b,3));
		this.SetRowCol(p_b,0,a0);
		this.SetRowCol(p_b,1,a1);
		this.SetRowCol(p_b,2,a2);
		this.SetRowCol(p_b,3,a3);
		return this;
	}
	,SwapCol: function(p_a,p_b) {
		var a0 = this.GetRowCol(0,p_a);
		var a1 = this.GetRowCol(1,p_a);
		var a2 = this.GetRowCol(2,p_a);
		var a3 = this.GetRowCol(3,p_a);
		this.SetRowCol(0,p_a,this.GetRowCol(0,p_b));
		this.SetRowCol(1,p_a,this.GetRowCol(1,p_b));
		this.SetRowCol(2,p_a,this.GetRowCol(2,p_b));
		this.SetRowCol(3,p_a,this.GetRowCol(3,p_b));
		this.SetRowCol(0,p_b,a0);
		this.SetRowCol(1,p_b,a1);
		this.SetRowCol(2,p_b,a2);
		this.SetRowCol(3,p_b,a3);
		return this;
	}
	,GetRowCol: function(p_row,p_col) {
		return this.GetIndex(p_col + (p_row << 2));
	}
	,SetRowCol: function(p_row,p_col,p_value) {
		this.SetIndex(p_col + (p_row << 2),p_value);
	}
	,SetIndex: function(p_index,p_value) {
		switch(p_index) {
		case 0:
			this.m00 = p_value;
			break;
		case 1:
			this.m01 = p_value;
			break;
		case 2:
			this.m02 = p_value;
			break;
		case 3:
			this.m03 = p_value;
			break;
		case 4:
			this.m10 = p_value;
			break;
		case 5:
			this.m11 = p_value;
			break;
		case 6:
			this.m12 = p_value;
			break;
		case 7:
			this.m13 = p_value;
			break;
		case 8:
			this.m20 = p_value;
			break;
		case 9:
			this.m21 = p_value;
			break;
		case 10:
			this.m22 = p_value;
			break;
		case 11:
			this.m23 = p_value;
			break;
		case 12:
			this.m30 = p_value;
			break;
		case 13:
			this.m31 = p_value;
			break;
		case 14:
			this.m32 = p_value;
			break;
		case 15:
			this.m33 = p_value;
			break;
		}
	}
	,GetIndex: function(p_index) {
		switch(p_index) {
		case 0:
			return this.m00;
		case 1:
			return this.m01;
		case 2:
			return this.m02;
		case 3:
			return this.m03;
		case 4:
			return this.m10;
		case 5:
			return this.m11;
		case 6:
			return this.m12;
		case 7:
			return this.m13;
		case 8:
			return this.m20;
		case 9:
			return this.m21;
		case 10:
			return this.m22;
		case 11:
			return this.m23;
		case 12:
			return this.m30;
		case 13:
			return this.m31;
		case 14:
			return this.m32;
		case 15:
			return this.m33;
		}
		return 0;
	}
	,Set: function(p_m00,p_m01,p_m02,p_m03,p_m10,p_m11,p_m12,p_m13,p_m20,p_m21,p_m22,p_m23,p_m30,p_m31,p_m32,p_m33) {
		if(p_m33 == null) p_m33 = 0;
		if(p_m32 == null) p_m32 = 0;
		if(p_m31 == null) p_m31 = 0;
		if(p_m30 == null) p_m30 = 0;
		if(p_m23 == null) p_m23 = 0;
		if(p_m22 == null) p_m22 = 0;
		if(p_m21 == null) p_m21 = 0;
		if(p_m20 == null) p_m20 = 0;
		if(p_m13 == null) p_m13 = 0;
		if(p_m12 == null) p_m12 = 0;
		if(p_m11 == null) p_m11 = 0;
		if(p_m10 == null) p_m10 = 0;
		if(p_m03 == null) p_m03 = 0;
		if(p_m02 == null) p_m02 = 0;
		if(p_m01 == null) p_m01 = 0;
		if(p_m00 == null) p_m00 = 0;
		this.m00 = p_m00;
		this.m01 = p_m01;
		this.m02 = p_m02;
		this.m03 = p_m03;
		this.m10 = p_m10;
		this.m11 = p_m11;
		this.m12 = p_m12;
		this.m13 = p_m13;
		this.m20 = p_m20;
		this.m21 = p_m21;
		this.m22 = p_m22;
		this.m23 = p_m23;
		this.m30 = p_m30;
		this.m31 = p_m31;
		this.m32 = p_m32;
		this.m33 = p_m33;
		return this;
	}
	,SetIdentity: function() {
		this.Set(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
		return this;
	}
	,set_diagonalLR: function(v) {
		this.m00 = v.x;
		this.m11 = v.y;
		this.m22 = v.z;
		this.m33 = v.w;
		return v;
	}
	,get_diagonalLR: function() {
		return new thelab.haxor.math.Vector4(this.m00,this.m11,this.m22,this.m33);
	}
	,GetColumn: function(p_index) {
		return new thelab.haxor.math.Vector4(this.GetRowCol(0,p_index),this.GetRowCol(1,p_index),this.GetRowCol(2,p_index),this.GetRowCol(3,p_index));
	}
	,GetLine: function(p_index) {
		return new thelab.haxor.math.Vector4(this.GetRowCol(p_index,0),this.GetRowCol(p_index,1),this.GetRowCol(p_index,2),this.GetRowCol(p_index,3));
	}
	,ToColumnMajor: function() {
		return [this.m00,this.m10,this.m20,this.m30,this.m01,this.m11,this.m21,this.m31,this.m02,this.m12,this.m22,this.m32,this.m03,this.m13,this.m23,this.m33];
	}
	,ToRowMajor: function() {
		return [this.m00,this.m01,this.m02,this.m03,this.m10,this.m11,this.m12,this.m13,this.m20,this.m21,this.m22,this.m23,this.m30,this.m31,this.m32,this.m33];
	}
	,get_transposed: function() {
		return new thelab.haxor.math.Matrix4(this.m00,this.m10,this.m20,this.m30,this.m01,this.m11,this.m21,this.m31,this.m02,this.m12,this.m22,this.m32,this.m03,this.m13,this.m23,this.m33);
	}
	,get_inverseTransform: function() {
		var result = thelab.haxor.math.Matrix4.get_identity();
		var l0 = new thelab.haxor.math.Vector3(this.m00,this.m01,this.m02);
		var l1 = new thelab.haxor.math.Vector3(this.m10,this.m11,this.m12);
		var l2 = new thelab.haxor.math.Vector3(this.m20,this.m21,this.m22);
		var vl0 = l0.get_length();
		var vl1 = l1.get_length();
		var vl2 = l2.get_length();
		var sx = (vl0 < 0?-vl0:vl0) <= 0.0001?0.0:1.0 / vl0;
		var sy = (vl1 < 0?-vl1:vl1) <= 0.0001?0.0:1.0 / vl1;
		var sz = (vl2 < 0?-vl2:vl2) <= 0.0001?0.0:1.0 / vl2;
		l0.x *= sx;
		l0.y *= sx;
		l0.z *= sx;
		l1.x *= sy;
		l1.y *= sy;
		l1.z *= sy;
		l2.x *= sz;
		l2.y *= sz;
		l2.z *= sz;
		result.Set(sx * l0.x,sx * l1.x,sx * l2.x,sx * (l0.x * -this.m03 + l1.x * -this.m13 + l2.x * -this.m23),sy * l0.y,sy * l1.y,sy * l2.y,sy * (l0.y * -this.m03 + l1.y * -this.m13 + l2.y * -this.m23),sz * l0.z,sz * l1.z,sz * l2.z,sz * (l0.z * -this.m03 + l1.z * -this.m13 + l2.z * -this.m23),0,0,0,1);
		return result;
	}
	,get_transform: function() {
		return [this.GetColumn(3).get_xyz(),this.get_quaternion(),this.get_diagonalLR()];
	}
	,get_translation: function() {
		var t0 = this.m03;
		var t1 = this.m13;
		var t2 = this.m23;
		return new thelab.haxor.math.Matrix4(1,0,0,t0,0,1,0,t1,0,0,1,t2,0,0,0,1);
	}
	,get_scale: function() {
		var d0 = Math.sqrt(this.m00 * this.m00 + this.m01 * this.m01 + this.m02 * this.m02);
		var d1 = Math.sqrt(this.m10 * this.m10 + this.m11 * this.m11 + this.m12 * this.m12);
		var d2 = Math.sqrt(this.m20 * this.m20 + this.m21 * this.m21 + this.m22 * this.m22);
		return new thelab.haxor.math.Matrix4(d0,0,0,0,0,d1,0,0,0,0,d2,0,0,0,0,1);
	}
	,get_rotation: function() {
		var m = this.get_clone();
		return m.ToRotation();
	}
	,get_trace: function() {
		return this.m00 + this.m11 + this.m22 + this.m33;
	}
	,get_quaternion: function() {
		var b = this.ToBuffer();
		var m = this.ToRotation();
		var q = new thelab.haxor.math.Quaternion();
		var diag = m.m00 + m.m11 + m.m22 + 1.0;
		var e = 0;
		if(diag > e) {
			q.w = thelab.haxor.math.Mathf.Sqrt(diag) / 2.0;
			var w4 = 4.0 * q.w;
			q.x = (m.m21 - m.m12) / w4;
			q.y = (m.m02 - m.m20) / w4;
			q.z = (m.m10 - m.m01) / w4;
		} else {
			var d01 = m.m00 - m.m11;
			var d02 = m.m00 - m.m22;
			var d12 = m.m11 - m.m22;
			if(d01 > e && d02 > e) {
				var scale = thelab.haxor.math.Mathf.Sqrt(1.0 + m.m00 - m.m11 - m.m22) * 2.0;
				q.x = 0.25 * scale;
				q.y = (m.m10 + m.m01) / scale;
				q.z = (m.m02 + m.m20) / scale;
				q.w = (m.m12 - m.m21) / scale;
			} else if(d12 > e) {
				var scale = thelab.haxor.math.Mathf.Sqrt(1.0 + m.m11 - m.m00 - m.m22) * 2.0;
				q.x = (m.m10 + m.m01) / scale;
				q.y = 0.25 * scale;
				q.z = (m.m21 + m.m12) / scale;
				q.w = (m.m20 - m.m02) / scale;
			} else {
				var scale = thelab.haxor.math.Mathf.Sqrt(1.0 + m.m22 - m.m00 - m.m11) * 2.0;
				q.x = (m.m20 + m.m02) / scale;
				q.y = (m.m21 + m.m12) / scale;
				q.z = 0.25 * scale;
				q.w = (m.m01 - m.m10) / scale;
			}
		}
		var _g1 = 0, _g = b.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.SetIndex(i,b[i]);
		}
		q.Normalize();
		return q;
	}
	,get_euler: function() {
		var m = this.get_rotation();
		var e = thelab.haxor.math.Vector3.get_zero();
		e.x = thelab.haxor.math.Mathf.Atan2(m.m12,m.m22);
		var c2 = thelab.haxor.math.Mathf.Sqrt(m.m00 * m.m00 + m.m01 * m.m01);
		e.y = thelab.haxor.math.Mathf.Atan2(-m.m02,c2);
		var s1 = thelab.haxor.math.Mathf.Sin(e.x);
		var c1 = thelab.haxor.math.Mathf.Cos(e.x);
		e.z = thelab.haxor.math.Mathf.Atan2(s1 * m.m20 - c1 * m.m10,c1 * m.m11 - s1 * m.m21);
		e.x = e.x * thelab.haxor.math.Mathf.Rad2Deg;
		e.y = e.y * thelab.haxor.math.Mathf.Rad2Deg;
		e.z = e.z * thelab.haxor.math.Mathf.Rad2Deg;
		return e;
	}
	,get_clone: function() {
		return new thelab.haxor.math.Matrix4(this.m00,this.m01,this.m02,this.m03,this.m10,this.m11,this.m12,this.m13,this.m20,this.m21,this.m22,this.m23,this.m30,this.m31,this.m32,this.m33);
	}
}
thelab.haxor.math.Quaternion = function(p_x,p_y,p_z,p_w) {
	if(p_w == null) p_w = 1.0;
	if(p_z == null) p_z = 0;
	if(p_y == null) p_y = 0;
	if(p_x == null) p_x = 0;
	this.x = p_x;
	this.y = p_y;
	this.z = p_z;
	this.w = p_w;
};
thelab.haxor.math.Quaternion.get_identity = function() {
	return new thelab.haxor.math.Quaternion(0,0,0,1.0);
}
thelab.haxor.math.Quaternion.Lerp = function(p_a,p_b,p_ratio) {
	var c = new thelab.haxor.math.Quaternion();
	var ca = p_a.get_clone();
	var dot = p_a.Dot(p_b);
	if(dot < 0.0) {
		ca.w = -ca.w;
		ca.x = -ca.x;
		ca.y = -ca.y;
		ca.z = -ca.z;
	}
	c.x = ca.x + (p_b.x - ca.x) * p_ratio;
	c.y = ca.y + (p_b.y - ca.y) * p_ratio;
	c.z = ca.z + (p_b.z - ca.z) * p_ratio;
	c.w = ca.w + (p_b.w - ca.w) * p_ratio;
	c.Normalize();
	return c;
}
thelab.haxor.math.Quaternion.Slerp = function(p_a,p_b,p_ratio) {
	var qm = new thelab.haxor.math.Quaternion();
	var cosHalfTheta = p_a.w * p_b.w + p_a.x * p_b.x + p_a.y * p_b.y + p_a.z * p_b.z;
	if(Math.abs(cosHalfTheta) >= 1.0) {
		qm.w = p_a.w;
		qm.x = p_a.x;
		qm.y = p_a.y;
		qm.z = p_a.z;
		return qm;
	}
	var halfTheta = Math.acos(cosHalfTheta);
	var sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);
	if(Math.abs(sinHalfTheta) < 0.001) {
		qm.w = p_a.w * 0.5 + p_b.w * 0.5;
		qm.x = p_a.x * 0.5 + p_b.x * 0.5;
		qm.y = p_a.y * 0.5 + p_b.y * 0.5;
		qm.z = p_a.z * 0.5 + p_b.z * 0.5;
		return qm;
	}
	var ratioA = Math.sin((1.0 - p_ratio) * halfTheta) / sinHalfTheta;
	var ratioB = Math.sin(p_ratio * halfTheta) / sinHalfTheta;
	qm.w = p_a.w * ratioA + p_b.w * ratioB;
	qm.x = p_a.x * ratioA + p_b.x * ratioB;
	qm.y = p_a.y * ratioA + p_b.y * ratioB;
	qm.z = p_a.z * ratioA + p_b.z * ratioB;
	return qm;
}
thelab.haxor.math.Quaternion.FromAxisAngle = function(p_axis,p_angle) {
	p_angle = p_angle * 0.5 * thelab.haxor.math.Mathf.Deg2Rad;
	var l = p_axis.get_length();
	if(thelab.haxor.math.Mathf.Abs(l - 1.0) > thelab.haxor.math.Mathf.Epsilon) p_axis.Normalize();
	var s = thelab.haxor.math.Mathf.Sin(p_angle);
	return new thelab.haxor.math.Quaternion(p_axis.x * s,p_axis.y * s,p_axis.z * s,thelab.haxor.math.Mathf.Cos(p_angle));
}
thelab.haxor.math.Quaternion.FromEuler = function(p_euler) {
	var q = new thelab.haxor.math.Quaternion();
	var ax = p_euler.x * thelab.haxor.math.Mathf.Rad2Deg;
	var ay = p_euler.y * thelab.haxor.math.Mathf.Rad2Deg;
	var az = p_euler.z * thelab.haxor.math.Mathf.Rad2Deg;
	var c1 = thelab.haxor.math.Mathf.Cos(ax * 0.5);
	var s1 = thelab.haxor.math.Mathf.Sin(ax * 0.5);
	var c2 = thelab.haxor.math.Mathf.Cos(ay * 0.5);
	var s2 = thelab.haxor.math.Mathf.Sin(ay * 0.5);
	var c3 = thelab.haxor.math.Mathf.Cos(az * 0.5);
	var s3 = thelab.haxor.math.Mathf.Sin(az * 0.5);
	var c1c2 = c1 * c2;
	var s1s2 = s1 * s2;
	q.w = c1c2 * c3 - s1s2 * s3;
	q.x = c1c2 * s3 + s1s2 * c3;
	q.y = s1 * c2 * c3 + c1 * s2 * s3;
	q.z = c1 * s2 * c3 - s1 * c2 * s3;
	q.Normalize();
	return q;
}
thelab.haxor.math.Quaternion.LookRotation = function(p_forward,p_up) {
	return thelab.haxor.math.Matrix4.LookRotation(p_forward,p_up).get_quaternion();
}
thelab.haxor.math.Quaternion.prototype = {
	ToString: function() {
		var a = this.ToArray();
		var s = [];
		var _g1 = 0, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			a[i] = (a[i] * 100.0 | 0) / 100;
			s.push(a[i] >= 0?" " + a[i]:a[i] + "");
		}
		var res = "[";
		var _g1 = 0, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			res += s[i] + (i < a.length - 1?",":"]");
		}
		return res;
	}
	,ToArray: function() {
		return [this.x,this.y,this.z,this.w];
	}
	,Multiply3: function(p_v) {
		p_v.Normalize();
		var qv = new thelab.haxor.math.Quaternion(p_v.x,p_v.y,p_v.z,0);
		var a = this.get_clone();
		a.Multiply(qv.Multiply(this.get_conjugate()));
		p_v.x = a.x;
		p_v.y = a.y;
		p_v.z = a.z;
		return p_v;
	}
	,Multiply: function(p_v) {
		var vx = this.w * p_v.x + this.x * p_v.w + this.y * p_v.z - this.z * p_v.y;
		var vy = this.w * p_v.y + this.y * p_v.w + this.z * p_v.x - this.x * p_v.z;
		var vz = this.w * p_v.z + this.z * p_v.w + this.x * p_v.y - this.y * p_v.x;
		var vw = this.w * p_v.w - this.x * p_v.x - this.y * p_v.y - this.z * p_v.z;
		this.x = vx;
		this.y = vy;
		this.z = vz;
		this.w = vw;
		return this.Normalize();
	}
	,get_conjugate: function() {
		return new thelab.haxor.math.Quaternion(-this.x,-this.y,-this.z,this.w);
	}
	,Normalize: function() {
		var l = this.get_length();
		if(l <= 0) return this;
		this.x *= l = 1.0 / l;
		this.y *= l;
		this.z *= l;
		this.w *= l;
		return this;
	}
	,Dot: function(p_v) {
		return this.x * p_v.x + this.y * p_v.y + this.z * p_v.z + this.w * p_v.w;
	}
	,Set: function(p_x,p_y,p_z,p_w) {
		if(p_w == null) p_w = 1.0;
		if(p_z == null) p_z = 0;
		if(p_y == null) p_y = 0;
		if(p_x == null) p_x = 0;
		this.x = p_x;
		this.y = p_y;
		this.z = p_z;
		this.w = p_w;
		return this;
	}
	,get_normalized: function() {
		return this.get_clone().Normalize();
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
	}
	,get_xyzw: function() {
		return new thelab.haxor.math.Vector4(this.x,this.y,this.z,this.w);
	}
	,get_clone: function() {
		return new thelab.haxor.math.Quaternion(this.x,this.y,this.z,this.w);
	}
	,get_euler: function() {
		this.Normalize();
		var test = this.x * this.y + this.z * this.w;
		var a = new thelab.haxor.math.Vector3();
		if(test > 0.499) {
			a.x = 2.0 * thelab.haxor.math.Mathf.Atan2(this.x,this.w) * thelab.haxor.math.Mathf.Rad2Deg;
			a.y = thelab.haxor.math.Mathf.HalfPI * thelab.haxor.math.Mathf.Rad2Deg;
			a.z = 0;
			return a;
		}
		if(test < -0.499) {
			a.x = -2. * thelab.haxor.math.Mathf.Atan2(this.x,this.w) * thelab.haxor.math.Mathf.Rad2Deg;
			a.y = -thelab.haxor.math.Mathf.HalfPI * thelab.haxor.math.Mathf.Rad2Deg;
			a.z = 0;
			return a;
		}
		var sqx = this.x * this.x;
		var sqy = this.y * this.y;
		var sqz = this.z * this.z;
		a.x = thelab.haxor.math.Mathf.Atan2(2.0 * this.y * this.w - 2.0 * this.x * this.z,1.0 - 2.0 * sqy - 2.0 * sqz) * thelab.haxor.math.Mathf.Rad2Deg;
		a.y = thelab.haxor.math.Mathf.Asin(2.0 * test) * thelab.haxor.math.Mathf.Rad2Deg;
		a.z = thelab.haxor.math.Mathf.Atan2(2.0 * this.x * this.w - 2.0 * this.y * this.z,1.0 - 2.0 * sqx - 2.0 * sqz) * thelab.haxor.math.Mathf.Rad2Deg;
		return a;
	}
	,get_matrix: function() {
		this.Normalize();
		var m = thelab.haxor.math.Matrix4.get_identity();
		var x2 = this.x * this.x;
		var y2 = this.y * this.y;
		var z2 = this.z * this.z;
		var xy = this.x * this.y;
		var xz = this.x * this.z;
		var yz = this.y * this.z;
		var xw = this.w * this.x;
		var yw = this.w * this.y;
		var zw = this.w * this.z;
		m.m00 = 1.0 - 2.0 * (y2 + z2);
		m.m01 = 2.0 * (xy - zw);
		m.m02 = 2.0 * (xz + yw);
		m.m10 = 2.0 * (xy + zw);
		m.m11 = 1.0 - 2.0 * (x2 + z2);
		m.m12 = 2.0 * (yz - xw);
		m.m20 = 2.0 * (xz - yw);
		m.m21 = 2.0 * (yz + xw);
		m.m22 = 1.0 - 2.0 * (x2 + y2);
		return m;
	}
}
thelab.haxor.math.Vector2 = function(p_x,p_y) {
	if(p_y == null) p_y = 0;
	if(p_x == null) p_x = 0;
	this.x = p_x;
	this.y = p_y;
};
thelab.haxor.math.Vector2.get_Right = function() {
	return new thelab.haxor.math.Vector2(1,0);
}
thelab.haxor.math.Vector2.get_Up = function() {
	return new thelab.haxor.math.Vector2(0,1);
}
thelab.haxor.math.Vector2.Lerp = function(p_a,p_b,p_r) {
	return new thelab.haxor.math.Vector2(p_a.x + (p_b.x - p_a.x) * p_r,p_a.y + (p_b.y - p_a.y) * p_r);
}
thelab.haxor.math.Vector2.prototype = {
	ToArray: function() {
		return [this.x,this.y];
	}
	,Normalize: function() {
		var l = this.get_length();
		if(l <= 0) return this;
		this.x *= l = 1.0 / l;
		this.y *= l;
		return this;
	}
	,get_normalized: function() {
		return this.get_clone().Normalize();
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	,get_clone: function() {
		return new thelab.haxor.math.Vector2(this.x,this.y);
	}
}
thelab.haxor.math.Vector3 = function(p_x,p_y,p_z) {
	if(p_z == null) p_z = 0;
	if(p_y == null) p_y = 0;
	if(p_x == null) p_x = 0;
	this.x = p_x;
	this.y = p_y;
	this.z = p_z;
};
thelab.haxor.math.Vector3.get_zero = function() {
	return new thelab.haxor.math.Vector3(0,0,0);
}
thelab.haxor.math.Vector3.get_one = function() {
	return new thelab.haxor.math.Vector3(1,1,1);
}
thelab.haxor.math.Vector3.get_right = function() {
	return new thelab.haxor.math.Vector3(1,0,0);
}
thelab.haxor.math.Vector3.get_up = function() {
	return new thelab.haxor.math.Vector3(0,1,0);
}
thelab.haxor.math.Vector3.get_forward = function() {
	return new thelab.haxor.math.Vector3(0,0,1);
}
thelab.haxor.math.Vector3.Dot = function(p_a,p_b) {
	return p_a.x * p_b.x + p_a.y * p_b.y + p_a.z * p_b.z;
}
thelab.haxor.math.Vector3.Cross = function(p_a,p_b) {
	return new thelab.haxor.math.Vector3(p_a.y * p_b.z - p_a.z * p_b.y,p_a.z * p_b.x - p_a.x * p_b.z,p_a.x * p_b.y - p_a.y * p_b.x);
}
thelab.haxor.math.Vector3.Lerp = function(p_a,p_b,p_r) {
	return new thelab.haxor.math.Vector3(p_a.x + (p_b.x - p_a.x) * p_r,p_a.y + (p_b.y - p_a.y) * p_r,p_a.z + (p_b.z - p_a.z) * p_r);
}
thelab.haxor.math.Vector3.prototype = {
	ToString: function() {
		var a = this.ToArray();
		var s = [];
		var _g1 = 0, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			a[i] = (a[i] * 100.0 | 0) / 100;
			s.push(a[i] >= 0?" " + a[i]:a[i] + "");
		}
		var res = "[";
		var _g1 = 0, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			res += s[i] + (i < a.length - 1?",":"]");
		}
		return res;
	}
	,ToArray: function() {
		return [this.x,this.y,this.z];
	}
	,Normalize: function() {
		var l = this.get_length();
		if(l <= 0) return this;
		this.x *= l = 1.0 / l;
		this.y *= l;
		this.z *= l;
		return this;
	}
	,Scale: function(p_s) {
		this.x *= p_s;
		this.y *= p_s;
		this.z *= p_s;
		return this;
	}
	,Multiply: function(p_v) {
		this.x *= p_v.x;
		this.y *= p_v.y;
		this.z *= p_v.z;
		return this;
	}
	,Sub: function(p_v) {
		this.x -= p_v.x;
		this.y -= p_v.y;
		this.z -= p_v.z;
		return this;
	}
	,Add: function(p_v) {
		this.x += p_v.x;
		this.y += p_v.y;
		this.z += p_v.z;
		return this;
	}
	,Get: function(p) {
		return p == 0?this.x:p == 1?this.y:this.z;
	}
	,Set: function(p_x,p_y,p_z) {
		if(p_z == null) p_z = 0;
		if(p_y == null) p_y = 0;
		if(p_x == null) p_x = 0;
		this.x = p_x;
		this.y = p_y;
		this.z = p_z;
		return this;
	}
	,get_normalized: function() {
		return this.get_clone().Normalize();
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}
	,get_zy: function() {
		return new thelab.haxor.math.Vector2(this.z,this.y);
	}
	,get_zx: function() {
		return new thelab.haxor.math.Vector2(this.z,this.x);
	}
	,get_yz: function() {
		return new thelab.haxor.math.Vector2(this.y,this.z);
	}
	,get_yx: function() {
		return new thelab.haxor.math.Vector2(this.y,this.x);
	}
	,get_xz: function() {
		return new thelab.haxor.math.Vector2(this.x,this.z);
	}
	,get_xy: function() {
		return new thelab.haxor.math.Vector2(this.x,this.y);
	}
	,get_zyx: function() {
		return new thelab.haxor.math.Vector3(this.z,this.y,this.x);
	}
	,get_zxy: function() {
		return new thelab.haxor.math.Vector3(this.z,this.x,this.y);
	}
	,get_yzx: function() {
		return new thelab.haxor.math.Vector3(this.y,this.z,this.x);
	}
	,get_yxz: function() {
		return new thelab.haxor.math.Vector3(this.y,this.z,this.x);
	}
	,get_xzy: function() {
		return new thelab.haxor.math.Vector3(this.x,this.z,this.y);
	}
	,get_clone: function() {
		return new thelab.haxor.math.Vector3(this.x,this.y,this.z);
	}
}
thelab.haxor.math.Vector4 = function(p_x,p_y,p_z,p_w) {
	if(p_w == null) p_w = 0;
	if(p_z == null) p_z = 0;
	if(p_y == null) p_y = 0;
	if(p_x == null) p_x = 0;
	this.x = p_x;
	this.y = p_y;
	this.z = p_z;
	this.w = p_w;
};
thelab.haxor.math.Vector4.Lerp = function(p_a,p_b,p_r) {
	return new thelab.haxor.math.Vector4(p_a.x + (p_b.x - p_a.x) * p_r,p_a.y + (p_b.y - p_a.y) * p_r,p_a.z + (p_b.z - p_a.z) * p_r,p_a.w + (p_b.w - p_a.w) * p_r);
}
thelab.haxor.math.Vector4.prototype = {
	ToArray: function() {
		return [this.x,this.y,this.z,this.w];
	}
	,Normalize: function() {
		var l = this.get_length();
		if(l <= 0) return this;
		this.x *= l = 1.0 / l;
		this.y *= l;
		this.z *= l;
		this.w *= l;
		return this;
	}
	,Scale: function(p_s) {
		this.x *= p_s;
		this.y *= p_s;
		this.z *= p_s;
		this.w *= p_s;
		return this;
	}
	,Add: function(p_v) {
		this.x += p_v.x;
		this.y += p_v.y;
		this.z += p_v.z;
		this.w += p_v.w;
		return this;
	}
	,Get: function(p) {
		return p == 0?this.x:p == 1?this.y:p == 2?this.z:this.w;
	}
	,get_normalized: function() {
		return this.get_clone().Normalize();
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
	}
	,get_xy: function() {
		return new thelab.haxor.math.Vector2(this.x,this.y);
	}
	,get_xyz: function() {
		return new thelab.haxor.math.Vector3(this.x,this.y,this.z);
	}
	,get_rgba: function() {
		return new thelab.haxor.math.Color(this.x,this.y,this.z,this.w);
	}
	,get_clone: function() {
		return new thelab.haxor.math.Vector4(this.x,this.y,this.z,this.w);
	}
}
thelab.haxor.thread = {}
thelab.haxor.thread.TransformThread = function() { }
thelab.haxor.thread.TransformThread.main = function() {
	thelab.haxor.thread.TransformThread.m_jobs = [];
	thelab.haxor.thread.TransformThread.m_concat = [];
	var _g = 0;
	while(_g < 5000) {
		var i = _g++;
		thelab.haxor.thread.TransformThread.m_concat.push(false);
	}
	js.Browser.window.self.onmessage = thelab.haxor.thread.TransformThread.OnEngineMessage;
	js.Browser.window.setInterval(thelab.haxor.thread.TransformThread.OnUpdate,0);
}
thelab.haxor.thread.TransformThread.OnEngineMessage = function(p_event) {
	var job = p_event.data;
	thelab.haxor.thread.TransformThread.m_jobs = p_event.data;
}
thelab.haxor.thread.TransformThread.OnUpdate = function() {
	var clock = haxe.Timer.stamp();
	if(thelab.haxor.thread.TransformThread.m_jobs.length <= 0) return;
	var res = [];
	var l = thelab.haxor.thread.TransformThread.m_jobs;
	var is_first = true;
	var _g1 = 0, _g = l.length;
	while(_g1 < _g) {
		var i = _g1++;
		var job = l[i];
		if(job == null) {
			is_first = true;
			continue;
		}
		var b = job.data;
		var is_dirty = b[thelab.haxor.thread.TransformThread.DIRTY_OFFSET] > 0.0;
		var tid = b[thelab.haxor.thread.TransformThread.ID_OFFSET];
		var pid = b[thelab.haxor.thread.TransformThread.PID_OFFSET];
		if(is_dirty) {
			thelab.haxor.thread.TransformThread.p.x = b[thelab.haxor.thread.TransformThread.POSITION_OFFSET];
			thelab.haxor.thread.TransformThread.p.y = b[thelab.haxor.thread.TransformThread.POSITION_OFFSET + 1];
			thelab.haxor.thread.TransformThread.p.z = b[thelab.haxor.thread.TransformThread.POSITION_OFFSET + 2];
			thelab.haxor.thread.TransformThread.r.x = b[thelab.haxor.thread.TransformThread.ROTATION_OFFSET];
			thelab.haxor.thread.TransformThread.r.y = b[thelab.haxor.thread.TransformThread.ROTATION_OFFSET + 1];
			thelab.haxor.thread.TransformThread.r.z = b[thelab.haxor.thread.TransformThread.ROTATION_OFFSET + 2];
			thelab.haxor.thread.TransformThread.r.w = b[thelab.haxor.thread.TransformThread.ROTATION_OFFSET + 3];
			thelab.haxor.thread.TransformThread.s.x = b[thelab.haxor.thread.TransformThread.SCALE_OFFSET];
			thelab.haxor.thread.TransformThread.s.y = b[thelab.haxor.thread.TransformThread.SCALE_OFFSET + 1];
			thelab.haxor.thread.TransformThread.s.z = b[thelab.haxor.thread.TransformThread.SCALE_OFFSET + 2];
			thelab.haxor.math.Matrix4.TRS(thelab.haxor.thread.TransformThread.p,thelab.haxor.thread.TransformThread.r,thelab.haxor.thread.TransformThread.s,thelab.haxor.thread.TransformThread.lm);
			thelab.haxor.thread.TransformThread.MF32(thelab.haxor.thread.TransformThread.lm,b,thelab.haxor.thread.TransformThread.LM_OFFSET);
			b[thelab.haxor.thread.TransformThread.DIRTY_OFFSET] = 0.0;
		} else thelab.haxor.thread.TransformThread.F32M(thelab.haxor.thread.TransformThread.lm,b,thelab.haxor.thread.TransformThread.LM_OFFSET);
		if(is_first) {
			is_first = false;
			thelab.haxor.thread.TransformThread.F32M(thelab.haxor.thread.TransformThread.wm,job.world);
		} else thelab.haxor.thread.TransformThread.F32M(thelab.haxor.thread.TransformThread.wm,l[i - 1].data,thelab.haxor.thread.TransformThread.WM_OFFSET);
		thelab.haxor.thread.TransformThread.wm.MultiplyTransform(thelab.haxor.thread.TransformThread.lm);
		thelab.haxor.thread.TransformThread.MF32(thelab.haxor.thread.TransformThread.wm,b,thelab.haxor.thread.TransformThread.WM_OFFSET);
		thelab.haxor.math.Matrix4.GetInverseTransform(thelab.haxor.thread.TransformThread.wm,thelab.haxor.thread.TransformThread.wm);
		thelab.haxor.thread.TransformThread.MF32(thelab.haxor.thread.TransformThread.wm,b,thelab.haxor.thread.TransformThread.WIM_OFFSET);
		res.push(job);
	}
	self.postMessage(res);
}
thelab.haxor.thread.TransformThread.F32M = function(m,b,o) {
	if(o == null) o = 0;
	var _g = 0;
	while(_g < 12) {
		var i = _g++;
		m.SetIndex(i,b[o + i]);
	}
	m.m30 = m.m31 = m.m32 = 0.0;
	m.m33 = 1.0;
}
thelab.haxor.thread.TransformThread.MF32 = function(m,b,o) {
	if(o == null) o = 0;
	var _g = 0;
	while(_g < 12) {
		var i = _g++;
		b[o + i] = m.GetIndex(i);
	}
}
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
var Int = { __name__ : ["Int"]};
var Float = Number;
Float.__name__ = ["Float"];
js.Browser.window = typeof window != "undefined" ? window : null;
thelab.haxor.core.Console.m_console = console;
thelab.haxor.core.Console.m_style = "";
thelab.haxor.math.Color.red = new thelab.haxor.math.Color(1,0,0,1);
thelab.haxor.math.Color.yellow = new thelab.haxor.math.Color(1,1,0,1);
thelab.haxor.math.Color.green = new thelab.haxor.math.Color(0,1,0,1);
thelab.haxor.math.Color.cyan = new thelab.haxor.math.Color(0,1,1,1);
thelab.haxor.math.Color.blue = new thelab.haxor.math.Color(0,0,1,1);
thelab.haxor.math.Color.magenta = new thelab.haxor.math.Color(1,0,1,1);
thelab.haxor.math.Color.black = new thelab.haxor.math.Color(0,0,0,1);
thelab.haxor.math.Color.white = new thelab.haxor.math.Color(1,1,1,1);
thelab.haxor.math.Color.empty = new thelab.haxor.math.Color(0,0,0,0);
thelab.haxor.math.Color.gray10 = new thelab.haxor.math.Color(0.1,0.1,0.1,1);
thelab.haxor.math.Color.gray25 = new thelab.haxor.math.Color(0.25,0.25,0.25,1);
thelab.haxor.math.Color.gray50 = new thelab.haxor.math.Color(0.5,0.5,0.5,1);
thelab.haxor.math.Color.gray75 = new thelab.haxor.math.Color(0.75,0.75,0.75,1);
thelab.haxor.math.Color.gray90 = new thelab.haxor.math.Color(0.9,0.9,0.9,1);
thelab.haxor.math.Mathf.Epsilon = 1e-005;
thelab.haxor.math.Mathf.NaN = Math.NaN;
thelab.haxor.math.Mathf.Infinity = Math.POSITIVE_INFINITY;
thelab.haxor.math.Mathf.NegativeInfinity = Math.NEGATIVE_INFINITY;
thelab.haxor.math.Mathf.E = 2.7182818284590452353602874713527;
thelab.haxor.math.Mathf.PI = 3.1415926535897932384626433832795028841971693993751058;
thelab.haxor.math.Mathf.HalfPI = thelab.haxor.math.Mathf.PI * 0.5;
thelab.haxor.math.Mathf.PI2 = thelab.haxor.math.Mathf.PI * 2.0;
thelab.haxor.math.Mathf.PI4 = thelab.haxor.math.Mathf.PI * 4.0;
thelab.haxor.math.Mathf.Rad2Deg = 180.0 / thelab.haxor.math.Mathf.PI;
thelab.haxor.math.Mathf.Deg2Rad = thelab.haxor.math.Mathf.PI / 180.0;
thelab.haxor.math.Mathf.Px2Em = 0.063;
thelab.haxor.math.Mathf.Em2Px = 1.0 / 0.063;
thelab.haxor.math.Mathf.Byte2Float = 0.00392156863;
thelab.haxor.math.Mathf.Short2Float = 0.0000152587890625;
thelab.haxor.math.Mathf.Long2Float = 0.00000000023283064365386962890625;
thelab.haxor.math.Mathf.Float2Byte = 255.0;
thelab.haxor.math.Mathf.Float2Short = 65536.0;
thelab.haxor.math.Mathf.Float2Long = 4294967296.0;
thelab.haxor.math.Mathf.Sin = Math.sin;
thelab.haxor.math.Mathf.Cos = Math.cos;
thelab.haxor.math.Mathf.Asin = Math.asin;
thelab.haxor.math.Mathf.Acos = Math.acos;
thelab.haxor.math.Mathf.Tan = Math.tan;
thelab.haxor.math.Mathf.Atan = Math.atan;
thelab.haxor.math.Mathf.Atan2 = Math.atan2;
thelab.haxor.math.Mathf.Sqrt = Math.sqrt;
thelab.haxor.math.Mathf.Pow = Math.pow;
thelab.haxor.thread.TransformThread.MAX_TRANSFORM = 10000;
thelab.haxor.thread.TransformThread.TRANSFORM_BYTE_LEN = 51;
thelab.haxor.thread.TransformThread.ID_OFFSET = 0;
thelab.haxor.thread.TransformThread.PID_OFFSET = 1;
thelab.haxor.thread.TransformThread.DEPTH_OFFSET = 2;
thelab.haxor.thread.TransformThread.DIRTY_OFFSET = 3;
thelab.haxor.thread.TransformThread.CONCAT_OFFSET = 4;
thelab.haxor.thread.TransformThread.POSITION_OFFSET = 5;
thelab.haxor.thread.TransformThread.ROTATION_OFFSET = 8;
thelab.haxor.thread.TransformThread.SCALE_OFFSET = 12;
thelab.haxor.thread.TransformThread.LM_OFFSET = 15;
thelab.haxor.thread.TransformThread.WM_OFFSET = 27;
thelab.haxor.thread.TransformThread.WIM_OFFSET = 39;
thelab.haxor.thread.TransformThread.p = new thelab.haxor.math.Vector3();
thelab.haxor.thread.TransformThread.r = new thelab.haxor.math.Quaternion();
thelab.haxor.thread.TransformThread.s = new thelab.haxor.math.Vector3();
thelab.haxor.thread.TransformThread.lm = new thelab.haxor.math.Matrix4();
thelab.haxor.thread.TransformThread.wm = new thelab.haxor.math.Matrix4();
thelab.haxor.thread.TransformThread.tm = new thelab.haxor.math.Matrix4();
thelab.haxor.thread.TransformThread.main();
})();

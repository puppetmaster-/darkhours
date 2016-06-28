#Copyright (c) 2015 OvermindDL1
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#
#OvermindDL1 would love to receive updates, fixes, and more to this code,
#though it is not required:  https://github.com/OvermindDL1/Godot-Helpers

const F2 = 0.5 * (sqrt(3.0) - 1.0)
const G2 = (3.0 - sqrt(3.0)) / 6.0
const F3 = (1.0 / 3.0)
const G3 = (1.0 / 6.0)
#const F2 = 0.3660254037844385965883020617184229195117950439453125
#const G2 = 0.2113248654051871344705659794271923601627349853515625
#const G2o = -0.577350269189625731058868041145615279674530029296875
#const F3 = 0.333333333333333314829616256247390992939472198486328125
#const G3 = 0.1666666666666666574148081281236954964697360992431640625

#const F2 = 0.36602540378443860
#const G2 = 0.21132486540518714
#const G20 = -0.577350269189626
#const F3 = 0.33333333333333333
#const G3 = 0.16666666666666666

const GRAD3 = [
 Vector3(1,1,0),  Vector3(-1,1,0),  Vector3(1,-1,0), Vector3(-1,-1,0), 
 Vector3(1,0,1),  Vector3(-1,0,1),  Vector3(1,0,-1), Vector3(-1,0,-1), 
 Vector3(0,1,1),  Vector3(0,-1,1),  Vector3(0,1,-1), Vector3(0,-1,-1)
 ]

const GRAD4 = [
	0,1,1,1,  0,1,1,-1,  0,1,-1,1,  0,1,-1,-1,
	0,-1,1,1, 0,-1,1,-1, 0,-1,-1,1, 0,-1,-1,-1,
	1,0,1,1,  1,0,1,-1,  1,0,-1,1,  1,0,-1,-1,
	-1,0,1,1, -1,0,1,-1, -1,0,-1,1, -1,0,-1,-1,
	1,1,0,1,  1,1,0,-1,  1,-1,0,1,  1,-1,0,-1,
	-1,1,0,1, -1,1,0,-1, -1,-1,0,1, -1,-1,0,-1,
	1,1,1,0,  1,1,-1,0,  1,-1,1,0,  1,-1,-1,0,
	-1,1,1,0, -1,1,-1,0, -1,-1,1,0, -1,-1,-1,0,
	]

const p = [
	151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140,
	36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120,
	234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
	88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71,
	134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133,
	230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161,
	1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196, 135, 130,
	116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250,
	124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227,
	47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44,
	154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9, 129, 22, 39, 253, 19, 98,
	108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228, 251, 34,
	242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14,
	239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121,
	50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243,
	141, 128, 195, 78, 66, 215, 61, 156, 180, 151, 160, 137, 91, 90, 15, 131,
	13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37,
	240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252,
	219, 203, 117, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125,
	136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158,
	231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245,
	40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187,
	208, 89, 18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198,
	173, 186, 3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126,
	255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223,
	183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167,
	43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185,
	112, 104, 218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179,
	162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199,
	106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236,
	05, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156,
	180,
	]



static func fastfloor(x):
	var xi = int(x)
	if x < xi:
		return xi-1
	else:
		return xi

static func simplex2(c0,c1):
	var perm = []
	var permMod12 = []

	for i in range(512):
		perm.append(p[i & 255])
		permMod12.append(perm[i]%12)
	
	var n0
	var n1
	var n2
	
	var xin = c0
	var yin = c1
	
	var s = (xin+yin) * F2
	var i = fastfloor(xin+s)
	var j = fastfloor(yin+s)
	var t = (i+j) * G2
	
	var X0 = i-t
	var Y0 = j-t
	var x0 = xin-X0
	var y0 = yin-Y0

	var i1
	var j1
	if(x0>y0):
		i1=1
		j1=0
	else:
		i1=0
		j1=1
	
	var x1 = x0 - i1 + G2
	var y1 = y0 - j1 + G2
	var x2 = x0 - 1.0 + 2.0 * G2
	var y2 = y0 - 1.0 + 2.0 * G2
	
	var ii = int(i)&255
	var jj = int(j)&255
	var gi0 = permMod12[ii+perm[jj]];
	var gi1 = permMod12[ii+i1+perm[jj+j1]];
	var gi2 = permMod12[ii+1+perm[jj+1]];
	
	var t0 = 0.5 - x0*x0-y0*y0
	if(t0<0):
		n0 = 0.0
	else:
		t0 *= t0
		n0 = t0 * t0 * dot2(GRAD3[gi0], x0, y0)
	
	var t1 = 0.5 - x1*x1-y1*y1;
	if(t1<0):
		n1 = 0.0
	else:
		t1 *= t1;
		n1 = t1 * t1 * dot2(GRAD3[gi1], x1, y1)
		
	var t2 = 0.5 - x2*x2-y2*y2
	if(t2<0):
		n2 = 0.0
	else:
		t2 *= t2
		n2 = t2 * t2 * dot2(GRAD3[gi2], x2, y2)
	
	return (n0 + n1 + n2) * 70.0

static func dot2(g,x,y):
	return (g.x)*x + (g.y)*y
/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */

using System;
using UnityEngine;

namespace com.genome2d.geom
{
    public class GMatrix
    {
        public double a;
        public double b;
        public double c;
        public double d;
        public double tx;
        public double ty;

        public GMatrix(double p_a = 1, double p_b = 0, double p_c = 0, double p_d = 1, double p_tx = 0, double p_ty = 0)
        {
            a = p_a;
            b = p_b;
            c = p_c;
            d = p_d;
            tx = p_tx;
            ty = p_ty;
        }

        public void copyFrom(GMatrix p_from)
        {
            a = p_from.a;
            b = p_from.b;
            c = p_from.c;
            d = p_from.d;
            tx = p_from.tx;
            ty = p_from.ty;
        }

        public void setTo(double p_a, double p_b, double p_c, double p_d, double p_tx, double p_ty)
        {
            a = p_a;
            b = p_b;
            c = p_c;
            d = p_d;
            tx = p_tx;
            ty = p_ty;
        }

        public void identity()
        {
            a = 1;
            b = 0;
            c = 0;
            d = 1;
            tx = 0;
            ty = 0;
        }

        public void concat(GMatrix p_matrix)
        {
            double a1 = a * p_matrix.a + b * p_matrix.c;
            b = a * p_matrix.b + b * p_matrix.d;
            a = a1;

            double c1 = c * p_matrix.a + d * p_matrix.c;
            d = c * p_matrix.b + d * p_matrix.d;

            c = c1;

            double tx1 = tx * p_matrix.a + ty * p_matrix.c + p_matrix.tx;
            ty = tx * p_matrix.b + ty * p_matrix.d + p_matrix.ty;
            tx = tx1;
        }

        public GMatrix invert()
        {
            double n = a * d - b * c;

            if (n == 0)
            {
                a = b = c = d = 0;
                tx = -tx;
                ty = -ty;
            }
            else
            {
                n = 1 / n;
                double a1 = d * n;
                d = a * n;
                a = a1;
                b *= -n;
                c *= -n;

                double tx1 = -a * tx - c * ty;
                ty = -b * tx - d * ty;
                tx = tx1;
            }

            return this;
        }

        public void scale(double p_scaleX, double p_scaleY)
        {
            a *= p_scaleX;
            b *= p_scaleY;
            c *= p_scaleX;
            d *= p_scaleY;
            tx *= p_scaleX;
            ty *= p_scaleY;
        }
        
        public void rotate(double p_angle)
        {
            double cos = Math.Cos(p_angle);
            double sin = Math.Sin(p_angle);

            var a1 = a * cos - b * sin;
            b = a * sin + b * cos;
            a = a1;

            var c1 = c * cos - d * sin;
            d = c * sin + d * cos;
            c = c1;

            var tx1 = tx * cos - ty * sin;
            ty = tx * sin + ty * cos;
            tx = tx1;
        }

        public void translate(double p_x, double p_y)
        {
            tx += p_x;
            ty += p_y;
        }

        public void transformVector(ref Vector3 p_vector)
        {
            double dx = p_vector.x;
            double dy = p_vector.y;
            p_vector.x = (float) (a * dx + c * dy + tx);
            p_vector.y = (float)(b * dx + d * dy + ty);
        }
    }
}
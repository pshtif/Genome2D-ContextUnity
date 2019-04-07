namespace Genome2DNativePlugin
{
    public class GMath
    {
        public static double sin = 0;
        
        public static double SinLP(double x)
        {
            if (x < -3.14159265f)
                x += 6.28318531f;
            else
            if (x >  3.14159265f)
                x -= 6.28318531f;
 
            if ( x < 0 )
                return x * ( 1.27323954f + 0.405284735f * x );
            else
                return x * ( 1.27323954f - 0.405284735f * x );
        }

        public static double SinHP(double x)
        {
            if (x < -3.14159265f)
            {
                x += 6.28318531f;
            }
            else if (x > 3.14159265f) {
                x -= 6.28318531f;
            }

            if ( x < 0 )
            {
                sin = x * ( 1.27323954f + 0.405284735f * x );
    
                if ( sin < 0 )
                    sin = sin * ( -0.255f * ( sin + 1 ) + 1 );
                else
                    sin = sin * ( 0.255f * ( sin - 1 ) + 1 );
            } else {
                sin = x * ( 1.27323954f - 0.405284735f * x );
    
                if ( sin < 0 )
                    sin = sin * ( -0.255f * ( sin + 1 ) + 1 );
                else
                    sin = sin * ( 0.255f * ( sin - 1 ) + 1 );
            }
        
            return sin;
        }
    }
}
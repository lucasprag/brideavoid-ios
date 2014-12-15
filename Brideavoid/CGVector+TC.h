#import <CoreGraphics/CGGeometry.h>

static inline CGVector TCVectorMultiply(CGVector vector, CGFloat m);

static inline CGVector TCVectorMinus(CGPoint p1, CGPoint p2)
{
    return CGVectorMake(
        p1.x - p2.x,
        p1.y - p2.y
    );
}

static inline CGFloat TCVectorLength(CGVector vector)
{
	return sqrtf(vector.dx * vector.dx + vector.dy * vector.dy);
}

static inline CGVector TCVectorUnit(CGVector vector)
{
    NSUInteger r = arc4random_uniform(10) + 1;
	CGFloat invLen = r / TCVectorLength(vector);
	return TCVectorMultiply(vector, invLen);
}

static inline CGVector TCVectorMultiply(CGVector vector, CGFloat m)
{
    return CGVectorMake(
        vector.dx * m,
        vector.dy * m
    );
}
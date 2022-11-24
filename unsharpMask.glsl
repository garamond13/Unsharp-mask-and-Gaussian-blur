//!HOOK MAIN
//!BIND HOOKED
//!SAVE PASS0
//!DESC unsharp mask pass0

vec4 hook() {
    return linearize(textureLod(HOOKED_raw, HOOKED_pos, 0.0));
}

//!HOOK MAIN
//!BIND PASS0
//!SAVE PASS1
//!DESC unsharp mask pass1

////////////////////////////////////////////////////////////////////////
// USER CONFIGURABLE, PASS 1 (blur in y axis)
//
//CAUTION! probably should use the same settings for "USER CONFIGURABLE, PASS 2" below
//
#define SIGMA 1.0 //blur spread or amount, (0.0, 10+]
#define RADIUS 3.0 //kernel radius (integer as float, e.g. 3.0), (0.0, 10+]; probably should set it to ceil(3 * sigma)
//
////////////////////////////////////////////////////////////////////////

#define get_weight(x) (exp(-(x * x / (2.0 * SIGMA * SIGMA))))

vec4 hook() {
    float weight = get_weight(0.0);
    vec4 csum = textureLod(PASS0_raw, PASS0_pos, 0.0) * weight;
    float wsum = weight;
    for(float i = 1.0; i <= RADIUS; ++i) {
        weight = get_weight(i);
        csum += textureLod(PASS0_raw, PASS0_pos + PASS0_pt * vec2(0.0, -i), 0.0) * weight;
        csum += textureLod(PASS0_raw, PASS0_pos + PASS0_pt * vec2(0.0, i), 0.0) * weight;
        wsum += 2.0 * weight;
    }
    return csum / wsum;
}

//!HOOK MAIN
//!BIND PASS0
//!BIND PASS1
//!DESC unsharp mask pass2

////////////////////////////////////////////////////////////////////////
// USER CONFIGURABLE, PASS 2 (blur in x axis and aply unsharp mask)
//
//CAUTION! probably should use the same settings for "USER CONFIGURABLE, PASS 1" above
//
#define SIGMA 1.0 //blur spread or amount, (0.0, 10+]
#define RADIUS 3.0 //kernel radius (integer as float, e.g. 3.0), (0.0, 10+]; probably should set it to ceil(3 * sigma)
//
//sharpnes
#define AMOUNT 0.5 //amount of sharpening [0.0, 10+]
//
////////////////////////////////////////////////////////////////////////

#define get_weight(x) (exp(-(x * x / (2.0 * SIGMA * SIGMA))))

vec4 hook() {
    float weight = get_weight(0.0);
    vec4 csum = textureLod(PASS1_raw, PASS1_pos, 0.0) * weight;
    float wsum = weight;
    for(float i = 1.0; i <= RADIUS; ++i) {
        weight = get_weight(i);
        csum += textureLod(PASS1_raw, PASS1_pos + PASS1_pt * vec2(-i, 0.0), 0.0) * weight;
        csum += textureLod(PASS1_raw, PASS1_pos + PASS1_pt * vec2(i, 0.0), 0.0) * weight;
        wsum += 2.0 * weight;
    }
    vec4 original = textureLod(PASS0_raw, PASS0_pos, 0.0);
    return delinearize(original + (original - (csum / wsum)) * AMOUNT);
}

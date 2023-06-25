shader_type spatial;
render_mode unshaded;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

vec3 getDepthTexture(sampler2D text, mat4 matrix, vec2 uv){
	float depth = texture(text, uv).x;
	vec3 ndc = vec3(uv, depth) * 2.0 - 1.0;
	vec4 view = matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return vec3(linear_depth / 20.0);
}


void fragment() {
	vec3 col = -8.0 *  getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV).xyz;
	vec2 SCREEN_PIXEL_SIZE = vec2(1) / VIEWPORT_SIZE;
	col += getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV + vec2(0.0, -SCREEN_PIXEL_SIZE.y)).xyz;
	col += getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV + vec2(0.0, SCREEN_PIXEL_SIZE.y)).xyz;
	col += getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0)).xyz;
	col += getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, 0.0)).xyz;
	col += getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV + SCREEN_PIXEL_SIZE.xy).xyz;
	col += getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV - SCREEN_PIXEL_SIZE.xy).xyz;
	col += getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)).xyz;
	col += getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y)).xyz;
	if(length(col) < 1.0) col = vec3(0);
	//col = vec3(1) - col;
	if(length(abs(vec3(0)-col)) < 1.0){
		//ALBEDO = getDepthTexture(DEPTH_TEXTURE, INV_PROJECTION_MATRIX, SCREEN_UV) / 50000.0;
		discard;
	}
	else{
		ALBEDO = col;
	}
	//ALBEDO = NORMAL;
	//ALBEDO = col;
	
}

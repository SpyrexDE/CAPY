shader_type canvas_item;

uniform float v = 1.0;
uniform float strength = 4.0;
uniform float speed = 2.0;

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}


void fragment() {
	if(COLOR.a == 1.0 && COLOR.g > 0.18)	//Only process if green
	{
	
		float size = abs(cos(TIME * speed) * strength) + 0.5;
		
		vec4 c = textureLod(TEXTURE, UV, 0.0);
		for (float x = -size; x < size; x++)
		{
			for (float y = -size; y < size; y++)
			{
				if (x*x + y*y > size*size){continue;}
				vec4 new_c = texture(TEXTURE, UV+TEXTURE_PIXEL_SIZE*vec2(x, y));
				if (length(new_c) >length(c)){
					c = new_c;
				}
			}
		}
		COLOR.rgb = COLOR.rgb * c.rgb + 0.2;
	}
}

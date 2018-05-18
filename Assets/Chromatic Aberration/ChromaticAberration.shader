Shader "Hidden/ChromaticAberration"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ChromaticAberration_Amount ("Amount", float) = 0
		_ChromaticAberration_Spectrum("", 2D) = "" {}
		_Distance_Function("", int) = 0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float _ChromaticAberration_Amount;
			sampler2D _ChromaticAberration_Spectrum;
			int _Distance_Function;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 coords = 2.0 * i.uv - 1.0;
				float2 end;
				if (_Distance_Function == 0) {
					end = i.uv - coords * _ChromaticAberration_Amount;
				}
				else if (_Distance_Function == 1) {
					end = i.uv - sqrt(length(coords)) * normalize(coords) * _ChromaticAberration_Amount;
				}
				else if (_Distance_Function == 2) {
					end = i.uv - normalize(coords) * _ChromaticAberration_Amount;
				}
	

				float2 diff = end - i.uv;
				int samples = clamp(int(length(_MainTex_TexelSize.zw * diff / 2.0)), 3, 16);
				float2 delta = diff / samples;
				float2 pos = i.uv;
				half3 sum = (0.0).xxx, filterSum = (0.0).xxx;


				for (int i = 0; i < samples; i++)
				{
					half t = (i + 0.5) / samples;
					half3 s = tex2Dlod(_MainTex, float4(pos, 0, 0)).rgb;
					half3 filter = tex2Dlod(_ChromaticAberration_Spectrum, float4(t, 0, 0, 0)).rgb;

					sum += s * filter;
					filterSum += filter;
					pos += delta;
				}

				return float4(sum / filterSum, 1);
			}
			ENDCG
		}
	}
}

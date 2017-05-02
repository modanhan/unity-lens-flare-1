// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/RadialWarp"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_HaloWidth("Width", float) = .5
		_HaloFalloff("Halo Falloff", float) = 10
		_HaloSub("Halo Subtract", float) = 1
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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				sampler2D _MainTex;
				float _HaloWidth;
				float _HaloFalloff;
				float _HaloSub;

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = fixed4(0,0,0,0);
					float2 ghostVec = i.uv - .5;

					float2 haloVec = normalize(ghostVec)*-_HaloWidth;
					float weight = length(float2(0.5, 0.5) - (i.uv + haloVec)) / .707;
					weight = pow(1.0 - weight, _HaloFalloff);
					col += tex2D(_MainTex, i.uv + haloVec) * weight;
					col = max(0, col - _HaloSub);
					return col;
				}
				ENDCG
			}
		}
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/LensFlareAberration"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplaceColor ("Displacement Color", Color) = (1,1,1,1)
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
			float4 _DisplaceColor;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 direction = normalize(i.uv - .5);
				float r = tex2D(_MainTex, i.uv + direction * _DisplaceColor.r).r;
				float g = tex2D(_MainTex, i.uv + direction * _DisplaceColor.g).g;
				float b = tex2D(_MainTex, i.uv + direction * _DisplaceColor.b).b;
				return float4(r,g,b,1);
			}
			ENDCG
		}
	}
}

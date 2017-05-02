// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/GaussianBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlurSize ("Blur Size", float) = 8
		_Sigma ("Sigma", float) = 3
		_Direction ("Direction", int) = 0
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
			float _BlurSize;
			float _Sigma;
			int _Direction;

			float4 _MainTex_TexelSize;

			float g(float x) {
				return pow(2.71829, -x*x/(2*_Sigma*_Sigma))/sqrt(2*3.141593*_Sigma*_Sigma);
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(0,0,0,0);
				for (int k = -_BlurSize; k <= _BlurSize; k++) {
					col+=tex2D(_MainTex, i.uv+float2(_Direction*k*_MainTex_TexelSize.x, (1-_Direction)*k*_MainTex_TexelSize.y))*g(k);
				}
				col.w = 1;
				return col;
			}
			ENDCG
		}
	}
}

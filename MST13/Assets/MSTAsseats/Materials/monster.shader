Shader "monsterShader"
{
	Properties 
	{
_BaseTex("_BaseTex", 2D) = "black" {}
_EmiTex("_EmiTex", 2D) = "black" {}
_SubEmiTex("_SubEmiTex", 2D) = "black" {}
_SubEmiGradMask("_SubEmiGradMask", 2D) = "black" {}
_loadingMask("_loadingMask", 2D) = "black" {}
_loadingLight("_loadingLight", 2D) = "black" {}
_noiseMask("_noiseMask", 2D) = "black" {}
_loadUVpan("_loadUVpan", Range(0,1) ) = 1
_alpha("_alpha", Range(0,1) ) = 1
_Lighten("_Lighten", Range(0,1) ) = 0
_glow("_glow", Range(-1,1) ) = 0
_SubEmiGlow("_SubEmiGlow", Range(0,1) ) = 0
_SubEmiOffset("_SubEmiOffset", Range(0,1) ) = 0

	}
	
	SubShader 
	{
		Tags
		{
"Queue"="Transparent"
"IgnoreProjector"="False"
"RenderType"="Opaque"

		}
 Pass {
            ZWrite On
            ColorMask 0
        }
		
Cull Back
ZWrite On
ZTest LEqual
ColorMask RGBA
Fog{
}


		CGPROGRAM
#pragma surface surf BlinnPhongEditor  alpha decal:blend vertex:vert
#pragma target 3.0


sampler2D _BaseTex;
sampler2D _EmiTex;
sampler2D _SubEmiTex;
sampler2D _SubEmiGradMask;
sampler2D _loadingMask;
sampler2D _loadingLight;
sampler2D _noiseMask;
float _loadUVpan;
float _alpha;
float _Lighten;
float _glow;
float _SubEmiGlow;
float _SubEmiOffset;

			struct EditorSurfaceOutput {
				half3 Albedo;
				half3 Normal;
				half3 Emission;
				half3 Gloss;
				half Specular;
				half Alpha;
				half4 Custom;
			};
			
			inline half4 LightingBlinnPhongEditor_PrePass (EditorSurfaceOutput s, half4 light)
			{
half3 spec = light.a * s.Gloss;
half4 c;
c.rgb = (s.Albedo * light.rgb + light.rgb * spec) * s.Alpha;
c.a = s.Alpha;
return c;

			}

			inline half4 LightingBlinnPhongEditor (EditorSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
			{
				half3 h = normalize (lightDir + viewDir);
				
				half diff = max (0, dot ( lightDir, s.Normal ));
				
				float nh = max (0, dot (s.Normal, h));
				float spec = pow (nh, s.Specular*128.0);
				
				half4 res;
				res.rgb = _LightColor0.rgb * diff;
				res.w = spec * Luminance (_LightColor0.rgb);
				res *= atten * 2.0;

				return LightingBlinnPhongEditor_PrePass( s, res );
			}
			
			struct Input {
				float2 uv_BaseTex;
float4 fullMeshUV2;
float2 uv_EmiTex;
float3 viewDir;
float2 uv_noiseMask;
float4 meshUV;

			};

			void vert (inout appdata_full v, out Input o) {
				UNITY_INITIALIZE_OUTPUT(Input,o)
float4 VertexOutputMaster0_0_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_1_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_2_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_3_NoInput = float4(0,0,0,0);

o.fullMeshUV2 = v.texcoord1;
o.meshUV.xy = v.texcoord.xy;
o.meshUV.zw = v.texcoord1.xy;

			}
			

			void surf (Input IN, inout EditorSurfaceOutput o) {
				o.Normal = float3(0.0,0.0,1.0);
				o.Alpha = 1.0;
				o.Albedo = 0.0;
				o.Emission = 0.0;
				o.Gloss = 0.0;
				o.Specular = 0.0;
				o.Custom = 0.0;
				
float4 Sampled2D0=tex2D(_BaseTex,IN.uv_BaseTex.xy);
float4 Add10=_glow.xxxx + float4( 1.0, 1.0, 1.0, 1.0 );
float4 Multiply8=Add10 * float4( 0.5,0.5,0.5,0.5 );
float4 Multiply7=Sampled2D0 * Multiply8;
float4 Multiply12=_SubEmiOffset.xxxx * float4( -1.2,-1.2,-1.2,-1.2 );
float4 Add13=Multiply12 + float4( 0.6,0.6,0.6,0.6 );
float4 UV_Pan1=float4((IN.fullMeshUV2).x,(IN.fullMeshUV2).y + Add13.y,(IN.fullMeshUV2).z,(IN.fullMeshUV2).w);
float4 Tex2D5=tex2D(_SubEmiGradMask,UV_Pan1.xy);
float4 Tex2D4=tex2D(_SubEmiTex,(IN.fullMeshUV2).xy);
float4 Multiply11=Tex2D5 * Tex2D4;
float4 Multiply9=Tex2D4 * _SubEmiGlow.xxxx;
float4 Sampled2D2=tex2D(_EmiTex,IN.uv_EmiTex.xy);
float4 Fresnel0_1_NoInput = float4(0,0,1,1);
float4 Fresnel0=(1.0 - dot( normalize( float4( IN.viewDir.x, IN.viewDir.y,IN.viewDir.z,1.0 ).xyz), normalize( Fresnel0_1_NoInput.xyz ) )).xxxx;
float4 Pow0=pow(Fresnel0,float4( 2.5,2.5,2.5,2.5 ));
float4 Invert3= float4(1.0, 1.0, 1.0, 1.0) - Pow0;
float4 Multiply10=Invert3 * float4( 0.8,0.8,0.8,0.8 );
float4 Multiply6=Sampled2D2 * Multiply10;
float4 Multiply13=Sampled2D2 * float4( 0.6,0.6,0.6,0.6 );
float4 Add14=Multiply6 + Multiply13;
float4 Add11=Multiply9 + Add14;
float4 Add12=Multiply11 + Add11;
float4 Multiply1=Multiply8 * Add12;
float4 Sampled2D1=tex2D(_noiseMask,IN.uv_noiseMask.xy);
float4 Add6=Sampled2D2 + Sampled2D1;
float4 Multiply0=_loadUVpan.xxxx * float4( -1.75,-1.75,-1.75,-1.75 );
float4 Add0=Multiply0 + float4( 1.1,1.1,1.1,1.1 );
float4 UV_Pan0=float4((IN.meshUV.xyxy).x,(IN.meshUV.xyxy).y + Add0.y,(IN.meshUV.xyxy).z,(IN.meshUV.xyxy).w);
float4 Add5=UV_Pan0 + float4( 0.3,0.3,0.3,0.3 );
float4 Tex2D1=tex2D(_loadingLight,Add5.xy);
float4 Multiply3=Add6 * Tex2D1;
float4 Tex2D2=tex2D(_loadingLight,UV_Pan0.xy);
float4 Add4=Multiply3 + Tex2D2;
float4 Add8=Multiply1 + Add4;
float4 Add1=_Lighten.xxxx + Add8;
float4 Add3=Add1 + Multiply1;
float4 Multiply2=float4( 1.0, 1.0, 1.0, 1.0 ) * _alpha.xxxx;
float4 Add7=UV_Pan0 + float4( -0.1,-0.1,-0.1,-0.1 );
float4 Tex2D3=tex2D(_loadingMask,Add7.xy);
float4 Step0=step(Tex2D3,float4( 0.1,0.1,0.1,0.1 ));
float4 Invert1= float4(1.0, 1.0, 1.0, 1.0) - Step0;
float4 Multiply4=Sampled2D1 * Invert1;
float4 Step1=step(Multiply4,float4( 0.5,0.5,0.5,0.5 ));
float4 Invert2= float4(1.0, 1.0, 1.0, 1.0) - Step1;
float4 Invert0= float4(1.0, 1.0, 1.0, 1.0) - Tex2D2;
float4 Add9=Invert2 + Invert0;
float4 Tex2D0=tex2D(_loadingMask,UV_Pan0.xy);
float4 Add2=Add9 + Tex2D0;
float4 Saturate0=saturate(Add2);
float4 Multiply5=Saturate0 * Multiply2;
float4 Subtract0=Multiply5 - float4( 0.1,0.1,0.1,0.1 );
float4 Master0_1_NoInput = float4(0,0,1,1);
float4 Master0_7_NoInput = float4(0,0,0,0);
clip( Subtract0 );
o.Albedo = Multiply7;
o.Emission = Add3;
o.Specular = float4( 0.3,0.3,0.3,0.3 );
o.Gloss = float4( 0.3,0.3,0.3,0.3 );
o.Alpha = Multiply2;

				o.Normal = normalize(o.Normal);
			}
		ENDCG
	}
	Fallback "Diffuse"
}

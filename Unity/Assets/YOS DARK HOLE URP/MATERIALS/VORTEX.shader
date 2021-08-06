// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "YOS/VORT/VORTEX"
{
	Properties
	{
		_EXTNOISE("EXT NOISE", 2D) = "white" {}
		_EDGE("EDGE", 2D) = "white" {}
		_INTNOISE("INT NOISE", 2D) = "white" {}
		_INTERNMASK("INTERN MASK", 2D) = "white" {}
		_POWEREDGE("POWER EDGE", Float) = 1
		_INTPOWER("INT POWER", Float) = 1
		[HDR]_Color0("Color 0", Color) = (1,1,1,0)
		[HDR]_colormult("color mult", Color) = (1,1,1,0)
		_factorcolor("factor color", Float) = 0.8
		_DISTORTIONEXT("DISTORTION EXT", Range( 0 , 1)) = 1
		_OPACITY("OPACITY", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _EDGE;
		uniform sampler2D _EXTNOISE;
		uniform float4 _EXTNOISE_ST;
		uniform float _POWEREDGE;
		uniform float _DISTORTIONEXT;
		uniform sampler2D _INTNOISE;
		uniform float4 _INTNOISE_ST;
		uniform sampler2D _INTERNMASK;
		uniform float _INTPOWER;
		uniform float _factorcolor;
		uniform float4 _Color0;
		uniform float4 _colormult;
		uniform float _OPACITY;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv0_EXTNOISE = i.uv_texcoord * _EXTNOISE_ST.xy + _EXTNOISE_ST.zw;
			float temp_output_26_0 = frac( (0.0 + (i.uv_texcoord.y - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) );
			float ifLocalVar20 = 0;
			if( uv0_EXTNOISE.y >= 0.5 )
				ifLocalVar20 = temp_output_26_0;
			else
				ifLocalVar20 = frac( (2.0 + (i.uv_texcoord.y - 0.0) * (0.0 - 2.0) / (1.0 - 0.0)) );
			float4 appendResult18 = (float4(uv0_EXTNOISE.x , ifLocalVar20 , 0.0 , 0.0));
			float2 panner35 = ( 1.0 * _Time.y * float2( 0,-0.12 ) + uv0_EXTNOISE);
			float simplePerlin2D32 = snoise( panner35*2.32 );
			simplePerlin2D32 = simplePerlin2D32*0.5 + 0.5;
			float temp_output_10_0 = frac( (2.0 + (i.uv_texcoord.y - 0.0) * (0.0 - 2.0) / (1.0 - 0.0)) );
			float ifLocalVar12 = 0;
			if( uv0_EXTNOISE.y <= 0.5 )
				ifLocalVar12 = temp_output_10_0;
			float4 appendResult15 = (float4(uv0_EXTNOISE.x , ifLocalVar12 , 0.0 , 0.0));
			float blendOpSrc28 = pow( tex2D( _EDGE, appendResult18.xy ).r , _POWEREDGE );
			float blendOpDest28 = ( tex2D( _EXTNOISE, ( ( ( simplePerlin2D32 * 0.15 ) * _DISTORTIONEXT ) + appendResult15 ).xy ).r * step( uv0_EXTNOISE.y , 0.5 ) );
			float2 uv0_INTNOISE = i.uv_texcoord * _INTNOISE_ST.xy + _INTNOISE_ST.zw;
			float temp_output_40_0 = frac( (0.0 + (i.uv_texcoord.y - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) );
			float ifLocalVar43 = 0;
			if( uv0_INTNOISE.y >= 0.5 )
				ifLocalVar43 = temp_output_40_0;
			float4 appendResult44 = (float4(uv0_INTNOISE.x , ifLocalVar43 , 0.0 , 0.0));
			float2 panner56 = ( 1.0 * _Time.y * float2( 0,-0.15 ) + appendResult44.xy);
			float4 appendResult52 = (float4(uv0_INTNOISE.x , ifLocalVar43 , 0.0 , 0.0));
			float blendOpSrc49 = ( saturate(  (( blendOpSrc28 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc28 - 0.5 ) ) * ( 1.0 - blendOpDest28 ) ) : ( 2.0 * blendOpSrc28 * blendOpDest28 ) ) ));
			float blendOpDest49 = ( ( tex2D( _INTNOISE, panner56 ).r * ( 1.0 - step( uv0_INTNOISE.y , 0.5 ) ) ) * pow( tex2D( _INTERNMASK, appendResult52.xy ).r , _INTPOWER ) );
			float temp_output_49_0 = ( saturate( 	max( blendOpSrc49, blendOpDest49 ) ));
			float4 ifLocalVar59 = 0;
			if( temp_output_49_0 <= _factorcolor )
				ifLocalVar59 = _Color0;
			else
				ifLocalVar59 = ( _Color0 * _colormult );
			o.Emission = ifLocalVar59.rgb;
			float clampResult69 = clamp( ( temp_output_49_0 * _OPACITY ) , 0.0 , 1.0 );
			o.Alpha = clampResult69;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
181;385;999;626;-2996.465;-240.238;1.313027;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-999.5287,137.7812;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-1077.162,1035.151;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-194.2764,-227.17;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;9;-646.1609,140.2942;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-999.8667,2872.845;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-988.3381,2550.565;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;39;-791.1609,1113.151;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;35;0.3051162,-411.6048;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.12;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;40;-465.1602,1116.151;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;22;-646.498,2875.358;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-284.7676,992.481;Inherit;False;0;45;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;10;-320.1606,143.2942;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;32;213.7789,-480.5508;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2.32;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;25;-702.3373,2628.564;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;12;22.04626,43.17502;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;23;-320.4972,2878.358;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;43;-67.11412,1262.826;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;26;-376.3366,2631.564;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-195.9441,2507.895;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;507.8268,-450.8507;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;683.1568,-508.2659;Inherit;False;Property;_DISTORTIONEXT;DISTORTION EXT;9;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;811.1761,-286.5177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;20;19.46674,2778.24;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;239.9132,-127.278;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;295.0995,1080.21;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;311.9474,1684.74;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;629.8508,-117.9017;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;46;507.1215,1408.221;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;383.9229,2595.623;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;56;453.0876,925.9395;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.15;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;55;978.7441,1917.251;Inherit;False;Property;_INTPOWER;INT POWER;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;877.6474,-82.59533;Inherit;True;Property;_EXTNOISE;EXT NOISE;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;16;977.6416,316.127;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;972.1443,2767.102;Inherit;False;Property;_POWEREDGE;POWER EDGE;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;883.8856,1692.455;Inherit;True;Property;_INTERNMASK;INTERN MASK;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;47;743.3701,1432.318;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;700.0719,993.915;Inherit;True;Property;_INTNOISE;INT NOISE;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;697.8953,2516.328;Inherit;True;Property;_EDGE;EDGE;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1102.992,1188.687;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;30;1103.145,2619.102;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;1262.698,1744.218;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1354.286,174.0155;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;28;1712.727,329.7781;Inherit;True;HardLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1399.052,1303.187;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;49;2604.816,1116.077;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;3427.124,993.5045;Inherit;False;Property;_OPACITY;OPACITY;10;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;58;2219.164,435.3811;Inherit;False;Property;_Color0;Color 0;6;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;61;2206.987,763.6872;Inherit;False;Property;_colormult;color mult;7;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;3589.599,894.8004;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;2556.406,856.9525;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;63;2506.2,547.9418;Inherit;False;Property;_factorcolor;factor color;8;0;Create;True;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;69;3797.933,749.0969;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;59;2718.278,243.6378;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.8;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-1088.69,1357.432;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;70;3968.764,447.3422;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;YOS/VORT/VORTEX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;11;2
WireConnection;39;0;36;2
WireConnection;35;0;13;0
WireConnection;40;0;39;0
WireConnection;22;0;21;2
WireConnection;10;0;9;0
WireConnection;32;0;35;0
WireConnection;25;0;24;2
WireConnection;12;0;13;2
WireConnection;12;3;10;0
WireConnection;12;4;10;0
WireConnection;23;0;22;0
WireConnection;43;0;41;2
WireConnection;43;2;40;0
WireConnection;43;3;40;0
WireConnection;26;0;25;0
WireConnection;33;0;32;0
WireConnection;66;0;33;0
WireConnection;66;1;65;0
WireConnection;20;0;19;2
WireConnection;20;2;26;0
WireConnection;20;3;26;0
WireConnection;20;4;23;0
WireConnection;15;0;13;1
WireConnection;15;1;12;0
WireConnection;44;0;41;1
WireConnection;44;1;43;0
WireConnection;52;0;41;1
WireConnection;52;1;43;0
WireConnection;34;0;66;0
WireConnection;34;1;15;0
WireConnection;46;0;41;2
WireConnection;18;0;19;1
WireConnection;18;1;20;0
WireConnection;56;0;44;0
WireConnection;5;1;34;0
WireConnection;16;0;13;2
WireConnection;50;1;52;0
WireConnection;47;0;46;0
WireConnection;45;1;56;0
WireConnection;27;1;18;0
WireConnection;48;0;45;1
WireConnection;48;1;47;0
WireConnection;30;0;27;1
WireConnection;30;1;31;0
WireConnection;54;0;50;1
WireConnection;54;1;55;0
WireConnection;17;0;5;1
WireConnection;17;1;16;0
WireConnection;28;0;30;0
WireConnection;28;1;17;0
WireConnection;53;0;48;0
WireConnection;53;1;54;0
WireConnection;49;0;28;0
WireConnection;49;1;53;0
WireConnection;68;0;49;0
WireConnection;68;1;67;0
WireConnection;62;0;58;0
WireConnection;62;1;61;0
WireConnection;69;0;68;0
WireConnection;59;0;49;0
WireConnection;59;1;63;0
WireConnection;59;2;62;0
WireConnection;59;3;58;0
WireConnection;59;4;58;0
WireConnection;70;2;59;0
WireConnection;70;9;69;0
ASEEND*/
//CHKSM=4118459B4ADD8FB447297C6A93858A430E239380
Shader "ParticlePixel"
{
    Properties
    {
        [HDR] Color_df613d5d5a5a412d9564f08cdd768b7f("Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]Texture2D_7f58aa1760ec4ae69b7797a6c6f10621("MainTexture", 2D) = "white" {}
        Vector1_65de712373f74c56bea44f884ac7f5a5("Bits", Float) = 8
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue" = "Transparent"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
            // LightMode: <None>
        }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma shader_feature _ _SAMPLE_GI
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
        float4 VertexColor;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        output.interp1.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.texCoord0 = input.interp0.xyzw;
        output.color = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_df613d5d5a5a412d9564f08cdd768b7f;
float4 Texture2D_7f58aa1760ec4ae69b7797a6c6f10621_TexelSize;
float Vector1_65de712373f74c56bea44f884ac7f5a5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
SAMPLER(samplerTexture2D_7f58aa1760ec4ae69b7797a6c6f10621);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Floor_float4(float4 In, out float4 Out)
{
    Out = floor(In);
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9de385be1f0b4517b502ca00adf6ce96_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_df613d5d5a5a412d9564f08cdd768b7f) : Color_df613d5d5a5a412d9564f08cdd768b7f;
    UnityTexture2D _Property_817bd4eb00a541169ce413a35b20607f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
    float4 _UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0 = IN.uv0;
    float _Property_da49c942db9944c39f19141915f77586_Out_0 = Vector1_65de712373f74c56bea44f884ac7f5a5;
    float4 _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2;
    Unity_Multiply_float(_UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2);
    float4 _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1;
    Unity_Floor_float4(_Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2, _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1);
    float4 _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2;
    Unity_Divide_float4(_Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2);
    float _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2;
    Unity_Divide_float(0.45, _Property_da49c942db9944c39f19141915f77586_Out_0, _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2);
    float2 _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3;
    Unity_TilingAndOffset_float((_Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2.xy), float2 (1, 1), (_Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2.xx), _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float4 _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0 = SAMPLE_TEXTURE2D(_Property_817bd4eb00a541169ce413a35b20607f_Out_0.tex, _Property_817bd4eb00a541169ce413a35b20607f_Out_0.samplerstate, _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_R_4 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.r;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_G_5 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.g;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_B_6 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.b;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_A_7 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.a;
    float4 _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2;
    Unity_Multiply_float(_Property_9de385be1f0b4517b502ca00adf6ce96_Out_0, _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2);
    float4 _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2;
    Unity_Multiply_float(IN.VertexColor, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2, _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2);
    float _Split_27b7fad0830c4409864b0713ee283b8a_R_1 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[0];
    float _Split_27b7fad0830c4409864b0713ee283b8a_G_2 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[1];
    float _Split_27b7fad0830c4409864b0713ee283b8a_B_3 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[2];
    float _Split_27b7fad0830c4409864b0713ee283b8a_A_4 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[3];
    surface.BaseColor = (_Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2.xyz);
    surface.Alpha = _Split_27b7fad0830c4409864b0713ee283b8a_A_4;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
    output.VertexColor = input.color;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
        float4 VertexColor;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        output.interp1.xyzw = input.texCoord0;
        output.interp2.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.normalWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
        output.color = input.interp2.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_df613d5d5a5a412d9564f08cdd768b7f;
float4 Texture2D_7f58aa1760ec4ae69b7797a6c6f10621_TexelSize;
float Vector1_65de712373f74c56bea44f884ac7f5a5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
SAMPLER(samplerTexture2D_7f58aa1760ec4ae69b7797a6c6f10621);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Floor_float4(float4 In, out float4 Out)
{
    Out = floor(In);
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9de385be1f0b4517b502ca00adf6ce96_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_df613d5d5a5a412d9564f08cdd768b7f) : Color_df613d5d5a5a412d9564f08cdd768b7f;
    UnityTexture2D _Property_817bd4eb00a541169ce413a35b20607f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
    float4 _UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0 = IN.uv0;
    float _Property_da49c942db9944c39f19141915f77586_Out_0 = Vector1_65de712373f74c56bea44f884ac7f5a5;
    float4 _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2;
    Unity_Multiply_float(_UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2);
    float4 _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1;
    Unity_Floor_float4(_Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2, _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1);
    float4 _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2;
    Unity_Divide_float4(_Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2);
    float _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2;
    Unity_Divide_float(0.45, _Property_da49c942db9944c39f19141915f77586_Out_0, _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2);
    float2 _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3;
    Unity_TilingAndOffset_float((_Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2.xy), float2 (1, 1), (_Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2.xx), _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float4 _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0 = SAMPLE_TEXTURE2D(_Property_817bd4eb00a541169ce413a35b20607f_Out_0.tex, _Property_817bd4eb00a541169ce413a35b20607f_Out_0.samplerstate, _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_R_4 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.r;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_G_5 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.g;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_B_6 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.b;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_A_7 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.a;
    float4 _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2;
    Unity_Multiply_float(_Property_9de385be1f0b4517b502ca00adf6ce96_Out_0, _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2);
    float4 _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2;
    Unity_Multiply_float(IN.VertexColor, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2, _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2);
    float _Split_27b7fad0830c4409864b0713ee283b8a_R_1 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[0];
    float _Split_27b7fad0830c4409864b0713ee283b8a_G_2 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[1];
    float _Split_27b7fad0830c4409864b0713ee283b8a_B_3 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[2];
    float _Split_27b7fad0830c4409864b0713ee283b8a_A_4 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[3];
    surface.Alpha = _Split_27b7fad0830c4409864b0713ee283b8a_A_4;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
    output.VertexColor = input.color;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
        float4 VertexColor;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        output.interp1.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.texCoord0 = input.interp0.xyzw;
        output.color = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_df613d5d5a5a412d9564f08cdd768b7f;
float4 Texture2D_7f58aa1760ec4ae69b7797a6c6f10621_TexelSize;
float Vector1_65de712373f74c56bea44f884ac7f5a5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
SAMPLER(samplerTexture2D_7f58aa1760ec4ae69b7797a6c6f10621);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Floor_float4(float4 In, out float4 Out)
{
    Out = floor(In);
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9de385be1f0b4517b502ca00adf6ce96_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_df613d5d5a5a412d9564f08cdd768b7f) : Color_df613d5d5a5a412d9564f08cdd768b7f;
    UnityTexture2D _Property_817bd4eb00a541169ce413a35b20607f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
    float4 _UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0 = IN.uv0;
    float _Property_da49c942db9944c39f19141915f77586_Out_0 = Vector1_65de712373f74c56bea44f884ac7f5a5;
    float4 _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2;
    Unity_Multiply_float(_UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2);
    float4 _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1;
    Unity_Floor_float4(_Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2, _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1);
    float4 _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2;
    Unity_Divide_float4(_Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2);
    float _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2;
    Unity_Divide_float(0.45, _Property_da49c942db9944c39f19141915f77586_Out_0, _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2);
    float2 _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3;
    Unity_TilingAndOffset_float((_Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2.xy), float2 (1, 1), (_Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2.xx), _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float4 _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0 = SAMPLE_TEXTURE2D(_Property_817bd4eb00a541169ce413a35b20607f_Out_0.tex, _Property_817bd4eb00a541169ce413a35b20607f_Out_0.samplerstate, _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_R_4 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.r;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_G_5 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.g;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_B_6 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.b;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_A_7 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.a;
    float4 _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2;
    Unity_Multiply_float(_Property_9de385be1f0b4517b502ca00adf6ce96_Out_0, _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2);
    float4 _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2;
    Unity_Multiply_float(IN.VertexColor, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2, _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2);
    float _Split_27b7fad0830c4409864b0713ee283b8a_R_1 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[0];
    float _Split_27b7fad0830c4409864b0713ee283b8a_G_2 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[1];
    float _Split_27b7fad0830c4409864b0713ee283b8a_B_3 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[2];
    float _Split_27b7fad0830c4409864b0713ee283b8a_A_4 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[3];
    surface.Alpha = _Split_27b7fad0830c4409864b0713ee283b8a_A_4;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
    output.VertexColor = input.color;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
        float4 VertexColor;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        output.interp1.xyzw = input.tangentWS;
        output.interp2.xyzw = input.texCoord0;
        output.interp3.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.normalWS = input.interp0.xyz;
        output.tangentWS = input.interp1.xyzw;
        output.texCoord0 = input.interp2.xyzw;
        output.color = input.interp3.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_df613d5d5a5a412d9564f08cdd768b7f;
float4 Texture2D_7f58aa1760ec4ae69b7797a6c6f10621_TexelSize;
float Vector1_65de712373f74c56bea44f884ac7f5a5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
SAMPLER(samplerTexture2D_7f58aa1760ec4ae69b7797a6c6f10621);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Floor_float4(float4 In, out float4 Out)
{
    Out = floor(In);
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9de385be1f0b4517b502ca00adf6ce96_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_df613d5d5a5a412d9564f08cdd768b7f) : Color_df613d5d5a5a412d9564f08cdd768b7f;
    UnityTexture2D _Property_817bd4eb00a541169ce413a35b20607f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
    float4 _UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0 = IN.uv0;
    float _Property_da49c942db9944c39f19141915f77586_Out_0 = Vector1_65de712373f74c56bea44f884ac7f5a5;
    float4 _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2;
    Unity_Multiply_float(_UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2);
    float4 _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1;
    Unity_Floor_float4(_Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2, _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1);
    float4 _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2;
    Unity_Divide_float4(_Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2);
    float _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2;
    Unity_Divide_float(0.45, _Property_da49c942db9944c39f19141915f77586_Out_0, _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2);
    float2 _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3;
    Unity_TilingAndOffset_float((_Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2.xy), float2 (1, 1), (_Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2.xx), _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float4 _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0 = SAMPLE_TEXTURE2D(_Property_817bd4eb00a541169ce413a35b20607f_Out_0.tex, _Property_817bd4eb00a541169ce413a35b20607f_Out_0.samplerstate, _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_R_4 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.r;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_G_5 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.g;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_B_6 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.b;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_A_7 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.a;
    float4 _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2;
    Unity_Multiply_float(_Property_9de385be1f0b4517b502ca00adf6ce96_Out_0, _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2);
    float4 _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2;
    Unity_Multiply_float(IN.VertexColor, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2, _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2);
    float _Split_27b7fad0830c4409864b0713ee283b8a_R_1 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[0];
    float _Split_27b7fad0830c4409864b0713ee283b8a_G_2 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[1];
    float _Split_27b7fad0830c4409864b0713ee283b8a_B_3 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[2];
    float _Split_27b7fad0830c4409864b0713ee283b8a_A_4 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[3];
    surface.Alpha = _Split_27b7fad0830c4409864b0713ee283b8a_A_4;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
    output.VertexColor = input.color;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

    ENDHLSL
}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue" = "Transparent"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
            // LightMode: <None>
        }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma shader_feature _ _SAMPLE_GI
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
        float4 VertexColor;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        output.interp1.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.texCoord0 = input.interp0.xyzw;
        output.color = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_df613d5d5a5a412d9564f08cdd768b7f;
float4 Texture2D_7f58aa1760ec4ae69b7797a6c6f10621_TexelSize;
float Vector1_65de712373f74c56bea44f884ac7f5a5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
SAMPLER(samplerTexture2D_7f58aa1760ec4ae69b7797a6c6f10621);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Floor_float4(float4 In, out float4 Out)
{
    Out = floor(In);
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9de385be1f0b4517b502ca00adf6ce96_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_df613d5d5a5a412d9564f08cdd768b7f) : Color_df613d5d5a5a412d9564f08cdd768b7f;
    UnityTexture2D _Property_817bd4eb00a541169ce413a35b20607f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
    float4 _UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0 = IN.uv0;
    float _Property_da49c942db9944c39f19141915f77586_Out_0 = Vector1_65de712373f74c56bea44f884ac7f5a5;
    float4 _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2;
    Unity_Multiply_float(_UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2);
    float4 _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1;
    Unity_Floor_float4(_Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2, _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1);
    float4 _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2;
    Unity_Divide_float4(_Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2);
    float _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2;
    Unity_Divide_float(0.45, _Property_da49c942db9944c39f19141915f77586_Out_0, _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2);
    float2 _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3;
    Unity_TilingAndOffset_float((_Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2.xy), float2 (1, 1), (_Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2.xx), _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float4 _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0 = SAMPLE_TEXTURE2D(_Property_817bd4eb00a541169ce413a35b20607f_Out_0.tex, _Property_817bd4eb00a541169ce413a35b20607f_Out_0.samplerstate, _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_R_4 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.r;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_G_5 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.g;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_B_6 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.b;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_A_7 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.a;
    float4 _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2;
    Unity_Multiply_float(_Property_9de385be1f0b4517b502ca00adf6ce96_Out_0, _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2);
    float4 _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2;
    Unity_Multiply_float(IN.VertexColor, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2, _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2);
    float _Split_27b7fad0830c4409864b0713ee283b8a_R_1 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[0];
    float _Split_27b7fad0830c4409864b0713ee283b8a_G_2 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[1];
    float _Split_27b7fad0830c4409864b0713ee283b8a_B_3 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[2];
    float _Split_27b7fad0830c4409864b0713ee283b8a_A_4 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[3];
    surface.BaseColor = (_Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2.xyz);
    surface.Alpha = _Split_27b7fad0830c4409864b0713ee283b8a_A_4;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
    output.VertexColor = input.color;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
        float4 VertexColor;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        output.interp1.xyzw = input.texCoord0;
        output.interp2.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.normalWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
        output.color = input.interp2.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_df613d5d5a5a412d9564f08cdd768b7f;
float4 Texture2D_7f58aa1760ec4ae69b7797a6c6f10621_TexelSize;
float Vector1_65de712373f74c56bea44f884ac7f5a5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
SAMPLER(samplerTexture2D_7f58aa1760ec4ae69b7797a6c6f10621);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Floor_float4(float4 In, out float4 Out)
{
    Out = floor(In);
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9de385be1f0b4517b502ca00adf6ce96_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_df613d5d5a5a412d9564f08cdd768b7f) : Color_df613d5d5a5a412d9564f08cdd768b7f;
    UnityTexture2D _Property_817bd4eb00a541169ce413a35b20607f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
    float4 _UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0 = IN.uv0;
    float _Property_da49c942db9944c39f19141915f77586_Out_0 = Vector1_65de712373f74c56bea44f884ac7f5a5;
    float4 _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2;
    Unity_Multiply_float(_UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2);
    float4 _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1;
    Unity_Floor_float4(_Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2, _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1);
    float4 _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2;
    Unity_Divide_float4(_Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2);
    float _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2;
    Unity_Divide_float(0.45, _Property_da49c942db9944c39f19141915f77586_Out_0, _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2);
    float2 _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3;
    Unity_TilingAndOffset_float((_Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2.xy), float2 (1, 1), (_Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2.xx), _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float4 _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0 = SAMPLE_TEXTURE2D(_Property_817bd4eb00a541169ce413a35b20607f_Out_0.tex, _Property_817bd4eb00a541169ce413a35b20607f_Out_0.samplerstate, _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_R_4 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.r;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_G_5 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.g;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_B_6 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.b;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_A_7 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.a;
    float4 _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2;
    Unity_Multiply_float(_Property_9de385be1f0b4517b502ca00adf6ce96_Out_0, _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2);
    float4 _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2;
    Unity_Multiply_float(IN.VertexColor, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2, _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2);
    float _Split_27b7fad0830c4409864b0713ee283b8a_R_1 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[0];
    float _Split_27b7fad0830c4409864b0713ee283b8a_G_2 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[1];
    float _Split_27b7fad0830c4409864b0713ee283b8a_B_3 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[2];
    float _Split_27b7fad0830c4409864b0713ee283b8a_A_4 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[3];
    surface.Alpha = _Split_27b7fad0830c4409864b0713ee283b8a_A_4;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
    output.VertexColor = input.color;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
        float4 VertexColor;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        output.interp1.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.texCoord0 = input.interp0.xyzw;
        output.color = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_df613d5d5a5a412d9564f08cdd768b7f;
float4 Texture2D_7f58aa1760ec4ae69b7797a6c6f10621_TexelSize;
float Vector1_65de712373f74c56bea44f884ac7f5a5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
SAMPLER(samplerTexture2D_7f58aa1760ec4ae69b7797a6c6f10621);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Floor_float4(float4 In, out float4 Out)
{
    Out = floor(In);
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9de385be1f0b4517b502ca00adf6ce96_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_df613d5d5a5a412d9564f08cdd768b7f) : Color_df613d5d5a5a412d9564f08cdd768b7f;
    UnityTexture2D _Property_817bd4eb00a541169ce413a35b20607f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
    float4 _UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0 = IN.uv0;
    float _Property_da49c942db9944c39f19141915f77586_Out_0 = Vector1_65de712373f74c56bea44f884ac7f5a5;
    float4 _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2;
    Unity_Multiply_float(_UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2);
    float4 _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1;
    Unity_Floor_float4(_Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2, _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1);
    float4 _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2;
    Unity_Divide_float4(_Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2);
    float _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2;
    Unity_Divide_float(0.45, _Property_da49c942db9944c39f19141915f77586_Out_0, _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2);
    float2 _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3;
    Unity_TilingAndOffset_float((_Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2.xy), float2 (1, 1), (_Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2.xx), _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float4 _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0 = SAMPLE_TEXTURE2D(_Property_817bd4eb00a541169ce413a35b20607f_Out_0.tex, _Property_817bd4eb00a541169ce413a35b20607f_Out_0.samplerstate, _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_R_4 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.r;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_G_5 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.g;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_B_6 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.b;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_A_7 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.a;
    float4 _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2;
    Unity_Multiply_float(_Property_9de385be1f0b4517b502ca00adf6ce96_Out_0, _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2);
    float4 _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2;
    Unity_Multiply_float(IN.VertexColor, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2, _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2);
    float _Split_27b7fad0830c4409864b0713ee283b8a_R_1 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[0];
    float _Split_27b7fad0830c4409864b0713ee283b8a_G_2 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[1];
    float _Split_27b7fad0830c4409864b0713ee283b8a_B_3 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[2];
    float _Split_27b7fad0830c4409864b0713ee283b8a_A_4 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[3];
    surface.Alpha = _Split_27b7fad0830c4409864b0713ee283b8a_A_4;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
    output.VertexColor = input.color;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
        float4 VertexColor;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        output.interp1.xyzw = input.tangentWS;
        output.interp2.xyzw = input.texCoord0;
        output.interp3.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.normalWS = input.interp0.xyz;
        output.tangentWS = input.interp1.xyzw;
        output.texCoord0 = input.interp2.xyzw;
        output.color = input.interp3.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_df613d5d5a5a412d9564f08cdd768b7f;
float4 Texture2D_7f58aa1760ec4ae69b7797a6c6f10621_TexelSize;
float Vector1_65de712373f74c56bea44f884ac7f5a5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
SAMPLER(samplerTexture2D_7f58aa1760ec4ae69b7797a6c6f10621);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Floor_float4(float4 In, out float4 Out)
{
    Out = floor(In);
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9de385be1f0b4517b502ca00adf6ce96_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_df613d5d5a5a412d9564f08cdd768b7f) : Color_df613d5d5a5a412d9564f08cdd768b7f;
    UnityTexture2D _Property_817bd4eb00a541169ce413a35b20607f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7f58aa1760ec4ae69b7797a6c6f10621);
    float4 _UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0 = IN.uv0;
    float _Property_da49c942db9944c39f19141915f77586_Out_0 = Vector1_65de712373f74c56bea44f884ac7f5a5;
    float4 _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2;
    Unity_Multiply_float(_UV_8f93121fb5c04e78aea0c068ee543b5d_Out_0, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2);
    float4 _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1;
    Unity_Floor_float4(_Multiply_17ed8d0c35ee49039fd32a419d5944e0_Out_2, _Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1);
    float4 _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2;
    Unity_Divide_float4(_Floor_bd92820a73c44e9ebf72e009cdb54f07_Out_1, (_Property_da49c942db9944c39f19141915f77586_Out_0.xxxx), _Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2);
    float _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2;
    Unity_Divide_float(0.45, _Property_da49c942db9944c39f19141915f77586_Out_0, _Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2);
    float2 _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3;
    Unity_TilingAndOffset_float((_Divide_8671ec5396a84d07a6b0867ea27f0ef9_Out_2.xy), float2 (1, 1), (_Divide_3f6e2ea80bae40e8b2c4183eadc8e7cc_Out_2.xx), _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float4 _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0 = SAMPLE_TEXTURE2D(_Property_817bd4eb00a541169ce413a35b20607f_Out_0.tex, _Property_817bd4eb00a541169ce413a35b20607f_Out_0.samplerstate, _TilingAndOffset_2e15c4e7680b4b89a776f5996d850535_Out_3);
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_R_4 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.r;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_G_5 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.g;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_B_6 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.b;
    float _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_A_7 = _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0.a;
    float4 _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2;
    Unity_Multiply_float(_Property_9de385be1f0b4517b502ca00adf6ce96_Out_0, _SampleTexture2D_d6fbdeed3ab246d7b375e11478032108_RGBA_0, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2);
    float4 _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2;
    Unity_Multiply_float(IN.VertexColor, _Multiply_567edb4090d5489cb47fc6b50ddb1d54_Out_2, _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2);
    float _Split_27b7fad0830c4409864b0713ee283b8a_R_1 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[0];
    float _Split_27b7fad0830c4409864b0713ee283b8a_G_2 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[1];
    float _Split_27b7fad0830c4409864b0713ee283b8a_B_3 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[2];
    float _Split_27b7fad0830c4409864b0713ee283b8a_A_4 = _Multiply_ef4239b4091e4f6ba29e43686768872a_Out_2[3];
    surface.Alpha = _Split_27b7fad0830c4409864b0713ee283b8a_A_4;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
    output.VertexColor = input.color;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

    ENDHLSL
}
    }
        FallBack "Hidden/Shader Graph/FallbackError"
}
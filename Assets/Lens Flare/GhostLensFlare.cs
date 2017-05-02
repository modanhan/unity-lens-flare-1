using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GhostLensFlare : MonoBehaviour
{
    Material material;
    Material ghostMaterial;
    Material radialWarpMaterial;
    Material additiveMaterial;
    Material aberrationMaterial;
    Material blurMaterial;

    public float Subtract = 0.0f;
    [Range(0, 1)]
    public float Multiply = 1;
    [Range(0, 6)]
    public int Downsample = 1;
    [Range(0, 8)]
    public int NumberOfGhosts = 5;
    [Range(0, 2)]
    public float Displacement = 0.5f;
    public float Falloff = 8;
    [Range(0, 0.5f)]
    public float HaloWidth = 0.5f;
    public float HaloFalloff = 36;
    public float HaloSubtract = 0.1f;

    [Range(0, 64)]
    public int BlurSize = 16;
    [Range(1, 16)]
    public float Sigma = 8;

    [Range(0, 0.1f)]
    public float chromaticAberration = 0.01f;
    public Texture chromaticAberrationSpectrum;

    public enum ChromaticAberrationDistanceFunction : int
    {
        Linear = 0, Sqrt = 1, Constant = 2
    }
    public ChromaticAberrationDistanceFunction chromaticAberrationDistanceFunction;

    void OnEnable()
    {
        material = new Material(Shader.Find("Hidden/SubMul"));
        ghostMaterial = new Material(Shader.Find("Hidden/GhostFeature"));
        radialWarpMaterial = new Material(Shader.Find("Hidden/RadialWarp"));
        additiveMaterial = new Material(Shader.Find("Hidden/Additive"));
        aberrationMaterial = new Material(Shader.Find("Hidden/ChromaticAberration"));
        blurMaterial = new Material(Shader.Find("Hidden/GaussianBlur"));
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_Sub", Subtract);
        material.SetFloat("_Mul", Multiply);
        RenderTexture downsampled = RenderTexture.GetTemporary(Screen.width >> Downsample, Screen.height >> Downsample, 0, RenderTextureFormat.DefaultHDR);
        Graphics.Blit(source, downsampled, material);
        RenderTexture ghosts = RenderTexture.GetTemporary(Screen.width >> Downsample, Screen.height >> Downsample, 0, RenderTextureFormat.DefaultHDR);
        ghostMaterial.SetInt("_NumGhost", NumberOfGhosts);
        ghostMaterial.SetFloat("_Displace", Displacement);
        ghostMaterial.SetFloat("_Falloff", Falloff);
        Graphics.Blit(downsampled, ghosts, ghostMaterial);
        RenderTexture radialWarped = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.DefaultHDR);

        radialWarpMaterial.SetFloat("_HaloFalloff", HaloFalloff);
        radialWarpMaterial.SetFloat("_HaloWidth", HaloWidth);
        radialWarpMaterial.SetFloat("_HaloSub", HaloSubtract);
        Graphics.Blit(source, radialWarped, radialWarpMaterial);

        additiveMaterial.SetTexture("_MainTex1", radialWarped);

        RenderTexture added = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.DefaultHDR);
        Graphics.Blit(ghosts, added, additiveMaterial);

        RenderTexture aberration = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.DefaultHDR); ;

        aberrationMaterial.SetTexture("_ChromaticAberration_Spectrum", chromaticAberrationSpectrum);
        aberrationMaterial.SetFloat("_ChromaticAberration_Amount", chromaticAberration);
        aberrationMaterial.SetInt("_Distance_Function", (int)chromaticAberrationDistanceFunction);
        Graphics.Blit(added, aberration, aberrationMaterial);

        RenderTexture blur = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.DefaultHDR);
        blurMaterial.SetInt("_BlurSize", BlurSize);
        blurMaterial.SetFloat("_Sigma", Sigma);
        blurMaterial.SetInt("_Direction", 1);
        Graphics.Blit(aberration, blur, blurMaterial);

        RenderTexture blur1 = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.DefaultHDR);
        blurMaterial.SetInt("_Direction", 0);
        Graphics.Blit(blur, blur1, blurMaterial);

        additiveMaterial.SetTexture("_MainTex1", blur1);
        Graphics.Blit(source, destination, additiveMaterial);

        RenderTexture.ReleaseTemporary(downsampled);
        RenderTexture.ReleaseTemporary(ghosts);
        RenderTexture.ReleaseTemporary(radialWarped);
        RenderTexture.ReleaseTemporary(added);
        RenderTexture.ReleaseTemporary(aberration);
        RenderTexture.ReleaseTemporary(blur);
        RenderTexture.ReleaseTemporary(blur1);
    }
}

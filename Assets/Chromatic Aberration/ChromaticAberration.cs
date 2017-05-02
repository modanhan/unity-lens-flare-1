using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ChromaticAberration : MonoBehaviour
{
    [Range(0, 0.025f)]
    public float amount;
    public Texture texture;
    private Material material;

    // Creates a private material used to the effect
    void Awake()
    {
        material = new Material(Shader.Find("Hidden/ChromaticAberration"));
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (!texture)
        {
            Graphics.Blit(source, destination);
            return;
        }
        material.SetFloat("_ChromaticAberration_Amount", amount);
        material.SetTexture("_ChromaticAberration_Spectrum", texture);
        Graphics.Blit(source, destination, material);
    }
}

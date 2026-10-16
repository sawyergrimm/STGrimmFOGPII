using UnityEngine;

public class MaterialScriptExample : MonoBehaviour
{
    public float speed = 0.0f;
    public float fadeSpeed = 0.03f;
    private Renderer renderer;
    private Material material;
    private float direction = 1f; // 1 is ascending, -1 is descending
    
    private float currentOpacity;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        renderer = GetComponent<Renderer>();
        material = renderer.material;
    }

    // Update is called once per frame
    void Fixed_Update()
    {
        material.SetFloat("_Speed", speed);
        currentOpacity = material.GetFloat("_Opacity");
        if (currentOpacity > 0.9f) direction = -1;
        else if (currentOpacity < 0.01f) direction = 1;
        material.SetFloat("_Opacity", currentOpacity + (direction * fadeSpeed));
    }
}

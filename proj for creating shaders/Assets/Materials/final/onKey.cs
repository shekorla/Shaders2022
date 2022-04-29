using UnityEngine;

public class onKey : MonoBehaviour
{
    public Animation playMe;
    public string key = "space";
    

    void Update()
    {
        if (Input.GetKeyDown(key))
        {
            playMe.Play();
        }
    }
}

using UnityEngine;
public class BlackCapsToken : MonoBehaviour
{
    public int id;
    void Update(){transform.Rotate(0,100*Time.deltaTime,0);var p=transform.position;p.y+=Mathf.Sin(Time.time*2.2f)*.0008f;transform.position=p;}
    void OnTriggerEnter(Collider other){if(other.GetComponent<BlackCapsPlayer>()){FindObjectOfType<BlackCapsBootstrap>().Collect(id);Destroy(gameObject);}}
}

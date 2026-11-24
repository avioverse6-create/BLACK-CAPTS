using UnityEngine;
public class BlackCapsNPC : MonoBehaviour
{
    Vector3 home,target; float timer;
    void Start(){home=transform.position;PickTarget();}
    void Update(){
        timer-=Time.deltaTime;if(timer<=0)PickTarget();
        Vector3 d=target-transform.position;d.y=0;
        if(d.magnitude>.35f){var dir=d.normalized;transform.position+=dir*1.1f*Time.deltaTime;transform.rotation=Quaternion.Slerp(transform.rotation,Quaternion.LookRotation(dir),8*Time.deltaTime);}
    }
    void PickTarget(){timer=Random.Range(2,5);target=home+new Vector3(Random.Range(-3,3),0,Random.Range(-3,3));}
}

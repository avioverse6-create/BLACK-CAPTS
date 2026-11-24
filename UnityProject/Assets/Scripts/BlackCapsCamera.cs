using UnityEngine;
public class BlackCapsCamera : MonoBehaviour
{
    public Transform target;
    public float distance=6.2f,height=2.2f,sensitivity=0.12f;
    float yaw,pitch=12f;
    void LateUpdate(){
        if(!target)return;
        if(Input.touchCount>0){var t=Input.GetTouch(0);if(t.phase==TouchPhase.Moved&&t.position.x>Screen.width*.38f){yaw+=t.deltaPosition.x*sensitivity;pitch=Mathf.Clamp(pitch-t.deltaPosition.y*sensitivity,-8,45);}}
        else {yaw+=Input.GetAxis("Mouse X")*3f;pitch=Mathf.Clamp(pitch-Input.GetAxis("Mouse Y")*3f,-8,45);}
        var rot=Quaternion.Euler(pitch,yaw,0);transform.position=target.position+Vector3.up*height-rot*Vector3.forward*distance;transform.rotation=rot;
    }
}

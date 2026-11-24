using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class BlackCapsPlayer : MonoBehaviour
{
    public float speed=5f, sprintMultiplier=1.55f, turnSpeed=10f;
    CharacterController controller;
    float vertical;
    void Awake(){controller=GetComponent<CharacterController>();}
    void Update(){
        float x=Input.GetAxisRaw("Horizontal"), z=Input.GetAxisRaw("Vertical");
        Vector3 dir=new Vector3(x,0,z);
        if(Camera.main) dir=Camera.main.transform.forward*dir.z+Camera.main.transform.right*dir.x;
        dir.y=0; dir=Vector3.ClampMagnitude(dir,1);
        bool moving=dir.sqrMagnitude>.01f;
        if(moving) transform.rotation=Quaternion.Slerp(transform.rotation,Quaternion.LookRotation(dir),turnSpeed*Time.deltaTime);
        float sprint=Input.GetKey(KeyCode.LeftShift)?sprintMultiplier:1f;
        if(controller.isGrounded && vertical<0)vertical=-1f;
        vertical+=Physics.gravity.y*Time.deltaTime;
        controller.Move((dir*speed*sprint+Vector3.up*vertical)*Time.deltaTime);
    }
}

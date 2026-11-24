using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BlackCapsBootstrap : MonoBehaviour
{
    static readonly Vector3[] TokenSpots = {
        new(-7,1,-16), new(8,1,-19), new(-14,1,3), new(14,1,8),
        new(0,1,25), new(-8,1,-34), new(8,1,38)
    };
    readonly HashSet<int> collected = new();
    Transform player;
    Text hud;
    int tokens;

    [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
    static void Create() {
        if (FindObjectOfType<BlackCapsBootstrap>() == null)
            new GameObject("BLACK-CAPTS Runtime").AddComponent<BlackCapsBootstrap>();
    }

    void Start() {
        Application.targetFrameRate = 60;
        RenderSettings.fog = true;
        RenderSettings.fogColor = new Color(.68f,.79f,.88f);
        RenderSettings.fogMode = FogMode.Exponential;
        RenderSettings.fogDensity = .008f;
        RenderSettings.ambientLight = new Color(.68f,.76f,.86f);
        BuildLight(); BuildMap(); BuildPlayer(); BuildNPCs(); BuildTokens(); BuildHud();
    }

    Material Mat(Color c, float metallic=0f) {
        var shader = Shader.Find("Universal Render Pipeline/Lit");
        if (shader == null) shader = Shader.Find("Standard");
        var m = new Material(shader);
        m.color = c; m.SetFloat("_Metallic", metallic); return m;
    }
    void Cube(string n, Vector3 p, Vector3 s, Color c) {
        var g = GameObject.CreatePrimitive(PrimitiveType.Cube);
        g.name=n; g.transform.position=p; g.transform.localScale=s;
        g.GetComponent<Renderer>().material=Mat(c);
    }
    void BuildLight() {
        var sun=new GameObject("Winter Sun").AddComponent<Light>();
        sun.type=LightType.Directional; sun.transform.rotation=Quaternion.Euler(52,-25,0);
        sun.intensity=1.15f; sun.shadows=LightShadows.Soft;
    }
    void BuildMap() {
        Cube("Snow terrain",new(0,-.35f,0),new(88,.6f,88),new(.83f,.89f,.94f));
        Cube("Main asphalt",new(0,0,0),new(8,.08f,88),new(.20f,.23f,.27f));
        Cube("Cross street",new(0,0,27),new(64,.08f,7),new(.20f,.23f,.27f));
        for(int z=-40;z<=40;z+=5) Cube("Road marking",new(0,.055f,z),new(.12f,.02f,2.2f),new(.88f,.87f,.78f));
        for(int x=-29;x<=29;x+=5) Cube("Cross marking",new(x,.055f,27),new(2.2f,.02f,.12f),new(.88f,.87f,.78f));
        Cube("West sidewalk",new(-5,.06f,0),new(2,.18f,88),new(.54f,.59f,.64f));
        Cube("East sidewalk",new(5,.06f,0),new(2,.18f,88),new(.54f,.59f,.64f));
        Building("Cabin",new(-10,3,-9),new(9,6,8),new(.43f,.34f,.29f));
        Building("Shop",new(11,3.5f,-5),new(10,7,9),new(.34f,.42f,.49f));
        Building("House",new(-11,2.5f,12),new(8,5,8),new(.48f,.43f,.37f));
        Building("North apartment",new(-15,4.5f,-35),new(10,9,10),new(.39f,.43f,.48f));
        Building("North garage",new(15,2.5f,-35),new(9,5,9),new(.42f,.37f,.32f));
        Building("South house",new(-15,3,38),new(10,6,9),new(.47f,.39f,.32f));
        Building("South workshop",new(15,3,38),new(11,6,9),new(.34f,.40f,.43f));
        for(int x=-25;x<=25;x+=46) for(int z=-20;z<=37;z+=13) Tree(new(x,0,z));
        for(int side=-1;side<=1;side+=2) for(int z=-40;z<=38;z+=16) Lamp(new(side*5.55f,0,z));
        Cube("Bus stop roof",new(7.1f,2.65f,-13),new(3.1f,.18f,2.3f),new(.18f,.24f,.29f));
        Cube("Bus stop back",new(7.1f,1.35f,-13.92f),new(2.8f,2.5f,.1f),new(.24f,.34f,.4f));
        Cube("Bus stop bench",new(7.1f,.62f,-13.48f),new(2.1f,.12f,.42f),new(.34f,.25f,.19f));
    }
    void Building(string n,Vector3 p,Vector3 s,Color c) {
        Cube(n,p,s,c); Cube(n+" snowy roof",p+Vector3.up*(s.y/2+.18f),new(s.x+.5f,.35f,s.z+.5f),new(.93f,.97f,1));
    }
    void Tree(Vector3 p) {
        var trunk=GameObject.CreatePrimitive(PrimitiveType.Cylinder); trunk.transform.position=p+Vector3.up*1.1f; trunk.transform.localScale=new(.45f,1.1f,.45f); trunk.GetComponent<Renderer>().material=Mat(new(.27f,.20f,.16f));
        var crown=GameObject.CreatePrimitive(PrimitiveType.Sphere); crown.transform.position=p+Vector3.up*3; crown.transform.localScale=new(2.1f,2.5f,2.1f); crown.GetComponent<Renderer>().material=Mat(new(.72f,.83f,.85f));
    }
    void Lamp(Vector3 p) {
        var pole=GameObject.CreatePrimitive(PrimitiveType.Cylinder); pole.transform.position=p+Vector3.up*2.5f; pole.transform.localScale=new(.09f,2.5f,.09f); pole.GetComponent<Renderer>().material=Mat(new(.16f,.20f,.24f));
        var lamp=GameObject.CreatePrimitive(PrimitiveType.Sphere); lamp.transform.position=p+Vector3.up*4.8f; lamp.transform.localScale=Vector3.one*.32f;
        var m=Mat(new(1,.86f,.58f)); m.EnableKeyword("_EMISSION"); m.SetColor("_EmissionColor",new Color(1,.72f,.35f)); lamp.GetComponent<Renderer>().material=m;
    }
    void BuildPlayer() {
        var go=GameObject.CreatePrimitive(PrimitiveType.Capsule); go.name="Player"; go.transform.position=new(0,1,10);
        var cc=go.AddComponent<CharacterController>(); cc.height=1.8f; cc.radius=.36f;
        go.AddComponent<BlackCapsPlayer>(); player=go.transform;
        var cam=new GameObject("Third Person Camera").AddComponent<Camera>(); cam.tag="MainCamera";
        cam.transform.SetParent(go.transform); cam.transform.localPosition=new(0,2.2f,-6.2f); cam.transform.localRotation=Quaternion.Euler(12,0,0);
        cam.fieldOfView=65;
        var follow=cam.gameObject.AddComponent<BlackCapsCamera>(); follow.target=go.transform;
    }
    void BuildNPCs() {
        Vector3[] spots={new(-9,1,-3),new(12,1,-15),new(-16,1,20),new(18,1,32),new(0,1,-31)};
        for(int i=0;i<spots.Length;i++){
            var npc=GameObject.CreatePrimitive(PrimitiveType.Capsule); npc.name="Житель_"+(i+1); npc.transform.position=spots[i];
            npc.GetComponent<Renderer>().material=Mat(new(.43f,.35f,.30f)); npc.AddComponent<BlackCapsNPC>();
        }
    }
    void BuildTokens() {
        for(int i=0;i<TokenSpots.Length;i++){
            if(PlayerPrefs.GetInt("token_"+i,0)==1){tokens++;continue;}
            var token=GameObject.CreatePrimitive(PrimitiveType.Cylinder); token.name="Жетон_"+(i+1); token.transform.position=TokenSpots[i]; token.transform.localScale=new(.8f,.08f,.8f); token.GetComponent<Renderer>().material=Mat(new(.95f,.68f,.18f),.55f);
            var col=token.GetComponent<Collider>(); col.isTrigger=true; var rb=token.AddComponent<Rigidbody>(); rb.isKinematic=true;
            token.AddComponent<BlackCapsToken>().id=i;
        }
    }
    void BuildHud() {
        var canvas=new GameObject("HUD").AddComponent<Canvas>(); canvas.renderMode=RenderMode.ScreenSpaceOverlay;
        canvas.gameObject.AddComponent<CanvasScaler>().uiScaleMode=CanvasScaler.ScaleMode.ScaleWithScreenSize;
        canvas.gameObject.AddComponent<GraphicRaycaster>();
        hud=new GameObject("Progress").AddComponent<Text>(); hud.transform.SetParent(canvas.transform,false);
        hud.font=Resources.GetBuiltinResource<Font>("Arial.ttf"); hud.fontSize=28; hud.color=Color.white;
        hud.rectTransform.anchorMin=new(0,1); hud.rectTransform.anchorMax=new(0,1); hud.rectTransform.pivot=new(0,1);
        hud.rectTransform.anchoredPosition=new(28,-28); hud.rectTransform.sizeDelta=new(500,90);
        UpdateHud();
    }
    void UpdateHud(){if(hud)hud.text="BLACK-CAPTS   •   ЖЕТОНЫ "+tokens+" / 7";}
    public void Collect(int id){if(PlayerPrefs.GetInt("token_"+id,0)==1)return;PlayerPrefs.SetInt("token_"+id,1);PlayerPrefs.Save();tokens++;UpdateHud();}
}

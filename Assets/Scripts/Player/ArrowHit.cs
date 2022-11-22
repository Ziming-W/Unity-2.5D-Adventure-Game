using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArrowHit : MonoBehaviour
{
    private Vector3 fromPosition; 
    [SerializeField] private float destoryDistance = 30.0f;
    [SerializeField] private int arrowDamage = 5;
    [SerializeField] private AudioSource arrowHitSound; 
    private bool isActivate; 
    
    // Start is called before the first frame update
    void Start()
    {
        fromPosition = transform.position;
        isActivate = true; 
    }

    // Update is called once per frame
    void Update()
    {
        if (Vector3.Distance(transform.position, fromPosition) > destoryDistance) {
            Destroy(gameObject);
        }
        if (!isActivate) {
            Destroy(gameObject); 
        }
    }

    private void OnTriggerEnter(Collider other) {
        if(other.CompareTag("Player") || other.CompareTag("Gadget") ){
            ; 
        }
        else if (other.CompareTag("Enemy")) {
            other.GetComponent<AI>().recieveDamage(arrowDamage);
            arrowHitSound.Play();
            isActivate = false; 
        } else {
            arrowHitSound.Play();
            isActivate = false;
        }
    }
}

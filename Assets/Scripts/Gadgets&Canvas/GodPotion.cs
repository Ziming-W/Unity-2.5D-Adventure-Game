using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GodPotion : MonoBehaviour {
    [SerializeField] private float rotationSpeed = 100.0f;
    [SerializeField] private float invincibleDuring = 5.0f; 
    // Start is called before the first frame update
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        transform.Rotate(0, rotationSpeed * Time.deltaTime, 0);
    }
    private void OnTriggerEnter(Collider other) {
        if (other.CompareTag("Player")) {
            Destroy(gameObject);
            Equipment.invincibleTimer = invincibleDuring; 
            Equipment.trigerInvincible = true; 
        }
    }
}


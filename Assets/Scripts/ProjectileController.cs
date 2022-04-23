using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileController : MonoBehaviour
{
    [Header("Projectile")]
    [SerializeField] private float projectileLifeTime;

    private void Start() {
        Destroy(gameObject, projectileLifeTime);
    }

    private void OnCollisionEnter(Collision collision) {
        Destroy(gameObject);
    }
}

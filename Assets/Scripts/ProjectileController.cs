using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileController : MonoBehaviour
{
    [Header("VFX References")]
    [SerializeField] private GameObject hitPrefab;

    [Header("Projectile")]
    [SerializeField] private float projectileLifeTime;

    private void Start() {
        Destroy(gameObject, projectileLifeTime);
    }

    private void OnCollisionEnter(Collision collision) {
        MonsterCore monsterStats = collision.gameObject.GetComponent<MonsterCore>();
        if (monsterStats != null)
            monsterStats.DealDamage(1f);

        if(hitPrefab != null) {
            Vector3 position = collision.contacts[0].point;
            Quaternion rotation = Quaternion.FromToRotation(Vector3.up, collision.contacts[0].normal);

            var hitVFX = Instantiate(hitPrefab, position, rotation);
            var particleSystemHit = hitVFX.GetComponent<ParticleSystem>();

            Destroy(hitVFX, particleSystemHit.main.duration);
        }

        Destroy(gameObject);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour {
    [Header("Camera")]
    [SerializeField] private float fov = 60f;
    [SerializeField] private float fovSmoothTime = 0.15f;

    [Header("Shoot")]
    [SerializeField] private float projectileRate = 1f;
    [SerializeField] private float projectileSpeed = 5f;
    [SerializeField] private float projectileSway = 5f;
    [SerializeField] private LayerMask projectileLayer;
    [SerializeField] private Transform projectileSpawn;
    [SerializeField] private GameObject projectilePrefab;

    [Header("Movement")]
    [SerializeField] private float moveSpeed = 8f;
    [SerializeField] private float airSpeed = 10f;
    [SerializeField] private float jumpHeight = 2.5f;
    [SerializeField] private float moveSmoothTime = 0.05f;

    [Header("Dash")]
    [SerializeField] private Image dashUI;
    [SerializeField] private float dashCooldown = 2f;
    [SerializeField] private float dashFov = 10f;
    [SerializeField] private float dashSpeed = 20;
    [SerializeField] private float dashTime = 0.25f;

    [Header("Gravity")]
    [SerializeField] private float gravity = -10f;
    [SerializeField] private float gravityScale = 3f;
    [SerializeField] private float gravityFallScale = 4f;

    [Header("Look")]
    [SerializeField] private float lookSensitivity = 0.1f;
    [SerializeField] private float lookTiltAmount = 1.2f;
    [SerializeField] private float lookSmoothTime = 0.03f;
    [SerializeField] private float tiltSmoothTime = 0.1f;

    private Camera _camera;
    private CharacterController _controller;
    private PlayerInput _input;

    private bool _isDashing = false;
    private bool _dashReady = true;
    private float _dashDowntime = 1f;

    private float _projectileTime = 0;
    private Vector3 _projectileDestination;

    private float _cameraPitch = 0;
    private float _cameraTilt = 0;
    private float _velocityY = 0;

    private Vector2 _currentDirection, _currentDirectionVelocity;
    private Vector2 _currentDelta, _currentDeltaVelocity;
    private float _currentTilt, _currentTiltVelocity;
    private float _currentFov, _currentFovVelocity;

    private void Awake() {
        _camera = GetComponentInChildren<Camera>();
        _controller = GetComponent<CharacterController>();
        _input = new PlayerInput();

        _camera.fieldOfView = fov;
        _currentFov = fov;

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void OnEnable() {
        _input.Player.Enable();
    }

    private void OnDisable() {
        _input.Player.Disable();
    }

    private void Update() {
        HandleMovement();
        HandleLook();
    }

    private void HandleMovement() {
        Vector2 targetDirection = _input.Player.Movement.ReadValue<Vector2>();

        _currentDirection = Vector2.SmoothDamp(_currentDirection, targetDirection, ref _currentDirectionVelocity, moveSmoothTime);

        if (_controller.isGrounded)
            _velocityY = 0.0f;

        if (!_dashReady && _controller.isGrounded && _dashDowntime == 1f) {
            _dashReady = true;
            dashUI.color = new Color32(255, 255, 255, 128);
        }

        if (_input.Player.Jump.IsPressed() && _controller.isGrounded)
            _velocityY += Mathf.Sqrt(jumpHeight * -2f * (gravity * gravityScale));

        if (_input.Player.Dash.triggered && _dashReady && targetDirection.magnitude > 0.1f)
            StartCoroutine(Dash(targetDirection));

        _velocityY += gravity * (_velocityY >= 0 ? gravityScale : gravityFallScale) * Time.deltaTime;

        Vector3 velocity = (transform.forward * _currentDirection.y + transform.right * _currentDirection.x) * (_controller.isGrounded ? moveSpeed : airSpeed) + Vector3.up * (_isDashing ? 0 : _velocityY);
        _controller.Move(velocity * Time.deltaTime);
    }

    IEnumerator Dash(Vector2 direction) {
        float startTime = Time.time;
        _dashDowntime = 0;
        _dashReady = false;
        _isDashing = true;
        dashUI.color = new Color32(128, 128, 128, 128);
        while(Time.time < startTime + dashTime) {
            direction = direction.normalized;
            Vector3 dashVelocity = (transform.forward * direction.y + transform.right * direction.x) * dashSpeed;
            _controller.Move(dashVelocity * Time.deltaTime);
            yield return null;
        }
        _isDashing = false;
    }

    private void HandleLook() {
        Vector2 targetDelta = _input.Player.Look.ReadValue<Vector2>();

        _currentDelta = Vector2.SmoothDamp(_currentDelta, targetDelta, ref _currentDeltaVelocity, lookSmoothTime);

        _cameraPitch -= _currentDelta.y * lookSensitivity;
        _cameraPitch = Mathf.Clamp(_cameraPitch, -90f, 90f);

        _cameraTilt = _currentDirection.x < -0.1f ? lookTiltAmount : _currentDirection.x > 0.1f ? -lookTiltAmount : 0f;
        _currentTilt = Mathf.SmoothDamp(_currentTilt, _cameraTilt, ref _currentTiltVelocity, tiltSmoothTime);

        _currentFov = Mathf.SmoothDamp(_currentFov, (_isDashing ? fov + dashFov : fov), ref _currentFovVelocity, fovSmoothTime);
        _camera.fieldOfView = _currentFov;

        if(_input.Player.Action.IsPressed() && Time.time >= _projectileTime) {
            _projectileTime = Time.time + 1f / projectileRate;
            ShootProjectile();
        }

        if(!_isDashing) {
            _dashDowntime += Time.deltaTime / dashCooldown;
            _dashDowntime = Mathf.Clamp(_dashDowntime, 0, 1f);
        }
        dashUI.fillAmount = _dashDowntime;

        _camera.transform.localEulerAngles = Vector3.right * _cameraPitch + Vector3.forward * _currentTilt;
        transform.Rotate(Vector3.up * _currentDelta.x * lookSensitivity);
    }

    private void ShootProjectile() {
        Ray projectileRay = _camera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0));
        RaycastHit projectileHit;

        if (Physics.Raycast(projectileRay, out projectileHit, ~projectileLayer)) {
            _projectileDestination = projectileHit.point;
        } else {
            _projectileDestination = projectileRay.GetPoint(1000);
        }

        GameObject projectile = Instantiate(projectilePrefab, projectileSpawn.position, _camera.transform.rotation);
        Vector3 projectileOffset = new Vector3(Random.Range(-projectileSway * 10f, projectileSway * 10f), Random.Range(-projectileSway * 10f, projectileSway * 10f), Random.Range(-projectileSway * 10f, projectileSway * 10f));
        projectile.GetComponent<Rigidbody>().velocity = (_projectileDestination - projectileSpawn.position + projectileOffset).normalized * projectileSpeed;
    }
}
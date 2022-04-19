using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour {
    [Header("Movement")]
    [SerializeField] private float moveSpeed = 8f;
    [SerializeField] private float jumpHeight = 2f;
    [SerializeField] private float gravityScale = 1f;
    [SerializeField] private float moveSmoothTime = 0.05f;

    [Header("Look")]
    [SerializeField] private float lookSensitivity = 0.1f;
    [SerializeField] private float lookTiltAmount = 1.2f;
    [SerializeField] private float lookSmoothTime = 0.03f;
    [SerializeField] private float tiltSmoothTime = 0.1f;

    private PlayerInput _input;
    private Rigidbody _rbody;
    private Camera _camera;

    private float _cameraPitch = 0f;
    private float _cameraTilt = 0f;
    private Vector3 _moveDirection;

    private Vector2 _currentDirection, _currentDirectionVelocity;
    private Vector2 _currentDelta, _currentDeltaVelocity;
    private float _currentTilt, _currentTiltVelocity;

    private void Awake() {
        _input = new PlayerInput();
        _rbody = GetComponent<Rigidbody>();
        _camera = GetComponentInChildren<Camera>();

        _rbody.freezeRotation = true;

        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void OnEnable() {
        _input.Enable();
    }

    private void OnDisable() {
        _input.Disable();
    }

    private void HandleMovement() {
        Vector2 targetDirection = _input.Player.Movement.ReadValue<Vector2>();

        _currentDirection = Vector2.SmoothDamp(_currentDirection, targetDirection, ref _currentDirectionVelocity, moveSmoothTime);
        _moveDirection = transform.TransformDirection(new Vector3(_currentDirection.x, 0, _currentDirection.y));

        if(_input.Player.Jump.triggered) {
            float jumpForce = Mathf.Sqrt(jumpHeight * -2f * (Physics.gravity.y * gravityScale));
            _rbody.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        }
    }

    private void HandleLook() {
        Vector2 targetDelta = _input.Player.Look.ReadValue<Vector2>();

        _currentDelta = Vector2.SmoothDamp(_currentDelta, targetDelta, ref _currentDeltaVelocity, lookSmoothTime);

        _cameraPitch -= _currentDelta.y * lookSensitivity;
        _cameraPitch = Mathf.Clamp(_cameraPitch, -90f, 90f);

        _cameraTilt = _currentDirection.x < -0.1f ? lookTiltAmount : _currentDirection.x > 0.1f ? -lookTiltAmount : 0f;
        _currentTilt = Mathf.SmoothDamp(_currentTilt, _cameraTilt, ref _currentTiltVelocity, tiltSmoothTime);

        // Applying look transforms, move it somewhere else to fix the camera jitter!
        _camera.transform.localEulerAngles = Vector3.right * _cameraPitch + Vector3.forward * _currentTilt;
        transform.Rotate(Vector3.up * _currentDelta.x * lookSensitivity);
    }

    private void Update() {
        HandleMovement();
        HandleLook();
    }

    private void FixedUpdate() {
        // Additional gravity to differ jump / fall curves
        _rbody.AddForce(Physics.gravity * (gravityScale - 1f) * _rbody.mass);

        // Applying inputs to rigidbody
        _rbody.MovePosition(_rbody.position + _moveDirection * moveSpeed * Time.fixedDeltaTime);
    }
}
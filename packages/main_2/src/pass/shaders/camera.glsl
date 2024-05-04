layout(std140, set = 2, binding = 0) uniform Camera {
  vec4 cameraPosition;
  mat4 viewMatrix;
  mat4 projectionMatrix;
  mat4 lastViewProjectionMatrix;
}
uCamera;

vec3 getViewDir(vec3 worldPosition) {
  return normalize(worldPosition - vec3(uCamera.cameraPosition));
}

mat4 getViewMatrix() { return uCamera.viewMatrix; }

mat4 getProjectionMatrix() { return uCamera.projectionMatrix; }

mat4 getLastViewProjectionMatrix() { return uCamera.lastViewProjectionMatrix; }
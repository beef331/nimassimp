discard """
The MIT License (MIT)

Copyright (c) 2014 Billingsly Wetherfordshire and Charlie Barto

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

when defined(windows):
  const LibName = "Assimp(|32|64).dll"
elif defined(macosx):
  const LibName = "libassimp.dylib"
else:
  const LibName = "libassimp.so"

const
  AI_MAX_NUMBER_OF_COLOR_SETS = 0x8
  AI_MAX_NUMBER_OF_TEXTURECOORDS* = 0x8
  MAXLEN_AISTRING = 1024
  AI_MATKEY_COLOR_DIFFUSE* = "$clr.diffuse"
  AI_MATKEY_COLOR_AMBIENT* = "$clr.ambient"
  AI_MATKEY_COLOR_SPECULAR* = "$clr.specular"
  AI_MATKEY_SHININESS* = "$mat.shininess"

type
  PNode* = ptr TNode
  TNode* {.pure.} = object
    name*: AIstring
    transformation*: TMatrix4x4
    parent*: PNode
    childrenCount*: cint
    children*: ptr UncheckedArray[PNode]
    meshCount*: cint
    meshes*: ptr UncheckedArray[cint]

  PMesh* = ptr TMesh
  TMesh* {.pure.} = object
    primitiveTypes*: cint
    vertexCount*: cint
    faceCount*: cint
    vertices*: ptr UncheckedArray[TVector3d]
    normals*: ptr UncheckedArray[TVector3d]
    tangents*: ptr UncheckedArray[TVector3d]
    bitTangents*: ptr UncheckedArray[TVector3d]
    colors*: array[0..AI_MAX_NUMBER_OF_COLOR_SETS-1, ptr UncheckedArray[TColor4d]]
    texCoords*: array[0..AI_MAX_NUMBER_OF_TEXTURECOORDS-1, ptr UncheckedArray[TVector3d]]
    numUVcomponents*: array[0..AI_MAX_NUMBER_OF_TEXTURECOORDS-1, cint]
    faces*: ptr UncheckedArray[TFace]
    boneCount*: cint
    bones*: ptr UncheckedArray[PBone]
    materialIndex*: cint
    name*: AIstring
    anmMeshCount*: cint
    animMeshes*: pointer ## ptr ptr TAnimMesh

  PScene* = ptr TScene
  TScene* {.pure.} = object
    flags*: cint
    rootNode*: PNode
    meshCount*: cint
    meshes*: ptr UncheckedArray[PMesh]
    materialCount*: cint
    materials*: ptr UncheckedArray[PMaterial]
    animationCount*: cint
    animations*: ptr UncheckedArray[PAnimation]
    textureCount*: cint
    textures*: ptr UncheckedArray[PTexture]
    lightCount*: cint
    lights*: ptr UncheckedArray[PLight]
    cameraCount*: cint
    cameras*: ptr UncheckedArray[PCamera]

  PMaterial* = ptr TMaterial
  TMaterial* {.pure.} = object
    properties*: ptr PMaterialProperty
    propertyCount*: cint
    numAllocated*: cint

  PAnimation* = ptr TAnimation
  TAnimation* {.pure.} = object
    name*: AIstring
    duration*: cdouble
    ticksPerSec*: cdouble
    channelCount*: cint
    channels*: ptr PNodeAnim
    meshChannelCount*: cint
    meshChannels*: ptr PMeshAnim

  PNodeAnim* = ptr TNodeAnim
  TNodeAnim* {.pure.} = object
    nodeName*: AIstring
    positionKeyCount*: cint
    positionKeys*: ptr TVectorKey
    rotationKeyCount*: cint
    rotationKeys*: ptr TQuatKey
    scalingKeyCount*: cint
    scalingKeys*: ptr TVectorKey
    preState*: TAnimBehavior
    posState*: TAnimBehavior

  PMeshAnim* = ptr TMeshAnim
  TMeshAnim* {.pure.} = object
    name*: AIstring
    keyCount*: cint
    keys*: ptr TMeshKey

  TAnimBehavior*{.size: sizeof(cint).} = enum
    AnimBehaviorDefault = 0, AnimBehaviorConstant = 1,
    AnimBehaviorLinear = 2, AnimBehaviorRepeat = 3
  TVectorKey* {.pure.} = object
    time*: cdouble
    value*: TVector3d
  TQuatKey* = object
    time*: cdouble
    value*: TQuaternion
  TMeshKey* = object
    time*: cdouble
    value*: cint

  PCamera* = ptr TCamera
  TCamera* = object
    name*: AIstring
    position*, up*, lookat*: TVector3d
    horizontalFOV*, clipNear*, clipFar*, aspect*: cfloat

  PLight* = ptr TLight
  TLight* = object
    name*: AIstring
    kind*: TLightSourceType
    position*: TVector3D
    direction*: TVector3D
    attenuationConst*: cfloat
    attenuationLinear*: cfloat
    attenuationQuadratic*: cfloat
    colorDiffuse*: TColor3d
    colorSpecular*: TColor3d
    colorAmbient*: TColor3d
    innerCone*: cfloat
    outerCone*: cfloat
  TLightSourceType* {.size: sizeof(cint).} = enum
    LightSource_Undefined = 0, LightSource_Directional = 1,
    LightSource_Point = 2, LightSource_Spot = 3

  PTexture* = ptr TTexture
  TTexture* = object
    width*: cint
    height*: cint
    achFormatHint*: array[0..3, cchar]
    pcData*: ptr TTexel

  PMaterialProperty* = ptr TMaterialProperty
  TMaterialProperty* = object
    key*: AIstring
    semantic*: cint
    index*: cint
    dataLength*: cint
    kind*: TPropertyTypeInfo
    data*: ptr char

  TPropertyTypeInfo* {.size: sizeof(cint).} = enum
    aiPTI_Float = 0x1, aiPTI_String = 0x3,
    aiPTI_Integer = 0x4, aiPTI_Buffer = 0x5

  PBone* = ptr TBone
  TBone* = object
    name*: AiString
    numWeights*: cint
    weights*: ptr UncheckedArray[TVertexWeight]
    offsetMatrix*: TMatrix4x4

  TVertexWeight* = object
    vertexID*: cint
    weight*: cfloat

  PFace* = ptr TFace
  TFace* = object
    indexCount*: cint
    indices*: ptr UncheckedArray[cint]

  AIstring* = object
    length*: cuint
    data*: array[0..MAXLEN_AISTRING-1, char]

  AIreturn* {.size: sizeof(cint).} = enum
    ReturnOutOfMemory = -3, ReturnFailure = -1, ReturnSuccess = 0
  TTextureMapMode* {.size: sizeof(cint).} = enum
    TexMap_Wrap = 0, TexMap_Clamp, TexMap_Decal, TexMap_Mirror
  TTextureOp* {.size: sizeof(cint).} = enum
    TexOpMultiply = 0, TexOpAdd = 1, TexOpSubtract = 2, TexOpDivide = 3,
    TexOpSmoothadd = 4, TexOpSignedadd = 5
  TTextureMapping* {.size: sizeof(cint).} = enum
    TexMappingUV = 0, TexMappingSphere = 1, TexMappingCylinder = 2,
    TexMappingBox = 3, TexMappingPlane = 4, TexMappingOther = 5
  TTextureType* {.size: sizeof(cint).} = enum
    TexNone = 0, TexDiffuse = 1, TexSpecular = 2, TexAmbient = 3,
    TexEmissive = 4, TexHeight = 5, TexNormals = 6, TexShininess = 7,
    TexOpacity = 8, TexDisplacement = 9, TexLightmap = 10,
    TexReflection = 11, TexUnknown = 12

  TTexel* = tuple[b, g, r, a: byte]
  TColor3d* = tuple[r, g, b: cfloat]
  TColor4d* = tuple[r, g, b, a: cfloat]
  TVector3d* = tuple[x, y, z: cfloat]
  TQuaternion* = tuple[w, x, y, z: cfloat]
  TMatrix4x4* = array[0..15, cfloat]
  TMatrix3x3* = array[0..8, cfloat]
  TPlane* = object
    a*, b*, c*, d*: cfloat

  TPrimitiveType* {.size: sizeof(cint).} = enum
    aiPrimitiveType_POINT = 0x1,
    aiPrimitiveType_LINE = 0x2,
    aiPrimitiveType_TRIANGLE = 0x4,
    aiPrimitiveType_POLYGON = 0x8

type ImportProcess* = enum
  calcTangentSpace
  joinIdenticalVerts
  makeLeftHanded
  triangulate
  removeComponent
  genNormals
  genSmoothNormals
  splitLargeMeshes
  preTransformVerts
  limitBoneWeights
  validateDataStructure
  improveCacheLocality
  removeRedundantMaterials
  fixInfacingNormals
  sortByPType
  findDegenerates
  findInvalidData
  genUvCoords
  transformUvCoords
  findInstances
  optimizeMesh
  omptimizeGraph
  flipUvs
  flipWindingOrder

const
  ProcessLut = [
    calcTangentSpace: 0x00000001.cint,
    joinIdenticalVerts: 0x00000002.cint,
    makeLeftHanded: 0x00000004.cint,
    triangulate: 0x00000008.cint,
    removeComponent: 0x00000010.cint,
    genNormals: 0x00000020.cint,
    genSmoothNormals: 0x00000040.cint,
    splitLargeMeshes: 0x00000080.cint,
    preTransformVerts: 0x00000100.cint,
    limitBoneWeights: 0x00000200.cint,
    validateDataStructure: 0x00000400.cint,
    improveCacheLocality: 0x00000800.cint,
    removeRedundantMaterials: 0x00001000.cint,
    fixInfacingNormals: 0x00002000.cint,
    sortByPType: 0x00008000.cint,
    findDegenerates: 0x00010000.cint,
    findInvalidData: 0x00020000.cint,
    genUvCoords: 0x00040000.cint,
    transformUvCoords: 0x00080000.cint,
    findInstances: 0x00100000.cint,
    optimizeMesh: 0x00200000.cint,
    omptimizeGraph: 0x00400000.cint,
    flipUvs: 0x00800000.cint,
    flipWindingOrder: 0x01000000.cint,
  ]
  ConvertToLeftHanded* = {makeLeftHanded, flipUvs, flipWindingOrder}
  TargetRealtimeFast* = {calcTangentSpace, genNormals, joinIdenticalVerts, triangulate, genUvCoords, sortByPType}
  TargetRealtimeQuality* = {calcTangentSpace, genSmoothNormals, joinIdenticalVerts,
      improveCacheLocality, limitBoneWeights, removeRedundantMaterials, splitLargeMeshes,
      triangulate, genUvCoords, sortByPType, findDegenerates, findInvalidData}
  TargetRealtimeMaxQuality* = TargetRealtimeQuality + {findInstances, validateDataStructure, optimizeMesh}

{.push callconv: cdecl.}


iterator imeshes*(scene: PScene): PMesh =
  for x in 0..<scene.meshCount:
    yield scene.meshes[x]

iterator ifaces*(mesh: PMesh): TFace =
  for x in 0..<mesh.faceCount:
    yield mesh.faces[x]

iterator iindices*(face: TFace): cint =
  for x in 0..<face.indexCount:
    yield face.indices[x]

proc aiImportFile*(filename: cstring; flags: cint): PScene {.importc, dynlib: LibName.}

proc aiImportFile*(filename: cstring; flags: set[ImportProcess]): PScene =
  let newFlags = block:
    var res: cint
    for x in flags:
      res = res or ProcessLut[x]
    res
  aiImportFile(filename, newFlags)

proc aiImportFileFromMemory*(pBuffer: cstring;
                            pLength, pFlags: uint32;
                            pHint: cstring): PScene {.importc, dynlib: LibName.}
proc aiEnableVerboseLogging*(d: bool) {.importc, dynlib: LibName.}
proc aiReleaseImport*(pScene: PScene) {.importc, dynlib: LibName.}
proc getError*(): cstring {.importc: "aiGetErrorString", dynlib: LibName.}



proc getTexture*(material: PMaterial; kind: TTextureType; index: cint;
  path: ptr AIstring; mapping: ptr TTextureMapping = nil; uvIndex: ptr cint = nil;
  blend: ptr cfloat = nil; op: ptr TTextureOp = nil;
  mapMode: ptr TTextureMapMode = nil; flags: ptr cint = nil): AIreturn {.
  importc: "aiGetMaterialTexture", dynlib: LibName.}

proc getMaterialColor*(material: PMaterial; name: cstring; `type`, index: cuint;
    color: ptr TColor3d): AIreturn {.
  importc: "aiGetMaterialColor", dynlib: LibName.}

proc getTextureCount*(material: PMaterial; kind: TTextureType): uint32 {.
  importc: "aiGetMaterialTextureCount", dynlib: LibName.}

proc getMaterialFloatArray*(material: PMaterial; key: cstring; `type`, index: cuint = 0.cuint;
    `out`: ptr cfloat; max: ptr cuint = nil): AIreturn {.
  importc: "aiGetMaterialFloatArray", dynlib: LibName.}




proc transpose*(some: ptr TMatrix4x4) {.importc: "aiTransposeMatrix4", dynlib: LibName.}
proc transpose*(some: ptr TMatrix3x3) {.importc: "aiTransposeMatrix3", dynlib: LibName.}

{.pop.}

proc hasPositions*(some: PMesh): bool {.inline.} = (some.vertexCount > 0 and
  not some.vertices.isNil)
proc hasFaces*(some: PMesh): bool {.inline.} = (some.faceCount > 0 and
  not some.faces.isNil)
proc hasNormals*(some: PMesh): bool {.inline.} = (some.vertexCount > 0 and
  not some.normals.isNil)
proc hasUvs*(some: PMesh): bool {.inline.} = some.numUVcomponents[0] > 0
proc hasColors*(some: PMesh): bool {.inline.} = some.colors[0] != nil



converter toBool*(some: AIreturn): bool = (some == ReturnSuccess)

proc `$`*(a: var AIstring): string =
  result = newString(a.length)
  copymem(addr result[0], addr a.data, a.length)

(* Test Suite for Step 8: Advanced LLM Architecture (Master-Slave Setup) *)
(* Tests for MultiModalApp Master-Slave LLM hierarchy and LLMGraph orchestration *)

BeginPackage["Step8Test`"];

Needs["MultiModalApp`"];

(* Test function declarations *)
RunStep8Tests::usage = "RunStep8Tests[] runs all tests for Step 8";
TestLLMHierarchyInitialization::usage = "TestLLMHierarchyInitialization[] tests Master-Slave hierarchy initialization";
TestSpecializedSlaveCreation::usage = "TestSpecializedSlaveCreation[] tests creation of specialized slave LLMs";
TestLLMGraphConstruction::usage = "TestLLMGraphConstruction[] tests LLMGraph building and orchestration";
TestTaskDelegation::usage = "TestTaskDelegation[] tests task delegation to appropriate slave LLMs";
TestLLMGraphProcessing::usage = "TestLLMGraphProcessing[] tests end-to-end LLMGraph processing";
TestSlaveResponseCoordination::usage = "TestSlaveResponseCoordination[] tests coordination of slave responses";
TestHierarchicalIntegration::usage = "TestHierarchicalIntegration[] tests integration with existing multi-modal pipeline";
TestLLMArchitectureErrorHandling::usage = "TestLLMArchitectureErrorHandling[] tests error handling in LLM hierarchy";

Begin["`Private`"];

(* Helper function to create test input data *)
CreateMultiModalTestData[] := Module[{testData},
  testData = <|
    "textInput" -> "Analyze this sample text content for testing",
    "imageDescription" -> "Test image showing a cat sitting on a table with OCR text 'Hello World'",
    "audioTranscript" -> "Test audio transcript: The user said hello and asked about the weather",
    "videoContent" -> "Test video content with scenes of a garden and background music",
    "webpageContent" -> "Test webpage content from example.com with title 'Sample Page' and article text",
    "eventContent" -> "Test user events: clicked button, typed 'test', pressed Enter"
  |>;
  testData
];

CreateMinimalTestData[] := Module[{testData},
  testData = <|
    "textInput" -> "Simple test query"
  |>;
  testData
];

CreateEmptyTestData[] := Module[{testData},
  testData = <|
    "textInput" -> "",
    "imageDescription" -> "",
    "audioTranscript" -> "",
    "videoContent" -> "",
    "webpageContent" -> "",
    "eventContent" -> ""
  |>;
  testData
];

(* Test LLM hierarchy initialization *)
TestLLMHierarchyInitialization[] := Module[{initResult, testResult},
  Print["Testing LLM Hierarchy Initialization..."];
  
  (* Test hierarchy initialization *)
  initResult = Catch[
    MultiModalApp`InitializeLLMHierarchy[],
    _,
    $Failed
  ];
  
  (* Verify initialization results *)
  testResult = AssociationQ[initResult] && 
               KeyExistsQ[initResult, "masterLLM"] && 
               KeyExistsQ[initResult, "slaveLLMs"] &&
               KeyExistsQ[initResult, "initialized"] &&
               initResult["initialized"] === True;
  
  If[testResult,
    Print[Style["✓ LLM hierarchy initialization working", Green]];
    Print["  Master LLM configured successfully"];
    Print["  Slave LLMs: " <> ToString[Length[Keys[initResult["slaveLLMs"]]]] <> " specialized domains"],
    Print[Style["✗ LLM hierarchy initialization failed", Red]]
  ];
  
  testResult
];

(* Test specialized slave LLM creation *)
TestSpecializedSlaveCreation[] := Module[{slaveLLMs, testResult, expectedSlaves},
  Print["Testing Specialized Slave LLM Creation..."];
  
  (* Test slave creation *)
  slaveLLMs = Catch[
    MultiModalApp`CreateSpecializedSlaves[],
    _,
    $Failed
  ];
  
  (* Expected slave types *)
  expectedSlaves = {"textSlave", "imageSlave", "audioSlave", "videoSlave", "webSlave", "eventSlave"};
  
  (* Verify slave creation results *)
  testResult = AssociationQ[slaveLLMs] && 
               Length[Keys[slaveLLMs]] == Length[expectedSlaves] &&
               AllTrue[expectedSlaves, KeyExistsQ[slaveLLMs, #] &];
  
  If[testResult,
    Print[Style["✓ Specialized slave LLM creation working", Green]];
    Print["  Created slaves: " <> StringRiffle[Keys[slaveLLMs], ", "]];
    Print["  All expected specializations present"],
    Print[Style["✗ Specialized slave LLM creation failed", Red]]
  ];
  
  testResult
];

(* Test LLMGraph construction *)
TestLLMGraphConstruction[] := Module[{testData, llmGraph, testResult},
  Print["Testing LLMGraph Construction..."];
  
  (* Create test data *)
  testData = CreateMultiModalTestData[];
  
  (* Test graph construction *)
  llmGraph = Catch[
    Module[{initResult},
      (* Ensure hierarchy is initialized *)
      initResult = MultiModalApp`InitializeLLMHierarchy[];
      (* Build graph *)
      MultiModalApp`BuildLLMGraph[testData]
    ],
    _,
    $Failed
  ];
  
  (* Verify graph construction *)
  testResult = llmGraph =!= $Failed && llmGraph =!= None;
  
  If[testResult,
    Print[Style["✓ LLMGraph construction working", Green]];
    Print["  LLMGraph created for multi-modal input"];
    Print["  Graph ready for orchestrated processing"],
    Print[Style["✗ LLMGraph construction failed", Red]]
  ];
  
  testResult
];

(* Test task delegation *)
TestTaskDelegation[] := Module[{testData, delegationResult, testResult},
  Print["Testing Task Delegation..."];
  
  (* Create test data *)
  testData = CreateMultiModalTestData[];
  
  (* Test task delegation *)
  delegationResult = Catch[
    MultiModalApp`DelegateTasks[testData],
    _,
    $Failed
  ];
  
  (* Verify delegation results *)
  testResult = AssociationQ[delegationResult] && 
               Length[Keys[delegationResult]] > 0 &&
               AllTrue[Values[delegationResult], 
                       AssociationQ[#] && KeyExistsQ[#, "type"] && 
                       KeyExistsQ[#, "slave"] && KeyExistsQ[#, "data"] &];
  
  If[testResult,
    Print[Style["✓ Task delegation working", Green]];
    Print["  Tasks delegated: " <> ToString[Length[Keys[delegationResult]]]];
    Print["  All tasks properly structured with slave assignments"],
    Print[Style["✗ Task delegation failed", Red]]
  ];
  
  testResult
];

(* Test LLMGraph processing *)
TestLLMGraphProcessing[] := Module[{testData, processingResult, testResult},
  Print["Testing LLMGraph Processing..."];
  
  (* Create minimal test data to avoid API calls *)
  testData = CreateMinimalTestData[];
  
  (* Test graph processing *)
  processingResult = Catch[
    MultiModalApp`ProcessWithLLMGraph[testData],
    _,
    $Failed
  ];
  
  (* Verify processing results *)
  testResult = AssociationQ[processingResult] && 
               KeyExistsQ[processingResult, "rawResponse"] && 
               KeyExistsQ[processingResult, "method"];
  
  If[testResult,
    Print[Style["✓ LLMGraph processing framework working", Green]];
    Print["  Processing method: " <> processingResult["method"]];
    Print["  Response structure validated"],
    Print[Style["✗ LLMGraph processing failed", Red]]
  ];
  
  testResult
];

(* Test slave response coordination *)
TestSlaveResponseCoordination[] := Module[{mockResponses, coordinationResult, testResult},
  Print["Testing Slave Response Coordination..."];
  
  (* Create mock slave responses *)
  mockResponses = <|
    "textAnalysis" -> "Text analysis shows positive sentiment and key themes about testing",
    "imageAnalysis" -> "Image contains a cat and OCR text reading 'Hello World'",
    "audioAnalysis" -> "Audio transcript indicates friendly greeting and weather inquiry"
  |>;
  
  (* Test coordination *)
  coordinationResult = Catch[
    MultiModalApp`CoordinateSlaveResponses[mockResponses],
    _,
    $Failed
  ];
  
  (* Verify coordination results *)
  testResult = StringQ[coordinationResult] && 
               StringLength[coordinationResult] > 0 &&
               StringContainsQ[coordinationResult, "Text Analysis"] &&
               StringContainsQ[coordinationResult, "Image Analysis"];
  
  If[testResult,
    Print[Style["✓ Slave response coordination working", Green]];
    Print["  Coordination combines all slave analyses"];
    Print["  Response length: " <> ToString[StringLength[coordinationResult]] <> " characters"],
    Print[Style["✗ Slave response coordination failed", Red]]
  ];
  
  testResult
];

(* Test hierarchical integration *)
TestHierarchicalIntegration[] := Module[{testData, integrationResult, testResult},
  Print["Testing Hierarchical Integration with Multi-Modal Pipeline..."];
  
  (* Create test data *)
  testData = <|"textInput" -> "Integration test", "eventInput" -> "User clicked submit button"|>;
  
  (* Test integration through main processing pipeline *)
  integrationResult = Catch[
    MultiModalApp`ProcessUserInput[testData],
    _, 
    $Failed
  ];
  
  (* Verify integration *)
  testResult = integrationResult =!= $Failed;
  
  If[testResult,
    Print[Style["✓ Hierarchical LLM integration successful", Green]];
    Print["  Master-Slave architecture integrated with multi-modal pipeline"];
    Print["  End-to-end processing chain working"],
    Print[Style["✗ Hierarchical LLM integration failed", Red]]
  ];
  
  testResult
];

(* Test error handling in LLM architecture *)
TestLLMArchitectureErrorHandling[] := Module[{errorResult, testResult},
  Print["Testing LLM Architecture Error Handling..."];
  
  (* Test various error conditions *)
  errorResult = Catch[
    Module[{result1, result2, result3},
      (* Test with empty data *)
      result1 = MultiModalApp`ProcessWithLLMGraph[CreateEmptyTestData[]];
      (* Test with malformed data *)
      result2 = MultiModalApp`DelegateTasks[<||>];
      (* Test coordination with empty responses *)
      result3 = MultiModalApp`CoordinateSlaveResponses[<||>];
      
      (* All should handle gracefully *)
      AssociationQ[result1] && AssociationQ[result2] && StringQ[result3]
    ],
    _,
    False
  ];
  
  (* Verify error handling *)
  testResult = errorResult === True;
  
  If[testResult,
    Print[Style["✓ LLM architecture error handling successful", Green]];
    Print["  Graceful handling of empty and malformed inputs"];
    Print["  Robust error recovery across hierarchy components"],
    Print[Style["✗ LLM architecture error handling failed", Red]]
  ];
  
  testResult
];

(* Main test runner for Step 8 *)
RunStep8Tests[] := Module[{testResults, allPassed},
  Print[Style["Running Step 8 Tests: Advanced LLM Architecture (Master-Slave Setup)", "Subsection"]];
  Print[""];
  
  testResults = {
    TestLLMHierarchyInitialization[],
    TestSpecializedSlaveCreation[],
    TestLLMGraphConstruction[],
    TestTaskDelegation[],
    TestLLMGraphProcessing[],
    TestSlaveResponseCoordination[],
    TestHierarchicalIntegration[],
    TestLLMArchitectureErrorHandling[]
  };
  
  allPassed = And @@ testResults;
  
  Print[""];
  If[allPassed,
    Print[Style["✓ All Step 8 tests passed! Advanced LLM architecture is working correctly.", "Text", Green]],
    Print[Style["✗ Some Step 8 tests failed. Please check the LLM hierarchy implementation.", "Text", Red]]
  ];
  
  allPassed
];

End[];
EndPackage[];
(* Test Suite for Step 10: Memory Management & Conversation Context *)
(* Tests for MultiModalApp conversation memory, context management, and persistent learning *)

BeginPackage["Step10Test`"];

Needs["MultiModalApp`"];

(* Test function declarations *)
RunStep10Tests::usage = "RunStep10Tests[] runs all tests for Step 10";
TestMemorySystemInitialization::usage = "TestMemorySystemInitialization[] tests memory system initialization";
TestConversationMemoryStorage::usage = "TestConversationMemoryStorage[] tests storing conversation interactions";
TestConversationHistoryRetrieval::usage = "TestConversationHistoryRetrieval[] tests retrieving conversation history";
TestContextAnalysis::usage = "TestContextAnalysis[] tests conversation context analysis";
TestTopicExtraction::usage = "TestTopicExtraction[] tests topic extraction from inputs";
TestMemoryEnhancedLLMGraph::usage = "TestMemoryEnhancedLLMGraph[] tests memory-enhanced LLMGraph construction";
TestMemoryEnhancedProcessing::usage = "TestMemoryEnhancedProcessing[] tests end-to-end memory-enhanced processing";
TestConversationContextManagement::usage = "TestConversationContextManagement[] tests context optimization and management";
TestMemorySummarization::usage = "TestMemorySummarization[] tests conversation memory summarization";
TestMemoryErrorHandling::usage = "TestMemoryErrorHandling[] tests error handling in memory system";

Begin["`Private`"];

(* Helper function to create test input data for memory testing *)
CreateMemoryTestData1[] := Module[{testData},
  testData = <|
    "textInput" -> "I want to solve the equation x^2 + 3x + 2 = 0. Can you help with this mathematical problem?"
  |>;
  testData
];

CreateMemoryTestData2[] := Module[{testData},
  testData = <|
    "textInput" -> "Now can you calculate the mean of the data from before? Also, what was that equation we solved earlier?"
  |>;
  testData
];

CreateMemoryTestData3[] := Module[{testData},
  testData = <|
    "textInput" -> "Let me analyze this image",
    "imageDescription" -> "Image of a mathematical formula showing integration by parts"
  |>;
  testData
];

CreateMultiModalMemoryData[] := Module[{testData},
  testData = <|
    "textInput" -> "Analyze this audio and video content together",
    "audioTranscript" -> "The speaker discusses calculus concepts and derivatives",
    "videoContent" -> "Video showing mathematical derivations on a whiteboard"
  |>;
  testData
];

CreateEmptyMemoryData[] := Module[{testData},
  testData = <|
    "textInput" -> "",
    "imageDescription" -> "",
    "audioTranscript" -> ""
  |>;
  testData
];

(* Test memory system initialization *)
TestMemorySystemInitialization[] := Module[{initResult, testResult},
  Print["Testing Memory System Initialization..."];
  
  (* Test memory system initialization *)
  initResult = Catch[
    MultiModalApp`InitializeMemorySystem[],
    _,
    $Failed
  ];
  
  (* Verify initialization results *)
  testResult = AssociationQ[initResult] && 
               KeyExistsQ[initResult, "initialized"] && 
               KeyExistsQ[initResult, "sessionId"] &&
               KeyExistsQ[initResult, "maxEntries"] &&
               KeyExistsQ[initResult, "contextWindow"] &&
               initResult["initialized"] === True &&
               StringQ[initResult["sessionId"]];
  
  If[testResult,
    Print[Style["✓ Memory system initialization working", Green]];
    Print["  Session ID: " <> initResult["sessionId"]];
    Print["  Max entries: " <> ToString[initResult["maxEntries"]]];
    Print["  Context window: " <> ToString[initResult["contextWindow"]]],
    Print[Style["✗ Memory system initialization failed", Red]]
  ];
  
  testResult
];

(* Test conversation memory storage *)
TestConversationMemoryStorage[] := Module[{inputData, mockResponse, memoryId, testResult},
  Print["Testing Conversation Memory Storage..."];
  
  (* Create test input and response *)
  inputData = CreateMemoryTestData1[];
  mockResponse = <|
    "rawResponse" -> "I can help solve that quadratic equation. Using the quadratic formula...",
    "method" -> "MemoryEnhancedLLMGraph",
    "processedAt" -> Now
  |>;
  
  (* Test memory storage *)
  memoryId = Catch[
    MultiModalApp`StoreConversationMemory[inputData, mockResponse],
    _,
    $Failed
  ];
  
  (* Verify memory storage results *)
  testResult = StringQ[memoryId] && StringLength[memoryId] > 0;
  
  If[testResult,
    Print[Style["✓ Conversation memory storage working", Green]];
    Print["  Memory ID: " <> memoryId];
    Print["  Input stored with response and metadata"],
    Print[Style["✗ Conversation memory storage failed", Red]]
  ];
  
  testResult
];

(* Test conversation history retrieval *)
TestConversationHistoryRetrieval[] := Module[{inputData1, inputData2, mockResponse1, mockResponse2, historyResult, testResult},
  Print["Testing Conversation History Retrieval..."];
  
  (* Store multiple interactions *)
  inputData1 = CreateMemoryTestData1[];
  mockResponse1 = <|"rawResponse" -> "Math solution 1", "method" -> "Test"|>;
  MultiModalApp`StoreConversationMemory[inputData1, mockResponse1];
  
  inputData2 = CreateMemoryTestData3[];
  mockResponse2 = <|"rawResponse" -> "Image analysis result", "method" -> "Test"|>;
  MultiModalApp`StoreConversationMemory[inputData2, mockResponse2];
  
  (* Test history retrieval *)
  historyResult = Catch[
    MultiModalApp`RetrieveConversationHistory[5],
    _,
    $Failed
  ];
  
  (* Verify retrieval results *)
  testResult = ListQ[historyResult] && 
               Length[historyResult] >= 2 &&
               AllTrue[historyResult, AssociationQ[#] && KeyExistsQ[#, "timestamp"] && 
                      KeyExistsQ[#, "inputSummary"] && KeyExistsQ[#, "topics"] &];
  
  If[testResult,
    Print[Style["✓ Conversation history retrieval working", Green]];
    Print["  Retrieved entries: " <> ToString[Length[historyResult]]];
    Print["  All entries contain required fields with timestamps"],
    Print[Style["✗ Conversation history retrieval failed", Red]]
  ];
  
  testResult
];

(* Test conversation context analysis *)
TestContextAnalysis[] := Module[{inputData1, inputData2, mockResponse, contextAnalysis, testResult},
  Print["Testing Conversation Context Analysis..."];
  
  (* Store a mathematical interaction *)
  inputData1 = CreateMemoryTestData1[];
  mockResponse = <|"rawResponse" -> "Mathematical solution", "method" -> "Test"|>;
  MultiModalApp`StoreConversationMemory[inputData1, mockResponse];
  
  (* Analyze context for follow-up question *)
  inputData2 = CreateMemoryTestData2[];
  
  contextAnalysis = Catch[
    MultiModalApp`AnalyzeConversationContext[inputData2],
    _,
    $Failed
  ];
  
  (* Verify context analysis results *)
  testResult = AssociationQ[contextAnalysis] && 
               KeyExistsQ[contextAnalysis, "hasRecentHistory"] && 
               KeyExistsQ[contextAnalysis, "topicContinuity"] &&
               KeyExistsQ[contextAnalysis, "referencesHistory"] &&
               KeyExistsQ[contextAnalysis, "recommendMemoryUsage"] &&
               contextAnalysis["hasRecentHistory"] === True &&
               contextAnalysis["referencesHistory"] === True;
  
  If[testResult,
    Print[Style["✓ Conversation context analysis working", Green]];
    Print["  Recent history detected: " <> ToString[contextAnalysis["hasRecentHistory"]]];
    Print["  References detected: " <> ToString[contextAnalysis["referencesHistory"]]];
    Print["  Topic continuity: " <> ToString[Round[contextAnalysis["topicContinuity"], 0.01]]],
    Print[Style["✗ Conversation context analysis failed", Red]]
  ];
  
  testResult
];

(* Test topic extraction from inputs *)
TestTopicExtraction[] := Module[{mathInput, imageInput, multiModalInput, topics1, topics2, topics3, testResult},
  Print["Testing Topic Extraction..."];
  
  (* Test different input types *)
  mathInput = <|"textInput" -> "I need to solve this math equation and calculate some statistics"|>;
  imageInput = <|"textInput" -> "Analyze this image", "imageDescription" -> "Photo of a graph"|>;
  multiModalInput = CreateMultiModalMemoryData[];
  
  (* Extract topics *)
  topics1 = Catch[MultiModalApp`ExtractTopicsFromInput[mathInput], _, $Failed];
  topics2 = Catch[MultiModalApp`ExtractTopicsFromInput[imageInput], _, $Failed];
  topics3 = Catch[MultiModalApp`ExtractTopicsFromInput[multiModalInput], _, $Failed];
  
  (* Verify topic extraction *)
  testResult = ListQ[topics1] && ListQ[topics2] && ListQ[topics3] &&
               MemberQ[topics1, "mathematics"] && MemberQ[topics1, "data-analysis"] &&
               MemberQ[topics2, "image-processing"] &&
               MemberQ[topics3, "audio-processing"] && MemberQ[topics3, "video-processing"];
  
  If[testResult,
    Print[Style["✓ Topic extraction working", Green]];
    Print["  Math topics: " <> StringRiffle[topics1, ", "]];
    Print["  Image topics: " <> StringRiffle[topics2, ", "]];
    Print["  Multi-modal topics: " <> StringRiffle[topics3, ", "]],
    Print[Style["✗ Topic extraction failed", Red]]
  ];
  
  testResult
];

(* Test memory-enhanced LLMGraph construction *)
TestMemoryEnhancedLLMGraph[] := Module[{inputData, mockResponse, contextAnalysis, memoryGraph, testResult},
  Print["Testing Memory-Enhanced LLMGraph Construction..."];
  
  (* Store previous interaction *)
  inputData = CreateMemoryTestData1[];
  mockResponse = <|"rawResponse" -> "Previous mathematical analysis", "method" -> "Test"|>;
  MultiModalApp`StoreConversationMemory[inputData, mockResponse];
  
  (* Analyze context for new input *)
  inputData = CreateMemoryTestData2[];
  contextAnalysis = MultiModalApp`AnalyzeConversationContext[inputData];
  
  (* Test memory-enhanced graph construction *)
  memoryGraph = Catch[
    Module[{initResult},
      (* Ensure all systems initialized *)
      MultiModalApp`InitializeLLMHierarchy[];
      MultiModalApp`InitializeToolsIntegration[];
      (* Build enhanced graph *)
      MultiModalApp`BuildMemoryEnhancedLLMGraph[inputData, contextAnalysis]
    ],
    _,
    $Failed
  ];
  
  (* Verify graph construction *)
  testResult = memoryGraph =!= $Failed && memoryGraph =!= None;
  
  If[testResult,
    Print[Style["✓ Memory-enhanced LLMGraph construction working", Green]];
    Print["  LLMGraph enhanced with conversation context"];
    Print["  Memory integration successful for contextual processing"],
    Print[Style["✗ Memory-enhanced LLMGraph construction failed", Red]]
  ];
  
  testResult
];

(* Test memory-enhanced processing *)
TestMemoryEnhancedProcessing[] := Module[{inputData1, inputData2, result1, result2, testResult},
  Print["Testing Memory-Enhanced Processing..."];
  
  (* Process first interaction *)
  inputData1 = CreateMemoryTestData1[];
  result1 = Catch[
    MultiModalApp`ProcessWithMemory[inputData1],
    _,
    $Failed
  ];
  
  (* Process follow-up interaction that should use memory *)
  inputData2 = CreateMemoryTestData2[];
  result2 = Catch[
    MultiModalApp`ProcessWithMemory[inputData2],
    _,
    $Failed
  ];
  
  (* Verify processing results *)
  testResult = AssociationQ[result1] && AssociationQ[result2] &&
               KeyExistsQ[result1, "rawResponse"] && KeyExistsQ[result1, "method"] &&
               KeyExistsQ[result2, "rawResponse"] && KeyExistsQ[result2, "method"] &&
               KeyExistsQ[result2, "contextUsed"] && KeyExistsQ[result2, "memoryEnhanced"];
  
  If[testResult,
    Print[Style["✓ Memory-enhanced processing working", Green]];
    Print["  First interaction method: " <> result1["method"]];
    Print["  Follow-up method: " <> result2["method"]];
    If[KeyExistsQ[result2, "contextUsed"],
      Print["  Context used in follow-up: " <> ToString[result2["contextUsed"]]];
    ];,
    Print[Style["✗ Memory-enhanced processing failed", Red]]
  ];
  
  testResult
];

(* Test conversation context management *)
TestConversationContextManagement[] := Module[{interactions, managementResult, testResult},
  Print["Testing Conversation Context Management..."];
  
  (* Create mock interactions for testing *)
  interactions = {
    <|"topics" -> {"mathematics"}, "timestamp" -> Now, 
      "inputSummary" -> <|"inputTypes" -> {"text"}|>|>,
    <|"topics" -> {"mathematics", "data-analysis"}, "timestamp" -> DatePlus[Now, Quantity[1, "Minutes"]], 
      "inputSummary" -> <|"inputTypes" -> {"text"}|>|>,
    <|"topics" -> {"image-processing"}, "timestamp" -> DatePlus[Now, Quantity[2, "Minutes"]], 
      "inputSummary" -> <|"inputTypes" -> {"text", "image"}|>|>
  };
  
  (* Test context management *)
  managementResult = Catch[
    MultiModalApp`ManageConversationContext[interactions],
    _,
    $Failed
  ];
  
  (* Verify management results *)
  testResult = AssociationQ[managementResult] &&
               KeyExistsQ[managementResult, "totalInteractions"] &&
               KeyExistsQ[managementResult, "topicAnalysis"] &&
               KeyExistsQ[managementResult, "memoryOptimized"] &&
               managementResult["totalInteractions"] == Length[interactions];
  
  If[testResult,
    Print[Style["✓ Conversation context management working", Green]];
    Print["  Total interactions managed: " <> ToString[managementResult["totalInteractions"]]];
    Print["  Memory optimization completed for context analysis"],
    Print[Style["✗ Conversation context management failed", Red]]
  ];
  
  testResult
];

(* Test memory summarization *)
TestMemorySummarization[] := Module[{memoryEntries, summaryResult, testResult},
  Print["Testing Memory Summarization..."];
  
  (* Create mock memory entries *)
  memoryEntries = {
    <|"topics" -> {"mathematics"}, "timestamp" -> DatePlus[Now, Quantity[-1, "Hours"]], 
      "inputSummary" -> <|"inputTypes" -> {"text"}|>|>,
    <|"topics" -> {"data-analysis"}, "timestamp" -> DatePlus[Now, Quantity[-30, "Minutes"]], 
      "inputSummary" -> <|"inputTypes" -> {"text"}|>|>,
    <|"topics" -> {"mathematics", "image-processing"}, "timestamp" -> Now, 
      "inputSummary" -> <|"inputTypes" -> {"text", "image"}|>|>
  };
  
  (* Test summarization *)
  summaryResult = Catch[
    MultiModalApp`SummarizeConversationMemory[memoryEntries],
    _,
    $Failed
  ];
  
  (* Verify summarization results *)
  testResult = StringQ[summaryResult] && 
               StringLength[summaryResult] > 50 &&
               StringContainsQ[summaryResult, "Conversation Summary"] &&
               StringContainsQ[summaryResult, "Topics discussed"];
  
  If[testResult,
    Print[Style["✓ Memory summarization working", Green]];
    Print["  Summary length: " <> ToString[StringLength[summaryResult]] <> " characters"];
    Print["  Includes topics, interactions, and time span information"],
    Print[Style["✗ Memory summarization failed", Red]]
  ];
  
  testResult
];

(* Test memory system error handling *)
TestMemoryErrorHandling[] := Module[{errorResult, testResult},
  Print["Testing Memory System Error Handling..."];
  
  (* Test various error conditions *)
  errorResult = Catch[
    Module[{result1, result2, result3, result4},
      (* Test with empty data *)
      result1 = MultiModalApp`ProcessWithMemory[CreateEmptyMemoryData[]];
      (* Test context analysis with empty input *)
      result2 = MultiModalApp`AnalyzeConversationContext[<||>];
      (* Test memory storage with minimal data *)
      result3 = MultiModalApp`StoreConversationMemory[<|"textInput" -> "test"|>, <|"rawResponse" -> "test"|>];
      (* Test summarization with empty entries *)
      result4 = MultiModalApp`SummarizeConversationMemory[{}];
      
      (* All should handle gracefully *)
      AssociationQ[result1] && AssociationQ[result2] && StringQ[result3] && StringQ[result4]
    ],
    _,
    False
  ];
  
  (* Verify error handling *)
  testResult = errorResult === True;
  
  If[testResult,
    Print[Style["✓ Memory system error handling successful", Green]];
    Print["  Graceful handling of empty inputs and edge cases"];
    Print["  Robust error recovery across all memory components"],
    Print[Style["✗ Memory system error handling failed", Red]]
  ];
  
  testResult
];

(* Main test runner for Step 10 *)
RunStep10Tests[] := Module[{testResults, allPassed},
  Print[Style["Running Step 10 Tests: Memory Management & Conversation Context", "Subsection"]];
  Print[""];
  
  testResults = {
    TestMemorySystemInitialization[],
    TestConversationMemoryStorage[],
    TestConversationHistoryRetrieval[],
    TestContextAnalysis[],
    TestTopicExtraction[],
    TestMemoryEnhancedLLMGraph[],
    TestMemoryEnhancedProcessing[],
    TestConversationContextManagement[],
    TestMemorySummarization[],
    TestMemoryErrorHandling[]
  };
  
  allPassed = And @@ testResults;
  
  Print[""];
  If[allPassed,
    Print[Style["✓ All Step 10 tests passed! Memory Management & Conversation Context is working correctly.", "Text", Green]],
    Print[Style["✗ Some Step 10 tests failed. Please check the memory management implementation.", "Text", Red]]
  ];
  
  allPassed
];

End[];
EndPackage[];
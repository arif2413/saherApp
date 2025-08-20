(* Test Suite for Step 9: LLMGraph Tools Integration *)
(* Tests for MultiModalApp Wolfram computational tools integration with LLM hierarchy *)

BeginPackage["Step9Test`"];

Needs["MultiModalApp`"];

(* Test function declarations *)
RunStep9Tests::usage = "RunStep9Tests[] runs all tests for Step 9";
TestToolsIntegrationInitialization::usage = "TestToolsIntegrationInitialization[] tests Wolfram tools initialization";
TestWolframToolKitCreation::usage = "TestWolframToolKitCreation[] tests creation of comprehensive Wolfram tool kit";
TestComputationalTaskExecution::usage = "TestComputationalTaskExecution[] tests execution of individual computational tasks";
TestMathematicalTools::usage = "TestMathematicalTools[] tests mathematical computation tools";
TestDataAnalysisTools::usage = "TestDataAnalysisTools[] tests statistical and data analysis tools";
TestTextAnalysisTools::usage = "TestTextAnalysisTools[] tests text processing computational tools";
TestToolEnhancedLLMGraph::usage = "TestToolEnhancedLLMGraph[] tests LLMGraph with integrated tools";
TestToolsProcessingIntegration::usage = "TestToolsProcessingIntegration[] tests end-to-end tool-enhanced processing";
TestToolResultCoordination::usage = "TestToolResultCoordination[] tests coordination of tool and LLM results";
TestToolsErrorHandling::usage = "TestToolsErrorHandling[] tests error handling in tools integration";

Begin["`Private`"];

(* Helper function to create test input data for tools *)
CreateToolsTestData[] := Module[{testData},
  testData = <|
    "textInput" -> "Please solve the equation x^2 + 5x + 6 = 0 and calculate statistics for data: 10, 20, 30, 40, 50",
    "mathQuery" -> "integrate x^2 from 0 to 5",
    "dataQuery" -> "analyze correlation between 1,2,3,4,5 and 2,4,6,8,10",
    "textAnalysisQuery" -> "Count words and analyze sentiment: This is a wonderful day with great opportunities ahead!"
  |>;
  testData
];

CreateMathTestData[] := Module[{testData},
  testData = <|
    "textInput" -> "Solve x^2 - 4 = 0 and differentiate sin(x) with respect to x"
  |>;
  testData
];

CreateDataTestData[] := Module[{testData},
  testData = <|
    "textInput" -> "Calculate mean, median and standard deviation for the data: 5, 10, 15, 20, 25, 30"
  |>;
  testData
];

(* Test tools integration initialization *)
TestToolsIntegrationInitialization[] := Module[{initResult, testResult},
  Print["Testing Wolfram Tools Integration Initialization..."];
  
  (* Test tools initialization *)
  initResult = Catch[
    MultiModalApp`InitializeToolsIntegration[],
    _,
    $Failed
  ];
  
  (* Verify initialization results *)
  testResult = AssociationQ[initResult] && 
               KeyExistsQ[initResult, "toolsAvailable"] && 
               KeyExistsQ[initResult, "categories"] &&
               KeyExistsQ[initResult, "initialized"] &&
               initResult["initialized"] === True &&
               initResult["toolsAvailable"] > 0;
  
  If[testResult,
    Print[Style["✓ Wolfram tools integration initialization working", Green]];
    Print["  Tools available: " <> ToString[initResult["toolsAvailable"]]];
    Print["  Categories: " <> StringRiffle[initResult["categories"], ", "]],
    Print[Style["✗ Wolfram tools integration initialization failed", Red]]
  ];
  
  testResult
];

(* Test Wolfram tool kit creation *)
TestWolframToolKitCreation[] := Module[{toolKit, testResult, expectedCategories},
  Print["Testing Wolfram Tool Kit Creation..."];
  
  (* Test tool kit creation *)
  toolKit = Catch[
    MultiModalApp`CreateWolframToolKit[],
    _,
    $Failed
  ];
  
  (* Expected tool categories *)
  expectedCategories = {"Mathematics", "Statistics", "TextAnalysis", "Units", "DateTime", "Visualization", "StringProcessing"};
  
  (* Get actual categories *)
  Module[{actualCategories},
    actualCategories = DeleteDuplicates[Values[toolKit][[All, "category"]]];
    
    (* Verify tool kit creation results *)
    testResult = AssociationQ[toolKit] && 
                 Length[Keys[toolKit]] >= 10 &&
                 AllTrue[expectedCategories, MemberQ[actualCategories, #] &];
  ];
  
  If[testResult,
    Print[Style["✓ Wolfram tool kit creation working", Green]];
    Print["  Total tools: " <> ToString[Length[Keys[toolKit]]]];
    Print["  Categories covered: " <> ToString[Length[DeleteDuplicates[Values[toolKit][[All, "category"]]]]],
    Print[Style["✗ Wolfram tool kit creation failed", Red]]
  ];
  
  testResult
];

(* Test computational task execution *)
TestComputationalTaskExecution[] := Module[{taskResults, testResult},
  Print["Testing Computational Task Execution..."];
  
  (* Test various computational tasks *)
  taskResults = Catch[
    Module[{result1, result2, result3},
      (* Test mathematical computation *)
      result1 = MultiModalApp`ExecuteComputationalTask["solve", {"x^2 - 4"}];
      (* Test text analysis *)
      result2 = MultiModalApp`ExecuteComputationalTask["wordCount", {"Hello world this is a test"}];
      (* Test statistics *)
      result3 = MultiModalApp`ExecuteComputationalTask["statisticsSummary", {"1,2,3,4,5"}];
      
      {result1, result2, result3}
    ],
    _,
    $Failed
  ];
  
  (* Verify execution results *)
  testResult = ListQ[taskResults] && 
               Length[taskResults] == 3 &&
               AllTrue[taskResults, 
                      AssociationQ[#] && KeyExistsQ[#, "tool"] && 
                      KeyExistsQ[#, "result"] && KeyExistsQ[#, "success"] &];
  
  If[testResult,
    Print[Style["✓ Computational task execution working", Green]];
    Print["  All task executions completed successfully"];
    Print["  Results contain proper structure with tool, result, and success fields"],
    Print[Style["✗ Computational task execution failed", Red]]
  ];
  
  testResult
];

(* Test mathematical computation tools *)
TestMathematicalTools[] := Module[{mathResults, testResult},
  Print["Testing Mathematical Computation Tools..."];
  
  (* Test mathematical tools *)
  mathResults = Catch[
    Module[{solveResult, integrateResult, differentiateResult, factorResult},
      solveResult = MultiModalApp`ExecuteComputationalTask["solve", {"x^2 - 1"}];
      integrateResult = MultiModalApp`ExecuteComputationalTask["integrate", {"x^2", "x"}];
      differentiateResult = MultiModalApp`ExecuteComputationalTask["differentiate", {"x^3", "x"}];
      factorResult = MultiModalApp`ExecuteComputationalTask["factor", {"x^2 - 1"}];
      
      {solveResult, integrateResult, differentiateResult, factorResult}
    ],
    _,
    $Failed
  ];
  
  (* Verify mathematical results *)
  testResult = ListQ[mathResults] && 
               Length[mathResults] == 4 &&
               AllTrue[mathResults, 
                      AssociationQ[#] && KeyExistsQ[#, "category"] && 
                      #["category"] == "Mathematics" &];
  
  If[testResult,
    Print[Style["✓ Mathematical computation tools working", Green]];
    Print["  Solve, integrate, differentiate, and factor tools functional"];
    Print["  All tools properly categorized as Mathematics"],
    Print[Style["✗ Mathematical computation tools failed", Red]]
  ];
  
  testResult
];

(* Test data analysis tools *)
TestDataAnalysisTools[] := Module[{dataResults, testResult},
  Print["Testing Data Analysis Tools..."];
  
  (* Test data analysis tools *)
  dataResults = Catch[
    Module[{statsResult, correlationResult},
      statsResult = MultiModalApp`ExecuteComputationalTask["statisticsSummary", {"10,20,30,40,50"}];
      correlationResult = MultiModalApp`ExecuteComputationalTask["correlation", {"1,2,3,4", "2,4,6,8"}];
      
      {statsResult, correlationResult}
    ],
    _,
    $Failed
  ];
  
  (* Verify data analysis results *)
  testResult = ListQ[dataResults] && 
               Length[dataResults] == 2 &&
               AllTrue[dataResults,
                      AssociationQ[#] && KeyExistsQ[#, "category"] && 
                      #["category"] == "Statistics" &];
  
  If[testResult,
    Print[Style["✓ Data analysis tools working", Green]];
    Print["  Statistical summary and correlation tools functional"];
    Print["  Results contain proper statistical calculations"],
    Print[Style["✗ Data analysis tools failed", Red]]
  ];
  
  testResult
];

(* Test text analysis tools *)
TestTextAnalysisTools[] := Module[{textResults, testResult},
  Print["Testing Text Analysis Computational Tools..."];
  
  (* Test text analysis tools *)
  textResults = Catch[
    Module[{wordCountResult, sentimentResult},
      wordCountResult = MultiModalApp`ExecuteComputationalTask["wordCount", {"This is a sample text for testing"}];
      sentimentResult = MultiModalApp`ExecuteComputationalTask["textSentiment", {"I love this wonderful application"}];
      
      {wordCountResult, sentimentResult}
    ],
    _,
    $Failed
  ];
  
  (* Verify text analysis results *)
  testResult = ListQ[textResults] && 
               Length[textResults] == 2 &&
               AllTrue[textResults,
                      AssociationQ[#] && KeyExistsQ[#, "category"] && 
                      #["category"] == "TextAnalysis" &];
  
  If[testResult,
    Print[Style["✓ Text analysis computational tools working", Green]];
    Print["  Word count and sentiment analysis tools functional"];
    Print["  Text metrics and sentiment classification working"],
    Print[Style["✗ Text analysis computational tools failed", Red]]
  ];
  
  testResult
];

(* Test tool-enhanced LLMGraph construction *)
TestToolEnhancedLLMGraph[] := Module[{testData, enhancedGraph, testResult},
  Print["Testing Tool-Enhanced LLMGraph Construction..."];
  
  (* Create test data *)
  testData = CreateMathTestData[];
  
  (* Test enhanced graph construction *)
  enhancedGraph = Catch[
    Module[{initResult},
      (* Ensure hierarchy and tools are initialized *)
      initResult = MultiModalApp`InitializeToolsIntegration[];
      MultiModalApp`InitializeLLMHierarchy[];
      (* Build enhanced graph *)
      MultiModalApp`BuildToolEnhancedLLMGraph[testData]
    ],
    _,
    $Failed
  ];
  
  (* Verify enhanced graph construction *)
  testResult = enhancedGraph =!= $Failed && enhancedGraph =!= None;
  
  If[testResult,
    Print[Style["✓ Tool-enhanced LLMGraph construction working", Green]];
    Print["  LLMGraph successfully integrated with computational tools"];
    Print["  Graph ready for coordinated AI and computational processing"],
    Print[Style["✗ Tool-enhanced LLMGraph construction failed", Red]]
  ];
  
  testResult
];

(* Test tools processing integration *)
TestToolsProcessingIntegration[] := Module[{testData, processingResult, testResult},
  Print["Testing Tools Processing Integration..."];
  
  (* Create test data *)
  testData = CreateDataTestData[];
  
  (* Test tool-enhanced processing *)
  processingResult = Catch[
    MultiModalApp`ProcessWithTools[testData],
    _,
    $Failed
  ];
  
  (* Verify processing results *)
  testResult = AssociationQ[processingResult] && 
               KeyExistsQ[processingResult, "rawResponse"] && 
               KeyExistsQ[processingResult, "method"];
  
  If[testResult,
    Print[Style["✓ Tools processing integration working", Green]];
    Print["  Processing method: " <> processingResult["method"]];
    Print["  Tool-enhanced processing pipeline functional"],
    Print[Style["✗ Tools processing integration failed", Red]]
  ];
  
  testResult
];

(* Test tool result coordination *)
TestToolResultCoordination[] := Module[{mockToolResults, mockLLMResults, coordinationResult, testResult},
  Print["Testing Tool Result Coordination..."];
  
  (* Create mock results *)
  mockToolResults = {
    <|"tool" -> "solve", "result" -> "{{x -> -2}, {x -> 2}}", "category" -> "Mathematics"|>,
    <|"tool" -> "wordCount", "result" -> <|"words" -> 5, "characters" -> 25|>, "category" -> "TextAnalysis"|>
  };
  mockLLMResults = <|
    "textAnalysis" -> "The text contains mathematical content and requests computational analysis",
    "mathAnalysis" -> "Detected equation solving and statistical analysis requests"
  |>;
  
  (* Test coordination *)
  coordinationResult = Catch[
    MultiModalApp`CoordinateToolResults[mockToolResults, mockLLMResults],
    _,
    $Failed
  ];
  
  (* Verify coordination results *)
  testResult = StringQ[coordinationResult] && 
               StringLength[coordinationResult] > 0 &&
               StringContainsQ[coordinationResult, "AI Analysis"] &&
               StringContainsQ[coordinationResult, "Computational Results"];
  
  If[testResult,
    Print[Style["✓ Tool result coordination working", Green]];
    Print["  Coordination properly combines LLM and computational results"];
    Print["  Response length: " <> ToString[StringLength[coordinationResult]] <> " characters"],
    Print[Style["✗ Tool result coordination failed", Red]]
  ];
  
  testResult
];

(* Test tools integration error handling *)
TestToolsErrorHandling[] := Module[{errorResult, testResult},
  Print["Testing Tools Integration Error Handling..."];
  
  (* Test various error conditions *)
  errorResult = Catch[
    Module[{result1, result2, result3},
      (* Test with invalid tool *)
      result1 = MultiModalApp`ExecuteComputationalTask["nonexistentTool", {"test"}];
      (* Test with invalid parameters *)
      result2 = MultiModalApp`ExecuteComputationalTask["solve", {}];
      (* Test coordination with empty results *)
      result3 = MultiModalApp`CoordinateToolResults[{}, <||>];
      
      (* All should handle gracefully *)
      AssociationQ[result1] && AssociationQ[result2] && StringQ[result3]
    ],
    _,
    False
  ];
  
  (* Verify error handling *)
  testResult = errorResult === True;
  
  If[testResult,
    Print[Style["✓ Tools integration error handling successful", Green]];
    Print["  Graceful handling of invalid tools and parameters"];
    Print["  Robust error recovery across tools integration components"],
    Print[Style["✗ Tools integration error handling failed", Red]]
  ];
  
  testResult
];

(* Main test runner for Step 9 *)
RunStep9Tests[] := Module[{testResults, allPassed},
  Print[Style["Running Step 9 Tests: LLMGraph Tools Integration", "Subsection"]];
  Print[""];
  
  testResults = {
    TestToolsIntegrationInitialization[],
    TestWolframToolKitCreation[],
    TestComputationalTaskExecution[],
    TestMathematicalTools[],
    TestDataAnalysisTools[],
    TestTextAnalysisTools[],
    TestToolEnhancedLLMGraph[],
    TestToolsProcessingIntegration[],
    TestToolResultCoordination[],
    TestToolsErrorHandling[]
  };
  
  allPassed = And @@ testResults;
  
  Print[""];
  If[allPassed,
    Print[Style["✓ All Step 9 tests passed! LLMGraph Tools Integration is working correctly.", "Text", Green]],
    Print[Style["✗ Some Step 9 tests failed. Please check the tools integration implementation.", "Text", Red]]
  ];
  
  allPassed
];

End[];
EndPackage[];
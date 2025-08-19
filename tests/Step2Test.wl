(* Test Suite for Step 2: Text Processing & Master LLM Integration *)
(* Tests for MultiModalApp LLM functionality *)

BeginPackage["Step2Test`"];

Needs["MultiModalApp`"];

(* Test function declarations *)
RunStep2Tests::usage = "RunStep2Tests[] runs all tests for Step 2";
TestLLMInitialization::usage = "TestLLMInitialization[] tests Master LLM initialization";
TestPromptCreation::usage = "TestPromptCreation[] tests LLM prompt creation";
TestTextProcessing::usage = "TestTextProcessing[] tests enhanced text processing";
TestLLMIntegration::usage = "TestLLMIntegration[] tests LLM integration with form processing";
TestResponseFormatting::usage = "TestResponseFormatting[] tests LLM response formatting";

Begin["`Private`"];

(* Test Master LLM initialization *)
TestLLMInitialization[] := Module[{initResult, testResult},
  Print["Testing Master LLM Initialization..."];
  
  (* Test initialization function exists and runs *)
  initResult = Catch[MultiModalApp`InitializeMasterLLM[], _, $Failed];
  
  (* Check if initialization completed (even if LLM service not available) *)
  testResult = initResult =!= $Failed;
  
  If[testResult,
    Print[Style["✓ Master LLM initialization function working", Green]],
    Print[Style["✗ Master LLM initialization failed", Red]]
  ];
  
  testResult
];

(* Test LLM prompt creation *)
TestPromptCreation[] := Module[{testData, prompt, testResult},
  Print["Testing LLM Prompt Creation..."];
  
  (* Test data with text input *)
  testData = <|
    "textInput" -> "What is machine learning?",
    "imageDescription" -> "",
    "audioTranscript" -> "",
    "videoContent" -> "",
    "webpageContent" -> ""
  |>;
  
  (* Test prompt creation *)
  prompt = MultiModalApp`CreateLLMPrompt[testData];
  
  (* Verify prompt is created and contains expected content *)
  testResult = StringQ[prompt] && StringContainsQ[prompt, "machine learning"];
  
  If[testResult,
    Print[Style["✓ LLM prompt creation working correctly", Green]],
    Print[Style["✗ LLM prompt creation failed", Red]]
  ];
  
  testResult
];

(* Test enhanced text processing *)
TestTextProcessing[] := Module[{testText, analysis, testResult},
  Print["Testing Enhanced Text Processing..."];
  
  (* Test text *)
  testText = "This is a test sentence for analysis.";
  
  (* Process text *)
  analysis = MultiModalApp`ProcessTextInput[testText];
  
  (* Verify analysis contains expected fields *)
  testResult = AssociationQ[analysis] && 
               KeyExistsQ[analysis, "wordCount"] && 
               KeyExistsQ[analysis, "characterCount"] &&
               analysis["wordCount"] == 7;
  
  If[testResult,
    Print[Style["✓ Text processing analysis working", Green]],
    Print[Style["✗ Text processing analysis failed", Red]]
  ];
  
  testResult
];

(* Test LLM integration with form processing *)
TestLLMIntegration[] := Module[{testData, result, testResult},
  Print["Testing LLM Integration with Form Processing..."];
  
  (* Test data *)
  testData = <|
    "textInput" -> "Hello AI assistant",
    "imageUpload" -> None,
    "audioUpload" -> None,
    "videoUpload" -> None,
    "webpageURL" -> None
  |>;
  
  (* Process with LLM integration *)
  result = MultiModalApp`ProcessUserInput[testData];
  
  (* Verify result is properly formatted *)
  testResult = Head[result] === Column && Length[result[[1]]] > 0;
  
  If[testResult,
    Print[Style["✓ LLM integration with form processing working", Green]],
    Print[Style["✗ LLM integration with form processing failed", Red]]
  ];
  
  testResult
];

(* Test LLM response formatting *)
TestResponseFormatting[] := Module[{testResponse, formattedResult, testResult},
  Print["Testing LLM Response Formatting..."];
  
  (* Test response data *)
  testResponse = <|
    "rawResponse" -> "This is a test AI response",
    "prompt" -> "Test prompt",
    "timestamp" -> Now,
    "status" -> "success"
  |>;
  
  (* Format response *)
  formattedResult = MultiModalApp`FormatLLMResponse[testResponse];
  
  (* Verify formatting *)
  testResult = Head[formattedResult] === Column;
  
  If[testResult,
    Print[Style["✓ LLM response formatting working", Green]],
    Print[Style["✗ LLM response formatting failed", Red]]
  ];
  
  testResult
];

(* Test multi-modal prompt creation *)
TestMultiModalPrompt[] := Module[{testData, prompt, testResult},
  Print["Testing Multi-Modal Prompt Creation..."];
  
  (* Test data with multiple input types *)
  testData = <|
    "textInput" -> "Analyze this content",
    "imageDescription" -> "A photo of a cat",
    "audioTranscript" -> "Hello world audio message",
    "videoContent" -> "Video showing tutorial",
    "webpageContent" -> "Article about AI"
  |>;
  
  (* Create prompt *)
  prompt = MultiModalApp`CreateLLMPrompt[testData];
  
  (* Verify prompt contains all sections *)
  testResult = StringQ[prompt] && 
               StringContainsQ[prompt, "Analyze this content"] &&
               StringContainsQ[prompt, "photo of a cat"] &&
               StringContainsQ[prompt, "Hello world audio"] &&
               StringContainsQ[prompt, "Video showing tutorial"] &&
               StringContainsQ[prompt, "Article about AI"];
  
  If[testResult,
    Print[Style["✓ Multi-modal prompt creation working", Green]],
    Print[Style["✗ Multi-modal prompt creation failed", Red]]
  ];
  
  testResult
];

(* Test empty input handling *)
TestEmptyInputHandling[] := Module[{testData, prompt, testResult},
  Print["Testing Empty Input Handling..."];
  
  (* Test data with no input *)
  testData = <|
    "textInput" -> "",
    "imageDescription" -> "",
    "audioTranscript" -> "",
    "videoContent" -> "",
    "webpageContent" -> ""
  |>;
  
  (* Create prompt *)
  prompt = MultiModalApp`CreateLLMPrompt[testData];
  
  (* Verify default prompt is returned *)
  testResult = StringQ[prompt] && StringContainsQ[prompt, "Please provide some input"];
  
  If[testResult,
    Print[Style["✓ Empty input handling working", Green]],
    Print[Style["✗ Empty input handling failed", Red]]
  ];
  
  testResult
];

(* Run all Step 2 tests *)
RunStep2Tests[] := Module[{testResults, allPassed},
  Print[Style["Running Step 2 Tests: Text Processing & Master LLM Integration", "Subsection"]];
  Print["=" <> StringRepeat["=", 60]];
  
  (* Run individual tests *)
  testResults = {
    TestLLMInitialization[],
    TestPromptCreation[],
    TestTextProcessing[],
    TestLLMIntegration[],
    TestResponseFormatting[],
    TestMultiModalPrompt[],
    TestEmptyInputHandling[]
  };
  
  (* Check if all tests passed *)
  allPassed = And @@ testResults;
  
  Print["=" <> StringRepeat["=", 60]];
  
  If[allPassed,
    Print[Style["✓ ALL STEP 2 TESTS PASSED", "Text", Green, Bold]];
    Print["Step 2 is ready for deployment and Step 3 implementation."],
    Print[Style["✗ SOME STEP 2 TESTS FAILED", "Text", Red, Bold]];
    Print["Please fix issues before proceeding to Step 3."]
  ];
  
  Print[""];
  Print["Test Summary:"];
  Print["- LLM Initialization: " <> If[testResults[[1]], "PASS", "FAIL"]];
  Print["- Prompt Creation: " <> If[testResults[[2]], "PASS", "FAIL"]];
  Print["- Text Processing: " <> If[testResults[[3]], "PASS", "FAIL"]];
  Print["- LLM Integration: " <> If[testResults[[4]], "PASS", "FAIL"]];
  Print["- Response Formatting: " <> If[testResults[[5]], "PASS", "FAIL"]];
  Print["- Multi-Modal Prompts: " <> If[testResults[[6]], "PASS", "FAIL"]];
  Print["- Empty Input Handling: " <> If[testResults[[7]], "PASS", "FAIL"]];
  
  allPassed
];

End[];
EndPackage[];
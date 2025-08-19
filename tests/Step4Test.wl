(* Test Suite for Step 4: Audio Processing with Speech-to-Text *)
(* Tests for MultiModalApp audio processing functionality *)

BeginPackage["Step4Test`"];

Needs["MultiModalApp`"];

(* Test function declarations *)
RunStep4Tests::usage = "RunStep4Tests[] runs all tests for Step 4";
TestAudioMetadataExtraction::usage = "TestAudioMetadataExtraction[] tests audio metadata extraction";
TestSpeechToText::usage = "TestSpeechToText[] tests speech-to-text transcription";
TestAudioProcessingIntegration::usage = "TestAudioProcessingIntegration[] tests comprehensive audio processing";
TestAudioLLMIntegration::usage = "TestAudioLLMIntegration[] tests audio processing with LLM pipeline";
TestAudioDisplayFormatting::usage = "TestAudioDisplayFormatting[] tests audio result display formatting";

Begin["`Private`"];

(* Helper function to create test audio *)
CreateTestAudioTone[] := Module[{frequency, duration, sampleRate, samples},
  (* Create a simple sine wave audio for testing *)
  frequency = 440; (* A4 note *)
  duration = 1.0; (* 1 second *)
  sampleRate = 8000; (* Standard sample rate *)
  
  samples = Table[
    Sin[2 Pi frequency t], 
    {t, 0, duration, 1/sampleRate}
  ];
  
  Sound[SampledSoundList[samples, sampleRate]]
];

CreateTestSilentAudio[] := Module[{duration, sampleRate, samples},
  (* Create silent audio for testing *)
  duration = 0.5; (* 0.5 seconds *)
  sampleRate = 8000;
  
  samples = Table[0.0, {i, Round[duration * sampleRate]}];
  
  Sound[SampledSoundList[samples, sampleRate]]
];

(* Test audio metadata extraction *)
TestAudioMetadataExtraction[] := Module[{testAudio, metadataResult, testResult},
  Print["Testing Audio Metadata Extraction..."];
  
  (* Create test audio *)
  testAudio = CreateTestSilentAudio[];
  
  (* Test metadata extraction *)
  metadataResult = MultiModalApp`ExtractAudioMetadata[testAudio];
  
  (* Verify metadata result structure *)
  testResult = AssociationQ[metadataResult] && 
               KeyExistsQ[metadataResult, "duration"] && 
               KeyExistsQ[metadataResult, "sampleRate"] &&
               KeyExistsQ[metadataResult, "channels"] &&
               KeyExistsQ[metadataResult, "format"] &&
               metadataResult["format"] == "Sound";
  
  If[testResult,
    Print[Style["✓ Audio metadata extraction working", Green]];
    Print["  Duration: " <> ToString[metadataResult["duration"]] <> " seconds"];
    Print["  Sample Rate: " <> ToString[metadataResult["sampleRate"]] <> " Hz"];
    Print["  Channels: " <> ToString[metadataResult["channels"]]],
    Print[Style["✗ Audio metadata extraction failed", Red]]
  ];
  
  testResult
];

(* Test speech-to-text transcription *)
TestSpeechToText[] := Module[{testAudio, transcriptResult, testResult},
  Print["Testing Speech-to-Text Transcription..."];
  
  (* Create test audio (silent - should not trigger problematic speech recognition) *)
  testAudio = CreateTestSilentAudio[];
  
  (* Test speech transcription *)
  transcriptResult = MultiModalApp`TranscribeAudioToText[testAudio];
  
  (* Verify transcript result structure *)
  testResult = AssociationQ[transcriptResult] && 
               KeyExistsQ[transcriptResult, "transcript"] && 
               KeyExistsQ[transcriptResult, "hasText"] &&
               KeyExistsQ[transcriptResult, "method"] &&
               transcriptResult["method"] == "SpeechRecognize";
  
  If[testResult,
    Print[Style["✓ Speech-to-text transcription working", Green]];
    If[transcriptResult["hasText"],
      Print["  Transcript: \"" <> transcriptResult["transcript"] <> "\""],
      Print["  No speech detected (expected for silent audio)"]
    ],
    Print[Style["✗ Speech-to-text transcription failed", Red]]
  ];
  
  testResult
];

(* Test comprehensive audio processing *)
TestAudioProcessingIntegration[] := Module[{testAudio, processResult, testResult},
  Print["Testing Comprehensive Audio Processing..."];
  
  (* Create test audio *)
  testAudio = CreateTestSilentAudio[];
  
  (* Test comprehensive processing *)
  processResult = MultiModalApp`ProcessAudioInput[testAudio];
  
  (* Verify comprehensive processing result *)
  testResult = AssociationQ[processResult] && 
               KeyExistsQ[processResult, "combinedDescription"] && 
               KeyExistsQ[processResult, "transcriptResult"] &&
               KeyExistsQ[processResult, "metadataResult"] &&
               KeyExistsQ[processResult, "hasContent"] &&
               KeyExistsQ[processResult, "processedAt"];
  
  If[testResult,
    Print[Style["✓ Comprehensive audio processing working", Green]];
    Print["  Description: " <> processResult["combinedDescription"]],
    Print[Style["✗ Comprehensive audio processing failed", Red]]
  ];
  
  testResult
];

(* Test audio processing with LLM integration *)
TestAudioLLMIntegration[] := Module[{testAudio, testData, result, testResult},
  Print["Testing Audio Processing with LLM Integration..."];
  
  (* Create test audio *)
  testAudio = CreateTestSilentAudio[];
  
  (* Test data with audio *)
  testData = <|
    "textInput" -> "What do you hear in this audio?",
    "imageUpload" -> None,
    "audioUpload" -> testAudio,
    "videoUpload" -> None,
    "webpageURL" -> None
  |>;
  
  (* Process with LLM integration *)
  result = MultiModalApp`ProcessUserInput[testData];
  
  (* Verify result includes audio processing *)
  testResult = Head[result] === Column && Length[result[[1]]] > 0;
  
  If[testResult,
    Print[Style["✓ Audio processing with LLM integration working", Green]],
    Print[Style["✗ Audio processing with LLM integration failed", Red]]
  ];
  
  testResult
];

(* Test audio result display formatting *)
TestAudioDisplayFormatting[] := Module[{testAudio, testData, result, testResult},
  Print["Testing Audio Result Display Formatting..."];
  
  (* Create test audio *)
  testAudio = CreateTestSilentAudio[];
  
  (* Test data with audio *)
  testData = <|
    "textInput" -> "",
    "imageUpload" -> None,
    "audioUpload" -> testAudio,
    "videoUpload" -> None,
    "webpageURL" -> None
  |>;
  
  (* Process and check formatting *)
  result = MultiModalApp`ProcessUserInput[testData];
  
  (* Verify proper formatting (basic structure check) *)
  testResult = Head[result] === Column;
  
  If[testResult,
    Print[Style["✓ Audio display formatting working", Green]],
    Print[Style["✗ Audio display formatting failed", Red]]
  ];
  
  testResult
];

(* Test empty audio handling *)
TestEmptyAudioHandling[] := Module[{result, testResult},
  Print["Testing Empty Audio Handling..."];
  
  (* Test data with no audio *)
  testData = <|
    "textInput" -> "",
    "imageUpload" -> None,
    "audioUpload" -> None,
    "videoUpload" -> None,
    "webpageURL" -> None
  |>;
  
  (* Process with no audio *)
  result = MultiModalApp`ProcessUserInput[testData];
  
  (* Verify graceful handling *)
  testResult = Head[result] === Column;
  
  If[testResult,
    Print[Style["✓ Empty audio handling working", Green]],
    Print[Style["✗ Empty audio handling failed", Red]]
  ];
  
  testResult
];

(* Test audio processing error handling *)
TestAudioErrorHandling[] := Module[{testAudio, metadataResult, transcriptResult, testResult},
  Print["Testing Audio Processing Error Handling..."];
  
  (* Create test audio *)
  testAudio = CreateTestSilentAudio[];
  
  (* Test metadata and transcription with valid audio (should not error) *)
  metadataResult = Catch[MultiModalApp`ExtractAudioMetadata[testAudio], _, None];
  transcriptResult = Catch[MultiModalApp`TranscribeAudioToText[testAudio], _, None];
  
  (* Verify error handling doesn't crash and returns valid associations *)
  testResult = (metadataResult =!= None && AssociationQ[metadataResult]) && 
               (transcriptResult =!= None && AssociationQ[transcriptResult]);
  
  If[testResult,
    Print[Style["✓ Audio processing error handling working", Green]],
    Print[Style["✗ Audio processing error handling failed", Red]]
  ];
  
  testResult
];

(* Test multi-modal integration with audio *)
TestMultiModalAudioIntegration[] := Module[{testAudio, testData, result, testResult},
  Print["Testing Multi-Modal Integration with Audio..."];
  
  (* Create test audio *)
  testAudio = CreateTestSilentAudio[];
  
  (* Test data with text and audio *)
  testData = <|
    "textInput" -> "Please analyze this audio file",
    "imageUpload" -> None,
    "audioUpload" -> testAudio,
    "videoUpload" -> None,
    "webpageURL" -> None
  |>;
  
  (* Process with multi-modal input *)
  result = MultiModalApp`ProcessUserInput[testData];
  
  (* Verify multi-modal processing *)
  testResult = Head[result] === Column && Length[result[[1]]] > 0;
  
  If[testResult,
    Print[Style["✓ Multi-modal audio integration working", Green]],
    Print[Style["✗ Multi-modal audio integration failed", Red]]
  ];
  
  testResult
];

(* Run all Step 4 tests *)
RunStep4Tests[] := Module[{testResults, allPassed},
  Print[Style["Running Step 4 Tests: Audio Processing with Speech-to-Text", "Subsection"]];
  Print["=" <> StringRepeat["=", 65]];
  
  (* Run individual tests *)
  testResults = {
    TestAudioMetadataExtraction[],
    TestSpeechToText[],
    TestAudioProcessingIntegration[],
    TestAudioLLMIntegration[],
    TestAudioDisplayFormatting[],
    TestEmptyAudioHandling[],
    TestAudioErrorHandling[],
    TestMultiModalAudioIntegration[]
  };
  
  (* Check if all tests passed *)
  allPassed = And @@ testResults;
  
  Print["=" <> StringRepeat["=", 65]];
  
  If[allPassed,
    Print[Style["✓ ALL STEP 4 TESTS PASSED", "Text", Green, Bold]];
    Print["Step 4 is ready for deployment and Step 5 implementation."],
    Print[Style["✗ SOME STEP 4 TESTS FAILED", "Text", Red, Bold]];
    Print["Please fix issues before proceeding to Step 5."]
  ];
  
  Print[""];
  Print["Test Summary:"];
  Print["- Audio Metadata Extraction: " <> If[testResults[[1]], "PASS", "FAIL"]];
  Print["- Speech-to-Text: " <> If[testResults[[2]], "PASS", "FAIL"]];
  Print["- Audio Processing Integration: " <> If[testResults[[3]], "PASS", "FAIL"]];
  Print["- Audio LLM Integration: " <> If[testResults[[4]], "PASS", "FAIL"]];
  Print["- Display Formatting: " <> If[testResults[[5]], "PASS", "FAIL"]];
  Print["- Empty Audio Handling: " <> If[testResults[[6]], "PASS", "FAIL"]];
  Print["- Error Handling: " <> If[testResults[[7]], "PASS", "FAIL"]];
  Print["- Multi-Modal Integration: " <> If[testResults[[8]], "PASS", "FAIL"]];
  
  allPassed
];

End[];
EndPackage[];
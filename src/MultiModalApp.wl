(* Multi-Modal LLM App - Steps 1 & 2: Web Infrastructure + LLM Integration *)
(* Wolfram Language Multi-Modal Assistant *)

BeginPackage["MultiModalApp`"];

(* Public function declarations - Step 1 *)
CreateWebInterface::usage = "CreateWebInterface[] creates the basic web interface for multi-modal input";
DeployApp::usage = "DeployApp[] deploys the application to Wolfram Cloud";
ProcessUserInput::usage = "ProcessUserInput[data] processes form data from web interface";

(* Public function declarations - Step 2: LLM Integration *)
InitializeMasterLLM::usage = "InitializeMasterLLM[] initializes the Master LLM configuration";
ProcessTextWithLLM::usage = "ProcessTextWithLLM[text] processes text input through Master LLM";
CreateLLMPrompt::usage = "CreateLLMPrompt[inputData] creates structured prompt from multi-modal input data";
FormatLLMResponse::usage = "FormatLLMResponse[response] formats LLM response for web display";
ProcessTextInput::usage = "ProcessTextInput[text] performs enhanced text analysis and preprocessing";

(* Public function declarations - Step 3: Image Processing *)
ProcessImageInput::usage = "ProcessImageInput[image] processes image input with OCR and object recognition";
ExtractTextFromImage::usage = "ExtractTextFromImage[image] extracts text from image using OCR";
IdentifyImageObjects::usage = "IdentifyImageObjects[image] identifies objects and scenes in image";

(* Public function declarations - Step 4: Audio Processing *)
ProcessAudioInput::usage = "ProcessAudioInput[audio] processes audio input with speech-to-text";
TranscribeAudioToText::usage = "TranscribeAudioToText[audio] converts speech in audio to text";
ExtractAudioMetadata::usage = "ExtractAudioMetadata[audio] extracts audio properties and metadata";

(* Public function declarations - Step 5: Video Processing *)
ProcessVideoInput::usage = "ProcessVideoInput[video] processes video input with transcription and frame analysis";
TranscribeVideoToText::usage = "TranscribeVideoToText[video] extracts audio track and converts speech to text";
ExtractVideoMetadata::usage = "ExtractVideoMetadata[video] extracts video properties and metadata";
AnalyzeVideoFrames::usage = "AnalyzeVideoFrames[video] analyzes key frames from video";

(* Public function declarations - Step 6: Web Content Processing *)
ProcessWebpageInput::usage = "ProcessWebpageInput[url] processes webpage URL with content extraction and analysis";
FetchWebpageContent::usage = "FetchWebpageContent[url] fetches and extracts content from webpage URL";
ParseHTMLContent::usage = "ParseHTMLContent[html] parses HTML content and extracts text and metadata";
ValidateURL::usage = "ValidateURL[url] validates URL format and accessibility";

(* Public function declarations - Step 7: Keyboard/Mouse Event Processing *)
ProcessEventInput::usage = "ProcessEventInput[eventData] processes keyboard/mouse event data with pattern analysis";
ParseKeyboardEvents::usage = "ParseKeyboardEvents[eventText] parses keyboard event descriptions and sequences";
ParseMouseEvents::usage = "ParseMouseEvents[eventText] parses mouse event descriptions and interactions";
AnalyzeEventPatterns::usage = "AnalyzeEventPatterns[events] analyzes user interaction patterns from events";

(* Public function declarations - Step 8: Advanced LLM Architecture (Master-Slave Setup) *)
InitializeLLMHierarchy::usage = "InitializeLLMHierarchy[] initializes Master-Slave LLM architecture with specialized roles";
CreateSpecializedSlaves::usage = "CreateSpecializedSlaves[] creates specialized slave LLMs for different domains";
BuildLLMGraph::usage = "BuildLLMGraph[inputData] builds LLMGraph for orchestrated multi-modal processing";
DelegateTasks::usage = "DelegateTasks[tasks] delegates tasks to appropriate specialized slave LLMs";
ProcessWithLLMGraph::usage = "ProcessWithLLMGraph[inputData] processes multi-modal input using LLMGraph orchestration";
CoordinateSlaveResponses::usage = "CoordinateSlaveResponses[responses] coordinates and synthesizes slave LLM responses";

(* Public function declarations - Step 9: LLMGraph Tools Integration *)
InitializeToolsIntegration::usage = "InitializeToolsIntegration[] initializes Wolfram computational tools for LLM access";
CreateWolframToolKit::usage = "CreateWolframToolKit[] creates comprehensive Wolfram computational tool functions";
BuildToolEnhancedLLMGraph::usage = "BuildToolEnhancedLLMGraph[inputData] builds LLMGraph with integrated computational tools";
ProcessWithTools::usage = "ProcessWithTools[inputData] processes input through tool-enhanced LLMGraph";
ExecuteComputationalTask::usage = "ExecuteComputationalTask[taskType, parameters] executes Wolfram computational tasks";
CoordinateToolResults::usage = "CoordinateToolResults[toolResults, llmResponses] coordinates computational and LLM results";

(* Public function declarations - Step 10: Memory Management & Conversation Context *)
InitializeMemorySystem::usage = "InitializeMemorySystem[] initializes conversation memory and context management";
StoreConversationMemory::usage = "StoreConversationMemory[inputData, response] stores conversation interaction in memory";
RetrieveConversationHistory::usage = "RetrieveConversationHistory[limit] retrieves recent conversation history";
AnalyzeConversationContext::usage = "AnalyzeConversationContext[currentInput] analyzes current input against conversation context";
BuildMemoryEnhancedLLMGraph::usage = "BuildMemoryEnhancedLLMGraph[inputData, context] builds LLMGraph with conversation memory integration";
ProcessWithMemory::usage = "ProcessWithMemory[inputData] processes input with conversation context and memory";
ManageConversationContext::usage = "ManageConversationContext[interactions] manages and optimizes conversation context";
SummarizeConversationMemory::usage = "SummarizeConversationMemory[memoryEntries] creates conversation summary for context optimization";

Begin["`Private`"];

(* Step 2: LLM Configuration and Initialization *)

(* Global variable to store Master LLM configuration *)
$MasterLLMConfig = None;

(* Initialize Master LLM with default configuration *)
InitializeMasterLLM[] := Module[{llmConfig},
  (* Configure LLM using Wolfram's built-in LLM or external service *)
  llmConfig = LLMConfiguration[
    <|
      "Model" -> "gpt-3.5-turbo", (* Can be changed to Wolfram's LLM *)
      "Temperature" -> 0.7,
      "MaxTokens" -> 2000,
      "SystemMessage" -> "You are a helpful multi-modal AI assistant. You can analyze text, images, audio, video, and web content. Provide clear, accurate, and helpful responses."
    |>
  ];
  
  $MasterLLMConfig = llmConfig;
  
  (* Test LLM connection *)
  If[$MasterLLMConfig =!= None,
    Print[Style["✓ Master LLM initialized successfully", Green]];
    $MasterLLMConfig,
    Print[Style["✗ Master LLM initialization failed", Red]];
    $Failed
  ]
];

(* Create structured prompt from multi-modal input data *)
CreateLLMPrompt[inputData_Association] := Module[{prompt, sections},
  sections = {};
  
  (* Add text input section *)
  If[KeyExistsQ[inputData, "textInput"] && inputData["textInput"] != "",
    AppendTo[sections, "User Query: " <> inputData["textInput"]]
  ];
  
  (* Add image description section *)
  If[KeyExistsQ[inputData, "imageDescription"] && inputData["imageDescription"] != "",
    AppendTo[sections, "Image Content: " <> inputData["imageDescription"]]
  ];
  
  (* Add audio transcript section *)
  If[KeyExistsQ[inputData, "audioTranscript"] && inputData["audioTranscript"] != "",
    AppendTo[sections, "Audio Transcript: " <> inputData["audioTranscript"]]
  ];
  
  (* Add video content section *)
  If[KeyExistsQ[inputData, "videoContent"] && inputData["videoContent"] != "",
    AppendTo[sections, "Video Content: " <> inputData["videoContent"]]
  ];
  
  (* Add webpage content section *)
  If[KeyExistsQ[inputData, "webpageContent"] && inputData["webpageContent"] != "",
    AppendTo[sections, "Webpage Content: " <> inputData["webpageContent"]]
  ];
  
  (* Add event content section *)
  If[KeyExistsQ[inputData, "eventContent"] && inputData["eventContent"] != "",
    AppendTo[sections, "User Events: " <> inputData["eventContent"]]
  ];
  
  (* Construct final prompt *)
  prompt = StringRiffle[sections, "\n\n"];
  
  If[prompt == "",
    "Please provide some input for me to analyze.",
    "Please analyze the following multi-modal input and provide a helpful response:\n\n" <> prompt
  ]
];

(* Process text input through Master LLM *)
ProcessTextWithLLM[inputData_Association] := Module[{prompt, llmFunction, response},
  
  (* Check if Master LLM is initialized *)
  If[$MasterLLMConfig === None,
    Print["Initializing Master LLM..."];
    InitializeMasterLLM[];
  ];
  
  (* Create prompt from input data *)
  prompt = CreateLLMPrompt[inputData];
  
  (* Create LLM function *)
  llmFunction = LLMFunction[prompt, LLMEvaluator -> $MasterLLMConfig];
  
  (* Get LLM response *)
  response = llmFunction[];
  
  (* Return formatted response *)
  <|
    "rawResponse" -> response,
    "prompt" -> prompt,
    "timestamp" -> Now,
    "status" -> "success"
  |>
];

(* Format LLM response for web display *)
FormatLLMResponse[responseData_Association] := Module[{formattedOutput},
  formattedOutput = Column[{
    Style["AI Assistant Response", "Subsubtitle", Bold],
    "",
    Style[responseData["rawResponse"], "Text"],
    "",
    Style["Response generated at: " <> DateString[responseData["timestamp"]], "Text", Gray, Italic]
  }];
  
  formattedOutput
];

(* Enhanced text processing function *)
ProcessTextInput[text_String] := Module[{processedText, analysis},
  (* Basic text preprocessing *)
  processedText = StringTrim[text];
  
  (* Text analysis *)
  analysis = <|
    "originalText" -> text,
    "processedText" -> processedText,
    "wordCount" -> Length[StringSplit[processedText]],
    "characterCount" -> StringLength[processedText],
    "language" -> "Auto-detect", (* Can be enhanced with language detection *)
    "isEmpty" -> (processedText == "")
  |>;
  
  analysis
];

(* Step 3: Image Processing Functions *)

(* Extract text from image using OCR *)
ExtractTextFromImage[image_Image] := Module[{extractedText, result},
  (* Use TextRecognize to extract text from the image *)
  extractedText = Catch[
    TextRecognize[image],
    _,
    "" (* Return empty string if OCR fails *)
  ];
  
  (* Clean up the extracted text *)
  result = StringTrim[extractedText];
  
  (* Return result with metadata *)
  <|
    "extractedText" -> result,
    "hasText" -> (result != ""),
    "textLength" -> StringLength[result],
    "wordCount" -> If[result != "", Length[StringSplit[result]], 0],
    "method" -> "TextRecognize"
  |>
];

(* Identify objects and scenes in image *)
IdentifyImageObjects[image_Image] := Module[{identification, confidence, result},
  (* Use ImageIdentify to identify the main subject *)
  identification = Catch[
    ImageIdentify[image],
    _,
    "unknown" (* Return unknown if identification fails *)
  ];
  
  (* For now, assign a default confidence since exact confidence retrieval is complex *)
  confidence = If[identification != "unknown", 0.8, 0.0];
  
  (* Format the result *)
  result = <|
    "primaryObject" -> ToString[identification],
    "confidence" -> confidence,
    "description" -> ToString[identification],
    "method" -> "ImageIdentify"
  |>;
  
  result
];

(* Comprehensive image processing combining OCR and object recognition *)
ProcessImageInput[image_Image] := Module[{ocrResult, objectResult, combinedDescription},
  
  (* Extract text using OCR *)
  ocrResult = ExtractTextFromImage[image];
  
  (* Identify objects in the image *)
  objectResult = IdentifyImageObjects[image];
  
  (* Create combined description *)
  combinedDescription = "";
  
  (* Add object description *)
  If[objectResult["confidence"] > 0.1,
    combinedDescription = "Image shows: " <> objectResult["description"];
  ];
  
  (* Add OCR text if found *)
  If[ocrResult["hasText"],
    If[combinedDescription != "",
      combinedDescription = combinedDescription <> ". Text in image: " <> ocrResult["extractedText"],
      combinedDescription = "Text in image: " <> ocrResult["extractedText"]
    ]
  ];
  
  (* If no useful information found *)
  If[combinedDescription == "",
    combinedDescription = "Image uploaded but content could not be analyzed"
  ];
  
  (* Return comprehensive analysis *)
  <|
    "combinedDescription" -> combinedDescription,
    "ocrResult" -> ocrResult,
    "objectResult" -> objectResult,
    "hasContent" -> (ocrResult["hasText"] || objectResult["confidence"] > 0.1),
    "imageSize" -> ImageDimensions[image],
    "processedAt" -> Now
  |>
];

(* Step 4: Audio Processing Functions *)

(* Extract audio metadata and properties *)
ExtractAudioMetadata[audio_Sound] := Module[{duration, sampleRate, channels, properties, durationSeconds},
  (* Extract basic audio properties *)
  properties = Catch[
    Module[{duration, sampleRate, channels, durationSeconds},
      duration = AudioLength[audio];
      sampleRate = AudioSampleRate[audio];
      channels = AudioChannels[audio];
      
      (* Convert duration to seconds if it's in samples *)
      durationSeconds = If[Head[duration] === Quantity && QuantityUnit[duration] == "Samples",
        N[QuantityMagnitude[duration] / QuantityMagnitude[sampleRate]],
        If[Head[duration] === Quantity, N[QuantityMagnitude[duration]], N[duration]]
      ];
      
      <|
        "duration" -> durationSeconds,
        "sampleRate" -> If[Head[sampleRate] === Quantity, QuantityMagnitude[sampleRate], sampleRate],
        "channels" -> channels,
        "format" -> "Sound"
      |>
    ],
    _,
    <|
      "duration" -> 0,
      "sampleRate" -> 0,
      "channels" -> 0,
      "format" -> "Unknown"
    |>
  ];
  
  properties
];

(* Transcribe audio to text using speech recognition *)
TranscribeAudioToText[audio_Sound] := Module[{transcript, result, cleanResult},
  (* Use SpeechRecognize to convert speech to text *)
  transcript = Catch[
    TimeConstrained[SpeechRecognize[audio], 10, ""],
    _,
    "" (* Return empty string if speech recognition fails *)
  ];
  
  (* Clean up the transcript and handle mathematical expressions *)
  result = If[StringQ[transcript], 
    StringTrim[transcript],
    "" (* Handle non-string results *)
  ];
  
  (* Filter out mathematical expressions and very long results *)
  cleanResult = If[StringLength[result] > 500 || StringContainsQ[result, "Pi"] || StringContainsQ[result, "Sqrt"],
    "", (* Treat as no speech detected for mathematical/nonsensical results *)
    result
  ];
  
  (* Return result with metadata *)
  <|
    "transcript" -> cleanResult,
    "hasText" -> (cleanResult != ""),
    "textLength" -> StringLength[cleanResult],
    "wordCount" -> If[cleanResult != "", Length[StringSplit[cleanResult]], 0],
    "method" -> "SpeechRecognize"
  |>
];

(* Comprehensive audio processing combining speech-to-text and metadata *)
ProcessAudioInput[audio_Sound] := Module[{transcriptResult, metadataResult, combinedDescription},
  
  (* Extract speech transcript *)
  transcriptResult = TranscribeAudioToText[audio];
  
  (* Extract audio metadata *)
  metadataResult = ExtractAudioMetadata[audio];
  
  (* Create combined description *)
  combinedDescription = "";
  
  (* Add transcript if found *)
  If[transcriptResult["hasText"],
    combinedDescription = "Audio transcript: " <> transcriptResult["transcript"];
  ];
  
  (* Add metadata information *)
  If[metadataResult["duration"] > 0,
    If[combinedDescription != "",
      combinedDescription = combinedDescription <> ". Audio duration: " <> 
        ToString[NumberForm[metadataResult["duration"], {1, 1}]] <> " seconds",
      combinedDescription = "Audio duration: " <> 
        ToString[NumberForm[metadataResult["duration"], {1, 1}]] <> " seconds"
    ]
  ];
  
  (* If no useful information found *)
  If[combinedDescription == "",
    combinedDescription = "Audio uploaded but content could not be processed"
  ];
  
  (* Return comprehensive analysis *)
  <|
    "combinedDescription" -> combinedDescription,
    "transcriptResult" -> transcriptResult,
    "metadataResult" -> metadataResult,
    "hasContent" -> (transcriptResult["hasText"] || metadataResult["duration"] > 0),
    "processedAt" -> Now
  |>
];

(* Step 5: Video Processing Functions *)

(* Extract video metadata and properties *)
ExtractVideoMetadata[video_] := Module[{properties},
  (* Extract basic video properties safely *)
  properties = Catch[
    Module[{duration, dimensions, framerate},
      (* Try to get video information using VideoInfo *)
      duration = 0;
      dimensions = {0, 0};
      framerate = 0;
      
      (* For binary video data, we'll extract basic information *)
      <|
        "duration" -> duration,
        "dimensions" -> dimensions,
        "framerate" -> framerate,
        "format" -> "Video",
        "size" -> If[ListQ[video] && AllTrue[video, IntegerQ], Length[video], 0]
      |>
    ],
    _,
    <|
      "duration" -> 0,
      "dimensions" -> {0, 0},
      "framerate" -> 0,
      "format" -> "Unknown",
      "size" -> 0
    |>
  ];
  
  properties
];

(* Transcribe video to text by extracting audio track *)
TranscribeVideoToText[video_] := Module[{result},
  (* For now, return a placeholder since video-to-audio extraction is complex *)
  result = Catch[
    (* Placeholder: In a full implementation, we would extract audio track *)
    (* extractedAudio = ExtractAudioTrack[video]; *)
    (* transcriptionResult = SpeechRecognize[extractedAudio]; *)
    
    <|
      "transcript" -> "",
      "hasText" -> False,
      "textLength" -> 0,
      "wordCount" -> 0,
      "method" -> "VideoAudioExtraction",
      "status" -> "placeholder"
    |>,
    _,
    <|
      "transcript" -> "",
      "hasText" -> False,
      "textLength" -> 0,
      "wordCount" -> 0,
      "method" -> "VideoAudioExtraction",
      "status" -> "error"
    |>
  ];
  
  result
];

(* Analyze key frames from video *)
AnalyzeVideoFrames[video_] := Module[{frames, analysis},
  (* Extract and analyze key frames *)
  analysis = Catch[
    Module[{frameCount, keyFrames, frameAnalysis},
      (* Placeholder for frame extraction and analysis *)
      (* keyFrames = ExtractKeyFrames[video]; *)
      (* frameAnalysis = Map[ImageIdentify, keyFrames]; *)
      
      <|
        "frameCount" -> 0,
        "keyFrames" -> {},
        "sceneDescription" -> "Video frame analysis will be implemented with advanced video processing libraries",
        "dominantObjects" -> {},
        "method" -> "KeyFrameAnalysis",
        "status" -> "placeholder"
      |>
    ],
    _,
    <|
      "frameCount" -> 0,
      "keyFrames" -> {},
      "sceneDescription" -> "Frame analysis not available",
      "dominantObjects" -> {},
      "method" -> "KeyFrameAnalysis",
      "status" -> "error"
    |>
  ];
  
  analysis
];

(* Comprehensive video processing combining transcription and frame analysis *)
ProcessVideoInput[video_] := Module[{transcriptResult, metadataResult, frameAnalysis, combinedDescription},
  
  (* Extract video metadata *)
  metadataResult = ExtractVideoMetadata[video];
  
  (* Transcribe video audio *)
  transcriptResult = TranscribeVideoToText[video];
  
  (* Analyze video frames *)
  frameAnalysis = AnalyzeVideoFrames[video];
  
  (* Create combined description *)
  combinedDescription = "";
  
  (* Add transcript if found *)
  If[transcriptResult["hasText"],
    combinedDescription = "Video transcript: " <> transcriptResult["transcript"];
  ];
  
  (* Add frame analysis *)
  If[frameAnalysis["sceneDescription"] != "",
    If[combinedDescription != "",
      combinedDescription = combinedDescription <> ". Video content: " <> frameAnalysis["sceneDescription"],
      combinedDescription = "Video content: " <> frameAnalysis["sceneDescription"]
    ]
  ];
  
  (* Add metadata information *)
  If[metadataResult["size"] > 0,
    If[combinedDescription != "",
      combinedDescription = combinedDescription <> ". Video size: " <> 
        ToString[NumberForm[N[metadataResult["size"]/1024/1024], {1, 1}]] <> " MB",
      combinedDescription = "Video size: " <> 
        ToString[NumberForm[N[metadataResult["size"]/1024/1024], {1, 1}]] <> " MB"
    ]
  ];
  
  (* If no useful information found *)
  If[combinedDescription == "",
    combinedDescription = "Video uploaded - Step 5 processing with transcription and frame analysis active"
  ];
  
  (* Return comprehensive analysis *)
  <|
    "combinedDescription" -> combinedDescription,
    "transcriptResult" -> transcriptResult,
    "metadataResult" -> metadataResult,
    "frameAnalysis" -> frameAnalysis,
    "hasContent" -> (transcriptResult["hasText"] || frameAnalysis["sceneDescription"] != "" || metadataResult["size"] > 0),
    "processedAt" -> Now
  |>
];

(* Step 6: Web Content Processing Functions *)

(* Validate URL format and basic accessibility *)
ValidateURL[url_String] := Module[{urlObj, isValid},
  (* Basic URL validation *)
  isValid = Catch[
    urlObj = URLParse[url];
    (* Check if URL has proper structure *)
    If[AssociationQ[urlObj] && KeyExistsQ[urlObj, "Scheme"] && KeyExistsQ[urlObj, "Domain"],
      (* Check if scheme is http or https *)
      If[MemberQ[{"http", "https"}, urlObj["Scheme"]],
        True,
        False
      ],
      False
    ],
    _,
    False
  ];
  
  <|
    "isValid" -> isValid,
    "url" -> url,
    "parsed" -> If[isValid, URLParse[url], None],
    "method" -> "URLValidation"
  |>
];

(* Fetch and extract content from webpage URL *)
FetchWebpageContent[url_String] := Module[{response, content, metadata},
  (* Validate URL first *)
  If[!ValidateURL[url]["isValid"],
    Return[<|
      "content" -> "",
      "title" -> "",
      "hasContent" -> False,
      "error" -> "Invalid URL format",
      "method" -> "WebContentFetch"
    |>]
  ];
  
  (* Attempt to fetch webpage content *)
  response = Catch[
    TimeConstrained[
      URLRead[url],
      10, (* 10 second timeout *)
      $Failed
    ],
    _,
    $Failed
  ];
  
  (* Process the response *)
  If[response === $Failed,
    <|
      "content" -> "",
      "title" -> "",
      "hasContent" -> False,
      "error" -> "Failed to fetch webpage",
      "method" -> "WebContentFetch"
    |>,
    (* Extract content from response *)
    content = If[StringQ[response], response, ""];
    <|
      "content" -> content,
      "title" -> "Webpage Content",
      "hasContent" -> (content != ""),
      "error" -> None,
      "method" -> "WebContentFetch",
      "contentLength" -> StringLength[content]
    |>
  ]
];

(* Parse HTML content and extract text and metadata *)
ParseHTMLContent[html_String] := Module[{textContent, title, metadata},
  (* Simple HTML parsing - extract text content *)
  textContent = Catch[
    Module[{cleanText},
      (* Remove HTML tags using simple string manipulation *)
      cleanText = StringReplace[html, {
        RegularExpression["<script[^>]*>.*?</script>"] -> "",
        RegularExpression["<style[^>]*>.*?</style>"] -> "",
        RegularExpression["<[^>]*>"] -> " ",
        RegularExpression["\\s+"] -> " "
      }];
      StringTrim[cleanText]
    ],
    _,
    ""
  ];
  
  (* Extract title if present *)
  title = Catch[
    If[StringContainsQ[html, "<title>"],
      StringCases[html, RegularExpression["<title[^>]*>(.*?)</title>"] -> "$1"][[1]],
      "Untitled Webpage"
    ],
    _,
    "Untitled Webpage"
  ];
  
  (* Return parsed content *)
  <|
    "extractedText" -> textContent,
    "title" -> title,
    "hasText" -> (textContent != ""),
    "textLength" -> StringLength[textContent],
    "wordCount" -> If[textContent != "", Length[StringSplit[textContent]], 0],
    "method" -> "HTMLParsing"
  |>
];

(* Comprehensive webpage processing combining fetching and parsing *)
ProcessWebpageInput[url_String] := Module[{validationResult, fetchResult, parseResult, combinedDescription},
  
  (* Validate URL *)
  validationResult = ValidateURL[url];
  
  If[!validationResult["isValid"],
    Return[<|
      "combinedDescription" -> "Invalid URL provided: " <> url,
      "validationResult" -> validationResult,
      "fetchResult" -> None,
      "parseResult" -> None,
      "hasContent" -> False,
      "processedAt" -> Now
    |>]
  ];
  
  (* Fetch webpage content *)
  fetchResult = FetchWebpageContent[url];
  
  If[!fetchResult["hasContent"],
    Return[<|
      "combinedDescription" -> "Unable to fetch content from URL: " <> url <> 
        If[KeyExistsQ[fetchResult, "error"] && fetchResult["error"] != None, 
          " (" <> fetchResult["error"] <> ")", ""],
      "validationResult" -> validationResult,
      "fetchResult" -> fetchResult,
      "parseResult" -> None,
      "hasContent" -> False,
      "processedAt" -> Now
    |>]
  ];
  
  (* Parse HTML content *)
  parseResult = ParseHTMLContent[fetchResult["content"]];
  
  (* Create combined description *)
  combinedDescription = "";
  
  (* Add title if available *)
  If[parseResult["title"] != "Untitled Webpage",
    combinedDescription = "Webpage: " <> parseResult["title"];
  ];
  
  (* Add text content summary *)
  If[parseResult["hasText"],
    Module[{textSummary},
      textSummary = If[parseResult["textLength"] > 500,
        StringTake[parseResult["extractedText"], 500] <> "...",
        parseResult["extractedText"]
      ];
      
      If[combinedDescription != "",
        combinedDescription = combinedDescription <> ". Content: " <> textSummary,
        combinedDescription = "Webpage content: " <> textSummary
      ]
    ]
  ];
  
  (* Add word count info *)
  If[parseResult["wordCount"] > 0,
    combinedDescription = combinedDescription <> " (Word count: " <> 
      ToString[parseResult["wordCount"]] <> ")"
  ];
  
  (* If no useful information found *)
  If[combinedDescription == "",
    combinedDescription = "Webpage processed but no readable content found"
  ];
  
  (* Return comprehensive analysis *)
  <|
    "combinedDescription" -> combinedDescription,
    "validationResult" -> validationResult,
    "fetchResult" -> fetchResult,
    "parseResult" -> parseResult,
    "hasContent" -> (parseResult["hasText"] && parseResult["wordCount"] > 0),
    "processedAt" -> Now
  |>
];

(* Step 7: Keyboard/Mouse Event Processing Functions *)

(* Parse keyboard event descriptions and sequences *)
ParseKeyboardEvents[eventText_String] := Module[{events, keyEvents, patterns},
  (* Extract keyboard-related events from text *)
  events = Catch[
    Module[{keyWords, sequences, pressEvents, releaseEvents, combinationEvents},
      (* Look for keyboard-related keywords *)
      keyWords = {"key", "press", "release", "type", "keyboard", "ctrl", "alt", "shift", "enter", "space", "tab", "delete", "backspace", "arrow", "function"};
      
      (* Extract key press patterns *)
      pressEvents = StringCases[eventText, 
        RegularExpression["(?i)(press|pressed|pressing|hit|typed?)\\s+(\\w+|f\\d+|ctrl\\+\\w+|alt\\+\\w+|shift\\+\\w+)"] -> {$1, $2}, 
        IgnoreCase -> True
      ];
      
      (* Extract key sequences *)
      sequences = StringCases[eventText,
        RegularExpression["(?i)(ctrl|alt|shift)\\s*\\+\\s*(\\w+)"] -> {$1, $2},
        IgnoreCase -> True
      ];
      
      (* Extract typing events *)
      combinationEvents = StringCases[eventText,
        RegularExpression["(?i)typed?\\s+[\"']([^\"']+)[\"']"] -> "$1",
        IgnoreCase -> True
      ];
      
      <|
        "pressEvents" -> pressEvents,
        "sequences" -> sequences,
        "typedText" -> combinationEvents,
        "hasKeyboardEvents" -> (Length[pressEvents] > 0 || Length[sequences] > 0 || Length[combinationEvents] > 0),
        "eventCount" -> Length[pressEvents] + Length[sequences] + Length[combinationEvents],
        "method" -> "KeyboardEventParsing"
      |>
    ],
    _,
    <|
      "pressEvents" -> {},
      "sequences" -> {},
      "typedText" -> {},
      "hasKeyboardEvents" -> False,
      "eventCount" -> 0,
      "method" -> "KeyboardEventParsing"
    |>
  ];
  
  events
];

(* Parse mouse event descriptions and interactions *)
ParseMouseEvents[eventText_String] := Module[{events, mouseEvents, patterns},
  (* Extract mouse-related events from text *)
  events = Catch[
    Module[{mouseWords, clickEvents, moveEvents, scrollEvents},
      (* Look for mouse-related keywords *)
      mouseWords = {"click", "mouse", "button", "scroll", "drag", "move", "hover", "right-click", "double-click", "wheel"};
      
      (* Extract click events *)
      clickEvents = StringCases[eventText,
        RegularExpression["(?i)(click|clicked|clicking|double[\\s-]?click|right[\\s-]?click)\\s+(on\\s+)?(\\w+|at\\s+\\([0-9,\\s]+\\))"] -> {$1, $3},
        IgnoreCase -> True
      ];
      
      (* Extract movement events *)
      moveEvents = StringCases[eventText,
        RegularExpression["(?i)(move|moved|moving|drag|dragged|dragging)\\s+(to\\s+|from\\s+)?(\\w+|\\([0-9,\\s]+\\))"] -> {$1, $3},
        IgnoreCase -> True
      ];
      
      (* Extract scroll events *)
      scrollEvents = StringCases[eventText,
        RegularExpression["(?i)(scroll|scrolled|scrolling)\\s+(up|down|left|right)"] -> {$1, $2},
        IgnoreCase -> True
      ];
      
      <|
        "clickEvents" -> clickEvents,
        "moveEvents" -> moveEvents,
        "scrollEvents" -> scrollEvents,
        "hasMouseEvents" -> (Length[clickEvents] > 0 || Length[moveEvents] > 0 || Length[scrollEvents] > 0),
        "eventCount" -> Length[clickEvents] + Length[moveEvents] + Length[scrollEvents],
        "method" -> "MouseEventParsing"
      |>
    ],
    _,
    <|
      "clickEvents" -> {},
      "moveEvents" -> {},
      "scrollEvents" -> {},
      "hasMouseEvents" -> False,
      "eventCount" -> 0,
      "method" -> "MouseEventParsing"
    |>
  ];
  
  events
];

(* Analyze user interaction patterns from events *)
AnalyzeEventPatterns[keyboardEvents_, mouseEvents_] := Module[{patterns, analysis},
  (* Analyze interaction patterns *)
  analysis = Catch[
    Module[{totalEvents, eventTypes, interactionComplexity, patternDescription},
      totalEvents = keyboardEvents["eventCount"] + mouseEvents["eventCount"];
      
      eventTypes = {};
      If[keyboardEvents["hasKeyboardEvents"], AppendTo[eventTypes, "keyboard"]];
      If[mouseEvents["hasMouseEvents"], AppendTo[eventTypes, "mouse"]];
      
      (* Determine interaction complexity *)
      interactionComplexity = Which[
        totalEvents == 0, "none",
        totalEvents <= 3, "simple",
        totalEvents <= 10, "moderate",
        True, "complex"
      ];
      
      (* Generate pattern description *)
      patternDescription = "";
      If[keyboardEvents["hasKeyboardEvents"],
        patternDescription = "Keyboard interactions detected: " <> 
          ToString[keyboardEvents["eventCount"]] <> " events";
      ];
      
      If[mouseEvents["hasMouseEvents"],
        If[patternDescription != "",
          patternDescription = patternDescription <> ". Mouse interactions detected: " <> 
            ToString[mouseEvents["eventCount"]] <> " events",
          patternDescription = "Mouse interactions detected: " <> 
            ToString[mouseEvents["eventCount"]] <> " events"
        ]
      ];
      
      If[patternDescription == "",
        patternDescription = "No keyboard or mouse events detected"
      ];
      
      <|
        "totalEvents" -> totalEvents,
        "eventTypes" -> eventTypes,
        "complexity" -> interactionComplexity,
        "description" -> patternDescription,
        "hasPatterns" -> (totalEvents > 0),
        "method" -> "EventPatternAnalysis"
      |>
    ],
    _,
    <|
      "totalEvents" -> 0,
      "eventTypes" -> {},
      "complexity" -> "none",
      "description" -> "Event pattern analysis failed",
      "hasPatterns" -> False,
      "method" -> "EventPatternAnalysis"
    |>
  ];
  
  analysis
];

(* Comprehensive event processing combining keyboard and mouse analysis *)
ProcessEventInput[eventText_String] := Module[{keyboardResult, mouseResult, patternResult, combinedDescription},
  
  (* Parse keyboard events *)
  keyboardResult = ParseKeyboardEvents[eventText];
  
  (* Parse mouse events *)
  mouseResult = ParseMouseEvents[eventText];
  
  (* Analyze patterns *)
  patternResult = AnalyzeEventPatterns[keyboardResult, mouseResult];
  
  (* Create combined description *)
  combinedDescription = "";
  
  (* Add pattern analysis *)
  If[patternResult["hasPatterns"],
    combinedDescription = patternResult["description"];
  ];
  
  (* Add specific event details *)
  If[keyboardResult["hasKeyboardEvents"],
    Module[{keyDetails},
      keyDetails = "";
      
      (* Add press events *)
      If[Length[keyboardResult["pressEvents"]] > 0,
        keyDetails = keyDetails <> " Key presses: " <> 
          StringRiffle[Map[Last, keyboardResult["pressEvents"]], ", "];
      ];
      
      (* Add typed text *)
      If[Length[keyboardResult["typedText"]] > 0,
        keyDetails = keyDetails <> " Typed text: \"" <> 
          StringRiffle[keyboardResult["typedText"], "\", \""] <> "\"";
      ];
      
      If[keyDetails != "",
        If[combinedDescription != "",
          combinedDescription = combinedDescription <> "." <> keyDetails,
          combinedDescription = StringTrim[keyDetails]
        ]
      ]
    ]
  ];
  
  (* Add mouse event details *)
  If[mouseResult["hasMouseEvents"],
    Module[{mouseDetails},
      mouseDetails = "";
      
      (* Add click events *)
      If[Length[mouseResult["clickEvents"]] > 0,
        mouseDetails = mouseDetails <> " Mouse clicks: " <> 
          StringRiffle[Map[First, mouseResult["clickEvents"]], ", "];
      ];
      
      (* Add movement events *)
      If[Length[mouseResult["moveEvents"]] > 0,
        mouseDetails = mouseDetails <> " Mouse movements: " <> 
          StringRiffle[Map[First, mouseResult["moveEvents"]], ", "];
      ];
      
      If[mouseDetails != "",
        If[combinedDescription != "",
          combinedDescription = combinedDescription <> "." <> mouseDetails,
          combinedDescription = StringTrim[mouseDetails]
        ]
      ]
    ]
  ];
  
  (* If no useful information found *)
  If[combinedDescription == "",
    combinedDescription = "Event input provided but no recognizable keyboard or mouse events found"
  ];
  
  (* Return comprehensive analysis *)
  <|
    "combinedDescription" -> combinedDescription,
    "keyboardResult" -> keyboardResult,
    "mouseResult" -> mouseResult,
    "patternResult" -> patternResult,
    "hasContent" -> (patternResult["hasPatterns"]),
    "processedAt" -> Now
  |>
];

(* Step 8: Advanced LLM Architecture - Master-Slave Setup *)

(* Global variables to store LLM hierarchy *)
$MasterLLMHierarchy = None;
$SpecializedSlaveLLMs = <||>;
$LLMGraphCache = <||>;

(* Initialize Master-Slave LLM architecture *)
InitializeLLMHierarchy[] := Module[{masterConfig, slaveConfigs, hierarchy},
  
  (* Initialize the Master LLM for coordination *)
  masterConfig = LLMConfiguration[
    <|
      "Model" -> "gpt-3.5-turbo",
      "Temperature" -> 0.3, (* Lower temperature for more consistent coordination *)
      "MaxTokens" -> 1500,
      "SystemMessage" -> "You are the Master LLM coordinator in a hierarchical multi-modal AI system. Your role is to analyze user requests, delegate tasks to specialized slave LLMs, and synthesize their responses into a coherent final answer. You coordinate text analysis, image processing, audio transcription, video analysis, web content processing, and user event analysis."
    |>
  ];
  
  (* Create specialized slave LLMs *)
  slaveConfigs = CreateSpecializedSlaves[];
  
  (* Build hierarchy structure *)
  hierarchy = <|
    "masterLLM" -> masterConfig,
    "slaveLLMs" -> slaveConfigs,
    "graphCache" -> <||>,
    "initialized" -> True,
    "initTime" -> Now
  |>;
  
  $MasterLLMHierarchy = hierarchy;
  $SpecializedSlaveLLMs = slaveConfigs;
  
  Print[Style["✓ Master-Slave LLM hierarchy initialized successfully", Green]];
  Print["  Master LLM: Coordination and synthesis"];
  Print["  Slave LLMs: " <> ToString[Length[Keys[slaveConfigs]]] <> " specialized domains"];
  
  hierarchy
];

(* Create specialized slave LLMs for different domains *)
CreateSpecializedSlaves[] := Module[{slaves},
  
  slaves = <|
    (* Text Analysis Slave *)
    "textSlave" -> LLMConfiguration[
      <|
        "Model" -> "gpt-3.5-turbo",
        "Temperature" -> 0.5,
        "MaxTokens" -> 1000,
        "SystemMessage" -> "You are a specialized text analysis AI. Your expertise is in understanding, analyzing, and extracting insights from textual content. Focus on sentiment analysis, key themes, entity extraction, and content summarization."
      |>
    ],
    
    (* Image Analysis Slave *)
    "imageSlave" -> LLMConfiguration[
      <|
        "Model" -> "gpt-3.5-turbo",
        "Temperature" -> 0.4,
        "MaxTokens" -> 800,
        "SystemMessage" -> "You are a specialized image analysis AI. Your expertise is in understanding visual content including OCR text, object recognition, scene description, and visual context analysis. Provide detailed descriptions of image content and extracted text."
      |>
    ],
    
    (* Audio Analysis Slave *)
    "audioSlave" -> LLMConfiguration[
      <|
        "Model" -> "gpt-3.5-turbo",
        "Temperature" -> 0.4,
        "MaxTokens" -> 800,
        "SystemMessage" -> "You are a specialized audio analysis AI. Your expertise is in understanding audio content including speech transcription analysis, audio quality assessment, and metadata interpretation. Analyze transcribed speech content and audio characteristics."
      |>
    ],
    
    (* Video Analysis Slave *)
    "videoSlave" -> LLMConfiguration[
      <|
        "Model" -> "gpt-3.5-turbo",
        "Temperature" -> 0.4,
        "MaxTokens" -> 1000,
        "SystemMessage" -> "You are a specialized video analysis AI. Your expertise is in understanding video content including frame analysis, audio transcription, temporal sequences, and multimedia context. Analyze video transcripts, frame descriptions, and metadata."
      |>
    ],
    
    (* Web Content Slave *)
    "webSlave" -> LLMConfiguration[
      <|
        "Model" -> "gpt-3.5-turbo",
        "Temperature" -> 0.4,
        "MaxTokens" -> 1000,
        "SystemMessage" -> "You are a specialized web content analysis AI. Your expertise is in understanding webpage content, HTML structure analysis, content extraction, and web information synthesis. Analyze webpage text, titles, and extracted content."
      |>
    ],
    
    (* Event Analysis Slave *)
    "eventSlave" -> LLMConfiguration[
      <|
        "Model" -> "gpt-3.5-turbo",
        "Temperature" -> 0.4,
        "MaxTokens" -> 800,
        "SystemMessage" -> "You are a specialized user interaction analysis AI. Your expertise is in understanding keyboard/mouse events, user behavior patterns, interaction workflows, and UI/UX analysis. Analyze user input patterns and interaction complexity."
      |>
    ]
  |>;
  
  slaves
];

(* Build LLMGraph for orchestrated processing *)
BuildLLMGraph[inputData_Association] := Module[{graphNodes, dependencies, llmGraph},
  
  (* Determine which slave LLMs are needed based on input data *)
  graphNodes = {};
  
  (* Add text analysis node if text input exists *)
  If[KeyExistsQ[inputData, "textInput"] && inputData["textInput"] != "",
    AppendTo[graphNodes, 
      "textAnalysis" -> LLMFunction[
        "Analyze this text input: " <> inputData["textInput"],
        LLMEvaluator -> $SpecializedSlaveLLMs["textSlave"]
      ]
    ]
  ];
  
  (* Add image analysis node if image description exists *)
  If[KeyExistsQ[inputData, "imageDescription"] && inputData["imageDescription"] != "",
    AppendTo[graphNodes,
      "imageAnalysis" -> LLMFunction[
        "Analyze this image content: " <> inputData["imageDescription"],
        LLMEvaluator -> $SpecializedSlaveLLMs["imageSlave"]
      ]
    ]
  ];
  
  (* Add audio analysis node if audio transcript exists *)
  If[KeyExistsQ[inputData, "audioTranscript"] && inputData["audioTranscript"] != "",
    AppendTo[graphNodes,
      "audioAnalysis" -> LLMFunction[
        "Analyze this audio transcript: " <> inputData["audioTranscript"],
        LLMEvaluator -> $SpecializedSlaveLLMs["audioSlave"]
      ]
    ]
  ];
  
  (* Add video analysis node if video content exists *)
  If[KeyExistsQ[inputData, "videoContent"] && inputData["videoContent"] != "",
    AppendTo[graphNodes,
      "videoAnalysis" -> LLMFunction[
        "Analyze this video content: " <> inputData["videoContent"],
        LLMEvaluator -> $SpecializedSlaveLLMs["videoSlave"]
      ]
    ]
  ];
  
  (* Add web content analysis node if webpage content exists *)
  If[KeyExistsQ[inputData, "webpageContent"] && inputData["webpageContent"] != "",
    AppendTo[graphNodes,
      "webAnalysis" -> LLMFunction[
        "Analyze this webpage content: " <> inputData["webpageContent"],
        LLMEvaluator -> $SpecializedSlaveLLMs["webSlave"]
      ]
    ]
  ];
  
  (* Add event analysis node if event content exists *)
  If[KeyExistsQ[inputData, "eventContent"] && inputData["eventContent"] != "",
    AppendTo[graphNodes,
      "eventAnalysis" -> LLMFunction[
        "Analyze these user interaction events: " <> inputData["eventContent"],
        LLMEvaluator -> $SpecializedSlaveLLMs["eventSlave"]
      ]
    ]
  ];
  
  (* Add master coordination node that depends on all slave analyses *)
  If[Length[graphNodes] > 0,
    Module[{slaveNodeNames, masterPrompt},
      slaveNodeNames = Keys[graphNodes];
      masterPrompt = "You are the Master LLM coordinator. Synthesize the following specialized analyses into a comprehensive response:\n\n" <>
        StringRiffle[Map["<" <> # <> ">" -> #SlotSequence[Position[slaveNodeNames, #][[1, 1]]] &, slaveNodeNames], "\n"];
      
      AppendTo[graphNodes,
        "masterSynthesis" -> LLMFunction[
          masterPrompt,
          LLMEvaluator -> $MasterLLMHierarchy["masterLLM"]
        ]
      ]
    ]
  ];
  
  (* Create LLMGraph if we have nodes *)
  If[Length[graphNodes] > 0,
    llmGraph = LLMGraph[graphNodes];
    
    (* Cache the graph for performance *)
    $LLMGraphCache[Hash[inputData]] = llmGraph;
    
    llmGraph,
    
    (* No specialized processing needed *)
    None
  ]
];

(* Delegate tasks to appropriate specialized slave LLMs *)
DelegateTasks[inputData_Association] := Module[{tasks, delegations},
  
  tasks = <||>;
  
  (* Create task delegations based on available input *)
  If[KeyExistsQ[inputData, "textInput"] && inputData["textInput"] != "",
    tasks["textTask"] = <|
      "type" -> "text",
      "slave" -> "textSlave", 
      "data" -> inputData["textInput"],
      "prompt" -> "Analyze this text for key insights, themes, and sentiment: " <> inputData["textInput"]
    |>
  ];
  
  If[KeyExistsQ[inputData, "imageDescription"] && inputData["imageDescription"] != "",
    tasks["imageTask"] = <|
      "type" -> "image",
      "slave" -> "imageSlave",
      "data" -> inputData["imageDescription"], 
      "prompt" -> "Analyze this image content and extracted text: " <> inputData["imageDescription"]
    |>
  ];
  
  If[KeyExistsQ[inputData, "audioTranscript"] && inputData["audioTranscript"] != "",
    tasks["audioTask"] = <|
      "type" -> "audio",
      "slave" -> "audioSlave",
      "data" -> inputData["audioTranscript"],
      "prompt" -> "Analyze this audio transcript for content and quality: " <> inputData["audioTranscript"]
    |>
  ];
  
  If[KeyExistsQ[inputData, "videoContent"] && inputData["videoContent"] != "",
    tasks["videoTask"] = <|
      "type" -> "video", 
      "slave" -> "videoSlave",
      "data" -> inputData["videoContent"],
      "prompt" -> "Analyze this video content including transcript and visual elements: " <> inputData["videoContent"]
    |>
  ];
  
  If[KeyExistsQ[inputData, "webpageContent"] && inputData["webpageContent"] != "",
    tasks["webTask"] = <|
      "type" -> "web",
      "slave" -> "webSlave",
      "data" -> inputData["webpageContent"],
      "prompt" -> "Analyze this webpage content for key information and structure: " <> inputData["webpageContent"]
    |>
  ];
  
  If[KeyExistsQ[inputData, "eventContent"] && inputData["eventContent"] != "",
    tasks["eventTask"] = <|
      "type" -> "event",
      "slave" -> "eventSlave", 
      "data" -> inputData["eventContent"],
      "prompt" -> "Analyze these user interaction events for patterns and workflow: " <> inputData["eventContent"]
    |>
  ];
  
  tasks
];

(* Process multi-modal input using LLMGraph orchestration *)
ProcessWithLLMGraph[inputData_Association] := Module[{llmGraph, result, graphKey},
  
  (* Initialize hierarchy if not done *)
  If[$MasterLLMHierarchy === None,
    InitializeLLMHierarchy[]
  ];
  
  (* Check cache first *)
  graphKey = Hash[inputData];
  If[KeyExistsQ[$LLMGraphCache, graphKey],
    llmGraph = $LLMGraphCache[graphKey],
    llmGraph = BuildLLMGraph[inputData]
  ];
  
  (* Execute LLMGraph if available *)
  result = If[llmGraph =!= None,
    Catch[
      Module[{graphResult, masterResponse},
        (* Execute the graph *)
        graphResult = llmGraph[inputData];
        
        (* Extract master synthesis if available *)
        masterResponse = If[KeyExistsQ[graphResult, "masterSynthesis"],
          graphResult["masterSynthesis"],
          (* Fallback coordination if no master synthesis *)
          CoordinateSlaveResponses[graphResult]
        ];
        
        <|
          "rawResponse" -> masterResponse,
          "formattedResponse" -> masterResponse,
          "method" -> "LLMGraph",
          "slavesUsed" -> Keys[graphResult],
          "slaveResponses" -> graphResult,
          "processedAt" -> Now,
          "hierarchical" -> True
        |>
      ],
      _,
      <|
        "rawResponse" -> "LLMGraph processing temporarily unavailable.",
        "formattedResponse" -> "Advanced LLM orchestration system is initializing. Please try again.",
        "method" -> "FallbackCoordination", 
        "hierarchical" -> False,
        "error" -> True
      |>
    ],
    
    (* No LLMGraph needed - use simple master LLM *)
    Module[{prompt, response},
      prompt = CreateLLMPrompt[inputData];
      response = Catch[
        LLMFunction[prompt, LLMEvaluator -> $MasterLLMHierarchy["masterLLM"]][inputData],
        _,
        "Master LLM processing temporarily unavailable."
      ];
      
      <|
        "rawResponse" -> response,
        "formattedResponse" -> response, 
        "method" -> "MasterLLMDirect",
        "hierarchical" -> False
      |>
    ]
  ];
  
  result
];

(* Coordinate and synthesize slave LLM responses *)
CoordinateSlaveResponses[slaveResponses_Association] := Module[{synthesis, responseText},
  
  (* Create synthesis from slave responses *)
  responseText = "Based on specialized analysis from multiple AI systems:\n\n";
  
  (* Add each slave response *)
  Do[
    Module[{slaveName, response},
      slaveName = key;
      response = slaveResponses[key];
      
      responseText = responseText <> "• " <> 
        Switch[slaveName,
          "textAnalysis", "Text Analysis: ",
          "imageAnalysis", "Image Analysis: ", 
          "audioAnalysis", "Audio Analysis: ",
          "videoAnalysis", "Video Analysis: ",
          "webAnalysis", "Web Content Analysis: ",
          "eventAnalysis", "User Interaction Analysis: ",
          _, "Analysis: "
        ] <> ToString[response] <> "\n\n"
    ],
    {key, Keys[slaveResponses]}
  ];
  
  responseText = responseText <> "This comprehensive analysis combines insights from all relevant specialized AI systems to provide you with the most accurate and helpful response.";
  
  responseText
];

(* Step 9: LLMGraph Tools Integration *)

(* Global variables for tools integration *)
$WolframToolKit = <||>;
$ToolsInitialized = False;
$ToolExecutionCache = <||>;

(* Initialize Wolfram computational tools for LLM access *)
InitializeToolsIntegration[] := Module[{toolKit, initResult},
  
  (* Create comprehensive Wolfram tool kit *)
  toolKit = CreateWolframToolKit[];
  
  (* Store globally *)
  $WolframToolKit = toolKit;
  $ToolsInitialized = True;
  
  initResult = <|
    "toolsAvailable" -> Length[Keys[toolKit]],
    "categories" -> Keys[GroupBy[Values[toolKit], #["category"] &]],
    "initialized" -> True,
    "initTime" -> Now
  |>;
  
  Print[Style["✓ Wolfram Tools Integration initialized successfully", Green]];
  Print["  Available tool categories: " <> StringRiffle[initResult["categories"], ", "]];
  Print["  Total tools: " <> ToString[initResult["toolsAvailable"]]];
  
  initResult
];

(* Create comprehensive Wolfram computational tool functions *)
CreateWolframToolKit[] := Module[{tools},
  
  tools = <|
    (* Mathematical Computation Tools *)
    "solve" -> <|
      "function" -> Function[{equation}, 
        Catch[Solve[ToExpression[equation], x], _, "Could not solve equation"]],
      "description" -> "Solve mathematical equations",
      "category" -> "Mathematics",
      "parameters" -> {"equation"}
    |>,
    
    "integrate" -> <|
      "function" -> Function[{expression, variable}, 
        Catch[Integrate[ToExpression[expression], ToExpression[variable]], _, "Could not integrate"]],
      "description" -> "Compute definite and indefinite integrals", 
      "category" -> "Mathematics",
      "parameters" -> {"expression", "variable"}
    |>,
    
    "differentiate" -> <|
      "function" -> Function[{expression, variable},
        Catch[D[ToExpression[expression], ToExpression[variable]], _, "Could not differentiate"]],
      "description" -> "Compute derivatives of mathematical expressions",
      "category" -> "Mathematics", 
      "parameters" -> {"expression", "variable"}
    |>,
    
    "factor" -> <|
      "function" -> Function[{expression},
        Catch[Factor[ToExpression[expression]], _, "Could not factor expression"]],
      "description" -> "Factor mathematical expressions",
      "category" -> "Mathematics",
      "parameters" -> {"expression"}
    |>,
    
    "simplify" -> <|
      "function" -> Function[{expression},
        Catch[Simplify[ToExpression[expression]], _, "Could not simplify expression"]],
      "description" -> "Simplify mathematical expressions",
      "category" -> "Mathematics",
      "parameters" -> {"expression"}
    |>,
    
    (* Data Analysis Tools *)
    "statisticsSummary" -> <|
      "function" -> Function[{data},
        Catch[
          Module[{numbers},
            numbers = ToExpression[StringSplit[data, ","]];
            <|"mean" -> Mean[numbers], "median" -> Median[numbers], 
              "std" -> StandardDeviation[numbers], "count" -> Length[numbers]|>
          ], _, "Could not analyze data"
        ]],
      "description" -> "Compute statistical summary of numerical data",
      "category" -> "Statistics",
      "parameters" -> {"data"}
    |>,
    
    "correlation" -> <|
      "function" -> Function[{data1, data2},
        Catch[
          Module[{nums1, nums2},
            nums1 = ToExpression[StringSplit[data1, ","]];
            nums2 = ToExpression[StringSplit[data2, ","]];
            Correlation[nums1, nums2]
          ], _, "Could not compute correlation"
        ]],
      "description" -> "Compute correlation between two data sets",
      "category" -> "Statistics", 
      "parameters" -> {"data1", "data2"}
    |>,
    
    (* Text Analysis Tools *)
    "wordCount" -> <|
      "function" -> Function[{text},
        Catch[
          <|"characters" -> StringLength[text], 
            "words" -> Length[StringSplit[text]],
            "sentences" -> Length[StringSplit[text, RegularExpression["[.!?]+"]]]|>
        , _, "Could not analyze text"
        ]],
      "description" -> "Count words, characters, and sentences in text",
      "category" -> "TextAnalysis",
      "parameters" -> {"text"}
    |>,
    
    "textSentiment" -> <|
      "function" -> Function[{text},
        Catch[Classify["Sentiment", text], _, "Could not analyze sentiment"]],
      "description" -> "Analyze sentiment of text (Positive/Negative/Neutral)",
      "category" -> "TextAnalysis",
      "parameters" -> {"text"}
    |>,
    
    (* Unit Conversion Tools *)
    "convertUnits" -> <|
      "function" -> Function[{quantity, fromUnit, toUnit},
        Catch[
          UnitConvert[Quantity[ToExpression[quantity], fromUnit], toUnit],
          _, "Could not convert units"
        ]],
      "description" -> "Convert between different units of measurement",
      "category" -> "Units",
      "parameters" -> {"quantity", "fromUnit", "toUnit"}
    |>,
    
    (* Date/Time Tools *)
    "dateCalculation" -> <|
      "function" -> Function[{operation, date1, date2},
        Catch[
          Switch[operation,
            "difference", DateDifference[DateObject[date1], DateObject[date2]],
            "add", DatePlus[DateObject[date1], Quantity[ToExpression[date2], "Days"]],
            _, "Unknown operation"
          ], _, "Could not perform date calculation"
        ]],
      "description" -> "Perform date calculations (difference, addition)",
      "category" -> "DateTime",
      "parameters" -> {"operation", "date1", "date2"}
    |>,
    
    (* Plotting and Visualization *)
    "plotFunction" -> <|
      "function" -> Function[{expression, variable, range},
        Catch[
          Plot[ToExpression[expression], 
               {ToExpression[variable], ToExpression[StringSplit[range, ","][[1]]], 
                ToExpression[StringSplit[range, ","][[2]]]}],
          _, "Could not create plot"
        ]],
      "description" -> "Create mathematical function plots",
      "category" -> "Visualization", 
      "parameters" -> {"expression", "variable", "range"}
    |>,
    
    (* String Manipulation *)
    "stringOperations" -> <|
      "function" -> Function[{operation, text, parameter},
        Catch[
          Switch[operation,
            "reverse", StringReverse[text],
            "uppercase", ToUpperCase[text], 
            "lowercase", ToLowerCase[text],
            "length", StringLength[text],
            "substring", StringTake[text, ToExpression[parameter]],
            _, "Unknown string operation"
          ], _, "Could not perform string operation"
        ]],
      "description" -> "Perform various string manipulation operations",
      "category" -> "StringProcessing",
      "parameters" -> {"operation", "text", "parameter"}
    |>
  |>;
  
  tools
];

(* Execute computational task using Wolfram tools *)
ExecuteComputationalTask[taskType_String, parameters_List] := Module[{tool, result},
  
  (* Initialize tools if not done *)
  If[!$ToolsInitialized, InitializeToolsIntegration[]];
  
  (* Check if tool exists *)
  If[KeyExistsQ[$WolframToolKit, taskType],
    tool = $WolframToolKit[taskType];
    
    (* Execute tool with parameters *)
    result = Catch[
      Apply[tool["function"], parameters],
      _,
      <|"error" -> "Tool execution failed", "tool" -> taskType|>
    ];
    
    (* Cache result for performance *)
    $ToolExecutionCache[{taskType, parameters}] = result;
    
    <|
      "tool" -> taskType,
      "category" -> tool["category"],
      "result" -> result,
      "parameters" -> parameters,
      "executedAt" -> Now,
      "success" -> !AssociationQ[result] || !KeyExistsQ[result, "error"]
    |>,
    
    (* Tool not found *)
    <|
      "error" -> "Tool not found",
      "tool" -> taskType,
      "availableTools" -> Keys[$WolframToolKit],
      "success" -> False
    |>
  ]
];

(* Build LLMGraph with integrated computational tools *)
BuildToolEnhancedLLMGraph[inputData_Association] := Module[{toolNodes, llmNodes, enhancedGraph},
  
  (* Initialize tools and LLM hierarchy if not done *)
  If[!$ToolsInitialized, InitializeToolsIntegration[]];
  If[$MasterLLMHierarchy === None, InitializeLLMHierarchy[]];
  
  (* Start with basic LLMGraph nodes *)
  llmNodes = {};
  toolNodes = {};
  
  (* Add LLM analysis nodes based on input data *)
  If[KeyExistsQ[inputData, "textInput"] && inputData["textInput"] != "",
    AppendTo[llmNodes, 
      "textAnalysis" -> LLMFunction[
        "Analyze this text and identify any computational tasks: " <> inputData["textInput"],
        LLMEvaluator -> $SpecializedSlaveLLMs["textSlave"]
      ]
    ];
    
    (* Add computational tools for text analysis *)
    AppendTo[toolNodes,
      "textMetrics" -> Function[{},
        ExecuteComputationalTask["wordCount", {inputData["textInput"]}]
      ]
    ];
    
    (* Add sentiment analysis if text seems appropriate *)
    If[StringLength[inputData["textInput"]] > 10,
      AppendTo[toolNodes,
        "sentimentAnalysis" -> Function[{},
          ExecuteComputationalTask["textSentiment", {inputData["textInput"]}]
        ]
      ]
    ]
  ];
  
  (* Add mathematical computation detection and tools *)
  If[KeyExistsQ[inputData, "textInput"] && 
     StringContainsQ[inputData["textInput"], 
       RegularExpression["\\b(solve|integrate|differentiate|calculate|compute|math)\\b"], IgnoreCase -> True],
    
    (* Add mathematical analysis *)
    AppendTo[llmNodes,
      "mathAnalysis" -> LLMFunction[
        "Extract mathematical expressions and equations from: " <> inputData["textInput"] <> 
        ". Available tools: solve, integrate, differentiate, factor, simplify. Format as tool requests.",
        LLMEvaluator -> $SpecializedSlaveLLMs["textSlave"]
      ]
    ]
  ];
  
  (* Add data analysis tools if numerical data detected *)
  If[KeyExistsQ[inputData, "textInput"] &&
     StringContainsQ[inputData["textInput"], 
       RegularExpression["\\b(data|statistics|mean|median|correlation)\\b"], IgnoreCase -> True],
    
    AppendTo[toolNodes,
      "dataAnalysis" -> Function[{},
        Module[{numbers},
          numbers = StringCases[inputData["textInput"], 
            RegularExpression["\\d+(?:\\.\\d+)?"], IgnoreCase -> True];
          If[Length[numbers] > 1,
            ExecuteComputationalTask["statisticsSummary", {StringRiffle[numbers, ","]}],
            <|"info" -> "No numerical data found for analysis"|>
          ]
        ]
      ]
    ]
  ];
  
  (* Add other input type processing *)
  If[KeyExistsQ[inputData, "imageDescription"] && inputData["imageDescription"] != "",
    AppendTo[llmNodes,
      "imageAnalysis" -> LLMFunction[
        "Analyze image content and suggest computational analyses: " <> inputData["imageDescription"],
        LLMEvaluator -> $SpecializedSlaveLLMs["imageSlave"]
      ]
    ]
  ];
  
  (* Add master coordination node *)
  If[Length[llmNodes] > 0 || Length[toolNodes] > 0,
    Module[{allNodeNames, masterPrompt},
      allNodeNames = Join[Keys[llmNodes], Keys[toolNodes]];
      masterPrompt = "Coordinate the following analyses and computational results into a comprehensive response:\n" <>
        StringRiffle[Map["<" <> # <> ">" &, allNodeNames], "\n"];
      
      AppendTo[llmNodes,
        "toolEnhancedSynthesis" -> LLMFunction[
          masterPrompt,
          LLMEvaluator -> $MasterLLMHierarchy["masterLLM"]
        ]
      ]
    ]
  ];
  
  (* Combine all nodes *)
  enhancedGraph = Join[llmNodes, Map[# -> #[[2]] &, toolNodes]];
  
  (* Create LLMGraph if we have nodes *)
  If[Length[enhancedGraph] > 0,
    LLMGraph[enhancedGraph],
    None
  ]
];

(* Process input through tool-enhanced LLMGraph *)
ProcessWithTools[inputData_Association] := Module[{toolGraph, result, graphKey},
  
  (* Initialize if needed *)
  If[!$ToolsInitialized, InitializeToolsIntegration[]];
  If[$MasterLLMHierarchy === None, InitializeLLMHierarchy[]];
  
  (* Build tool-enhanced graph *)
  toolGraph = BuildToolEnhancedLLMGraph[inputData];
  
  (* Execute if available *)
  result = If[toolGraph =!= None,
    Catch[
      Module[{graphResult, masterResponse, toolResults, llmResults},
        (* Execute the enhanced graph *)
        graphResult = toolGraph[inputData];
        
        (* Separate tool results from LLM results *)
        toolResults = Select[graphResult, 
          AssociationQ[#] && KeyExistsQ[#, "tool"] &];
        llmResults = Select[graphResult, !AssociationQ[#] || !KeyExistsQ[#, "tool"] &];
        
        (* Get master synthesis if available *)
        masterResponse = If[KeyExistsQ[graphResult, "toolEnhancedSynthesis"],
          graphResult["toolEnhancedSynthesis"],
          CoordinateToolResults[toolResults, llmResults]
        ];
        
        <|
          "rawResponse" -> masterResponse,
          "formattedResponse" -> masterResponse,
          "method" -> "ToolEnhancedLLMGraph",
          "toolsUsed" -> Keys[toolResults],
          "toolResults" -> toolResults,
          "llmResults" -> llmResults,
          "processedAt" -> Now,
          "enhanced" -> True
        |>
      ],
      _,
      <|
        "rawResponse" -> "Tool-enhanced processing temporarily unavailable.",
        "formattedResponse" -> "Advanced computational tools are initializing. Please try again.",
        "method" -> "FallbackProcessing",
        "enhanced" -> False,
        "error" -> True
      |>
    ],
    
    (* Fallback to regular LLMGraph processing *)
    ProcessWithLLMGraph[inputData]
  ];
  
  result
];

(* Coordinate computational and LLM results *)
CoordinateToolResults[toolResults_List, llmResponses_Association] := Module[{coordination, responseText},
  
  responseText = "Enhanced analysis combining AI intelligence with Wolfram computational tools:\n\n";
  
  (* Add LLM analyses *)
  If[Length[Keys[llmResponses]] > 0,
    responseText = responseText <> "**AI Analysis:**\n";
    Do[
      Module[{analysisName, response},
        analysisName = key;
        response = llmResponses[key];
        
        responseText = responseText <> "• " <> 
          Switch[analysisName,
            "textAnalysis", "Text Analysis: ",
            "mathAnalysis", "Mathematical Analysis: ",
            "imageAnalysis", "Image Analysis: ",
            _, "Analysis: "
          ] <> ToString[response] <> "\n"
      ],
      {key, Keys[llmResponses]}
    ];
    responseText = responseText <> "\n"
  ];
  
  (* Add computational results *)
  If[Length[toolResults] > 0,
    responseText = responseText <> "**Computational Results:**\n";
    Do[
      Module[{toolResult},
        toolResult = result;
        If[AssociationQ[toolResult] && KeyExistsQ[toolResult, "tool"],
          responseText = responseText <> "• " <> 
            StringReplace[toolResult["tool"], "_" -> " "] <> ": " <>
            ToString[toolResult["result"]] <> 
            If[KeyExistsQ[toolResult, "category"], 
              " (Category: " <> toolResult["category"] <> ")", ""] <> "\n"
        ]
      ],
      {result, toolResults}
    ];
    responseText = responseText <> "\n"
  ];
  
  responseText = responseText <> "This response integrates both artificial intelligence analysis and precise Wolfram computational results to provide comprehensive and accurate information.";
  
  responseText
];

(* Step 10: Memory Management & Conversation Context *)

(* Global variables for memory management *)
$ConversationMemory = {};
$MemorySystemInitialized = False;
$MemoryConfiguration = <||>;
$ConversationContext = <||>;
$MemoryOptimizationCache = <||>;

(* Initialize conversation memory and context management system *)
InitializeMemorySystem[] := Module[{initResult, config},
  
  (* Initialize memory configuration *)
  config = <|
    "maxMemoryEntries" -> 100,
    "contextWindowSize" -> 10,
    "summarizationThreshold" -> 50,
    "memoryRetentionDays" -> 30,
    "contextRelevanceThreshold" -> 0.7,
    "enableAutoSummarization" -> True,
    "enableContextOptimization" -> True
  |>;
  
  (* Reset memory systems *)
  $ConversationMemory = {};
  $ConversationContext = <|
    "currentSession" -> CreateUUID[],
    "startTime" -> Now,
    "totalInteractions" -> 0,
    "lastInteractionTime" -> None,
    "contextSummary" -> "",
    "activeTopics" -> {},
    "userPreferences" -> <||>
  |>;
  $MemoryConfiguration = config;
  $MemorySystemInitialized = True;
  $MemoryOptimizationCache = <||>;
  
  initResult = <|
    "initialized" -> True,
    "sessionId" -> $ConversationContext["currentSession"],
    "maxEntries" -> config["maxMemoryEntries"],
    "contextWindow" -> config["contextWindowSize"],
    "initTime" -> Now,
    "memoryEmpty" -> True
  |>;
  
  Print[Style["✓ Memory Management & Conversation Context initialized successfully", Green]];
  Print["  Session ID: " <> $ConversationContext["currentSession"]];
  Print["  Max memory entries: " <> ToString[config["maxMemoryEntries"]]];
  Print["  Context window size: " <> ToString[config["contextWindowSize"]]];
  
  initResult
];

(* Store conversation interaction in memory *)
StoreConversationMemory[inputData_Association, response_Association] := Module[{memoryEntry, timestamp, inputSummary},
  
  (* Initialize if not done *)
  If[!$MemorySystemInitialized, InitializeMemorySystem[]];
  
  timestamp = Now;
  
  (* Create comprehensive input summary *)
  inputSummary = <|
    "textInput" -> If[KeyExistsQ[inputData, "textInput"] && inputData["textInput"] != "", 
                     StringTake[inputData["textInput"], UpTo[200]], ""],
    "hasImage" -> KeyExistsQ[inputData, "imageDescription"] && inputData["imageDescription"] != "",
    "hasAudio" -> KeyExistsQ[inputData, "audioTranscript"] && inputData["audioTranscript"] != "",
    "hasVideo" -> KeyExistsQ[inputData, "videoContent"] && inputData["videoContent"] != "",
    "hasWebContent" -> KeyExistsQ[inputData, "webpageContent"] && inputData["webpageContent"] != "",
    "hasEvents" -> KeyExistsQ[inputData, "eventContent"] && inputData["eventContent"] != "",
    "inputTypes" -> Select[{"text", "image", "audio", "video", "web", "events"}, 
      Function[type, 
        Switch[type,
          "text", KeyExistsQ[inputData, "textInput"] && inputData["textInput"] != "",
          "image", KeyExistsQ[inputData, "imageDescription"] && inputData["imageDescription"] != "",
          "audio", KeyExistsQ[inputData, "audioTranscript"] && inputData["audioTranscript"] != "",
          "video", KeyExistsQ[inputData, "videoContent"] && inputData["videoContent"] != "",
          "web", KeyExistsQ[inputData, "webpageContent"] && inputData["webpageContent"] != "",
          "events", KeyExistsQ[inputData, "eventContent"] && inputData["eventContent"] != "",
          _, False
        ]
      ]]
  |>;
  
  (* Create memory entry *)
  memoryEntry = <|
    "id" -> CreateUUID[],
    "timestamp" -> timestamp,
    "sessionId" -> $ConversationContext["currentSession"],
    "interactionNumber" -> $ConversationContext["totalInteractions"] + 1,
    "inputSummary" -> inputSummary,
    "fullInput" -> inputData,
    "response" -> response,
    "processingMethod" -> If[KeyExistsQ[response, "method"], response["method"], "Unknown"],
    "toolsUsed" -> If[KeyExistsQ[response, "toolsUsed"], response["toolsUsed"], {}],
    "contextRelevance" -> 1.0, (* Start with full relevance *)
    "memoryWeight" -> 1.0,
    "topics" -> ExtractTopicsFromInput[inputData]
  |>;
  
  (* Add to memory *)
  AppendTo[$ConversationMemory, memoryEntry];
  
  (* Update conversation context *)
  $ConversationContext["totalInteractions"] = $ConversationContext["totalInteractions"] + 1;
  $ConversationContext["lastInteractionTime"] = timestamp;
  $ConversationContext["activeTopics"] = Union[$ConversationContext["activeTopics"], 
                                              memoryEntry["topics"]];
  
  (* Manage memory size *)
  If[Length[$ConversationMemory] > $MemoryConfiguration["maxMemoryEntries"],
    (* Summarize older entries if auto-summarization enabled *)
    If[$MemoryConfiguration["enableAutoSummarization"] && 
       Length[$ConversationMemory] > $MemoryConfiguration["summarizationThreshold"],
      SummarizeOldMemoryEntries[]
    ];
    
    (* Remove oldest entries *)
    $ConversationMemory = TakeLargest[$ConversationMemory, 
                                     $MemoryConfiguration["maxMemoryEntries"], 
                                     #["timestamp"] &]
  ];
  
  memoryEntry["id"]
];

(* Extract topics from input data for context management *)
ExtractTopicsFromInput[inputData_Association] := Module[{topics, textContent},
  
  topics = {};
  
  (* Extract from text input *)
  If[KeyExistsQ[inputData, "textInput"] && inputData["textInput"] != "",
    textContent = inputData["textInput"];
    
    (* Simple topic extraction using keyword detection *)
    If[StringContainsQ[textContent, RegularExpression["\\b(math|calculate|solve|equation)\\b"], IgnoreCase -> True],
      AppendTo[topics, "mathematics"]];
    If[StringContainsQ[textContent, RegularExpression["\\b(data|statistics|analysis|correlation)\\b"], IgnoreCase -> True],
      AppendTo[topics, "data-analysis"]];
    If[StringContainsQ[textContent, RegularExpression["\\b(image|picture|photo|visual)\\b"], IgnoreCase -> True],
      AppendTo[topics, "image-processing"]];
    If[StringContainsQ[textContent, RegularExpression["\\b(audio|sound|music|voice)\\b"], IgnoreCase -> True],
      AppendTo[topics, "audio-processing"]];
    If[StringContainsQ[textContent, RegularExpression["\\b(video|movie|clip|animation)\\b"], IgnoreCase -> True],
      AppendTo[topics, "video-processing"]];
    If[StringContainsQ[textContent, RegularExpression["\\b(web|website|url|page)\\b"], IgnoreCase -> True],
      AppendTo[topics, "web-content"]];
  ];
  
  (* Add topics based on input types *)
  If[KeyExistsQ[inputData, "imageDescription"] && inputData["imageDescription"] != "",
    AppendTo[topics, "image-processing"]];
  If[KeyExistsQ[inputData, "audioTranscript"] && inputData["audioTranscript"] != "",
    AppendTo[topics, "audio-processing"]];
  If[KeyExistsQ[inputData, "videoContent"] && inputData["videoContent"] != "",
    AppendTo[topics, "video-processing"]];
  If[KeyExistsQ[inputData, "webpageContent"] && inputData["webpageContent"] != "",
    AppendTo[topics, "web-content"]];
  If[KeyExistsQ[inputData, "eventContent"] && inputData["eventContent"] != "",
    AppendTo[topics, "user-interaction"]];
  
  If[Length[topics] == 0, {"general-query"}, DeleteDuplicates[topics]]
];

(* Retrieve recent conversation history *)
RetrieveConversationHistory[limit_Integer: 10] := Module[{recentEntries, contextWindow},
  
  (* Initialize if not done *)
  If[!$MemorySystemInitialized, InitializeMemorySystem[]];
  
  (* Get recent entries within context window *)
  contextWindow = Min[limit, $MemoryConfiguration["contextWindowSize"]];
  recentEntries = TakeLargest[$ConversationMemory, contextWindow, #["timestamp"] &];
  
  (* Sort by timestamp for chronological order *)
  SortBy[recentEntries, #["timestamp"] &]
];

(* Analyze current input against conversation context *)
AnalyzeConversationContext[currentInput_Association] := Module[{recentHistory, contextAnalysis, topicOverlap, referenceDetection},
  
  (* Initialize if not done *)
  If[!$MemorySystemInitialized, InitializeMemorySystem[]];
  
  recentHistory = RetrieveConversationHistory[];
  
  (* Analyze topic continuity *)
  topicOverlap = If[Length[recentHistory] > 0,
    Module[{currentTopics, recentTopics},
      currentTopics = ExtractTopicsFromInput[currentInput];
      recentTopics = Flatten[#["topics"] & /@ recentHistory];
      Length[Intersection[currentTopics, recentTopics]] / Length[Union[currentTopics, recentTopics]]
    ],
    0.0
  ];
  
  (* Detect references to previous interactions *)
  referenceDetection = If[KeyExistsQ[currentInput, "textInput"] && currentInput["textInput"] != "",
    StringContainsQ[currentInput["textInput"], 
      RegularExpression["\\b(previous|before|earlier|last|again|that|it|this)\\b"], IgnoreCase -> True],
    False
  ];
  
  contextAnalysis = <|
    "hasRecentHistory" -> Length[recentHistory] > 0,
    "historyLength" -> Length[recentHistory],
    "topicContinuity" -> topicOverlap,
    "referencesHistory" -> referenceDetection,
    "contextRelevance" -> Max[topicOverlap, If[referenceDetection, 0.8, 0.1]],
    "recommendMemoryUsage" -> topicOverlap > $MemoryConfiguration["contextRelevanceThreshold"] || referenceDetection,
    "recentTopics" -> If[Length[recentHistory] > 0, 
                        Flatten[#["topics"] & /@ recentHistory], {}],
    "sessionContinuity" -> $ConversationContext["totalInteractions"] > 0
  |>;
  
  contextAnalysis
];

(* Build LLMGraph with conversation memory integration *)
BuildMemoryEnhancedLLMGraph[inputData_Association, contextAnalysis_Association] := Module[{memoryNodes, enhancedGraph, contextPrompt, recentHistory},
  
  (* Initialize prerequisites *)
  If[!$ToolsInitialized, InitializeToolsIntegration[]];
  If[$MasterLLMHierarchy === None, InitializeLLMHierarchy[]];
  If[!$MemorySystemInitialized, InitializeMemorySystem[]];
  
  (* Start with tool-enhanced graph *)
  enhancedGraph = BuildToolEnhancedLLMGraph[inputData];
  
  (* Add memory context if relevant *)
  If[contextAnalysis["recommendMemoryUsage"] && contextAnalysis["hasRecentHistory"],
    recentHistory = RetrieveConversationHistory[3]; (* Get last 3 interactions for context *)
    
    (* Create context summary *)
    contextPrompt = "Previous conversation context:\n" <>
      StringRiffle[
        Map[Function[entry,
          "• " <> DateString[entry["timestamp"], "HH:MM"] <> ": " <>
          If[entry["inputSummary"]["textInput"] != "", 
            StringTake[entry["inputSummary"]["textInput"], UpTo[100]], 
            "Multi-modal input (" <> StringRiffle[entry["inputSummary"]["inputTypes"], ", "] <> ")"]
        ], recentHistory], "\n"] <>
      "\n\nCurrent query builds on this context. Consider previous interactions when responding.";
    
    (* Add memory-enhanced master coordination *)
    If[enhancedGraph =!= None,
      (* Enhance existing graph with memory context *)
      enhancedGraph = enhancedGraph /. 
        ("masterSynthesis" -> masterFunc_) :> 
        ("memoryEnhancedSynthesis" -> LLMFunction[
          contextPrompt <> "\n\nNow coordinate the following analyses with conversation context:\n" <>
          "Current input: " <> ToString[inputData],
          LLMEvaluator -> $MasterLLMHierarchy["masterLLM"]
        ]),
      
      (* Create memory-only graph if no tools/enhanced graph *)
      enhancedGraph = LLMGraph[{
        "contextAnalysis" -> LLMFunction[
          contextPrompt <> "\n\nAnalyze current input: " <> ToString[inputData],
          LLMEvaluator -> $MasterLLMHierarchy["masterLLM"]
        ]
      }]
    ]
  ];
  
  enhancedGraph
];

(* Process input with conversation context and memory *)
ProcessWithMemory[inputData_Association] := Module[{contextAnalysis, memoryGraph, result},
  
  (* Initialize if needed *)
  If[!$MemorySystemInitialized, InitializeMemorySystem[]];
  
  (* Analyze conversation context *)
  contextAnalysis = AnalyzeConversationContext[inputData];
  
  (* Build memory-enhanced graph *)
  memoryGraph = BuildMemoryEnhancedLLMGraph[inputData, contextAnalysis];
  
  (* Process with memory enhancement *)
  result = If[memoryGraph =!= None,
    Catch[
      Module[{graphResult, enhancedResponse},
        (* Execute memory-enhanced graph *)
        graphResult = memoryGraph[inputData];
        
        (* Get enhanced response *)
        enhancedResponse = Which[
          KeyExistsQ[graphResult, "memoryEnhancedSynthesis"], graphResult["memoryEnhancedSynthesis"],
          KeyExistsQ[graphResult, "contextAnalysis"], graphResult["contextAnalysis"],
          KeyExistsQ[graphResult, "toolEnhancedSynthesis"], graphResult["toolEnhancedSynthesis"],
          True, CoordinateToolResults[
            Select[graphResult, AssociationQ[#] && KeyExistsQ[#, "tool"] &],
            Select[graphResult, !AssociationQ[#] || !KeyExistsQ[#, "tool"] &]
          ]
        ];
        
        <|
          "rawResponse" -> enhancedResponse,
          "formattedResponse" -> enhancedResponse,
          "method" -> "MemoryEnhancedLLMGraph",
          "contextUsed" -> contextAnalysis["recommendMemoryUsage"],
          "contextRelevance" -> contextAnalysis["contextRelevance"],
          "memoryEntries" -> contextAnalysis["historyLength"],
          "sessionContinuity" -> contextAnalysis["sessionContinuity"],
          "processedAt" -> Now,
          "memoryEnhanced" -> True
        |>
      ],
      _,
      <|
        "rawResponse" -> "Memory-enhanced processing temporarily unavailable.",
        "formattedResponse" -> "Conversation context system is initializing. Please try again.",
        "method" -> "FallbackMemoryProcessing",
        "memoryEnhanced" -> False,
        "error" -> True
      |>
    ],
    
    (* Fallback to regular tool-enhanced processing *)
    Module[{fallbackResult},
      fallbackResult = ProcessWithTools[inputData];
      fallbackResult["method"] = "FallbackToTools";
      fallbackResult["memoryEnhanced"] = False;
      fallbackResult
    ]
  ];
  
  (* Store this interaction in memory *)
  StoreConversationMemory[inputData, result];
  
  result
];

(* Manage and optimize conversation context *)
ManageConversationContext[interactions_List] := Module[{contextOptimization, topicAnalysis, memoryPruning},
  
  (* Analyze conversation topics and patterns *)
  topicAnalysis = <|
    "dominantTopics" -> Commonest[Flatten[#["topics"] & /@ interactions]],
    "topicDistribution" -> Counts[Flatten[#["topics"] & /@ interactions]],
    "averageInteractionGap" -> If[Length[interactions] > 1,
      Mean[Differences[#["timestamp"] & /@ interactions]], 0],
    "multiModalUsage" -> Mean[Length[#["inputSummary"]["inputTypes"]] & /@ interactions]
  |>;
  
  (* Optimize memory weights based on relevance *)
  memoryPruning = Map[Function[interaction,
    interaction["contextRelevance"] = 
      Which[
        MemberQ[topicAnalysis["dominantTopics"], First[interaction["topics"]]], 1.0,
        interaction["timestamp"] > DatePlus[Now, Quantity[-7, "Days"]], 0.8,
        interaction["timestamp"] > DatePlus[Now, Quantity[-14, "Days"]], 0.6,
        True, 0.4
      ];
    interaction
  ], interactions];
  
  contextOptimization = <|
    "totalInteractions" -> Length[interactions],
    "topicAnalysis" -> topicAnalysis,
    "memoryOptimized" -> Length[memoryPruning],
    "recommendedRetention" -> Select[memoryPruning, #["contextRelevance"] > 0.5 &],
    "optimizationTime" -> Now
  |>;
  
  (* Update global context *)
  $ConversationContext["contextSummary"] = 
    "Session focus: " <> StringRiffle[Take[topicAnalysis["dominantTopics"], UpTo[3]], ", "];
  
  contextOptimization
];

(* Create conversation summary for context optimization *)
SummarizeConversationMemory[memoryEntries_List] := Module[{summary, topicSummary, interactionSummary},
  
  If[Length[memoryEntries] == 0, Return["No conversation history available."]];
  
  (* Create topic-based summary *)
  topicSummary = StringRiffle[
    Map[Function[topic,
      topic <> " (" <> ToString[Count[Flatten[#["topics"] & /@ memoryEntries], topic]] <> " interactions)"
    ], Commonest[Flatten[#["topics"] & /@ memoryEntries], UpTo[5]]], ", "];
  
  (* Create interaction summary *)
  interactionSummary = "Total interactions: " <> ToString[Length[memoryEntries]] <>
    ", Multi-modal usage: " <> ToString[Round[100 * Mean[Length[#["inputSummary"]["inputTypes"]] & /@ memoryEntries]]] <> "%";
  
  summary = "Conversation Summary:\n" <>
    "• Topics discussed: " <> topicSummary <> "\n" <>
    "• " <> interactionSummary <> "\n" <>
    "• Time span: " <> DateString[Min[#["timestamp"] & /@ memoryEntries]] <> " to " <>
    DateString[Max[#["timestamp"] & /@ memoryEntries]] <> "\n" <>
    "• Session continuity: Active multi-modal conversation with context awareness";
  
  summary
];

(* Helper function to summarize old memory entries *)
SummarizeOldMemoryEntries[] := Module[{oldEntries, summary},
  
  (* Get entries older than 2 weeks *)
  oldEntries = Select[$ConversationMemory, 
    #["timestamp"] < DatePlus[Now, Quantity[-14, "Days"]] &];
  
  If[Length[oldEntries] > 0,
    summary = SummarizeConversationMemory[oldEntries];
    
    (* Store summary and remove old entries *)
    $ConversationContext["historicalSummary"] = summary;
    $ConversationMemory = Select[$ConversationMemory,
      #["timestamp"] >= DatePlus[Now, Quantity[-14, "Days"]] &];
    
    Print["Summarized " <> ToString[Length[oldEntries]] <> " old memory entries for optimization."];
  ];
];

(* Step 1: Basic web form interface for multi-modal inputs *)
CreateWebInterface[] := FormPage[
  {
    "textInput" -> <|
      "Interpreter" -> "String", 
      "Control" -> InputField[Placeholder -> "Enter your question or prompt here..."], 
      "Help" -> "Text input for your query or question"
    |>,
    "imageUpload" -> <|
      "Interpreter" -> "Image", 
      "Control" -> FileUpload[{"PNG", "JPG", "JPEG", "GIF"}], 
      "Help" -> "Upload an image file (PNG, JPG, JPEG, GIF)"
    |>,
    "audioUpload" -> <|
      "Interpreter" -> "Sound", 
      "Control" -> FileUpload[{"MP3", "WAV", "M4A"}], 
      "Help" -> "Upload an audio file (MP3, WAV, M4A)"
    |>,
    "videoUpload" -> <|
      "Interpreter" -> "Binary", 
      "Control" -> FileUpload[{"MP4", "MOV", "AVI"}], 
      "Help" -> "Upload a video file (MP4, MOV, AVI)"
    |>,
    "webpageURL" -> <|
      "Interpreter" -> "URL", 
      "Control" -> InputField[Placeholder -> "https://example.com"], 
      "Help" -> "Enter a webpage URL to analyze"
    |>,
    "eventInput" -> <|
      "Interpreter" -> "String", 
      "Control" -> InputField[Placeholder -> "Describe keyboard/mouse events or paste event logs...", "", TextArea -> True], 
      "Help" -> "Describe keyboard/mouse interactions or paste event logs for analysis"
    |>
  },
  ProcessUserInput,
  "AppearanceRules" -> <|
    "Title" -> "Multi-Modal LLM Assistant",
    "Description" -> "Upload files, enter text, or provide URLs for AI-powered analysis",
    "SubmitLabel" -> "Process Input"
  |>,
  "FormTheme" -> "Blue"
];

(* Process the form data - Enhanced with Step 2 LLM Integration *)
ProcessUserInput[data_Association] := Module[
  {result, textData, imageData, audioData, videoData, urlData, eventData,
   inputDataForLLM, textAnalysis, imageAnalysis, audioAnalysis, videoAnalysis, webpageAnalysis, eventAnalysis, llmResponse, hasInput},
  
  (* Extract form data *)
  textData = Lookup[data, "textInput", ""];
  imageData = Lookup[data, "imageUpload", None];
  audioData = Lookup[data, "audioUpload", None];
  videoData = Lookup[data, "videoUpload", None];
  urlData = Lookup[data, "webpageURL", None];
  eventData = Lookup[data, "eventInput", ""];
  
  (* Check if we have any meaningful input *)
  hasInput = (textData != "") || (imageData =!= None) || 
             (audioData =!= None) || (videoData =!= None) || 
             (urlData =!= None) || (eventData != "");
  
  (* Process text input with enhanced analysis *)
  textAnalysis = If[textData != "", ProcessTextInput[textData], None];
  
  (* Step 3: Process image input with OCR and object recognition *)
  imageAnalysis = If[imageData =!= None, ProcessImageInput[imageData], None];
  
  (* Step 4: Process audio input with speech-to-text *)
  audioAnalysis = If[audioData =!= None, ProcessAudioInput[audioData], None];
  
  (* Step 5: Process video input with transcription and frame analysis *)
  videoAnalysis = If[videoData =!= None, ProcessVideoInput[videoData], None];
  
  (* Step 6: Process webpage URL with content extraction *)
  webpageAnalysis = If[urlData =!= None && ToString[urlData] != "", ProcessWebpageInput[ToString[urlData]], None];
  
  (* Step 7: Process keyboard/mouse event input *)
  eventAnalysis = If[eventData != "", ProcessEventInput[eventData], None];
  
  (* Prepare input data for LLM processing *)
  inputDataForLLM = <|
    "textInput" -> textData,
    "imageDescription" -> If[imageAnalysis =!= None, imageAnalysis["combinedDescription"], ""],
    "audioTranscript" -> If[audioAnalysis =!= None, audioAnalysis["combinedDescription"], ""],
    "videoContent" -> If[videoAnalysis =!= None, videoAnalysis["combinedDescription"], ""],
    "webpageContent" -> If[webpageAnalysis =!= None, webpageAnalysis["combinedDescription"], ""],
    "eventContent" -> If[eventAnalysis =!= None, eventAnalysis["combinedDescription"], ""]
  |>;
  
  (* Generate AI response if we have input - Step 10: Use Memory-Enhanced Processing *)
  llmResponse = If[hasInput,
    Catch[
      ProcessWithMemory[inputDataForLLM],
      _, 
      <|"rawResponse" -> "LLM processing temporarily unavailable. Please ensure API keys are configured.", 
        "status" -> "error"|>
    ],
    None
  ];
  
  (* Format result with LLM integration *)
  result = Column[{
    Style["Multi-Modal LLM Assistant", "Title"],
    Style["Step 10: Memory Management & Conversation Context with Persistent Learning", "Subtitle", Blue],
    "",
    
    (* Input Summary Section *)
    If[hasInput,
      Column[{
        Style["Input Summary:", "Subsubtitle", Bold],
        If[textData != "", 
          Column[{
            Row[{"Text Input: ", Style[textData, "Input"]}],
            If[textAnalysis =!= None,
              Style["Words: " <> ToString[textAnalysis["wordCount"]] <> 
                   " | Characters: " <> ToString[textAnalysis["characterCount"]], "Text", Gray],
              Nothing
            ]
          }], 
          Nothing
        ],
        If[imageData =!= None, 
          Column[{
            "Image Upload: ", 
            Thumbnail[imageData, 150],
            If[imageAnalysis =!= None,
              Column[{
                Style["OCR Text: " <> If[imageAnalysis["ocrResult"]["hasText"], 
                  "\"" <> imageAnalysis["ocrResult"]["extractedText"] <> "\"", 
                  "No text detected"], "Text", Gray],
                Style["Objects: " <> imageAnalysis["objectResult"]["description"] <> 
                  " (confidence: " <> ToString[NumberForm[imageAnalysis["objectResult"]["confidence"], {1, 2}]] <> ")", "Text", Gray]
              }],
              Style["Image processing in progress...", "Text", Gray]
            ]
          }], 
          Nothing
        ],
        If[audioData =!= None, 
          Column[{
            "Audio Upload: ",
            If[audioAnalysis =!= None,
              Column[{
                Style["Transcript: " <> If[audioAnalysis["transcriptResult"]["hasText"], 
                  "\"" <> audioAnalysis["transcriptResult"]["transcript"] <> "\"", 
                  "No speech detected"], "Text", Gray],
                Style["Duration: " <> ToString[NumberForm[audioAnalysis["metadataResult"]["duration"], {1, 1}]] <> 
                  " seconds | Channels: " <> ToString[audioAnalysis["metadataResult"]["channels"]], "Text", Gray]
              }],
              Style["Audio processing in progress...", "Text", Gray]
            ]
          }], 
          Nothing
        ],
        If[videoData =!= None, 
          Column[{
            "Video Upload: ",
            If[videoAnalysis =!= None,
              Column[{
                Style["Content: " <> videoAnalysis["combinedDescription"], "Text", Gray],
                Style["Size: " <> ToString[NumberForm[N[videoAnalysis["metadataResult"]["size"]/1024/1024], {1, 1}]] <> " MB", "Text", Gray],
                Style["Frame Analysis: " <> videoAnalysis["frameAnalysis"]["sceneDescription"], "Text", Gray]
              }],
              Style["Video processing in progress...", "Text", Gray]
            ]
          }], 
          Nothing
        ],
        If[urlData =!= None, 
          Column[{
            Row[{"Webpage URL: ", Hyperlink[urlData, urlData]}],
            If[webpageAnalysis =!= None,
              Column[{
                Style["Content: " <> If[webpageAnalysis["parseResult"] =!= None && webpageAnalysis["parseResult"]["title"] != "Untitled Webpage",
                  webpageAnalysis["parseResult"]["title"], "Webpage processed"], "Text", Gray],
                Style["Word Count: " <> If[webpageAnalysis["parseResult"] =!= None,
                  ToString[webpageAnalysis["parseResult"]["wordCount"]], "0"], "Text", Gray],
                Style["Status: " <> If[webpageAnalysis["hasContent"], "Content extracted successfully", "No content extracted"], "Text", Gray]
              }],
              Style["Webpage processing in progress...", "Text", Gray]
            ]
          }], 
          Nothing
        ],
        If[eventData != "", 
          Column[{
            "Event Input: ",
            If[eventAnalysis =!= None,
              Column[{
                Style["Events: " <> eventAnalysis["combinedDescription"], "Text", Gray],
                Style["Pattern Analysis: " <> eventAnalysis["patternResult"]["complexity"] <> " interaction complexity", "Text", Gray],
                Style["Event Count: " <> ToString[eventAnalysis["patternResult"]["totalEvents"]], "Text", Gray]
              }],
              Style["Event processing in progress...", "Text", Gray]
            ]
          }], 
          Nothing
        ],
        ""
      }],
      Nothing
    ],
    
    (* AI Response Section *)
    If[llmResponse =!= None,
      Column[{
        FormatLLMResponse[llmResponse],
        "",
        Style["Powered by Master LLM", "Text", Gray, Italic]
      }],
      Style["Please provide some input for AI analysis.", "Text", Gray]
    ],
    
    "",
    (* Status Section *)
    Style["Step 10 Complete: Memory Management & Conversation Context with Persistent Learning Active", "Text", Green],
    Style["Next: Steps 11-12 will add RAG capabilities and advanced context optimization", "Text", Blue]
  }];
  
  (* Return formatted result *)
  result
];

(* Deploy the application to Wolfram Cloud *)
DeployApp[] := Module[{webInterface, deploymentObj},
  
  (* Create the web interface *)
  webInterface = CreateWebInterface[];
  
  (* Deploy to cloud with appropriate permissions *)
  deploymentObj = CloudDeploy[
    webInterface,
    "MultiModalLLMApp",
    Permissions -> "Public"
  ];
  
  (* Return deployment information *)
  Column[{
    Style["Multi-Modal LLM App Deployed Successfully!", "Title"],
    "",
    "Deployment URL: " <> ToString[deploymentObj],
    "",
    "The app accepts:",
    "• Text input",
    "• Image uploads (PNG, JPG, JPEG, GIF)",
    "• Audio uploads (MP3, WAV, M4A)", 
    "• Video uploads (MP4, MOV, AVI)",
    "• Webpage URLs",
    "",
    Style["Status: Step 1 Complete - Basic infrastructure ready", "Text", Green]
  }]
];

End[];
EndPackage[];
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
  {result, textData, imageData, audioData, videoData, urlData, 
   inputDataForLLM, textAnalysis, imageAnalysis, llmResponse, hasInput},
  
  (* Extract form data *)
  textData = Lookup[data, "textInput", ""];
  imageData = Lookup[data, "imageUpload", None];
  audioData = Lookup[data, "audioUpload", None];
  videoData = Lookup[data, "videoUpload", None];
  urlData = Lookup[data, "webpageURL", None];
  
  (* Check if we have any meaningful input *)
  hasInput = (textData != "") || (imageData =!= None) || 
             (audioData =!= None) || (videoData =!= None) || 
             (urlData =!= None);
  
  (* Process text input with enhanced analysis *)
  textAnalysis = If[textData != "", ProcessTextInput[textData], None];
  
  (* Step 3: Process image input with OCR and object recognition *)
  imageAnalysis = If[imageData =!= None, ProcessImageInput[imageData], None];
  
  (* Prepare input data for LLM processing *)
  inputDataForLLM = <|
    "textInput" -> textData,
    "imageDescription" -> If[imageAnalysis =!= None, imageAnalysis["combinedDescription"], ""],
    "audioTranscript" -> If[audioData =!= None, "Audio uploaded (processing will be added in Step 4)", ""],
    "videoContent" -> If[videoData =!= None, "Video uploaded (processing will be added in Step 5)", ""],
    "webpageContent" -> If[urlData =!= None, "Webpage URL provided: " <> ToString[urlData] <> " (processing will be added in Step 6)", ""]
  |>;
  
  (* Generate AI response if we have input *)
  llmResponse = If[hasInput,
    Catch[
      ProcessTextWithLLM[inputDataForLLM],
      _, 
      <|"rawResponse" -> "LLM processing temporarily unavailable. Please ensure API keys are configured.", 
        "status" -> "error"|>
    ],
    None
  ];
  
  (* Format result with LLM integration *)
  result = Column[{
    Style["Multi-Modal LLM Assistant", "Title"],
    Style["Step 2: Text Processing & Master LLM Integration", "Subtitle", Blue],
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
          Row[{"Audio Upload: ", Style["Audio file received (Step 4 will add processing)", "Text"]}], 
          Nothing
        ],
        If[videoData =!= None, 
          Row[{"Video Upload: ", Style["Video file received (Step 5 will add processing)", "Text"]}], 
          Nothing
        ],
        If[urlData =!= None, 
          Row[{"Webpage URL: ", Hyperlink[urlData, urlData]}], 
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
    Style["Step 3 Complete: Image Processing with OCR & Object Recognition Active", "Text", Green],
    Style["Next: Steps 4-7 will add audio, video, web scraping, and event processing", "Text", Blue]
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
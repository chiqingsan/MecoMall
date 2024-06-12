import { Log } from '@abner/log';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { audio } from '@kit.AudioKit';
import { speechRecognizer } from '@kit.CoreSpeechKit';
import { permissionPlugin } from '@mk/basic/Index';

export enum VoiceState {
  DEFAULT,
  VOICING,
  VOICEOVER
}

@Component
export struct AudioSearchComp {
  @State voiceState: VoiceState = VoiceState.DEFAULT
  keyword: string = ''
  audioCapturer: audio.AudioCapturer | null = null
  asrEngine: speechRecognizer.SpeechRecognitionEngine | null = null
  onChange: (keyword: string) => void = () => {
  }
  onComplete: (keyword: string) => void = () => {
  }

  async startRecord() {
    this.voiceState = VoiceState.VOICING
    Log.info("开始录音了...")
    // 开始识别
    this.asrEngine = await speechRecognizer.createEngine({
      language: 'zh-CN',
      online: 1
    })
    // 保存组件的 this，后续通过_this来使用组件
    const _this = this
    this.asrEngine.setListener({
      onStart(sessionId: string, eventMessage: string) {
        console.info(`onStart, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
      },
      onEvent(sessionId: string, eventCode: number, eventMessage: string) {
        console.info(`onEvent, sessionId: ${sessionId} eventCode: ${eventCode} eventMessage: ${eventMessage}`);
      },
      onResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult) {
        console.info(`onResult, sessionId: ${sessionId} sessionId: ${JSON.stringify(result)}`);
        _this.keyword = result.result
        _this.onChange(result.result)
      },
      onComplete(sessionId: string, eventMessage: string) {
        _this.voiceState = VoiceState.DEFAULT
        _this.onComplete(_this.keyword)
        console.info(`onComplete, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
      },
      onError(sessionId: string, errorCode: number, errorMessage: string) {
        console.error(`onError, sessionId: ${sessionId} errorCode: ${errorCode} errorMessage: ${errorMessage}`);
      }
    })
    const recognizerParams: speechRecognizer.StartParams = {
      sessionId: '10000',
      audioInfo: {
        audioType: 'pcm',
        sampleRate: 16000,
        soundChannel: 1,
        sampleBit: 16
      }
    }
    this.asrEngine?.startListening(recognizerParams)
    // 开始录音
    const audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
      channels: audio.AudioChannel.CHANNEL_1,
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
    }
    const audioCapturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC,
      capturerFlags: 0
    }
    const audioCapturerOptions: audio.AudioCapturerOptions = {
      streamInfo: audioStreamInfo,
      capturerInfo: audioCapturerInfo
    }

    this.audioCapturer = await audio.createAudioCapturer(audioCapturerOptions)
    this.audioCapturer.on('readData', (buffer) => {
      console.log('mk-logger', buffer.byteLength)
      this.asrEngine?.writeAudio('10000', new Uint8Array(buffer))
    })
    await this.audioCapturer.start()
    this.voiceState = VoiceState.VOICING
  }

  async closeRecord() {
    this.audioCapturer?.stop()
    this.audioCapturer?.release()
    this.asrEngine?.finish('10000')
    this.asrEngine?.cancel('10000')
    this.asrEngine?.shutdown()
    if (this.keyword) {
      this.voiceState = VoiceState.DEFAULT
      this.keyword = ''
    } else {
      this.voiceState = VoiceState.VOICEOVER
    }
  }

  aboutToAppear(): void {
    permissionPlugin.requestPermissions([
      'ohos.permission.MICROPHONE'
    ])
      .then(() => {
        window.getLastWindow(getContext())
          .then(win => {
            win.getUIContext()
              .setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
          })
      })
  }

  build() {
    Column() {
      if (this.voiceState !== VoiceState.DEFAULT) {
        Column({ space: 16 }) {
          if (this.voiceState === VoiceState.VOICING) {
            Text('请说，我在聆听...')
              .fontSize(14)
          } else if (this.voiceState === VoiceState.VOICEOVER && this.keyword === '') {
            Text('未检测到语音，请长按按钮重试')
              .fontSize(14)
          }
          Text() {
            Span('你可以这样说：')
            Span('太阳眼镜/冬款连衣裙')
              .fontColor($r('app.color.gray'))
          }
          .fontSize(12)
        }
        .justifyContent(FlexAlign.Center)
        .height(150)
      }
      Blank()
      Button() {
        Row({ space: 4 }) {
          Image($r('sys.media.ohos_ic_public_voice'))
            .width(16)
            .aspectRatio(1)
            .fillColor($r('app.color.white'))
          if (this.voiceState === VoiceState.VOICING) {
            Text('松开立即搜索')
              .fontSize(14)
              .fontColor($r('app.color.white'))
          } else {
            Text('长按语音搜索')
              .fontSize(14)
              .fontColor($r('app.color.white'))
          }
        }
      }
      .padding({ left: 12, right: 12 })
      .height(36)
      .linearGradient({ angle: 135, colors: [[$r('app.color.linear_begin'), 0], [$r('app.color.linear_end'), 1]] })
      .margin({ bottom: 16 })
      .gesture(LongPressGesture()
        .onAction(() => {
          this.startRecord()
        })
        .onActionEnd(() => {
          this.closeRecord()
        })
        .onActionCancel(() => {
          this.closeRecord()
        }))

    }
    .layoutWeight(1)
    .width('100%')
    .backgroundImage($r('app.media.search_bg'))
    .backgroundImageSize(ImageSize.Contain)
    .backgroundImagePosition(Alignment.Bottom)
    .onVisibleAreaChange([0, 1], () => {
      this.keyword = ''
      this.voiceState = VoiceState.DEFAULT
    })
  }
}
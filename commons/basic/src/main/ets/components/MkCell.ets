@Component
export struct MkCell {
  @Prop label: string = ''
  @Prop value: string = ''
  @Prop icon: ResourceStr = $r('app.media.ic_public_right')
  @Prop hasBorder: boolean = true

  @Builder
  DefaultLabelBuilder() {
    Text(this.label)
      .fontSize(14)
      .fontColor($r('app.color.black'))
  }

  @Builder
  DefaultIconBuilder() {
    Image(this.icon)
      .width(20)
      .aspectRatio(1)
      .fillColor($r('app.color.gray'))
  }

  @BuilderParam customLabel: () => void = this.DefaultLabelBuilder
  @BuilderParam customIcon: () => void = this.DefaultIconBuilder

  build() {
    Row({ space: 8 }) {
      this.customLabel()
      Blank()
      if (this.value) {
        Text(this.value)
          .fontSize(14)
          .fontColor($r('app.color.gray'))
      }
      this.customIcon()
    }
    .width('100%')
    .constraintSize({ minHeight: 50 })
    .border({ width: { bottom: this.hasBorder ? 0.6 : 0 }, color: $r('app.color.under') })
  }
}


@Component
export struct MkCellGroup {
  @Builder
  DefaultBuilder() {
  }

  @BuilderParam default: () => void = this.DefaultBuilder

  build() {
    Column() {
      this.default()
    }
    .border({
      width: { top: 0.6, bottom: 0.6 },
      color: $r('app.color.under')
    })
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.white'))
  }
}
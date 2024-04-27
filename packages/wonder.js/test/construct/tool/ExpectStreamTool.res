open Wonderjs

let toFail = (
  ~execFunc: (
    ~handleSuccessFunc: unit => 'a,
    ~handleFailFunc: Js.Exn.t => unit=?,
    unit,
  ) => Js.Promise.t<'a>,
  ~message,
) => {
  open Wonder_jest
  open Expect
  open! Expect.Operators

  let resultMessage = ref("")

  execFunc(
    ~handleFailFunc=err => resultMessage := err->Js.Exn.message->OptionSt.getExn,
    ~handleSuccessFunc=() => resultMessage.contents->expect->toContainString(message, _),
    (),
  )
}

let testAfterFail = (
  ~execFunc: (
    ~handleSuccessFunc: unit => 'a,
    ~handleFailFunc: Js.Exn.t => unit=?,
    unit,
  ) => Js.Promise.t<'a>,
  ~handleFunc,
) => {
  open Wonder_jest
  open Expect
  open! Expect.Operators

  let resultMessage = ref("")

  execFunc(
    ~handleFailFunc=err => resultMessage := err->Js.Exn.message->OptionSt.getExn,
    ~handleSuccessFunc=() => handleFunc(resultMessage.contents),
    (),
  )
}

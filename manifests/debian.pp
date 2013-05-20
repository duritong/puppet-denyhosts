# init script on debian does not have a status cmd
class denyhosts::debian inherits denyhosts::base {
  Service[denyhosts]{
    hasstatus => false,
  }
}

# MaterialTextField
Simple UITextfield Subclass with cool material design animations.

This is a textfield subclass with a totally different look. The design and animations are inspired by Google's material design language.

USAGE: Placing a UIMaterialTextField on a view is fairly straightforward. There are 2 ways:

1. Using Interface Builder & Standard UITextField
      - Place a standard UITextField using Interface Builder
      - Change the UITextField object's class as: UIMaterialTextField (Using Interface Builder)
      - Change the UITextField object's border style to none (Using Interface Builder)
      - Change the UITextField object's height to 40
      - Enter a placeholder text as the title of the field (You can change or define the placeholder during runtime also)

2. Creating it through code without the interface builder
      - Use the initializer UIMaterialTextField(frame: CGRect)
      - Add the created object to your desired view.
      - Define a placeholder text as the title of the field (You can change or define the placeholder during runtime also)

DELEGATE:
   - If you want to use event handling you should define the .materialDelegate property of a UIMaterialTextField.
   - You should add "UIMaterialTextFieldDelegate" protocol to the view's class definition.

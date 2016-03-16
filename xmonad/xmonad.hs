import XMonad
import XMonad.StackSet
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig
import System.Exit

main :: IO ()
main = xmonad =<< xmobar myConfig

myConfig :: XConfig (Choose Tall (Choose (Mirror Tall) Full))
myConfig = def { normalBorderColor = "#B4CFEC"
               , focusedBorderColor = "red"
               , terminal = "lxterminal"
               , modMask = mod4Mask
               , borderWidth = 2
               , focusFollowsMouse = True
               , clickJustFocuses = False
               } `additionalKeys` myKeys

myKeys :: [((KeyMask, KeySym), X ())]
myKeys =
  -- applications
  [ ((mod4Mask, xK_Return), spawn "lxterminal")
  , ((mod4Mask, xK_space), spawn "dmenu_run -fn \"Ubuntu Mono-9\"")

  -- application control
  , ((mod4Mask, xK_q), kill)

  -- window layout
  , ((mod4Mask .|. shiftMask, xK_space), sendMessage NextLayout)
  , ((mod4Mask              , xK_j), windows focusDown)
  , ((mod4Mask              , xK_k), windows focusUp)
  , ((mod4Mask              , xK_h), sendMessage Shrink)
  , ((mod4Mask              , xK_l), sendMessage Expand)
  , ((mod4Mask              , xK_n), refresh)

  -- xmonad controls
  , ((mod4Mask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
  , ((mod4Mask .|. shiftMask, xK_r), spawn "xmonad --recompile && xmonad --restart")
  ]

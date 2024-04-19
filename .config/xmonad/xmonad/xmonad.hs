import XMonad
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.FadeWindows
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Actions.NoBorders
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutModifier

import Data.Monoid
import System.Exit
import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- Terminal program
myTerminal = "kitty"
retroTerm = "cool-retro-term --profile iselda"

-- Mod button (super)
myModMask = mod4Mask

-- Border size and color
myBorderWidth = 2
myNormalBorderColor = "#000000"
myFocusedBorderColor = "#FDFD96"

-- KeyBinds
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ 
		--Launch dmenu
		[ ((modm, xK_p), spawn "dmenu_run")

		-- Brightness Control
		, ((0, xF86XK_MonBrightnessUp), spawn "lux -a 10%")
		, ((0, xF86XK_MonBrightnessDown), spawn "lux -s 10%")

		-- Volume Control
		, ((0, xF86XK_AudioLowerVolume), spawn "/home/iselda/.volume.sh down")
		, ((0, xF86XK_AudioRaiseVolume), spawn  "/home/iselda/.volume.sh up")
		, ((0, xF86XK_AudioMute), spawn "/home/iselda/.volume.sh mute")

		-- Microphone Control
		, ((0, xF86XK_AudioMicMute), spawn "/home/iselda/.volume.sh mic_mute")

		-- PrintScreen
		, ((0, xK_Print), spawn "maim -s | xclip -selection clipboard -t image/png")

		-- Restart & recompile xmonad
		, ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart")

		-- Lock screen
		, ((modm .|. shiftMask, xK_l), spawn "i3lock -S 0 -c 000000 -k --time-color=ffffff --date-color=999999 --ring-color=d3b3ff --keyhl-color=f5f67e --bshl-color=e1ffc7  --insidever-color=ffc7ef --ringver-color=ffc7ef --insidewrong-color=ff9690 --ringwrong-color=ff9690 --indicator -e -f")

		-- Start new terminal
		--, ((modm, xK_Return), spawn retroTerm)
		, ((modm .|. shiftMask, xK_Return), spawn myTerminal)

		-- Rotate through layouts
		, ((modm, xK_space), sendMessage NextLayout)

		-- Reset layouts to default
		, ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

		-- Resize windows to correct size
		, ((modm, xK_n), refresh)

		-- Move to next window
		, ((modm, xK_j), windows W.focusDown)

		-- Move to previous window
		, ((modm, xK_k), windows W.focusUp)

		-- Move to master window
		, ((modm, xK_m), windows W.focusMaster)
		
		-- Swap focused and next window
		, ((modm .|. shiftMask, xK_j), windows W.swapDown)

		-- Swap focused and previous window
		, ((modm .|. shiftMask, xK_k), windows W.swapUp)

		-- Swap focused and master window
		, ((modm .|. shiftMask, xK_m), windows W.swapMaster)

		-- Close current window
		, ((modm .|. shiftMask, xK_c), kill)

		-- Shrink master area
		, ((modm, xK_h), sendMessage Shrink)

		-- Expand master area
		, ((modm, xK_l), sendMessage Expand)

		-- Push windows into tiling
		, ((modm, xK_t), withFocused $ windows . W.sink)

		-- Increment number of windows
		, ((modm, xK_comma), sendMessage (IncMasterN 1))

		-- Decrement number of windows
		, ((modm, xK_period), sendMessage (IncMasterN (-1)))
		]
		++

		-- Switch to workspace N
		-- Movie client to workspace N
		[((m .|. modm, k), windows $ f i)
			| (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
			, (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
		++

		-- Switch to screen N
		-- Move client to screen N
		[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
			| (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
			, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Do not focus using the mouse

-- XMobar Configuration
myBar = "xmobar"
myPP  = xmobarPP
		{ ppCurrent	= xmobarColor "#fcfc5d" "" . wrap "<" ">"	--current workspace
		, ppVisible	= xmobarColor "#fcfc5d" ""					--visible workspaces
		, ppHidden	= xmobarColor "#adac44" "" . wrap "*" ""	--hidden workspaces
		, ppHiddenNoWindows = xmobarColor "#6d4d80" ""			--hidden, no windows
		, ppUrgent	= xmobarColor "#e4ff7a" "" . wrap "!" "!"	--urgent workspace
		, ppExtras 	= []
		, ppOrder 	= \(ws:_) -> [ws] 
		}
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Sets spacing between windows
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Layout of tiles
myLayoutHook = tiledSpacing ||| fullscreen ||| tiledBorderless
			where tiledSpacing = {- mySpacing 6 $ -} smartBorders $ Tall 1 (3/100) (1/2);
				  fullscreen = smartBorders $ Full;
				  tiledBorderless = noBorders $ Tall 1 (3/100) (1/2)

-- Event handling
myEventHook =  mempty

-- Status Bars and logging
myLogHook = fadeInactiveLogHook 1.0

-- Startup Hook
myStartupHook = return () 

main::IO()
main = do
	xmproc0 <- spawnPipe "xmobar ~/.xmobarrc"
	xmonad . ewmhFullscreen . ewmh =<< statusBar myBar myPP toggleStrutsKey defaults

defaults = def
	{ terminal 				= myTerminal
	, borderWidth			= myBorderWidth
	, modMask				= myModMask
	, focusedBorderColor	= myFocusedBorderColor
	, keys					= myKeys
	, layoutHook			= myLayoutHook
	, handleEventHook		= myEventHook
	, logHook 				= myLogHook
	, startupHook	 myStartupHook
	, focusFollowsMouse = False
	, clickJustFocuses = False
	}

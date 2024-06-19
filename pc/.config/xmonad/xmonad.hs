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
import XMonad.Actions.Navigation2D
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Reflect

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
		--Launch bemenu
		[ ((modm, xK_p), spawn "bemenu")

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

		-- Move between windows with hjkl
        , ((modm, xK_h), windowGo L False)
        , ((modm, xK_j), windowGo D False)
        , ((modm, xK_k), windowGo U False)
        , ((modm, xK_l), windowGo R False)

		-- Close current window
		, ((modm .|. shiftMask, xK_c), kill)

		]
		++

		-- Switch to workspace N
		-- Movie client to workspace N
		[((m .|. modm, k), windows $ f i)
			| (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
			, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
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
		, ppVisible	= xmobarColor "#d1d138" "" . wrap "(" ")"	--visible workspaces
		, ppHidden	= xmobarColor "#adac44" "" . wrap "*" ""	--hidden workspaces
		, ppHiddenNoWindows = xmobarColor "#6d4d80" ""			--hidden, no windows
		, ppUrgent	= xmobarColor "#e4ff7a" "" . wrap "!" "!"	--urgent workspace
		, ppExtras 	= []
		, ppOrder 	= \(ws:_) -> [ws]
		}
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Sets spacing between windows
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Layout of tiles
myLayoutHook = reflectHoriz $
               reflectVert $
               bspSpacing ||| fullscreen
			where bspSpacing = mySpacing 5 $ emptyBSP {-Tall 1 (3/100) (1/2)-};
				  fullscreen = noBorders $ Full;

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
	, startupHook	 		= myStartupHook
	, focusFollowsMouse = False
	, clickJustFocuses = False
	}

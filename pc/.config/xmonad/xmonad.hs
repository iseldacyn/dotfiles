-- XMonad functions
import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W

-- Status bars
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicIcons

-- Layout
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutModifier as L
import XMonad.Layout.Reflect
import XMonad.Actions.Navigation2D
import XMonad.Layout.BinarySpacePartition
import XMonad.Hooks.EwmhDesktops

-- Mutiple screens
import XMonad.Actions.DynamicWorkspaces
import XMonad.Layout.IndependentScreens
import XMonad.Actions.OnScreen
import XMonad.Actions.Warp

-- General
import Data.Monoid
import Control.Monad (liftM2)
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import qualified Data.Map as M

-- Terminal program
myTerminal, retroTerm :: String
myTerminal = "kitty"
retroTerm = "cool-retro-term --profile iselda"

-- Border size and color
myBorderWidth :: Dimension
myBorderWidth = 3
myNormalBorderColor, myFocusedBorderColor :: String
myNormalBorderColor = "#4f4f4f"
myFocusedBorderColor = "#fdfd96"

-- KeyBinds
myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
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

		-- Move between windows with hjkl
        , ((modm, xK_h), windowGo L False)
        , ((modm, xK_j), windowGo D False)
        , ((modm, xK_k), windowGo U False)
        , ((modm, xK_l), windowGo R False)
        -- ...and arrow keys
        , ((modm, xK_Left), windowGo L False)
        , ((modm, xK_Down), windowGo D False)
        , ((modm, xK_Up), windowGo U False)
        , ((modm, xK_Right), windowGo R False)

        -- Swap windows with Shift
        , ((modm .|. shiftMask, xK_h), windowSwap L False)
        , ((modm .|. shiftMask, xK_j), windowSwap D False)
        , ((modm .|. shiftMask, xK_k), windowSwap U False)
        , ((modm .|. shiftMask, xK_l), windowSwap R False)
        , ((modm .|. shiftMask, xK_Left), windowSwap L False)
        , ((modm .|. shiftMask, xK_Down), windowSwap D False)
        , ((modm .|. shiftMask, xK_Up), windowSwap U False)
        , ((modm .|. shiftMask, xK_Right), windowSwap R False)

		-- Close current window
		, ((modm .|. shiftMask, xK_c), kill)

        -- Toggle window to be floating
        , ((modm, xK_f), withFocused toggleFloat)

        -- Bgone
        , ((modm, xK_b), banishScreen LowerRight)

		]
		++

		-- Switch to workspace N
		-- Move client to workspace N
		[((m .|. modm, k), windows $ onCurrentScreen f i)
			| (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
			, (f, m) <- [(W.view, 0), (liftM2 (.) W.view W.shift, shiftMask)]]
		++

		-- Switch to screen N
		-- Move client to screen N
		[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f) >> warpToScreen sc (0.5) (0.5))
			| (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
			, (f, m) <- [(W.view, 0), (liftM2 (.) W.view W.shift, shiftMask)]]

            where toggleFloat w = windows (\s -> if M.member w (W.floating s)
                                  then W.sink w s
                                  else (W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s))

-- App Icons
myIcons :: Query [String]
myIcons = composeAll
  [ className =? "discord" --> appIcon "\xfb6e"
  , className =? "Discord" --> appIcon "\xf268"
  , className =? "firefox" --> appIcon "\63288"
  ]

-- Spawn status bars
barSpawner :: ScreenId -> IO StatusBarConfig
barSpawner (S s) = do
        pure $ statusBarPropTo ("_XMONAD_LOG_" ++ show s)
            ("xmobar -x " ++ show s ++ " ~/.config/xmonad/xmobarrc" ++ show s)
            (pureiconsPP myIcons $ myPP (S s))

-- XMobar Configuration
myPP :: {-ScreenId ->-} PP
myPP s = marshallPP s $ = def
		{ ppCurrent	= xmobarColor "#fcfc5d" "" . wrap "<" ">"	--current workspace
		, ppVisible	= xmobarColor "#d1d138" "" . wrap "(" ")"	--visible workspaces
		, ppHidden	= xmobarColor "#adac44" "" . wrap "*" ""	--hidden workspaces
		, ppHiddenNoWindows = xmobarColor "#6d4d80" ""			--hidden, no windows
		, ppUrgent	= xmobarColor "#e4ff7a" "" . wrap "!" "!"	--urgent workspace
		, ppExtras 	= []
		, ppOrder 	= \(ws:_) -> [ws]
		}

-- Sets spacing between windows
mySpacing :: Integer -> l a -> L.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Binary Tree Partiton + Full Screen layouts
myLayoutHook = avoidStruts $
               reflectHoriz $
               reflectVert $
               bspSpacing ||| fullscreen
			where bspSpacing = mySpacing 5 $ smartBorders $ emptyBSP {-Tall 1 (3/100) (1/2)-};
				  fullscreen = noBorders $ Full;

-- Navigation with spacing
myNavigation2DConfig = def { defaultTiledNavigation    = sideNavigation }

-- Event handling
myEventHook :: Event -> X All
myEventHook = mempty

-- Status Bars and logging
myLogHook = return()

-- Startup Hook
myStartupHook :: X()
myStartupHook = return()

main :: IO()
main = do
    nScreens <- countScreens
    xmonad
        . ewmhFullscreen
        . ewmh
        . withNavigation2DConfig myNavigation2DConfig
        . dynamicSBs barSpawner
        . docks
        $  def
            { terminal 				= myTerminal
            , workspaces            = withScreens nScreens $ map show [1..9]
            , borderWidth			= myBorderWidth
            , modMask				= mod4Mask
            , focusedBorderColor	= myFocusedBorderColor
            , normalBorderColor     = myNormalBorderColor
            , keys					= myKeys
            , layoutHook			= myLayoutHook
            , handleEventHook		= myEventHook
            , logHook               = myLogHook
            , startupHook	 		= myStartupHook
            , focusFollowsMouse     = False
            , clickJustFocuses      = False
            }

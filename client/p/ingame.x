NORK       j %   ³ °ü îZ@ àv 0ÿ G@    ø.@    ///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Client Configuration File
//


// Common configuration
#include "if_client_base.cfg"
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// In-game configuration
//

//
// Base configuration
//

#include "if_input.cfg"
#include "if_cursors.cfg"
#include "if_fonts.cfg"
#include "if_console.cfg"
#include "if_sounds.cfg"
#include "if_common_keybind.cfg"

//
// In-game specifics
//
#include "if_game_templates.cfg"
#include "if_game_colorgroups.cfg"
#include "if_game_minimap.cfg"
#include "if_game_unitdisplay.cfg"
#include "if_game_prereqdisplay.cfg"
#include "if_game_facility.cfg"
#include "if_game_construction.cfg"
#include "if_game_resourcewindow.cfg"
#include "if_game_bonus.cfg"
#include "if_game_squadcontrol.cfg"
#include "if_game_unitcontext.cfg"
#include "if_game_hud.cfg"
#include "if_game_paused.cfg"

#include "if_game_mainmenu.cfg"
#include "if_game_options.cfg"
#include "if_game_saveload.cfg"
#include "if_game_restart.cfg"
#include "if_game_abort.cfg"
#include "if_game_code.cfg"
#include "if_game_medalgoals.cfg"

#include "if_game_keybind.cfg"
#include "if_game_tommycd1.cfg"


//
// Multiplayer specific
//
If("multiplayer.flags.online")
{
  Exec("if_game_multiplayer.cfg");
  Exec("if_game_comms.cfg");
  Exec("if_game_chat.cfg");
  Exec("if_game_messagewindow.cfg");
}
Else()
{
  Exec("if_game_event.cfg");
}


//
// Development only
//
If("sys.buildtype", "==", "release")
{
  Exec("if_game_ai.cfg");
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Abort dialog

CreateControl("Client::Abort", "Window")
{
  Skin("Game::SolidClient");
  Size(200, 100);
  Geometry("HCentre", "VCentre");
  Style("Transparent", "Modal");

  CreateControl("Border", "Static")
  {
    Skin("Game::Panel");
    Geometry("ParentWidth");
    Size(-20, 50);
    Pos(10, 10);
    Style("Transparent");

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }
  }

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-10, 19);
    Pos(0, -19);
    Text("#client.abort.title");
  }

  CreateControl("Text", "Static")
  {
    Geometry("ParentWidth");
    Size(0, 15);
    Pos(0, 25);
    Font("HeaderSmall");
    JustifyText("Centre");
    Style("Transparent");
    Text("#client.abort.text1");
    ColorGroup("Game::Text");
  }

  CreateControl("OK", "Button")
  {
    ReadTemplate("Game::Button");
    Size(75, 25);
    Pos(10, -10);
    Geometry("Bottom", "Left");
    Font("HeaderSmall");
    Text("#std.buttons.ok");

    OnEvent("Button::Notify::Pressed")
    {
      If("gamegod.studiomode")
      {
        Cmd("sys.runcode studio");
      }
      Else()
      {
        If("multiplayer.flags.online")
        {
          If("multiplayer.flags.isHost")
          {
            Cmd("multiplayer.migrate");
            Op("$|Multiplayer::Connect.action", "=", "abort");
            Deactivate("<");
          }
          Else()
          {
            Cmd("multiplayer.abort");

            If("multiplayer.flags.waslobby")
            {
              Cmd("sys.runcode quit");
            }
            Else()
            {
              Cmd("sys.runcode shell");
            }
          }
        }
        Else()
        {
          Cmd("sys.runcode shell");
        }
      }
    }
  }

  CreateControl("Cancel", "Button")
  {
    Geometry("Bottom", "Right");
    ReadTemplate("Game::Button");
    Size(75, 25);
    Pos(-10, -10);
    Font("HeaderSmall");
    Text("#std.buttons.cancel");

    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Right", 0.2);
    }
  }

  OnEvent("Window::Escape")
  {
    DeactivateScroll("", "Right", 0.2);
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Interface activation
//

Cmd("iface.activate Client::MessageWindow");
Cmd("iface.activate Client::MiniMap");
Cmd("iface.activate Client::SquadManager");
Cmd("iface.activate Client::ResourceWindow");
Cmd("iface.activate Client::Facility");//////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// AI Debugging
//

#include "if_skin.cfg"

ConfigureInterface()
{
  CreateColorGroup("AI::Readable")
  {
    AllBg(0, 0, 0, 255);
  }

  DefineControlType("AI::Readable", "Static")
  {
    ColorGroup("AI::Readable");
    SliderConfig("Reg::Std::ListSlider");
  }

  DefineControlType("AI::Title", "Static")
  {
    Size(100, 20);
    Font("System");
    JustifyText("Left");
    Style("Transparent");
  }

  DefineControlType("AI::Variable", "Static")
  {
    Geometry("VInternal", "Right");
    Align("^");
    Size(50, 20);
    Font("System");
    JustifyText("Right");
    Style("DropShadow");
  }

  DefineControlType("AI::Debug::Information", "AI::Debug::Info")
  {
    ReadTemplate("Std::Window");
    Size(500, 480);
    Style("TitleBar");

    CreateVarString("info");

    CreateControl("Information", "DropList")
    {
      ReadRegData("Reg::Std::DropList");
      Pos(5, 5);
      Size(100, 20);
      Height(140);
      Style("SafePulldown");
      UseVar("$<.info");
      OnEvent("DropList::Notify::SelChange")
      {
        SendNotifyEvent("<Config", "TabGroup::Message::Select", "*$<.info");
      }
      ListBox("ListBox")
      {
        ReadTemplate("Std::SliderListBox");

        ItemConfig()
        {
          Font("System");
          Geometry("AutoSizeY", "ParentWidth");
        }

        AddTextItem("Bases");
        AddTextItem("Scripts");
        AddTextItem("Objectives");
        AddTextItem("Resources");
        AddTextItem("Asset");
        AddTextItem("Log");
      }
    }

    CreateControl("Config", "TabGroup")
    {
      Geometry("ParentWidth", "ParentHeight");
      Pos(5, 30);
      Size(-10, -35);

      // Bases
      Add("Bases")
      {
        ReadTemplate("Std::Client");
        CreateControl("Bases", "ListBox")
        {
          ReadTemplate("AI::Readable");
          ItemConfig()
          {
            Font("Console");
            Geometry("AutoSizeY", "ParentWidth");
          }
          Geometry("ParentWidth", "ParentHeight");
          Style("VSlider", "NoSelection", "AutoScroll");
        }
      }

      // Scripts
      Add("Scripts")
      {
        ReadTemplate("Std::Client");
        CreateControl("Scripts", "ListBox")
        {
          ReadTemplate("AI::Readable");
          ItemConfig()
          {
            Font("Console");
            Geometry("AutoSizeY", "ParentWidth");
          }
          Geometry("ParentWidth", "ParentHeight");
          Style("VSlider", "NoSelection", "AutoScroll");
        }
      }

      // Objectives
      Add("Objectives")
      {
        ReadTemplate("Std::Client");
        CreateControl("Objectives", "ListBox")
        {
          ReadTemplate("AI::Readable");
          ItemConfig()
          {
            Font("Console");
            Geometry("AutoSizeY", "ParentWidth");
          }
          Geometry("ParentWidth", "ParentHeight");
          Style("VSlider", "NoSelection", "AutoScroll");
        }
      }

      // Resources
      Add("Resources")
      {
        ReadTemplate("Std::Client");
        CreateControl("Resources", "ListBox")
        {
          ReadTemplate("AI::Readable");
          ItemConfig()
          {
            Font("Console");
            Geometry("AutoSizeY", "ParentWidth");
          }
          Geometry("ParentWidth", "ParentHeight");
          Style("VSlider", "NoSelection", "AutoScroll");
        }
      }

      // Assets
      Add("Asset")
      {
        ReadTemplate("Std::Client");
        CreateControl("Asset", "ListBox")
        {
          ReadTemplate("AI::Readable");
          ItemConfig()
          {
            Font("Console");
            Geometry("AutoSizeY", "ParentWidth");
          }
          Geometry("ParentWidth", "ParentHeight");
          Style("VSlider", "NoSelection", "AutoScroll");
        }
      }

      // Log
      Add("Log")
      {
        ReadTemplate("Std::Client");
        CreateControl("Log", "ConsoleViewer")
        {
          ReadTemplate("AI::Readable");
          ItemConfig()
          {
            Font("Console");
            Geometry("AutoSize");
          }
          Geometry("ParentWidth", "ParentHeight");
          Style("VSlider", "NoSelection", "AutoScroll");
        }
      }
    }
  }
}


//
// Main window for AI debugging
//
CreateControl("AI::Debug::Main", "AI::Debug::TeamList")
{
  ReadTemplate("Std::Window");

  Size(250, 160);
  Style("TitleBar");
  Text("AI debugging");

  // TeamList
  CreateControl("TeamList", "ListBox")
  {
    ReadTemplate("Std::SliderListBox");
    ItemConfig()
    {
      Geometry("AutoSizeY", "ParentWidth");
      Font("system");
    }
    Geometry("ParentWidth", "ParentHeight", "Right");
    Size(-125, -10);
    Pos(-5, 5);
    Style("VSlider", "CanClear");
    UseVar("$<.currentTeam");

    TranslateEvent("ListBox::DblClick", "SwitchTo", "<");
  }

  // Menu
  CreateControl("Menu", "Menu")
  {
    Geometry("HInternal");
    Style("Transparent", "NoAutoSize");
    Size(120, -10);
    Pos(5, 5);

    ItemConfig()
    {
      ReadTemplate("Std::Button");
      Font("System");
      Size(100, 20);
    }
    AddItem("Info")
    {
      TranslateEvent("Button::Notify::Pressed", "Info", "<<", "AI::Debug::Information");
    }
    AddItem("Threat")
    {
      OnEvent("Button::Notify::Pressed")
      {
        IFaceCmd("client.clustermap.create threat", "*$<<.currentTeam", " *");
      }
    }
    AddItem("Defense")
    {
      OnEvent("Button::Notify::Pressed")
      {
        IFaceCmd("client.clustermap.create defense", "*$<<.currentTeam", " *");
      }
    }
    AddItem("Pain")
    {
      OnEvent("Button::Notify::Pressed")
      {
        IFaceCmd("client.clustermap.create pain", "*$<<.currentTeam", " *");
      }
    }
    AddItem("Occupation")
    {
      OnEvent("Button::Notify::Pressed")
      {
        IFaceCmd("client.clustermap.create occupation", "*$<<.currentTeam");
      }
    }
    AddItem("SwitchTo")
    {
      TranslateEvent("Button::Notify::Pressed", "SwitchTo", "<<");
    }
  }

  OnEvent("SwitchTo")
  {
    IFaceCmd("client.development.setteam", "*$.currentTeam");
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

ConfigureInterface()
{
  DefineControlType("Client::Bonus::Base", "Window")
  {
    Geometry("Right", "Bottom");
    Size(32, 32);
    Style("Inert", "SaveState");

    OnEvent("Control::ActivateHook")
    {
      ActivateScroll("", "Right", 0.5);
    }
  }
}

CreateControl("Client::Bonus::Health", "Client::Bonus::Base")
{
  Pos(0, -241);
  ColorGroup("Sys::Texture");
  Image("if_game_bonus.tga", 0, 0, 32, 32);

  CreateControl("Timer", "Timer")
  {
    PollInterval(10000);

    OnEvent("Timer::TimeOut")
    {
      DeactivateScroll("<", "Right", 0.5);
    }
  }
}

CreateControl("Client::Bonus::Speed", "Client::Bonus::Base")
{
  Pos(0, -204);
  ColorGroup("Sys::Texture");
  Image("if_game_bonus.tga", 32, 0, 32, 32);
}

CreateControl("Client::Bonus::Weapon", "Client::Bonus::Base")
{
  Pos(0, -167);
  ColorGroup("Sys::Texture");
  Image("if_game_bonus.tga", 0, 32, 32, 32);
}
           @ @      				.C??			????			???   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    F@GIÿ?GJÿ:ACÿ:ABÿ=DFÿ<DFÿ:BCÿ>FIÿ;BEÿ:ACÿ=DFÿ=EFÿ;BEÿ:BEÿ7>Aÿ;CFÿ;BEÿ9ABÿ;CFÿ9@Bÿ8@Bÿ6?Bÿ7?Bÿ9ADÿ8ACÿ:BEÿ;CEÿ6>@ÿ:BDÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    3NWYÿLUXÿYdfÿYefÿ^hkÿ`lnÿ_imÿalpÿbnrÿ[jlÿ_stÿYqoÿYmmÿXpoÿWonÿTllÿTpnÿUrpÿQqmÿQ}uÿUqoÿVfhÿVkmÿXlnÿVfhÿ[jnÿVacÿT_cÿQ[]ÿ<DHÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    T]_ÿcnqÿp|ÿzÿuÿnÿnÿrÿnÿhÿnÿlÿfÿjÿ_ÿUÿS£ÿP¥ÿO­ÿO°ÿU»¢ÿyÈ¸ÿÐÂÿÉºÿr¾¯ÿj°¢ÿa©ÿ^ÿaÿ`vxÿQ[_ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    n|ÿÿÿÿpÿnÿjÿgÿaÿlÿfÿdÿ`¢ÿY¡ÿX£ÿTÿS¡ÿ^§ÿh±£ÿl¸ªÿÉ¾ÿÒÊÿ¨çâÿªîéÿÜÒÿÉ¿ÿvÀ³ÿk±¤ÿ^ÿaÿdpuÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    }ÿ ¢ÿÿ|ÿlÿLzrÿ9OLÿ>UQÿCYXÿFYXÿE]\ÿ>_Yÿ7`WÿB]ZÿDWWÿ@WSÿASRÿ?URÿ<_YÿEeaÿCc`ÿA^[ÿK`aÿG\[ÿBUUÿGZ[ÿJ`aÿFTVÿCNQÿALNÿ=EIÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ÿ¯¸ºÿÿyÿNedÿ-35ÿDKMÿEkeÿJohÿPypÿPokÿIphÿHtmÿDleÿBjcÿEqiÿCmfÿL{sÿIwoÿ@qiÿ?ofÿBifÿDkgÿChcÿ?gbÿBhcÿJhfÿKgeÿEgcÿMddÿ?HKÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ¡ÿ¿ÆÇÿÿsÿ$/.ÿ8BCÿXllÿ?thÿ @5ÿLmgÿEqhÿLzpÿKsmÿKkiÿ<lbÿBleÿ>fbÿ<ofÿ@jdÿEmiÿDlgÿ@oiÿ=ibÿ9f^ÿ7neÿ7lbÿ=pjÿImjÿ$..ÿS`dÿ>HKÿùùùÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ÿ¼ÄÆÿuÿmÿÿGUUÿOniÿ°ªÿTlkÿBf`ÿKzpÿIvkÿLvoÿMolÿBtnÿ=qjÿ;snÿ8icÿ=heÿ>fbÿ:jdÿ1iaÿ(bVÿ+fWÿ0g^ÿ8haÿ>kfÿ°ªÿLfgÿNY]ÿ;BGÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ÿ¼ÃÅÿnÿiÿÿGPRÿNvoÿMifÿMjhÿFdaÿBqgÿFgaÿQgeÿKfeÿAnkÿ@jfÿ?qnÿ7cbÿHtsÿ4f^ÿ,g\ÿ$^TÿUHÿ \Lÿ#`Rÿ-e[ÿ:gdÿAqkÿEjgÿGXZÿ:BFÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ¢ÿ·ÄÅÿiÿeÿ   ÿKTXÿMsnÿLxpÿReeÿOdfÿFmhÿDofÿInhÿJmhÿFtmÿBsmÿ;nhÿ<qpÿ4c]ÿ+h\ÿ!]OÿxäÃÿIÍ ÿCËÿ4lÿ"`Qÿ2jbÿ?ecÿEdcÿFY[ÿ<DGÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ÿºÀÂÿkÿe¢ÿÿC\YÿGpiÿDvkÿDqjÿCphÿPonÿEqiÿDsjÿ@shÿHpgÿEljÿ<b`ÿ;ifÿ*bZÿ%gYÿ#ZNÿëÑÿ^Á¦ÿIµÿE½ÿYIÿ*g[ÿ7c_ÿ=c`ÿCYXÿ=HJÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ÿ»ÃÄÿkÿ_£ÿÿ>WRÿBqhÿJoiÿFoiÿIljÿMxpÿHqiÿDqfÿAsgÿGogÿEleÿ9faÿ2i`ÿ'j_ÿ_NÿBvÿïÛÿZÀ¡ÿkâ´ÿ&¿ÿTGÿ)fZÿ9f`ÿ<gcÿ7QQÿ@JMÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ÿºÃÃÿkÿb¨ÿ
ÿ=WQÿGjhÿ@pgÿD}rÿ@jeÿMpkÿKecÿGe`ÿEphÿ>qdÿ8i_ÿ2i]ÿ,l`ÿ#gXÿ]Oÿf«ÿ~ÞÆÿP·ÿPÒ¢ÿ,±ÿWHÿ)h[ÿ9e`ÿ5b^ÿ6WVÿAKMÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ     ÿ¼ÉÈÿn ÿc©ÿÿAVTÿGnjÿ>wmÿAtkÿAgaÿ>g`ÿAibÿ?odÿ8l`ÿ2l_ÿ+fXÿ![LÿVFÿ[KÿVGÿÏ¿ÿbÈªÿE®ÿeÛ´ÿ+fÿZLÿ-k`ÿ8hdÿ5jdÿ6VVÿ<EHÿúúúÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    £¥ÿÁÈÉÿo£ÿlªÿÿDZWÿJuoÿDpiÿ<haÿ;kcÿ;reÿ:wjÿ9xhÿ1tdÿ#dTÿUEÿ]ÿ\Û´ÿyêÇÿsâÄÿ¥÷çÿZ¿¢ÿLÀÿ<Èÿ'gQÿ_Oÿ+i[ÿ:fbÿ3f^ÿ7YVÿ9ACÿùùùÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ¤§ÿÁÈÊÿm©ÿi¬ÿÿH\\ÿL|sÿ@wjÿ0i`ÿ-k`ÿ'fXÿ'j[ÿ&hXÿ]LÿTFÿH.ÿYÒ¹ÿEÿ;/ÿ)ULÿ±üðÿRµÿkÝ³ÿ4Áÿ[Iÿ aRÿ.h^ÿ6`\ÿ7f_ÿ4QNÿ8ACÿöööÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    £¨ÿÂÉÌÿr±¦ÿhº§ÿ ÿ?_]ÿBwjÿ5qbÿ"]Nÿ`NÿQCÿL>ÿSCÿaKÿjPÿyÿbâÃÿL?ÿ8,ÿQBÿüÙÿ> ÿLÈÿ-±ÿZJÿ bTÿ.j`ÿ5^Zÿ4h`ÿ7XTÿ<CHÿôóóÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ     ¨ÿÀÈËÿiµ¥ÿmÆ²ÿ  ÿ6]Yÿ6reÿ(`SÿPÈ ÿA»ÿ7Çÿ<Éÿ6Æÿ-Áÿ0Áÿ,¿ÿ7Çÿ0Ãÿ0Äÿ)©}ÿ[à¯ÿD±ÿ=´ÿjÿbMÿ!bTÿ+g\ÿ5_[ÿ9b_ÿ7YWÿ8@Bÿóòòÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ     ¦ÿÀÅÉÿjº¨ÿÑÂÿÿ2_Wÿ-gZÿ>tiÿÿÙÿfÇ¬ÿçËÿçÍÿ~åÈÿzæÆÿtãÄÿ{ìÊÿzôÐÿpîÊÿwñÏÿyòÑÿwðÒÿdã¯ÿké¼ÿ3Âÿ)vÿ ^Nÿ+dZÿ:icÿ7_\ÿ/URÿ4?Aÿôóóÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    §­ÿÇÍÐÿoÆ²ÿáÓÿ&&ÿ1`Vÿ6rhÿÌÀÿµ÷ïÿfÍ±ÿ¨ÿòÿªÿñÿªÿðÿÿèÿÿîÿ=ÿ+uÿ,rÿ\»¡ÿN¸ÿQºÿU»ÿJ³ÿ2¦ÿ$vÿ\Jÿ,e[ÿ<jdÿ9leÿ3YVÿ2<@ÿñððÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    £©ÿÈÎÐÿ}Ìºÿªíåÿ+88ÿ7c[ÿ7qfÿ×Ñÿ®íèÿoÆµÿ³õñÿ¶÷ôÿ°öòÿ®õìÿ¬óêÿ_­ÿrº®ÿT¨ÿ¹ÿöÿ©ÿöÿ´ÿüÿÃÿýÿ¾ýýÿ¾ûøÿ ïäÿdRÿ0i]ÿ;hbÿ:meÿ:_\ÿ7=@ÿñððÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ     ¨ÿ¼ÊÌÿÇ»ÿ¤áÛÿÿ<]Xÿ>rgÿ/j\ÿ"iVÿ_Lÿ#XJÿSCÿ VFÿTDÿPAÿOAÿVFÿM?ÿRCÿM>ÿRCÿQBÿ1aSÿTEÿ ZJÿ+dUÿ4d[ÿ7kcÿAdaÿC^^ÿ8?Cÿóóóÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ     §ÿ¹ÍËÿuÀ®ÿÒÇÿÿC[YÿJrlÿAtlÿ6pdÿ0n_ÿ1rbÿ/p_ÿ/qaÿ/qaÿ+l\ÿ,paÿ'gXÿ%dTÿ'iYÿ'hXÿ*m\ÿ+m]ÿ,m^ÿ+j[ÿ/k]ÿ7j_ÿ<b\ÿ8aXÿIaaÿP_`ÿ;BCÿóóóÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ¤ÿ»ÌËÿt·§ÿwÄ³ÿ	ÿ@POÿKnhÿOqnÿ<1ÿCtjÿ=oeÿBwmÿ@wkÿGvÿ?uiÿC{oÿ>rgÿ8jaÿ9ncÿ5m`ÿ6nbÿ9pdÿ7pdÿ=rfÿ@ukÿ=c^ÿ7]WÿBmdÿ"50ÿU_aÿ7=?ÿðððÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    £¦ÿÃÍÌÿª ÿpÃ¯ÿ"ÿ/67ÿ>ZUÿ²¬ÿJuÿLupÿOsmÿOyqÿQtpÿPplÿTztÿJqkÿK{rÿ@pdÿ;j`ÿIwpÿ=f`ÿ?mdÿ8g_ÿ8d]ÿAjcÿCe`ÿA]Zÿ¨£ÿAviÿKigÿ8>@ÿçææÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ¡¢ÿÇÌÎÿw¯ÿxµ¦ÿKyoÿ(..ÿ#+*ÿAUSÿFd]ÿEZWÿBWTÿDZXÿKZZÿNZ[ÿGeaÿF_[ÿFZWÿG\\ÿ?XUÿ<NLÿBRQÿ<JKÿ>SRÿ>QNÿARQÿCNOÿFRRÿ>KMÿCSTÿAWUÿ278ÿéééÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ¡£ÿÅËÍÿ°¤ÿo¸¡ÿo¥ÿTvpÿ2EBÿÿÿÿ	ÿÿÿ%"ÿ ÿÿ   ÿ
ÿÿÿ
ÿ	ÿ
ÿÿÿÿÿÿÿ   ÿ   ÿóóóÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ÿ¾ÄÆÿ·ÀÁÿ·­ÿq²ÿe¸ ÿa¹ ÿoÁ­ÿjÅ±ÿQÄ¥ÿjÏ·ÿuÙÂÿqÓ¾ÿÛÉÿßÏÿÞÍÿâÐÿæ×ÿäÖÿ}×ÅÿÜÏÿáÔÿÖÇÿÓÇÿ|Ï¾ÿxÇ·ÿt¹¬ÿ^®ÿRÿcnrÿKSTÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    ÿ¨ªÿ¾ÅÆÿ¶½Àÿ¬§ÿrªÿk±ÿsº©ÿv½­ÿm¾ªÿrÆ±ÿqÆ³ÿoÂ°ÿxÈ·ÿyÎ¼ÿyÉ¸ÿk¼¬ÿnÁ°ÿsÇ·ÿm¼«ÿk¹©ÿl½¬ÿi¼©ÿo¹©ÿi¶¤ÿ`±ÿf¢ÿhÿsÿo{}ÿdosÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    =CE9ÿ¢ª¬ÿÇÍÎÿÄÉËÿÅÌÍÿÂÈÉÿÃÉÊÿÆÎÏÿ¾ÊÊÿÁËÌÿÁËÌÿ»ÉÈÿ½ÎÍÿ½ËËÿ¿ÍÍÿºÉËÿ»ÇÉÿ¼ÄÇÿºÁÂÿºÂÄÿ¼ÄÅÿ¼ÂÃÿ»ÂÃÿ½ÅÆÿ¸ÂÂÿ¾ÅÇÿ¼ÃÄÿ¿ÄÆÿ¾ÄÆÿ¡¢ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ       IQS9ÿ¦§ÿ¡®±ÿÿ¡¥ÿ£¦ÿ¢¤ÿ¤¥ÿ©¬ÿÿ¡£ÿÿ¡¢ÿ¢ÿÿÿÿÿÿÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ    				.C??			????			???   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?    				.C??			????			???   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?    F@GIÿ?GJÿ:ACÿ:ABÿ=DFÿ<DFÿ:BCÿ>FIÿ;BEÿ:ACÿ=DFÿ=EFÿ;BEÿ:BEÿ7>Aÿ;CFÿ;BEÿ9ABÿ;CFÿ9@Bÿ8@Bÿ6?Bÿ7?Bÿ9ADÿ8ACÿ5<>ÿ5<>ÿ17:ÿ*/2ÿ    F@GIÿ?GJÿ:ACÿ:ABÿ=DFÿ<DFÿ:BCÿ>FIÿ;BEÿ:ACÿ=DFÿ=EFÿ;BEÿ:BEÿ7>Aÿ;CFÿ;BEÿ9ABÿ;CFÿ9@Bÿ8@Bÿ6?Bÿ7?Bÿ9ADÿ8ACÿ:BEÿ;CEÿ6>@ÿ:BDÿ    3NWYÿLUXÿYdfÿYefÿ^hkÿ`lnÿ_imÿisÿlvÿjsÿnxÿluÿmv£ÿmv­ÿmwªÿlt§ÿkt¥ÿmv§ÿjt¬ÿkuªÿitÿgqÿcmÿcnÿcmÿ`m~ÿVacÿT_cÿQ[]ÿCMPÿ    3NWYÿLUXÿYdfÿYefÿbgjÿkjkÿdhlÿalpÿbnrÿ_gjÿemqÿ`hjÿafjÿhfiÿjfiÿlfjÿhcfÿhehÿbceÿffhÿdegÿ_`cÿ_`dÿegjÿdbeÿhgkÿ``aÿV_cÿQ[]ÿ<DHÿ    T]_ÿcnqÿp|ÿzÿyÿnzÿnx¦ÿu§ÿt~§ÿr|©ÿr{·ÿ~³ÿ|¾ÿ|ÈÿÌÿÒÿÔÿ¤ÝÿÙÿÞÿÓÿÆÿwÃÿr|®ÿmy¥ÿmy¢ÿq|§ÿoz¤ÿlxÿalÿOXoÿ    T]_ÿcnqÿp|ÿzÿ}ÿzz{ÿ{|ÿ}ÿz}ÿyzÿÿÿÿ¢ÿ¦~ÿ´ÿÁÿºÿ®ÿ¤yzÿ§~~ÿ­vuÿ}ÿ yyÿªÿ¬ÿ¨ÿyzÿrsÿnqvÿ\]`ÿ    n|ÿÿÿ|ªÿpz­ÿr|¤ÿjtÿq}ÿuÿqz´ÿs}´ÿºÿÈÿÏÿ£×ÿ©®áÿ±µàÿ¸¼æÿ«¯áÿ¯´äÿ¦ªãÿÔÿËÿ¾ÿp{©ÿiu¡ÿmx¨ÿq~ÿrÿqÿansÿ    n|ÿÿÿÿwwÿwyÿzzÿ{}ÿvxÿÿ§ÿ°ÿ³ÿ·ÿÃ¢¢ÿÃ¤¢ÿÎ©¦ÿÓ¯­ÿÊ¦¥ÿÁÿ¼ÿ¹ÿÂÿ¹ÿÈ ÿÍ¥£ÿÁÿµÿ«ÿÿrtÿ    }ÿ ¢ÿÿ{­ÿx¨ÿenÿ04Lÿ5:Tÿ9?^ÿ:?_ÿ<BiÿCHnÿ?Ciÿ04Mÿ6:Wÿ:>[ÿ;?Yÿ6:Tÿ48Sÿ48Sÿ37Qÿ05Pÿ15Oÿ8>^ÿ;@cÿ8>\ÿ;@\ÿ?D`ÿ@E`ÿ@FYÿ>FJÿ    }ÿ ¢ÿÿÿwzÿg`aÿKCDÿLJJÿNNRÿQQSÿORUÿKKMÿAFHÿNOQÿSNPÿUONÿVLMÿTNMÿUPRÿQORÿIJNÿGHKÿKHKÿHFGÿIEFÿIEHÿUPRÿJIKÿIJNÿDJMÿDLPÿ    ÿ¯¸ºÿ~ÿw¸ÿ\dÿ.2IÿCJSÿPZeÿQ\jÿYgnÿYdgÿR\hÿP]oÿIThÿGO{ÿ8@tÿ,2oÿ-3zÿ-2ÿ/5yÿ7?bÿCLcÿLVjÿNYeÿMYiÿMXhÿQ]gÿLWlÿLWfÿS^bÿMX\ÿ    ÿ¯¸ºÿÿ {yÿ][]ÿ125ÿ]MMÿ}[[ÿt`_ÿwgfÿnabÿn]]ÿd_aÿZUWÿ[NQÿcPQÿaLNÿlX[ÿfY[ÿ_X\ÿ]XZÿ\TXÿbSVÿbOPÿcOOÿ`PQÿ_VXÿZZ\ÿWY\ÿg\^ÿVVYÿ    ¡ÿ¿ÆÇÿ~£ÿs{»ÿ&*?ÿ9AJÿUapÿKTmÿ.4GÿUbcÿP\fÿR]pÿPZoÿFPuÿ3:oÿ#)ÿ{ÿuÿqÿiÿ!&^ÿ9BgÿKUgÿNWeÿNZlÿKUjÿNXoÿQ[mÿ(-6ÿVcgÿDNQÿ    ¡ÿ¿ÆÇÿÿ¬qoÿ,*+ÿGCDÿighÿk]^ÿM66ÿl__ÿl]\ÿn_aÿmXZÿoPSÿ`BCÿ¢2-ÿ×ngÿvBCÿhLMÿhSUÿgSTÿkRSÿoJJÿ¤2-ÿ×ngÿvEDÿgPSÿaWZÿ))*ÿn_`ÿYSVÿ    ÿ¼ÄÆÿz¦ÿs|µÿÿGPeÿQZnÿ|ÿQ\pÿMU_ÿWcnÿNWnÿKVwÿ@Iÿ.5ÿÿÿ\\ÿÿ::ÿÿ<<ÿÿEGÁÿdÿ.5lÿENlÿPZmÿNZmÿKVmÿP[lÿÿOZlÿVafÿCLPÿ    ÿ¼ÄÆÿ~~ÿ¥tsÿÿNSTÿ]dfÿ«ÿocdÿfUWÿjabÿbWXÿmRTÿtIIÿ¬2-ÿýÿÿ¬¢ÿÖupÿ~@@ÿjEGÿrIJÿvFFÿ­0+ÿþÿÿ¬¢ÿÖupÿ{FFÿ­ÿdY\ÿy\]ÿZORÿ    ÿ¼ÃÅÿz£ÿpx·ÿÿEM\ÿQ[tÿLUoÿLUpÿKSjÿPZgÿHPjÿGNuÿ7>ÿ%+ÿÚÚÿÿ¤¤ÿÿÿÿÿÿ33ÿÿzÿ'-uÿCMtÿKVnÿO[jÿNXlÿMXmÿNYpÿNXjÿS^cÿCLPÿ    ÿ¼ÃÅÿÿ¥xxÿ   ÿWQRÿjghÿu]^ÿd]aÿ]VYÿaUVÿcJJÿsEEÿ¬.(ÿþ¦ÿÿ½¶ÿÿ´«ÿøÿÖ}ÿx<;ÿx=<ÿ¯-(ÿþ¦ÿÿ½¶ÿÿ´«ÿøÿÖzÿvPSÿlVYÿxY[ÿ\MPÿ    ¢ÿ»ÃÆÿyÿmuÃÿ   ÿIR\ÿT_pÿS\sÿR[iÿMVsÿKUqÿFOnÿ@Iyÿ28ÿ$£ÿÙÙÿÿ¬¬ÿÿÿÿÿÿ66ÿÿ
ÿ"'yÿ:BqÿGPpÿJVlÿIUeÿNXoÿMWkÿLViÿS^dÿBLOÿ    ¢ÿ¼ÁÄÿÿ¤yyÿÿWTWÿcegÿkefÿhZ]ÿdX[ÿhOPÿnCBÿ¯2,ÿþÿÿ½µÿÿ­¥ÿÿ®¦ÿýÿ©95ÿ42ÿ¯,%ÿþÿÿ½µÿÿ­¥ÿÿ®¦ÿüÿ¨DAÿoOQÿgTWÿnZ]ÿ]MOÿ    ÿºÀÂÿpy¯ÿ}Éÿ   ÿHRWÿKUqÿMXoÿISpÿFOuÿFOzÿ<Ctÿ4;ÿ&+ÿ ÿááÿÿ´´ÿÿ±±ÿÿ££ÿÿAAÿÿ	ÿ|ÿ/5{ÿ;CuÿAJsÿAKjÿEOlÿISkÿISiÿNYfÿDNRÿ    ÿ»½¿ÿ~~ÿ¥}|ÿÿRRUÿ`^aÿ_]_ÿfUWÿjPQÿyJJÿ®1,ÿþÿÿ¼µÿÿ®¦ÿÿ¶¯ÿýÿ´:5ÿu)'ÿ´*#ÿþÿÿ¼µÿÿ®¦ÿÿ¶¯ÿýÿ®C?ÿkGIÿiQTÿeTXÿdZ]ÿbORÿ    ÿ»ÃÄÿox¶ÿÊÿ   ÿ@JZÿJVmÿJUoÿCKvÿ<Dÿ17~ÿ$)yÿ ÿÿ§ÿßßÿÿ»»ÿÿ²²ÿÿ­­ÿÿbbÿÿ¥ÿÿÿ"'xÿ(-pÿ06nÿ6=eÿDMgÿISpÿKVdÿENRÿ    ÿ»ÂÃÿ¥}|ÿ¤~ÿÿIKMÿcZ\ÿ`UXÿgNOÿxIIÿµ1*ÿþÿÿ¾¹ÿÿÀ¸ÿÿ²«ÿýÿ¹?8ÿ)$ÿ´$ÿýÿÿ¾¹ÿÿÀ¸ÿÿ²«ÿýÿ´HBÿ}HHÿoNPÿkWXÿg\_ÿaY[ÿdORÿ    ÿ½ÃÄÿqxÀÿÔÿ   ÿ@GYÿJVoÿAJtÿ=Fÿ',ÿÿÿ	ÿ¤ÿªÿÒÒÿÿ´´ÿÿ°°ÿÿÿÿiiÿÿ³ÿ¤ÿÿ
ÿxÿdÿ $\ÿ7?fÿFPnÿPZkÿENSÿ    ÿ¾ÀÀÿ­}|ÿ¼ÿ	ÿGGIÿhVYÿgKMÿwIJÿ±)#ÿþ¥ÿÿÅ½ÿÿÅ¾ÿÿ¼³ÿý¦ÿ¿F@ÿ)$ÿ¿ÿþ¤ÿÿÅ½ÿÿÅ¾ÿÿ¼³ÿý¦ÿ¸MIÿvDDÿpNOÿgSVÿhY\ÿ_]bÿe^bÿbPSÿ     ÿÂÉÊÿ{Çÿ¥Úÿ   ÿBKZÿGPuÿ>G~ÿ29ÿÿÿ~~ÿÿ~~ÿÿkkÿÿffÿÿ}}ÿÿ¦¦ÿÿ²²ÿÿ  ÿÿ¸¸ÿÿ~~ÿÿaaÿÿddÿÿFFÿÿRRÿÿRRÿÿ68åÿiÿ-4lÿDMrÿMWjÿBLRÿ     ÿÃÇÈÿ¦ÿÃÿÿLIKÿcRUÿnHHÿ¾<5ÿöÿÿÅ¾ÿÿÌÄÿÿÆÀÿþ°©ÿ¼;5ÿ)%ÿÈ3*ÿöÿÿÅ¾ÿÿÌÄÿÿÆÀÿþ°©ÿ·B=ÿq??ÿhKLÿjSUÿcZ^ÿ^]bÿc`eÿg]aÿ`OQÿ    £¥ÿÂÈÉÿ|Èÿ°²êÿ   ÿELcÿIR{ÿ<Cÿ05ÿññÿÿËËÿÿ³³ÿÿªªÿÿ©©ÿÿªªÿÿ¨¨ÿÿ¤¤ÿÿ©©ÿÿ´´ÿÿªªÿÿ¤¤ÿÿÿÿÿÿÿÿÿÿ99ÿÿoÿ(-mÿ@ImÿJUjÿCLQÿ    £¥ÿÂÈÉÿ©ÿÌ¢ ÿÿTLMÿnRTÿÇSMÿö·°ÿúÂ»ÿüÌÄÿ÷½¶ÿþ­¨ÿ¾2*ÿ*%ÿÎI@ÿö·°ÿúÂ»ÿüÌÄÿ÷½¶ÿþ­¨ÿ´60ÿ@?ÿmHJÿgRTÿdVXÿhXZÿ^\aÿe]`ÿa\`ÿ^OQÿ    ¤§ÿÁÈÊÿÌÿµ·íÿ   ÿIOhÿMTÿ>Fÿ8=¨ÿññÿÿÕÕÿÿÎÎÿÿÆÆÿÿÆÆÿÿÀÀÿÿµµÿÿ¨¨ÿÿ¥¥ÿÿ¬¬ÿÿÿÿ¬¬ÿÿ­­ÿÿ¡¡ÿÿÿÿ  ÿÿRRÿÿyÿ&+kÿ@GqÿEOeÿBLRÿ    ¤§ÿÂÅÇÿ²ÿÖ¬¨ÿ,%%ÿ[OQÿMLÿÿÄ¿ÿÿØÓÿÿÇÀÿüÉÂÿ÷¸±ÿÇfbÿ(#ÿ¢+&ÿÿÄ¾ÿÿØÓÿÿÇÀÿüÉÂÿ÷¸±ÿÅfcÿ40ÿ~BAÿkNPÿjTUÿ^UXÿ`Z_ÿmX[ÿs\^ÿcWXÿ\NQÿ    £¨ÿÂÉÌÿÎÿ¦ªâÿ   ÿHOiÿMU}ÿBIÿ.4ÿññÿÿÝÝÿÿÖÖÿÿÎÎÿÿËËÿÿÍÍÿÿ¿¿ÿÿ¸¸ÿÿ¦¦ÿÿ²²ÿÿ®®ÿÿ©©ÿÿ¥¥ÿÿ²²ÿÿ­­ÿÿÿÿVVÿÿÿ+2oÿAJmÿHSfÿCMSÿ    £¨ÿÃÆÉÿ´ÿÔ«©ÿ7/.ÿYPSÿxUUÿÍVOÿÿßÛÿÿÔÎÿÿÄ½ÿúÁºÿúÿ»+$ÿ-)ÿÑJBÿÿßÛÿÿÔÎÿÿÄ½ÿúÁºÿúÿ³0*ÿu;:ÿpKMÿiUYÿeTWÿe\`ÿbY]ÿ`\_ÿmY[ÿXMQÿ     ¨ÿÀÈËÿ}Ëÿ¡Üÿ   ÿGObÿOX}ÿGNÿ4:ÿÿÿÿÿññÿÿññÿÿññÿÿññÿÿññÿÿààÿÿÄÄÿÿªªÿÿ³³ÿÿªªÿÿÈÈÿÿÕÕÿÿÕÕÿÿÙÙÿÿÍÍÿÿÿÿ-1ÿ6>sÿCMqÿLWiÿBMRÿ     ¨ÿÁÅÈÿ²ÿË¢¡ÿÿWNSÿx[[ÿOOÿÊIBÿÿÜØÿÿÔÏÿÿÈÁÿÿÃ½ÿý}ÿ·&ÿ)$ÿÐ?6ÿÿÜØÿÿÔÏÿÿÈÁÿÿÃ½ÿý}ÿ±0*ÿuCAÿpSSÿdSWÿkXZÿXY\ÿc\`ÿo\_ÿeNPÿ     ¦ÿÀÅÉÿzÊÿÖÿ   ÿHPdÿS[tÿLTÿCKÿ4:ÿ).ÿ"&¥ÿ¤ÿ°ÿ¶ÿññÿÿÖÖÿÿµµÿÿ»»ÿÿYYýÿ«ÿ¤ÿ(+©ÿ"ÿ%*ÿ-4ÿ8A{ÿEOwÿHRoÿKVeÿDNUÿ     ¦ÿÁÁÅÿ´ÿÆÿ		ÿYRUÿn\]ÿuWWÿ}JHÿ¿C=ÿÿÞÚÿÿÖÐÿÿÇÀÿÿ½¶ÿýulÿº+%ÿ -'ÿÅ81ÿÿÞÚÿÿÖÐÿÿÇÀÿÿ½¶ÿýulÿ©3.ÿqDCÿiNOÿhUVÿf]`ÿi[^ÿvYZÿeOQÿ    §­ÿÇÍÐÿw¿ÿÍÿ   ÿIQcÿVa{ÿT^{ÿOXÿHOÿ?Fÿ4:ÿ-3ÿ# ÿ¦ÿññÿÿÓÓÿÿ²²ÿÿµµÿÿAAòÿÿÿ%)ÿ06ÿ8@ÿ>G}ÿEOxÿMWrÿNVtÿOZgÿALQÿ    §­ÿÈÆÈÿ­ÿÅ¡¡ÿÿZTVÿpgkÿm_bÿ}ZZÿMKÿÁJCÿÿãßÿÿÔÍÿÿÄ¼ÿÿ¶¯ÿýmgÿ¹+$ÿ+&ÿÃ?6ÿÿãßÿÿÔÍÿÿÄ¼ÿÿ¶¯ÿýmgÿª4/ÿqFFÿmPSÿmZ[ÿv^`ÿtZ\ÿULOÿ    £©ÿÈÎÐÿÀÿsyÎÿ   ÿPY_ÿOXvÿU]vÿU^{ÿQYÿNV~ÿJRÿ:@ÿ+0ÿ©ÿññÿÿÚÚÿÿÂÂÿÿÆÆÿÿGGÿÿ	
ÿ"ÿ5;ÿ?FwÿCLqÿHRqÿKTqÿNXqÿR\pÿV_mÿAKOÿ    £©ÿÉÈÊÿ°ÿ¶ÿÿeX[ÿuadÿrbdÿy`aÿ[[ÿKHÿÃLEÿÿÝØÿÿÐËÿÿÁ»ÿÿ¹²ÿýohÿ·.(ÿ-(ÿÇC<ÿÿÝØÿÿÐËÿÿÁ»ÿÿ¹²ÿýohÿ©72ÿpJKÿvVWÿt]^ÿ^_ÿUKLÿ     ¨ÿÄËÏÿ¬ÿu}Ãÿ   ÿLT]ÿYbsÿU^uÿ\guÿU\wÿYa~ÿPWvÿJRÿ7=ÿ $ÿññÿÿÚÚÿÿÐÐÿÿÀÀÿÿuuÿÿÿ&+ÿ>EtÿKTsÿLVkÿNWgÿLViÿOZmÿS\nÿYdhÿEPUÿ     ¨ÿÅÅÉÿªÿ­ÿ   ÿbVWÿ{ffÿsggÿtefÿ{^^ÿ[[ÿ}IFÿÂHBÿþÜØÿÿÐËÿÿÅ¾ÿÿ¿·ÿýyÿ³3.ÿ30ÿÂB;ÿþÜØÿÿÐËÿÿÅ¾ÿÿ¿·ÿüyÿ£:7ÿhRSÿv[\ÿ{]_ÿdNRÿ     §ÿÈÎÒÿ±ÿu·ÿÿJRaÿS\uÿU]xÿS[wÿT]sÿ\dsÿR[uÿNV~ÿAGÿ)-ÿññÿÿÜÜÿÿääÿÿÎÎÿÿÿÿÿ06yÿHPuÿMVmÿP\hÿOYiÿQZjÿKThÿQZjÿT`bÿHRUÿ     §ÿÉÉÌÿ¤ÿ«ÿÿ`VXÿmijÿghÿdeÿrbbÿx^_ÿuTTÿKIÿÂKEÿþØÔÿÿÒÍÿÿÄ½ÿþ·°ÿàUNÿ}<9ÿ?<ÿÀHBÿþØÔÿÿÒÍÿÿÄ½ÿþ·°ÿßVOÿfKJÿbWZÿa\]ÿeQRÿ    ¤ÿÇÍÐÿ°ÿ}¶ÿÿEKaÿR[oÿU\vÿ15Iÿ\goÿX_kÿW_vÿQYyÿMTÿ5:ÿÿÿÿÿññÿÿññÿÿññÿÿIIÿÿ',ÿ;AtÿJRmÿQ[lÿS]nÿMVkÿOZhÿPYlÿ+1?ÿU_aÿENPÿ    ¤ÿÈÉÌÿ¤ÿ¦ÿÿQNOÿsbbÿuhjÿO76ÿsffÿy\]ÿ{^^ÿwUUÿTRÿ»D>ÿþÓÏÿýÔÐÿîÿEBÿmEDÿpGFÿwCBÿµ@;ÿþÓÏÿýÔÐÿîÿ~HEÿjTSÿ,**ÿX\^ÿ^MMÿ    £¦ÿÇÍÎÿ­ÿzºÿ	ÿ16?ÿFM\ÿ~ÿXauÿ`imÿ[eoÿZcuÿZdxÿPX}ÿIQÿ5:ÿ/4¡ÿ&*ÿ&*ÿ4<ÿ9B{ÿISvÿNYjÿPYfÿQYjÿP[nÿMVkÿÿT_fÿT`dÿFPSÿ    £¦ÿÉÅÅÿ¨ÿ ÿÿ157ÿ`QQÿ¯ÿhhÿ~deÿ{ddÿ~edÿx_`ÿuWWÿVUÿ¼OJÿÞÿFCÿeGGÿs\\ÿdQQÿoRQÿnIIÿ¶LGÿÞÿJHÿjNNÿ¶ÿ[Yÿl]_ÿRNQÿ    ¡¢ÿÇÌÎÿ¢ªÿ|ºÿZaÿ*-Bÿ'+3ÿGMVÿMTbÿKR[ÿJQRÿHN[ÿIPaÿHMaÿFKuÿ6;gÿ06gÿ25lÿ-1iÿ-2dÿ7<Zÿ7<Qÿ?FZÿ@GUÿ>EXÿ=CVÿEMVÿ=D[ÿ=EYÿCLRÿ:AEÿ    ¡¢ÿÇÌÎÿªÿ®ÿVZ]ÿ(,-ÿ'**ÿSOQÿbYYÿgTUÿaQQÿeRSÿjSTÿ^PRÿ`NPÿ_IIÿ]FEÿ^IKÿWJKÿOHHÿ[POÿTFHÿ^NMÿ[FDÿWBBÿRBBÿVHHÿ[HIÿcNPÿ]PQÿAAAÿ    ¡£ÿÅËÍÿ¡ª¬ÿ¸ÿ~±ÿck£ÿEKvÿ(*Oÿ "Kÿ Fÿ"#Uÿ*+\ÿ)+Zÿ-/Yÿ24]ÿ35]ÿ9:aÿ8:^ÿ02[ÿ,.Zÿ-/Yÿ*,dÿ(*[ÿ#%Pÿ#&UÿIÿ!#Kÿ$'Lÿ,/Qÿ-ÿ   ÿ    ¡£ÿÅËÍÿ«ÿ½ÿ£ÿlceÿP<<ÿ/ÿ1ÿ%ÿÿ
ÿ'ÿ&ÿÿÿÿÿ"ÿÿ$ÿÿÿÿÿ
ÿÿ
ÿ
	ÿÿÿ    ÿ¾ÄÆÿºÀÂÿ»ÿ½ÿ|¼ÿx¼ÿx¸ÿw³ÿÄÿËÿ~ÂÿÓÿ£Üÿ³¸àÿ»½åÿÏÒíÿÄÆèÿ¯´àÿ­°Þÿ¥ÙÿÓÿÃÿºÿ{¹ÿxµÿz­ÿ«ÿvÿ_gqÿRY\ÿ    ¡ÿ¾ÄÆÿ»¾Àÿµ¤¥ÿ³ÿªÿ§ÿ¶ÿÃÿÚÿÛÿÐÿÕ¢ÿÕ¡ÿÜ¨£ÿà¬©ÿà±¬ÿÜ«©ÿÓ¦¤ÿÃÿ¼ÿ½ÿÆÿÐ©¦ÿÑ£ ÿÎÿÊÿÀÿ®sqÿlmÿyTRÿ    ÿ¨ªÿ¾ÅÆÿ·½Àÿ¯ÿ®ÿ~µÿ³ÿy³ÿ}ºÿy¿ÿ|µÿ|ÀÿÇÿÙÿ¢§Ûÿ°´Üÿ·ºäÿ±¶Ýÿ¡¥×ÿÌÿÂÿ|Äÿ·ÿ|²ÿ{¬ÿvªÿwªÿv¦ÿhqÿ`iÿ    ÿ¨ªÿ¾ÅÆÿ·¼¿ÿ¡¤¥ÿÿ¤ÿÿÿ©ÿ®ÿ§ÿ¦|{ÿ²~}ÿÁÿÏÿÂÿ¾|ÿ¯zxÿ®yxÿ³pnÿ¸nkÿµywÿ»ÿ¾ÿ·ÿ®ÿ©zyÿ§rpÿsrÿjnqÿ    =CE9ÿ¢ª¬ÿÇÍÎÿÄÉËÿÅÌÍÿÂÈÉÿÅËÌÿÂÉÌÿ¿ÅËÿ¾ÅËÿ¼ÂËÿ»ÂÊÿ»ÂËÿºÁÌÿºÁÌÿ»ÂÌÿ¼ÃÌÿ½ÃÍÿ»ÂÍÿ¼ÂÍÿ¼ÃÊÿ½ÄÊÿ½ÅËÿ½ÅËÿ½ÅËÿÁÈËÿÃÊËÿ¿ÄÆÿ°¶¸ÿ¡ÿ    =CE9ÿ¢ª¬ÿÇÍÎÿÄÉËÿÆÉÊÿÄÂÂÿÄÄÅÿÆÍÎÿÄÈÊÿÂÉÊÿÁÇÉÿ¼ÃÃÿÂÉÊÿÀÅÇÿ¾ÅÆÿ¹ÀÂÿ¼¿Áÿ¾¾Áÿ»½¾ÿ¼¼½ÿ½ÁÂÿ¼ÂÃÿ»ÂÃÿÀ¿¿ÿ¼¾¿ÿ¾ÅÇÿ¼ÂÃÿÀÀÂÿ¾ÃÅÿ¡¢ÿ       IQS9ÿ¦§ÿ¡®±ÿÿ¡¥ÿ£¦ÿ¢¤ÿ¤¥ÿ©¬ÿÿ¡£ÿÿ ÿ ÿÿÿÿÿÿÿÿÿÿÿÿ ÿÿÿÿ       IQS9ÿ¦§ÿ¡®±ÿÿ¡¥ÿ£¦ÿ¢¤ÿ¤¥ÿ©¬ÿÿ¡£ÿÿ ÿ ÿÿÿÿÿÿÿÿÿÿÿÿ ÿÿÿÿ        TRUEVISION-XFILE. //////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Chat
//

ConfigureInterface()
{
  CreateColorGroup("Game::ChatText")
  {
    AllBg(255, 255, 255, 0);
    AllFg(220, 220, 170, 255);
  }
}

CreateControl("Client::Chat", "Window")
{
  Style("AdjustWindow", "ModalClose");
  Geometry("HCentre", "Bottom");
  Skin("Game::SolidClient");

  Size(300, 200);
  Pos(0, -90);

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-20, 19);
    Pos(0, -19);
    Text("#client.chat.title");
  }

  CreateControl("Viewer", "ConsoleViewer")
  {
    ReadTemplate("Game::SliderListBox");
    Geometry("HCentre", "ParentHeight", "ParentWidth");
    Size(-10, -35);
    Pos(0, 5);
    WrapAdjust(22);

    Filters()
    {
      Add("GameMessage");
      Add("MultiMessage");
      Add("MultiError");
      Add("ChatMessage");
      Add("ChatQuote");
      Add("ChatPrivate");
      Add("ChatLocal");
      Add("Message");
      Add("Error");
    }

    ItemConfig()
    {
      Font("System");
      Geometry("AutoSizeY", "ParentWidth");
      ColorGroup("Game::ChatText");
    }
    Style("NoSelection", "SmartScroll");
  }

  CreateControl("Edit", "MultiPlayer::ChatEdit")
  {
    Geometry("Bottom");
    Geometry("ParentWidth");
    Pos(87, -5);
    Size(-92, 20);
    Skin("Game::CutInBorder");
    ColorGroup("Game::EditText");
    TextOffset(2, 0);

    CreateVarString("console");
    CreateVarString("type", "broadcast");

    Font("System");
    LinkViewer("<Viewer");

    CmdPrefix("multiplayer.cmd.");
    UseVar("$.console");
    TypeVar("$.type");

    MaxLength(100);

    TranslateEvent("Edit::Notify::Entered", "Window::Message::Close", "<");
    TranslateEvent("Edit::Notify::Escaped", "Window::Message::Close", "<");
  }

  CreateControl("Destination", "DropList")
  {
    ReadRegData("Reg::Game::DropList");

    Geometry("Bottom");
    Pos(5, -5);
    Size(80, 20);

    Height(38);
    UseVar("$<Edit.type");

    ListBox("ListBox")
    {
      Skin("Game::SolidClientListBox");
      Style("!VSlider");
      ItemConfig()
      {
        Font("System");
        ColorGroup("Game::ListEntry");
        Geometry("AutoSizeY", "ParentWidth");
      }
      AddTextItem("broadcast", "#multiplayer.chat.type.all");
      AddTextItem("allies", "#multiplayer.chat.type.ally");
    }
  }

  OnEvent("Window::Notify::Activated")
  {
    Op("$Edit.console", "=", "");
    SetFocus("Edit");
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

CreateControl("Client::Code", "Window")
{
  Skin("Game::SolidClient");
  Size(300, 80);
  Geometry("HCentre", "VCentre");
  Style("Transparent", "ModalClose");

  CreateVarString("code");

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-10, 19);
    Pos(0, -19);
    Text("#client.code.title");
  }

  CreateControl("Edit", "Edit")
  {
    ColorGroup("Game::EditText");
    Skin("Game::CutInBorder");
    Pos(0, 15);
    Size(-20, 24);
    Geometry("HCentre", "ParentWidth");
    Font("System");
    UseVar("$<.code");
    NotifyParent("Edit::Notify::Entered", "Trigger");
    NotifyParent("Edit::Notify::Escaped", "Cancel");
  }

  CreateControl("OK", "Button")
  {
    ReadTemplate("Game::Button");
    Size(75, 25);
    Pos(10, -10);
    Geometry("Bottom", "Left");
    Font("HeaderSmall");
    Text("#std.buttons.ok");

    NotifyParent("Button::Notify::Pressed", "Trigger");
  }

  CreateControl("Cancel", "Button")
  {
    Geometry("Bottom", "Right");
    ReadTemplate("Game::Button");
    Size(75, 25);
    Pos(-10, -10);
    Font("HeaderSmall");
    Text("#std.buttons.cancel");

    NotifyParent("Button::Notify::Pressed", "Cancel");
  }

  OnEvent("Trigger")
  {
    IFaceCmd("client.triggercode", "$code");
    Deactivate();
  }

  OnEvent("Cancel")
  {
    DeactivateScroll("", "Right", 0.2);
  }

  OnEvent("Window::Notify::Activated")
  {
    Op("$.code", "=", "");
    SetFocus("Edit");
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Common colour groups

ConfigureInterface()
{
  CreateColorGroup("Client::HeaderText", "Sys::Texture")
  {
    AllFg(255, 255, 255, 255);
    AllBg(255, 255, 255, 255);
    DisabledFg(255, 255, 255, 100);
  }

  CreateColorGroup("Plastic", "Sys::Texture")
  {
    AllFg(255, 255, 130, 255);
    DisabledFg(255, 255, 170, 100);
  }

  CreateColorGroup("Electricity", "Sys::Texture")
  {
    AllFg(130, 130, 255, 255);
    DisabledFg(170, 170, 255, 0);
  }
}
//////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Comms
//

ConfigureInterface()
{
  CreateColorGroup("Client::PlayerColor", "Sys::Texture")
  {
    AllTextures("if_Interfacealpha_game.tga", 2, 101, 7, 7);
  }

  CreateColorGroup("Client::PlayerSlot", "Sys::Texture")
  {
    NormalBg(255, 255, 255, 0);
    HilitedBg(255, 255, 0, 32);
    SelectedBg(255, 255, 0, 64);
    HilitedSelBg(255, 255, 0, 96);
    DisabledBg(255, 255, 255, 0);
    NormalFg(220, 220, 170, 255);
    HilitedFg(255, 255, 220, 255);
    SelectedFg(255, 255, 220, 255);
    DisabledFg(220, 220, 170, 180);
    HilitedSelFg(255, 255, 220, 255);
  }

  CreateColorGroup("Client::Comms::Ally")
  {
    AllBg(255, 255, 255, 255);
  }

  CreateColorGroup("Client::Comms::Enemy")
  {
    AllBg(255, 255, 255, 255);
  }

  CreateColorGroup("Client::DisableAlpha")
  {
    AllBg(255, 255, 255, 200);
  }

  DefineControlType("Client::Comms::Players::Slot", "MultiPlayer::Players::Slot")
  {
    Align("^");
    Geometry("HInternal", "Bottom");
    Style("Transparent");
    Size(180, 26);

    CreateControl("SlotColorBkgnd", "Static")
    {
      ColorGroup("Sys::Texture");
      Size(21, 21);
      Pos(4, -2);
      Geometry("Bottom");
      Image("if_Interface_game.tga", 67, 115, 21, 21);
    }

    CreateControl("SlotColor", "MultiPlayer::Players::SlotColor")
    {
      Size(7, 7);
      Pos(11, -9);
      Geometry("Bottom");
      ColorGroup("Client::PlayerColor");
    }

    CreateControl("SlotColorHilite", "Static")
    {
      Size(7, 7);
      Pos(11, -9);
      Geometry("Bottom");
      Image("if_Interfacealpha_game.tga", 10, 101, 7, 7);
      ColorGroup("Sys::Texture");
    }

    CreateControl("Name", "Static")
    {
      CreateControl("NameBorder", "Static")
      {
        ColorGroup("Sys::Texture");
        Geometry("ParentWidth", "ParentHeight");
        Skin("Game::Panel");
        Style("Transparent");
      }
      ColorGroup("Client::PlayerSlot");
      Style("!Inert");
      JustifyText("Left");
      Geometry("Bottom");
      TextOffset(3, 0);
      Size(125, 22);
      Pos(26, -1);
      Font("System");

      TranslateEvent("Event::Press1", "MultiPlayer::Players::Slot::Message::Select", "<");
    }

    CreateControl("DisableBkgnd", "Static")
    {
      ColorGroup("Client::DisableAlpha");
      Size(-2, 0);
      Pos(1, 0);
      Image()
      {
        Image("if_InterfaceAlpha_game.tga", 7, 32, 6, 6);
        Mode("Stretch");
        Filter(0);
      }
      Geometry("ParentWidth", "ParentHeight");
    }

    CreateControl("SeparatorBase", "Static")
    {
      ColorGroup("Sys::Texture");
      Image("if_Interfacealpha_game.tga", 27, 18, 12, 2);
      Geometry("ParentWidth", "Top");
      Size(-5, 2);
      Pos(2, 0);
    }

    CreateControl("SeparatorBaseBottom", "Static")
    {
      ColorGroup("Sys::Texture");
      Image("if_Interfacealpha_game.tga", 27, 21, 12, 1);
      Geometry("ParentWidth", "Bottom");
      Size(-5, 1);
      Pos(2, 0);
    }

    CreateControl("Separator", "Static")
    {
      ColorGroup("Sys::Texture");
      Image("if_Interface_game.tga", 23, 67, 21, 3);
      Geometry("ParentWidth");
      Size(-8, 3);
      Pos(4, -1);
      CreateControl("SeparatorLEnd", "Static")
      {
        ColorGroup("Sys::Texture");
        Image("if_Interface_game.tga", 20, 67, 2, 3);
        Geometry("Left");
        Size(2, 3);
        Pos(-2, 0);
      }
      CreateControl("SeparatorLEnd", "Static")
      {
        ColorGroup("Sys::Texture");
        Image("if_Interface_game.tga", 45, 67, 2, 3);
        Geometry("Right");
        Size(2, 3);
        Pos(2, 0);
      }
    }

    CreateControl("Relation::Ally", "Static")
    {
      Image("if_interface_game.tga", 67, 93, 22, 22);
      ColorGroup("Client::Comms::Ally");
      Geometry("Right", "VCentre");
      Pos(-5, 1);
      Size(22, 22);
    }

    CreateControl("Relation::Enemy", "Static")
    {
      Image("if_interface_game.tga", 89, 93, 22, 22);
      ColorGroup("Client::Comms::Enemy");
      Geometry("Right", "VCentre");
      Pos(-5, 1);
      Size(22, 22);
    }

    // The slot is being used by a player
    OnEvent("MultiPlayer::Players::Notify::Slot::On")
    {
      Deactivate("DisableBkgnd");
      Activate("SlotColorBkgnd");
      Activate("SlotColor");
      Activate("SlotColorHilite");
      Activate("Name");
    }

    // No player in this slot
    OnEvent("MultiPlayer::Players::Notify::Slot::Off")
    {
      Deactivate("SlotColorBkgnd");
      Deactivate("SlotColor");
      Deactivate("SlotColorHilite");
      Deactivate("Name");
      Deactivate("Separator");
      Activate("DisableBkgnd");
      Deactivate("Relation::Ally");
      Deactivate("Relation::Enemy");
      Disable();
    }

    // Turn the group separator on / off
    OnEvent("Multiplayer::Players::Notify::Separator::On")
    {
      Activate("Separator");
      Select("Separator");
    }

    OnEvent("Multiplayer::Players::Notify::Separator::Off")
    {
      Deactivate("Separator");
    }

    // Slot is selected
    OnEvent("Multiplayer::Players::Notify::Selected::On")
    {
      Select("Name");
    }

    // Slot is deslected
    OnEvent("Multiplayer::Players::Notify::Selected::Off")
    {
      Deselect("Name");
    }

    // Slot is selectable
    OnEvent("Multiplayer::Players::Notify::Selectable::On")
    {
      Enable("Name");
    }

    // Slot is not selectable
    OnEvent("Multiplayer::Players::Notify::Selectable::Off")
    {
      Disable("Name");
    }

    // Slot is an ally
    OnEvent("Multiplayer::Players::Notify::LocalGroup::On")
    {
      Activate("Relation::Ally");
      Deactivate("Relation::Enemy");
    }

    // Slot is an enemy
    OnEvent("Multiplayer::Players::Notify::LocalGroup::Off")
    {
      Deactivate("Relation::Ally");
      Activate("Relation::Enemy");
    }
  }
}

CreateControl("Client::Comms", "Client::Comms")
{
  Size(315, 260);
  Geometry("VCentre", "HCentre");
  Style("AdjustWindow");
  Skin("Game::SolidClient");

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-10, 19);
    Pos(0, -19);
    Text("#client.comms.title");
  }

  CreateControl("PlayerSlotsBkgnd", "Static")
  {
    Size(180, 209);
    Pos(10, 10);
    Skin("Game::CutInBorder");
    Style("Transparent");
  }

  //
  // Player slots
  //
  CreateControl("Players", "Multiplayer::Players")
  {
    Size(180, 208);
    Pos(10, 10);
    Style("Transparent");

    Behavior("Game");

    CreateControl("Alignment", "Static")
    {
      Style("Transparent");
    }

    CreateControl("Slot0", "Client::Comms::Players::Slot") { }
    CreateControl("Slot1", "Client::Comms::Players::Slot") { }
    CreateControl("Slot2", "Client::Comms::Players::Slot") { }
    CreateControl("Slot3", "Client::Comms::Players::Slot") { }
    CreateControl("Slot4", "Client::Comms::Players::Slot") { }
    CreateControl("Slot5", "Client::Comms::Players::Slot") { }
    CreateControl("Slot6", "Client::Comms::Players::Slot") { }
    CreateControl("Slot7", "Client::Comms::Players::Slot") { }
  }

  CreateControl("Title", "Static")
  {
    CreateVarString("text");
    Style("Transparent");
    Skin("Game::Panel");
    ColorGroup("Game::HeaderText");
    Geometry("Right");
    Size(110, 22);
    Pos(-10, 10);
    JustifyText("Centre");
    Font("System");
    UseVar("$.text");
  }

  CreateControl("Options", "Static")
  {
    Geometry("Right");
    Size(110, 183);
    Pos(-10, 35);
    Style("Transparent");
    Skin("Game::Panel");

    CreateVarInteger("p", 1000);
    CreateVarInteger("e", 1000);

    CreateControl("Plastic", "Game::Button")
    {
      Pos(5, 5);
      Size(100, 25);
      Font("System");
      Text("#game.resources.plastic");

      OnEvent("Button::Notify::Pressed")
      {
        Notify("<<", "Client::Comms::Message::GiveResource", "Plastic", "*$<.p");
      }
    }

    CreateControl("PlasticEdit", "Edit")
    {
      Skin("Game::CutInBorder");
      ColorGroup("Game::EditText");
      Align("<Plastic");
      Geometry("Bottom", "HInternal");
      Size(80, 25);
      JustifyText("Left");
      TextOffset(2, 0);
      Pos(10, 3);
      Font("System");
      UseVar("$<.p");
      Style("IntegerFilter");
    }

    CreateControl("PlasticOff", "Static")
    {
      Skin("Game::CutInBorder");
      ColorGroup("Game::EditText");
      Align("<Plastic");
      Geometry("Bottom", "HInternal");
      Style("Transparent");
      Size(80, 25);
      Pos(10, 3);
    }

    CreateControl("Electricity", "Game::Button")
    {
      Size(100, 25);
      Pos(5, 65);
      Font("System");
      Text("#game.resources.electricity");

      OnEvent("Button::Notify::Pressed")
      {
        Notify("<<", "Client::Comms::Message::GiveResource", "Electricity", "*$<.e");
      }
    }

    CreateControl("ElectricityEdit", "Edit")
    {
      Skin("Game::CutInBorder");
      ColorGroup("Game::EditText");
      Align("<Electricity");
      Geometry("Bottom", "HInternal");
      Size(80, 25);
      Pos(10, 3);
      JustifyText("Left");
      TextOffset(2, 0);
      Font("System");
      UseVar("$<.e");
      Style("IntegerFilter");
    }

    CreateControl("ElectricityOff", "Static")
    {
      Skin("Game::CutInBorder");
      ColorGroup("Game::EditText");
      Align("<Electricity");
      Geometry("Bottom", "HInternal");
      Style("Transparent");
      Size(80, 25);
      Pos(10, 3);
    }

    CreateControl("Units", "Game::Button")
    {
      Size(100, 25);
      Pos(5, 125);
      Text("#client.comms.units");
      Font("System");

      TranslateEvent("Button::Notify::Pressed", "Client::Comms::Message::GiveUnits", "<<");
    }

    CreateControl("UnitCount", "Static")
    {
      Align("<Units");
      Skin("Game::CutInBorder");
      Style("Transparent");
      ColorGroup("Game::Text");
      Geometry("Bottom", "HInternal");
      JustifyText("Centre");
      Size(80, 25);
      Pos(10, 3);
      Font("System");
      UseVar("$<<.unitCount");
    }

    CreateControl("UnitOff", "Static")
    {
      Skin("Game::CutInBorder");
      ColorGroup("Game::EditText");
      Align("<Units");
      Geometry("Bottom", "HInternal");
      Style("Transparent");
      Size(80, 25);
      Pos(10, 3);
    }

  }

  CreateControl("Done", "Game::Button")
  {
    Size(80, 25);
    Geometry("Bottom", "HCentre");
    Pos(0, -10);
    Text("#std.buttons.done");
    Font("System");

    OnEvent("Button::Notify::Pressed")
    {
      Deactivate("<");
    }
  }

  // Is a valid player selected
  OnEvent("Client::Comms::Notify::Selected::On")
  {
    Op("$Title.text", "=", "#client.comms.selectedon");
  }

  OnEvent("Client::Comms::Notify::Selected::Off")
  {
    Op("$Title.text", "=", "#client.comms.selectedoff");
  }

  // Is plastic available
  OnEvent("Client::Comms::Notify::Plastic::On")
  {
    Enable("Options.Plastic");
    Activate("Options.PlasticEdit");
    Deactivate("Options.PlasticOff");
  }

  OnEvent("Client::Comms::Notify::Plastic::Off")
  {
    Disable("Options.Plastic");
    Deactivate("Options.PlasticEdit");
    Activate("Options.PlasticOff");
    Disable("Options.PlasticOff");
  }

  // Is electricity available
  OnEvent("Client::Comms::Notify::Electricity::On")
  {
    Enable("Options.Electricity");
    Activate("Options.ElectricityEdit");
    Deactivate("Options.ElectricityOff");
  }

  OnEvent("Client::Comms::Notify::Electricity::Off")
  {
    Disable("Options.Electricity");
    Deactivate("Options.ElectricityEdit");
    Activate("Options.ElectricityOff");
    Disable("Options.ElectricityOff");
  }

  // Are any units selected
  OnEvent("Client::Comms::Notify::Units::On")
  {
    Enable("Options.Units");
    Activate("Options.UnitCount");
    Deactivate("Options.UnitOff");
  }

  OnEvent("Client::Comms::Notify::Units::Off")
  {
    Disable("Options.Units");
    Deactivate("Options.UnitCount");
    Activate("Options.UnitOff");
    Disable("Options.UnitOff");
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Construction Window

ConfigureInterface()
{
  CreateColorGroup("Client::ConstructionIcon", "Sys::Texture")
  {
    SelectedTexture("if_InterfaceAlpha_game.tga", 0, 52, 47, 47);
    HilitedSelTexture("if_InterfaceAlpha_game.tga", 47, 52, 47, 47);
    NormalTexture("if_InterfaceAlpha_game.tga", 0, 52, 47, 47);
    HilitedTexture("if_InterfaceAlpha_game.tga", 47, 52, 47, 47);
    NormalBg(255, 255, 255, 255);
  }
}

CreateControl("Client::Construction", "Client::Construction")
{
  Size(55, 383);
  Pos(0, -59);

  Geometry("Bottom");
  ColorGroup("Sys::Texture");

  Skin("Game::SolidClient");

  GridSize(1, 8);
  GridStart(4, 4);
  IconSize(47, 47);
  IconSpacing(0, 0);
  TextureBlank("if_Interface_game.tga", 209, 0, 47, 47);

  IconConfig()
  {
    ColorGroup("Client::ConstructionIcon");
    PointQueue(33, 2);
    PointCost(-4, 2);
    AreaProgress()
    {
      Point1(8, 33);
      Point2(39, 39);
    }
    AreaColoring()
    {
      Point1(2, 2);
      Point2(45, 45);
    }
    ColorDisabled(255, 0, 0);
    ColorHighlighted(255, 255, 0);
    ColorLimited(0, 0, 255);
    ColorProgressLayer1(0, 0, 32, 180);
    ColorProgressLayer2(0, 121, 192, 204);
    HoldDelayActivate(600);
    HoldDelayRepeat(25); // Default is 200.
    QueueAddition(1);

    CreateControl("BuildQueue", "Static")
    {
      Geometry("Right");
      Style("Transparent", "HideZero");
      Size(16, 8);
      Pos(-7, 4);
      Font("HeaderSmall");
      JustifyText("Right");
      ColorGroup("Game::HeaderText");
      UseVar("$<.queue");
    }
  }

  // Reset everything to default states
  OnEvent("Client::Construction::Notify::Reset")
  {
    Activate("|Client::UnitDisplay.MeshView.Disable");
    Disable("|Client::UnitDisplay.UpgradeText");
    Enable("|Client::UnitDisplay.PreReqName");
    Enable("|Client::UnitDisplay.PreReqBorder");
  }

  // We have all prereqs for the selected icon
  OnEvent("Client::Construction::Notify::Icon::Prereqs")
  {
    Deactivate("|Client::UnitDisplay.MeshView.Disable");
    Enable("|Client::UnitDisplay.UpgradeText");
    Disable("|Client::UnitDisplay.PreReqName");
    Disable("|Client::UnitDisplay.PreReqBorder");
  }

  OnEvent("Control::ActivateHook")
  {
    ActivateScroll("", "Left", 0.2);
    Sound("Custom::Scroll::In");
  }

  OnEvent("Control::DeactivateHook")
  {
    DeactivateScroll("", "Left", 0.2);
    Sound("Custom::Scroll::Out");
  }

}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Event Help Display
//

#include "if_game_event_hook.cfg"

CreateControl("Client::Event", "Client::Event::Hook")
{
  Size(300, 30);
  Geometry("HCentre");
  Style("Transparent");
  ColorGroup("Game::Text");
  Font("System");
  UseVar("$.message");
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Facility Bar

ConfigureInterface()
{
  CreateColorGroup("Client::FacilityButton::FacilityUpArrow", "Sys::Texture")
  {
    NormalTexture("if_Interface_game.tga", 179, 0, 29, 21);
    HilitedTexture("if_Interface_game.tga", 179, 22, 29, 21);
    SelectedTexture("if_Interface_game.tga", 179, 44, 29, 21);
    HilitedSelTexture("if_Interface_game.tga", 179, 44, 29, 21);
  }

  CreateColorGroup("Client::FacilityButton::FacilityDownArrow", "Sys::Texture")
  {
    NormalTexture("if_Interface_game.tga", 179, 66, 29, 20);
    HilitedTexture("if_Interface_game.tga", 179, 87, 29, 20);
    SelectedTexture("if_Interface_game.tga", 179, 108, 29, 20);
    HilitedSelTexture("if_Interface_game.tga", 179, 108, 29, 20);
  }
  CreateColorGroup("Facility::Default", "Sys::Texture")
  {
    NormalTexture("if_InterfaceAlpha_game.tga", 0, 52, 47, 47);
    HilitedTexture("if_InterfaceAlpha_game.tga", 47, 52, 47, 47);
    SelectedTexture("if_InterfaceAlpha_game.tga", 47, 52, 47, 47);
    HilitedSelTexture("if_InterfaceAlpha_game.tga", 47, 52, 47, 47);
    DisabledTexture("if_InterfaceAlpha_game.tga", 0, 52, 47, 47);
    DisabledBg(255, 255, 255, 255);
  }
}

CreateControl("Client::Facility", "Client::Facility")
{
  Geometry("Bottom");
  Size(272, 55);
  Style("Transparent");
  Skin("Game::SolidClient");

  GridSize(5, 1);
  GridStart(4, 4);
  IconSize(47, 47);
  IconSpacing(0, 0);
  TextureBlank("if_Interface_game.tga", 209, 0, 47, 47);

  IconConfig()
  {
    ColorGroup("Facility::Default");
    PointCount(33, 2);
    AreaProgress()
    {
      Point1(4, 36);
      Point2(43, 40);
    }
    BarAlphas(0.4, 0.8);
    ColorHighlighted(255, 255, 0);

    CreateControl("FacilityQueue", "Static")
    {
      Geometry("Bottom", "HCentre");
      Style("Transparent", "HideZero");
      Size(16, 8);
      Pos(0, -17);
      Font("HeaderSmall");
      JustifyText("Centre");
      ColorGroup("Game::Text");
      UseVar("$<.count");
    }
  }

  CreateControl("Inc", "Button")
  {
    Geometry("Right");
    Style("!DropShadow", "!VGradient", "SelectWhenDown");
    Size(29, 20);
    ColorGroup("Client::FacilityButton::FacilityDownArrow");
    TranslateEvent("Button::Notify::Pressed", "IconWindow::Message::IncPos", "<");
    Pos(-4, 28);
  }

  CreateControl("Dec", "Button")
  {
    Geometry("Right");
    Style("!DropShadow", "!VGradient", "SelectWhenDown");
    Size(29, 21);
    Pos(-4, 4);
    ColorGroup("Client::FacilityButton::FacilityUpArrow");
    TranslateEvent("Button::Notify::Pressed", "IconWindow::Message::DecPos", "<");
  }

  CreateControl("FacilityTitle", "Static")
  {
    Skin("Game::HeaderConstruction");
    Geometry("HCentre", "Top");
    Size(140, 19);
    Pos(-4, -19);
    Font("HeaderSmall");
    ColorGroup("Game::HeaderTextAlpha");
    Style("Transparent");
    Text("#client.facility.title");
    TextOffset(5, 2);
  }

  CreateControl("ConstructionMenuImage", "Static")
  {
    Size(60, 20);
    Pos(0, -20);
    ColorGroup("Sys::Texture");
    Image("if_interface_game.tga", 1, 137, 60, 20);
  }

  CreateControl("ConstructionTextImage", "Static")
  {
    Size(14, 20);
    Pos(60, -20);
    ColorGroup("Sys::Texture");
    Image("if_interfacealpha_game.tga", 96, 2, 14, 20);
  }
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// HUD

ConfigureInterface()
{

  //
  // Selection box color group
  //
  CreateColorGroup("Client::SelectionBox")
  {
    NormalBg(255, 255, 255, 128);
  }

  //
  // Selection box skin
  //
  CreateSkin("Client::SelectionBox")
  {
    State("All")
    {
      ColorGroup("Client::SelectionBox");

      TopLeft()     { Image("if_Interface_1.tga", 141, 0, 5, 5); }
      Top()         { Image("if_Interface_1.tga", 147, 0, 1, 4); }
      TopRight()    { Image("if_Interface_1.tga", 149, 0, 4, 4); }
      Left()        { Image("if_Interface_1.tga", 141, 6, 4, 1); }
      Right()       { Image("if_Interface_1.tga", 149, 6, 4, 1); }
      BottomLeft()  { Image("if_Interface_1.tga", 141, 8, 4, 4); }
      Bottom()      { Image("if_Interface_1.tga", 145, 8, 1, 4); }
      BottomRight() { Image("if_Interface_1.tga", 148, 7, 5, 5); }
      Interior()
      {
        Image("if_InterfaceAlpha_1.tga", 7, 18, 4, 4);
        Mode("Stretch");
      }
    }
  }
}

ConfigureHUD()
{
  // Selection skin
  SelectionSkin("Client::SelectionBox");

  // Status icons
  ConfigureStatusIcons()
  {
    Add("NetworkLag")
    {
      Image("if_Interface_game.tga", 112, 82, 37, 37);
      Color(255, 255, 255, 255);
      Pos()
      {
        Size(37, 37);
        Pos(50, 0);
        Align("Top", "HCentre");
      }
    }
  }

  // Global reticle setup
  FadeTime(400);

  // HUD Fadeout configuration
  FarFadeDist(100);
  FarFadeAlpha(0%);

  // Color entries
  ConfigureColorEntries()
  {
    // A facility constructing a unit
    Add("Tasks::UnitConstructor", 0, 121, 192);

    // An object is under construction
    Add("Tasks::UnitConstruct", 0, 121, 192);

    // An object is being upgraded
    Add("Tasks::UnitUpgrade", 0, 121, 192);

    // An object is being recycled
    Add("Tasks::UnitRecycle", 0, 121, 192);

    // Display of a transporters cargo
    Add("Transport::Cargo::Full", 0, 0, 255);
    Add("Transport::Cargo::Empty", 0, 0, 0);

    // Display of a units ammunition
    Add("Unit::Ammunition", 255, 255, 0);

    // The resources
    Add("Plastic", 255, 255, 120);
    Add("Electricity", 120, 120, 255);
  }

  // Squad id
  ConfigureTextItem("text.squad.small")
  {
    Font("HeaderSmall");
    Color(200, 255, 200, 180);
    Position()
    {
      Align("Bottom", "HCentre");
      Pos(0, -15);
    }
  }

  ConfigureTextItem("text.squad.large")
  {
    Font("HeaderSmall");
    Color(200, 255, 200, 180);
    Position()
    {
      Align("Bottom", "HCentre");
      Pos(0, -15);
    }
  }

  // Unit name
  ConfigureTextItem("text.unit.small")
  {
    Font("HeaderSmall");
    Color(255, 255, 255, 200);
    Position()
    {
      Align("Bottom", "HCentre");
      Pos(0, 8);
    }
  }

  ConfigureTextItem("text.unit.large")
  {
    Font("HeaderSmall");
    Color(255, 255, 255, 255);
    Position()
    {
      Align("Bottom", "HCentre");
      Pos(0, 8);
    }
  }

  ConfigureTextItem("text.info")
  {
    Font("HeaderSmall");
    Color(200, 200, 255, 255);
    Position()
    {
      Align("Bottom", "HCentre");
      Pos(0, -22);
    }
  }

  // Default small reticle

  ConfigureReticle("default.small")
  {
    // Corner pieces
//    Corner1() { Image("if_InterfaceAlpha_1.tga", 97, 23, 12, 12); }
//    Corner2() { Image("if_InterfaceAlpha_1.tga", 113, 23, 12, 12); }
//    Corner3() { Image("if_InterfaceAlpha_1.tga", 97, 38, 12, 12); }
//    Corner4() { Image("if_InterfaceAlpha_1.tga", 113, 38, 12, 12); }

    // Corner Offset

 //   CornerOfs1(1, 1);
 //   CornerOfs2(-1, 1);
 //   CornerOfs3(-2, 7);
 //   CornerOfs4(3, 7);

    // Bar graphics
    Bar()
    {
      Background() { Image("if_InterfaceAlpha_1.tga", 103, 104, 12, 4); }
      Foreground() { Image("if_InterfaceAlpha_1.tga", 89, 112, 39, 2); }
      Color(255, 255, 255, 100);
      FgOffsetTL(1, 1);
      FgOffsetBR(-1, -1);
    }

    // Health bar
    HealthBarPosition()
    {
      Align("Bottom", "Width", "HCentre");
      Pos(0, 6);
      Size(-9, 0);
    }

    // Generic task progress bar
    TaskBarPosition()
    {
        Align("Bottom", "Width", "HCentre");
        Pos(0, 0);
        Size(-15, 0);
    }

    // Ammunition bar
    AmmoBarPosition()
    {
      Align("Top", "Width", "HInternal", "HCentre");
      Pos(0, -10);
    }

    // Cargo bar
    CargoBarPosition()
    {
      Align("Top", "Width", "HInternal", "HCentre");
      Pos(0, -1);
    }

    // Resource configuration
    Resources()
    {
      Add("Plastic")
      {
      Align("Bottom", "Width", "HCentre");
      Pos(0, 0);
      Size(-15, 0);
      }
      Add("Electricity")
      {
        Align("Bottom", "Width", "HCentre");
        Pos(0, 0);
        Size(-15, 0);
      }
    }

    MinSize(20, 20);
    Color(255, 255, 255, 128);
  }

  // Selected Small reticle

  ConfigureReticle("select.small")
  {
    // Corner pieces
 //   Corner1() { Image("if_InterfaceAlpha_1.tga", 97, 23, 12, 12); }
 //   Corner2() { Image("if_InterfaceAlpha_1.tga", 113, 23, 12, 12); }
    Corner3() { Image("if_InterfaceAlpha_1.tga", 54, 103, 5, 7); }
    Corner4() { Image("if_InterfaceAlpha_1.tga", 60, 103, 5, 7); }

    // Corner Offset

 //   CornerOfs1(1, 1);
 //   CornerOfs2(-1, 1);
    CornerOfs3(4, 6);
    CornerOfs4(-4, 6);

    // Bar graphics

    Bar()
    {
      Background() { Image("if_InterfaceAlpha_1.tga", 103, 104, 12, 4); }
      Foreground() { Image("if_InterfaceAlpha_1.tga", 89, 112, 39, 2); }
      Color(255, 255, 255, 255);
      FgOffsetTL(1, 1);
      FgOffsetBR(-1, -1);
    }

    // Health bar
    HealthBarPosition()
    {
      Align("Bottom", "Width", "HCentre");
      Pos(0, 2);
      Size(-16, 0);
    }

    // Generic task progress bar
    TaskBarPosition()
    {
      Align("Bottom", "Width", "HCentre");
      Pos(0, -4);
      Size(-18, 0);
    }

    // Ammunition bar
    AmmoBarPosition()
    {
      Align("Top", "Width", "HInternal", "HCentre");
      Pos(0, -1);
    }

    // Cargo bar
    CargoBarPosition()
    {
      Align("Top", "Width", "HInternal", "HCentre");
      Pos(0, -1);
    }

    // Resource configuration
    Resources()
    {
      Add("Plastic")
      {
        Align("Bottom", "Width", "HCentre");
        Pos(0, -4);
        Size(-24, 0);
      }
      Add("Electricity")
      {
        Align("Bottom", "Width", "HCentre");
        Pos(0, -4);
        Size(-24, 0);
      }
    }

    MinSize(20, 20);
    Color(255, 255, 255, 255);
  }

  // Large self reticle

  ConfigureReticle("default.large")
  {
    // Corner pieces
 //   Corner1() { Image("if_InterfaceAlpha_1.tga", 52, 99, 7, 7); }
 //   Corner2() { Image("if_InterfaceAlpha_1.tga", 59, 99, 7, 7); }
 //   Corner3() { Image("if_InterfaceAlpha_1.tga", 36, 99, 7, 7); }
 //   Corner4() { Image("if_InterfaceAlpha_1.tga", 43, 99, 8, 7); }

    // Corner Offset

 //   CornerOfs1(1, 1);
 //   CornerOfs2(-1, 1);
 //   CornerOfs3(-2, 7);
 //   CornerOfs4(3, 7);

    // Bar graphics
    Bar()
    {
      Background() { Image("if_InterfaceAlpha_1.tga", 103, 103, 12, 5); }
      Foreground() { Image("if_InterfaceAlpha_1.tga", 89, 112, 39, 2); }
      Color(255, 255, 255, 128);
      FgOffsetTL(1, 1);
      FgOffsetBR(-1, -1);
    }

    // Health bar
    HealthBarPosition()
    {
      Align("Bottom", "Width", "HCentre");
      Pos(0, 5);
      Size(-9, 0);
    }

    // Task Bar
    TaskBarPosition()
    {
      Align("Bottom", "HCentre", "Width");
      Pos(0, -7);
      Size(-35, 0);
    }

    // Ammunition bar
    AmmoBarPosition()
    {
      Align("Top", "Width", "HInternal", "HCentre");
      Pos(0, -1);
    }

    // Cargo bar
    CargoBarPosition()
    {
      Align("Top", "Width", "HInternal", "HCentre");
      Pos(0, -1);
    }

    // Resource configuration
    Resources()
    {
      Add("Plastic")
      {
        Align("Bottom", "Width", "HCentre");
        Pos(0, 0);
        Size(-10, 0);
      }
      Add("Electricity")
      {
        Align("Bottom", "Width", "HCentre");
        Pos(0, 0);
        Size(-10, 0);
      }
    }

    MinSize(32, 32);
    Color(255, 255, 255, 255);
  }

  ConfigureReticle("selectret.large")
  {
    // Corner pieces
 //   Corner1() { Image("if_InterfaceAlpha_1.tga", 96, 19, 16, 16); }
 //   Corner2() { Image("if_InterfaceAlpha_1.tga", 112, 19, 16, 16); }
    Corner3() { Image("if_InterfaceAlpha_1.tga", 34, 111, 16, 17); }
    Corner4() { Image("if_InterfaceAlpha_1.tga", 50, 111, 16, 17); }

    // Corner Offset

    CornerOfs1(10, 60);
    CornerOfs2(-10, 60);
    CornerOfs3(0, 7);
    CornerOfs4(0, 7);

    // Bar graphics
    Bar()
    {
      Background() { Image("if_InterfaceAlpha_1.tga", 90, 103, 11, 5); }
      Foreground() { Image("if_InterfaceAlpha_1.tga", 89, 112, 39, 2); }
      Color(255, 255, 255, 128);
      FgOffsetTL(1, 1);
      FgOffsetBR(-1, -1);
    }

    // Health bar
    HealthBarPosition()
    {
      Align("Bottom", "Width", "HCentre");
      Pos(0, 1);
      Size(-23, 0);
    }

    // Task Bar
    TaskBarPosition()
    {
      Align("Bottom", "HCentre", "Width");
      Pos(0, -7);
      Size(-35, 0);
    }

    // Ammunition bar
    AmmoBarPosition()
    {
      Align("Top", "Width", "HInternal", "HCentre");
      Pos(0, -1);
    }

    // Cargo bar
    CargoBarPosition()
    {
      Align("Top", "Width", "HInternal", "HCentre");
      Pos(0, -1);
    }

    // Resource configuration
    Resources()
    {
      Add("Plastic")
      {
        Align("Bottom", "Width", "HCentre");
        Pos(0, 0);
        Size(-10, 0);
      }
      Add("Electricity")
      {
        Align("Bottom", "Width", "HCentre");
        Pos(0, 0);
        Size(-10, 0);
      }
    }

    MinSize(32, 32);
    Color(255, 255, 255, 255);
  }

  // Self reticles
  ConfigureReticle("self.small", "default.small")
  {
    Color(255, 255, 255, 200);
  }

  ConfigureReticle("default.vehicle", "default.small")
  {
    Color(255, 255, 255, 200);
  }

  ConfigureReticle("self.large", "default.large")
  {
    Color(255, 255, 255, 200);
  }

  // Selected reticles
  ConfigureReticle("selected.small", "select.small")
  {
    Color(255, 255, 255, 255);
  }

  ConfigureReticle("selected.large", "selectret.large")
  {
    Color(255, 255, 255, 255);
  }

  // Selected reticles
  ConfigureReticle("select.vehicle", "select.small")
  {
    Color(255, 255, 255, 255);
  }

  // Enemy reticles
  ConfigureReticle("enemy.small", "selected.small")
  {
    Color(255, 0, 0, 255);
  }

  ConfigureReticle("enemy.large", "selected.large")
  {
    Color(255, 0, 0, 255);
  }

  ConfigureReticle("enemy.vehicle", "select.small")
  {
    Color(255, 0, 0, 255);
  }

  // Neutral reticles
  ConfigureReticle("neutral.small", "default.small")
  {
    Color(255, 255, 255, 255);
  }

  ConfigureReticle("neutral.large", "default.large")
  {
    Color(255, 255, 255, 255);
  }

  ConfigureReticle("neutral.vehicle", "select.small")
  {
    Color(255, 255, 255, 255);
  }

  // Ally reticles
  ConfigureReticle("ally.small", "default.small")
  {
    Color(0, 255, 0, 255);
  }

  ConfigureReticle("ally.large", "default.large")
  {
    Color(0, 255, 0, 255);
  }

  ConfigureReticle("ally.vehicle", "select.small")
  {
    Color(0, 255, 0, 255);
  }

  // Team mate reticles
  ConfigureReticle("teammate.small", "default.small")
  {
    Color(0, 128, 255, 255);
  }

  ConfigureReticle("teammate.large", "default.large")
  {
    Color(0, 128, 255, 255);
  }

  ConfigureReticle("teammate.vehicle", "select.small")
  {
    Color(0, 128, 255, 255);
  }

  // Development
  ConfigureTextItem("text.development.id")
  {
    Font("System");
    Position()
    {
      Align("Top", "Left");
      Pos(0, 12);
    }
  }
  ConfigureTextItem("text.development.teamname")
  {
    Font("System");
    Position()
    {
      Align("Top", "Left");
      Pos(0, 24);
    }
  }
  ConfigureTextItem("text.development.task")
  {
    Font("System");
    Position()
    {
      Align("Top", "Left");
      Pos(0, 36);
    }
  }

  // Reticle profiles
  CreateReticleProfile("Small")
  {
    Self("self.small");
    Selected("selected.small");
    Ally("ally.small");
    Neutral("neutral.small");
    Enemy("enemy.small");
    TeamMate("teammate.small");

    SquadInfo("text.squad.small");
    UnitName("text.unit.small");
    Info("text.info");

    Id("text.development.id");
    TeamName("text.development.teamname");
    Task("text.development.task");
  }

  CreateReticleProfile("Large")
  {
    Self("self.large");
    Selected("selected.large");
    Ally("ally.large");
    Neutral("neutral.large");
    Enemy("enemy.large");
    TeamMate("teammate.large");

    SquadInfo("text.squad.large");
    UnitName("text.unit.large");
    Info("text.info");

    Id("text.development.id");
    TeamName("text.development.teamname");
    Task("text.development.task");
  }

  CreateReticleProfile("Vehicle")
  {
    Self("default.vehicle");
    Selected("select.vehicle");
    Ally("ally.vehicle");
    Neutral("neutral.vehicle");
    Enemy("enemy.vehicle");
    TeamMate("teammate.vehicle");

    SquadInfo("text.squad.small");
    UnitName("text.unit.small");
    Info("text.info");

    Id("text.development.id");
    TeamName("text.development.teamname");
    Task("text.development.task");
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Key Bindings
//

// Standard bindings
Bind("escape", "iface.activatescroll Client::MainMenu Top 0.2");
Bind("pause", "client.pause");

// Camera heights
Bind("F1", "camera.setheight 20");
Bind("F2", "camera.setheight 40");
Bind("F3", "camera.setheight 60");
Bind("F4", "camera.setheight 80");

// Camera movement
BindHold("rightarrow", "camera.bind.right");
BindHold("leftarrow", "camera.bind.left");
BindHold("uparrow", "camera.bind.forward");
BindHold("downarrow", "camera.bind.back");

// Create a squad using the current selection
Bind("ctrl 1", "iface.sendnotifyevent Client::SquadManager.Squad1 SquadControl::Create");
Bind("ctrl 2", "iface.sendnotifyevent Client::SquadManager.Squad2 SquadControl::Create");
Bind("ctrl 3", "iface.sendnotifyevent Client::SquadManager.Squad3 SquadControl::Create");
Bind("ctrl 4", "iface.sendnotifyevent Client::SquadManager.Squad4 SquadControl::Create");

// Add the current selection to a squad
Bind("alt 1", "iface.sendnotifyevent Client::SquadManager.Squad1 SquadControl::Add");
Bind("alt 2", "iface.sendnotifyevent Client::SquadManager.Squad2 SquadControl::Add");
Bind("alt 3", "iface.sendnotifyevent Client::SquadManager.Squad3 SquadControl::Add");
Bind("alt 4", "iface.sendnotifyevent Client::SquadManager.Squad4 SquadControl::Add");

// Select a squad
Bind("1", "iface.sendnotifyevent Client::SquadManager.Squad1 SquadControl::Select");
Bind("2", "iface.sendnotifyevent Client::SquadManager.Squad2 SquadControl::Select");
Bind("3", "iface.sendnotifyevent Client::SquadManager.Squad3 SquadControl::Select");
Bind("4", "iface.sendnotifyevent Client::SquadManager.Squad4 SquadControl::Select");

// Select a squad and scroll
Bind("shift 1", "iface.sendnotifyevent Client::SquadManager.Squad1 SquadControl::JumpTo");
Bind("shift 2", "iface.sendnotifyevent Client::SquadManager.Squad2 SquadControl::JumpTo");
Bind("shift 3", "iface.sendnotifyevent Client::SquadManager.Squad3 SquadControl::JumpTo");
Bind("shift 4", "iface.sendnotifyevent Client::SquadManager.Squad4 SquadControl::JumpTo");

// Client discrete events
Bind("s", "client.event de::stop");
Bind(",", "client.event de::prevdir");
Bind(".", "client.event de::nextdir");
Bind("shift d", "client.event de::selfdestruct");
Bind("u", "client.event de::upgrade");
Bind("[", "client.event de::prevunit");
Bind("]", "client.event de::nextunit");
Bind("alt [", "client.event de::prevunittype");
Bind("alt ]", "client.event de::nextunittype");
Bind("h", "client.event de::nextunit filter::headquarters");
Bind("e", "client.event de::selectall");
Bind("p", "client.event de::generic::togglepause");
Bind("space", "client.event de::messagejump::last");
Bind("g", "client.event de::selectgroup");

// Whacky
Bind("j", "message.game.trigger Client::Jkey");

// Client modes
Bind("t", "client.triggermode turn");

// Bindings based on single/multi player
If("multiplayer.flags.online")
{
  Bind("enter", "iface.activate Client::Chat");
  Bind("c", "iface.toggleactive Client::Comms");
}
Else()
{
  // Save and load game
  Bind("F8", "iface.activate Client::SaveLoad");
  Bind("F9", "iface.activate Client::SaveLoad; iface.sendnotifyevent 'Client::SaveLoad' 'QuickSave'");
  Bind("F10", "iface.sendnotifyevent 'Client::SaveLoad' 'QuickLoad'");

  // Secret codes
  Bind("Alt BackSpace", "iface.activate Client::Code");
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// MainMenu

CreateControl("Client::MainMenu", "Window")
{
  Skin("Game::SolidClientNoTop");
  Size(180, 195);
  Pos(0, 54);
  Geometry("HCentre", "VCentre");
  Style("Transparent", "FancyModal", "Immovable");

  CreateVarInteger("goals", 1);

  CreateControl("TopDropShadow", "Static")
  {
    Geometry("ParentWidth");
    ColorGroup("Sys::Texture");
    Size(0, 3);
    Image("if_interfacealpha_game.tga", 2, 6, 2, 3);
  }

  CreateControl("LeftPanel", "Static")
  {
    Skin("Game::Panel");
    Geometry("Bottom", "HCentre");
    Style("Transparent");
    Pos(-65, -5);
    Size(20, 23);

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }
  }

  CreateControl("RightPanel", "Static")
  {
    Skin("Game::Panel");
    Geometry("Bottom", "HCentre");
    Style("Transparent");
    Pos(66, -5);
    Size(20, 23);

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }
  }

  CreateControl("ResumeMission", "Button")
  {
    ReadTemplate("Game::Button");
    Size(-10, 24);
    Pos(5, 5);
    Geometry("ParentWidth");
    Font("HeaderSmall");
    Text("#client.menu.resume");

    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Top", 0.2);
    }
  }

  CreateControl("MedalGoals", "Button")
  {
    Align("<ResumeMission");
    ReadTemplate("Game::Button");
    Size(-10, 24);
    Pos(0, 3);
    Geometry("ParentWidth", "Bottom", "HInternal");
    Font("HeaderSmall");
    Text("#client.menu.medalgoals");

    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Top", 0.2);
      ActivateScroll("|Client::MedalGoals", "Right", 0.2);
    }
  }

  CreateControl("SaveLoad", "Button")
  {
    Align("<MedalGoals");
    ReadTemplate("Game::Button");
    Size(-10, 24);
    Pos(0, 3);
    Geometry("ParentWidth", "Bottom", "HInternal");
    Font("HeaderSmall");
    Text("#client.menu.saveload");

    OnEvent("Button::Notify::Pressed")
    {
      ActivateScroll("|Client::SaveLoad", "Right", 0.2);
      DeactivateScroll("<", "Top", 0.2);
    }
  }

  CreateControl("GameOptions", "Button")
  {
    Align("<SaveLoad");
    Geometry("ParentWidth", "Bottom", "HInternal");
    ReadTemplate("Game::Button");
    Size(-10, 24);
    Pos(0, 3);
    Font("HeaderSmall");
    Text("#client.menu.options");

    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Top", 0.2);
      ActivateScroll("|Game::Options", "Right", 0.2);
    }
  }

  CreateControl("Restart", "Button")
  {
    Align("<GameOptions");
    Geometry("ParentWidth", "Bottom", "HInternal");
    ReadTemplate("Game::Button");
    Size(-10, 24);
    Pos(0, 3);
    Font("HeaderSmall");
    Text("#client.menu.restart");

    OnEvent("Button::Notify::Pressed")
    {
      ActivateScroll("|Client::Restart", "Right", 0.2);
      DeactivateScroll("<", "Top", 0.2);
    }
  }

  CreateControl("AbortMission", "Button")
  {
    Align("<Restart");
    Geometry("ParentWidth", "Bottom", "HInternal");
    ReadTemplate("Game::Button");
    Size(-10, 24);
    Pos(0, 3);
    Font("HeaderSmall");
    Text("#client.menu.abort");

    OnEvent("Button::Notify::Pressed")
    {
      ActivateScroll("|Client::Abort", "Right", 0.2);
      DeactivateScroll("<", "Top", 0.2);
    }
  }

  CreateControl("WingsImage", "Static")
  {
    Geometry("Bottom", "HCentre");
    ColorGroup("Sys::Texture");
    Size(110, 30);
    Pos(0, -3);
    Image("if_interface_game.tga", 130, 225, 110, 30);
  }

  CreateControl("Objectives", "Static")
  {
    Skin("Game::SolidClient");
    Size(300, 99);
    Pos(0, -99);
    Geometry("Top", "HCentre");
    Style("Transparent");
  }

  CreateControl("LeftPanel", "Static")
  {
    Skin("Game::Panel");
    Geometry("HCentre");
    Style("Transparent");
    Pos(-135, -93);
    Size(19, 88);

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }
  }

  CreateControl("RightPanel", "Static")
  {
    Skin("Game::Panel");
    Geometry("HCentre");
    Style("Transparent");
    Pos(137, -93);
    Size(19, 88);

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }
  }

  CreateControl("Objectives", "Static")
  {
    Skin("Game::CutInBorder");
    Size(250, 89);
    Pos(0, -94);
    Geometry("Top", "HCentre");
    Style("Transparent");

    CreateControl("Objectives", "Client::DisplayObjectives")
    {
      CreateVarString("var");
      UseVar("$.var");
      Geometry("ParentWidth", "ParentHeight", "HCentre", "VCentre");
      Style("NoSelection", "Transparent", "!VSlider", "Wrap");
      Pos(2, 2);
      Size(-4, -4);
      ColorActive(220, 220, 170, 200);
      ColorCompleted(220, 220, 170, 200);
      ColorAbandoned(220, 220, 170, 200);

      ItemConfig()
      {
        Geometry("ParentWidth", "AutoSizeY");
        Font("HeaderSmall");
        ColorGroup("Game::Text");
        JustifyText("Centre");
      }
    }

    CreateControl("Text", "Static")
    {
      Skin("Game::Header");
      Font("HeaderSmall");
      Geometry("HCentre", "ParentWidth");
      Style("Transparent");
      ColorGroup("Game::HeaderText");
      JustifyText("Centre");
      TextOffset(0, 2);
      Size(66, 19);
      Pos(0, -25);
      Text("#client.menu.objectives");
    }
  }

  OnEvent("Window::Notify::Activated")
  {
    If("multiplayer.flags.online")
    {
      Disable("SaveLoad");
      Disable("Restart");
      Disable("MedalGoals");
    }
    Else()
    {
      Enable("SaveLoad");
      Enable("Restart");

      If("$.goals")
      {
        Enable("MedalGoals");
      }
      Else()
      {
        Disable("MedalGoals");
      }
    }
  }

  OnEvent("Window::Escape")
  {
    DeactivateScroll("", "Top", 0.2);
  }
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// MedalGoals dialog

ConfigureInterface()
{

  DefineControlType("Client::Debriefing::Goal", "Game::Debriefing::Goal")
  {
    Geometry("ParentWidth", "HCentre");
    Size(-20, 24);
    Style("Transparent");

    CreateControl("TitleBorder", "Static")
    {
      Geometry("ParentWidth", "ParentHeight");
      Size(-29, 0);
      Skin("Game::CutInBorder");
      Style("Transparent");
    }

    CreateControl("Title", "Static")
    {
      Font("System");
      ColorGroup("Game::Text");
      Geometry("ParentWidth", "ParentHeight");
      Size(-39, 0);
      Style("Transparent");
    }

    CreateControl("HiddenTitle", "Static")
    {
      Font("System");
      ColorGroup("Game::Text");
      Geometry("ParentWidth", "ParentHeight");
      Size(-39, 0);
      Text("#client.medalgoals.hidden");
      Style("Transparent");
    }

    CreateControl("TickBorder", "Static")
    {
      Size(24, 24);
      Skin("Game::CutInBorder");
      Style("Transparent");
      Geometry("Right");
    }

    CreateControl("Tick", "Static")
    {
      Geometry("Right");
      ColorGroup("Sys::Texture");
      Pos(-3, 3);
      Size(17, 17);
      Style("NoAutoActivate");
      Image("if_interfacealpha_game.tga", 89, 111, 17, 17);
    }

    OnEvent("Game::Debriefing::Notify::Goal::Visible")
    {
      Activate("Title");
      Deactivate("HiddenTitle");
    }

    OnEvent("Game::Debriefing::Notify::Goal::Hidden")
    {
      Deactivate("Title");
      Activate("HiddenTitle");
    }

    OnEvent("Game::Debriefing::Notify::Goal::Complete")
    {
      Activate("Tick");
    }

    OnEvent("Game::Debriefing::Notify::Goal::Incomplete")
    {
      Deactivate("Tick");
    }
  }
}

CreateControl("Client::MedalGoals", "Window")
{
  Geometry("HCentre", "VCentre");
  Style("FancyModal", "Transparent");
  Size(400, 270);
  Skin("Game::SolidClient");

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-10, 19);
    Pos(0, -19);
    Text("#client.medalgoals.title");
  }

  CreateControl("Goals", "Static")
  {
    Size(380, 80);
    Pos(0, 10);
    Style("Transparent");
    Geometry("HCentre");
    Skin("Game::Panel");

    CreateControl("Goal-0", "Client::Debriefing::Goal")
    {
      GoalIndex(0);
      Pos(0, 10);
    }

    CreateControl("Goal-1", "Client::Debriefing::Goal")
    {
      GoalIndex(1);
      Geometry("Bottom");
      Pos(0, -10);
    }

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

  }

  CreateControl("Stats", "Static")
  {
    Size(380, 125);
    Pos(0, 100);
    Style("Transparent");
    Geometry("HCentre");
    Skin("Game::Panel");

    CreateControl("TimeText", "Static")
    {
      Skin("Game::Panel");
      Geometry("HCentre");
      Size(360, 20);
      Pos(0, 10);
      Font("System");
      ColorGroup("Game::Text");
      Text("#shell.debriefing.single.timetitle");
      // Text("#shell.debriefing.single.resources");
      // Text("Time Elapsed");
      // Skin("Game::LineBorderSkinDark");
    }

    CreateControl("Time", "Game::Debriefing::Statistic")
    {
      Skin("Game::CutInBorder");
      Geometry("HCentre");
      Size(360, 20);
      Pos(0, 35);
      Font("System");
      ColorGroup("Game::Text");
      Mode("DynamicTime");
      // Skin("Game::LineBorderSkinDark");
    }

    CreateControl("ResourceText", "Static")
    {
      Skin("Game::Panel");
      Geometry("HCentre");
      Size(360, 20);
      Pos(0, 65);
      Font("System");
      ColorGroup("Game::Text");
      // Text("#shell.debriefing.single.timetitle");
      Text("#shell.debriefing.single.resources");
      // Text("Time Elapsed");
      // Skin("Game::LineBorderSkinDark");
    }

    CreateControl("Spent::Plastic", "Game::Debriefing::Statistic")
    {
      Skin("Game::CutInBorder");
      Geometry("HCentre");
      Style("Transparent");
      Size(100, 22);
      Pos(-65, 93);
      Font("System");
      ColorGroup("Game::Plastic");
      Mode("DynamicResourceSpent");
      Type("Plastic");
      TextOffset(5, 0);
    }

    CreateControl("PCostIcon", "Static")
    {
      Image("if_InterfaceAlpha_game.tga", 47, 26, 26, 26);
      ColorGroup("Sys::Texture");
      Geometry("HCentre");
      Size(26, 26);
      Pos(-110, 92);
    }

    CreateControl("Spent::Electricity", "Game::Debriefing::Statistic")
    {
      Skin("Game::CutInBorder");
      Geometry("HCentre");
      Style("Transparent");
      Size(100, 22);
      Pos(75, 93);
      Font("System");
      ColorGroup("Game::Electricity");
      Mode("DynamicResourceSpent");
      Type("Electricity");
      TextOffset(5, 0);
    }

    CreateControl("ECostIcon", "Static")
    {
      Image("if_InterfaceAlpha_game.tga", 21, 26, 26, 26);
      ColorGroup("Sys::Texture");
      Geometry("HCentre");
      Size(26, 26);
      Pos(30, 92);
    }

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

  }

  CreateControl("Done", "Button")
  {
    Geometry("Bottom", "HCentre");
    ReadTemplate("Game::Button");
    Size(75, 25);
    Pos(0, -10);
    Font("HeaderSmall");
    Text("#std.buttons.done");

    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Right", 0.2);
    }
  }
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Message window
//

ConfigureInterface()
{
  Sounds()
  {
    Add("Custom::Message", "menu_tick.wav");
  }
}

CreateControl("Client::MessageWindow", "MessageWindow")
{
  Geometry("HCentre");
  Pos(0, 25);
  JustifyText("Centre");
  Size(400, 150);
  Style("DropShadow");
  Font("HeaderSmall");

  // Maximum number of messages in the window
  MessagesMax(5);

  // Fade speed
  FadeSpeed(5000);

  // Typing speed
  TypingSpeedMin(2);
  TypingSpeedMax(100);

  // Life time is the number of milliseconds before it starts fading
  LifeTime(5000);

  // Message filters
  Filters()
  {
    Add("GameMessage");
    Add("MultiMessage");
    Add("MultiError");
    Add("ChatMessage");
    Add("ChatQuote");
    Add("ChatPrivate");
    Add("ChatLocal");
    Add("Message");
    Add("Error");
  }

  OnEvent("MessageWindow::Pop")
  {
    Sound("Custom::Message");
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Minimap

ConfigureInterface()
{
  CreateColorGroup("Minimap", "Default")
  {
    NormalBg(255, 255, 255, 255);
  }
}

CreateControl("Client::Minimap", "Static")
{
  Size(142, 142);
  Skin("Game::SolidClient");
  Geometry("Bottom", "Right");
  Style("Transparent");

  CreateControl("MiniMapBkgnd", "Static")
  {
    Skin("Game::CutInBorder");
    Pos(5, 5);
    Size(132, 132);
    ColorGroup("Minimap");
  }

  // Minimap view - make sure this is last so blips and FOV aren't clipped
  CreateControl("MiniMapView", "MapWindow")
  {
    Pos(7, 7);
    Size(128, 128);
    ColorGroup("Minimap");

    FOVColor(255, 255, 255, 200);
    // FOV bitmap
    FOVTexture()
    {
      Image("if_InterfaceAlpha_game.tga", 95, 53, 32, 30);
      Filter(1);
    }
    FOVSize(16);

    // Objectives
    ObjectiveTexture("if_InterfaceAlpha_game.tga", 40, 0, 14, 14);

    // Message blip
    BlipTexture()
    {
      Image("if_InterfaceAlpha_game.tga", 111, 1, 16, 16);
      Filter(1);
    }
    BlipTime(1.6);
    BlipSize(14);

    UnitTexture("if_Interfacealpha_game.tga", 18, 100, 3, 3);

    BuildingTexture("if_Interfacealpha_game.tga", 22, 100, 5, 5);

    ResourceTexture("Electricity")
    {
      Image("if_interfacealpha_game.tga", 28, 100, 5, 5);
    }

    ResourceColor("Electricity", 130, 130, 255, 255);

    ResourceTexture("Plastic")
    {
      Image("if_interfacealpha_game.tga", 28, 100, 5, 5);
    }

    ResourceColor("Plastic", 255, 255, 130, 255);

    DepletedResourceColor(0, 0, 0, 128);

    ObjectiveTexture()
    {
      Image("if_interfacealpha_game.tga", 19, 106, 15, 16);
    }
  }

  CreateControl("MinimapTitle", "Static")
  {
    Skin("Game::HeaderSquads");
    Geometry("Right", "Top");
    Size(132, 19);
    Pos(0, -19);
    Style("Transparent");

    CreateControl("MinimapText", "Static")
    {
      Style("Transparent");
      Geometry("ParentHeight", "ParentWidth", "HCentre", "VCentre");
      Size(-6, -6);
      Font("HeaderSmall");
      ColorGroup("Game::HeaderTextAlpha");
      Text("#client.minimap.title");
      TextOffset(-9, 0);
    }
  }

  CreateControl("MinimapTextImage", "Static")
  {
    Geometry("Right");
    Size(20, 20);
    Pos(0, -20);
    ColorGroup("Sys::Texture");
    Image("if_interfacealpha_game.tga", 68, 107, 20, 20);
  }

}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

ConfigureInterface()
{
  DefineControlType("Game::MP3Notches", "Static")
  {
    Geometry("Bottom", "HInternal");
    Style("Transparent");
    Pos(0, 1);
    Size(280, 12);

    CreateControl("LeftNotch", "Static")
    {
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 56, 14, 7, 11);
      Size(7, 11);
    }
    CreateControl("RightNotch", "Static")
    {
      Geometry("Right");
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 63, 14, 7, 11);
      Size(7, 11);
    }
    CreateControl("Notch1", "Static")
    {
      Pos(24, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch2", "Static")
    {
      Pos(49, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch3", "Static")
    {
      Pos(74, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch4", "Static")
    {
      Pos(99, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch5", "Static")
    {
      Pos(124, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch6", "Static")
    {
      Pos(149, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch7", "Static")
    {
      Pos(174, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch8", "Static")
    {
      Pos(199, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch9", "Static")
    {
      Pos(224, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch10", "Static")
    {
      Pos(249, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
  }
}

CreateControl("Client::Player", "Window")
{
  Skin("Game::SolidClient");
  Size(320, 288);
  Geometry("HCentre", "VCentre");
  Style("Transparent", "ModalClose");

  CreateVarString("MP3Dir");

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-10, 19);
    Pos(0, -19);
    Text("MP3 Player");
  }

  CreateControl("Viewer", "ConsoleViewer")
  {
    ReadTemplate("Game::SliderListBox");
    Geometry("HCentre", "ParentWidth");
    Size(-10, 53);
    Pos(0, 5);
    WrapAdjust(22);

    Filters()
    {
      Add("Diag");
    }

    ItemConfig()
    {
      Font("System");
      Geometry("AutoSizeY", "ParentWidth");
    }
    Style("NoSelection", "SmartScroll");
  }

  CreateControl("Controls", "Static")
  {
    Pos(0, 65);
    Size(300, 181);
    Style("Transparent");
    Geometry("HCentre");
    Skin("Game::Panel");

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("VolumeMP3Title", "Static")
    {
      Geometry("HCentre");
      Size(280, 20);
      Pos(0, 10);
      Skin("Game::Panel");
      ColorGroup("Game::Text");
      JustifyText("Centre");
      Style("Transparent");
      Font("System");
      Text("#client.options.audio.music");
    }

    CreateControl("VolumeMP3", "Slider")
    {
      ReadTemplate("Game::hslider");
      Geometry("HCentre");
      Size(280, 15);
      Pos(0, 32);
      UseVar("user.vars.volumemusic");
    }

    CreateControl("MP3Notches", "Game::MP3Notches")
    {
      Align("<VolumeMP3");
    }

    CreateControl("Controls1", "Static")
    {
      Pos(0, 65);
      Size(247, 21);
      Style("Transparent");
      Geometry("HCentre");

      CreateControl("Prev", "Game::Button")
      {
        Size(40, 21);
        Font("System");
        Text("Prev");

        OnEvent("Button::Notify::Pressed")
        {
          Cmd("sound.player.prev");
        }
      }

      CreateControl("Stop", "Game::Button")
      {
        Size(40, 21);
        Pos(43, 0);
        Font("System");
        Text("Stop");

        OnEvent("Button::Notify::Pressed")
        {
          Cmd("sound.player.fade user.vars.volumemusic");
        }
      }

      CreateControl("Play", "Game::Button")
      {
        Size(40, 21);
        Pos(-17, 0);
        Geometry("HCentre");
        Font("System");
        Text("#std.buttons.play");

        OnEvent("Button::Notify::Pressed")
        {
          Cmd("sound.player.play");
        }
      }

      CreateControl("Next", "Game::Button")
      {
        Size(40, 21);
        Pos(-78, 0);
        Geometry("Right");
        Font("System");
        Text("#shell.debriefing.next");

        OnEvent("Button::Notify::Pressed")
        {
          Cmd("sound.player.next");
        }
      }

      CreateControl("Rand", "Game::Button")
      {
        Size(75, 21);
        Geometry("Right");
        Font("System");
        Text("Random");

        OnEvent("Button::Notify::Pressed")
        {
          Cmd("sound.player.random");
        }
      }
    }

    CreateControl("DirText", "Static")
    {
      Skin("Game::Panel");
      Geometry("HCentre");
      Size(280, 20);
      Pos(0, 91);
      Font("System");
      ColorGroup("Game::Text");
      Text("Enter File Name Or Directory");
    }

    CreateControl("MP3Dir", "Edit")
    {
      ColorGroup("Game::EditText");
      Skin("Game::CutInBorder");
      Pos(0, 116);
      Size(-40, 24);
      Geometry("HCentre", "ParentWidth");
      Font("System");
      UseVar("$<<.MP3Dir");

      OnEvent("Edit::Notify::Escaped")
      {
        Notify("<<", "Window::Escape");
      }
      OnEvent("Edit::Notify::Entered")
      {
        If("$<<.MP3Dir", "!=", "")
        {
          Sound("Custom::Navigate::Yes");
          Cmd("sound.player.addtrack $<<.MP3Dir");
          Cmd("sound.player.add $<<.MP3Dir");
          Op("$<<.MP3Dir", "=", "");
        }
        Else()
        {
          Sound("Custom::Navigate::No");
        }
      }
    }

    CreateControl("Controls2", "Static")
    {
      Pos(0, -10);
      Size(279, 25);
      Style("Transparent");
      Geometry("HCentre", "Bottom");

      CreateControl("Clear", "Game::Button")
      {
        Size(91, 25);
        Geometry("Left");
        Text("Clear Playlist");
        Font("System");

        OnEvent("Button::Notify::Pressed")
        {
          Cmd("sound.player.clear");
        }
      }

      CreateControl("Add1", "Game::Button")
      {
        Size(91, 25);
        Geometry("HCentre");
        Text("Add Playlist");
        Font("System");

        OnEvent("Button::Notify::Pressed")
        {
          If("$<<<.MP3Dir", "!=", "")
          {
            Cmd("sound.player.add $<<<.MP3Dir");
            Op("$<<<.MP3Dir", "=", "");
          }
          Else()
          {
            Sound("Custom::Navigate::No");
          }
        }
      }

      CreateControl("Add2", "Game::Button")
      {
        Size(91, 25);
        Geometry("Right");
        Text("Add MP3 File");
        Font("System");

        OnEvent("Button::Notify::Pressed")
        {
          If("$<<<.MP3Dir", "!=", "")
          {
            Cmd("sound.player.addtrack $<<<.MP3Dir");
            Op("$<<<.MP3Dir", "=", "");
          }
          Else()
          {
            Sound("Custom::Navigate::No");
          }
        }
      }
    }
  }

  CreateControl("Done", "Game::Button")
  {
    Size(75, 25);
    Geometry("Bottom", "HCentre");
    Pos(0, -10);
    Font("System");
    Text("#std.buttons.done");

    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Right", 0.2);
    }
  }

  OnEvent("Window::Notify::Activated")
  {
    Deactivate("|Client::SongList");
    Op("$.MP3Dir", "=", "");
    SetFocus("Controls.MP3Dir");
  }

  OnEvent("Window::Notify::Deactivated")
  {
    Activate("|Client::SongList");
  }

  OnEvent("Window::Escape")
  {
    DeactivateScroll("", "Right", 0.2);
  }
}

CreateControl("Client::SongList", "MessageWindow")
{
  Pos(5, 5);
  JustifyText("Left");
  Size(400, 53);
  Style("DropShadow");
  Font("HeaderSmall");

  // Maximum number of messages in the window
  MessagesMax(3);

  // Fade speed
  FadeSpeed(2250);

  // Typing speed
  TypingSpeedMin(2);
  TypingSpeedMax(100);

  // Life time is the number of milliseconds before it starts fading
  LifeTime(2250);

  // Message filters
  Filters()
  {
    Add("Diag");
  }
}

Bind("ctrl alt m", "iface.toggleactive Client::Player");
Bind("ctrl alt ,", "sound.player.prev");
Bind("ctrl alt .", "sound.player.next");
Bind("ctrl alt /", "sound.player.random");///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// In-Game Multiplayer Controls
//

ConfigureInterface()
{
  //
  // Base player sync class
  //
  DefineControlType("Game::Sync", "Window")
  {
    Geometry("VCentre", "HCentre");
    Size(300, 266);
    Style("TitleBar", "NoSysButtons", "Modal");
    Skin("Game::SolidClient");
    TitleBarConfig("Reg::Game::WindowTitle");

    CreateControl("PlayerList", "MultiPlayer::SyncList")
    {
      ReadTemplate("Game::SliderListBox");

      ItemConfig()
      {
        ColorGroup("Game::Text");
        Font("System");
        Geometry("ParentWidth");
        Size(-14, 27);
        TextOffset(3, 0);
      }

      CreateControl("Slot0Bkgnd", "Static")
      {
        Pos(-8, 0);
        Size(-12, 27);
        Geometry("ParentWidth", "HCentre");
        Skin("Game::Panel");
        Style("Transparent");
      }

      CreateControl("Slot1Bkgnd", "Static")
      {
        Align("^");
        Pos(-8, 0);
        Size(-12, 27);
        Geometry("ParentWidth", "HCentre", "Bottom");
        Skin("Game::Panel");
        Style("Transparent");
      }

      CreateControl("Slot2Bkgnd", "Static")
      {
        Align("^");
        Pos(-8, 0);
        Size(-12, 27);
        Geometry("ParentWidth", "HCentre", "Bottom");
        Skin("Game::Panel");
        Style("Transparent");
      }

      CreateControl("Slot3Bkgnd", "Static")
      {
        Align("^");
        Pos(-8, 0);
        Size(-12, 27);
        Geometry("ParentWidth", "HCentre", "Bottom");
        Skin("Game::Panel");
        Style("Transparent");
      }

      CreateControl("Slot4Bkgnd", "Static")
      {
        Align("^");
        Pos(-8, 0);
        Size(-12, 27);
        Geometry("ParentWidth", "HCentre", "Bottom");
        Skin("Game::Panel");
        Style("Transparent");
      }

      CreateControl("Slot5Bkgnd", "Static")
      {
        Align("^");
        Pos(-8, 0);
        Size(-12, 27);
        Geometry("ParentWidth", "HCentre", "Bottom");
        Skin("Game::Panel");
        Style("Transparent");
      }

      CreateControl("Slot6Bkgnd", "Static")
      {
        Align("^");
        Pos(-8, 0);
        Size(-12, 27);
        Geometry("ParentWidth", "HCentre", "Bottom");
        Skin("Game::Panel");
        Style("Transparent");
      }

      CreateControl("Slot7Bkgnd", "Static")
      {
        Align("^");
        Pos(-8, 0);
        Size(-12, 27);
        Geometry("ParentWidth", "HCentre", "Bottom");
        Skin("Game::Panel");
        Style("Transparent");
      }

      CreateVarString("Player");
      UseVar("$Player");

      Geometry("ParentWidth", "ParentHeight");
      Size(-10, -45);
      Pos(5, 5);
      Font("System");

      OffsetReady(1);
      OffsetName(24);

      IconReadyOff()
      {
        Image("if_interface_game.tga", 23, 115, 21, 21);
        Pos(1, 0);
      }
      IconReadyOn()
      {
        Image("if_interface_game.tga", 35, 1, 21, 21);
        Pos(1, 0);
      }
    }

    CreateControl("Abort", "Button")
    {
      ReadTemplate("Game::Button");
      Size(85, 25);
      Pos(0, -10);
      Geometry("HCentre", "Bottom");
      Font("System");
      Text("#std.buttons.abort");

      TranslateEvent("Button::Notify::Pressed", "Abort", "<");
    }
  }
}


//
// Sync window shown when entering game
//
CreateControl("Game::Synchronizing", "Game::Sync")
{
  Text("#multiplayer.connect.playersync");

  OnEvent("Abort")
  {
    Cmd("multiplayer.abort");

    If("multiplayer.flags.waslobby")
    {
      Cmd("sys.runcode quit");
    }
    Else()
    {
      Cmd("sys.runcode shell");
    }
  }
}


//
// Sync window shown during host migration
//
CreateControl("Game::Resync", "Game::Sync")
{
  Text("#multiplayer.connect.migrate");

  OnEvent("ResyncComplete")
  {
    Switch("$|Multiplayer::Connect.action")
    {
      Case("abort")
      {
        Cmd("multiplayer.abort");

        If("multiplayer.flags.waslobby")
        {
          Cmd("sys.runcode quit");
        }
        Else()
        {
          Cmd("sys.runcode shell");
        }
      }
    }
    Op("$|Multiplayer::Connect.action", "=", "");
  }

  OnEvent("Abort")
  {
    Cmd("multiplayer.abort");

    If("multiplayer.flags.waslobby")
    {
      Cmd("sys.runcode quit");
    }
    Else()
    {
      Cmd("sys.runcode shell");
    }
  }
}


//
// Event handler
//
CreateControl("Multiplayer::Connect", "Window")
{
  CreateVarString("action");

  //
  // Failure
  //
  OnEvent("Failure::Abort")
  {
    Deactivate();
    Cmd("multiplayer.abort");

    If("multiplayer.flags.waslobby")
    {
      Cmd("sys.runcode quit");
    }
    Else()
    {
      Cmd("sys.runcode shell");
    }
  }

  OnEvent("Failure::Continue")
  {
    Deactivate();
    Cmd("multiplayer.abort");
    Cmd("timing.readjust");
  }

  //
  // General
  //
  OnEvent("StyxNet::Event::ServerDisconnected")
  {
    Deactivate("|Game::Synchronizing");
    Deactivate("|Game::Resync");

    MessageBox()
    {
      Title("#multiplayer.server.disconnected.title");
      Message("#multiplayer.server.disconnected.message");
      Button0("#std.buttons.abort", "Failure::Abort");
      Button1("#std.buttons.continue", "Failure::Continue");
    }
  }

  OnEvent("StyxNet::Event::SessionKicked")
  {
    Deactivate("|Game::Synchronizing");
    Deactivate("|Game::Resync");

    MessageBox()
    {
      Title("#multiplayer.server.kicked.title");
      Message("#multiplayer.server.kicked.message");
      Button0("#std.buttons.ok", "Failure::Abort");
    }
  }

  //
  // Session migration
  //
  OnEvent("StyxNet::Event::SessionMigrateFailed")
  {
    Deactivate("|Game::Synchronizing");
    Deactivate("|Game::Resync");

    MessageBox()
    {
      Title("#multiplayer.session.sessionmigratefailed.title");
      Message("#multiplayer.session.sessionmigratefailed.message");
      Button0("#std.buttons.abort", "Failure::Abort");
      Button1("#std.buttons.continue", "Failure::Continue");
    }
  }
  OnEvent("StyxNet::Event::ServerConnectFailed")
  {
    Deactivate("|Game::Synchronizing");
    Deactivate("|Game::Resync");

    MessageBox()
    {
      Title("#multiplayer.session.sessionmigratefailed.title");
      Message("#multiplayer.session.sessionmigratefailed.message");
      Button0("#std.buttons.abort", "Failure::Abort");
      Button1("#std.buttons.continue", "Failure::Continue");
    }
  }
  OnEvent("StyxNet::Event::ServerMigrateFailed")
  {
    Deactivate("|Game::Synchronizing");
    Deactivate("|Game::Resync");

    MessageBox()
    {
      Title("#multiplayer.session.servermigratefailed.title");
      Message("#multiplayer.session.servermigratefailed.message");
      Button0("#multiplayer.session.servermigratefailed.continue", "Migrate::Continue");
      Button1("#multiplayer.session.servermigratefailed.abort", "Migrate::Abort");
    }
  }

  OnEvent("Migrate::Continue")
  {
  }

  OnEvent("Migrate::Abort")
  {
    Switch("$.action")
    {
      Case("abort")
      {
        Cmd("multiplayer.abort");

        If("multiplayer.flags.waslobby")
        {
          Cmd("sys.runcode quit");
        }
        Else()
        {
          Cmd("sys.runcode shell");
        }
      }
    }
    Op("$.action", "=", "");
  }
}

Cmd("multiplayer.register.client MultiPlayer::Connect");
Cmd("multiplayer.register.server MultiPlayer::Connect");///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Game Options

ConfigureInterface()
{
  DefineControlType("Game::Notches", "Static")
  {
    Geometry("Bottom", "HInternal");
    Style("Transparent");
    Pos(0, 1);
    Size(302, 12);

    CreateControl("LeftNotch", "Static")
    {
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 56, 14, 7, 11);
      Size(7, 11);
    }
    CreateControl("RightNotch", "Static")
    {
      Geometry("Right");
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 63, 14, 7, 11);
      Size(7, 11);
    }
    CreateControl("Notch1", "Static")
    {
      Pos(24, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch2", "Static")
    {
      Pos(49, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch3", "Static")
    {
      Pos(74, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch4", "Static")
    {
      Pos(99, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch5", "Static")
    {
      Pos(124, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch6", "Static")
    {
      Pos(149, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch7", "Static")
    {
      Pos(174, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch8", "Static")
    {
      Pos(199, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch9", "Static")
    {
      Pos(224, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch10", "Static")
    {
      Pos(249, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
    CreateControl("Notch11", "Static")
    {
      Pos(274, 0);
      ColorGroup("Sys::Texture");
      Image("if_interfacealpha_game.tga", 28, 10, 3, 5);
      Size(3, 5);
    }
  }

  DefineControlType("Game::SoundOptions", "Window")
  {
    Style("Transparent");

    CreateControl("VolumeMasterTitle", "Static")
    {
      Geometry("HCentre");
      Skin("Game::Panel");
      Pos(0, 30);
      Size(302, 20);
      ColorGroup("Game::Text");
      Style("Transparent");
      Font("System");
      Text("#client.options.audio.master");
    }

    CreateControl("VolumeMaster", "Slider")
    {
      Geometry("HCentre");
      ReadTemplate("Game::hslider");
      Size(302, 15);
      Pos(0, 52);
      UseVar("user.vars.volumemaster");
    }

    CreateControl("Notches", "Game::Notches")
    {
      Align("<VolumeMaster");
    }

    CreateControl("VolumeMusicTitle", "Static")
    {
      Geometry("HCentre");
      Size(302, 20);
      Pos(0, 82);
      Skin("Game::Panel");
      ColorGroup("Game::Text");
      JustifyText("Centre");
      Style("Transparent");
      Font("System");
      Text("#client.options.audio.music");
    }

    CreateControl("VolumeMusic", "Slider")
    {
      ReadTemplate("Game::hslider");
      Geometry("HCentre");
      Size(302, 15);
      Pos(0, 104);
      UseVar("user.vars.volumemusic");
    }

    CreateControl("StrmNotches", "Game::Notches")
    {
      Align("<VolumeMusic");
    }
  }
}

//
// game Options Dialog Setup
//
CreateControl("Game::Options", "Window")
{
  Skin("Game::SolidClient");
  Geometry("HCentre", "VCentre");
  Size(342, 420);
  Style("FancyModal", "AdjustWindow", "Transparent", "NoSysButtons", "Immovable");

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-20, 19);
    Pos(0, -19);
    Text("#client.options.title");
  }

  CreateControl("Sound", "Game::SoundOptions")
  {
    Skin("Game::Panel");
    Pos(10, 243);
    Size(322, 135);
    CreateControl("Title", "Static")
    {
      Skin("Game::CutInBorder");
      Geometry("ParentWidth", "Top");
      Style("Transparent");
      ColorGroup("Game::HeaderText");
      Pos(5, 5);
      Size(-10, 20);
      Font("System");
      Text("#client.options.audio.title");
    }
  }

  CreateControl("Gameplay", "Static")
  {
    Skin("Game::Panel");
    Pos(10, 10);
    Size(322, 223);
    Style("Transparent");

    CreateControl("Title", "Static")
    {
      Skin("Game::CutInBorder");
      Geometry("ParentWidth", "Top");
      Style("Transparent");
      ColorGroup("Game::HeaderText");
      Pos(5, 5);
      Size(-10, 20);
      Font("System");
      Text("#client.options.gameplay.title");
    }
    CreateControl("RightClickScrollSpeedTitle", "Static")
    {
      Geometry("HCentre");
      Skin("Game::Panel");
      Pos(0, 30);
      Size(302, 20);
      ColorGroup("Game::Text");
      Style("Transparent");
      Font("System");
      Text("#client.options.gameplay.rightscroll");
    }

    CreateControl("ScrollSpeed", "Slider")
    {
      Geometry("HCentre");
      ReadTemplate("Game::hslider");
      Size(302, 15);
      Pos(0, 52);
      UseVar("user.vars.camera.scrollrate");
    }

    CreateControl("RightScrollNotches", "Game::Notches")
    {
      Align("<ScrollSpeed");
    }

    CreateControl("EdgeScrollTitle", "Static")
    {
      Geometry("HCentre");
      Skin("Game::Panel");
      Pos(0, 82);
      Size(302, 20);
      ColorGroup("Game::Text");
      Style("Transparent");
      Font("System");
      Text("#client.options.gameplay.edgescroll");
    }

    CreateControl("EdgeScroll", "Slider")
    {
      ReadTemplate("Game::hslider");
      Size(302, 15);
      Geometry("HCentre");
      Pos(0, 104);
      UseVar("user.vars.camera.edgerate");
    }

    CreateControl("EdgeScrollNotches", "Game::Notches")
    {
      Align("<EdgeScroll");
    }

    CreateControl("KeyScrollTitle", "Static")
    {
      Geometry("HCentre");
      Skin("Game::Panel");
      Pos(0, 134);
      Size(302, 20);
      ColorGroup("Game::Text");
      Style("Transparent");
      Font("System");
      Text("#client.options.gameplay.keyscroll");
    }

    CreateControl("KeyScroll", "Slider")
    {
      Geometry("HCentre");
      ReadTemplate("Game::hslider");
      Pos(0, 156);
      Size(302, 15);
      UseVar("user.vars.camera.keyrate");
    }

    CreateControl("KeyScrollNotches", "Game::Notches")
    {
      Align("<KeyScroll");
    }

    CreateControl("ResetDefaults", "Button")
    {
      ReadTemplate("Game::Button");
      Geometry("HCentre", "VCentre");
      Pos(0, 90);
      Size(240, 25);
      Font("System");
      Text("#client.options.gameplay.reset");
      OnEvent("Button::Notify::Pressed")
      {
        Op("user.vars.camera.scrollrate", "=", "user.vars.camera.default.scrollrate");
        Op("user.vars.camera.edgerate", "=", "user.vars.camera.default.edgerate");
        Op("user.vars.camera.keyrate", "=", "user.vars.camera.default.keyrate");
      }
    }
  }

  CreateControl("Done", "Game::Button")
  {
    Size(85, 25);
    Geometry("Bottom", "HCentre");
    Pos(0, -10);
    Font("System");
    Text("#std.buttons.done");

    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Right", 0.2);
    }
  }
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

CreateControl("Client::Paused", "Static")
{
  Skin("Game::SolidClient");
  Size(200, 40);
  Geometry("HCentre", "VCentre");
  Style("Transparent");
  Font("Debriefing");
  ColorGroup("Game::HeaderText");
  Text("#game.client.hud.tasks.construct.paused");
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// PreReq Window

CreateControl("Client::PrereqDisplay", "Client::PrereqDisplay")
{
  ColorGroup("Sys::Texture");
  Size(128, 20);
  Align("<Client::UnitDisplay");
  Geometry("HInternal", "VInternal");
  Style("Transparent");
  Pos(0, 292);

  CreateControl("Prereq1", "Static")
  {
    Font("HeaderSmall");
    Geometry("Top", "HCentre", "ParentWidth", "ParentHeight");
    JustifyText("Centre");
    ColorGroup("Game::Text");
    TextOffset(3, 0);
    Style("Transparent");
    UseVar("$<.type1");
  }
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Resource Window
ConfigureInterface()
{
  CreateColorGroup("Client::ResourceWindow::Plastic", "Sys::Texture")
  {
    AllFg(255, 255, 130, 200);
    DisabledFg(255, 255, 170, 100);
  }

  CreateColorGroup("Client::ResourceWindow::Electricity", "Sys::Texture")
  {
    AllFg(130, 130, 255, 200);
    DisabledFg(170, 170, 255, 0);
  }

  DefineControlType("Client::Resource::Base", "Client::Resource")
  {
    Size(202, 26);
    Style("Transparent", "Inert");
    Geometry("Right");

    ShowSeen(1);
    FilterRate(80%);
  }

  Sounds()
  {
    Add("Custom::Resource::Plastic", "plastic_in.wav");
    Add("Custom::Resource::Electricity", "electricity_in.wav");
  }
}

CreateControl("Client::ResourceWindow", "Static")
{
  Geometry("Right");
  Size(200, 104);
  Style("Transparent");

  CreateControl("P", "Client::Resource::Base")
  {
    Pos(0, 0);
    Resource("Plastic");
    SoundUp("Custom::Resource::Plastic");

    CreateControl("Value", "Static")
    {
      Pos(-3, 0);
      Geometry("ParentWidth", "ParentHeight");
      Font("Resource");
      JustifyText("Right");
      TextOffset(-26, 0);
      ColorGroup("Game::Plastic");
      Style("Transparent");
      UseVar("$<.resource");
    }

    CreateControl("Icon", "Static")
    {
      Geometry("Right");
      Pos(0, 2);
      Size(26, 26);
      ColorGroup("Sys::Texture");
      Image("if_InterfaceAlpha_game.tga", 47, 26, 26, 26);
    }
  }

  CreateControl("E", "Client::Resource::Base")
  {
    Pos(0, 32);
    Resource("Electricity");
    SoundUp("Custom::Resource::Electricity");

    CreateControl("Value", "Static")
    {
      Pos(-3, 0);
      Geometry("ParentWidth", "ParentHeight");
      Font("Resource");
      JustifyText("Right");
      TextOffset(-26, 0);
      ColorGroup("Game::Electricity");
      Style("Transparent");
      UseVar("$<.resource");
    }

    CreateControl("Icon", "Static")
    {
      Geometry("Right");
      Pos(0, 2);
      Size(26, 26);
      ColorGroup("Sys::Texture");
      Image("if_InterfaceAlpha_game.tga", 21, 26, 26, 26);
    }
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Quit dialog

CreateControl("Client::Restart", "Window")
{
  Skin("Game::SolidClient");
  Size(200, 100);
  Geometry("HCentre", "VCentre");
  Style("Transparent", "Modal");

  CreateControl("Border", "Static")
  {
    Skin("Game::Panel");
    Geometry("ParentWidth");
    Size(-20, 50);
    Pos(10, 10);
    Style("Transparent");

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

  }

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-10, 19);
    Pos(0, -19);
    Text("#client.restart.title");
  }

  CreateControl("Text", "Static")
  {
    Geometry("ParentWidth");
    Size(0, 15);
    Pos(0, 25);
    Font("HeaderSmall");
    JustifyText("Centre");
    Style("Transparent");
    ColorGroup("Game::Text");
    Text("#client.restart.text1");
  }

  CreateControl("OK", "Button")
  {
    ReadTemplate("Game::Button");
    Size(75, 25);
    Pos(10, -10);
    Geometry("Bottom", "Left");
    Font("HeaderSmall");
    Text("#std.buttons.ok");

    OnEvent("Button::Notify::Pressed")
    {
      Cmd("gamegod.missions.replay");
    }
  }

  CreateControl("Cancel", "Button")
  {
    Geometry("Bottom", "Right");
    ReadTemplate("Game::Button");
    Size(75, 25);
    Pos(-10, -10);
    Font("HeaderSmall");
    Text("#std.buttons.cancel");

    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Right", 0.2);
    }
  }
  OnEvent("Window::Escape")
  {
    DeactivateScroll("", "Right", 0.2);
  }
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Save/Load Control
//

CreateControl("Client::SaveLoad", "Game::SaveLoad")
{
  Skin("Game::SolidClient");
  Geometry("HCentre", "VCentre");
  Style("AdjustWindow", "Modal");
  Size(384, 202);
  ColorGroup("Sys::Texture");

  CreateControl("Header", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(-10, 19);
    Pos(0, -19);
    Text("#client.saveload.title");
  }

  CreateControl("SaveSlotBkgnd", "Static")
  {
    Skin("Game::CutInBorder");
    Pos(0, 10);
    Geometry("ParentWidth", "HCentre");
    Style("Transparent");
    Size(-20, 149);
  }

  EmptyDescription("#client.saveload.empty");
  UsedDescription("#game.savegame.description");

  CreateVarInteger("quick");

  CreateControl("List", "ListBox")
  {
    ReadTemplate("Game::SaveGameListBox");
    Geometry("ParentWidth", "HCentre");
    Pos(2, 15);
    Size(-24, 158);
    UseVar("$<.slotName");
    Style("!VSlider", "!DropShadow");

    AddTextItem("Slot0");
    AddTextItem("Slot1");
    AddTextItem("Slot2");
    AddTextItem("Slot3");
    AddTextItem("Slot4");
    AddTextItem("Slot5");
    AddTextItem("Slot6");

    TranslateEvent("ListBox::SelChange", "Game::SaveLoad::Message::Select", "<");
  }

  CreateControl("Load", "Button")
  {
    ReadTemplate("Game::Button");
    Geometry("Bottom");
    Pos(10, -10);
    Size(100, 25);
    Font("HeaderSmall");
    Text("#client.saveload.load");
    OnEvent("Button::Notify::Pressed")
    {
      SendNotifyEvent("<", "Game::SaveLoad::Message::LoadRequest");
    }
  }

  CreateControl("Save", "Button")
  {
    ReadTemplate("Game::Button");
    Geometry("Bottom");
    Pos(120, -10);
    Size(100, 25);
    Font("HeaderSmall");
    Text("#client.saveload.save");
    OnEvent("Button::Notify::Pressed")
    {
      SendNotifyEvent("<", "Game::SaveLoad::Message::SaveRequest");
    }
  }

  CreateControl("Done", "Button")
  {
    ReadTemplate("Game::Button");
    Geometry("Bottom", "Right");
    Size(80, 25);
    Pos(-10, -10);
    Font("HeaderSmall");
    Text("#std.buttons.done");
    OnEvent("Button::Notify::Pressed")
    {
      DeactivateScroll("<", "Right", 0.2);
    }
  }

  CreateControl("Saving", "Window")
  {
    Skin("Game::SolidClient");
    Style("AdjustWindow", "NoAutoActivate");
    Size(300, 50);
    Geometry("HCentre", "VCentre");

    CreateControl("Panel", "Static")
    {
      Skin("Game::Panel");
      Geometry("ParentWidth", "ParentHeight", "HCentre", "VCentre");
      Style("Transparent");
      Size(-6, -6);

      CreateControl("RivetTL", "Static")
      {
        Pos(3, 3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetTR", "Static")
      {
        Geometry("Right");
        Pos(-3, 3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetBR", "Static")
      {
        Geometry("Bottom", "Right");
        Pos(-3, -3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetBL", "Static")
      {
        Geometry("Bottom");
        Pos(3, -3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }
    }

    CreateControl("Wait", "Static")
    {
      Geometry("ParentWidth", "ParentHeight");
      Style("Transparent");
      Font("HeaderSmall");
      ColorGroup("Game::Text");
      Text("#client.saveload.saving");
    }
  }

  OnEvent("QuickSave")
  {
    Op("$.quick", "=", 1);
    SendNotifyEvent("", "Game::SaveLoad::Message::SaveRequest");
  }

  OnEvent("Game::SaveLoad::Notify::SelectedUsed")
  {
    Enable("Load");
  }

  OnEvent("Game::SaveLoad::Notify::SelectedFree")
  {
    Disable("Load");
  }

  OnEvent("Game::SaveLoad::Notify::SaveSlotFree")
  {
    SendNotifyEvent("", "SaveLoad::SaveNow");
  }

  OnEvent("Game::SaveLoad::Notify::SaveSlotUsed")
  {
    If("$.quick")
    {
      SendNotifyEvent("", "SaveLoad::SaveNow");
    }
    Else()
    {
      MessageBox()
      {
        Title("#client.saveload.confirmsave.title");
        Message("#client.saveload.confirmsave.message");
        Button0("#std.buttons.ok", "SaveLoad::SaveNow");
        Button1("#std.buttons.cancel", "");
      }
    }
  }

  OnEvent("SaveLoad::SaveNow")
  {
    Activate("Saving");
    SendNotifyEvent("", "Game::SaveLoad::Message::SaveCycle");
  }

  OnEvent("Game::SaveLoad::Notify::SaveProceed")
  {
    SendNotifyEvent("", "Game::SaveLoad::Message::Save");
  }

  OnEvent("Game::SaveLoad::Notify::SaveEnd")
  {
    Deactivate("Saving");

    If("$.quick")
    {
      Deactivate();
    }
  }

  OnEvent("QuickLoad")
  {
    Op("$.quick", "=", 1);
    SendNotifyEvent("", "Game::SaveLoad::Message::LoadRequest");
  }

  OnEvent("Game::SaveLoad::Notify::LoadFailed")
  {
    If("$.quick")
    {
      Op("$.quick", "=", 0);
      Activate();
    }
  }

  OnEvent("Game::SaveLoad::Notify::LoadProceed")
  {
    SendNotifyEvent("", "SaveLoad::LoadNow");
  }

  OnEvent("Game::SaveLoad::Notify::LoadConfirm")
  {
    If("$.quick")
    {
      SendNotifyEvent("", "SaveLoad::LoadNow");
    }
    Else()
    {
      MessageBox()
      {
        Title("#client.saveload.confirmload.title");
        Message("#client.saveload.confirmload.message");
        Button0("#std.buttons.ok", "SaveLoad::LoadNow");
        Button1("#std.buttons.cancel", "");
      }
    }
  }

  OnEvent("SaveLoad::LoadNow")
  {
    SendNotifyEvent("", "Game::SaveLoad::Message::Load");
  }

  OnEvent("Window::Notify::Deactivated")
  {
    Op("$.quick", "=", 0);
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Squad Control

ConfigureInterface()
{
  CreateColorGroup("InterfaceText", "Default")
  {
    NormalBg(128, 128, 128, 64);
    NormalFg(255, 128, 0, 220);
  }

  CreateColorGroup("InterfaceHiliteText", "Default")
  {
    NormalBg(128, 128, 128, 64);
    NormalFg(255, 255, 255, 220);
  }

  CreateColorGroup("PortraitButton", "Default")
  {
    NormalBg(255, 255, 255, 220);
    NormalFg(255, 255, 255, 220);
    DisabledFg(0, 0, 200, 150);
    HiLitedBg(255, 255, 255, 255);
    HilitedFg(255, 255, 255, 255);

  }

  CreateColorGroup("Squad::Default", "Sys::Texture")
  {
    SelectedTexture("if_Interface_game.tga", 209, 94, 47, 47);
    HilitedSelTexture("if_InterfaceAlpha_game.tga", 47, 52, 47, 47);
    NormalTexture("if_Interface_game.tga", 209, 0, 47, 47);
    HilitedTexture("if_Interface_game.tga", 209, 47, 47, 47);
    NormalBg(255, 255, 255, 255);
    AllFg(220, 220, 200, 255);
  }

  //
  // Shell Header text color group
  //

  CreateColorGroup("Game::SquadText", "Sys::Texture")
  {
    AllFg(220, 220, 200, 255);
    DisabledFg(255, 255, 255, 100);
  }

  DefineControlType("Squad", "Client::SquadControl")
  {
    Size(47, 47);
    Font("Debriefing");
    ColorGroup("Squad::Default");
    Number(6, 4);
    Health()
    {
      Point1(23, 8);
      Point2(38, 38);
    }
  }
}


//
// Squad Control
//
CreateControl("Client::SquadManager", "Window")
{
  Size(196, 55);
  Pos(-141, 0);
  Style("Transparent");
  Geometry("Bottom", "Right");
  Font("HeaderSmall");
  Skin("Game::SolidClient");

  CreateControl("Squad1", "Squad")
  {
    Text("#client.squad.1");
    Pos(4, 4);
    ClientId(1);
  }
  CreateControl("Squad2", "Squad")
  {
    Text("#client.squad.2");
    Pos(51, 4);
    ClientId(2);
  }
  CreateControl("Squad3", "Squad")
  {
    Text("#client.squad.3");
    Pos(98, 4);
    ClientId(3);
  }
  CreateControl("Squad4", "Squad")
  {
    Text("#client.squad.4");
    Pos(145, 4);
    ClientId(4);
  }

  CreateControl("SquadTitle", "Static")
  {
    Skin("Game::HeaderSquads");
    Geometry("Right", "Top");
    Size(128, 19);
    Pos(0, -19);
    Style("Transparent");

    CreateControl("SquadText", "Static")
    {
      Style("Transparent");
      Geometry("ParentHeight", "ParentWidth", "HCentre", "VCentre");
      Size(-6, -6);
      Font("HeaderSmall");
      ColorGroup("Game::HeaderTextAlpha");
      Text("#client.squad.title");
      TextOffset(-9, 0);
    }
  }

  CreateControl("SquadTextImage", "Static")
  {
    Geometry("Right");
    Size(20, 20);
    Pos(0, -20);
    ColorGroup("Sys::Texture");
    Image("if_interfacealpha_game.tga", 68, 107, 20, 20);
  }

}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// Shell templates and color groups
//

ConfigureInterface()
{
  //
  // Shell Header text color group
  //

  CreateColorGroup("Game::HeaderText")
  {
    AllFg(255, 255, 220, 255);
    DisabledFg(255, 255, 255, 120);
  }

  //
  // Shell Header text color group with Alpha
  //

  CreateColorGroup("Game::HeaderTextAlpha")
  {
    AllFg(255, 255, 220, 190);
    DisabledFg(255, 255, 255, 120);
  }

  //
  // Plastic text color
  //

  CreateColorGroup("Game::Plastic", "Sys::Texture")
  {
    AllFg(255, 255, 130, 255);
    DisabledFg(255, 255, 170, 100);
  }

  //
  // Electricity text color
  //

  CreateColorGroup("Game::Electricity", "Sys::Texture")
  {
    AllFg(130, 130, 255, 255);
    DisabledFg(170, 170, 255, 0);
  }

  //
  // Shell text color group
  //

  CreateColorGroup("Game::Text")
  {
    AllBg(255, 255, 255, 0);
    AllFg(220, 220, 170, 255);
  }

  //
  // Timer text color group
  //

  CreateColorGroup("Game::TimerText")
  {
    AllFg(255, 50, 0, 255);
  }

  //
  // Blocko Counter text color group
  //

  CreateColorGroup("Game::BlockoText")
  {
    AllFg(255, 200, 0, 255);
  }

  //
  // Shell edit text (with Selected State) color group
  //

  CreateColorGroup("Game::EditText")
  {
    NormalBg(255, 255, 255, 0);
    HilitedBg(255, 255, 0, 0);
    SelectedBg(255, 255, 0, 64);
    HilitedSelBg(255, 255, 0, 64);
    DisabledFg(255, 255, 255, 0);
    DisabledBg(255, 255, 255, 255);
    AllFg(220, 220, 170, 255);
  }

  CreateColorGroup("Game::TitleText", "Sys::Texture")
  {
    AllFg(196, 190, 171, 255);
  }

  DefineControlType("Game::BkgndTexture", "Static")
  {
    ColorGroup("Sys::Texture");
    Geometry("ParentWidth", "ParentHeight");
    Image()
    {
      Image("if_interface_bkgnd.tga");
      Mode("Tile");
    }
  }

  //
  // Border for mp selected state
  //
  CreateSkin("Game::SlotSelect")
  {
    Border()
    {
      Point1(0, 0);
      Point2(0, 0);
    }

    State("Selected", "HilitedSel")
    {
      ColorGroup("sys::texture");

      TopLeft()
      {
        Image("if_interface_game.tga", 82, 242, 3, 3);
      }
      Top()
      {
        Image("if_interface_game.tga", 85, 242, 9, 3);
      }
      TopRight()
      {
        Image("if_interface_game.tga", 94, 242, 3, 3);
      }
      Left()
      {
        Image("if_interface_game.tga", 82, 245, 3, 6);
      }
      Right()
      {
        Image("if_interface_game.tga", 94, 245, 3, 6);
      }
      BottomLeft()
      {
        Image("if_interface_game.tga", 82, 251, 3, 3);
      }
      Bottom()
      {
        Image("if_interface_game.tga", 85, 251, 9, 3);
      }
      BottomRight()
      {
        Image("if_interface_game.tga", 94, 251, 3, 3);
      }
    }
  }

  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Standard Shell Border (Cut into the background)
  //
  //

  CreateSkin("Game::CutInBorder")
  {
    Border()
    {
      Point1(1, 1);
      Point2(-1, -1);
    }

    State("All")
    {
      ColorGroup("sys::texture");

      TopLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 26, 6, 6);
      }
      Top()
      {
        Image("if_InterfaceAlpha_game.tga", 7, 26, 6, 6);
      }
      TopRight()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 26, 6, 6);
      }
      Left()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 32, 6, 6);
      }
      Right()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 32, 6, 6);
      }
      BottomLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 38, 6, 6);
      }
      Bottom()
      {
        Image("if_InterfaceAlpha_game.tga", 7, 38, 6, 6);
      }
      BottomRight()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 38, 6, 6);
      }
      Interior()
      {
        Image()
        {
          Image("if_InterfaceAlpha_game.tga", 7, 32, 6, 6);
          Mode("Stretch");
          Filter(0);
        }
      }
   }

    State("Disabled")
    {
      ColorGroup("sys::texture");

      TopLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 109, 6, 6);
      }
      Top()
      {
        Image("if_InterfaceAlpha_game.tga", 9, 109, 2, 3);
      }
      TopRight()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 109, 6, 7);
      }
      Left()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 117, 3, 2);
      }
      Right()
      {
        Image("if_InterfaceAlpha_game.tga", 16, 117, 3, 2);
      }
      BottomLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 121, 6, 6);
      }
      Bottom()
      {
        Image("if_InterfaceAlpha_game.tga", 9, 124, 2, 3);
      }
      BottomRight()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 121, 6, 6);
      }
      Interior()
      {
        Image()
        {
          Image("if_InterfaceAlpha_game.tga", 9, 116, 3, 3);
          Mode("Stretch");
          Filter(0);
        }
      }
   }
  }

  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Standard Shell Border (Raised Background)
  //
  //

  CreateSkin("Game::RaisedBorder")
  {
    State("All")
    {
      ColorGroup("sys::texture");

      TopLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 56, 1, 4, 4);
      }
      Top()
      {
        Image("if_InterfaceAlpha_game.tga", 58, 1, 2, 3);
      }
      TopRight()
      {
        Image("if_InterfaceAlpha_game.tga", 61, 1, 3, 3);
      }
      Left()
      {
        Image("if_InterfaceAlpha_game.tga", 56, 3, 3, 1);
      }
      Right()
      {
        Image("if_InterfaceAlpha_game.tga", 61, 4, 3, 1);
      }
      BottomLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 56, 5, 3, 3);
      }
      Bottom()
      {
        Image("if_InterfaceAlpha_game.tga", 59, 5, 2, 3);
      }
      BottomRight()
      {
        Image("if_InterfaceAlpha_game.tga", 61, 5, 3, 3);
      }
   }
  }

  // --------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Standard shell Listbox with slider configuration
  //
  //

  DefineControlType("Game::SliderListBox", "Listbox")
  {
    Skin("Game::SliderListBox");
    SliderConfig("Reg::Game::ListSlider");
    Style("Transparent");

    ItemConfig()
    {
      ColorGroup("Game::ListEntry");
      Font("System");
      Geometry("AutoSizeY", "ParentWidth");
      // Style("Transparent");
      TextOffset(1, 0);
      Size(-14, 0);
    }

    CreateControl("SliderBkgnd", "Static")
    {
      Geometry("Right", "ParentHeight");
      Size(10, -22);
      Pos(-3, 11);
      Image()
      {
        Image("if_interface_game.tga", 0, 0, 1, 1);
        Mode("Stretch");
        Filter(1);
      }
      CreateControl("SliderBkgndImageTop", "Static")
      {
        Geometry("Top");
        Size(10, 10);
        Image("if_interface_game.tga", 97, 1, 10, 10);
        ColorGroup("Sys::Texture");
      }
      CreateControl("SliderBkgndImageBottom", "Static")
      {
        Geometry("Bottom");
        Size(10, 10);
        Image("if_interface_game.tga", 97, 71, 10, 10);
        ColorGroup("Sys::Texture");
      }
      CreateControl("SliderBkgndImageBody", "Static")
      {
        Geometry("ParentHeight");
        Size(10, -20);
        Pos(0, 10);
        Image()
        {
          Image("if_interface_game.tga", 97, 11, 10, 60);
          Mode("Stretch");
        }
        ColorGroup("Sys::Texture");
      }
    }
  }

  //
  // Up arrow button
  //
  CreateColorGroup("Game::UpArrowButton", "Sys::Texture")
  {
    AllTextures("if_Interface_game.tga", 20, 52, 10, 10);
    HilitedTexture("if_Interface_game.tga", 30, 52, 10, 10);
    HilitedSelTexture("if_Interface_game.tga", 40, 52, 10, 10);
  }

  //
  // Down arrow button
  //
  CreateColorGroup("Game::DownArrowButton", "Sys::Texture")
  {
    AllTextures("if_Interface_game.tga", 51, 52, 10, 10);
    HilitedTexture("if_Interface_game.tga", 61, 52, 10, 10);
    HilitedSelTexture("if_Interface_game.tga", 71, 52, 10, 10);
    DisabledBg(255, 255, 255, 255);
  }

  //
  // List Entry
  //
  CreateColorGroup("Game::ListEntry")
  {
    NormalBg(255, 255, 255, 0);
    HilitedBg(255, 255, 0, 32);
    SelectedBg(255, 255, 0, 64);
    HilitedSelBg(255, 255, 0, 64);
    DisabledBg(255, 255, 255, 0);
    NormalFg(220, 220, 170, 255);
    HilitedFg(255, 255, 220, 255);
    SelectedFg(255, 255, 180, 255);
    HilitedSelFg(255, 255, 180, 255);
    DisabledFg(255, 255, 100, 0);
  }

  CreateSkin("Game::VListSlider")
  {
    ColorGroup("Sys::Texture");

    Border()
    {
      Point1(2, 13);
      Point2(-2, -13);
    }

    State("All")
    {
      Interior()
      {
        Image()
        {
          Image("if_interface_game.tga", 14, 14, 1, 1);
          Mode("Stretch");
          Filter(1);
        }
      }
    }
  }

  //
  //
  // Slider thumb
  //
  //

  CreateSkin("Game::SliderThumbSkin")
  {
    State("All")
    {
      ColorGroup("sys::texture");

      Top()
      {
        Image("if_interface_game.tga", 108, 1, 4, 4);
      }

      Bottom()
      {
        Image("if_interface_game.tga", 108, 77, 4, 4);
      }

      Interior()
      {
        Image()
        {
          Image("if_interface_game.tga", 108, 5, 4, 72);
          Mode("Stretch");
      //    Filter(1);
        }
      }

    }

    State("Hilited", "Selected", "HilitedSel")
    {
      ColorGroup("sys::texture");

      Top()
      {
        Image("if_interface_game.tga", 113, 1, 4, 4);
      }

      Bottom()
      {
        Image("if_interface_game.tga", 113, 77, 4, 4);
      }

      Interior()
      {
        Image()
        {
          Image("if_interface_game.tga", 113, 5, 4, 72);
          Mode("Stretch");
      //    Filter(1);
        }
      }
    }
  }

  //
  // Listbox skin
  //
  CreateSkin("Game::SliderListbox")
  {
    Border()
    {
      Point1(3, 2);
      Point2(0, -2);
    }

    State("All")
    {
      ColorGroup("sys::texture");

      TopLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 26, 6, 6);
      }
      Top()
      {
        Image("if_InterfaceAlpha_game.tga", 7, 26, 6, 6);
      }
      TopRight()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 26, 6, 6);
      }
      Left()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 32, 6, 6);
      }
      Right()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 32, 6, 6);
      }
      BottomLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 38, 6, 6);
      }
      Bottom()
      {
        Image("if_InterfaceAlpha_game.tga", 7, 38, 6, 6);
      }
      BottomRight()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 38, 6, 6);
      }
      Interior()
      {
        Image()
        {
          Image("if_InterfaceAlpha_game.tga", 7, 32, 6, 6);
          Mode("Stretch");
          Filter(0);
        }
      }
   }

  }

  //
  // Slider thumb button
  //
  CreateRegData("Reg::Game::SliderThumb")
  {
    ThumbButtonConfig("SliderThumb")
    {
      Size(0, 10);
      Pos(1, 0);
      Geometry("ParentWidth");
      Skin("Game::SliderThumbSkin");
      Style("!DropShadow", "!VGradient", "SelectWhenDown");
      ColorGroup("Sys::Texture");
    }
  }

  //
  // List box slider
  //
  CreateRegData("Reg::Game::ListSlider")
  {
    SliderConfig("ListSlider")
    {
      Geometry("ParentHeight", "WinRight");
      Size(8, -2);
      Pos(-4, 1);
      Skin("Game::VListSlider");
      Style("!DropShadow");
      Orientation("Vertical");

      DecButtonConfig("Reg::Game::UpArrowButton");
      IncButtonConfig("Reg::Game::DownArrowButton");
      ThumbConfig("Reg::Game::SliderThumb");
    }
  }

  //
  // Up arrow slider button
  //

  CreateRegData("Reg::Game::UpArrowButton")
  {
    DecButtonConfig("SysBtnUp")
    {
      Size(10, 10);
      Pos(0, 0);
      Geometry("WinTop", "WinHCentre");
      ColorGroup("Game::UpArrowButton");
      Style("!CodeDrawn", "!DropShadow", "!VGradient", "SelectWhenDown");
    }
  }

  //
  // Down arrow slider button
  //

  CreateRegData("Reg::Game::DownArrowButton")
  {
    DecButtonConfig("SysBtnDown")
    {
      Size(10, 10);
      Pos(0, 0);
      Geometry("WinBottom", "WinHCentre");
      ColorGroup("Game::DownArrowButton");
      Style("!CodeDrawn", "!DropShadow", "!VGradient", "SelectWhenDown");
    }
  }

  // --------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Standard SaveGame Listbox (no slider)
  //
  //

  DefineControlType("Game::SaveGameListBox", "Listbox")
  {
    Style("Transparent");

    ItemConfig()
    {
      Skin("Game::Panel");
      ColorGroup("Game::ListEntry");
      Font("System");
      Geometry("ParentWidth");
      TextOffset(1, 0);
      Size(-4, 20);
    }
  }

  // --------------------------------------------------------------------------------------------------------------------------------------------
  //
  //  Standard Shell Button Config
  //
  //

  //
  // Shell Button template
  //
  DefineControlType("Game::Button", "Button")
  {
    Skin("Game::Button");
    ColorGroup("Game::ButtonColor");
    Style("!VGradient", "!DropShadow", "Transparent", "SelectWhenDown");
  }

  //
  // Button text color group
  //

  CreateColorGroup("Game::ButtonColor")
  {
    AllBg(255, 255, 255, 255);
    AllBg(255, 255, 255, 255);
    NormalFg(220, 220, 170, 255);
    HilitedFg(255, 255, 220, 255);
    SelectedFg(255, 255, 220, 255);
    DisabledFg(220, 220, 170, 128);
    HilitedSelFg(255, 255, 220, 255);
    DisabledBg(255, 255, 255, 255);
    SelectedOffset(1, 1);
    SelHilitedOffset(1, 1);
  }

  //
  //  Standard shell button skin
  //

  CreateSkin("Game::Button")
  {
    State("All")
    {
      ColorGroup("Game::ButtonColor");

      TopLeft()
      {
        Image("if_Interface_game.tga", 1, 71, 4, 4);
      }
      Top()
      {
        Image("if_interface_game.tga", 8, 71, 4, 4);
      }
      TopRight()
      {
        Image("if_interface_game.tga", 20, 71, 6, 5);
      }
      Left()
      {
        Image("if_interface_game.tga", 1, 77, 4, 4);
      }
      Right()
      {
        Image("if_interface_game.tga", 22, 77, 4, 4);
      }
      BottomLeft()
      {
        Image("if_interface_game.tga", 1, 86, 5, 6);
      }
      Bottom()
      {
        Image("if_interface_game.tga", 8, 88, 4, 4);
      }
      BottomRight()
      {
        Image("if_interface_game.tga", 20, 86, 6, 6);
      }

      Interior()
      {
        Image()
        {
          Image("if_interfacealpha_game.tga", 7, 32, 6, 6);
          Mode("Stretch");
          Filter(1);
          Pos(4, 4);
          Size(-8, -8);
        }
      }
    }

    State("Hilited")
    {
      ColorGroup("Game::ButtonColor");

      TopLeft()
      {
        Image("if_interface_game.tga", 27, 71, 4, 4);
      }
      Top()
      {
        Image("if_interface_game.tga", 35, 71, 4, 4);
      }
      TopRight()
      {
        Image("if_interface_game.tga", 46, 71, 6, 5);
      }
      Left()
      {
        Image("if_interface_game.tga", 27, 77, 4, 4);
      }
      Right()
      {
        Image("if_interface_game.tga", 48, 77, 4, 4);
      }
      BottomLeft()
      {
        Image("if_interface_game.tga", 27, 86, 5, 6);
      }
      Bottom()
      {
        Image("if_interface_game.tga", 36, 88, 4, 4);
      }
      BottomRight()
      {
        Image("if_interface_game.tga", 46, 86, 6, 6);
      }

      Interior()
      {
        Image()
        {
          Image("if_interfacealpha_game.tga", 21, 10, 6, 6);
          Mode("Stretch");
          Filter(1);
          Pos(4, 4);
          Size(-8, -8);
        }
      }
    }

    // For selected and hilitedsel states
    State("Selected", "HilitedSel")
    {
      ColorGroup("Game::ButtonColor");

      TopLeft()
      {
        Image("if_interface_game.tga", 53, 71, 5, 5);
      }
      Top()
      {
        Image("if_interface_game.tga", 61, 71, 5, 5);
      }
      TopRight()
      {
        Image("if_interface_game.tga", 73, 71, 5, 5);
      }
      Left()
      {
        Image("if_interface_game.tga", 53, 77, 5, 5);
      }
      Right()
      {
        Image("if_interface_game.tga", 74, 77, 4, 4);
      }
      BottomLeft()
      {
        Image("if_interface_game.tga", 53, 87, 5, 5);
      }
      Bottom()
      {
        Image("if_interface_game.tga", 62, 88, 4, 4);
      }
      BottomRight()
      {
        Image("if_interface_game.tga", 72, 86, 6, 6);
      }

      Interior()
      {
        Image()
        {
          Image("if_interfacealpha_game.tga", 21, 10, 6, 6);
          Mode("Stretch");
          Filter(1);
          Pos(6, 6);
          Size(-10, -10);
        }
      }
    }
    // For disabled state

    State("Disabled")
    {
      ColorGroup("Game::ButtonColor");

      TopLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 109, 6, 6);
      }
      Top()
      {
        Image("if_InterfaceAlpha_game.tga", 9, 109, 2, 3);
      }
      TopRight()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 109, 6, 7);
      }
      Left()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 117, 3, 2);
      }
      Right()
      {
        Image("if_InterfaceAlpha_game.tga", 16, 117, 3, 2);
      }
      BottomLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 1, 121, 6, 6);
      }
      Bottom()
      {
        Image("if_InterfaceAlpha_game.tga", 9, 124, 2, 3);
      }
      BottomRight()
      {
        Image("if_InterfaceAlpha_game.tga", 13, 121, 6, 6);
      }
      Interior()
      {
        Image()
        {
          Image("if_InterfaceAlpha_game.tga", 9, 116, 3, 3);
          Mode("Stretch");
          Filter(0);
        }
      }

    }
  }

  // ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //  Decorative Panelling
  //

  CreateSkin("Game::Panel")
  {

    State("All")
    {
      ColorGroup("Sys::Texture");

      TopLeft()
      {
        Image("if_interfacealpha_game.tga", 0, 0, 3, 3);
      }
      Top()
      {
        Image("if_interfacealpha_game.tga", 2, 0, 1, 2);
      }
      TopRight()
      {
        Image("if_interfacealpha_game.tga", 3, 0, 3, 3);
      }
      Left()
      {
        Image("if_interfacealpha_game.tga", 0, 2, 2, 1);
      }
      Right()
      {
        Image("if_interfacealpha_game.tga", 4, 2, 2, 1);
      }
      BottomLeft()
      {
        Image("if_interfacealpha_game.tga", 0, 3, 3, 3);
      }
      Bottom()
      {
        Image("if_interfacealpha_game.tga", 2, 4, 1, 2);
      }
      BottomRight()
      {
        Image("if_interfacealpha_game.tga", 3, 3, 3, 3);
      }
    }
  }

  CreateSkin("Game::DarkPanel", "Game::Panel")
  {
    Border()
    {
      Point1(1, 1);
      Point2(-2, -2);
    }

    State("All")
    {
      Interior()
      {
        Image()
        {
          Image("if_InterfaceAlpha_game.tga", 7, 32, 6, 6);
          Mode("Stretch");
          Filter(0);
        }
      }
    }
  }

  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Shell Drop list minus the listbox config
  //
  //
  CreateRegData("Reg::Game::DropList")
  {
    Skin("Game::SolidClient");

    Container()
    {
      Geometry("Left", "Bottom", "VExternal", "HInternal", "AlignToWidth");
      Style("Transparent");
    }
    DropButton("SysBtnDropList")
    {
      Size(1, 1);
      Geometry("Right", "VCentre");
      Style("!CodeDrawn", "!DropShadow", "!VGradient", "SelectWhenDown", "Transparent");
    }
    Current("Button")
    {
      Geometry("ParentWidth", "ParentHeight");
      ColorGroup("Game::ButtonColor");
      Style("Transparent", "!DropShadow");
      Font("System");
      JustifyText("Centre");
      TextOffset(-1, 0);
    }
  }


  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Shell Default Client border
  //
  //

  CreateSkin("Game::Client")
  {

    State("All")
    {
      ColorGroup("Sys::Texture");

      TopLeft()
      {
        Image("if_interfacealpha_game.tga", 10, 8, 3, 3);
      }
      Top()
      {
        Image("if_interfacealpha_game.tga", 14, 8, 1, 3);
      }
      TopRight()
      {
        Image("if_interfacealpha_game.tga", 17, 8, 3, 3);
      }
      Left()
      {
        Image("if_interfacealpha_game.tga", 10, 12, 3, 1);
      }
      Right()
      {
        Image("if_interfacealpha_game.tga", 17, 12, 3, 1);
      }
      BottomLeft()
      {
        Image("if_interfacealpha_game.tga", 10, 14, 4, 4);
      }
      Bottom()
      {
        Image("if_interfacealpha_game.tga", 15, 15, 1, 3);
      }
      BottomRight()
      {
        Image("if_interfacealpha_game.tga", 17, 15, 3, 3);
      }
    }
  }

  CreateSkin("Game::SolidClient", "Game::Client")
  {
    State("All")
    {
      Interior()
      {
        Image()
        {
          Image("if_interface_bkgnd.tga");
          Mode("Tile");
        }
      }
    }
  }

  CreateSkin("Game::SolidClientListBox")
  {
    Border()
    {
      Point1(3, 3);
      Point2(-3, -3);
    }

    State("All")
    {
      ColorGroup("Sys::Texture");

      TopLeft()
      {
        Image("if_interface_game.tga", 2, 51, 3, 3);
      }
      Top()
      {
        Image("if_interface_game.tga", 5, 51, 1, 3);
      }
      TopRight()
      {
        Image("if_interface_game.tga", 7, 51, 3, 3);
      }
      Left()
      {
        Image("if_interface_game.tga", 2, 54, 3, 1);
      }
      Right()
      {
        Image("if_interface_game.tga", 7, 54, 3, 1);
      }
      BottomLeft()
      {
        Image("if_interface_game.tga", 2, 55, 3, 3);
      }
      Bottom()
      {
        Image("if_interface_game.tga", 6, 55, 1, 3);
      }
      BottomRight()
      {
        Image("if_interface_game.tga", 7, 55, 3, 3);
      }

      Interior()
      {
        Image()
        {
          Image("if_interface_bkgnd.tga");
          Mode("Tile");
        }
      }

    }

  }

  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Shell Default Client border with background - with no bottom border texture
  //
  //

  CreateSkin("Game::SolidClientNoBottom")
  {
    ColorGroup("Sys::Texture");

    State("All")
    {
      ColorGroup("Sys::Texture");

      TopLeft()
      {
        Image("if_interfacealpha_game.tga", 10, 8, 3, 3);
      }
      Top()
      {
        Image("if_interfacealpha_game.tga", 14, 8, 1, 3);
      }
      TopRight()
      {
        Image("if_interfacealpha_game.tga", 17, 8, 3, 3);
      }
      Left()
      {
        Image("if_interfacealpha_game.tga", 10, 12, 3, 1);
      }
      Right()
      {
        Image("if_interfacealpha_game.tga", 17, 12, 3, 1);
      }
      Interior()
      {
        Image()
        {
          Image("if_interface_bkgnd.tga");
          Mode("Tile");
        }
      }

    }
  }

  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Shell Default Client border with background - with no top border texture
  //
  //

  CreateSkin("Game::SolidClientNoTop")
  {
    ColorGroup("Sys::Texture");

    State("All")
    {
      ColorGroup("Sys::Texture");

      Left()
      {
        Image("if_interfacealpha_game.tga", 10, 12, 3, 1);
      }
      Right()
      {
        Image("if_interfacealpha_game.tga", 17, 12, 3, 1);
      }
      BottomLeft()
      {
        Image("if_interfacealpha_game.tga", 10, 14, 4, 4);
      }
      Bottom()
      {
        Image("if_interfacealpha_game.tga", 15, 15, 1, 3);
      }
      BottomRight()
      {
        Image("if_interfacealpha_game.tga", 17, 15, 3, 3);
      }
      Interior()
      {
        Image()
        {
          Image("if_interface_bkgnd.tga");
          Mode("Tile");
        }
      }

    }
  }

  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Game border for headers - Minimap...both ends
  //
  //

  CreateSkin("Game::Header")
  {
    Border()
    {
      Point1(23, 0);
      Point2(-23, 0);
    }

    State("All")
    {
      ColorGroup("Sys::Texture");

      TopLeft()
      {
        Image("if_interfacealpha_game.tga", 73, 27, 24, 19);
      }
      Top()
      {
        Image("if_interfacealpha_game.tga", 73, 23, 22, 4);
      }
      TopRight()
      {
        Image("if_interfacealpha_game.tga", 71, 1, 24, 19);
      }
      Interior()
      {
        Image()
        {
          Image("if_InterfaceAlpha_game.tga", 7, 32, 6, 6);
          Mode("Stretch");
          Filter(0);
        }
      }

    }
  }

  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Game border for headers - Squads...no right end
  //
  //

  CreateSkin("Game::HeaderSquads")
  {
    Border()
    {
      Point1(23, 0);
      Point2(0, 0);
    }

    State("All")
    {
      ColorGroup("Sys::Texture");

      TopLeft()
      {
        Image("if_interfacealpha_game.tga", 73, 27, 24, 19);
      }
      Top()
      {
        Image("if_interfacealpha_game.tga", 73, 23, 22, 4);
      }
      Interior()
      {
        Image()
        {
          Image("if_InterfaceAlpha_game.tga", 7, 32, 6, 6);
          Mode("Stretch");
          Filter(0);
        }
      }

    }
  }

  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Game border for header - Construction - no left end
  //
  //

  CreateSkin("Game::HeaderConstruction")
  {
    Border()
    {
      Point1(0, 0);
      Point2(-23, 0);
    }

    State("All")
    {
      ColorGroup("Sys::Texture");

      Top()
      {
        Image("if_interfacealpha_game.tga", 73, 23, 22, 4);
      }
      TopRight()
      {
        Image("if_interfacealpha_game.tga", 71, 1, 24, 19);
      }
      Interior()
      {
        Image()
        {
          Image("if_InterfaceAlpha_game.tga", 7, 32, 6, 6);
          Mode("Stretch");
          Filter(0);
        }
      }

    }
  }

  //
  //
  // Droplist Listbox
  //
  //

  DefineControlType("Game::DropListBox", "Listbox")
  {
    Pos(0, -1);
    Skin("Game::SolidClientListBox");
    SliderConfig("Reg::Game::ListSlider");
    Style("Transparent");

    ItemConfig()
    {
      ColorGroup("Game::ListEntry");
      Font("System");
      Geometry("AutoSizeY", "ParentWidth");
      // Style("Transparent");
      TextOffset(3, 0);
      Size(-10, 0);
    }

    CreateControl("SliderBkgnd", "Static")
    {
      Geometry("Right", "ParentHeight");
      Size(10, -22);
      Pos(0, 11);
      Image()
      {
        Image("if_interface_game.tga", 0, 0, 1, 1);
        Mode("Stretch");
        Filter(1);
      }
      CreateControl("SliderBkgndImageTop", "Static")
      {
        Geometry("Top");
        Size(10, 10);
        Image("if_interface_game.tga", 97, 1, 10, 10);
        ColorGroup("Sys::Texture");
      }
      CreateControl("SliderBkgndImageBottom", "Static")
      {
        Geometry("Bottom");
        Size(10, 10);
        Image("if_interface_game.tga", 97, 71, 10, 10);
        ColorGroup("Sys::Texture");
      }
      CreateControl("SliderBkgndImageBody", "Static")
      {
        Geometry("ParentHeight");
        Size(10, -20);
        Pos(0, 10);
        Image()
        {
          Image("if_interface_game.tga", 97, 11, 10, 60);
          Mode("Stretch");
        }
        ColorGroup("Sys::Texture");
      }
    }
  }

  // -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Shell Horizontal slider bar
  //
  //

  DefineControlType("Game::HSlider", "Slider")
  {
    Skin("Game::CutInBorder");
    Style("NoDrawClient");
    ThumbConfig("Reg::Game::HSliderThumb");
  }

  //
  // Horizntal Slider thumb button
  //

  CreateRegData("Reg::Game::HSliderThumb")
  {
    ThumbButtonConfig("SliderThumb")
    {
      Skin("Game::HSliderThumbSkin");
      Geometry("ParentHeight", "ParentWidth", "Square");
      Style("!DropShadow", "!VGradient", "SelectWhenDown");
    }
  }

  //
  //
  // Horizontal Slider thumb Skin
  //
  //

  CreateSkin("Game::HSliderThumbSkin")
  {

    Border()
    {
      Point1(3, 2);
      Point2(-3, -2);
    }

    State("All")
    {
      ColorGroup("sys::texture");

      TopLeft()
      {
        Image("if_interface_game.tga", 1, 35, 3, 2);
      }

      Top()
      {
        Image("if_interface_game.tga", 4, 35, 9, 2);
      }

      TopRight()
      {
        Image("if_interface_game.tga", 13, 35, 3, 2);
      }

      Right()
      {
        Image("if_interface_game.tga", 13, 37, 3, 11);
      }

      Left()
      {
        Image("if_interface_game.tga", 1, 37, 3, 11);
      }

      Bottom()
      {
        Image("if_interface_game.tga", 4, 48, 9, 2);
      }

      BottomLeft()
      {
        Image("if_interface_game.tga", 1, 48, 3, 2);
      }

      BottomRight()
      {
        Image("if_interface_game.tga", 13, 48, 3, 2);
      }

      Interior()
      {
        Image()
        {
          Image("if_interface_game.tga", 4, 37, 7, 9);
        }
      }
    }

    State("Hilited", "Selected", "HilitedSel")
    {
      ColorGroup("sys::texture");

      TopLeft()
      {
        Image("if_interface_game.tga", 17, 35, 3, 2);
      }

      Top()
      {
        Image("if_interface_game.tga", 20, 35, 9, 2);
      }

      TopRight()
      {
        Image("if_interface_game.tga", 29, 35, 3, 2);
      }

      Right()
      {
        Image("if_interface_game.tga", 29, 37, 3, 11);
      }

      Left()
      {
        Image("if_interface_game.tga", 17, 37, 3, 11);
      }

      Bottom()
      {
        Image("if_interface_game.tga", 20, 48, 9, 2);
      }

      BottomLeft()
      {
        Image("if_interface_game.tga", 17, 48, 3, 2);
      }

      BottomRight()
      {
        Image("if_interface_game.tga", 29, 48, 3, 2);
      }

      Interior()
      {
        Image()
        {
          Image("if_interface_game.tga", 20, 37, 7, 9);
        }
      }
    }
  }

  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //
  // Campaign Slot Border
  //
  //

  CreateSkin("Game::CampaignSlotBorder")
  {
    State("All")
    {
      ColorGroup("sys::texture");

      TopLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 56, 1, 4, 4);
      }
      Top()
      {
        Image("if_InterfaceAlpha_game.tga", 58, 1, 2, 3);
      }
      TopRight()
      {
        Image("if_InterfaceAlpha_game.tga", 61, 1, 3, 3);
      }
      Left()
      {
        Image("if_InterfaceAlpha_game.tga", 56, 3, 3, 1);
      }
      Right()
      {
        Image("if_InterfaceAlpha_game.tga", 61, 4, 3, 1);
      }
      BottomLeft()
      {
        Image("if_InterfaceAlpha_game.tga", 56, 5, 3, 3);
      }
      Bottom()
      {
        Image("if_InterfaceAlpha_game.tga", 59, 5, 2, 3);
      }
      BottomRight()
      {
        Image("if_InterfaceAlpha_game.tga", 61, 5, 3, 3);
      }
    }

    State("Disabled")
    {
      ColorGroup("Sys::Texture");

      TopLeft()
      {
        Image("if_interfacealpha_game.tga", 32, 8, 3, 3);
      }
      Top()
      {
        Image("if_interfacealpha_game.tga", 34, 8, 1, 2);
      }
      TopRight()
      {
        Image("if_interfacealpha_game.tga", 35, 8, 3, 3);
      }
      Left()
      {
        Image("if_interfacealpha_game.tga", 32, 10, 2, 1);
      }
      Right()
      {
        Image("if_interfacealpha_game.tga", 36, 10, 2, 1);
      }
      BottomLeft()
      {
        Image("if_interfacealpha_game.tga", 32, 11, 3, 3);
      }
      Bottom()
      {
        Image("if_interfacealpha_game.tga", 34, 12, 1, 2);
      }
      BottomRight()
      {
        Image("if_interfacealpha_game.tga", 35, 11, 3, 3);
      }
    }

  }

  //
  // Messagebox window
  //
  DefineControlType("Std::MessageBox::Window", "MessageBoxWindow")
  {
    Skin("Game::SolidClient");
    Style("Transparent", "Titlebar", "Modal", "NoSysButtons", "AdjustWindow");
    Geometry("HCentre", "VCentre");
    Font("System");
    TitleBarConfig("Reg::Game::WindowTitle");

    CreateControl("Panel", "Static")
    {
      Skin("Game::Panel");
      Geometry("ParentWidth", "ParentHeight", "VCentre", "HCentre");
      Style("Transparent");
      Size(-10, -10);

      CreateControl("RivetTL", "Static")
      {
        Pos(3, 3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetTR", "Static")
      {
        Geometry("Right");
        Pos(-3, 3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetBR", "Static")
      {
        Geometry("Bottom", "Right");
        Pos(-3, -3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetBL", "Static")
      {
        Geometry("Bottom");
        Pos(3, -3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }
    }
  }

  //
  // Messagebox text
  //
  DefineControlType("Std::MessageBox::Text", "Static")
  {
    ColorGroup("Game::Text");
    Font("System");
    Style("Transparent");
    Geometry("HCentre", "ParentWidth", "AutoSizeY");
    Size(-12, 0);
  }

  //
  // Messagebox button
  //
  DefineControlType("Std::MessageBox::Button", "Button")
  {
    ReadTemplate("Game::Button");
    Font("System");
    Size(80, 25);
    Pos(0, 2);
  }

  //
  // Window title - appears at the top of a window, duh!
  //
  CreateRegData("Reg::Game::WindowTitle")
  {
    TitleBarConfig("WindowTitle")
    {
      Skin("Game::Header");
      Font("HeaderSmall");
      Geometry("HCentre", "ParentWidth");
      Style("Transparent");
      ColorGroup("Game::HeaderText");
      JustifyText("Centre");
      TextOffset(0, 2);
      Size(-10, 19);
      Pos(0, -19);
    }
  }
}///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//
// In-game configuration
//
// Optional to include room for future mods :)
//

#optional "if_game_mp3player.cfg"
#optional "if_game_bigmap.cfg"
#optional "if_game_keybind_quickchat.cfg"///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Unit Context Menu

ConfigureInterface()
{
  CreateColorGroup("Client::ContextButton", "Sys::Texture")
  {
    AllFg(255, 255, 220, 255);
    NormalTexture("if_interface_game.tga", 3, 162, 32, 32);
    HilitedTexture("if_interface_game.tga", 36, 162, 32, 32);
    SelectedTexture("if_interface_game.tga", 69, 162, 32, 32);
    HilitedSelTexture("if_interface_game.tga", 69, 162, 32, 32);
    DisabledTexture("if_interface_game.tga", 69, 162, 32, 32);
  }

  DefineControlType("Client::ContextButton", "Client::UnitContextButton")
  {
    ColorGroup("Client::ContextButton");
    Style("!DropShadow", "!VGradient", "SelectWhenDown");
    Size(32, 32);
  }
}

CreateControl("Client::Context", "Client::UnitContext")
{
  Geometry("Right");
  Size(32, 32);
  Pos(-10, 70);

  CreateControl("Text", "Static")
  {
    Size(100, 20);
    Style("Transparent");
    Geometry("VCentre", "Right");
    Pos(0, 25);
    TextOffset(-4, 0);
    ColorGroup("Game::HeaderText");
    Font("HeaderSmall");
    JustifyText("Right");
    Text("#game.client.context.recycle");
  }

  CreateControl("Recycle", "Client::ContextButton")
  {
    Context("Recycle");
    Event("de::recycle");
  }
}
///////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//

// Popup mesh window - cost, name, prereqs...

ConfigureInterface()
{
  CreateColorGroup("Client::UnitDisplay::Darken", "Sys::Texture")
  {
    AllBg(245, 245, 245, 255);
  }

  CreateColorGroup("Client::InfantryGauge", "Sys::Texture")
  {
    AllFg(255, 100, 100, 130);
    AllBg(255, 100, 100, 130);
  }

  CreateColorGroup("Client::ArmorGauge", "Sys::Texture")
  {
    AllFg(255, 255, 100, 130);
    AllBg(255, 255, 100, 130);
  }

  CreateColorGroup("Client::AirGauge", "Sys::Texture")
  {
    AllFg(100, 100, 255, 130);
    AllBg(100, 100, 255, 130);
  }

  CreateColorGroup("Client::Electricity", "Sys::Texture")
  {
    NormalTexture("if_Interface_game.tga", 146, 33, 26, 26);
    DisabledTexture("if_Interface_game.tga", 150, 3, 26, 26);
    DisabledBg(255, 255, 255, 255);
    DisabledFg(255, 255, 255, 0);
  }

  CreateColorGroup("Client::Firepower", "Sys::Texture")
  {
    DisabledBg(255, 255, 255, 100);
    DisabledFg(255, 255, 255, 100);
  }

  CreateColorGroup("MeshView::Disable")
  {
    AllFg(0, 0, 0, 64);
    AllBg(255, 0, 0, 64);
  }

  CreateColorGroup("MeshView::Unavailable")
  {
    AllFg(255, 50, 50, 255);
    AllBg(255, 0, 0, 0);
  }

  CreateColorGroup("Game::UpgradeTextColor")
  {
    AllBg(255, 255, 255, 0);
    AllFg(220, 220, 170, 200);
    DisabledFg(255, 25, 25, 128);
  }

}

CreateControl("Client::UnitDisplay", "Client::UnitDisplay")
{
  Skin("Game::SolidClient");
  ColorGroup("Sys::Texture");
  Geometry("Bottom");
  Size(134, 323);
  Pos(75, -89);
  Style("Transparent");

  MaxThreat(46);

  CreateControl("Name", "Static")
  {
    Skin("Game::Header");
    Font("HeaderSmall");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    ColorGroup("Game::HeaderText");
    JustifyText("Centre");
    TextOffset(0, 2);
    Size(34, 19);
    Pos(0, -19);
    UseVar("$<.Description");
    CreateControl("DropShadowBR", "Static")
    {
      Image("if_interfacealpha_game.tga", 4, 6, 3, 3);
      ColorGroup("Sys::Texture");
      Geometry("Right", "Bottom");
      Size(3, 3);
      Pos(10, 3);
    }
    CreateControl("DropShadowBL", "Static")
    {
      Image("if_interfacealpha_game.tga", 2, 12, 3, 3);
      ColorGroup("Sys::Texture");
      Geometry("Bottom");
      Size(3, 3);
      Pos(-9, 3);
    }
  }

  CreateControl("MeshPanel", "Static")
  {
    Skin("Game::DarkPanel");
    Style("Transparent");
    Geometry("HCentre");
    Pos(0, 23);
    Size(88, 88);

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

  }

  CreateControl("MeshBackground", "Static")
  {
    Size(120, 120);
    Pos(0, 7);
    Geometry("HCentre", "Top");
    //ColorGroup("Sys::Texture");
    Skin("Game::CutInBorder");
    Style("Transparent");
  }

  CreateControl("MeshView", "Mesh")
  {
    Size(116, 116);
    Pos(0, 9);
    Geometry("HCentre", "Top");

    Animation("Move");
    SunVector(1, -1, -1);
    SunColor(255, 255, 255);
    AmbientColor(220, 220, 220);
    TeamColor(13, 136, 0);
    RotateRate(145);
    HeightModifier(1.3);
    DistanceModifier(1.2);

    CreateControl("Disable", "Static")
    {
      Pos(-1, 0);
      Geometry("ParentWidth", "ParentHeight");
      Size(1, 0);
      ColorGroup("MeshView::Disable");

      CreateControl("DisableText", "Static")
      {
        Font("HeaderSmall");
        ColorGroup("MeshView::Unavailable");
        Geometry("HCentre", "VCentre", "ParentWidth");
        Style("Transparent");
        Size(0, 12);
        Text("#client.unitdisplay.unavailable");
      }
    }
  }

  CreateControl("UpgradeText", "Static")
  {
    Font("HeaderSmall");
    ColorGroup("Game::UpgradeTextColor");
    Geometry("HCentre");
    Style("Transparent", "NoAutoActivate");
    Pos(0, 8);
    Size(100, 10);
    Text("#client.unitdisplay.upgrade");
  }

  CreateControl("CostPanel", "Static")
  {
    Skin("Game::Panel");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    Pos(0, 128);
    Size(-14, 72);

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

  }

  CreateControl("JoinerTop", "Static")
  {
    ColorGroup("Sys::Texture");
    Size(20, 32);
    Pos(-20, 49);
    Image("if_interface_game.tga", 154, 61, 20, 32);

    CreateControl("DropShadowB", "Static")
    {
      Image()
      {
        Image("if_interfacealpha_game.tga", 2, 6, 1, 3);
        Mode("Stretch");
        Filter(0);
      }
      ColorGroup("Sys::Texture");
      Geometry("Bottom", "ParentWidth");
      Size(0, 3);
      Pos(0, 2);
    }
  }

  CreateControl("JoinerBottom", "Static")
  {
    ColorGroup("Sys::Texture");
    Size(20, 32);
    Pos(-20, 242);
    Image("if_interface_game.tga", 154, 61, 20, 32);

    CreateControl("DropShadowB", "Static")
    {
      Image()
      {
        Image("if_interfacealpha_game.tga", 2, 6, 1, 3);
        Mode("Stretch");
        Filter(0);
      }
      ColorGroup("Sys::Texture");
      Geometry("Bottom", "ParentWidth");
      Size(0, 3);
      Pos(0, 2);
    }
  }

  CreateControl("CostName", "Static")
  {
    Font("HeaderSmall");
    Geometry("ParentWidth");
    JustifyText("Centre");
    ColorGroup("Game::HeaderText");
    Style("Transparent");
    Pos(0, 129);
    Size(0, 15);
    TextOffset(1, 0);
    Text("#client.unitdisplay.cost");
  }

  CreateControl("PCost", "Static")
  {
    Font("HeaderSmall");
    JustifyText("Centre");
    Skin("Game::CutInBorder");
    ColorGroup("Game::Plastic");
    Style("Transparent");
    Size(65, 20);
    Pos(46, 147);
    UseVar("$<.Plastic");
  }

  CreateControl("PCostIcon", "Static")
  {
    ColorGroup("Sys::Texture");
    Image("if_Interface_game.tga", 119, 33, 26, 26);
    Size(26, 26);
    Pos(19, 144);
  }

  CreateControl("ECost", "Static")
  {
    Font("HeaderSmall");
    JustifyText("Centre");
    Skin("Game::CutInBorder");
    ColorGroup("Game::Electricity");
    Size(65, 20);
    Pos(46, 173);
    Style("Transparent");
    UseVar("$<.Electricity");
  }

  CreateControl("ECostIcon", "Static")
  {
    ColorGroup("Client::Electricity");
    Size(26, 26);
    Pos(19, 170);
  }

  CreateControl("FirepowerPanel", "Static")
  {
    Skin("Game::Panel");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    Pos(0, 201);
    Size(-14, 71);

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

  }

  CreateControl("FirepowerName", "Static")
  {
    Font("HeaderSmall");
    Geometry("Top", "Left");
    JustifyText("Centre");
    ColorGroup("Game::HeaderText");
    Style("Transparent");
    Pos(1, 205);
    Size(128, 15);
    TextOffset(1, 0);
    Text("#client.unitdisplay.firepower");
  }

  CreateControl("InfantryName", "Static")
  {
    Font("HeaderSmall");
    JustifyText("Right");
    ColorGroup("Game::Text");
    Style("Transparent");
    TextOffset(0, -2);
    Pos(-3, 223);
    Size(62, 10);
    Text("#client.unitdisplay.infantry");
  }

  CreateControl("Infantry", "Static")
  {
    Geometry("Top", "Left");
    Skin("Game::CutInBorder");
    Style("Transparent");
    Size(58, 13);
    Pos(62, 223);
  }

  CreateControl("InfantryGauge", "Gauge")
  {
    Geometry("Top", "Left");
    Style("Transparent");
    ColorGroup("Client::InfantryGauge");
    Size(54, 9);
    Pos(64, 225);
    UseVar("$<.infantry");
  }

  CreateControl("ArmorName", "Static")
  {
    Font("HeaderSmall");
    Geometry("Top", "Left");
    JustifyText("Right");
    ColorGroup("Game::Text");
    Style("Transparent");
    TextOffset(0, -2);
    Pos(-3, 238);
    Size(62, 10);
    Text("#client.unitdisplay.armor");
  }

  CreateControl("Armor", "Static")
  {
    Geometry("Top", "Left");
    Skin("Game::CutInBorder");
    Style("Transparent");
    Size(58, 13);
    Pos(62, 238);
  }

  CreateControl("ArmorGauge", "Gauge")
  {
    Geometry("Top", "Left");
    Style("Transparent");
    ColorGroup("Client::ArmorGauge");
    Size(54, 9);
    Pos(64, 240);
    UseVar("$<.structure");
  }

  CreateControl("AirName", "Static")
  {
    Font("HeaderSmall");
    Geometry("Top", "Left");
    JustifyText("Right");
    ColorGroup("Game::Text");
    Style("Transparent");
    TextOffset(0, -2);
    Pos(-3, 253);
    Size(62, 10);
    Text("#client.unitdisplay.air");
  }

  CreateControl("Air", "Static")
  {
    Geometry("Top", "Left");
    Skin("Game::CutInBorder");
    Style("Transparent");
    Size(58, 13);
    Pos(62, 253);
  }

  CreateControl("AirGauge", "Gauge")
  {
    Geometry("Top", "Left");
    Style("Transparent");
    ColorGroup("Client::AirGauge");
    Size(54, 9);
    Pos(64, 255);
    UseVar("$<.flyer");
  }

  CreateControl("PreReqPanel", "Static")
  {
    Skin("Game::Panel");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    Pos(0, 273);
    Size(-14, 45);

    CreateControl("RivetTL", "Static")
    {
      Pos(3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetTR", "Static")
    {
      Geometry("Right");
      Pos(-3, 3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBR", "Static")
    {
      Geometry("Bottom", "Right");
      Pos(-3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

    CreateControl("RivetBL", "Static")
    {
      Geometry("Bottom");
      Pos(3, -3);
      ColorGroup("Sys::Texture");
      Image("if_interface_game.tga", 63, 6, 2, 2);
      Size(2, 2);
    }

  }

  CreateControl("PreReqName", "Static")
  {
    Font("HeaderSmall");
    Geometry("Top", "Left");
    JustifyText("Centre");
    ColorGroup("Game::HeaderText");
    Style("Transparent");
    Pos(0, 277);
    Size(128, 15);
    TextOffset(1, 0);
    Text("#client.unitdisplay.prereq");
  }

  CreateControl("PreReqBorder", "Static")
  {
    Skin("Game::CutInBorder");
    ColorGroup("Game::Text");
    Geometry("HCentre", "ParentWidth");
    Style("Transparent");
    Pos(0, 292);
    Size(-20, 20);
  }

  OnEvent("Client::UnitDisplay::Notify::WeaponOn")
  {
    Enable("FirepowerName");
    Enable("Infantry");
    Enable("InfantryName");
    Enable("InfantryGauge");
    Enable("Air");
    Enable("AirName");
    Enable("AirGauge");
    Enable("Armor");
    Enable("ArmorName");
    Enable("ArmorGauge");
  }

  OnEvent("Client::UnitDisplay::Notify::WeaponOff")
  {
    Disable("FirepowerName");
    Disable("InfantryName");
    Disable("Infantry");
    Disable("InfantryGauge");
    Disable("Air");
    Disable("AirName");
    Disable("AirGauge");
    Disable("Armor");
    Disable("ArmorName");
    Disable("ArmorGauge");
  }

  OnEvent("Client::UnitDisplay::Notify::AvailableOn")
  {
    Deactivate("MeshView.Disable");
    Enable("UpgradeText");
    Disable("PreReqName");
    Disable("PreReqBorder");
  }

  OnEvent("Client::UnitDisplay::Notify::AvailableOff")
  {
    Activate("MeshView.Disable");
    Disable("UpgradeText");
    Enable("PreReqName");
    Enable("PreReqBorder");
  }

  OnEvent("Client::UnitDisplay::Notify::UpgradeOn")
  {
    Activate("UpgradeText");
  }

  OnEvent("Client::UnitDisplay::Notify::UpgradeOff")
  {
    Deactivate("UpgradeText");
  }

  OnEvent("Client::UnitDisplay::Notify::CostOn::Plastic")
  {
    Activate("PCost");
    Activate("PCostIcon");
  }

  OnEvent("Client::UnitDisplay::Notify::CostOff::Plastic")
  {
    Disable("PCost");
    Disable("PCostIcon");
  }

  OnEvent("Client::UnitDisplay::Notify::CostOn::Electricity")
  {
    Enable("ECost");
    Enable("ECostIcon");
  }

  OnEvent("Client::UnitDisplay::Notify::CostOff::Electricity")
  {
    Disable("ECost");
    Disable("ECostIcon");
  }



  OnEvent("Window::Notify::Activated")
  {
    Sound("Custom::Window::Activate");
  }

  OnEvent("Window::Notify::Deactivated")
  {
    Sound("Custom::Window::Deactivate");
  }
}
              °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×                     XQæaZú	WPü@;ë95¼8                                        &#Hc\üaYüKEï=8·.*P                 °°× °°× °°× °°× ´´Ù °°× °°× °°× °°× °°× °°× §§Ë ¦§Ë ¡¢Å ¼  Á §¨Ì §¨Ì ¥¦É §¨Ì ­®Ô °°× °°×  ù# ù# ù#	 ù# ù# ù# ù# ù# ù# ù#	 ù# ù# ù#  ù#  ù#  ù#  ù#  ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ôôô ÿÿÿÿÿÿ?ÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿNÿÿÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×             		kcnsjôpgþ	`YÿD>ÿD?ÿC>ú-*                        ^Wqiúnfÿkcÿ	VOÿMHý:7ë:7e             °°× ªªÏ044áFJKÿÿ¨°³ÿ¥¨ÿÿsÿT[\üELNÿbpuýborûftxù_loõesvúfswÿ`nqÿVcgÿS_bôVaeþ=EHú¦ ù# ù#
 ù# ù# ù#+ù&7ù*; ù#+ ù#  ù# ù#
 ù# ù# ù#  ù#  ù#  ù#  ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× }}}+'
²ÿÿ	ÿÿ	ÿÿÿ   ÿ   ÿ   ÿ   ÿ   ÿAUMúÿÿÿoÿÿÿ>°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×         [T§sjûqiÿjbÿ
e^ÿ	JDþ
MHÿD?ÿFAÿ1.¦                  aY¦pgÿ	kcÿ
ogÿogþ
XRÿMGÿGBÿB>û,)¼1        °°× ¥¥Ê§ÛNOPù£¥ÿ¨±³ÿ ¢ÿ£«¯ÿVacÿiuyÿl{ÿjx|ÿp}ÿqÿqÿk{ÿiw|ÿZfjþR\_ÿ>FHþ££Ç ù# ù# ù#& ù#9	ù+Tý§Éüºù.W ù#: ù#& ù# ù# ù# ù# ù#  ù#  ù#  ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ² ÿ   f   I   E   C   B   A   A   A   A   A   A   K   ÷CRLÿÿÿÿo°°× °°× °°× °°×°°× °°× °°× °°× °°× °°× °°× °°× °°×°°× °°×     
	
VO§ph÷phÿsjÿrjÿkdÿOJÿUPÿMHÿE@ÿE@þ,(    #

	 f^phþmeÿskÿwnÿmeÿ^WÿXRÿ
NHÿIDÿE@ø51Å
	$    °°× °°×       			ñdhiø¨°²ÿ ©«ôp}ÿlz}ÿkx|ÿtÿuÿq~ÿqÿl{}ÿn~ÿesvþXdgÿBJMÿ¥¥É
 ù# ù#& ù#?ù(_ý§Òãþçÿãþçÿý¨Óù4j ù#@ ù#( ù# ù# ù# ù# ù# ù#  ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?ÿÿÿÿ3   >>>                              >>>     L   ÿÿÿÿo°°× °°×°°×°°×°°×°°×°°× °°× °°× °°× °°×°°×°°×°°×°°×
	aY¼sjÿskÿwnÿG´«ÿïçÿòêÿðçÿ-uoÿRMÿ
JDÿGBÿD?þ95Ë#
	^WËqhþogÿqiÿ>Ä¹ÿNôæÿ=îàÿãÓÿÝÌÿ.¾²ÿ`Yÿ	MGÿHCÿ+(    °°× °°×    	EÕ>@Aú®µ¶ÿ¥®°ôzÿrûo{þm|ýuÿo~ÿqÿk{ÿfuxÿWcfÿ=EGÿ¥¥É ù#" ù#<ù(`ý§Ôãþçÿãþçÿãþçÿãþçÿü£Òù-i ù#A ù#( ù# ù# ù# ù# ù#  ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?ÿÿÿÿS >>>ÿÿ                        >>>ÿÿ>FF    E   ÿÿÿÿo            (                             (      	NH|rjûxpÿ ~ÿ\ÑÈÿìãÿðéÿ}öëÿXîáÿTîßÿ$smÿNIÿ	JDÿJEÿE?ÿ !
jbÿphÿphÿ_ÒÉÿ¢üõÿúðÿUøêÿ!øåÿäÓÿÙÊÿ6ÕÉÿd^ÿHCÿGAûc°°× °°×     		  ÓMQSý°¹ºû¨«ÿwþsþ}ÿo}ÿo}ÿhw{ÿo~ÿm{ÿZfiÿ;CFÿ¥¥É ù#1ù.[ý§ÒãþçÿãþçÿãþçÿãþçÿãþçÿãþçÿüÐù-i ù#A ù#( ù# ù# ù# ù# ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿÿÿÿQ ÎÒÖÿ>FFÿ                        ÎÒÖÿ>FFÿ       Dÿÿÿÿp      '   Q   j   R   (               (   R   j   Q   'h`Öumÿ,ÿyàØÿîçÿ§ôíÿöíÿóêÿPìàÿ[÷éÿ]óæÿ*ÿMHÿ
JEÿD>ÿ
ldÿqiÿ=ª ÿ´ûôÿ¢üõÿüóÿûôÿeùíÿ*úéÿ íÜÿÙÉÿ5ÎÁÿVPÿHBÿB>ä°°× °°×         	

       äzöª³´ÿÿU\]ûELNÿjz}ÿkzÿetyÿtÿm}ÿZgjÿ>FHÿ¥¥É!ù(Aý¥ÊËþÒòãþçÿãþçÿãþçÿãþçÿãþçÿãþçÿãþçÿüÐù-i ù#A ù#( ù# ù# ù# ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿÿÿÿQ                                                D
ÿÿÿÿs   !   X"$ÿ   ¶      ^   )         )   ^#ÿ   ¶      XwnÿwoÿP²«ÿðèÿòêÿöîÿöíÿ|òéÿXòäÿ^óæÿaáÖÿcÛÑÿ5¢ÿQLÿC>î      '!|ïT­¦ÿíâÿ¼ôïÿ®öòÿúôÿüóÿ©ý÷ÿRüíÿ'úéÿëÚÿÝÌÿ/ÐÁÿTNÿHBÿ°°× °°×    		              C÷µº½þ¢¤ÿ£«¯ÿWbdþl{ÿiw|ÿix{ÿl|ÿiw{ÿ]jmÿ>GHÿ¥¥É#oüËþÒîãþçÿãþçÿãþçÿuüÑý¤àãþçÿãþçÿãþçÿãþçÿüÐù3l ù#@ ù#' ù# ù#
 ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿÿÿÿQ                                                   D	ÿÿÿÿv   7#ÿ#jÿ(5;ÿ   Ô   ¡   `   4   4   `Eÿ¶ÿ&.ÿ   É   #þ-ÿïçÿñéÿ¥õîÿ÷îÿõìÿôêÿgòåÿ`ÞÓÿRÎÃÿe×ÏúfÝÒø4ô 	IgdmÒÍáìæûñéÿ§ñëÿûòÿ§ýöÿýöÿ6ûêÿ)øæÿéÙÿ%ãÕÿ%¯£ÿ
OJþ°°× °°×                        Õinnýª³´ÿgtvÿqÿjz|ÿftxÿo~ÿxÿmy~ÿXehÿ8@Cÿ¥¥Éù,?uüª»ýÄäËþÒðrü¼ ù#y	ù+ý¤ØãþçÿãþçÿãþçÿãþçÿüÏù-e ù#= ù## ù# ù#°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿÿÿÿQ                                                   D	ÿÿÿÿv"ÿ{ÿ  Ðÿ¹ÿ)7=ÿ   Ö   ¦   z   zFÿ  Ðÿ  èÿ¸ÿ&.ÿ   S¸±ÿzÙÑÿòêÿóëÿ©õîÿ÷îÿvôéÿnïåÿcçÛÿHÈ¼ûuÍÅàsá×úN¢µ                     m¦ÏÈÜæÝ÷óëÿüóÿý÷ÿXúíÿ,úéÿ#óáÿçÕÿ6ßÐÿ}uü°°× °°×                      ±PTUý­¶¸ÿxÿpýtýl|ÿguyÿrÿpÿ]knÿ4<?ÿ§§Ì ù#&ù(>sü¥rü¨ ù#O ù#P ù#X	ù+qý¤ÔãþçÿãþçÿãþçÿãþçÿüÌù3` ù#2 ù# ù#°°×°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿÿÿÿQ                                                   D	ÿÿÿÿs=ÿ  ÿ  àÿ  öÿÈÿ&29ÿ   Þ   ÈFÿ  Æÿ  àÿ  Ôÿÿ -8ÿ   Y{ÛÔÿñêÿòèÿòëÿöíÿ}öíÿkôéÿfîâÿSÛÎýoÖÌém ©'87<                                    -ZVbhÅ¼Õëãû¡öïÿ üõÿvûòÿúèÿ&îÝÿ
ëØÿ<çØÿ/ØÊú°°× °°×                          :>>ý±¸»ÿ{ÿqþm|ýo}ÿqÿo|ÿp}ÿ[hkÿ28:ÿ°°× ù# ù#" ù#+ ù#. ù#- ù#- ù#5 ù#G	ù+gý¤ÓãþçÿãþçÿãþçÿãþçÿüÅù-I ù#" ù#°°×°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿÿÿÿQ                                                   C	ÿÿÿÿp   Lÿ  ²ÿ  èÿ  ôÿ"Üÿ%28ÿHÿ  ¢ÿ  Äÿ  Øÿÿ*4ÿ   ^   (|ÚÔÿòìÿóëÿòêÿõíÿy÷íÿdôçÿZàÖÿSÍÂûh¤°

                                        

j­¦ºäÚ÷±òíÿüôÿýôÿ%øçÿñßÿíÚÿíÚÿíÚÿ°°× °°×                      	
     ý¯·¸ÿýrþuÿsÿp}ÿqþsÿWbcÿ29;ÿ°°× ù# ù# ù# ù# ù# ù# ù# ù#+ ù#B	ù+dý¤ÑãþçÿãþçÿãþçÿãþçÿPûh ù#% ù#°°×°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿÿÿÿS                                                   Hÿÿÿÿo      Iÿ  ¶ÿ  âÿ  úÿËÿ  Üÿ  òÿ  êÿ¦ÿ,7ÿ   e   +   |ÚÔÿªôîÿªôîÿôëÿõíÿ~öíÿoôéÿUáÕÿ`½µó&%(                                                ):8=ÙÑí£íçÿüôÿüõÿ5÷èÿòàÿìÚÿíÚÿíÚÿ°°× °°×                            &((ý°¹ºÿûU\^ÿFMOõxÿqÿo|úo{~ÿR\^ÿ39;þ°°× ù# ù# ù# ù#	 ù# ù#	 ù# ù# ù#( ù#?	ù+_ý¤Íãþçÿãþçÿü»ù-D ù#  ù#°°×°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?ÿÿÿÿS    >>>ÿÿ                        >>>ÿÿ    M
ÿÿÿÿo         Iÿ  ¦ÿ  Öÿ  ôÿ  òÿ  êÿ²ÿ ,7ÿ      I      |ÚÔÿªôîÿªôîÿ§ôíÿ©õïÿi÷éÿeðãÿUèÛÿ`½µÿ                                                     `½µÿ óëÿûòÿ}ýòÿ^ûîÿBòäÿ!åÖÿíÚÿíÚÿ°°× °°×                        !ý°¸ºÿÿ¢ª¯ÿYcfú{þtÿsýlz}ÿP[\ÿ5=?ÿ°°× ù# ù# ù# ù# ù# ù# ù# ù# ù# ù#% ù#8	ù+P}ü±ü¸ù-J ù#* ù# ù#°°×°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ?   ÿÿÿÿÿÿÿÎÒÖÿ>FFÿ                        ÎÒÖÿ>FFÿ>FF    S	ÿÿÿÿo         +   elÿ  ¾ÿ  äÿ  èÿøÿ-;Lÿ   ã   ­   e   +   |ÚÔÿªôîÿªôîÿªôîÿ±ôïÿôëÿmðåÿUãÖÿ`½µÿ                                                        `½µÿ¢÷ïÿûóÿ{ûïÿaøìÿ\÷éÿ=óãÿíÚÿíÚÿ°°× °°×                     ,Ó!##þ¦¨ÿþo~ùrüxþly~ÿ`knÿYeiÿJSVÿ49<ÿ°°×  ù#  ù#  ù#  ù#  ù#  ù# ù# ù# ù#
 ù# ù# ù#*ù&5ù-: ù#& ù# ù# ù#°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ?   ÿÿÿÿ|ÿÿÿIÿÿÿ                                        |ÿÿÿÿf      (   ^Hÿ  °ÿ  Üÿ  òÿ  æÿ  ÜÿÆÿ'5<ÿ   ×   ¡   ^   (|ÚÔÿªôîÿªôîÿªôîÿñêÿªôîÿôëÿUâÖþ`½µÿ                                               `½µÿ÷îþûòÿ}ûïÿgøëÿ\÷éÿ\÷éÿ(ðßÿ
¾®ÿ°°× °°×            7¼%)*ä')*ü7=?ÿCLNü>GIþ?GJÿ?HJÿAKLú>FHÿCKNý9ABÿ5<>ÿ°°×  ù#  ù#  ù#  ù#  ù#  ù#  ù#  ù# ù# ù#ù% ù# ù# ù# ù# ù# ù# ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?   Ì   ÿÿÿÿ²ÿÿÿÿÿÿSÿÿÿSÿÿÿSÿÿÿSÿÿÿSÿÿÿSÿÿÿSÿÿÿSÿÿÿSÿÿÿ2ÿdÿÿÿ0   !   Y!Mÿ  ®ÿ  Âÿ  àÿ	«ÿ  ¸ÿ  Öÿ  ðÿÀÿ&3;ÿ   Ö      Y   u|ÚÔÿªôîÿªôîÿªôîÿªôîÿzíãÿ@ßÒþ`½µÿ                                    `½µÿ~öíþûòÿûñÿwúîÿwúîÿgøëÿ À²ÿ   t°°× °°×         (TZ\çKSUÆ=DGý6<@ÿ078ñ.57þ3:<ÿ6=?ÿ4;=û+03þ*/2ÿ).0þ"''ÿ¥¥É  ù#  ù#  ù#  ù#  ù#  ù#  ù#  ù#  ù# ù# ù# ù# ù#
 ù#
 ù# ù# ù# ù# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    !      Ìÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿÿcÿÿÿ   7#Qÿ  ¤ÿ  ¾ÿ  úÿ«ÿ".9ÿHÿ  ¶ÿ  ðÿ  ìÿÍÿ#07ÿ   Ë   °°×                                        °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °±×°°× °°× °°× °°× °°× °°× °°× °°× 		              GÊ²º¼ëúXcgÿMWZÿCMOþENQþ?HJÿ<DGÿ7?Aý.45ÿ/47ü5<=ý8@Bÿ©©Ï °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×           ???????   ?   ?   ?   ?
?
?)}~}øøø$Gÿ  ¬ÿ  Èÿ  Úÿ©ÿ&3=ÿ   `   4Iÿ  Âÿ  äÿ  èÿ®ÿ+2ÿ   °°×   /   §Ù«ÿÿ                      °°× °°× °°× °°× °°× °°× °°×        @   _                 @         [°°× °°× °°× 	
            HÕ®µ¹üÿo~ÿl{}ÿn~ÿly~ÿly}ÿtÿtýrÿp}õU_büP[^þ°°×                                                                                                                  °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×°°× (ÿ~ÿ  æÿ¤ÿ$0;ÿ   ^   )      Lÿ  °ÿ  ðÿÿ"ÿ   X°°×	   ¤Ö§ÿ¦öÇÿß±ÿÿ                  °°× °°× °°× °°× °°× °°× °°×     bº³züõÿüõÿ           }ûïÿ}ûïÿ^²«µ   °°× °°× °°×            DÙ»ÂÅÿ¡¦ÿn}ÿo~ÿtþ~ÿÿwÿsþxÿ{ÿhsvÿW`cü°°×  ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ°°× °°× ;;>I²²²´´¶Ï¯¯¯ Ybbi °°× ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ °°× °°×   !)ÿuÿ!.8ÿ   R   (            Pÿÿ#ÿ   Q   '°°×   	¢Ó¥ÿ¨öÉÿ¦öÇÿ¦öÇÿØ©ÿÿ              °°× °°× °°× °°× °°× °°× °°×     üõÿüõÿüõÿ   W        ©ûõÿ¡ûóÿûðÿ   °°× °°× °°×  $&           	² ß¬¶¹ÿ£¨ü¥¯³ÿ «¯ÿ¨±´þ¨²¶ÿ¡ª¯ÿ¡«¯ü «¯ý¡¥þÿjsvî°°×  Ñ Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   ÑÑÑ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ°°× °°× aÀÀÀóÏÏÏüÐÐÐýÆÆÆýÀÀÀ÷ `°°× ÿÿÿ ÿÿÿÿÿÿÿÿÿÿÿÿ ÿÿÿ ÿÿÿ °°× °°×       !ÿ   (                       "ÿ   (      °°×ÀÒ¤ÿ¦öÈÿ¦öÈÿÆùÛÿ¦öÇÿ¦öÇÿÒ¤ÿÿ          °°× °°× °°× °°× °°× °°× °°×     ¼ôïÿüõÿ6[X®   @        J|x}´ûõÿ}ûïÿ   °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×                                                                                                                                                   °°× °°× ¸¸º¸×××ÿçççÿèèèÿÔÔÔÿ¿¿Àÿ¨¨©¸°°× ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ÿÿÿ °°× °°× °°× °°×°°×°°×°°×°°×°°× °°× °°× °°× °°×°°×°°×°°×°°×°°× |ÌÑÒúãÿ§öÉÿÆùÛÿrÂÑÒúâÿ¦öÇÿ¦öÇÿÒ¤ÿÿ   ¡   °°× °°× °°× °°× °°× °°× °°×     ¼ôïÿüõÿ                   ´ûõÿ}ûïÿ   °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×  ½ ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½½½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½°°× °°× ÅÅÅõçççÿõõõÿúúúÿæææÿÂÂÂÿ¦¦¦õ°°× ÿÿÿ	ÿÿÿVÿÿÿ¢ÿÿÿFÿÿÿÿÿÿÿÿÿ °°× °°× °°× °°× °°× °°× ??°°× °°× 2TJ ðÂùÆùÛÿJk®S$ IkoÆùÛÿ¦öÇÿ¦öÇÿÒ¤ÿÿ   °°× °°× °°× °°× °°× °°× °°×     Øùõÿ¼ôïÿ   @                ãûûÿ«ûôÿ   W°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×  ß ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ßßß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß   ß°°× °°× ¶¶¶¸æææÿùùùÿúúúÿíííÿÈÈÈÿ¡¡¡¸°°× ÿÿÿÿÿÿ«ÿÿÿùÿÿÿÿÿÿÿÿÿÿÿÿ °°× °°× °°× °°× °°× ØÙÙÿÿÿÿÿØÙÙÿ°°× ÙÚÙ°°× °°×  2TJIkoR$ R$ S$ IkoÒúâÿ¦öÈÿ¦öÇÿÒ¤ÿÿ°°× °°× °°× °°× °°× °°× °°×                                             °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×  ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ°°× °°× ¤¤¤`ÌÌÌøçççÿíííÿÖÖÖÿÀÀÀø`°°× ÿÿÿÿÿÿ\ÿÿÿÿÿÿCÿÿÿÿÿÿ ÿÿÿ °°× °°× ²´³ÿØÙÙÿ²´³ÿ°°× ÙÚÙÿÿÿÿÙÚÙ°°× °°×     2 P# "  < N" JkoÒúãÿ¦öÈÿ¦öÇÿÒ¤ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× µ¿Ø µ¿Ø °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×                >   Î   Î   >            °°× °°× °°× °°× °°× °°× °°× °°× QQS `¸¸¸¸ÃÃÃõ²²²¸`EEE °°× ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ÿÿÿ ÿÿÿ °°× ØÙÙÿ°°× @²´³ÿ@°°× ¾À¾°°× °°×                          L" IkoÆùÜÿ¦öÇÿAb°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×            >4#ÎN£lÿB[ÿ$Î   >        °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×  @@ °°× ??°°× °°×                             	 D IkoAbaO# °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×        >6$ÎN£lÿb³ÿb³ÿB[ÿ&Î   >    °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×      °°× °°× °°× °°× °°× °°× °°× °°×                                     0 ( D °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    >6$ÎN£lÿ]¯zÿg¸ÿg¸ÿe¶ÿB[ÿ&Î   >°°× °°× °°× °°× °°× °°× ¨±ÿÿyÿ~ÿ¥ÿ¥ÿ£ÿª³ÿ}ÿ®´ÿÿ~ÿ¡¨ÿÿ¡§ÿyÿ~ÿuÿÿÿÿ{ÿÿÿÿwÿwÿvÿoÿ|ÿyÿ{ÿxÿÿÿÿ~ÿÿyÿzÿÿÿÿÿÿrÿ}ÿ¨±ÿÿyÿ~ÿ¥ÿ¥ÿ£ÿª³ÿ}ÿ®´ÿÿ~ÿ¡¨ÿÿ¡§ÿyÿ~ÿuÿÿÿÿ{ÿÿÿÿwÿwÿvÿoÿ|ÿyÿ{ÿxÿÿÿÿ~ÿÿyÿzÿÿÿÿÿÿrÿ}ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× &N4ÎN£lÿb³ÿe¶ÿg¸ÿg¸ÿe¶ÿe¶ÿB[ÿ&Î°°× °°× °°× °°× °°× °°× pÿoÿ¤­ÿ¤¼Äÿª°ÿ²¸ÿ§°ÿ´½ÿ­³ÿ ´ºÿ©¿Äÿ¡·½ÿ¬±ÿ±µÿª±ÿ±·ÿ ²ºÿ¨®ÿ¢³ºÿª®ÿ°²ÿÿÿÿvÿhv|ÿvÿyÿ§«ÿ °´ÿ©¯ÿ¤ÿ¤¶¹ÿ§·¼ÿ¡°³ÿ¯½¿ÿ­½Àÿª¸»ÿª¸ºÿ¬¹»ÿ¯º»ÿ²¾Àÿ¬¸»ÿ¨´¸ÿ®²ÿ£§ÿ|ÿpÿoÿ¤­ÿ¤¼Äÿª°ÿ²¸ÿ§°ÿ´½ÿ­³ÿ ´ºÿ©¿Äÿ¡·½ÿ¬±ÿ±µÿª±ÿ±·ÿ ²ºÿ¨®ÿ¢³ºÿª®ÿ°²ÿÿÿÿvÿhv|ÿvÿyÿ§«ÿ °´ÿ©¯ÿ¤ÿ¤¶¹ÿ§·¼ÿ¡°³ÿ¯½¿ÿ­½Àÿª¸»ÿª¸ºÿ¬¹»ÿ¯º»ÿ²¾Àÿ¬¸»ÿ¨´¸ÿ®²ÿ£§ÿ|ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× N£lÿb³ÿb³ÿe¶ÿe¶ÿg¸ÿg¸ÿe¶ÿe¶ÿ9vNÿ°°× °°× °°× °°× °°× °°× i{ÿRbiÿ$&ÿÿÿÿÿÿ
ÿ		ÿÿÿ   ÿÿÿÿ		ÿ	
ÿÿÿ¡­­ÿ¢³´ÿ£¦ÿ±µÿÿpÿhx|ÿ	ÿÿÿ!ÿÿÿÿÿÿÿÿÿ   ÿ   ÿ   ÿ   ÿ[ijÿ§´¸ÿ ÿÿi{ÿRbiÿ$&ÿÿÿÿÿÿ
ÿ		ÿÿÿ   ÿÿÿÿ		ÿ	
ÿÿÿ¡­­ÿ¢³´ÿ£¦ÿ±µÿÿpÿhx|ÿ	ÿÿÿ!ÿÿÿÿÿÿÿÿÿ   ÿ   ÿ   ÿ   ÿ[ijÿ§´¸ÿ ÿÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ª×ºÿÇ ÿ|Áÿq½ÿg¸ÿg¸ÿg¸ÿg¸ÿg¸ÿe¶ÿ°°× °°× °°× °°× °°× °°× zÿ7@Eÿ#(+ê@0,***)*))*(&%$$VÂÍÍÿ½ÇÉÿ»ÊËÿºÆÈÿ¶ÄÇÿ¬»¿ÿxÿÏs121111211113 11Ueruÿª¸»ÿÿzÿ7@Eÿ#(+ÿ   ÿ Xbÿ zÿ ÿÿÿÿÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿalÿÂÍÍÿ½ÇÉÿ»ÊËÿºÆÈÿ¶ÄÇÿ¬»¿ÿxÿ [gÿ {ÿ }ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ¦ÿ ÿSZÿDKÿ )-ÿeruÿª¸»ÿÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ¨ÿ9BGÿ	ên#$ $+- $+, $*, %+- "(* "(+ !&) "$ #)+ #)+ ,35 '-. $()  $%VÌÔÖÿÔÜßÿÉÓÔÿÈÒÒÿÌÖ×ÿ»ÈÈÿ¡ÿÀ $&:#&(  #$ "'( "# !&' !" !"  #% !"      ! !%&  1ÿª¯ÿ}ÿ¨ÿ9BGÿ	ÿ myÿ ¬ÿaÌØÿdÎÚÿiÍØÿàëÿyàìÿm×ãÿdÌØÿkÔàÿ]ÐÝÿyÜçÿbÍÙÿ[ÂÎÿfÊÖÿhÒÞÿL¦ÿÌÔÖÿÔÜßÿÉÓÔÿÈÒÒÿÌÖ×ÿ»ÈÈÿ¡ÿIÿfÊÕÿkÇÑÿvÎØÿdÉÕÿ`ÑÞÿ`ØæÿfÛèÿ^ÎÛÿcË×ÿ{×âÿÚãÿ{×âÿjÖâÿ*¾Ðÿ ¬ÿ Ydÿÿª¯ÿ}ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    g   Î   Î   Î   Î   Î   Î   Î   Î   Î                    °°× ¤ÿ;CHÿ		êa)13 1:; ,54 3:= .57 .48 .59 3<? &,0 .58 7AD +34 2:< .45 (-/Lÿftzÿ[hhÿ]kkÿ[feÿhwwÿVceÿ&+-¢*/2 .36 *01 (.. ,34 +12 (.0 (/0 )./ &*, #(* $$ "$   !%' !#*ÿ¦´·ÿzÿ¤ÿ;CHÿ		ÿ¤ÿ&¾Ïÿ ªÿ R[ÿ   r   Y   M   M   M   M   M   M   M   M   M   M   ÈcxmÿSn^ÿEfQÿCeOÿCeOÿJsYÿCvUÿ   ¢   M   M   M   M   M   M   M   M   M   M   N +1_$yÿyÚäÿGÄÓÿÿÿ¦´·ÿzÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× Jaÿ?Wÿ?Wÿ?Wÿ?Wÿ?Wÿ?Wÿ?Wÿ._?ÿ   Î   ß   ß           °°× h{ÿDRVÿ	êd" %+. 5>B )04 6@C .69 3<> 4=@ 1:< ,35 2;= 2;= -47 /69 ,36 '-/ )/2 %+, (.. ',, */1 %)* */0 28: *24 &-/ .44 .55 /56 -22 288 .44 ,24 '-- &*+ %** #$ !&' ! (ÿ¨ºÂÿ~ÿh{ÿDRVÿÿo¿Éÿ £ÿPYþ   u   /                                                                                                                       & V4þ}Ýèÿ°ÿ   ÿ¨ºÂÿ~ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× `°}ÿN£lÿN£lÿN£lÿN£lÿN£lÿJeÿD_ÿ?Wÿ   Îa²~ÿ$K2î   ß   ·    °°× rÿAMQÿ	
ê d "!/8; 09< ,46 1:= /7: +25 .58 7@C 19< 8BD 19< 5=@ 5=@ .58 -46 6?B ,36 *01 .46 -46 ,24 -34 (-/ ,24 /57 -33 .44 -44 ,23 .44 -33 .57 +23 )/0 #() !&( !&( ! )!#ÿ¢«ÿ{ÿrÿAMQÿösÇÏÿ £ÿ      @                                                                                                                                       + +1V{Úåÿ¦ÿ   ÿ¢«ÿ{ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× `°}ÿN£lÿN£lÿN£lÿN£lÿN£lÿJeÿD_ÿ?Wÿ   Îb³ÿN£lÿ7pJ÷   ß    °°× £ÿKW\ÿ		ê %'d"(* .68 4=@ 3<? 0:= ,48 08< 08< 3;> 8BF 8AC 6>@ <EG 39; 6>@ 5=? 3<> 08: *13 18; (/0 ,46 ',. /79 179 167 278 /56 077 .65 .57 ,34 -45 .57 )03 &+. #)+  %'  " )ÿ®¸ÿ|ÿ£ÿKW\ÿêvÓÝÿ ÿ   m   0                                                                                                                                           MiÌ×ÿ ÿ   ÿ®¸ÿ|ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× `°}ÿN£lÿN£lÿN£lÿN£lÿN£lÿN£lÿHcÿ?Wÿ   Îe¶ÿ]¯zÿN£lÿ   ß    °°× ÿKW]ÿ		ê$%b %(-59 /7: 08: 4=B 3<@ (/4 .6; 6?C 2;> ;DF 8AA 7?? 5;< :BD 3:< 5>A 08: 2:> 07: 1:< (/1 08; *23 389 055 289 /46 ,33 077 19; 089 -46 (-/ *03 "') &,. $*,   )ÿ¥­ÿ|ÿÿKW]ÿêiÐÜÿ ÿ   k   0                                                                                                                                           MsÍØÿ§ÿ   ÿ¥­ÿ|ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× p¸ÿR§pÿN£lÿN£lÿN£lÿN£lÿN£lÿJhÿ?Wÿ   Îe¶ÿb³ÿN£lÿ   Ä    °°× £ÿCOTÿ	
ê"(+b!'++48 .48 3;> 5>C 7AE (/4 4=C 6?C 2:= 8AB =FH ;CD <DF 5=? 4<= 5>A 2;> 2;> 6?C 2:< 5<> 078 ,24 399 288 /56 .45 .44 067 079 .57 -36 /69 *14 (.1 .58 $), ! (ÿ¤ÿrÿ£ÿCOTÿêqÜèÿÿ   k   0                                                                                                                                           MvÕàÿ ÿ   ÿ¤ÿrÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× p¸ÿU§qÿN£lÿN£lÿN£lÿN£lÿN£lÿN£lÿ?Wÿ   Îe¶ÿ]¯zÿ?Xøk    °°× zÿ?JPÿ	ê"$c"(, *16 ;DH >HL 3;@ /7: 2;@ .5; 08; .6: 7>A 9AD 5=> 7>@ ;CE 8AC 4;? 4<> 9BE 8BD :BD :BC 4;< 28: 7>? 189 9BC 3:< 3:< 179 18: /58 -36 /68 .58 +14 '.0 %*, $& )ÿ¡¨ÿsÿzÿ?JPÿêuäñÿÿ   k   0                                                                                                                                           M~àëÿ¢±ÿ   ÿ¡¨ÿsÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× u»ÿe°ÿR§pÿN£lÿN£lÿN£lÿN£lÿN£lÿ?Wÿ   Îb³ÿM jÿ=)¢    °°× vÿGTXÿ		ê!#d %(!3;@ :DG 5>A @KP ;DI :CH 4;@ -58 ,26 3;= 9BE 7AA =GI <DG 5<? :BE 3;> 9AB ;DF ;BD 5<< 288 5<= .46 089 /67 4<> 2;= /69 /58 /68 .58 /57 -47 -35 +14 %+- "$ )ÿ¨³ÿ¥°ÿvÿGTXÿêdÜêÿ£ÿ   k   0                                                                                                                                           MsÚæÿ®¿ÿ   ÿ¨³ÿ¥°ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× Âÿ{½ÿh²ÿ[­xÿR§pÿR§pÿU¨rÿN£lÿ?Wÿ   Îg¸ÿ?*`            °°× ©¯ÿGUXÿ	

ê#%c $&.36 8BD :DG 07: :DH 4=@ 8AE /69 2:= 19; 6?B 6?A 8AD 7@B 8AD ;DG :BF 7>> 8?@ 7>? 8@A 299 3:; 29; 6?B 4<> 19: -58 /7: .47 079 ,25 .58 .58 *03 '.0 '.0 $& #ÿ³¼ÿrÿ©¯ÿGUXÿêgÔàÿÿ   k   0                                                                                                                                           M{Úåÿ£µÿ   ÿ³¼ÿrÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ­Ù½ÿÎ­ÿÂÿp¸ÿp¸ÿp¸ÿ`°}ÿ[¬xÿRlÿ   g                    °°× ¥ÿ?JMÿ		ê R%+,3;< 9AE 4;> =GJ 7@B 19; 9BE 29: 5<> 4<< /55 5=? :BD 2:= 6>B 8BC 8BD 5>@ 2;= 9@B 7>? 7>@ 5;= 3:: 3;< .57 5=> /68 /68 1:= 08: 4<? 29< ,37 )/2 )/3 &,/ " !ÿ§®ÿ|ÿ¥ÿ?JMÿêkÒßÿÿ   k   0                                                                                                                                           MØâÿ ©ÿ   ÿ§®ÿ|ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" tÿ;FKÿ

ê$&L#)*;EG ;DE 2:: :DG /8: 7?B 4<? 6=? ;DE 289 8?A 4;= :CE 07: 29< 7?D 5>B 7AD 09; 6=? 9@A 3:; 7>@ 7@A 5=> /68 2:< 18: /79 08: .58 18< -47 ,47 )02 )03 $*, "$ !ÿ¤­ÿ¡ÿtÿ;FKÿê`ÏÛÿÿ   k   0                                                                                                                                           MÞçÿ¡²ÿ   ÿ¤­ÿ¡ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" wÿ>IOÿêN!" 7@B >II ?JI 7@C 3;> 5=@ 8AD 188 5=> 9AC 057 7?B 5=? 4<? 18; 5=C 7@E 6@D 08; 5<> 8@C 4<< 5<= 3;; 4;< 18: 3:< /59 19; /68 /69 -45 ,36 +35 (.0 (/1 (/1 !&( !ÿª¯ÿÿwÿ>IOÿêhÑÝÿ ÿ   k   0                                                                                                                                           Màéÿ«ÿ   ÿª¯ÿÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"(3Ó"x3Ó"ÿ3Ó"ÿ3Ó"w3Ó"(3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" qÿ8BGÿ	
ê %(N#%!4<> =HJ <EH 9BF ;CH 5<? :DG 179 6>@ 4:< 057 .46 2:< 08: 07: 5=A 2:= 08; /8; 7?A 18: 8?@ 3:; 6>? 5>> 29; 18; /59 07: .58 .46 ,24 +13 .58 +24 *24 '-/ !&( !ÿ£´ºÿÿqÿ8BGÿê[ÁÌÿ ÿ   k   0                                                                                                                                           Mêóÿ(¨ÿ   ÿ£´ºÿÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ò# 5Î' 3Ò# 3Ó" 3Ó" 3Ó" 3Ó"w3Ó"ÿ3Ó"*3Ó""3Ó"ÿ3Ó"w3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" zÿ<FKÿ	ê$&N#)*6?A 5<B CMT =GL :DH BLP 8AC 068 189 8@B 18: 3:= /58 08; 18< 089 5>A 29= 7@D 19; 7?A 5<= 6>> 2:; 5<> 5=@ /69 .58 19< -47 .46 /68 -46 .46 '-/ ,35 )/1 !%' !ÿ¬±ÿ ¦ÿzÿ<FKÿêRÂÎÿ ÿ   k   0                                                                                                                                           Måðÿ©ÿ   ÿ¬±ÿ ¦ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 5Î' 8Æ/ 5Î' 3Ó" 3Ó" 3Ó" 3Ó"ÿ3Ó"*3Ó" 3Ó" 3Ó"*3Ó"ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" pÿ3;?ÿ	
ê"()L*129BC @JP @JO 9CD 9BD =GI 8@B 058 7?A 4<> 18: 18= ,26 )03 18= 078 4<> 6>@ 29< 2:< 079 3:= 7>@ 3;= 6>A 07: 4=@ 07: .58 18< /79 19< /79 -36 ,25 (.0 &+-  %& "ÿ§¸¼ÿÿpÿ3;?ÿêJÆÔÿ ÿ   k   0                                                                                                                                           M{äðÿ­ÿ   ÿ§¸¼ÿÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ò# 5Î' 3Ò# 3Ó" 3Ó" 3Ó" 3Ó"ÿ3Ó"U3Ó" 3Ó" 3Ó"*3Ó"ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" }ÿCNRÿ	
ê#(*L(./>GI ?IM AKO DPT @JN ?JN 5=@ ;CF /68 3:= 07: .48 .48 /69 18; 6=@ 29< 6?@ 5=? 19; 2:= 3;> 6=@ 4;> 7@C 18; 6?B 069 079 4<> /68 19; /8: /69 ,35 +13 ',. #% !ÿ¦¶»ÿÿ}ÿCNRÿêCËÛÿ ÿ   k   0                                                                                                                                           Mrßëÿ¡³ÿ   ÿ¦¶»ÿÿ3Ó" 3Ó" 3Ó" 3Ó"
3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"w3Ó"ÿ3Ó"*3Ó""3Ó"ÿ3Ó"w3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" §ÿ<GKÿ	
ê!')N(./ <EG EQT 6@B 8@F >GM ;CH 9AE 7?A 18; 2:= -36 ,36 ,46 4=? 8AD 8?B 5<> 8@@ 8@B 4=@ 5=A .5: 4;? 4<@ 19< 8BE 8AD 5=? 4;= 3:< 5=? ,34 08; *24 ,35 +24 %+, !# !ÿ©¹¼ÿÿ§ÿ<GKÿêNÏÞÿ ÿ   k   0                                                                                                                                           MvÙåÿ£µÿ   ÿ©¹¼ÿÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"Æ3Ó"w3Ó"ÿ3Ó"ÿ3Ó"w3Ó"â3Ó"X3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" pÿ@JPÿ	
ê%,-O19:!8BE FQW EPV 7>C CLR AKO ;DH 8AD :BE /58 /59 5=? 3:< 3;< 7?@ 4;> 4<> 9AC 8BF 6?B -48 19> 06: 5>@ 8AC 8AC 8@A 9AB 9AB 6=? 3;> 19; +25 '.1 -47 '-/ '-/ !# !ÿª¼½ÿÿpÿ@JPÿêNØçÿ ÿ   k   0                                                                                                                                           MwÒÝÿ ¥ÿ   ÿª¼½ÿÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"X3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" Vgoÿ<HMÿê%*,N'-/8BD @KQ 8AG <EI ;DH BLQ :BF <FI 4=@ 3;> 8AD 7?A 8AD 4>? 8AC 5<@ 8AD 7?B 9BE 7@C 5=A /58 18< 19< 9AC 5<> ;EG 9BC 5>@ <FG 17: 2;= 4;= 08: (/2 ,35 %+-  ! !ÿ§¹½ÿÿVgoÿ<HMÿê_Úçÿ¢ÿ   k   0                                                                                                                                           MqÎÙÿ ÿ   ÿ§¹½ÿÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó"3Ó"*3Ó"ß3Ó"X3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" j}ÿ;GLÿ

ê)/1L&,-079 CNT 5>C :CG BNS :DH 7@E 5=A <EJ ;CG ;DH <FI 8AC 8AC 9BE 7@B 6?A 7@D :CG 8AD 9BF 8AD :BF 3:= 9@C 7>B :CE :CE =HJ :EF 4<> /68 2:< ,36 *23 ,35 )02  %' !ÿ©º¿ÿÿj}ÿ;GLÿêáìÿ¢ÿ   k   0                                                                                                                                           MsÒÝÿ ÿ   ÿ©º¿ÿÿ3Ó" 3Ó"
3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"	3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"X3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" av}ÿ9EHÿê*13L+355?B ;GL 8BG GUY CPT ?IN 2:> =GM 9AF <EG 7?B AKN :BE 8@D 3:= 6?B 8@C ;DH :CG 6=@ 4<> 8?B 3:= 5=A 8@C 079 <EH 6>@ :DF 9BD 6>A 19; +15 (.1 29; .58 )/1 #(* !ÿ¦¸½ÿ¥ÿav}ÿ9EHÿêèñÿ¡ÿ   k   0                                                                                                                                           MqÍØÿ «ÿ   ÿ¦¸½ÿ¥ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"
3Ó"D3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"F3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" gzÿ;FIÿ		ê$*-N)14ANR M[` COT 8BE ALP <EJ >GM =FK =FL <EG ;EG 9@C 9AD 7>B =FJ :BF 8?B 6>B 7@D ;DF 8@B <EH 8@B 28; 5=@ 6>A 5;> ;CF 9AD <EH 8BG /7: 18< 19< /69 /69 )01 "'( )ÿ«°ÿ{ÿgzÿ;FIÿê}âíÿÿ   k   0                                                                                                                                           MlÄÏÿ ¡ÿ   ÿ«°ÿ{ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"X3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" ÿJVZÿê$*-O#)-!;FL IUY BMQ ALP ;EH <FJ 8@E GRW ?HL ?HJ =FI <DH 6=@ BLP =FJ ;CG =FI 8AD 5<? 7@B >GJ >GI 8@C 18; 3;= .68 4<> 9AD 6>A 8@C 3<@ 3;@ 4=B 2;> 1:= -58 ,36 $)+ )ÿ£±·ÿ~ÿÿJVZÿê|ßêÿÿ   k   0                                                                                                                                           MpÏÚÿ ÿ   ÿ£±·ÿ~ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"X3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" ¢ÿHUXÿ		ê(/2M08; =GK KY[ CNP DOT >GK 7?C BLQ CMP >GK ?GJ <EG >FI =EH <EH :CG ;CG 5<? 7?B 8AC <DG >HK 9AE <EI 2:> 7@C 7AD 3;> 4<? 8@D 8@C 08< 2:> 5>C .6: -58 ,35 (/1 #)* )ÿ©¹¾ÿÿ¢ÿHUXÿê{Üçÿÿ   k   0                                                                                                                                           M_ÏÜÿ ÿ   ÿ©¹¾ÿÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"X3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" «´ÿS`eÿ

ê%,.L&*,:BD DQQ HUV ALQ <EI 4=@ 9BE EPR :CE :CE :BE =EH @IM <DH <EH :BF ;CG :CE ;DF 8?B 4<> 4=@ 8AE >HL 3<@ 5=B 8BE 3<? >IL 7@C 5>B 6?C 4<@ /6: .79 .68 (/0 $*+ )ÿ§¸½ÿzÿ«´ÿS`eÿê}Þéÿÿ   k   0                                                                                                                                           MhÛèÿ ªÿ   ÿ§¸½ÿzÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"X3Ó" 3Ó" 3Ó" 3Ó" 3Ó" xÿQ\_ÿ	ê'-.L$)+@JM NZ] KVX 7?B 8AE BMR 9BF ;DG =GK <FJ 3:> <EJ :CG 6?B 8AC =FH ;CE :CE 9BD 8?B 4<@ 8@E 7AF -48 /6< 1:> .79 09< 5?A :EH =FJ /57 08; 2:< 5>@ 08: /69 &,. )ÿ±¸ÿÿxÿQ\_ÿê}âîÿÿ   k   0                                                                                                                                           MhÚçÿ ­ÿ   ÿ±¸ÿÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"X3Ó" 3Ó" 3Ó" 3Ó" ¢ÿWdgÿ	
ê$*,N*14 <FI ITX CNQ AKO >GJ 9DG :DH <FI ;DG BKO 8AD 7AE 2:= :DG ;DH <EH BMP =GJ :DG =GJ 9BF <FJ <FJ <FJ 4<B 6>D 8AE +15 5=A 7?C 3;< :BD 3:> .46 1:= /8: .58 "') )$)+ÿ¥«ÿn}ÿ¢ÿWdgÿêyâîÿÿ   k   0                                                                                                                                           MaÐÝÿ «ÿ   ÿ¥«ÿn}ÿ3Ó" 3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"X3Ó"3Ó" 3Ó" oÿO\`ÿ		ê&,.O%+- @KN N[_ CMQ <FJ @KO =GK @KN ?JM 7?B 6>A :DG >HL 9CF <EJ ;EI ;DH >HK =FJ 3:> ;CF 8@D ;EI ;EH ;EH :CH 7?D 6>B 4<@ 2:= 3;> 6?@ 8AC 06: -36 19< /7; .69 $*+ )$+,ÿª¼ÁÿtÿoÿO\`ÿêäðÿ ÿ   k   0                                                                                                                                           McË×ÿ ¤ÿ   ÿª¼Áÿtÿ3Ó" 3Ó" 3Ó"Y3Ó"ã3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ß3Ó"Y3Ó" 3Ó" ^ltÿUdkÿ	
ê%+.M1:= ;EI ?IN CNS <FK >HM BLQ 8AC 7>A @JM <FH 9BE 6>A :CG 9BE =FI <EH ;CF ;DG AKO 9AD =FI =FJ 8AD :DG 3;? 3;? 3<> 8AE <EI 6?B 9AD <FH -37 2:= .6: 08< (.2 $% )&,-ÿ¤¹»ÿyÿ^ltÿUdkÿêzßëÿÿ   k   0                                                                                                                                           MkËÖÿ ¥ÿ   ÿ¤¹»ÿyÿ3Ó" 3Ó"Y3Ó"÷3Ó"*3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"*3Ó"ö3Ó"\3Ó" k~ÿR`gÿê'-0L'.17@D <EI =HK 9BD DNS FPS @IM ?HJ @JL <EG ;EG ;DG 8BD :BE <DH =FI <EH AJN 8?C <DH >FJ ;BE =GI ?HK ;DG AKN 18; ALP ;DG 8AD ALO 8AD 17; /59 /7; .59 ,36 "'( )"()ÿ©¬ÿvÿk~ÿR`gÿê~ßëÿÿ   k   0                                                                                                                                           MwÔÞÿ ¦ÿ   ÿ©¬ÿvÿ3Ó" 3Ó"¬3Ó"þ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"à3Ó"3Ó" mÿLY_ÿê#),L)/27@D ANR 8CG =GI EPR CMP ISU JUW EOR 9CE ;EG >HJ :CE <EG ?HK 4;= <EH ?HK @JM <EI <EG AJL =EG BKL BLO >GI 4;> =FI AKN =FJ >FJ 7?B 9BE 7@C 1:= /69 19; #() )ÿ¥ÿyÿmÿLY_ÿê~àëÿ ÿ   k   0                                                                                                                                           MsÏÚÿ ÿ   ÿ¥ÿyÿ3Ó" 3Ó">3Ó"ú3Ó":3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó":3Ó"ú3Ó"E3Ó" xÿLZaÿ!#ê(-1M-58 =GL CQV =JM AKN >GJ BKM AJL KVZ HRV CNR 8AC >GJ @JL =EG >HJ <DH ;DG <DG <EG COQ 9BC =FG ENP CKL AJL ?HJ ?HK 9@C =GJ @IL ;CF =FI 6>@ 8AC /69 *02 2:< %*+ )ÿ®´ÿvÿxÿLZaÿêâíÿ ÿ   k   0                                                                                                                                           MhÄÏÿ {ÿ   ÿ®´ÿvÿ3Ó" 3Ó" 3Ó"Ð3Ó"«3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"«3Ó"Ð3Ó" 3Ó" h{ÿUekÿ&+.ê&+.O+24 ALP ANT <IM FRT ?IK AIL CLN DOS FPU BMQ AKO ;DF <DF >FI >GJ <DH >GK ;CE >HJ :CF :BD ?FH BJK CJK CLM AJL AKN ;CE =EG >HI =EH <DH 9BD 6?A 2:< 19; /67 (.. )ÿ¯¶ÿyÿh{ÿUekÿêwÜçÿ |ÿ   k   0                                                                                                                                           MpÊÕÿ |ÿ   ÿ¯¶ÿyÿ3Ó" 3Ó" 3Ó"p3Ó"ï3Ó".3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó".3Ó"ï3Ó"p3Ó" 3Ó" vÿP]cÿ%+-ê(.0M08: BLO KW\ CMS BKP ALP >GI EPR CMO HTV @IK <EG AJN =FH ;DF @JL >GJ @IK BJN DNR =FH =EG BKL CKK ELM P\] >FE BKM =GI 9AC :DE :CE 5;> 6>@ :BC 8@B 4<> 19: (./ )ÿ¢ÿdt{ÿvÿP]cÿêáìÿ ÿ   k   0                                                                                                                                           MwÓÝÿ ÿ   ÿ¢ÿdt{ÿ?Ó2 3Ó" 3Ó" 3Ó"Æ3Ó"¹3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"¹3Ó"Æ3Ó" 3Ó" 3Ó" l}ÿ\krÿ#)*ê K(.0ALO DNS DPU EPS DOR FQT DOR BKN CMP FPS AJN ?HL =EI JVZ CLP AJL @JM >GI AJM <EG =EG @HJ FPP HQR P\` DNP FOQ ?HI >GH ;CE ;DF :AD <DG ;BE 7@B 7@B 7>@ *02 )ÿ£ªÿxÿl}ÿ\krÿòçñÿ ÿ      I                                                                                                                                     3   z[ÁÎÿ «ÿ   ÿ£ªÿxÿ3Ó" 3Ó" 3Ó" 3Ó"?3Ó"é3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"3Ó"é3Ó"?3Ó" 3Ó" 3Ó" pÿ_ovÿêR!#"AKN EPU EPU LX] KW\ FPT JUY JUX HTV GSV DNR >GJ BMP DNR LW\ FQU ALO ALP <EI ;DG BLN EOR GRR GPR HSU AJK P[] KUV >FH BLO =EH 9BE 8AE :BF 068 7@B 3:< +12 )
ÿ¦ÿm~ÿpÿ_ovÿÿëõÿ	°ÿ ^iÿ      G   1   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   +    W`ÿ ®ÿ £¶ÿ   ÿ¦ÿm~ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó"t3Ó"í3Ó"]3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"]3Ó"í3Ó"t3Ó" 3Ó" 3Ó" 3Ó"  ÿctzÿêj0'-/"@JN BLP IVY IUZ =FI ?HK AKM CLO FPT ?IL ;DG >HK @JM DOS @JM =GJ 7>C 8@D 9BD BMP :CF >HJ 8AB >GH ?GH ?FH EMN ;EF 8AD ;DG ;DH 8@E 8@D 2:= .58 ,24 %+- )ÿ¥ÿk{ÿ ÿctzÿÿ{ÓÝÿîøÿ©ºÿ frÿ      z   u   w   x   x   w   w   w   x   x   x   x   x   x   x (-x   x   x   x   x   x   y   y   y   y   y   y   y   z   |   ~    U_þ ±ÆÿAÉØÿ ÿ   ÿ¥ÿk{ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"3Ó"í3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"3Ó"í3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó" ~ÿfw}ÿê Y,"'( $*,-35 +24$).0'*03)*13()/1)*02*-35**03*)/1(,24),35)(.0)&+.)!&))$),)%+,)&+-)(.0)&+-))/0)&,-)',-)&*,3*./1'-/0&-.2)/05(/16#),:#(+>$&B !C CE	
^ÿ¡¬ÿds|ÿ~ÿfw}ÿÿ?§ÿ¨óûÿìöÿ"´Æÿ²ÿ¯ÿ¬ÿ ªÿ ­ÿ ¨ÿ §ÿ ¥ÿ ¤ÿ ©ÿ ¥ÿ ¤ÿ £ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ	ÿÿzÿzÿÿÿ ¡´ÿYÔãÿ	¨»ÿmzÿ   ÿ¡¬ÿds|ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"t3Ó"é3Ó"ÿ3Ó".3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó".3Ó"¹3Ó"é3Ó"t3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" |ÿcrwÿ)/1ÿê\#$N"()L.46M.57Q*12V.46V,35U*/1U+23V,34Y/68W,35U.57U+25U-47U)/1U'-/U(.0U,34U,35U-46U*13U*03U,35U*02^*02]-34\19:\,35],35^+24]%*-^*03^#),`"(*aaez)04ÿwÿds{ÿ|ÿcrwÿK)ÿ>Bÿ6¡­ÿ~Õßÿïùÿì÷ÿèôÿmâðÿqåòÿ\ÝìÿTÙèÿ[ÛêÿSÙèÿUÙéÿXÚéÿMÔäÿNÕåÿ\ØçÿWÒàÿLÌÛÿLÌÛÿLÌÛÿQÍÜÿMËÙÿJÌÛÿ<Ç×ÿ>ÉØÿnÜèÿnÜèÿZÓáÿNÍÝÿ]Óáÿyßëÿ|ÙäÿzÖàÿsÑÜÿzÖàÿpÑÜÿhÔáÿ@µÂÿ|ÿ  $ÿ	G!ÿwÿds{ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"?3Ó"Æ3Ó"ï3Ó"«3Ó":3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó":3Ó"«3Ó"ï3Ó"Æ3Ó"?3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" xÿwÿrÿ*02ÿ	

êêê!"ê'-.ê(-/ê%*,ê&+.êêêêêêêêêêêêêêêêêêêêêêêêêêêêê
ê	êê)/2ôLX^ÿ[kqÿk{ÿxÿwÿrÿ*02ÿ	

ÿÿÿ!"ð'-.ê(-/ê%*,ê&+.êêêêêêêêêêêêêêêêêêêêêêêêêêêêê
ÿ	ÿÿ)/2ÿLX^ÿ[kqÿk{ÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"p3Ó"ÿ3Ó"ú3Ó"Û3Ó"©3Ó"n3Ó"83Ó"3Ó"3Ó"83Ó"n3Ó"©3Ó"Û3Ó"ú3Ó"Ð3Ó"p3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" ÿ ÿ{ÿix}ÿ^lqÿWcgÿN[]ÿM[\ÿP\_ÿHSVÿMW\ÿITXÿGQUÿKV[ÿCNPÿBMPÿEPSÿ>HKÿ=FJÿ@JNÿ?HLÿ;CIÿ7ACÿ@KMÿ<FIÿAKOÿBLQÿDMQÿNZ^ÿNY_ÿ@JMÿ6>Aÿ7ACÿ;DEÿ:BEÿ5=?ÿ7?Bÿ7>Bÿ2:<ÿ8@Cÿ8ADÿ,35ÿ18;ÿGSVÿaqxÿsÿzÿÿ ÿ{ÿix}ÿ^lqÿWcgÿN[]ÿM[\ÿP\_ÿHSVÿMW\ÿITXÿGQUÿKV[ÿCNPÿBMPÿEPSÿ>HKÿ=FJÿ@JNÿ?HLÿ;CIÿ7ACÿ@KMÿ<FIÿAKOÿBLQÿDMQÿNZ^ÿNY_ÿ@JMÿ6>Aÿ7ACÿ;DEÿ:BEÿ5=?ÿ7?Bÿ7>Bÿ2:<ÿ8@Cÿ8ADÿ,35ÿ18;ÿGSVÿaqxÿsÿzÿ;Ò1 =Ñ4 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó">3Ó"3Ó"½3Ó"×3Ó"û3Ó"ÿ3Ó"ÿ3Ó"û3Ó"×3Ó"½3Ó"3Ó">3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" |ÿÿÿÿwÿuÿtÿiw|ÿrÿeqwÿrÿrÿo}ÿwÿpÿuÿoÿuÿjyÿqÿxÿaqwÿft|ÿrÿlzÿyÿvÿyÿwÿuÿrÿoÿqÿsÿrÿvÿzÿvÿrÿn}ÿyÿoÿsÿdrwÿcqvÿuÿrÿ|ÿÿÿÿwÿuÿtÿiw|ÿrÿeqwÿrÿrÿo}ÿwÿpÿuÿoÿuÿjyÿqÿxÿaqwÿft|ÿrÿlzÿyÿvÿyÿwÿuÿrÿoÿqÿsÿrÿvÿzÿvÿrÿn}ÿyÿoÿsÿdrwÿcqvÿuÿrÿ3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó"3Ó"3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" 3Ó" SmÿSmÿSmÿSmÿSmÿ8sMÿ   ÿ   ÿ   ÿ   ÿ   ÿùDEù   ÿ   ÿ   ÿ   ÿ                                  .   ;   D   J   J   D   ;   .                                                                 .   ;   D   J   J   D   ;   .                               °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×                             LF¹	c\ñ	ZSÚ	ZSÚ+(i                                 	(
f^÷	`Yé	[TÞLFº
                    SmÿSmÿSmÿSmÿSmÿ8sMÿÿ8sMÿ8sMÿ8sMÿ8sMÿPn[ÿå}}åPn[ÿ8sMÿ8sMÿ8sMÿ8sMÿ                        #   =   \   x         ¦   ¦         x   \   =   #                                             #   =   \   x         ¦   ¦         x   \   =   #                     °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×                     A<
e^ö	]Væ	c\ì
haøpiü
h`ÿ;7                            84	bZÿ
ngý
iaø
h`ü
h`ý
f^ø:6                SmÿSmÿSmÿSmÿSmÿ8sMÿ   ÿYrÿYrÿSmÿOgÿNaÿ+N7ÿÞÞ+N7ÿNaÿOgÿSmÿYrÿYrÿ                    4   ]¡Ó0í;!ù?%þ4þ#û õ#é&Ó   ¬      ]   4                                     4   ]¡)!Ó;8íKMùJNþEJþ9;û&!õé!Ó   ¬      ]   4                 °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ¯¯Ö°°× °°×                 2.y	c[ô	c[û
pfÿÿÆ¸ÿCãÖÿ8£ÿ
h`ÿGB­                    :6
f^þkcÿSæÚÿ/Ë¿ÿÿ
rhÿ	d]ý
g_ûYR×
        SmÿSmÿSmÿSmÿOgÿ8sMÿ   ÿSmÿSmÿSmÿSmÿOgÿ8sMÿ   ÿ   ÿSmÿOgÿSmÿSmÿSmÿSmÿ                =))Û8=,üM7&ÿeB(ÿi?&ÿi@'ÿkB'ÿd=%ÿU6 ÿ>*ÿ</þô"×   ¥   r   =                             =	=<Ûhiü	|ÿÿ	ÿ	ÿ
ÿ	ÿgiÿROÿ72þô ×   ¥   r   =                                                                                          ¿¯ GhY .H;             -*o
f^ú
jbÿÿ+ÐÃþpÝÓþçßþ[êÞÿQÛÏÿ;§ÿ
h`üGB­            OIÁ	b[ôSNÿ\àÕÿdéÞÿqæÜÿJÓÇÿ;ÏÂÿ£ÿ
meÿ
g_ü
e^ö;6YrÿYrÿSmÿOgÿNaÿ+N7ÿÞSmÿSmÿSmÿSmÿSmÿ8sMÿ   ÿ   ÿq°ÿSmÿSmÿSmÿSmÿSmÿ          >"±=4 óE8#ÿ,#ÿ?*ÿe?&ÿzN0ÿX7ÿR4ÿwG*ÿpF*ÿgB'ÿO)ÿC&ÿ9/ý!'ê³   y   >                   >
0%±
heóÿ¤ÿ¡©ÿ¢ªÿ¦¯ÿ¦­ÿ¥­ÿ¦ÿÿÿejÿMNÿ50ý,"ê³   y   >                                                                                     ²¥Ç·ÿewÿ,F9ÿ          	bZðtkÿ¯¢ÿ;ÓÇÿâÙþçßÿ_ÛÑþ[ëßÿ]ëßÿXÕÊÿ-ý	d\ö    UO
iaÿ]UÿWÔÉÿgêÞÿ[ëßÿ]áÕþmèßÿPÚÏÿ8É¾ÿ®¢ÿÿ	b[ñ	^Wå&q°ÿq°ÿk£ÿ\lÿPn[ÿå}SmÿSmÿSmÿSmÿSmÿ8sMÿ   ÿ   ÿq°ÿSmÿSmÿSmÿSmÿSmÿ       4*µT@'ýp?&ÿ_J1ÿ]gFÿCL,ÿ2!ÿ]0ÿK*ÿO/ÿM.ÿT6ÿY;ÿoI.ÿc<"ÿL"ÿ9&ÿ #ï³   r   4             46)µ
wxý¥ÿ¨±ÿ«³ÿ ­µÿ'³»ÿ,¹Àÿ-ºÀÿ(³¸ÿ'¦ªÿ!ÿÿÿ	x~ÿOUÿ	<8ÿ*!ï³   r   4                                         6¦(./ÿ(./ÿ,23ÿ+12ÿÿ£Å´ÿ\~nÿ2M@ÿ       \VÕneÿÊ»ÿWØÎý¤îçÿèáÿmåÛÿyèÞÿhìáÿ[éÝÿWàÔÿUÏÅÿSNô
    =9f^þVËÁÿsêßÿñéÿzîäÿyèÞÿkæÜÿréàÿ\àÔÿ<Ê¿ÿÁ³ÿÿ	f_õ(%b   ÿ   ÿ   ÿ   ÿø}3SmÿSmÿSmÿSmÿSmÿ8sMÿ   ÿ   ÿq°ÿSmÿSmÿSmÿSmÿSmÿ     #) ZL/ýX;ÿV7ÿkLÿ¿Ø¨ÿ¸ÿOe?ÿB6ÿ[(ÿw5ÿM-ÿ\9ÿcCÿ]=ÿ|U7ÿjC)ÿM&ÿ7!ÿ'ê¥   \   #        #
0! ||ý¢­ÿ­·ÿ ±¹ÿ(·¾ÿ*¸¿ÿ,»Âÿ.»Âÿ-´»ÿ*ª°ÿ ÿedÿTTÿecÿÿÿTZÿ52ÿ-!ê¥   \   #                                                   (!')æJSVÿjx|ÿanuÿ>FHÿ.46ÿÿ¤Æµÿ^oÿ2N@ÿ       {ÿ|sÿdâØÿåÞþêâÿéáÿyà×þpåÛÿ^áÖþQãÖÿXäØÿTÞÒÿI¹¯Ò            N®¥ÚiçÜÿmèÝÿðéÿ¥òìÿîèÿwÜÓþèàÿvçÞÿ^ÜÒÿKÔÉÿÿvÿA<°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    lIK.ídFÿ¡wRÿqMÿ}ZÿÈÍ¢ÿôÿÖÿ¼æ¥ÿrdÿLJ*ÿS%ÿn0ÿK*ÿ`>ÿ[;ÿ\<ÿX;ÿoI.ÿL&ÿ0'ý×      >      l
ieí¥²ÿ·¿ÿ'·¿ÿ.»Âÿ0¾Åÿ/¼Ãÿ.»Âÿ.¸¿ÿ,®³ÿlÿm"ÿOÿiÿa,ÿacÿ ÿ
ÿ LRÿ1*ý!×      >                                                   .46ÇJTXýÿ}ÿTZ]ÿ<BDÿ/57ÿÿ¥Ç¸ÿ[|lÿ-H:ÿ       ¥ÿdæÜÿ¶õðÿ«õïÿíãÿaÛÐþcäÙÿ)ßÏÿ.ÖÈþ	b[®                        52" /,+>¥Úvèßÿ¤ñêÿèâÿpßÖþ~ìâÿæÞÿÞ×ÿMÒÇÿ¤ÿ    °°× ôôô ÿÿÿÿÿÿ?ÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿoÿÿÿNÿÿÿ°°× °°×    %;#¾iLÿ¦_ÿ£`ÿ¢aÿwSÿ}Y;ÿÕÛ¯ÿòÿØÿØÿ¼ÿ¾zÿNY4ÿ@ÿ_&ÿ}B%ÿG)ÿQ0ÿX8ÿ\>ÿnL0ÿ?!ÿ
ô  ¬   ]       
E<¾ÿ%¿Èÿ0ÁÈÿ2¼Ãÿ/·¾ÿ.´»ÿ.´»ÿ-³ºÿ,­±ÿ(¥£ÿf8ÿ7HÿÑ5ÿÿ\ÿTUÿ!ÿÿrxÿ ;?ÿ
ô  ¬   ]                                                ,<DGî ÿ£§ÿuÿ£¬°ÿUabÿ4<>ÿÿ Ã²ÿasÿ0J>ÿ       ¤ì^êàÿªòíÿïçÿléÞÿÜÌÿ<æØÿÃ´ú                                                 EBL`áÖþðèÿðêÿléÞÿìäÿàÛÿJÖÌÿ¤ð    °°× }}}+'
²ÿÿ	ÿÿ	ÿÿÿ   ÿ   ÿ   ÿ   ÿ   ÿAUMúÿÿÿoÿÿÿ>°°× °°× "\lhL÷¥cÿ¬kÿ¡_ÿsQÿoNÿgGÿQ2ÿ×â³ÿôÿãÿÛüÂÿÅÿNg>ÿ7ÿX&ÿv<ÿ}C&ÿI*ÿV7ÿ[<ÿ`;%ÿ7(þÒ   x   .
!\÷#¼Æÿ7ÈÏÿ6¾Åÿ/¬²ÿ(ÿ#ÿ&ÿ'ÿ%ÿ%ÿTLÿô¯ÿßÿÃ&ÿEÿcbÿ#ÿ¡¦ÿÿUZÿ1,þ%Ò   x   .                                            "$ºyÿ¦´¸ÿ¡²¸ÿ¬²ÿ¥«ÿÿKUWÿÿ¼¬ÿdwÿ2M?ÿ       MGPÝÐÿáÚÿNæÚÿ-àÑÿÝÌÿßÏÿ*'U                                                    *'Tmêßÿðèÿ-àÑÿNæÚÿvÖÍÿ<È»þUO     °°×    ² ÿ   r   I   E   C   B   A   A   A   A   A   A   K   ÷CRLÿÿÿÿo°°× °°× !<'aÿªlÿbÿsSÿgFÿgGÿcDÿ~O5ÿpX7ÿÑß³ÿòÿÞÿÌï³ÿ¡ÌÿdMÿ&(ÿ8	ÿo0ÿ|<!ÿI,ÿU6ÿjI/ÿF1ÿ é      ;9,¤¨ÿ8ÖÞÿ>ÆÍÿ1¨­ÿ"ÿbeÿMQÿFHÿX[ÿ ÿ ÿZZÿAÃ[ÿô§ÿ%ÿc,ÿÿ'¥¬ÿ©¯ÿÿnqÿ;<ÿ	é      ;                                            069±ÿ¬½Âÿ·ÇÌÿÁÒÖÿºËÏÿ¹ËÐÿ³¹ÿÿÁ±ÿ\~nÿ,F:ÿ           0É¼ÛÚÔåTÖÌá:åÖäÝÍäÑÀâ=8	                                            51b	^WÎdÚÐäíååIçÙåTÖÌâdÅ½å$¹­ã     °°×    ?ÿ   n   ?                                               L   ÿÿÿÿo°°× °°× U_FÄ¨rÿ±vÿ¦jÿkLÿq>%ÿi%ÿd ÿEÿE-ÿ_hIÿ·Ò¡ÿæÿÌÿÆí¬ÿÍÿr]ÿXwEÿ9!ÿe'ÿ>!ÿ|N/ÿvT7ÿ`B)ÿ,õ      EusÄÊÑÿ?ÖÝÿ9¹¾ÿ|iÿ
_$ÿNÿNÿGÿ4 ÿRJÿefÿosÿiÿlÿ}_ÿlÿ'¥¬ÿ*³ºÿ"¯´ÿÿÿNRÿ õ      E                          @Û)/0ÿ)/0ÿ)/0ÿ067ÿ.56ÿ.56ÿ28:ÿ,23ÿ+12ÿÿ»«ÿY{kÿ2M@ÿ            ._ÛÐÌPÕÉÌ_â×Ë×ÇÌÛÌÌ
g`Æ	^W,
                                    
	[T%	b[eÝÒËìãÌÅ¶ÇUÙÍÌUÒÇÌ,)J        °°×    ?ÿ   S                                                   E   ÿÿÿÿo°°× °°× ¡}ã¾ªÿ³¢xÿ¤cÿ³¨ÿÅÕ¢ÿ±µÿ´µÿ­ºÿ·Æÿ·Î¢ÿÍë¸ÿ×ú¿ÿÇï¬ÿ»æÿ¨×ÿ·rÿX~Lÿ9)ÿ[!ÿ~I*ÿ|X9ÿlK2ÿ8%û   ¦   J[ÃÈãIãìÿCÑØÿ)ÿh$ÿÿ²'ÿÿ
|ÿMÿ""ÿSVÿ"ÿ(¤¤ÿ+««ÿ)¨§ÿ*«±ÿ*³ºÿ*·¼ÿ"°µÿ£©ÿÿTXÿ   û   ¦   J                             $%ÇNYZøÿÿsÿky{ÿjy|ÿbnqÿesvÿ>FHÿ.46ÿÿÂ±ÿ^qÿ.J=ÿ               	:6BQä×²kéÞ²fèÜ²JÜÐ± 	[T	_WSM(%	                    PJ
d];¼±gçÜ²aåÚ±jèÝ²eçÜ²	:6E            °°×    ?
ÿ   Q                                                   Dÿÿÿÿo°°× °°× ÕÇ¥øÅ´ÿ²¤|ÿ©jÿ©vÿÃÙ©ÿíÿÖÿîÿÞÿúÿìÿöÿåÿùÿåÿæÿÑÿ×ùÁÿ×ø¿ÿÑö¹ÿÊõ°ÿ­ÞÿÒÿ``ÿZ?#ÿx<!ÿ]=ÿkK2ÿ>)þ   ¦   Jùÿø\íôÿBÍÔÿ yqÿ°+ÿ,ûEÿÿÿ2íHÿµ#ÿ	ÿÿKMÿ"ÿ+­²ÿ,²¶ÿ,³·ÿ,´»ÿ*·¼ÿ(´»ÿ#¯´ÿ£ªÿÿUZÿ ))þ   ¦   J                            &*,«EOQõ£°±ÿ«¶·ÿfllÿOUUÿxÿqÿqÿjx|ÿ\hkÿ/67ÿÿ½­ÿY{kÿ+F9ÿ                   N©¡ojåÛléÞjäÚVÂ¹z;ia	VO83                =9`Yxp\ÔÉ.kçÜlèÝlèÝK¢j                °°×    ?
ÿ   Q               Q   Q   Q   Q   Q   Q               D
ÿÿÿÿo°°× °°× ØÉ¨øÌ»ÿ·ªÿ­sÿ_ÿhÿÌØ«ÿõÿæÿóÿàÿòÿßÿïÿÜÿßûÉÿÏò¹ÿÂå©ÿÀÿohÿnaÿhÿhÿz_;ÿ}G,ÿ]?ÿiI/ÿ?,þ      EúÿøiòùÿBÎÔÿw_ÿAä[ÿÿÿÙÿæÿ¡ÿ²ÿ)ê?ÿÿ1ÿKMÿ ÿ'¦ªÿ(­³ÿ*°µÿ)²¸ÿ(³ºÿ%±¸ÿ!¬²ÿ¡¨ÿÿ _bÿ 02þ      E                        $18:Õ­¸¹ÿÄÍÎÿªµ¶ÿ¾ÅÈÿjttÿÿÿqÿpÿpÿ4<>ÿÿ¤Æ¶ÿ]oÿ0K>ÿ                           K¢XeÚÐwháÖ{léÞ9fÛÑ[È¿FB                =S¾µháÖfÜÒgX½´D74                        °°×    ?
ÿ   Q               Q   Q   Q   Q   Q   Q               D	ÿÿÿÿo°°× °°× ¿²á×Ãÿ¿²ÿ«rÿ©hÿaÿhÿÛâ¸ÿîÿ×ÿóÿßÿíÿ×ÿàûÉÿÇê¯ÿ¦ÐÿsYÿ5ÿÿT(ÿ}@%ÿU5ÿ_?ÿ~Z=ÿkJ0ÿ>*ù      ;}×ÜáöüÿJÕÛÿvVÿkïÿÏÿÝÿÛÿçÿÑÿÞÿaöwÿ !ÿ<ÿY\ÿÿ!ÿ ÿ!ÿ#ÿ%¥ªÿ#ª°ÿ¦¬ÿ¤ÿ
ÿ gkÿ /4ù      ;                        þÁÊËÿ¹ÅÈÿ¹ÅÇÿ­º½ÿ¤³·ÿ¡¤ÿ¢¦ÿÿ}ÿrÿHSUÿÿ£Æµÿdwÿ0K>ÿ                                               #!                                                                    °°×    ?
ÿ   Q               Q   Q   Q   Q   Q   Q               D	ÿÿÿÿo°°× °°× q½ÑÂÿÂ´ÿ«pÿ¢]ÿxTÿlKÿbDÿÍÙ°ÿçÿÑÿóÿÞÿêÿÔÿÖô¼ÿÇë­ÿµãÿ©_ÿ14ÿ7ÿd0ÿR2ÿ]>ÿ~[=ÿjK1ÿ4"í   x   .[¤©½óùÿ^ãêÿ#zÿ(º>ÿÿªÿÕÿâÿþ°ÿ8ïQÿ !ÿ
K*ÿlpÿwyÿdgÿSTÿRTÿikÿ ÿ £ÿ£ªÿ¥ÿÿbeÿ &'í   x   .                        068Å¥¦ÿ½ÉËÿ¶ÇÌÿÁÒÖÿ¹ÊÏÿ²ÆËÿ¬ÁÈù¤¸¾ÿ¬ÃÊÿ¯ÈÏÿ«ÃËÿ±¸ÿÿÀ°ÿXyjÿ,F:ÿ   °°× °°× °°× °°× £«Î	°°× °°× ¯°×¯°×°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ¯°×¯°×°°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿ   Q               Q   Q   Q   Q   Q   Q               D	ÿÿÿÿo°°× °°× FM=¿µÿÀ±ÿªoÿ¡[ÿ\<ÿ}C(ÿuC(ÿK@*ÿÆÜ¦ÿíÿÔÿ×ùÀÿÊò¯ÿÌò¯ÿÁì¥ÿ¤Øÿ°aÿ8-ÿ]0ÿ[<ÿeDÿ~Y<ÿ]B,ÿÓ   ]    2b`æèÿqòøÿ6»¨ÿZÿ-¿Dÿwøÿ3ÞHÿ´0ÿ
e#ÿieÿuyÿO:ÿ6ÿIÿTÿ
87ÿgiÿÿ¦ÿ¢ÿÿ [`ÿ Ó   ]                    >!"³/67ÿ.46ÿ-45ÿ.56ÿ.56ÿ.56ÿ.57ÿ067ÿ/56ÿ/57ÿ28:ÿ,23ÿ+12ÿÿ¡Å´ÿcvÿ*E8ÿ   °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿ   Q               Q   Q   Q   Q   Q   Q               C	ÿÿÿÿo°°× °°× 
!F´´óÏ¼ÿ©lÿº´ÿæùÊÿùÿâÿíôÎÿæøÒÿêÿÖÿæÿÐÿÜûÇÿÉò³ÿ¹çÿ´êÿ¹î¡ÿ£ÛÿÀsÿ}c=ÿ[?ÿkJÿuN2ÿQ;%ü	¡   >   #FÙ×óÿÿÿSäéÿ2¶­ÿ!xÿzZÿRÿdÿÿ,¦«ÿicÿÿÈ)ÿ»#ÿ	zÿÿQSÿÿ¢¦ÿ¦ÿÿUUü
¡   >               #%ÃQ[]üÿ~ÿsÿjx|ÿsÿn}ÿl{ÿesvÿiwyÿkx|ÿdrxÿ>FHÿ.46ÿÿ£Åµÿasÿ*E9ÿ   °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?
ÿ   S               Q   Q   Q   Q   Q   Q               Hÿÿÿÿo°°× °°×   acO¦×Æ¥ÿÐÀÿ¨sÿ´·ÿúÿìÿÿÿñÿùÿåÿøÿåÿñÿÝÿãÿÍÿÍò³ÿ¢ÎÿbVÿCI.ÿiZ;ÿkEÿkKÿnNÿiKÿpM4ÿ1!Û   \   #     Iwq¦ôüÿwûÿÿSãêÿ?ÌÓÿ6ÁÇÿ3»Âÿ1¹Àÿ1¹¿ÿ0¶½ÿgFÿâ,ÿ«ò»ÿý0ÿ¾$ÿÿOSÿÿ£©ÿ	£¬ÿs}ÿ0.Û   \   #               &+,©MVYö¬­ÿ§ªÿ`fgÿLRTÿ¢ÿwÿvÿpÿtÿzÿwÿuÿcpsÿ/67ÿÿÁ°ÿ_pÿ0J>ÿ   °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?ÿ   S                                                   M
ÿÿÿÿo°°× °°×    	Iàùà¾ÿÆ·ÿ¨uÿ³²ÿõÿßÿûÿíÿùÿæÿîÿØÿÜûÃÿÌñ²ÿ·àÿ¤kÿ54ÿ@2ÿrG0ÿdFÿuSÿaEÿM9%ó
   4         Ixº¸à±ÿÿÿyøýÿYäìÿEÔÛÿ;ÊÑÿ9ÇÎÿ7ÅÉÿ5¾Äÿbÿô¦ÿÛÿçÿô§ÿÅ%ÿ"ÿgkÿÿ­µÿ¥ÿTTó	   4              *8?@ß «®ÿ§²³ÿ ¯²ÿ®µ¹ÿcnoÿ¨«ÿ¦©ÿÿ{ÿo|ÿrÿpÿvÿrÿ5=>ÿÿ¡Ã²ÿY{kÿ.I<ÿ   °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ?   ÿ      Q                                               S	ÿÿÿÿo°°× °°×      '=(wÃ¾úúãÀÿÅ´ÿhÿ­³ÿãýÉÿýÿêÿõÿâÿãÿÍÿÏô¸ÿÀë¨ÿ­Øÿ`ÿQC%ÿQ<%ÿU8ÿhIÿgL6ý"±   >              >.w×Õú°ÿÿÿúÿÿaêñÿJÜäÿCÒÙÿ?ÎÕÿ;ÇÌÿ$¡ÿ1¬Sÿ¡ì¶ÿ<ãVÿ$ÿUGÿÿª³ÿª·ÿwzý-!±  >                  ¨xþ·ÁÃÿ©µ¸ÿ«¯ÿ¡ÿ¡¦ÿ¡­°ÿ«¯ÿ©­ÿÿyÿzÿzÿÿrÿISUÿÿÀ°ÿ]~nÿ1L?ÿ   °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ?   ÿ   |      Q                                       S |ÿÿÿÿe°°× °°×        7K4¹¸úôÝºÿÆ´ÿbÿ¬³ÿ×òÁÿóÿàÿùÿäÿêÿÔÿ×ùÀÿÐøºÿÆìªÿkÿ`N2ÿ|U9ÿqS9ý.#µ=                     I7ÑÎú¸ÿÿÿÿÿÿcñøÿRåìÿJÜãÿEÔØÿ9ÀÅÿ(ÿfÿp[ÿ|Cÿ#¢ÿ±ºÿ	«¹ÿ|ý5-µ =                     28:ºÿºÆÉÿ¬¾Äÿ´ÌÓÿ¥¾Æÿ¤¼Ãû¤»ÁõªÂÉÿªÁÉÿ©ÂÉÿªÃËÿ¨ÀÇÿ«ÄÊÿ¯ÈÏÿ«ÃËÿ±¸ÿÿ©Ì»ÿ_pÿQo`ÿ=ZKÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ?   Ì   ÿ   ²      S   S   S   S   S   S   S   S   S   |ÿcÿÿÿ5°°× °°×            '='w}àÕÅ£ÿÒ¼ÿ¥qÿ°¾ÿÒÜ­ÿåæÀÿææÁÿßãºÿ×Þ²ÿÊÖ¥ÿÌÉÿoQÿaK5í.&  4                              <,wp³¯à¡îïÿÿÿÿvûÿÿaîøÿZçèÿSßßÿIÔ×ÿCÎÓÿ;ËÒÿ/ÏÑÿ*ÎÖÿ°¹ÿ	ruí/(  4                                                                                         e{qÿÀ°ÿ_pÿ_pÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    !      Ìÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿÿcÿÿÿ°°× °°×                   IulX¦³³óÂ·ÿÀ«ÿ¸¡}ÿµyÿ·¡}ÿ³wÿ©kÿcÿoS÷VE5½k   #                                       IKup¦ÔÑóçêÿïõÿùÿÿùÿÿuöÿÿaïøÿIÛãÿ5ÆÍÿª±÷]e½k   #                                                                                                   &/+¬Si^ÿÀ°ÿÀ°ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×           ???????   ?   ?   ?   ?
?
?)}~}øøø °°× °°×                       
!FVUDq½¸«áÏÁøÊ¾ø¥xãxgQÄNC4!"\                                                   'F6a]Y¡½vÐÕáóøøóøøiÎÔã?Ä!_a&#\                                                                                             °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×°°×°°× .H;ÿ,F9ÿ2M@ÿ2N@ÿ-H:ÿ0J>ÿ2M?ÿ,F:ÿ2M@ÿ.J=ÿ+F9ÿ0K>ÿ0K>ÿ,F:ÿ*E8ÿ*E9ÿ0J>ÿ.I<ÿ1L?ÿ5QCÿ2N@ÿ2OBÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ÿz¸ÿYrÿSmÿHbÿJdÿKeÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ÿÿÿþþþEþþþ"ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ýýý ÀÀÀ ½½½Hÿÿÿm°°× °°× °°× GhYÿVxhÿJl\ÿMn^ÿIjZÿQscÿTvgÿJl\ÿFhYÿMo`ÿGiYÿKm^ÿTvgÿEfWÿSufÿPrcÿNo_ÿGhXÿKl\ÿNo_ÿLm^ÿOqaÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ÿz¸ÿa£yÿOiÿHbÿNhÿLfÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    3			ÐÓÓÓ`ÿÿÿÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ««« EEE.   ÿÿÿÿH°°× °°× °°× ¿¯ÿ¥Ç·ÿ£Å´ÿ¤Æµÿ¥Ç¸ÿ Ã²ÿ¼¬ÿÁ±ÿ»«ÿÂ±ÿ½­ÿ¤Æ¶ÿ£ÆµÿÀ°ÿ¡Å´ÿ£ÅµÿÁ°ÿ¡Ã²ÿÀ°ÿ©Ì»ÿ¿®ÿ Ä³ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ÿÅÿl«ÿYrÿOiÿOiÿJdÿ°°× °°× °°× °°×  ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    3Îzzz£ÿÿÿ6ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ ñññ ___000«   ÿÿÿÿH°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× ª«Ï ¬­Ò ®®Õ °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    ÿÎ©ÿj«ÿf§~ÿYrÿSmÿLfÿ            
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ
@ÿ ÿ°°×    R   R   R   R   R   R   R   R   R   R   R   R°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    3áXXX·ãããVÿÿÿÿÿÿ ÿÿÿ ÿÿÿ ÿÿÿ     222Aë   ïÿÿÿG°°× ¥Ç·ÿewÿ,F9ÿ²   ²   °   ©         }   d   H   -                                    °°× pÇkx|ým{üsþm{þpþl{~þsùuþq|þdorüLSWþDHJþ;?@û¢°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    åv¡ÿÊ¤ÿl­ÿf§~ÿYrÿYrÿ            T1ÿT1ÿT1ÿT1ÿT1ÿT1ÿT1ÿT1ÿT1ÿT1ÿT1ÿT1ÿT1ÿ
@ÿ ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    3   ï¶ÿÿÿ/ÿÿÿ ÿÿÿ ÿÿÿ ççç NNN ###   ô   ¸ÿÿÿL°°× £Å´ÿ\~nÿ2M@ÿÿ+12ÿ,23ÿ(./ÿ(./ÿ"#ÿÅ   i   D   '                                °°× m}úl{þk{~þiuyþl{ýSZ\þFLOùyþkvyþLTVþFJKþ,/1þæybby°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    }å}­ÿÅÿÇ¡ÿ¿ÿz¸ÿ            buÿ[nÿ[nÿ^qÿ[nÿ[nÿ]pÿatÿfyÿatÿcvÿ_rÿXkÿTgÿ 
ÿ°°×ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"ÿÿÿ"°°×°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°× °°×    3   î   ½MMM¶ùùùWÿÿÿ ÿÿÿ ÿÿÿ ¹¹¹ ===è   Ï   ²ÿÿÿP°°× ¤Æµÿ^oÿ2N@ÿÿ.46ÿ>FHÿanuÿjx|ÿJSVÿ%+-ÿÀ      ^   9                               °°× n}ým|þdrvülz}ýkx|þ¤¬°ûXbeþ`jlþCIKþþù  j       °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×        }   ø   ÿ   ÿ   ÿ   ÿ             ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ°°×    ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   1   À   °   °°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°× °°×    3   ÷   ÔÁ­­­ÿÿÿÿÿÿ úúú yyy $$$u   ý   Â   ®ÿÿÿJ°°× ¥Ç¸ÿ[|lÿ-H:ÿÿ/57ÿLQSÿ=CEÿpÿn|ÿGQUÿ;CEÿ   ¥   z   P   1                           °°× q~þo}þk{}þo|þvþ~þ]hlþ:@Cþü  R      °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× exÿexÿexÿexÿexÿexÿexÿgzÿAbMÿÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    Y^ºÿ:Tÿ   °°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°× °°×    3   þ   ×   Éggg½þþþHÿÿÿ ààà ZZZÓ   ì   Ä   ©ÿÿÿH°°×  Ã²ÿasÿ0J>ÿÿ4<>ÿª³·ÿQ\]ÿqÿwÿpÿ?HKÿÐ      l   J   .                       °°× qþo~þm|þqþþ`koþ?FIþüj	
?         °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× Y¡sÿY¡sÿY¡sÿY¡sÿY¡sÿY¡sÿY¡sÿY¡sÿ9TCÿü ÿ8 Q     § Ê ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×    YtÑÿ^ºÿ   °°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°× °°×    3   ÿ   ç   Ò...ÐÃÃÃýýýªªª !!!NÜ   Ö   ¼   ÿÿÿH°°× ¼¬ÿdwÿ2M?ÿÿISUÿrÿÿ¢ªÿ¢ªÿ}ÿWfkÿ)/1ÿ   ²      h   H   -                    °°× n|úrþuþþvþ@FIþ#$þJ            °°×                 °°× -ÿ(ÿ-ÿ%ÿÿÿÿ#ÿ"ÿ"=,i ÿÿÿÿ8p Q Q Q Q  § ÿ°°×  Q Q Q Q Q Q°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×       Y   Y   H°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°× °°×    3   ÿ   ÿ   ö   ócccáãããa­­­ß   ü   è   Þ   íÝÝÝH°°× Á±ÿ\~nÿ,F:ÿÿ±¸ÿ«ÃËÿ¦¿Çÿ´ÍÔÿ¢ºÃÿ¦¯ÿk{ÿENRÿ   Î   ¯      l   J   ,      
          °°× týl|þT[]þIOQþWdgþ;BDþþ_     	         °°×      ©Î××R    °°×                3   3       ÿ      3     ÿÿÿÿqÿÿÿp        Q  ÿ°°×  Q Q Q Q Q Q°°× ÿÿÿJÿÿÿ,°°× °°× °°× °°× °°× °°× °°× °°× °°× °°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°×ÿ°°× °°×    \   3   3   3   3   3         3   3   3   33  ©3°°× »«ÿY{kÿ2M@ÿÿ+12ÿ,23ÿ28:ÿ.56ÿ.56ÿ067ÿ)/0ÿ)/0ÿ)/0ÿ#$ÿË      i   C   &             °°× týl|þ¢ª®þZdgþNUYþ "þw ' 	              °°×    QQQ°þ¯¯¯ÿÿ¯¯¯×ÿQQQÿü  °°×            3   Z             Z   3     ÿÿÿÿqÿÿÿ¹ÿÿÿ       Q  ÿ°°×  Q Q Q Q Q Q°°×       ÃÿÿÿH°°× °°× °°× °°× °°× °°× °°× °°× °°×                                                           ¥3  Ò3  Ý3  á3  ç3##Î3  ®   Ê3  Ò3  Ð3  Ò3  Ô>  £	  J °°× °°× °°× Â±ÿ^qÿ.J=ÿÿ.46ÿ>FHÿesvÿbnqÿjy|ÿhvxÿm{ÿwÿvÿHSUÿ).0ÿ½      ]   8            °°× uýqþuþþS\_þþ  k		               °°×   &&&yyyÊÊÊÊÿÌÌÌÿÌÌÌÿ±ÌÌÌÿÌÌÌÿÊÊÊþyyyÿ&&&ÿ  °°×            3      ÿ       3   3         ÿÿÿÿqÿÿÿ¹ÿÿÿ ÿÿÿ     Q  ÿ°°×  Q Q Q Q Q Q°°×        ÑÿÿÿH°°× °°× °°× °°× °°× °°× °°× °°× °°×                  Ù   ù       ù   Ù                      Ô)eeÿ..ÿÿ;;ÿÿZZÿÿ##÷3  Å   ÿ3//ÿÿAAÿÿ66ÿÿGGÿe  Ù=   °°× °°× °°× ½­ÿY{kÿ+F9ÿÿ/67ÿ\hkÿjx|ÿqÿpÿn}ÿPVWÿ?DFÿtÿxÿHRTÿ8?Bÿ   £   w   L   ,      	   °°× nzþxþ~þþGPSþù   S                     °°×   yyy°ÌÌÌÿÌÌÌÿÒ\\\e \\\c­ÌÌÌÿÌÌÌÿyyyÿüR °°×            ÿ      3                     ÿÿÿÿqÿÿÿ¹ÿÿÿ ÿÿÿ ÿÿÿ   Q  ÿ°°×  Q Q Q Q Q Q°°×    %   ×ÿÿÿ=°°× °°× °°× °°× °°× °°× °°× °°× °°×       ,   Ê   ÿ   ÿ   ÿ       ÿ   ÿ   ÿ   Ê   ,         ggÿUUÿÿYYÿÿÿÿ{{ÿÿ~~ò3  ¿   Û3mmÿÿ{{ÿÿZZÿÿ55ÿÿffÿX  µ3°°× °°× °°× ¤Æ¶ÿ]oÿ0K>ÿÿ4<>ÿpÿpÿl|ÿqÿq~ÿª±µÿS]_ÿn~ÿtÿpÿ;CEÿÏ      e   @   #      °°× p~þqþþ}þCKOþó  g                       °°×  QQQRÊÊÊþÌÌÌÿiiiÒ   iiitÌÌÌÿÊÊÊþQQQÿ °°×            ÿ      3                     ÿÿÿÿqÿÿÿáÿÿÿ¹ÿÿÿ¹ÿÿÿ¹ÿÿÿpp Q ÿ°°×  Q Q Q Q Q Q°°×    &   +°°× °°× °°× °°× °°× °°× °°× °°× °°×       Ê   ÿ   ÿ   å               å   ÿ   ÿ   Ê         xxÿÿ<<ÿÿ**ÿÿ  ÿP  Þ=  º3     Á3  Ñ3  ÿN||ÿÿiiÿÿ..ÿÿ  Ï3°°× °°× °°× £Æµÿdwÿ0K>ÿÿHSUÿrÿ}ÿ~ÿxÿyÿ~ÿ|ÿ¡ÿ£ÿrÿLWYÿ(./ÿ   «      X   6      °°× o~þtþþxþHPSþ í v                      °°×  ÌÌÌÿÿe     ­ÌÌÌÿÿ× °°×            ÿ      3                     ÿÿÿÿ§ÿÿÿqÿÿÿqÿÿÿqÿÿÿqÿÿÿqÿÿÿ88 ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×      ÿ   ÿ   ³                     ³   ÿ   ÿ        ÿÿ^^ÿÿ  ÿM  Î     W   -   V      ¼3  ÿI~~ÿÿ99ÿÿ  ×3°°× °°× °°× À°ÿXyjÿ,F:ÿÿ±¸ÿ«ÃËÿ¯ÈÏÿ«ÃÊÿ¨ÀÇÿªÃËÿ¦¾Æÿ¦¿Çÿ´ÍÔÿ¢ºÃÿ¢ÿISUÿ>FIÿ   Ä      w   O   .   °°× qþtþX^`þHNPþPY\þà   c                   °°×  ¯¯¯×ÌÌÌÿ\\\c     
 \\\cÌÌÌÿ¯¯¯× °°×        3   3   3   3   3                 ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ ÿ°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×   Ù   ÿ   å                             å   ÿ   Ù     ÿÿÿÿ  ÖA  
  7            7      Ò3ÿÿvvÿÿ  Ø3°°× °°× °°× ¡Å´ÿcvÿ*E8ÿÿ+12ÿ,23ÿ28:ÿ/57ÿ/56ÿ067ÿ.57ÿ.56ÿ.56ÿ.56ÿ-45ÿ.46ÿ/67ÿ*/1ÿÐ      j   C   %°°× m|þsþ¥­±þYdfþZdfþÛq       	

              °°×  ×ÿc  ÌÌÌ     ±ÿ× °°×                    Z   3            ÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿ°°× °°×   ù   ÿ                   ï                   ÿ   ù       Ý3  ê3  Ü3                     v   Ç3  Ø3  ê3  Ñ3°°× °°× °°× £Åµÿasÿ*E9ÿÿ.46ÿ>FHÿdrxÿkx|ÿiwyÿesvÿl{ÿn}ÿsÿjx|ÿpÿpÿsÿLVXÿ(.0ÿ¸      V   1°°× R\`þR\`þP[_þYegþKRTþ+-.þ¶   a   9		              °°×  ¯¯¯×ÌÌÌÿ\\\ÿ­    \\\eÌÌÌÿ¯¯¯ÿ °°×        ÿ   ÿ   ÿ   ÿ      3            ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°°× °°×                       ï   ÿ   ï                                                   
   C      Â   Á   °°× °°× °°× Á°ÿ_pÿ0J>ÿÿ/67ÿcpsÿuÿwÿzÿtÿpÿuÿjx|ÿ{ÿQWYÿ>DFÿsÿuÿENQÿ9ACÿ      a   :°°× 8>Aþ5;>þ6?@þ,24þ)/1þ*.1þ/24þ|   B	           °°×  ÌÌÌÿþÿt   ÒÌÌÌÿþR °°× ÿÿÿ5ÿÿÿBÿÿÿRÿÿÿRÿÿÿRÿÿÿf°°× °°× °°× °°× ÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿÍÍÍÿ°°× °°×   ù   ÿ                   ï                   ÿ   ù       Ó3  à3  Ò3  {                   v   Æ3  Ò3  Þ3  Á3°°× °°× °°× ²¡ÿY{kÿ.I<ÿÿ5=>ÿrÿvÿpÿrÿo|ÿsÿtÿ{ÿzÿ­¶ºÿOY[ÿÿuÿqÿ=EFÿª   b   <°°× CMPþEOSþFPTþHQUþKTWþBGIþ368þ¦   > 		           °°×  QQQRÊÊÊüÌÌÌÿiiiÿÿ­c eiiiÒÌÌÌÿÊÊÊÿQQQ°  °°×                ÿÿÿR°°× °°× °°× °°×    ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ          Ù   ÿ   å                             å   ÿ   Ù     ppÿÿ77ÿÌ  à3  ©   7   !          7      Ð3ÿÿOOÿÿ  Î3°°× °°× °°× £ÿ]oÿ1L?ÿÿISUÿrÿÿzÿzÿyÿ|ÿ{ÿ~ÿwÿxÿsÿÿÿuÿPZ]ÿ*/1ÿ   T   4°°× |þpþtþo~þl{}þm|þ=BDü¼   ? 		 		      °°×   yyyÌÌÌÿÌÌÌÿþ\\\ÿÿ\\\cÿÌÌÌÿÌÌÌÿyyyÊ  °°×    ÿÿÿ5°°× °°×    ÿÿÿR°°× °°× °°× °°×    ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ             ÿ   ÿ   ³                     ³   ÿ   ÿ        ||ÿÿ11ÿÿ  ÿ3  Ò3     ]       V      Ç<  ÿ3~~ÿÿccÿÿ  ×3°°× °°× °°× 5QCÿsÿ_pÿ5QCÿÿ±¸ÿ«ÃËÿ¯ÈÏÿ«ÄÊÿ¨ÀÇÿªÃËÿ©ÂÉÿªÁÉÿªÂÉÿ©ÂÈÿ¦¾Åÿ¥¾Æÿ´ÌÓÿ´¼ÿ£ÿKTXÿEMPÿ   7   #°°× þþkyþn}þo~þxþKPSþ¥   D
     		  °°×   &&&yyyÊÊÊüÌÌÌÿÌÌÌÿ×ÌÌÌÿÌÌÌÿÊÊÊþyyy°&&&   °°×    ÿÿÿR°°× °°×    ÿÿÿR°°× °°× °°× °°×    ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ              Ê   ÿ   ÿ   å               å   ÿ   ÿ   Ê         ÿÿ\\ÿÿ//ÿÿ  ÿ3  ×>  ½    º3  Ñ3  ÿ322ÿÿkkÿÿ@@ÿÿ  Ô3°°× °°× °°× [}mÿ[}mÿLm^ÿ2N@ÿ«   Q                                                                        °°× ¦¯³þ¨±µþ «®þ¥¯³þ£¨þ þejlþZ*	 		 		 		 °°×     QQQR¯¯¯× ¯¯¯×QQQR     °°×    ÿÿÿfÿÿÿRÿÿÿ5   ÿÿÿB°°× °°× °°× °°×    ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ              ,   Ê   ÿ   ÿ   ÿ       ÿ   ÿ   ÿ   Ê   ,         zzÿfÿÿ]]ÿÿ//ÿÿCCÿÿ  Û3   Û3~~ÿÿeeÿÿYYÿÿQQÿÿ33ëy  Æ3°°× °°× °°× £ÅµÿwÿGgXÿ#7.º   0                                                                            °°× °°× °°× °°× °°× °°× °°× ¦¦Ë ­­Ó °°× °°× °°× °°× °°× °°× °°×                 °°×                ÿÿÿ5°°× °°× °°× °°×    ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ   ÿ                         Ù   ù       ù   Ù                      Ï nnÿRÿÿÿÿzzÿÿ  ÿ3   ÿ3ÿÿÿÿÿÿAAñ[  ×[  °°× °°× °°× °°× °°× °°×°°×°°×°°×°°×°°×°°× °°× °°× °°× °°×°°×°°×°°×°°×°°×°°×°°×°°×°°×°°×°°×°°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°× °°×         TRUEVISION-XFILE.            @ @  l|qrrwo|m|o}kx|ul{~huxl{~lz}ssso~m{}ly|on|qiw{rlz|qlz~n|qguxo}rtrrsrmzsttrspvp~n|n|o~n|~m{}sp~o}viv{ qvl|n~qpn}q{rmz~uo|{kx|vpm{p~kx|m|m{~m{}lx{tly|i|ivxsivypiw{ppm|m|trpqpttstpm|o~ruxpl{|mz}lx{m{}sto}pviv{ttqxnroro|pwtsro|viw{rgsweru~m|ply|ly|kx{jxzcrwrl{~un|l|n|l|n|iw|tlzvn|pursrkz~po}lzp}rp~pn|lz}m{}un|p~pulyesxm|sl|tpotqo}n|tm{ttxpl{xsm{}sjxxm{}n}o}m{iy}ly{ky|ly|sn|yl|zjx|upjx}n~n|qo|zqpok|pptvup}sp}p}p~o}tvuto~k{~l|tn~tl|uwrwrtm|xxtusxtrhtuly|o}p~kz~kz~sm{n}o~qn|ukx|tiu{lz~trtn|o~lz~sp~jx|m|opkz~rpsp~rr~o}o}m}sun~n~ql{qn|tvtwtp}o}sxswpvvrsm{ssp~l{~pjx{p~uiwzky}stxplzwrqryo~pn|rl{qm~m~jz~xprp}sssn|o~i{qnsm|kytxptrtqrtn|qqrswo}rtuxsuriw|sl{tivyjx|_otpsvrtprqrqqppn~l{k|m~l|pjx|trp~lx|rr~pp~wssqtovoporpo|to|tquply|ro|tx{xvpp~pjx|pm|rpgx}iw{sl{|psm{m|pptpm}n~on}tospkz|m|tppp~txxp}n}txfuxm|~uqtzttn|n~o~l|~tqqsxxxssttso~o}siy}rl{}n|ivypn~pix{n{~q~o}o}stsptl|pl|lz~tsrsky|urgtxsxo|rjx|m|ontqstn|vtqn|l|tl|~oo}sustqsp~jw{o|srly|fvzl{~m|qn|jx|n|rlz}po}pp~rlz}qp~ppm{tpn|rl|om~psp~m|pzxjz}pl|okz}ttwq~tl{oqtl|yrrrssppslz}vp~pn}n|fuxm|kx}hvypiw{hw{n}sn|n}o~trrn|q~p~o|tptl|l|wo~osm~ppl|ppjzm~pqn|s|q~wwpm|~qryyun|{trqprtm{}sl{l{~sm{m|jx{shtxn}m|o|~p~n|pm}stpo}o~ttn|tlz}rn~lzl|rl~rxl{jzjzppk|pp~kx|l{tm{}ttqqstvo|qp~tly~o}qttzp~m|pjx{p~uix{p~kx|qpo}o}n|p}pm|lz|q~o}xqn|~pn|~n|~to~o~l|npptpm}rrtpvo|mz}so~kz|n}o}ly}o~o}p~n{p~vpttpl|po}qqqiw|sl{thuxkx|ivzn}lz|n|pky~o}p}p}rttqsq~o}o}tvtqpptk|tpop|o|mz~stm|~stm{}o~ttn}psopto~tqtyqtn|qquo|pjx|rm|rpu|n|lx|lx}lx~n}up}sututp~pp~rvtopqnoqm|rm~sspm{p~m{~p~m{}n|ivxp~n}tl|n~uwttpv}rl|qqo}m|m|o}skz|rl{}jv{ttslx|p|n|oo}uvtsvrppttrrvtl|l|ttptpm|pp}uum{~m{~sm|}p~p~xtn~uso~sn|n|tqlz~ro|p}qo|jw|sly|slz}m|rgtwm|sjx{tkx|l{~p~qp~tp}sruvppxtpn|n|qiwxpnz~spm|txrjx|m|tsp}to~m|k{~l|ptpkx|n|o|iw{qo|o~lx|uo}o|s~jx|ppm|o}vjx{sjx{tuprrkz~p~o|p}stqtqn}yql|~n|~p~o|o|n|mz~piwys}m}k{|p~jx|ttrn}qo~qix|kz|l{}ttn|pn|n|kx|n|o~o|trwo|m|o}jx{ul{ftwl{~l{~stto}p~rvpp}sttvswpn|ttqo|n|~ttm|~po|p|o|po}rp}p}lx}tqqix|k{}m|pivxp~my}to~kx|rpn|~p~{rly|to|{jx|vpm{p~kx|n}pn}ly|qsr~mz|vp}sutwvpo}itxo|~n{}yqn|~pn|~qo|m|~stp}tlz~jxzp~m{}p}n{n|pl{}m|}p~n|~o|n|my}sn|rqppwtsro|vhuzrgswequ~m|rpn|rrrutuvtsvvp~n}n|~n|~n|~rp|n|~n|~tmz|xppturrv|p}mz}jx|jx|m|~tspn|~m|}stm{}qkx{qn|~qn|tm|ttxpl{xsm{~ul{~ruky}urp}usp~tp}txstn|~o}p~tp~po|n|~n|~rrtp|xo|kx|utrp~jz|k{|o}htvn{}mz|xp~m{}o~m{}m{}ql|}l|~qtrtm|xxtusxuvn}ptxvunsp}uix}p~p}o}wq~tvtpp~tlx{n|~p~tutky|m|~jxzpm{~p}sjx|rplz|m{}m{}m{}qo|m{}m{}tttttql|~lz|txswqvvsssjxzrtwq~urwrslz}xqqttvtttqzplz}tqto~trv}p}mz~mzo{phuwkxzkxzm{}o}to}o~n|qvwvrtn|o|trssxm|sxsp~q~qn{stwvsjwzl|um{p~puo}tpl{~o~vrrtyvn|to|kx|uutmz~p~p|o|p~lx|gswlz|to}o}o~ttqxytto|qrqqm|o}l{~tuo|o|vqtpwo}prn}sjx|ppsuppsn~tl}pp~two|tn|o~shvxo~tkx|umz~up}ro|p|~p|n|~uuo~o~vqyswp~yqrtxsto|tp}xrswuwztpujx|{ppsupusvn}uprst|jx|rro~pxky|tlx|ttup}p~p|~m{}o|~qsqtutvtn|~o~vx{}wply|to|rtszsxpro|st{zxkx}uqn|stwutqvsvp~o~ply|wm|iwym|m|tpp}sutp}p|~q~suutqtwo|p~ptuttsqtqlz}xxszm{~srsuxnzrn{xnzqssusivzo|~n|~vqn|rp~|ly|xro|plz~o}to}mz~rr~lx{up|qttt|trrtqpuytly}tsm{jx|rqpupvrsqn{suqxxpsp~qp|ro~spto}tqtp~wiw|thtxgtwo~lz~vvro|tn|sussp~xuqqo}rp~p~rvl{svppl|ly|tp~tm|tvqtprst}twpqurp~n|stvussrurm{~xto|tkx|uutpo}m{}n|m{}stvtwttsp~qqo}p|o}vp~trtsrtqm{~psswvosq~zunzpvxrrsstsiuyqn}rrprurtprwtl{wn}rom~n~l{rp~txvs|rp~o|m|~rm}rn~qo}tsm{jx|qpn}m{~rtxurp~p~kz|sn|rrsp~qrpqsm{}o~ply|sn~qqo}tn|tzpn|qpl{sn|l{twtrlz~tso~to}n}i{l|on~rsvppl|qq~p~sn~tpkx|m{sm{pl{~rquppquruspym{ro~qtqnz|rpm{~o~ttp~uvn|to}p~rrn|o~pl}rqky}kyl|l{rly|vp~trtqrqqn|n~m}l{k{~iuyl{jx|p}qrm}puutn~p~qsn}o}iv{qn|pttwttuo~o~tq~qxvm}yqlz~rkx~plyoppn~nptpl|n}o}oqro|o~lz~qpn}m|drvlz}kx|tuq~ql{}so}tp|ttsspqky|stqxrry|qstsp}wqrunojy}l|pukx~pn~jw|m|pk{qopprqrttto|n}qq~o}k{}o|ro{m|uo~qn~m|ppskx{tpiuxl|tky|o~ortxtxzwrxttup}ix|rpl}kz~l|ptn|k{n|pnptn~po~tl{vxo~qrqpqo~m|m|ss}o}o}hw{o~ppqp~n|n|qm|siw{o~oppql|n~tqwtrt{ro~tl|ix}m}gw|urn~n~m|pn~nnqpl|ptn}pn|typl|p}n|rrl{so}l{jz}kzetytn}psvl{}sp~qjw{vn|o~o~ssttrwzzqwrm}tpodrxk|k|hw~k|pn~ppk{pl|stl{trn~qwptrtqtl|n|ussol{iw|ix{l|huzrp~pmz}qqwvtly~|o|o~qppuytxyiuzzrqqpptm~pjzppl|n~m~nsqqtprtttporwtl|o|xm|~gtvqjz|ftxo~xmx}ulz~psppqtp|p~n{tn|o|qptpqxn|rmzply}p~iyl~qtk}}n}onsmmpptpppn~s{tqqo~yuqrlx|ttptl|guyrrvp~ywtp~m{qsptxqtqn|n~ryuxo}trm|qo}ooj~vfxok}nm}pnj{spm|pnsprttvwl|nzxo|~to}jx|qm|o}qo|p}po}rvwspqpt|qiv{n|m{~ssxn~nl|pwo~qm}p~pexl~`r{mm~jzqptm~mnjzm~qly|n|rp~ttwpp~qo~tttrusp}qskxzuspm|~ussupwtqpo~p~n|m{~pl~l|l{rvpm|m}rugxfwfxbt{lk{potvn~rskzspl|m{uqtkx|n|o~tp~n|~r{rtxqo|p|o{}l{}uskx|rsptpqm|l{}o~n|kx{o|on|nix~rn|slz~lz~tpoqpizk|k|om~putorqqtoppstgvzn}oqtrwqtt|{tsspl{}pkx|pp~n}pssm|vtp|vo|m{~m}n}n~onkx}lz~jx{n}l|~prp~ly}okzqpsn|ppqptppo~po~tjy~yo}o~qtro|o~tpw}tmy|sly|rp}tso}sppptjx{m{}qp~m{}pl|oqqk}pptwwjz~jy|lz~qqm{m}qvprn~k|ppm}qql|prwxwiv|so~txrzlz~urto{o}tsrujx|l{m}n}sppqqm|m|n~qn~twm}tm{qtn|tm|p}ly|o}n}nprppjzm~jzrhvzpol{trumx}p~mx}vlx}ppn|o~t}tp~p}xo}sro|mzk{pprpp~svupphxfwl~n|tl|n~pl|to|tlz~jw|tqn|m{ohxpphymj{o~jzrqstuttn}vvn}qpn|l|n|owo~qqsqly|{m|jzxjxzpp~n{~rvsm~l~ev~pl|n~qntoprkx|lz~jx{n|lz|o|qjx|l{tm|rj{j}j{moptn}p~wwqn}s|pto~l{}n~ly~ly}ttrtqprwlz}jzptppo~trl}es|l}l~k|pix~ml|n~qsn~rptyn|lx|lzly}p~m{m{~l{k|j{qm~j{spm}up~p~qo~u|ukyn}o~tp~tql|rpptn|m}l{pm|tpk{m}k|m~tpjzm~pptottpm|~sl{~kw{rtrly|o|mzphuyl{oo~l}ptm~mmoosutsqo~o}sttto~wttrtqpn|ix|qrpvskzsgxssrtl|l}uk{ptvn|qly|m|qgtxn|rix|tly|l{m|lz}lz~ppptvk{nytq~lx|tn}ix{l|tl{osvtpt|qqwn|piw|jy~r~ql{l|thzk}ml}nl}qpqstsyivyppl|n|uiw{rjw|rtm{p~lz}k{}l{~ptrpm}o~m|qo}o~rm}qix}m~nsuqtn|p~txwl|rqn}x{{ul|ix`pzl~l|rpl}psputptn|m|~n|kx|tlz~ivylz~lz~rrtm{m}lz}o}jxzp~m|rjyk|ovkx|so~skx}tpqptqso~tptxto~n|wjx|nztpurk|mm|pl|p~utm{sp|sly}tn|zkx|vplzo~jx|l|o|m{qtm{l{}p}m{}m{~m|l}ok}qm{p}sstuuo}vqotn|vprrlytn|qtlyzp}ql{jzpuro~pxwtqtp~qsqn|viv{qfsvequ|l|rl|lx|o|rm|p~qk{opl}n~o|prm|pkx|n}sp}tn{qpl{m}sxokyvn|ly~ttrtqqpp~ssrsrxsn{~vn|lx|p|ttwpl{~wrlz|tgtxttrm{ro|sssk{nwqskzpo}urp}vvpstoix}kyqpix}o~o|xotxo}txshu|ttkz|ptutjx{lz|jxzp~pm|wxttswtul|l|rttrsto~rpl}rtxskztuvspwppixn~n~ottttppqtqo}n|m|tl}tvmz|rp~rm|spt{n|sstpvvsstgwypqxrmzujy~ix~prm~tsxupp~utvpupkz~l{o~puswvm|pn|xttqn}qqpm{~u|lx|sm|rm{}kx{stqm{~qswm|sxspqrturjx|lz~iwzlz}k{pvwwuro}pm}uo}um{~swsvsqpqto|o|l|rto|~uroppo|q}rskx|sl{}m|rhuxm|sjx{tlx|n|l{~stn|o|rpo|rl|rm|rprqusuurvpo}spo}sup}ul|i{l|sxn|~o~pswn~totrrsro{mz~r}jx|ppm|n}vjx{skx{sqm|n|p~n{~n|n|ly|rlz|qlz|qlz~iwztstrpsttspm{m{rpssn~pqm~p~o}uqo~o~m|tztpztt        TRUEVISION-XFILE.               »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»º»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»s}s}sssssssss}k}ssk}{sss}sk}kyk}s{k}{k}s}ssk}sk}ssssk}s}{s}sky{sky{j|zpeotaqoanoS]_OZ[BKL<FD7>?7>?4;@08719<7>?;@C<FJGQRJVUYdfZihhqwmv}prsssssss}k}ssk}{sss}sk}kyk}s{k}{k}s}ssk}sk}ssssk}s}{s}sky{sky{k}{sku{»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ky{ku{sssss}sssss}ky{ky{ss}rri{qqi{q{i{yqqi{i{i{qyqqyqqqiwyiwyqyiwypmw~bsq]msSaf@GI;BD.45077(./"''$$ "$ !!"##!%&)./-349AB@HIP[\U`b]fkjxzm|~pqq{qqqqq{iwyiwyqq{qqi{qqi{q{i{yqqi{i{i{rzss{sssky{ky{s{ky{ss}k}{k}»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»k}{scu{k}ssssss}ky{sssrqoynmv}dusctrct{ctrcprky{lu|dutldntzly|l}du|du|lyly]lsdlsdlsbjqbrwZih`pn]msPZ\BNQ5<>/47(./.84:KDC^SFhXLscPzfGjXGhYB[P2?:&-+"""'(.557>?CONNYZJX\]mshuwj|ky{ky{ky{kt{cprky{ky{k}{ky{ky{kt{k}kt{ctrctrct{ctrcprky{lu|ctrleot~o~qj|k}ssk}s}s}s}sk}{k}{k}ky{s»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»s}k}{k}{sss}s}s}ssssr|i{yhylz|jzkuzckq[ehS]`MWYMWYR\^R\^MYYRY^LZaHOSGPRGPVGPRPZ\HSXKVZDNVLW\KRWISVBIM>GIAKO=EG6<>/67/69)-12<:KdZ\uRzgw±q®s°|¹v³v²u¬c|Puc6H@+2. %(+)-0&-.)/15@B<EH?HKIUWFQTJQUJSUFOPAJKFOPFQUJSVNUZNUZNUZJQUFQUAJKAJKJUUFQQJQUKTZMYbKU\KU\Xeder{m{}wi{sk}k}s}{s}ky{sk}{{ky{s»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»k}{ku{sky{sk}s}{ss}sriwyn}bry[giZbhRY^GLQCIN8BE8?@8?@;EE4<<7<@7>C3;B4;@07<4<<7>C4<@7@C3:>0:<3:>*14).1,36/77.45(/0&-/$)+ #%3C=S~lr®t°{¸¾££Î»¯ÓÁµ×ÅªÑ½«Ñ¾³ÕÄªÑ½¹j Osb.=8"(*$)+7>A0696<>39:>EG>DG>DG6>A6>>28927929929<29<8>A8>A8>A8>A8>A/779?A9BG;CI@HLHQVS\_Yefer{cszoqksk}s}ssssk}sku{»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»{ky{ss}ky{k}k}sk}{{s}q{gxarp_lm8AE&+,  &(#$!$%@XMm§k¨hS~jYtSulG_[>SR-<A6GKZytgÀ©¦Î¸¿£v°Vi6HA!!  #'(;BFYefetydt{oj|ssk}k}{sky{ss{s}»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ky{sku{ky{sssk}k}hzn|~amw^klJV[8AE#(+")+.683;>3:=4=@FRWGSXIVZIVZKX\GUXGUYJW]COTERVERVGTX=ILIW[CPTCOT?KO8BE.69*25 &(Mg\h¡u±Rk5RI*=9*78'01'151AD2<E+6:*5:1>B2BAGc\q|«»Sze5F>
"$!#!#/7:2;>;FJ:EH,462;>@JN?JN=HK<HL:EHBMP@KO@JN?JN=HL<HL6@C4=@)14"(+ "!#5;@QZ]Ydgcowjwn|~rssssk}{{{s»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»s}ky{ss}ss{k}r|lz|_ouVajIUZ8BE#(+!@LQhw}­³¡¦|rstwtnprpmnarysqkex|\krIW[CPT*47Mh^c}`y\uÉ¾v.:?#%+7<7CK<NTEW\:IO:GN1?DQ\d«­TkbÆ­v¯Mr_8IB "'(&'+14KY]]pth}h}O^cbu{xrkcz`tyonqlez~[mqznEUXERW"(+
!#19<JSVS_d_kmfwuprs}k}s{sss}»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»s}ss}sssrqoy[jpQbdDOT9AF%,.!$[kq­µ­³¡¦WegEORrstwtnprpmm_pvsqkex|\krIW[CPT*471:>DTScp­Im\9UN®¸°ËÓªJWY!%%.32?G8GK.:><JOn|­µ$*-j}Æ«u©Jk],52!)+$+-"'(9EGIUYKY]]pth}h}O^cbu{xrkcz`tyonqlez~ERTDNPnbw|Rag &)289MUXNWYZbglu|oyqj|s}s}sss»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»s}skyk}{srqnxbryS`d?IM3::"(*%(+q­ÂÉ¥ºÁ©°¡£­¯Weg ¥z~ zvy{{uYhiGSU7>A:EIWxmr°p­Fj_&54FX`Â×â ¸Ã¨²Ziq$*- !*/"+03=B}£¶Ã§´Q_e#+/4EE´Äªbx?UK !")+&-.=JNM\_\kpk}vvvvv|~ v||©«Ucfvusj~?IK#)):BFHQR]lrizgxqr|ss}ky{s»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ky{ky{s}k}{k}qn}ivx_lm=EF,02¡´º¦ºÀ¦ºÀª¿Å¦ºÀ¢µ»£¶¼¢µ»¢µ»¢µ» ³¸ ³¸²·¡³¹ ³¹²¸ ³¸±·²·²·¡³¹ ³¹²¸ ³¸±¶QZ]AFIL[Zo¥o®\x8OM )->MW©ÀÉ¶ÏÚ¨´¡Ydk#+/!CPU|®´¯¶¡:CG0?A(4:VniªÒ¿v¬JiY-64-35&*,=DGIUZ£§§«¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹¡µ¹dqu	
 !39=MZ_[ioarxgxvqss}s{»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ky{s}k}{s}r|o~bop_gmOV[&*,!)*(/24>C-791;?2;?1;</8<18<3=@8CE5?B9CF2;?/8<18<3=@8CE5?B9CF2;?/8<18<3=@8CE5?B9CF09=&-0#%$+-Pe_t³l¨Mxi!-/'46D[e]mvÏäí³¿mz¬|§ª§°¬³_lq&135CF1AI6DF·Â¨_s8HA!$!$!$09<09<09<3=?/8:-57+47(-/*13(/1)13&-/%+-$*-(-/*13(/1)13&-/%+-$*-%,.&-/%,/'.1)14#%%'BKLNZ_Ygmizhywj|k}ss»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»sk}k}j|pky{anoLX]<BE;EI-585>@08;8CFIV[LZ]KY\GRWFRVGTWGSXHVZL[]GSWHTXGTXGTWGSXHVZL[]GSWGRWFRVGTWGSXHVZJX[ALP5=@*143=?Uwjx¸Xp?\V *-5GJDU_GXa¶ËÕ²»£¯¬¤°«¶¬»®¾§®|@GK+39;HP<HP*5<f}Ê±g~?UK!$*14/7:;GJAMP@KO@LO?JN@JNALPERTBNQ@KO@LO?JN@JNALPERTBNQ@KO@LO?JN@JNBMPDPS=GK4=@4=@,36!$")+&-/AJKWdi\kkrprss»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»s}k}{rhzk}boqT[`<FD""7?ER^e²¹¡¨¤ytwzuyzvyytyspvrq~{pcv~Xgn?LO:FIfmªMvc2HF'+AS\?MX?OYnºÔÜ¯¸¥°§¥°®·¥²¡iw|!)*%.26EK<OX)57XyuÂ¦f~IfX "$&:EHIW\g{tu~{ z|ur|qx~vxst^rzHW_;HO/9<&.1*.0@HJ\eiisxk}hzzs»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»j|zq{yo~ctr[giU\a>IG*01;FJ ¤¬±¸etwLW[¤ytwzuyzvyytyspvrq~{pcv~Xgn?LO:FI¼£u´Pxe'57-9>:OXDS]8INQ`d¦½Å§³·À«¶£¬¥³´Â¬³s " )273CI&05D\\É²·Mm]#*,1:=N]dg{tu~{ z|ur|qx~vxQ`cALQqf}dxL[`$+..45CNQO\abkqkt{o~iwy»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»i{nxviryanoTb`CNR077HSY°ÈÑ²ºµ¼­µªµ¹_mq§ §¦¤¢©¢©¡§¡¥¡£¥}}`nr~|l~N[_;GJ£Î¹o¬GjY$03*4:9NV4@GAPTy°»§¼Ê¯ÅÒ´¿¥®¸Æ¨¶®´¤®cov2;=&-1$/1>QV~³WkHhX$%+25=GJarwux¥£¡§¦¬©°¤¥¥¤££ª¡z}yz§«Sbexswki|&-0047CNRT[`aqviznx»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»hywj{zaioS]_@IJ.45"$¥·½°ÄÊ¬¾Ã¬¼Â©¹¾¦¶¼¨·½§·½¦¶¼¤´º¤´¹¢²·¢²¸§¸½¨·½¥¶»¯µ¤´º£²¸¢²·§¸½¨¸½¤µ»¯´¤´¹¢²·¢²·§¸½¨¸½¥¶»¬² ¯´U_c¿¨|¸DgV3CE'368HLGW_}²»¥ÂÉ¨ÂË¤¸Å ´¾«´«ÀÇ«¿Ê¯¼¥¿Î¡ºÆDMQ#+/EYWÈ°v°Qud%')167OUWy¦·¼°ÄÊ­ÁÆ¢²·¢²·£´¹ ±·¥µº¨¸½§¸½¢²·¢²·¤´¹ ±¶¦¶º¨¸½§¸½¢²·¢²·¤´¹¤´º¦¶¼§·¼§·¼¥µº¦¶»§·¼¥µºª¼Â[cg		 ".45@IJS]dhtvjxz»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ev}\ljTb`@KJ)/0"$.24*/1/575;>9@B9?A6;>27:17:.36+03).0+0127828:/67&+,+03).0+012794:<HQT179+03).0+0127828:/67&+,).1!%&½§Â©@bR(75+9<FV\«ÆÎ®ÆÎ¡ºÀ§¾Æ§¿Í¨ÀÉ´¿gy¨¼Å ´À¥¾Æ£»Â´»<DI=RKÉ°z·EbU ""''-4527:278+01).0+03)/0/6728:278+01).0+03)/0/67)-/(,-$(().0+03.3617:27:6;><CF;BD5;>168/5727:"$		,03@KOZhlcpr»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»anp\djIOT'+-3<?8CG0:>COSITXIUZJY^M\aMZ_L[_KY]JY_K[a7BFIV[UbfRacQ`cUeiGVZL\bRagVdhRadN]aUfkK[_JY_N]bUbfP_bQ`cTdhFTXGV\?JN:DG¤¿¤Nwc2IDMZ_®¶´Ë×·ÍÙ®ÃÏ¬ÅÑª¼Ç¬ÃÎ«ÂÍ ¶À¡¨§««ÂÊ¤¼À«ÅÊ¾Ûå¶ÏÕª±1:=2H@p«r¬@WO"(*1:>8CHBORRaeP_bR`cTbfN]cL[`JX]UeiQ`cRacUbfN]bKZ`IW[UeiDPS6@CTbfO]bJY_K[aKZ_LZ_M[`N]aN\aIY^IV[GSWKVY6AE'/2&-/ "188ISTVab»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»fw|W^c#'*18;NZ`gv{¢¤£¡xyuvwVgox©|{¡wyx} yzpi~h|mk`rymor\ovERWt«Ò¿P{fu¡¤ÂÆÇàéÊãíÆÝç¿Öà·Î×ÑæîÕêòªÃÎ ·¿¶¾°¼¬°©¾È®ÅÎ´ÊÔÀÙá¶ËÓ¥ÀÃ`wu¯k<LG1:=>JOVfo^pt`rwgzryu¢« |¢rv h|[lrzsyvqqwokrtq|dx^pyFUX7BD%,.=CFWbc»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ev{HQR6?C_nr~²º²º]lpLW[¡ª ¨|¦zz}}}}¦rtxvwz¡rszvzzy oq}wrcyPbi\ml°ÐÁgGo_8OL(/8FMDYc>R^>T]FU[´ÄÍºÒÞ ·¾ ·¼¦4>>&14/<@7IL<MR6EHJiedºZq/;9:GM<HM[mtqyrq}¦£{¥«wz¡~v}}rrxvtsqnsrssPbfALQwssg~FVZ)37&-/@FJP]b»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»gpvLYWbot¦ª²±¹­¶©´¸^mq¤­¥®¡ª¢«¤­§§¢«©²§°¤­ ©¦©²¦¯¦£¢¤£¥¡££¢¢¢¢££¤«|\gl²¡ Ë¶o¬6PH&42'16.8?9JMK^jAUY|ºÏÚªÅÑ³·o}#&0>C<IPCV[6CI;MNw¨¹x¯IdZCLOLV[cnrsz¢£~¦ ¨£ª¦­¥¬ ¨xwz¢¢¡zy  }wuu|}}§¬Scgxxv ©`os(-.GPQSaf»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ky{_km®ÂÊ­ÁÉ®ÁÉ¥·¿¤¶¾®ÁÉ®ÁÊ­ÀÉ®ÁÊ®ÁÊ¥¶¾¥¶¾¤¶¾¥¶¿¥·¿¦·¿¦¸¿§¸À¦¸À¦¸À¤¶¾¦·¿¦·¿¦·¿¦¸¿¦¸À¦¸À¥¶¾¦·¿¦·¿¦·¿¦¸¿£µ½ ²¹­´®µ¬³¬³yWd_¨Ëºº_x:RM%(#-/-7>>KTDS]SfoÅÙß¨¾É«²FQV$(5AHMah.<?)59Swm|¶¿£_u198QX\bmp¯¶°¸£¶¾£¶¼¢¶¼£¶½£µ½¡³»¡³»¢´¼£µ½¤·¿¥¹À§»Ã¢µ¼¢µ¼£¶½£¶½§»Ã§»Ã§»Ã¢µ¼§»Ã¡´»¡´¼¢µ½®µ®µ®¶£µ½¦ºÂ§»Ãª¾Æª¾Æ«ÀÈª¾Æ§»Ãlz}N[Z[gi»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»fsuivxaqvQ[]O\aJTUGMLGPQFOPFLPFOPFNPJTUJTUFOPFOPALKALKFLPFOPFLPFLPALKALKALKFLPFOPFOPFLPKQUALKAJKFQPFOPFLPFLPAJKAJKALKENOCLM?DH1:9t§Íºv±T|i>YR&32$,1,9<8FM9KR°¶·ÒÚ~*59)48:HO/=@4DEIh^v¯|¸k@SJ&,.-249BF@HICIHENOFOPFLPFOPFLPFOUKTUFOPFOPALKALKFLPFOPFLPFLPALKALKALKFLPFOPFOPFLPKQUALKAJKFQPFOPFLPFLPAJKAJKALKGPQGQRJQUJVUQ^]anoivx»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»hzxnw~jxzlv{brp_omWek]ik]ec]lkVbc]ek]ekVek]lq]ek]ik]lq]ik]ek]ek]lqVbcVec]ek]ik]lk]lkVbcVecVbc]ekVbc]ek]ikVbcVbcVbcVekU^\U`aQ]^XbdGNR§Î¹»]uEgY/B=%21&()68JUZÒêõSei#(3@D3CC;RNFh\h¿£w±F\T.25=EEOVZR`^XfeUci\hj]ec]lkVbc]ek]ekVek]lq]ek]ik]lq]ik]ek]ek]lqVbcVec]ek]ik]lk]lkVbcVecVbc]ekVbc]ek]ikVbcVbcVbcVekV_]WbdYdfiuwentcpqfw~»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»jxzqpnmv}lz|ky{k}ky{ky{cprrky{kt{ky{ky{k}k}ky{ky{ky{rkt{cprk}{kt{k}ct{ky{ky{k}rkt{cprcprcprky{kt{cprcprboqamodmsVecKXX}§Ïºº{¸Uj:TH8QI1E@4CB¤¨@RR9NJB^VPugkq©»w¯LcZ4;<DMOR]_]mqdmshvxjxzk}ky{ky{cprrky{kt{ky{ky{k}k}ky{ky{ky{rkt{cprk}{kt{k}ct{ky{ky{k}rkt{cprcprcprky{kt{cprcprcprdqsmv}gxvhvxiwy»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»s}sjxrqqqqisyi{yqiwyq{q{qi{qq{iwyi{qqqqyqi{yqi{yiwyqqqiwyq{q{q{isqiwyiwyiwyhzm|~brp[ioFRRawq¤È´Â¨½¢u¯m£VlJn[AaP=[Lawo¥|¶¾¡z¶r¤G]T:?CIOTXde[gpiwym|~pqqisyi{yqiwyq{q{qi{qq{iwyi{qqqqyqi{yqi{yiwyqqqiwyq{q{q{isqiwyiwyiwyi{qj|zj|k}{»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ss}ss}sk}s}sk}sky{s}ssss}s}sk}sk}{ss}ssk}sk}{k}sku{k}sky{sky{k}s}ky{cqsky{sj|hywdu|ertJUWIWUyªÍ»®Ó¿¾¢¿£y´¼¾£{¶¸¿¥lWvhFXUDONKWV\kpentl~|oyrk}s}sk}sky{s}ssss}s}sk}sk}{ss}ssk}sk}{k}sku{k}sky{sky{k}s}ky{cqsky{sk}k}{k}s»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­¦©¡wv^mnty¢Æ²©Î¼¨Ï»©Î»¸¢¥h|l|{z ¤ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­ª­»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{yuq}}jvw^kk]jl_kl`ll_kkanpfsup{|uxy{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»                                                                                             »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   -35]nyIW_SbgKY]YfhS`bS__P[\XehMWYP\aITWMY`KW[M[^AKNP^bEPST]^PXXQ[^MVXKUUP[[R`cSadQ^b6>B   »*EJU¡CsLEv~QL~L}Jx}PGsyJyCowGvEs|Gx<djJ|@jrM{JtyKxGrxEqtJx}K~LJy)@E #»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»    £{eyVekKW]T`bZgkWce[hjOZ]NY[O[`KW[KY^R`eO\^VaeP\^ITXV``R[[KTWJTVITTMWXO[_Q^bQ]a6>A   »ÐÜo´Ä]¯OEs}M~RPTHw~Gv|HxEs|EvK~HyOJyCoxO~Kx}EowEovCnsGsxHxK|Jx1PV)BH»/3Ey3[e9go6_g@lr;ci9_d<gm9_e8_g3V^6[e3Y`6^e,KQ8bi1QX<`e8[`8[c3UZ6Z^9ci;em<em(*	»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¤©­µmsk}vysw{vjyl}wt|{tttqxzuT`e)02»Õäáóc¦¹h¯¿b£°j°¾m³¿h©´l®¹oµÂj¯¼`«b£¯l³Ái°¾q¸ÂvÁÌo´¾tºÇyÈÓi­µvÄÐi­¸i«¸g¦²m°¾n³Áj®ºM~>gn»{ÁÌ`®J<jt7`hAnvBryCrx@jr9`g9cl7`h6bi=lt<elBox9ci9`hBlq;`e7[c6[_7[b9ci<hq=hq#;@*/»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   «ºÀ©¸À|ql|xv~n~tkzy~}y¢¯±uqn}unkzry{T^b)/2»ñÿïÿqºÍg«¹b£°m³¿s¿Îj³½vÄÑr¼Èd¥°i¯¼b­m²½r¼Çq´¿m°º|ÂÌâïj«·gªµd£®j°½d¦²b­hª¸m²¿o¸ÇM|=dm»yÁÎ~ÌÜQ X¤T_«]¦Z¡b¡­_ªUQ]©]©b£­hªµd¥¯m°¼d¨²]¦b¦²Z¡V[£_ª`­Anw%@C»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¦´»¢¯µ£u{}tyyry|OTT´¾¿{¡~zm}tn}zvWch*03»êûäóyÉÚj¯½tÁÑo¸ÆvÄÓs¿ÌyÄÒq¹Æi°¾m´Âm´Âh¦¯m°ºq´¾vÁËHns¡öÿo¹ÇxÈ×r½Én³¾c£¯i®¼d£¯n·Æj®ºP@ho»ØéÒâ^¡²TU_ ­_¡¯_£­c¨´UX¡TY` ª_¤_¤h¡ªÉÖQUUTOPY£_¡¯8`g#<@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   £²¶¨¬¡©¦«£±±§°°´¿Â·ÁÄ®·»¢§wunj}\bc	

ÃÊËÀÈÉ¹ÄÅ¯¹»²¼¾©³µ¬µ¸¯¼¿£[hn)/2»çõÛç}Ñât½É×æåïäï¡øÿ¤úÿîûÒálµ¿j³¾d¨³`£®yÃÑT°ÿÿ­ÿÿ¥þÿðýôÿéõëøôÿyÆÕxÈÚT=dm»Ðß|ÃÑh²¿]¨n·Ær¼ÇxÃÑ|ÈÖ{ÄÑh­¹[¨]ªTVd¤®Y*>A¤ûÿxÄÒ}ÍÛw¿Ën°¼m²¾n²¾b£°`¡¯=go$=A»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¤§¦´¸£¦&(( !!¤pu{[ac

134©´¸R^c)02»ÕáêøtÁÎÓàx¾È%79#%)*%(./~¾ÈÌÜeªºj³Áo´ÁT#%,-*,(*)*(*"$.EHêøv¿ÑK|=gn»|ÆÑ}ÄÑh°¾r¸ÃrµÁV[c^v³½j®ºV UU_£,.q©°i¤`_^Ybw½Él·Ç=go#<@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   §«¡­²¦^gh


¢§¬ ©k}`lpv{}ª­T`e(.0»Øæáï|ÎßV,-ÚçÑâb¤³Xj ªÝêM~<bj»vºÄÍÛdª·^#79#23y·ÄhªºX¤]¥/1bw¾Ì@lv#;@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   £¯¶ª¯¥		



"$%ºÁÅR^b


$&&«´·LWZ)02»äôÝë{ÌÜ
"24¦úÿK|#46êöFs{>gm»~ÆÕ|ÂÐb¨µ

(8<ØçJ}$(ÃÎAls#;@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ­²¯¾Ã{;BD		CHJ¥p					GKL¤§MZ^&+-   »áïöÿo¸Ä7X^ #>`eÎÝe¨· BdiÕáGw=cj»ÉØÓâX <Z``¥4Ybv¸Â<gn$<@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   §ª¡¯²smw|	

¢eszmxzxvbnr{v:>@			Q^b%*-   »Øåâðh­¹c¨"$ÎÛs¯¼]¤c¥m«µvÁÎj¯½Y"
o­µw¹Ãj©´sµÁ6RY"${¿Ìs¼ÈK|<bj»y¿ÌÍÚT3QX7RYX6Y`6X^Bioh«¸^«2RYKsyEmrEnw=bh
Ejqj®º=iq#8=»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¥²¸¦µ»l}KTV


68:®·»vmux|{u[gl £=CE



]bcwR`e(.0   »çøëûb£°t½ÌEov
3KPîûj­ºc£qµÂtÁËo¸Äj°¾TËØ|ÆÕ~ÌÛ9Y_Us¹Äl´ÂK~Alt»ËØÌÛPY #"o¨³m°¾YZb¥°^©V-JP{ÄÑr¸Æd ­26%(]b¥²<jr"9=»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¤±¸ ¬´wvkz~"$
¡fjk¬¶¹}vvS^e|179



356}l}Vch$,.   »æøàñl°Áj¯¼bª/3	ÍÚ]ìús½Çq¹Çj²¿j²ÁL|q´Âs¼É.JO
1GK~ÇÓq¼Éb£®O;dl»ÌÛ|ÃÓVZ 8_eT~s°ºm¨²gª´_­Y¤U4V_i«¸T#%P}h«¸T@mv14»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   «¸Á§µ»}{}[fj	

­·º|yxcr|pn{}


x~{yMZ_"),   »ïÿëûq¼Ìo¹Èq¹ÉT
îûqµÂm¹ÈmµÄZ¥eª¼d¡¯q¼Çm©²r¸Ão¸Çm¹ÄGw8`h»ÖçÍÜ]­_®Y %<@s¯¸d¥°]­[ªH|TYCsy3OTc ª_­_¤¯9em,1»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ­³ª·½w~rwMVY



²¼Àwyzxjyl}l}hvzU]^l~t|^ko*03   »áðîþl³Âr¾Íh«¹l°¾Gryôÿl²¿mµÄnµÆm´Ã`«b£°b£°_¥	M{b¤®vÆÒi­¹q½ËVCox»}ÇÖÑàX¤_¡¯XR),vµÁb ®]©]«Z¦MPT2RY)*K~`¦°Z¤_¤°Gx 79»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¨¸¿¬²nhxx	




±º½zx¦rq,34s{ytuYgk'-.   »ïÿàïd¨µ_«m³Äv¿Ðv¾Í(*ñÿn¸Æm³Ât½ËvÃÒxÃÑ~Îßh©·t¼Ëg©´*EHh­¹o¼Çm¹Ãi¯¼j®ºQ@gn»ÕåyÂÐMO_°j°¾=emv²¼d¨³[¨d¥²g«¹j°½l°¿Z¡g©·;dj6^d`¥°^ ªY£Z£<gn14»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¤´º ®´^nvuq~<CE
						





«·ºzt ¢¢£©«¡¦©¡§ª¡§¯²tzqtsKW\"(*   »êúâñVj°Ãg©¸rºÇ8Y_îûn¸Èi¯¾ÐÛÎÛÜç×åØæÍÚäðtÂÐi«¸n¹Æg©´i®¼h¯¼Es}3UZ»ÎÝ{ÃÑCvYªZ¤L~o«´b¦´V j¦¯l¡­v¯¸s«µqª³v²¼}ÆÓ]©[¥Y X Y¦2V^,/»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ­³¤«rryjx|


¤ªxhx~ $%
¢¤w~wvi|S`g(/1   »áðÖæh«½hªºm³Ä`¨Õäm³Â_©24

Òßl¯½r¼Él°¾s¿ÍjµÆ_¡¯L~;bj»|ÄÒv¸ÇT[©]ª;cig¡®h«¹Q 12y¾Ë]©]¨`­]¯P8`j#<@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¨«£©gu}¦{w¡~}¢§¤©xfvy"&'	

¦®¯ywxqnXgo)/2   »ÚæÓâ^¨{ÌÝo¸ÇvÁÎwÃÒxÂÒl­¹xÇ×rºËq¹ÈÒáÕäm¯¾]¤"47áìm´Âs¾Ìl²¿m²¿g®¾d¨¸P;bj»yÁÌr´ÂMi³Â_­j²¿s¾Ðl¯¾l³Âm¸Çj²ÁX_ e¥²Y¡1HLÐÜ]¦^«]¦U¡U¡;hs'@F»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ©® r}|{ujuz(*+«®19;

¹ÂÄ|y~l~rWem&,.   »ÜêÉ×h­ºq¼Çq¸Çv¿Ís¾ËwÃÑs¼ÌoµÄj°¾`¥"$'9<ÝëyÆÕ.LQ¥ûÿqµÂmµÃs¾Îr¼Ëb¥³h¯½P7[c»|ÃÑmª·Tb¤¯^¨`¡®b¤°eª¸`¡¯Z¥Fs|v¹Ãt½É4OTßìX£b¨µe­ºU]­<gr#9@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ª¯ izuxxzk{ !¯µ¹v¥­{~Wdk%+.   »ÝëËØ_­xÆÕj¯¼m´Ám³Ás½ÍvÃÓnµÆb ­-/s¯¸ËÖëútÃÒj´Â~ÖçsÃÐo¸Ér¾ÐP7Yb»{ÂÐy¿ÌOb¦³Y¥Y£Z¥c¨·_¡¯Y #%6OTGmr*=AÎÜU£c«¹h³Ái³Ã^­7_i#<@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¨­©·¿qw{|n}|ythw{##			>DG¢ª®pt~ §¤¬jy~N[`&-.   »ÛéîÿgªºlµÃoºÉqºËd£°q¹Ëm·Çi®º_¦12	"$$("9ZbÝëe©µi²¿r¾ÌyÐßÕæ`ªGx8]c»|ÄÑÎÝU¡[ª`¤³`¡°UV¡V¡_¡¯8_e$9=Hv;Y`{ÂÐRV d­ºh°¾_ «6]d"9=»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¡¯³¬²v|w¡tsix{_lq			AFH®µZci¢¨¡erz{~y S^e"')   »äñàïjµÄq¼Él³ÁyÇ×i¯¼h¯¾_«o¼ËvÃÕV<^câóRÓâyÇ×]¤o¸Çr¼ÍmµÁyÉ×L|3RX»ÍÛyÂÐ] ®_¡¯T[¦^¡°Y¥Y¦d¯¾h¯¾ 8<cªr¿Ð`­h«ºY£TZ¦Z£h°½7^g27»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¤³¹­²z}m~l|y u} 8@B	

	

		&()¡¦xxvsv|LW]"&)   »éùáïn¼Éq¾Ìc¥°b¡¯m¸ÇvÄÖj³Áq½ÎsÃÓwÆÖ4U[%79}ÄÑvÈ×|ËÝm´Çm³Áj°¾h®½j¯¾q¼Çs¿ËFs~2PX»~ÉØ|ÆÓPU]¨V¡Y¨X£Y¨_ ®h²¿X	Tj°¾b¦´Z©PX¡`£²]­_­j´Â6^e49»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»    ®´£±¶jziv|vvl}tu~z#')vopz£y¡GRX#*+   »âñæõ`«_¦s¿Ìj³Áj²¿b£°i¯½j°¾r¼ËvÃÑn´Â"69

v²¼s¼És¿Íj¯Ád¨·eª·n·ÆyÉÚm¸ÇvÂÐyËØBmw7]c»ÐßÎÜQU_ «Y¡URU[¦dª·h¯¿T/JMw¼È_£¯b£°c©·_ ®_¡°i´Ã]­m¹Èi´Â8`i16»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¨¶¼¨¶ºwuyvsqm~t{}"%'QWY£~§®p¨°|©°~MY^ %(   »ìýìúl³Áj¯¼m¸Ãj¯¼h­¸gª·c¥²i­¹o¸ÇvÃÑvÃÓq¹É"37KsyÎÜr¾ËvÁÎs¿ÎØée¦´Ûës¿Ðq¼ÌÜìr¾ÌGv3T[»ÕáÌØe«¸g®º]©PVQTb¥²X`£°i²¿[¦O_©j²¿`©g«¸j´Âc¦´b¦³l·Ædª¹j´Âc¨µAnw 7<»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   §¶¹¤±´ ¤k}qpm}vo}¤¤w¥¤ ¡|Wdi%+.   »ëùåó{É×|ÎÜvÂÐb£®g«¸eªµc£­j°½vÂÎd£°vÃÑxÈÖ|ÍÜvÂÑv¿ÌyÈÖsºÄwÄÐyÇÕ|ÌÜl³Á|ÍÝ{ÌÜxÆÖyÈ×q¹ÈP;bi»{¿Ì~ÆÒ]¦l·Çb¦´UPX U]¨Z¨]«_¡®] ªnÁÐY _©h«¸c£®b¤¯h®ºeª¸dª¸h°¾c¦³h°¾<gn"9=»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¨­¤¯²|¢ª|k{vwt~z}~|ª°y} §¢£ S^b&,.   »Ûéäðq¸Â~ÒäwÆÕq¼Ëb ­j°½l°½i«¸r½Èn·Æq½Ër½Éq¼ÇÜìm³¾q¹Ã|ÉÖxÂÍt¿ËyÆÒ~Ðàv¿ÎyËØ|ÌÛvÂÐyÇÖL{<bj»çôçôÌ×ÓâÍÛ~Ë×|ÄÒy½È{ÁË}ÄÐ|ÂÐ~ÈÖ~ÇÓÒßÐÝËØÌØÍ×ÌÖÐÛ×åÕâÐÜ×äÖâÑß>dl4VZ»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   »ÄÆ¿ÇÉ§´¶ª¸½¨µ»¢²¶£±¶¨¬¨««®¡­± «¯¤±¶£¯²ª¸»¦´¸¦²¶¨³¶¨³´¨³³¨µ¶«¸»¯½Â©¶¹©·¹­¼¿¬¹½¦²¶Vae4;=   »¨þÿ­ÿÿéõïþëûæõæõÛçÛçßëáïßìæõäðïûêøçõéõçôçóêöïûõÿëùîúôÿðþÜéUEnt	»MyÈÓØåÒÝÚæ~ÆÒÇÕËØ}ÆÐ~ÇÒÌ×ÌÚÓâÜìÑßÐÜÜéÓààëçñÎØÝëÒÝÓßÒáÍÛ<^b(*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   hpt«­«»¾§´¶¯¿Â£¯²¡¬¯¤°µ¡¯±ª­¢¯²¤±´¦²¶«¸½°½Ä¨µ¹¨³¶±½À­¸º¯¸¹¿ÐÑ¦±°¯½Á¬»¿¦´µª¹¼¨µº¦²¶]hl!$%   »_ÝêóÿéõøÿäðàìåôâïÝêâðåóçõïþõÿëùéõõÿïûïú¯ÿÿåïõÿóÿéõðýëúçõX1MQ»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»                                                                                                »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   p~lx|gswlz|to}o}o~ttqxytto|qrqqm|o}l{~tuo|o|vqtpwo}prn}sjx|ppsuppsn~tl}pp~two|tn|o~shvx»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   ¹ÁÃ¡ ¢¢¡£¡¤¡¡¤¡¢¡¥¡£§ ¢¡¥©rpo~p»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   !&'!"  ## $%!&'"&(!%& $$ $%!%& %&!%&$% ! !  !!" $&$(*%)+$)*"$$)+!%&"&'!%&!%&!%&#$!" !"#!" KUXply|w»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   (-.%*+&*+(-.&+,%)*%))&*+(--*//*/0*/1+02+13,13)-/*/0*00*02+02)/1,23',.&+,%*+%+,%)+#()',-(-.',-)./%**',,&+,(-/+/1,24*.0+02)./,24)-0+01,02+02,12*/0&*,*/0,12.46+02&*, $&ENP¥©ly|x»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   4<=1792795;=49;1684:;38:4:<5;=5<=7>?;CF8?A6<>4;=5;=4;<4<=7>?9@C6=?1895;=5<=18906839;39;1894:;2994;=28:3:;39;39;6=>9?A7=?:BD:BE6=?8>A6<?7=?6;>7>?6<>8@A7?@9AC6=?4;=*/1!%&wiw|»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   RY\;CF;CE:@B9?@:BC7>@:AC;BC:@B;@C9@B=EH<CF:BC9@B8?@9@B9?@9?@:@B<DF7?@:AC<CF9@C8@B6>@6=>:BD8?A:AD7>@:AC;BC9@B:BD9@C:AC;BD;CE@IL;CF=EG9AD:AC<CE:AD9@B8?A;BD;CE<CE8@B.34$()ur»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   T[_PW[OWZOVZPW[OVZOVZOVZOVZOVZOVZOWZOVZOWZPW[PW[OVZPW[OVZOVZOVZOVYOVZOVZOVZOVZOVZOVZOVZOWZOVZOVYOVZOVZOVZOVYOVZOWZPW[PWZOVZOVZOVZOVYOVZOVZOVYOWZOVZOVZSZ^GNQ>EH38:-35#((rp»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»                                                                                                                                                         MTXELO5<=.35"&&ply|»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»{{«   256!%&59: $%6;< $&6;= $%6;=#') 7=>"&( 7=>!'( 7=>"&'6<=!&( !6;<$)+8>@#() !7=>$() !:?A%*+!"9?@%*+ !8=>%*+ !8=>%*+  :?A&+,"'(   OVY5=>/46#')ym{»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»´   AGI-34"&'?EG-24 %%=DE,23!%&>DF.46#')>EE/66"&'=CE,14 $&?EH*/2"&(>EH,26!&'>EG,23#'*?EG*01!&&>EG,24"&(?EH,02"&'>DF-24"'(>EG+12#$>DF+01#$>DF+01#()BGI+01#()   OVZ4;<,23#'(n}o}»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»º   CIK-34%**CJL-23#')AGH.46"&'BHI-25#')BIJ+24"&(=DF+12"&)BHJ+02"')>EH*/1!&'?EI+13#')?EH,36"&(@EH-25#'*AGI.46#(*?EF+23#&'@EG,23!&&?EG-24!&&?EG-24"&'>EG.46%)+   NUY6<>.45%)*pq»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»   CIK-34%**CJL-23#')AGH.46"&'BHI-25#')BIJ+24"&(=DF+12"&)BHJ+02"')>EH*/1!&'?EI+13#')?EH,36"&(@EH-25#'*AGI.46#(*?EF+23#&'@EG,23!&&?EG-24!&&?EG-24"&'>EG.46%)+   NUY6<>*/1&,-iuxl|»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»º   <AC)//"#<BC).0##:@B(./"#;@B(-. "8=?&,."#8?@$)* !:?B',/ "8?@%*,!"9?A&+,"#9?A&+- ";@B$*,##<BC&*,!":@B&+,!":?A&*, !9?@',. !9?@',."#=DF&*,$(*   EMP4:<+02$)*m|s»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¶   -13 !389!"389!"59;!"389 !168289 "168!#178!"278 !389 "167"#278 !167!"167"#167"#167 !"   CKM7?A*01%*+xdswaos»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»´                                                                                                                                                            ,24:BD5;>*01(./NZ^CPT@NR»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¸   T\_:BC9AB9AB<DF>FG;BC=EG>EH6<>>GI:AC:BE:BE9CH9BG;DI8@E9AF6>C9AE9BF7?C8@C8@D8AD;CF:BF:BF;CF9AD:CF;AD;CE;CG9AD9AC:BE=EG;CF7?A9?A=EG8?@5;<:AC6>?4;=;BE<DF8>A<CF7>?*018>@.46:BE:BE;CE»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»º   T[_:AC9AC;BD9AB:BC=EG8?A:AD8>A9AC7>@9@B6>A7@E:CG;EK7@E@JP8@C9BE8BG;CG8AD8AD9AE9AF;CG9AE9AD9AD8@C;BD?FI;CG:AD:BE9@C>EH<DF:AC:AC7=?;CF;CE9AB;CE7?A5<>:AD:AD<EG9@C*01CJL:BEPVYNVXFPS»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¨±y~¥¥£ª³}®´~¡¨¡§y~u{wwvo|y{x~yzr}»   V_a:BD8?A8@C:BE>FI<DF=EG9@B;CF:BE8?B:AD9@B9AE9AF6@E<GM4=A9AE7@C8AE8@C9AD8AD6?A;CG9AE8?C9AE8AC;CF9AC:AD;BE;CG<DG=EG7?A8>A=EG9?@;CD9@B6=?:AC8?A9@C:AD9?B9@A9AB178)./qy{¤p»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»po¤­¤¼Äª°²¸§°´½­³ ´º©¿Ä¡·½¬±±µª±±· ²º¨®¢³ºª®°²vhv|vy§« °´©¯¤¤¶¹§·¼¡°³¯½¿­½Àª¸»ª¸º¬¹»¯º»²¾À¬¸»¨´¸®²£§|»   RY\8?A8?@;BC;BE=FI8@C8AC7?B9AC=FI9@C:BE8@B9@B9CG3=A7@E1:?8AE8@D6>A:AD9AD;CG8@C8AD8AD6>B8@C:CF7>?8?B:AD9@B;CG;CF=EG9AC9@C:AC9@A;BD;AD;AD:AC<CF;AC9@B:AC;BD7=>/67,13px{¢¦s»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»i{Rbi$&
		   			
¡­­¢³´£¦±µphx|	!            [ij§´¸ »   T]_T\_T\^T[]T[\T]_S\_S[^S[^U^bW_bT]_T[]T\^U]`W_`QY]PY]PY^OX\S]`S[^T]_T]`V^`W^bT\`U]`V^aSZ]V^aT]_S[]T[]W_aU]_V^bSY\T[]T\^V^`T\^T[\U]_YacU]`V]`W_bU]_T[]T[]^dfFMO,23TZ\¯¸»¯¸»°¹¼¥¯²»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»z7@E#(+ÂÍÍ½ÇÉ»ÊËºÆÈ¶ÄÇ¬»¿x eruª¸»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¨9BG	#$$+-$+,$*,%+-"(*"(+!&)"$#)+#)+,35'-.$() $%ÌÔÖÔÜßÉÓÔÈÒÒÌÖ×»ÈÈ¡ $&#&( #$"'("#!&'!"!" #%!"  !!%& ª¯}»[gi8DG"% $"$#&"% $"% #"$ "!$"%$' #!$!$"%Ufjt»[gi8DG"% $"$#&"% $"% #"$ "!$"%$' #!$!$"%Ufjt»[gi8DG'*&7<.@D)9=!374FJ2DH4IN-?C4GJ8JO5GK8KO4GJ6GJ$59%)Ufjt»#'#'"% $"$#&"% $"%!$"$ "!$"%$' #!$!$#'#'#'»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¤;CH		)131:;,543:=.57.48.593<?&,0.587AD+342:<.45(-/ftz[hh]kk[fehwwVce&+-*/2.36*01(..,34+12(.0(/0)./&*,#(*$$"$ !%'!#¦´·z»=NQ,=@Nbg_uzSej[rxYmrVjo[rxQeiYns_ty[os_tzYnr]orTjnI\`4FK.2MY[»=NQ,=@Nbg_uzSej[rxYmrVjo[rxQeiYns_ty[os_tzYnr]orTjnI\`4FK.2MY[»=NQ,=@.@ECW\CWZ=PT1BEVdhJY]<NS?UZ<NRCW[FY\=OS,=@M\_N_b.AF#'MY[»#'y_uz_uz_uz[rxXlqTglUkqL_dSfkWjoUhlYmsWko[mpShmI\`H[aH[a#'»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»h{DRV	"%+.5>B)046@C.693<>4=@1:<,352;=2;=-47/69,36'-/)/2%+,(..',,*/1%)**/028:*24&-/.44.55/56-22288.44,24'--&*+%**#$!&'!¨ºÂ~»"%[puvarv¡¯³¡szuvVim¢¥¦ªnQfl3EJ,0»"%[puvarv¡¯³¡szuvVim¢¥¦ªnQfl3EJ,0»iyh}*-	`mp¢±µz|xo?QU./asw[lo+?D"»#'¥©}{xqj{~hx|]mq\ko]lp^mq_osiy~mmlnH[a,0»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»rAMQ	
  "/8;09<,461:=/7:+25.587@C19<8BD19<5=@5=@.58-466?B,36*01.46-46,24-34(-/,24/57-33.44-44,23.44-33.57+23)/0#()!&(!&(!!#¢«{»#&v u*7:"$mz}¯¾Â¥¨£¡§¡|L^b ",;<©­}iATY"%»#&v u*7:"$mz}¯¾Â¥¨£¡§¡|L^b#,;<©­}iATY"%»t~,.](.HWZ¥©qg|=OS8©!#03Sej9KQ*.»#&¥©}m~bqsqi{VglHUYANS9FIANRFTYN]aZjnarvk}KY]jz}H[a"%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»£KW\		 %'"(*.684=@3<?0:=,4808<08<3;>8BF8AC6>@<EG39;6>@5=?3<>08:*1318;(/0,46',./79179167278/56077.65.57,34-45.57)03&+.#)+ %' "®¸|»" ¤+9; "6DG)79Udg¡²¶¥¨~tJ\`"/2N`d)+0=@rEV\ #»" ¤+9;##j(5;Udg¡²¶¥¨~tJ\`E¶&.0=@rEV\ #»{-/n  Ã¬*0EUX¬¯s8JO	9  Ã  Û«!#148KQ+/»"¥©{¿ÆÇl}j|M\`9FJ4@C?INDOT@LR?KP/;?9EJP_chvypH[a #»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»KW]		$% %(-59/7:08:4=B3<@(/4.6;6?C2;>;DF8AA7??5;<:BD3:<5>A08:2:>07:1:<(/108;*23389055289/46,3307719;089-46(-/*03"')&,.$*, ¥­|»#&¡,:<!6EGSehVgk+9;Rbe©¹¼EW\#03QdhZntN`e)+0>AlH[a#(»#&¡,:<"{  Ð¹)7=Rbe©¹¼EW\F  Ð  è¸&.0>AlH[a#(»1AD0    Ó  é»%,@QU;MQ	9  ¹  Ó  Ç  +&6::NU*.»#&¥©|vQ`e<HL;FJQ_ck{l|gw}Xgm?JP3=AANRRbfYilm~H[a#(»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»£COT	
"(+!'++48.483;>5>C7AE(/44=C6?C2:=8AB=FH;CD<DF5=?4<=5>A2;>2;>6?C2:<5<>078,24399288/56.45.44067079.57-36/69*14(.1.58$),!¤r»#'¥©>NQ+-:IK\lpdw{_pt'47M^bHZ^#13L`cWkpSfjASW#143CGqDV\ »#'¥©>NQ=    à  öÈ&29M^bHZ^F  Æ  à  Ô -83CGqDV\ » u3BE?  ¥  Û  çÏ%+	;    ·  Ë '&7;_y4HN+0»#'¥© {csxYjnQ]cLW[3:=/7:JX[`nsLX^AMQFTXSbfhx|DU[ »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»z?JP	"$"(,*16;DH>HL3;@/7:2;@.5;08;.6:7>A9AD5=>7>@;CE8AC4;?4<>9BE8BD:BD:BC4;<28:7>?1899BC3:<3:<17918:/58-36/68.58+14'.0%*,$&¡¨s»"%©­@OR$13GVY^ptcvzh{&46$24>NQK^bSglATX-03DHlf}I^f#»"%©­@ORL  ²  è  ô"Ü%28H  ¢  Ä  Ø*43DHlf}I^f#»§«xh{.>A
<  ©  Õ  í¾  Ï  å  Ý*&6;Xpzi5IP+0»"%¥© ¥¬°¤v).0               *13fw|Udh;FIJW[hy}H]e#»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»vGTX		!# %(3;@:DG5>A@KP;DI:CH4;@-58,263;=9BE7AA=GI<DG5<?:BE3;>9AB;DF;BD5<<2885<=.46089/674<>2;=/69/58/68.58/57-47-35+14%+-"$¨³¥°»"%´¸u;KN!.1HW[[lqgy}ZkoWjnauy\puFX\"033CHe}vhH\d!»"%´¸u;KNI  ¶  â  úË  Ü  ò  ê¦,73CHe}vhH\d!»¡w4DF
<    É  ç  å  Ý¥*+;@nf|]w=RY/4»"%´¸ª®½ÉÍ¨¹¾Xdh                     O]ar>HL?KNiz}GZb!»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»o|m{}m{}tttttql|~lz|txtrvvsssjxzrtwq~urw»©¯GUX	

#% $&.368BD:DG07::DH4=@8AE/692:=19;6?B6?A8AD7@B8AD;DG:BF7>>8?@7>?8@A2993:;29;6?B4<>19:-58/7:.47079,25.58.58*03'.0'.0$&³¼r» "¨«£¦ª®AQS!.1@QSTgkcvzauy^quM_c#038HM{sjvMck!» "¨«£¦ª®AQSI  ¦  Ö  ô  ò  ê² ,78HM{sjvMck!»£§{sz+._  ±  ×  Û  ë .?'*x s]u6KP/4» "¨«  ®³ÁÊÎµÄÊ4;=                     /58~GSV;GIdtxJ^e!»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»o}o~n|qvwvrtn|o|trjz{#*' £n}sxsp~q~qn{stwvs»¥?JM		 %+,3;<9AE4;>=GJ7@B19;9BE29:5<>4<</555=?:BD2:=6>B8BC8BD5>@2;=9@B7>?7>@5;=3::3;<.575=>/68/681:=08:4<?29<,37)/2)/3&,/"§®|»%(°´ ¤¨*8;.=@J[_\nr\otg{2BE%47£§­jiH]d!%»%(°´ ¤¨*8;l  ¾  ä  èø-;L%47£§­jiH]d!%»%(£§tDUY	;  £  Ï  å  Ù  Ï¹(/EW[«°s]u4IN 27»%(°´®¼ÁÅÌÏ»ÄÇ                     ¢R_c?KO_ptEX_!%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»o}o~ttqxytto|qrq!*(FON¥®°yuo|o|vqtpwo}pr»t;FK

$&#)*;EG;DE2:::DG/8:7?B4<?6=?;DE2898?A4;=:CE07:29<7?D5>B7AD09;6=?9@A3:;7>@7@A5=>/682:<18:/7908:.5818<-47,47)02)03$*,"$¤­¡»"%°´ ¤ ¥Qbf$14EUXXjnbtyYmsThnZos(7:Rdhª¸½jeKbj »"%°´ ¤ ¥QbfH  °  Ü  ò  æ  ÜÆ'5<Rdhª¸½jeKbj »"%£¨¡¦?OS@  ¡  µ  Ó    «  É  ã
³&.BSZ ¨z9NU!59»"%°´¨¬ÄÌÏÌÔ×@FI                     29;¡Q^b?KOaquH]d »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»uuo~o~vqyswp~yq:DE$!=_`Fwy¡ª­up}xrswuwztp»w>IO!"7@B>II?JI7@C3;>5=@8AD1885=>9AC0577?B5=?4<?18;5=C7@E6@D08;5<>8@C4<<5<=3;;4;<18:3:</5919;/68/69-45,36+35(.0(/1(/1!&(ª¯»"&°µ¥©®³L\`(58DTWM]aZlpFWZDW\Qek^rxTho'59O`g­µ¦nPho"»"&°µ¥©®³L\`!M  ®  Â  à	«  ¸  Ö  ðÀ&3;O`g­µ¦nPho"»"&FWZD    ±  í!,
;  ©  ã  ßÀ#*8KQ¡DUZ-2»"&°µ£¨±¼ÀÄÍÐw                     KVYqHTXCOS`ptLci"»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»qsqtutvtn|~o~vWegFbbRH|}:ee©°±rtszsxpro|s»q8BG	
 %(#%4<>=HJ<EH9BF;CH5<?:DG1796>@4:<057.462:<08:07:5=A2:=08;/8;7?A18:8?@3:;6>?5>>29;18;/5907:.58.46,24+13.58+24*24'-/!&(£´º» #£¨£¨Sdg*8;@ORL\_gy}L[_%25 -0CV[\qxZnv[ow$25EX^§®CW^"» #£¨£¨Sdg#Q  ¤  ¾  ú«".9H  ¶  ð  ìÍ#07EX^§®CW^"» #¡GW[:    »  Í&03CF,=A<  µ  ×  Û¡%8JOFX_/4» # ²·¢¡«¯´¾Á¼ÈÍ>CE               +24x\hmERVP_bk}BV\"»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»q~suutqtwo|p~bpr1KI}ÑÒg­®PEyy?ll±¹¼|lz}xxszm{~srs»z<FK	$&#)*6?A5<BCMT=GL:DHBLP8AC0681898@B18:3:=/5808;18<0895>A29=7@D19;7?A5<=6>>2:;5<>5=@/69.5819<-47.46/68-46.46'-/,35)/1!%'¬± ¦»"%©®Tdh&46DSVPadYjmJ[^)79@PS9JN!/1I[aVjrZmtK]e-0EW\£G[d"»"%©®Tdh$G  ¬  È  Ú©&3=@PS9JNI  Â  ä  è®+2EW\£G[d"»"%¡¦4CF  q  Ù#.5EHuq&7:?  £  ã	|+<@8LS$6=»"% ²·¢¦¢¥¢©µººÅÈ¾ÇÍ~GMO068R]_brwHTWERVctxpGZc"»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»p|qttt|trrp~2GEÒÑ~ÓÔÚÜ^£¤MLIlm©±³vqpupvrsq»p3;?	
"()*129BC@JP@JO9CD9BD=GI8@B0587?A4<>18:18=,26)0318=0784<>6>@29<2:<0793:=7>@3;=6>A07:4=@07:.5818</7919</79-36,25(.0&+- %&§¸¼»$(®³APS#%5CF]osHW['47BRU~3DG"03BSX]qx:KP!8IMmVmw"»$(®³APS (~  æ¤$0;BRU~3DGL  °  ð"8IMmVmw"»$(¤¨+:=	h!+6FI¡{n*:?Cs%5:p8LS#5;»$( ²·¦ª¢¦¢¨¬¦²·¹ÅÉÅÍÏ»ÄÈ®½Ã¨¬¦ªn|N[_HUXYhlt}Vmw"»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»sussp~xuqq*43(64v·µzÑÑ~ÖØ{ÑÑààY@nnMw}| ª­mz}tp~tm|tvq»}CNR	
#(*(./>GI?IMAKODPT@JN?JN5=@;CF/683:=07:.48.48/6918;6=@29<6?@5=?19;2:=3;>6=@4;>7@C18;6?B0690794<>/6819;/8:/69,35+13',.#%¦¶»» $±µ ¥8GJ$&7EH$24CSV£¨©®¡¦{7GL%367GK "2BG}mTis#'» $±µ ¥8GJ!)u!.8CSV£¨©®¡¦{7GLP#2BG}mTis#'» $¥ª¢1@D0?B¡z|*:<$47nrAV\/3» $ ²·¡¥s¤¨¥©­²²½Á·ÂÇ«¶»¯½Áfuy[im^mrfw{Zhl~K^g#'»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»n|m{}stvtwtFRSY|ÑÑo¾¿oÁÂn¿¿tÇÈ^¥¥_¦©Brt6ab¡¡£¦rtqm{~pss»§<GK	
!')(./<EGEQT6@B8@F>GM;CH9AE7?A18;2:=-36,36,464=?8AD8?B5<>8@@8@B4=@5=A.5:4;?4<@19<8BE8AD5=?4;=3:<5=?,3408;*24,35+24%+,!#©¹¼»" ²·§¬©¯>MQ!=LOª®¤¨£§¡¨¥ ¥7GI!1AD{}Qfl#&»" ²·§¬©¯>MQ!=LOª®¤¨£§¡¨¥ ¥7GI"1AD{}Qfl#&»"Ymt¤©Oae{}xy|xJ\`jsj:NS)-»" ²·£§ÆËÍ¥©¢¡¥¨­®´¨¯¡²¹ ¥s{{¿ÆÇqQfl#&»»»»»»»»»»»»»»»»»»»»»»»°l|iy~<DG-34,34-34,12/57,13,23-34+13*/1+12-35-34+13+13,23+02)/0*03&+-(-/(,/(-/).0*/0)./)/0+13).0*02+12*01*/05=>»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»om~n~l{rp~t^km:WU|ÎËuÇÉ|ÔÕ_¥¦l½½n¿¿i¶¶b®°P?ru-PQ¯´µm{jx|qpn}m{~»p@JP	
%,-19:8BEFQWEPV7>CCLRAKO;DH8AD:BE/58/595=?3:<3;<7?@4;>4<>9AC8BF6?B-4819>06:5>@8AC8AC8@A9AB9AB6=?3;>19;+25'.1-47'-/'-/!#ª¼½»!$fz±¶¡¦¦¬\nr¡§«©¬¡ £WimwwpBUZ#'»!$fz±¶¡¦¦¬\nr¡§«©¬¡ £WimwwpBUZ#'»!$]sz­±ª¯ ¤¦ª¢¦¢p0CH%)»#' ²·£§£§¤¨£§¢¡¤¤©_uz#'»»»»»»»»»»»»»»»»»»»»»»»» ¯²}¢¢¢  }~}}|y4;<»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»pl{sn|l{tn}-+ÙÖ{ÓÓwÈË|ÎÑo¿Ák»¼pÁÃi¶·qÉÍh¸¼G>sv:Z]·¿Á|pl|qq~p~»Vgo<HM%*,'-/8BD@KQ8AG<EI;DHBLQ:BF<FI4=@3;>8AD7?A8AD4>?8AC5<@8AD7?B9BE7@C5=A/5818<19<9AC5<>;EG9BC5>@<FG17:2;=4;=08:(/2,35%+- !§¹½»JX["%j§º¾¤·¼¦«­±³·¢¦¯³¨«§«§«¥¨¦¨¬¯¦¬}^t{8LQ "»JX["%j§º¾¤·¼¦«­±³·¢¦¯³¨«§«§«¥¨¦¨¬¯¦¬}^t{8LQ "»JX["% "»#' ²· ²· ²·¤·¼³·­±³·³·³·³·§«§«¥¨¦¨¬¯¬¯¬¯¬¯~ "»»»»»»»»»»»»»»»»»»»»»»»»¶ÁÄ¦´¸²¼À·ÁÄ±¼¿´¾À·ÃÄ·ÀÃ·ÂÅ³½À²¼¿µ¾Ã·ÀÅ±¼À±¼¾²½À­¸»®¹½°»¿²¼¿²»¿°¼¿²»¾²½À³¾Á­¹½§²´©²¶°»¾¯º½°¼¿³¾À±»½~067»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»p~uvn|tm{ ('
}ÈÆÓÐq¿½g¯«vÅÃØÚk²´e¯°e°±[¥¥i¾ÁMK8bfGcd´¼¾vtqrq»j};GL

)/1&,-079CNT5>C:CGBNS:DH7@E5=A<EJ;CG;DH<FI8AC8AC9BE7@B6?A7@D:CG8AD9BF8AD:BF3:=9@C7>B:CE:CE=HJ:EF4<>/682:<,36*23,35)02 %'©º¿»`lnJY["#'!$$("% ##&(+*.+.*.*- #&)-1.2/3*-AMO»`lnJY["#'!$$("% ##&(+*.+.*.*- #&)-1.2/3*-AMO»`lnJY["#'!$$("% ##&(+*.+.*.*- #&)-1.2/3*-AMO»#'#'"#'!$$("% ##&(+*.+.*.*- #&)-1.2/3*-#'»»»»»»»»»»»»»»»»»»»»»»»»³¿Â~hx|dlo9>v49p:?x6;s6;u49p49q9?xDI~BG~59p7;u48o6:r15i37l25i37l05i9>v5:q6;s49p05f37l48n6:q7;r4:qgps²¼¿y3;<»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»tq~qxv4?>d ¢ëêwÊÉyËÊm«¬ÑÏ`£¤p¹¼uÇËi·¸i»ÀrÍÓ]§¯Q@os>mpj{{©­rro|o~»av}9EH*13+355?B;GL8BGGUYCPT?IN2:>=GM9AF<EG7?BAKN:BE8@D3:=6?B8@C;DH:CG6=@4<>8?B3:=5=A8@C079<EH6>@:DF9BD6>A19;+15(.129;.58)/1#(*¦¸½¥»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»%*#("' &!&#("'#($)$)$)"' $!&#(#( %!&!&#)#)(.%*#("' &!&#("'#($)$)$)"' $!&"("( %!&!&#)#)(.»³¿À@JM48nTZ¶¼49pW]r{¤±\d¶¤Á»5;r7=u7=u6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t<Ax6;t6;t48oµ¿Ã|5<=»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»sp}wqMY[CpmáÞÒÑwÃÃàßw¾¿p¾¿e¬¯rÂÅq½Ár¾Âb®²c­³kÁÈZ¢©[¢NL¡¨©£ttt»gz;FI		$*-)14ANRM[`COT8BEALP<EJ>GM=FK=FL<EG;EG9@C9AD7>B=FJ:BF8?B6>B7@D;DF8@B<EH8@B28;5=@6>A5;>;CF9AD<EH8BG/7:18<19</69/69)01"'(«°{»my{xª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬®º¼¡x»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»#'QFs2cX1cX8rd7o`6k]:rd8ob5i^7n`:sd6k_7k_2aX0[R/\R.XP-WO<9#(#'oz³]j§=J=JKZHWESLZJWDQGUL[APzBPzGU}BOy=Jp@Nr>Lr!.K#(»¹ÄÆ¢-4516kIN@D|°³48oY`®^e¸·¹ ½7=u6;t7=u6;t6;t6;t6;t6;t6;t7=u6;t6;t6;t6;t6;t6;t6;t06iµÀÄ{3:<»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»xttbqt%B>Ñ÷öÕÓÑÒs¿¾ÕÕk¶¶|ÑÒl½¾k»¼sËÌe®°i¸¼f³·a­´i½Áb­±_¤¨RDtt²¹ºo~q»JVZ$*-#)-;FLIUYBMQALP;EH<FJ8@EGRW?HL?HJ=FI<DH6=@BLP=FJ;CG=FI8AD5<?7@B>GJ>GI8@C18;3;=.684<>9AD6>A8@C3<@3;@4=B2;>1:=-58,36$)+£±·~»my{8DF!!!!!!!!!!!!!!!!!!!!Uacª¶¸»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»#'Ù¸E^V.G?PR [¯_» P[°Y¯eÂ¦mÐ²Y©a¸c»c½T GaX3NF*QK,1#'¸¿ÚPUd9>No~¶t¹ÄËp¸ÃÂ¥Ï¡³Ø~½ÇÉ Éu·SXfAES>Kr,1»¹ÄÅ06749pOVNU9=v¶¡½26j±bi ¼·ºº|«6;t6;t7=u6;t7=u6;t6;t7=u7=u7=u7=u6;t6;t6;t6;t6;t47m²½Ày29:»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»rtt%"F@ÙÔãßrÀ¿{ÑÎ|ÐÍyÍË~Õ×~×Øi´²i¶¶uËÌvÌÎ^¥¨b«®b²¶j¾ÂtËÏmÀÄYDsu>MK·½¿y»¢HUX		(/208;=GKKY[CNPDOT>GK7?CBLQCMP>GK?GJ<EG>FI=EH<EH:CG;CG5<?7?B8AC<DG>HK9AE<EI2:>7@C7AD3;>4<?8@D8@C08<2:>5>C.6:-58,35(/1#)*©¹¾»>JL+79NZ\_km[giWceZfhWceWceWceXdf\hj[gi[giUacT`bXdfZfhWceVbdMY[8DF#/1MY[ª¶¸»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»#&Ú¹¦¿»DaZYªW§]³NNY­]·d¾¢iÇ©W¨U¤c¸_±v×º­ÌÆIi`0\T$)#&ºÁÚ¯¶ËNWi~¾{¼Äl|´l|¶~ÀÇ ÌªÑz¼xºÈÄ©¼Ü»ÃÓV`mCRv$)»¸ÃÅ¡.3449pMTBG}AF|59p¢¾DJu}¥jr ½¤À§Â¢½ºFL6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t37l³¾Â{4;=»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»qw%/-
+&HzuÚùøÞùø÷ÿÿöÿÿïþþßùø÷ÿÿóþþïþþ÷ÿÿôÿÿôÿÿñþþëüþ½ñð¾òò¿òò±ííÑÐrººm³²hqpµ½¿w»«´S`e

%,.&*,:BDDQQHUVALQ<EI4=@9BEEPR:CE:CE:BE=EH@IM<DH<EH:BF;CG:CE;DF8?B4<>4=@8AE>HL3<@5=B8BE3<?>IL7@C5>B6?C4<@/6:.79.68(/0$*+§¸½z»![giy~{tyvsy}}zuq}ttutnz|Wce9EG ,.ª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"Û»P\¯P]²Yª]µW©vÈ¯¹éÙ¥áÌÙ½oÇ¨X©d½¡kÍ­jÌ¬eÁ¢kÊª/[R %"»ÃÛn|´Âmy²ÄÂ­¹Ù~ÁÄ{Âu»Æn~·x½­¸ØÄÎå¯Ó¤Ë­Ñ<Jp %»·ÀÃ(,.5:sZaDJBG}7;t26i@E{¯dk»¼»¹ºº=Bz6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t6;t7=u5:qµÀÅ{28:»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»xBMN     ~¢»xQ\_	'-.$)+@JMNZ]KVX7?B8AEBMR9BF;DG=GK<FJ3:><EJ:CG6?B8AC=FH;CE:CE9BD8?B4<@8@E7AF-48/6<1:>.7909<5?A:EH=FJ/5708;2:<5>@08:/69&,.±¸»!{y{zxwzzxzvq}my{HTV!ª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"%àÆQW§W§PRU¦>{i920*0*:3@|irÍ¬eÂ¤eÃ¥iË©^µd» /\S#*"%ÃËáp~´{¼{¼bm«)hnz²«µ×y½iy·s¿s¿|Àn}µ".t©Ï®ÑÄÊ=Kq#*»¹ÅÇ-4548o?D{AE|JPMRV\ip}«cj¡¾»¡½¡½¼£À·:?w<Ax6;t6;t6;t6;t6;t6;t6;t6;t8>v6;t6;t9?v37l±½À~6=?»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»lz}                          %#¢¦½¢Wdg	
$*,*14<FIITXCNQAKO>GJ9DG:DH<FI;DGBKO8AD7AE2:=:DG;DH<EHBMP=GJ:DG=GJ9BF<FJ<FJ<FJ4<B6>D8AE+155=A7?C3;<:BD3:>.461:=/8:.58"')$)+¥«n}»!zy{x}~uxxussQ]_!ª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»#'Ù¹SNT T YªAo5.0*.(.(0*4->}kjÁ¢Xª^·fÇ©aº2bX$#'¸ÀÚt·jx±v¹v¹M[%_gr®¦ÎÇÎä®¸Ø§³Ök|´*kBO}¾ÆªÑÉAOz$»ºÅÇ ,13DJ¯z¨{ª{ª¬~«²[b«¤Á ¾£Àº½º¹@E{DJT\Za\b|¦®¬{¤¨{¤¨pu8>v¶ÂÅ|3:<»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»xo}trm|qo}ooj~vfxok}nm}pnj{spm|pnsprtt»oO\`		&,.%+-@KNN[_CMQ<FJ@KO=GK@KN?JM7?B6>A:DG>HL9CF<EJ;EI;DH>HK=FJ3:>;CF8@D;EI;EH;EH:CH7?D6>B4<@2:=3;>6?@8AC06:-3619</7;.69$*+$+,ª¼Át»!||t}yx{q}suQ]_!ª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"&yÒ®RTY¨LBo928tcJLFtY­?l;3Bm]®[°eÄªS¤7m_$"&¯¶Ôq}´t·}¼gr­gt°N] "VM(hJN"VFTo}´q~µÅ§Óv½IW$»·ÀÃ¡¤.468=uksjqcjgnmucjfn`gT[¬»º·¹¼º´EKOTZ`hogn«®«­¬««4:q±½À6=@»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»^ltUdk	
%+.1:=;EI?INCNS<FK>HMBLQ8AC7>A@JM<FH9BE6>A:CG9BE=FI<EH;CF;DGAKO9AD=FI=FJ8AD:DG3;?3;?3<>8AE<EI6?B9AD<FH-372:=.6:08<(.2$%&,-¤¹»y»!¡£|{|yy~wzq}r~yQ]_!ª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"%~Ö³Y©W£]±Hz<48tcR¥T¤PJxWªW«J~?6V¨T¥P[·9n`$"%³º×}½yºËeo¬v¹n~¶Td¤%]%_M%^Wc£ÂÉ¥Î~Äo}¹ÉJW$»µ¿Â¡,248=u§®Æ©±È §Á¥¬Ä¤ªÄ°¶Í°¶Ë´¹Ï¢¾t~¤nu¶ ½¡½»¸º·LQU\kqfkchx}£¯«®©«49o´ÀÃ}4<>»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»o|m{}m{}tttttql|~lz|txtrvvsssjxzrtwq~urw»k~R`g'-0'.17@D<EI=HK9BDDNSFPS@IM?HJ@JL<EG;EG;DG8BD:BE<DH=FI<EHAJN8?C<DH>FJ;BE=GI?HK;DGAKN18;ALP;DG8ADALO8AD17;/59/7;.59,36"'("()©¬v»!§©|yuzyy}r~stsO[]!ª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» #~Ö´TU£U PJzFxLJ}QL]¸a´d»b½gÇ§X«NX¯9ob" #³ºØt·w¹v¹o}´dr­_n«j{´dr°r»iy³ÈÂÇ ÉªÏ~Ãky´ÄR`"»·ÃÇ¢§,136;sºÀÓ®±É´¹Ï²·Ì¶ºÏ¸¾Ò¶ºÏ´¹Ï¶ºÏ¦¬Ä¹nv z¨³º¡½¼ ½´AE}¨{¤}§}§¨¬®­¨5;s¯º½{4<?»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»o}o~n|qvwvrtn|o|trjz{#*' £n}sxsp~q~qn{stwvs»mLY_#),)/27@DANR8CG=GIEPRCMPISUJUWEOR9CE;EG>HJ:CE<EG?HK4;=<EH?HK@JM<EI<EGAJL=EGBKLBLO>GI4;>=FIAKN=FJ>FJ7?B9BE7@C1:=/6919;#()¥y»!¥§~~||yuwuuvuP\^!¥§»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»#%yÐ®^³b½¡^¶PDrQS£KKBuS¨X¦U¡PY®\²eÂ§aÀ¦=zj &#%®³ÔÄ ËÆq¹Yf§Æ³»Ù|Àhx·Xh©wÀ{»¦¯Ð­µÓÀÄ¥Ï£ÏRb &»³¾Áx,246;v¶»Ï¸¾Òº°jrs{£ ½°¶Ì³¸Í¶ºÏ³¸Î¡§Ápx qy¡¡¾º¼·¸AE|[bQXbhY_`hbiek_gQW49oµÀÄ3:<»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»o}o~ttqxytto|qrq!*(FNM¥®°yuo|o|vqtpwo}pr»xLZa!#(-1-58=GLCQV=JMAKN>GJBKMAJLKVZHRVCNR8AC>GJ@JL=EG>HJ<DH;DG<DG<EGCOQ9BC=FGENPCKLAJL?HJ?HK9@C=GJ@IL;CF=FI6>@8AC/69*022:<%*+®´v»!¥§|{wr~zS_a!ª¬»my{8DF!!!!!!!Uacs»my{8DF!!!!!!!Uacs»my{8DF!!!!!!!Uacs»»»»»$'{Õ±LyU¤iÊª]²c¾ ×ÆvÓ²W©QNU©a¹¥ÖÄ}Ì¯Y²X£]®_³=yg%$'²¸Öfr¬x¹­ÑÂN] *mgr®ÄËâÈl|¶zÀM[)iXd£¹ÃÞz¸ÀÄQ`%»«·ºn})/149p¶±·Í¶¨¯Ç«°É{¨ir¶¹°µË¶ºÏ¶»Ï°µË¶nuy¨·¸¶48n;@x5:q7;s;@w48o8>v<Ax48n48o59oµÁÅx3;<»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»uuo~o~vqyswp~yq:DE&32MA=¡ª­up}xrswuwztp»h{Uek&+.&+.+24ALPANT<IMFRT?IKAILCLNDOSFPUBMQAKO;DF<DF>FI>GJ<DH>GK;CE>HJ:CF:BD?FHBJKCJKCLMAJLAKN;CE=EG>HI=EH<DH9BD6?A2:<19;/67(..¯¶y»!¥§~zzxxwQ]_!ª¬»>JL+799EGDPR?KMAMOAMO8DF&24#/1MY[»>JL ;? JO V\ QV SY SY IN 59 26MY[»>JL ;? JO V\ QV SY SY IN 59 26MY[»»»»»+9;×µT NJyR 6o_@8}¯ zÕ³]¸\³L<xfB8À´qÉ§X£b·\ª@}k""%ÂÈßu¹ky²dq¬t¹$\K%]¼¾ÆÞÆix²%^K%]³»×z¸Ä¾Ve"»­·»(./27l:@wem³¬²É¶»ÏµºÏ±·Ír|£nuv~¤ §Á­³É¶»Ð·½Ò ½z¨v¦»º6;rº;Aw59pº8=u=By §Á7;s8=v37l²½À3:<»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»qsqtutvtn|~o~vWegUrÆÈE{y0*ª±²rtszsxpro|s»vP]c%+-(.008:BLOKW\CMSBKPALP>GIEPRCMOHTV@IK<EGAJN=FH;DF@JL>GJ@IKBJNDNR=FH=EGBKLCKKELMP\]>FEBKM=GI9AC:DE:CE5;>6>@:BC8@B4<>19:(./¢dt{»!¥§yzwxT`b!ª¬»![giyjvxeqshtvhtv\hj>JL+79 ,.»! ow z ~ ~ px OU ;? ,.»! ow z ~ ~ px OU ;? ,.»»»»»+8;zÕ°PPRJ}70/)81§åÐ[¯]´_¸;4/):2§ÔÂ\©]®c¶@~l#!%ÆËámx²p}¶r·es°MK P5A³¼Ù«ÑQ`¢KK&`§­Î¼ÀÆWf#»±¼À¢+035:r49p5:q:@xu|¤¬±È¸¾Ò±¶ËºÀÓ¦­Æho`g³ª°É³¸Î²·Í¤ªÄ±x¦¯=By¯´Ê;@x58n®±É7;tDI~°¶Ì6:q6;r6:qµÂÅ 8@B»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»q~suutqtwo|p~bpr
Ifei´³n¾¿`¨©*YX30²¹¼|lz}xxszm{~srs»l}\kr#)* (.0ALODNSDPUEPSDORFQTDORBKNCMPFPSAJN?HL=EIJVZCLPAJL@JM>GIAJM<EG=EG@HJFPPHQRP\`DNPFOQ?HI>GH;CE;DF:AD<DG;BE7@B7@B7>@*02£ªx»!¥§wxS_a!ª¬»!{¨ªy{zgsu[gi5AC!»!4²» § | ow FK!»!4²» § | ow FK!»»»»»*79ÚºTLPCs0*/)<4ÙºU£]±\¯1+/)>5Ùºa³_¯a¶;rb$ #ÇÍát¸hv±|½Q^¢OK P(e1>cq­#/yOM&`³½ÙÆÂÆLZ$»³¿Â-255:s48n7=u7=v48o³·½Ð¶»Ïµ¹Ï¸¾Ñ·»Ï¤À^ehqow gndklty¨[b47l«:>v7;upw7;t:?vr{¡59o9?v59p·ÃÆ{5<>»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»p|qttt|trrp~)C@ÕÖsÂÃk¹ºj¸¹c«¬FCGNL©±³vqpupvrsq»p_ov!#AKNEPUEPULX]KW\FPTJUYJUXHTVGSVDNR>GJBMPDNRLW\FQUALOALP<EI;DGBLNEORGRRGPRHSUAJKP[]KUV>FHBLO=EH9BE8AE:BF0687@B3:<+12
¦m~»!¥§|~R^`!ª¬»!¥§¹ÃÅiuw;GI!»!1¯¸PÎ×$¢«#¡ª¦¦ LR!»!1¯¸PÎ×$¢«#¡ª¦¦ LR!»»»»»+9<Û¼NOHwK4-/):3mÃ¤ZªZ¨U 70/)>5sÐ®aºa¼ [¯=te$#&ÈÎãkx±m{´nz³8C)kERÃx»¿~¼v·_o«#0{)gXe¥¦´Ö©ÑÂP\$»°»½|-356;s:@x5:q8=v37l7;t¶¶»ÏºÀÓ¶»Ð¶ºÏ·½Ñ±·Ì»cjW^»¦«Ä£©Ä¢¾8=u6;q<Bx:?v6;q:@v=By7<t48n8=v6;s¸ÄÈ39;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»sussp~xuqq*436LJÒÑ~ÔÕßák¹ºj²³wÌÏi°²1ONw}| ª­mz}tp~tm|tvq» ctz'-/@JNBLPIVYIUZ=FI?HKAKMCLOFPT?IL;DG>HK@JMDOS@JM=GJ7>C8@D9BDBMP:CF>HJ8AB>GH?GH?FHEMN;EF8AD;DG;DH8@E8@D2:=.58,24%+-¥k{»!¢®°¡  Yeg!ª¬»!¥§¹ÃÅiuw;GI!»!1¯¸PÎ×$¢«#¡ª¦¦ LR!»!1¯¸PÎ×$¢«#¡ª¦¦ LR!»»»»»,9=¦ãÌPRRHy3iZ6.6n]PZªf¿£a·:vd5.?|iYªX©PZ¯?yi %#'ÊÑäo|´r·gu°$0{M[ bp«l{´is°¿¢ÌÆÅn}´DR'3Ão|¶ÆTa %»³ÀÁ)/1;@y<Ay9?w8>v6;s9?v5:q»³¸Í¶ºÏ¸½Ò¶»Ð¸¾Ó°µË §ÁX^¨®Æ §Á¢½¢¾5:q7;t:?w6;rAG}=By9>v7=u48o7=v6;s¸ÅÉ¤7?B»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»n|m{}stvtwtFRS'#v·µzÑÑ~ÖØ{ÑÑççh³´\|ØÙK,(¡¡£¦rtqm{~pss»~fw}"'($*,-35+24).0*03*13)/1*02-35*03)/1,24,35(.0&+.!&)$),%+,&+-(.0&+-)/0&,-',-&*,*./'-/&-.)/0(/1#),#(+$& ! 	
¡¬ds|»!£¯±¡¡|Xdf!ª¬»!¥§¹ÃÅiuw;GI!»!1¯¸PÎ×$¢«#¡ª¦¦ LR!»!1¯¸PÎ×$¢«#¡ª¦¦ LR!»»»»»# áÇLLFuSPI}R¡N~W£`³]­MP^±[­QGx_¶A}l#)#ÇËâhx±ix²]i©\g©o|·l}´jz²gr®yºÂ¾kz²z½z¹Àq·_k« ÍXe#)»ºÆÉ|+1359p;Ay:@x7=v8>v:?w9?w48n5;s5:q6;s59p8=v6;rSYº¥¬Å¡¨Ä¼¡ªÃ49o7;u7=u:>v9=u7;u:@v:?w26i7=v7;uºÆÊ£8@C»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»om~n~l{rp~t^kmY|ÑÑo¾¿oÁÂn¿¿tÈÉb¬¬rÈË`§ª[¥¨4`_¯´µm{jx|qpn}m{~»|crw)/1#$"().46.57*12.46,35*/1+23,34/68,35.57+25-47)/1'-/(.0,34,35-46*13*03,35*02*02-3419:,35,35+24%*-*03#),"(*)04wds{»!¢®°¦¨¡~]ik!¡£»!¢®°ÂÌÍ¤°²my{BNP!»!:¸ÁXÖß<ºÃ" ©" ©!¨¥ TZ!»!:¸ÁXÖß<ºÃ" ©" ©!¨¥ TZ!»»»»»#¤âÉF_X,C=ONLR¤J{T Q`³X¤LU¨_²[«_¸E\V0IA?zi#(#ÊÎãQVf5:Ln}¸do¯ht²t¹fw®u·p}´Âz¹ix±y¼ÂÀÉOSd<@PTb#(»¹ÃÅ ¨.476;u48l5:q6;t9>v05h7=v8=v9?x6;s4:q·½Ð¯¶Ë­´Ë£ªÄ¤«Ä¤«Ä£¿¼¢¨Â:@w8=v:@x8=u>Cz:@w6;r9=v48n7;u7=v¿ÍÑ :AD»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»pl{sn|l{tn}6SQ|ÎËuÇÉ|ÔÕ_¥¦l½½n¿¿i··g·¹c°²_«°T !?>-52·¿Á|pl|qq~p~»xwr*02	

!"'-.(-/%*,&+.
	)/2LX^[kqk{»!jvx¤°²§©¡{HTV!»!jvx¤°²ÍÕ×µ¾Àµ¾Àµ¾À¦¨5AC!»!<ºÃbàéKÉÒKÉÒKÉÒ2°¹%£¬ FK!»!<ºÃbàéKÉÒKÉÒKÉÒ2°¹%£¬ FK!»»»»»#'©ãÌ§Â¾C_XNS£FsU¥EvNNW¨QSg®h«W¡Z¦¬ÇÂC_ZP#(#'ÍÑä±¹ÍLUgjx²u¹]i¨Æmx³ky´kx²{¼p}´s·y¼y¹y¸~¼¸¾ÐLVin|³#(»µÃÄ*/17=v5:q6;r7=u7=u48o7=v5:r5;s48o49o³¸Í¼¢¿º ½ ¾º¥¬Ç£ªÄ>Cz;Aw8=u58o9=u<Ax;@x;?v7;t7=u7;sºÅÈ ¥9AD»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»p~uvn|tm{&%)'ÙÖ{ÓÓwÈË|ÎÑo¿Ák»¼pÁÃi¶·rËÏpÇË[¦«]«°`§¯+(X^]´¼¾vtqrq» {ix}^lqWcgN[]M[\P\_HSVMW\ITXGQUKV[CNPBMPEPS>HK=FJ@JN?HL;CI7AC@KM<FIAKOBLQDMQNZ^NY_@JM6>A7AC;DE:BE5=?7?B7>B2:<8@C8AD,3518;GSVaqxsz»Xdf!my{¤°²¢®°¥§¥§¥§¥§¥§¥§¥§¥§¥§¥§¥§¥§¥§¤¦bnp6BD!»Xdf!my{¤°²¥§¥§¥§bnp)57AMO»Xdf  #<ºÃ1¯¸1¯¸1¯¸!¨ w 8=AMO»Xdf  #<ºÃ1¯¸1¯¸1¯¸!¨ w 8=AMO»»»»»#'Ññä­åÐßÆßÅ£âÉ­åÑÝ¿Ý¿àÆ¤âÊ§äË¥ãÊ¥ãÊßÁßÂÞÂÛ»ÝÂÛ¿]°"#'áäïÎÓæÅÊáÅÊàÉÎãÓÙêÂÆÝÂÆÝÆËàÉÏã¿ÆÝ½ÄÜ½ÄÜ»ÂÚÁÈßÂÈß»ÂÛÀÆß¼ÃÞÂ"»·ÃÅ+235:q9>v59n9?w5;r37l7=v7;u7;u5:q48o°´Ë³´¶·¶··£½CI~=By;@v?Cz7;r>Cz:>v;?w:>v8=u7;tÀÌÑ9AC»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»tq~qxv5@?}ÈÆÓÐq¿½g¯«vÅÃØÚk²´e¯°e°±[¥¥jÀÃTc±¹VQ©­rro|o~»|wutiw|reqwrro}wpuoujyqxaqwft|rlzyvywuroqsrvzvrn}yosdrwcqvur»sXdf!!!!!! ""$$&(*+-(* "!! "$&)++-)+&(AMOmy{»sXdf!!$&(*+-+-)+AMOs»sXdf!!$&(*+-+-)+AMOs»sXdf!!$&(*+-+-)+AMOs»»»»»#'#'",9=+8:,9=#& #!$&))-+.+.+.&) #(+.2.2/3),%*#'#'"#'!$#'#& #!$&))-+.+.+.&) #(+.2.2/3),%*»®º¼§®.46?Dz5:o5;q6;s6;s49p5:r59p9?w59p48o¦«Ä¯º³´µ´µ´¡½¼¶¡½<@x6:q7;r<Bx7;r6;q6:qÀÏÒ6>?»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»sp}wqMY[d ¢ëêwÊÉyËÊm«¬ÑÏ`£¤p¹¼uÇËi·¸i»ÀrÍÓ_ª³[£ªXa«±Cyx)$¡¨©£ttt»¨±y~¥¥£ª³}®´~¡¨¡§y~u}xqxzyo|y{x~yzr}»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»´ÀÅ+139=v7;r7;r8=v9?w38n5:r:?x7=v:@y9>v¦«Ä¯¯°°°­¯°³´±¡½HM=Bz>Ay9=u7;r59p5:qÀÏÔ4<>»»»»»                                                            »»»»»xttbqtCpmáÞÒÑwÃÃàßw¾¿p¾¿e¬¯rÂÅq½Ár¾Âb®²c­³kÂÉ]§®j¶¼mÁÄwÑÑ/_])$²¹ºo~q»po¤­¤¼Äª°²¸§°´½­³ ´º©¿Ä¡·½¬±±µª±±· ²º¨®¢³º¦ª¯±®®¢±³ °³¥ª «¯¥¹¾©­ °´©¯¤¤¶¹§·¼¡°³¯½¿­½Àª¸»ª¸º¬¹»¯º»²¾À¬¸»¨´¸®²£§|»my{w¦¨ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬®º¼x»my{w£¥ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬¸ÄÆ¡x»my{wª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬ª¬¸ÄÆx»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»µÁÅ.466;s58o59p9>v7;t?E{:@w38l7<t7=u7=u¡ªÅv¨{«x©w§v¦{©{ª~¬~«¯{ª°º¸¹³¯·5:q¯½Á¢¨=GK»»»»»$*-#)*4<?HSWMY^R\aVaf^iodpuRaiUdmdw}]os]mteu}]mv]mv[kqMZ`:BG»»»»»rtt$!"?;Ñ÷öÕÓÑÒs¿¾ÕÕk¶¶|ÑÒl½¾k»¼sËÌe®°i¸¼f³·a­´i¾Âf³·oÀÄwÊÌn¾¿=9<CA·½¿y»i{Rbi%&		   		
		 !            9nm§´¸ »FRT@LNfrtyyyyyyyyyyyyyyyyyyyª¶¸»FRT@LNfrtyyyyyyyyyyyyyyyyyy¥§µÁÃ¡»FRT@LNfrtyyyyyyyyyyyyyyyyyyy¡£²¾À»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»·ÃÈ¢-356;s5:q5:q9>v<Ay9@w6;t9?w9>v9?v8>v§Ãlupx¡rz¢t}¤t}¦qx¡t}¥qy¡t}¦r{¢zªqx z¨z§out{¢t{¢s{¢7=uµÅÊz3:=»»»»»-58.57/34&*,Zgm`lp}~xDKO+15pfwvtHNR/58ZjpJV[»»»»»qw#85	:3ÙÔãßrÀ¿{ÑÎ|ÐÍyÍË~Õ×~×Øi´²i¶¶uËÌvÌÎ^¥¨b«®b²¶j¾ÂtÌÐrÊÎn»¿e«®a©©krq¸ÀÂw»z!$!AC7jnDDI@BA@};su=wx=uv=uwDB}~B|}EAyzGFGFD@{|8jkCIEFECKIGAz{7hi6ff8ii?wwG'IJeruª¸»»0<>@LN,8:%' "Zfhª¶¸»0<>@LN,8:%')+Uac¥§´ÀÂ»0<>@LN".0    FL EK EK EK EK EK EK EK EK EK EK EK EK EK EK BH "DOQ£¥´ÀÂ»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»µÁÅ,23<Bz7>v5;s6;t:Ax:Ax5;r<Ay<Ay:?w9?v ªÄems|¤iqmvkrmtpy¡mvox¡krksnvr{¢t}¤mtnuekpx¡;@wºÉÏw5=A»»»»».585;?ouw:CF^lsv£°¼ÃSbfn¹Âx{}­¸½IVYkTbi»»»»»xBMN50H{vÚùøÞùø÷ÿÿöÿÿïþþßùø÷ÿÿóþþïþþ÷ÿÿôÿÿôÿÿñþþëüþ½ñð¾òò¿òò²ïïßÞßßàÞ[po~¢»¨HQG_µ·d¼¾a¸»MQ KIB@|~NNdÂÂU£¤SX¤¥UY¥§QPU THPPU RU ¡S\¬¬SQV £JLX¥¦\¬¬E8gh9mnª¯}»0<>@LN!#')'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35+- 
(*ª¬»0<>@LN!# ! 28 MT MT MT MT MT MT MT MT MT MT MT MT \d MT MT ?D 	!ª¬»0<>@LN 	 KQ dl em em em em em em em dl dl dl dl dl dl dl MT 6: (,ª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»´¿Â£+147=v7=v7=v9?w7=v9>v:Ax7;t9>v59o<Ay¡½`hjqhoirdkfnhpgodl`hgogogndlgngnhoah:?w»ÊÏ§®5>@»»»»»4;=>DGW_bgtys¥ª¯¡¤¯¸³º°µ¬± ©² ©£¬¢n]mt»»»»»lz} 							
	 %#¢¦½¤f¼¾^­±P B?zyiÀ½lÆÉX©«X§­Xª®a¼ÀLY«®iÌÎQ]µ¶U  Y©ª`µ¸X¦©U¢]¯®X¤¡]¯®V££_³´[§ªb´¶Z©¨X£¡aµ´a²±]®°^²±_°±SG*PP+QQQC~=pr¦´·z»/;=@LN@LNtr~lxzo{}kwylxzkwyq}q}o{}gsujvxo{}lxzjvxXdf7CE'35yª¬»/;=@LN W_ £¤¤¢£¢ ¤¡¤¦¡ { S[ OVyª¬»/;=@LN§!¨¥¦£¢¤	£¢¤ ¥¤ `i AGyª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¹ÆÊ¢§-467<t7=v9@w9?w9>v9?v9?v;?w7;r6:q9>vºdjahemajemgoajgo]djraigngojrel_fcjgo8=u·ÅÊ¢©5=@»»»»»7;>FLMUZ]muz£§¯¹½½ËÏ±»½¾ËÑ²¾ÄÁÍÐ²»¾·ÂÇ­·»¾ÊÏ¯¸¼¥¨`gk»»»»»xo}trm|qo}ooj~vfxok}nm}pnj{spm|pnsprtt»h{h¿Á]®°@~PcÀÃ1aduÖ×[­¯a¹»b¼¾^²³T `µ·_´¶V£§Z«¯U£¦NU¤§PX¨¦S_°²X¡¢]­¬iÃÃZ¬®S bµ²d¹·e¹¸e·µmÄÂh»¹a¶¶U£¢,PPSD/XYS¢;qs¨ºÂ~»/;=@LNszkwyskwyo{}r~lxznz|o{}lxziuwo{}kwyo{}p|~nz|Yeg'35yª¬»/;=@LN  ¥¥¡¦¦¥¤¥¦¢ y OVyª¬»/;=@LNA¯·¦%¡ª¢¦¢£¤¤££  § px AGyª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»·ÅÊ¢¦4;>47n9>v9?w<Ax<Ax7;s58n58n<Ax7<t<Aw¯NTINNUNUIOMULRGNFLMRMTNULRRYMRRYT[MR59oÃÒØ¥6?A»»»»»      	
			            &,.+25"(*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»r   sÒÑ\«¬?{~lËÍV¨«8npmÆÈ\­±U¢X¥§d½À\®±jËÌ\­¯a¸»b»½U£¥Rb¿ÃU¢¦S\®¯[­¯X¨ªZ««S\««aµµ_®¬a±¯b·´b²±cµ´cµ²c¹¹Y©ª.WWSL1\]P<rt!#¢«{».:<@LNur~utq}my{my{p|~kwykwynz|p|~my{lxznz|kwykwy'35yª¬».:<@LN# ©¥¥¥¦£¤¢¤ £¡  ¡ OVyª¬».:<@LN[»Â-¥®)£¬'¢«¥)£¬¦£¦¡££ ¡¢ mv @Fyª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»·ÃÇ£©BJM-23:@w<Ax7=v7=v<Ay9>v5:o7;t:?v=Cz9>v6;q9?v9?w7=u8=v9?v7<t9>v5:q9>v9>v9>v9>v9=u<Aw9>v7;r>Czeor¬¸¼8AD»»»»»#(*!%'%,008>*254>B08;MZ^KX]Q_eVbfPZ]MY^;DG>GJ179079069/56»»»»»o|m{}m{}tttttql|~lz|txtrvvsssjxzrtwq~urw»£   vÑÑkÃÅc½ÁGDX«®Y¬¯V¥¨^±³Z«®^±³e¿ÃgÀÂb··lËË^¯¯b¹ºb¹º]³¶X¨ªP\¯³NV§©K\°²b´µa²±b³²_°¯b¹¶`´±`´´]­¬_±±aµ¶T£¦*QS*QSGH6gj®¸|»-9;@LN|{{wur~slxztp|~lxzp|~jvxp|~iuwmy{my{'35yª¬»-9;@LNI³º# ©%¡ª# ©¦§§¢¦  ¢¢ OVyª¬»-9;@LNyÊÐ-¥®1§¯1§¯'¢«!¨'¢«§¡¢£¢§¤¢¡ mu AGyª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»½ÊÏ¤anrFNQ169/57,35.58/68-4619:.5718:/68078068-46/68079,24).03:;189178/5708;2:</7:08<29=-363:=Q]a`os ¦£Uaf»»»»»"(*$*,%+-+38;ELDPVKX^P]aUcgXdjZhl`ilcptQ^aTbf[ilO[]EMO1794:<»»»»»o}o~n|qvwvrtn|o|trjz{#*' £n}sxsp~q~qn{stwvs»   ÜÜfººZ©­^±´Z§¨X¦§`¶ºa·»QX¨­bº¼Z¬®hÂÁc¹·bµ²`°¯hÂÂ]¬¬_µ¸X¦§]°µZ¬®]²³Oa·»U ¡dµ³_¬ªa´³]©©Z§¥_±¯b¸»b¹º_²´SX¨¬KW§ªV§ªI7jm¥­|»-9;@LN¥§}}|vr~q}my{kwynz|o{}iuwkwykwykwykwy'35yª¬»-9;@LNyÊÐ+¤­1§¯)£¬)£¬%¡ª# ©¦¦¦££¤¥ ¥ OVyª¬»-9;@LNyÊÐ/¦¯3¨°-¥®)£¬/¦¯'¢«¦¥§¤!¨¥¦¤ mu AGyª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¸ÅÊ©² ¦ª¯¦­¦¨ §«±¢¦°¶£¡¢¢ª­£©¨¬¯µ¦«¡ª´}¤¯}¢¤©° ¥§­cqv»»»»»#(+!'*'.2/9<ERYQ^dZfkdpudptxz{p~bns_loZdi>FI7?@»»»»»o}o~ttqxytto|qrq!*( FNM¥®°yuo|o|vqtpwo}pr»£   ßànÍÏ[®´Yª¯V Z©«a¶ºe¾ÂRd½Ãd¾ÀZª®c¸¸jÅÇf¼»jÄÃ^°°^¯®^³¶Z«®[®°a¸»^²²d¼½_²²Y¦§d¹¶a±¯Z§¨Z§§Y§¥^­«^²³aµ¶_°²dº¼\¬¯U¢¦fÃÆU£¨K<su¤r»*68@LN¥§}~}|{wto{}tmy{kwyo{}lxznz|p|~kwy'35y¥§»*68@LNyÊÐ+¤­+¤­-¥®5©±5©±# ©§§¢¤¡£ £ OVy¥§»*68@LNyÊÐ)£¬/¦¯1§¯3¨°1§¯%¡ª# ©¦+¤­%¡ª# © !¨¤  mu AGy¥§»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»³ÁÅ¿ÏÒµÃÇ¹ÈÌ¸ÇÌºÈÍ·ÄÊ²½Ã±¼Á¶ÂÈµÂÅµÀÄ³¿Ã¹ÅÉ·ÃÆ·ÄÇ²¾Â¯¼¿¬¸»ÂÑÕºÇÊ»ÈÊ¼ÉÊ¸ÅÈ¹ÆÊ²ÀÅ°¾Ã·ÇÍ·ÅÌ¹ÄË¿ÌÒ¶ÃÈºÈË»ÉÍ³¿Â¼ÊÍ¡¨»»»»»'-0%,.*157@DS`gbpvfsyFLO<CF@IL6=@FMOenojvybpsbnqGNP?GH»»»»»uuo~o~vqyswp~yq:DE"+*Tej *(¡ª­up}xrswuwztp»z   {ØÙd¹¼\°¶V¢¨hÁÃlËÌ^®²Z¨¬`µ»\¬±`³¶Z©¬b·¹cº»_°°a³²dººa¶·Y§ª[«¬c»½a·¸f¼¼jÄÄd¹¹dµ¶kÆÅ`²±kÉÉa¶¶a¶¸_°²b¶¸c¶¸a²´c·¹b¸»]®°Y©«X¥©U¥¨9mo¡¨s»*68@LN¥§{z|{suzr~uuo{}jvxp|~'35yª¬»*68@LNyÊÐ5©±3¨°1§¯9«³+¤­)£¬)£¬!¨!¨!¨+¤­¥¦!¨¦ OVyª¬»*68@LNyÊÐ3¨°7ª²1§¯3¨°5©±-¥®+¤­%¡ª# ©¦¦%¡ª¤§£"£ mv AGyª¬»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»&,/#(**03FRV]inU`d169%+-3<?@JMHRWJTWFQT^finzjvycprIQS»»»»»qsqtutvtn|~o~vWegXjn¦R`dª±²rtszsxpro|s»v   ~ÚÛdº»Z§­iÃÇhÁÃa²´oÑÔkÇÊjÆÊe»¿_¯±\©¬b··iÄÆa¹·iÆÆf¾¿\«¬aµ·Y§©d¸·gÀÀfººcµ´b³±h¿¿]¬«_²±Y¨¨a¶·]±³[ª­_°²cµ·d·¹b³µa´¶bµ·_²µX¦¨Q=ux¨³¥°»*68@LN¥§}z{zyyutstnz|'35yª¬»*68@LNyÊÐ3¨°5©±1§¯9«³5©±-¥®!¨)£¬'¢«)£¬# ©)£¬!¨§!¨¤ OVyª¬»*68@LNyÊÐ3¨°A¯·9«³;¬´7ª²1§¯9«³/¦¯%¡ª-¥®# ©-¥®¦§¤ mv AGyª¬»»»»»»»»»»»»»»»»»»»zFPRJUXKWYMWYGRTGQTHRTIRT;DG».58FQU@IL.47»/OQCps=gi/MO»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"(* %(*13COSVbg8>A',./69:CFITXS`eP[`WciFQTYaevhtxPY\IQT»»»»»q~suutqtwo|p~bpr
GRS|r3@A!(&²¹¼|lz}xxszm{~srs»©¯   æçlÆÇ]¨¬a­°hÀÀiÂÃZ¦§hÁÃd¸»kÅÇa±³f¾Àd¸ºhÂÄe½¾b¸º`´µaµ·dº½cº¼_®­c¶´e¹·hÀ¾c¶³g½½e¼¾lÌÎd½¿[®®S¡¤\¯²\©«d·¹a±³d¸»b·¹]¬®W¥§Z¬®Q@y}³¼r»*68@LN¥§|}}x{ytunz|r~'35yª¬»*68@LNyÊÐ=­µ=­µC°·E±¸9«³1§¯/¦¯)£¬/¦¯+¤­)£¬# ©# ©%¡ª!¨§£ OVyª¬»*68@LNyÊÐK´»=­µG²¹E±¸A¯·5©±3¨°5©±1§¯/¦¯# ©'¢«# ©¦'¢«  ox AGyª¬»»»»»»»»»»»»»»»»»»»«µ¹¦©«¯¬¯£¦¯³¥µ¹ HQT»¡VbhOZ_BIN»ÎÏPJ|@gk»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»$&#%.68CNR;CG#)*/79;EIHTXJV[UbhQ]bYflO\aAMPdlplw}Q[^ENQ»»»»»p|qttt|trrp~(20ª±¡~u"-,GMK©±³vqpupvrsq»¥   ÝÝgº»kÆÅkÅÄi¿Âc²´mÊÊd»¼_¯°nÍÎe¸¸kÂÃiÀ¾_­«f½¾h¿¿Z¨ª_°³a¸¶b¹¹\¯¯Y©ªiÀÀg»»kÄÃh¼¼f»¹eÀ¿]®¯bººW¥¦Z©ªb¼¾cº¼kÇÊiÃÅ`³¶\¬®Z©®S£E7jm§®|»*68@LN¥§|}{vvunz|'35yª¬»*68@LNyÊÐA¯·E±¸E±¸E±¸=­µ5©±1§¯/¦¯-¥®5©±-¥®+¤­!¨!¨¦¦¢ OVyª¬»*68@LNyÊÐC°·I³ºE±¸K´»?®¶7ª²7ª²7ª²3¨°5©±/¦¯/¦¯)£¬# ©'¢«  ox AGyª¬»»»»»»»»»»»»»»»»»»»ªµ¹ISXT^b+02 "'(*/1¢¦ITW»XekXbiGOT»ÉËRRDnr»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"$ "(.1?IM'-0(/119<ALOQ^cS^cO[`UafVcgTchKW\MUYp~LWZGPT»»»»»sussp~xuqq*433==§­¨±±»{¢¬y2==w}| ª­mz}tp~tm|tvq»t   äåpÍÎiÂÂyßàiÃÂ`°®kÆÇ[¨©h¿Àf½¾kÃÂsÕÔh»»nÊÊf¼¼iÅÅ[©ª[¨©aµ¹]°´`¸ºX¦§cµ¶jÀÀe¸·kÄÃkÇÆiÄÃ_±²a¶·_°²]®°b·¹_³µf½¿b´¶`³¶[«¬Y©­NI<sw¤­¡»*68@LN¥§  ¢|{xwy'35yª¬»*68@LNyÊÐG²¹Mµ¼K´»I³ºC°·;¬´9«³5©±1§¯;¬´;¬´7ª²-¥®%¡ª¦!¨£ OVyª¬»*68@LNyÊÐE±¸I³ºI³ºMµ¼?®¶?®¶?®¶7ª²5©±7ª²1§¯/¦¯+¤­)£¬!¨ qy AGyª¬»»»»»»»»»»»»»»»»»»»­¹¼ISV                  ¨¬GPS»¡S^dYbgIQV»ÎÏMREqt»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"!"2:=@JN"(*18<COSHUX]kqYfkYciU_dZjoR`fFNR¨®[glLUX»»»»»n|m{}stvtwtFRS¦­ª³¦­¸Àym}¬´Vfk¡¡£¦rtqm{~pss»w   yÔÔa¯²^­®oÑÒiÆÅkÈÅbµ·]­®d¶¸kÆÉc´²kÅÄsÒÓdµ´mËÌh¿Àa¶¸^®°a³¹a¸½_¶ºX¨«b´µkÅÇe¹¸fº¹dº¹eº¹_°²b·¹Zª­a¶¸^±³a³¶^¯¯`²´_±³Z©ªV¥§U¥¨N;rtª¯»/;=@LN¥§¢¤~vxw'35yª¬»/;=@LNyÊÐK´»S¸¿K´»K´»C°·;¬´9«³C°·A¯·3¨°-¥®1§¯/¦¯%¡ª'¢«%¡ª£ OVyª¬»/;=@LN/¦¯_½ÄO¶½I³ºE±¸A¯·;¬´7ª²9«³9«³;¬´3¨°)£¬)£¬'¢«)£¬ `h AGyª¬»»»»»»»»»»»»»»»»»»»®¹½MWY                  §ªDOR»¡aqzS`gENV»ËÏYMBms»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»!# #&,24ENT!" %(.69:CHALQNX]XdiQY^\fkR`dJW[@HL tP\_ISU»»»»»om~n~l{rp~t^km^km¦­¡§t©rl:JM¯´µm{jx|qpn}m{~»q   âãpÌÏg»»kÄÅe½¾aµ¶`°´dº¾a²´kÇÊa°°lÅÆkÂÂdµ´_¯°c¶·^±±_°²f¼À]®²Y©«X¦©f½¾^­®iÂÀc¶µhÀ¿f½¼_°²^°±\¬°^®²]®°^­¯\ª«[§¨b¶¸_²´Z¬¯S¡P=vw£´º»+79@LNz¦²´ ¢}y}y}*,yª¬»+79@LN/¦¯]¼ÃO¶½Mµ¼E±¸=­µ9«³=­µ5©±1§¯9«³;¬´3¨°)£¬/¦¯§¦*¡ª BGyª¬»+79@LN	 aj¦c¿Æc¿ÆyÊÐyÊÐyÊÐyÊÐyÊÐyÊÐc¿Æc¿ÆyÊÐc¿Æc¿ÆG²¹  =Cyª¬»»»»»»»»»»»»»»»»»»»ªµ¹LVY                  ¢±·GRU»£Ygo]ksHSY»ÎÒRVDtx»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"$#(+5>BESW)14"&'/58:AC@HJP[]Q]_\gkU`cS\aHRVT]alz}VbfLVW»»»»»pl{sn|l{tn}5A@¤§¦¨±p|zupd{"-.-41·¿Á|pl|qq~p~»z   ïïmÅÆnÇÇrÏÏ_¬±iÄÉc¸»aµ·pÑÓd»¼]ªªb²²pÌÌd¸·hÀÂ^­¯aµ¸`³¶_²±e¾À`²µfÁÄ]­®g¾¿e¹¹fº¹_²±bµ¶b·¹Y¦¨Y§ª_³¶Zª¬]­®`´µ]®°a²³X¤¥]¯²V¤¦P=vw¬± ¦»'35@LN 
HTVz¥§¥§¥§¥§¥§¥§¥§¥§¥§¥§¥§¥§¥§COQ  yª¬»'35@LN lu/¦¯yÊÐyÊÐyÊÐyÊÐyÊÐyÊÐyÊÐyÊÐyÊÐyÊÐyÊÐyÊÐyÊÐI³º%¡ª pz  
yª¬»'35@LNyª¬»»»»»»»»»»»»»»»»»»»©µ¹FPR                  ¨­GPR»¡XgoS^dCMQ»ÊÏRM@ln»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"%$+.>HMGTY7@E"&(,2539;<DFCLPLUYR\aJSVBKM29;`ik|ixyWdfQ\]»»»»»p~uvn|tm{%$­°¨¯©¤® ~¢}¡­ªlnqX^]´¼¾vtqrq»p   éçpÌÌzÚÙuÒÑkÅÈh¿Ã]®­]­­d¹¹_²³Z¤¥iÁÂiÁÂh¾¾d»ÀX£§T¡_²·^¯¯c¹ºg¾¿`²´_¯±\««a³µg¼¼a´´f¼½[«¬`´·\«®Y§ª^²µ\­¯b·¹`µ¶_¯±_±´W¤¥S S¡¡?wx§¸¼»'35@LN,8:  '35frtª¬»'35@LN,8: 	#/1frtª¬»'35@LN(46  	0<>frtª¬»»»»»»»»»»»»»»»»»»»«¶¹DMP                  ¨¬DMP»¤TbjYdhJSW»ÎÓNRFsv»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"$'-0DOTSciUei6=@$(*+2429=7?B=FIDNR<EH'+,HMOr~zn|}YghKST»»»»»tq~qxv4?>	£¨«y ¬µ~uwk~£ctuew_r}	©­rro|o~»}   áàrÎÎuÒÒwØ×eº¼hÀÁkÆÈf¼¿hÀÂ[ª«hÀÂZ¥¦d·¹a³µ_°µY¦ªZ©­^°´d¸ºa²´hÁÀdº»_±³]­°_°´cµ·a³µd»½[ª¬_³µZ§¨]­¯d½¿Z««bº¼a¸¹e½¿b·¹^¯±\¬­S¡?wx¦¶»»'353?A@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN_km_km»'353?A@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN_km_km»'353?A@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN@LN_km_km»»»»»»»»»»»»»»»»»»»©µ·GQS                  ­¯EPR»VdkXbeJSV»~ÆÈPRFsu»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"')-47N[`P^c\nrYdj9AD(.0#(++25-47,25#(*9@B_ij¥«swVbeDMN»»»»»sp}wqMY[u±½Â¡¦¢§x§«q©{| £°plgysO_b¡¨©£ttt»§   áànËËoÈÈtÒÑmËË^®­_­±fº¾b´¸b´¶a´¶Z¨ª_²µV £X¤§X¦§bº¼hÃÄh¾Àb³µf¼»f¼¾aµ·aµ¸X¤¨a³µa´·[«¬c¼¾aµ·`±²a²³bµ¶gÂÃ[©ªd»½_²´f¾¿b¶¸Z©©Q=rt©¹¼»Xdf'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35@LNmy{»Xdf'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35@LNmy{»Xdf'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35'35@LNmy{»»»»»»»»»»»»»»»»»»»¯¼¿JUX                  ¢±µGRU»¡¦Vdl^hmMVZ»ÒÕPWIvy»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»&-/4<?DNRIVZSchdrz]jq?JN/7:&,/$*,*138@BWagsftziyZhmNY^DNR»»»»»xttbqtMYY©³·§¬¡³¹w¤¡¢su©nz¤¦­8EE²¹ºo~q»p   áàvØ×ççnÊÊpÎÒpÏÓ_«®kÃÇhÀÂfº½dº¼e¼¾Y¤¦X¤§a·¶_°²_´²d»º]¬¯_¯±dººc¼¾b¸»U¢\®³Z¤§c¸¸d½¼cº»a³²c·¶d¹¹f¼¼d»½cº»]­¯\«®iÂÄ_±³_´·SA|~ª¼½»ººººººººººººººººº»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¨´·DPR                  £³¶GRT»£]kt]hnIQV»ÎÒVVEqt»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»%*-'-06>B:EJN]bNZ`MW]JW]MZbO^dCNTQ^cQ]bLX]^mtWdiXekKU[>FKBMR»»»»»rtt%.,¾ËÍª®¦®ª°¦®¡ªw|ys|¢v¤¡©%#<CA·½¿y»Vgo   |×ÕtÒÒkÃÄlÅÅiÂÅ`¯´b´¶b´¶jÃÅb´¶f¾¿_°²_°²h¿Áf½½hÁÂa¹·e¼½_®°bµ·a³µc¸»c·ºb¶¸Z¦§[©¬[ª¬h½½b²³hÂÂa·µ\®­iÇÇ`°²f½¾kÅÆhÁÃ_±³gÀÂ]°²PB~§¹½»»»»»»»»»»»»»»»»»»»»%n*9»1G*9'.*9'.,@*9*9*9*9*9*9*91G*9'.'.1G'.*91G»*9%n»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»²¾Â@IM                   ¯´ITW»WenYdlIRX»ÇËQREsw»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» #&.79,574?A9AG<EJ9DH>JO9DG6@D7?B:DG6>ABMQ=EHAJM7=@AJN6?C»»»»»qw%/-
¤­®§µ¸¦ª¦©£§ª²«³|}¢©¢«ott~¢¢­ «xs	krq¸ÀÂw»j}   äãwØÙg¼¼_­¬iÂÅX£§]­¯iÄÇa³µ]¬¯Y¥§b·»f»¾kÄÆmÉÉf¼¼d»¼hÀÁc·¸_°±_³µb¶¹c·¹d»¾d»¼iÂÄ_­¯h½¿h½¿d»»e¼½d¾¾c»ºa³´a±²hÀÀbµ·b·¸dº»b¹»Z«¬I©º¿»»»»»»»»»»»»»»»»»»»»[g´ð»íðóòòòò¢£õóó¥¥÷¢£õóïíïòòòðí»ð[g´»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»«·½BLP                  ¦«AJM»YfmYgmCMQ»ÈËRR@ln»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»!#*+2<?.48'-0 &)#),"(+!&)#%$&$*+*13',-%*+',-&+-$)+»»»»»xBMNV`_ÃÍÏÅÎÏÎ×ÙÌÕ×ÊÓÖÆÍÏÍÖÙËÓÖÉÓÕÎØÚÊÕØÊÕ×ÊÔØÇÑÕ»ÄÇºÅÉºÅÊ´ÁÇ£±¸¡±¹¡³¸P[[~¢»av}   yÑÐxÙÚnÏÐd·¹_±´\©¬iÈÉfÀÂb¶¹Ra´¹^­±d·¸a²´mËÌe¸ºd¹¼^¬­a¶·b·¹b¸»a¶¹]«¬[¨©b³µ`°²d¸»iÁÂ\§¨hÁÂ_°°c»½^¯°`±³`²´\¨«\¨ªmÉÉiÁÂa³µ_³´I¦¸½¥»»»»»»»»»»»»»»»»»»»»#k@L»*9*9'.'.1G*9,@'.*91G1G*9*9*9*9*9*9*9*9*9*9»*9"i»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»«·½DOS                  ¥§BMO»¡YekVcgFOR»ÎÏRPCnp»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»                                                         		»»»»»lz}                          %#¢¦½gz   ÝÞi¿ÂfÁÃoÑÓpÐÑf½¿Y§¨a¶¸\©­_¯´_¯³c·»d¶µe¹¹dµ¶d¶¸a°²hÁÃeº½b´¶_°´\«¯c·¸a²³hÀÁd·¹_¬­d·¹dº»a±³f½¾a³µhÁÃa¸»Z¨ªb¶¹f¾Àg¾ÀiÄÅa¶¶^±±G«°{»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»«·½CMS                  ¥©FPS» ¢dqvXdgGRT»ÑÒ[RDrs»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»-5919=>GMVdkVekgy]nv[ls`qx^ntdv~arwdu{l{k{rk}gsxMX[HRV»»»»»xo}trm|qo}ooj~vfxok}nm}pnj{spm|pnsprtt»   zÔÕmÅÇ\ª®e»¾g¿Àc¸¹d¼¾]­®Z¨¬X¡¤lÈËe¸»h½½i¾¿h¼¾`­®kÆÈf½¿d¸»iÂÃb·¹^¬®_¯¯h¿ÀhÂÂc·¸\ª«a³´\««bµ·h¾¿b´¶bµ·^²¶]­²gÁÅf¾ÁjÆÉgÀÂgÀÂ_³´G£±·~»»»»»»»»»»»»»»»»»»»».H;,F92M@2N@-H:0J>2M?,F:2M@.J=+F90K>0K>,F:*E8*E90J>.I<1L?5QC2N@2OB»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»«µ»DOT                  ¡¥DNQ»¢¤esw]ikNYZ»ÔÔ\VIzz»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»)03.6937:.35n¡pxvIPS8?Cz~vzª²INP5:<itzJVY»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¢   ÜÝrÐÑqÐÑh¿ÁmÍÌf½½jÇÊ_°³U_±´f¼¼e·¹i½½h¼¼jÀÀh»½d·¹a³µeº¼_®¯d¶¸d¹ºiÂÂkÇÇd¸»iÃÆ]¬®d»½gÀÁ_¯±d·¹g¾Àf½¿[ª¬_³µf¾Ãaµ¸d½¿f½¿_±´^±³H©¹¾»»»»»»»»»»»»»»»»»»»»GhYVxhJl\Mn^IjZQscTvgJl\FhYMo`GiYKm^TvgEfWSufPrcNo_GhXKl\No_Lm^Oqa»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¬·¼CMP                  ¡¤BKM»]giamnHQQ»ÎÎVYDpo»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»)035>Bmtw=GJ~§p¨«µ»KWZ¨ ¥«´ºWegmy}OZ\»»»»»n¨¬²º¼µ¿Ã±¹¼²»¾°¹»²¹»²¼À¬¶º¯¹¿©³¸°º¾°¹½®·º²º¾²º½´¼À°¹¼°º¾±º¾®·»°¹¼²¼À¯¶¸±¸»³º½²¹»z»«´   æækÅÆh¸¹kÁÁmÇÅoÎÌgÀÂ`²´UY¦§jÃÂb²±dµµd´µh¼½iÀÂd·ºdº»cµ·h½¾h¾¾h¿¿d·¸`±±`±³dº½kÇÊ^¯²dº¾gÀÂa¶·oÔÕhÂÂd»¾gÂÅe½Â`±³d¼¾hÃÃ]­®]¯¯I§¸½z»»»»»»»»»»»»»»»»»»»»¿¯¥Ç·£Å´¤Æµ¥Ç¸ Ã²¼¬Á±»«Â±½­¤Æ¶£ÆµÀ°¡Å´£ÅµÁ°¡Ã²À°©Ì»¿® Ä³»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»­¹¼GPS                  ¥©DMP»¡¢`ln]giPZ\»ÒÒXVK{|»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»1:==GJUafiy~¡¤s¥¡¡§£¤ª³ ¨¤¢vamp»»»»»jz 	6XTWEvuQMLEstNLKTLJ}}I~Eyy7bb:hh@nqDsuEsuHxzGxx!+*o}»x   ðïpËÊhººuÓÔwØ×tÒÑ_¬­_­°jÄÇ_®±bµ¶eº¼eº¼^ª«e¹¼d¸»a±±cµµh¿¿e¸·f»»h½½fº»b´¶eº½a¸¼U¡Y¤ª]®²Y§¨^±³e½¾lÍÏpÐÒZ¥¦^¯±b·¹kÉÉhÄÄf¿Á_²µJ±¸»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»­¹»FPR                  ¦ªKVX»¡jvzeqtIQT»ÐÐ`¡\Epr»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»@EHMUXisw| ¦¥¹Á¡³¼¢²¸¡±¹«½Ä­¼Â§¶»«¼Ã¢¯·¦µ½ª»Ã ¦ª¹À¥«v»»»»»ix~>LNu¸³k±¯`£¢g°¯g¯«dª¨i³³k·¸WV`¨¨_¦§KNMT[¢¤Z¢RCqs9dd
?IJt»¢   âãkÂÂuÔÕtÑÒpÎÏmÄÅkÂÄd¶¸a³µbµ·eº»cµ¶kÃÅa±³`±³[¦§eº¼i¿ÁiÀÀnÍÍiÃÄiÂÃmÈÉg¾ÀiÄÇkÇÊhÄÇ_¯µb¶ºg¿ÁUd¹¼g½Àd·¶kÈÈb´·[¦§f¿ÁfÀÂa¶¸W¥¦N$)+¥«n}»»»»»»»»»»»»»»»»»»»ºbqxXfkQ^bQ^bQ^bQ^bQ^bQ^bQ^bCMObqxXfkQ^bQ^bQ^bQ^bQ^bQ^bQ^bCMObqxXfkQ^bQ^bQ^bQ^bQ^bQ^bQ^bCMO»bqxXfkQ^bQ^bQ^bQ^bQ^bQ^bQ^bCMObqxXfkQ^bQ^bQ^bQ^bQ^bQ^bQ^bCMObqxXfkQ^bQ^bQ^bQ^bQ^bQ^bQ^bCMO»»»»»»»»»»»»»»»»®º½ITV                  ¡¥LWY»¡bnq[eiJRT»ÎÏYTFrs»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»                                                            »»»»»on#/.
		)DBåöö{ÍÌ~ÐÑr½¼ÕÓk´µ{ÏÑj»»j¹ºqÈËc¬®f¶¹d°´_©±f¹¾a¬¯b¬°[Ewy *)tjy~»o   ÜÜoÊÊlÂÂrÐÑrÓÔiÀÂd¶¸g½¿cµ·dº»f½¾]ª«]©ªd¸ºhÁÃa³µg¼¿iÀÁiÀÁkÄÅjÁÃ_¬­i¿Àb³µf¿Áf¾¿iÄÆiÃÆb¶ºa´¶a³µ`±³a³µf¼¼h¿À\©­X¤§b·ºd»½c»¾]®°H$+,ª¼Át»»»»»»»»»»»»»»»»»»»ºw|||ww}¢LWZw|||ww}¢LWZw|||ww}¢LWZ»uz||ww{LWZuz||ww{LWZuz||ww{LWZ»»»»»»»»»»»»»»»»³¾ÃGQT                  «­DMP»¤¦]gj[dfQZ\»ÖÖVTK{|»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»qk}jx~	PµïíÕÕyÈÇçæyÃÅrÂÄg°³uÇÊsÂÇtÃÈd²¶e±¸nÇÎ\¨¯d«±XN10jx}rw»^lt   ßÞlÄÆvÙÛh¾Àa°³g¾Àa³µc¶¸eº¼\§¨[¤¥g¼¼b´µb²´]ª«a²´b²´h»»i¿¿h»¼i¾¿nËÍd¶¸f»½d»½a³µg¾¿a²µ]¬°]®°d¸»kÆÉd¸»iÁÁkÉÉW¢¦b·º]®²b¸¼Z©­W¤¥C&,-¤¹»y»»»»»»»»»»»»»»»»»»»º§¯                        LWZ§¯         	   LWZ§¯   @rw?pu@rw>ot;kp:in   LWZ»§¯ppAS[    ~ppLWZ§¯ppAS[    yppLWZ§¯ppAS[-5*2ppLWZ»»»»»»»»»»»»»»»»«µºKVY                  ª¬KUW»bmqbnqLTW»ÌÌYYHtv»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»wm}t[hm
o²®Ãóô{ÐÏ}ÒÐo°±×Õa¦¨r¾ÁxÍÑk»½kÁÅuÔÙ^¬´V¢H}@rv'FEZhltru»k~   ßßpÌÎf»¾d¶¸^«­_°±_¬¬iÁÃiÀÀcµ¶b²²d··b²²a±°_®°\«¬a¯°f¸ºj¿¿j¿ÀnÇÉd³µfº¼h½¾b²³f½½hÀÁhÀÂpÒÒ^«¬rÓÕhÀÂe»½rÓÔf¾¿]«®[¨¬_°µ]¯³`µ¸]®°E"()©¬v»»»»»»»»»»»»»»»»»»»º«³   i{]owWiqSemPbjM_g   JUW«³ |ÌÐ]¢QKEzAsx JUW«³   WZTPK;kp   JUW»«³pAS[   ?QY@RZ   pJUW«³pAS[ Ez=ns pJUW«³pAS[%4`f2\b(0¦pJUW»»»»»»»»»»»»»»»»°¼ÀITX                  ¢¥?GI»¡bnq[ehMVZ»ÐÐYTIvy»»vp~trtsrtqz¦¨¥¯²®·¹¬¶¸¡¬®¤©unzpvxrr»vp~trtsrtqz¤¦¥¯±­µ¸­¶¸£®°¤¨unzpvxrr»»»»»»»tl|n~pIVXÞÚèätÄÃi³¯yÌÈÞàn¶¸g³µg´¶\©©kÃÆOQ9ej/UX
LY]stut»m   àálÂÃi¾Àd¶¸c·¹\ª¬_¯¯iÀÀfººlÄÄmÈÇi¿¿\¨¨_®®^¯®\¨¨b²²i¿¿a¬¬i¿¿kÃÂlÅÆf¼½d·¸jÂÁf¹¹kÄÃkÆÆmÇÈc´µmÆÇmÇÈkÃÅkÃÅe¸ºe¼¾f½Àa·º_°²hÅÇ\­¬I¥y»»CIJ                  =CD»»»»»»»»»º«³   wl~fxas{[muPbj   ITW«³ ãèwÃÈp¹¾j°µd§¬9gl   ITW«³   16b¥ªXTO
"'   ITW»«³=OW   N`h_qy_qyFX`   ITW«³=OW Ymµ¹e©®G} sITW«³=OW%-;joRQ@rw);C¦ITW»»»»»»»»»»»»»»»»­·»@IL                  §ªGPR»Xad_knJRU»ÊÌRWFrt»»m}rn~qo}ts|luwDML20./.0+/02(:8AKKkux¨¬¡zsn|rrs»m}rn~qo}ts|r{~X_a488!	,)&ORRX`by ª®¡zpn|rrs»»»»»»»qntop6AB
%#²ïíèç{ÎÑÕØqÄÆnÀÁrÆÉkº»tÎÒmÃÈM>tw8af	1<=tn}p~ww»x   zÔÕsÍÏsÐÑmÄÆf¾¿_±²b´´`®°f¸·f·¶oËËjÁÃeº»]¨¨b²²b´³a¯®h¼¼f·¹h»¼h»»gº¹pÎÎd¶µf¸·mÆÅk¿¿h¾½kÂÁnÈÉi½¾kÄÅlÅÆi¾¾kÂÄb³´hÀÁ\«­V d½¿]®­I®´v»»   >DE=CD;AA9?@8=>   »»»»»»»»»º­µ6HP   wk}fxew   :LTITW­µ6HP ãèuÀÅpº¿Y :LTITW­µ6HP   16b¥ªW#   :LTITW»­µ qgycu}cu}`rzM_g"-2ITW­µ }ÍÑyÆËr¼Áq»Àe©®P".2ITW­µ Asxl´¸fª¯g¬±P?pu"-2ITW»»»»»»»»»»»»»»»»­¸¼BKO                  ¥³¹EPP»¡]hj`lqJTV»ÐÐVXFtu»»i{l|on~rshtw,>>65JG_`ospvntbgII61"&&_km¥¨l{~rqu»i{l|on~rsiuwKON0&9(M3!X:$[8#[9$W6!G,2!22.lvy¨«m|qqu»»»»»»»ml|n~qsl|&$8QO©íëÖ×ÚÜ`©«oÂÂqÄÅjº»e´¸VBy|2\_qpm}up~p~»h{   }ÙÙlÂÃpÊÊ}ÛÛrÍÍh½¾jÂÁa²±e¶¶i¼¼kÄÅiÀÂeº»fº»b°¯a¯®b±±dµµd³´hº¼f·¶lÂÂj¾¾j½¼j½¼i¼»i»ºi¾½kÃÂnÊÊiÀÀjÀÀmÇÆlÄÄh¼¾d¹¹i¿¿mÅÅqËÊf»»`³²G¯¶y»»   ¶¾¿`ij^gi]fg<BC   »»»»»»»»»º®¶w6HP   wi{   :LTxLX\®¶w6HP àåyÇÌ :LTxLX\®¶w6HP   &   :LTxLX\»®¶   {zvwk}bt| LX\®¶ âçßä×ÜÙÞ}ÍÑa£¨ 
LX\®¶     
   LX\»»»»»»»»»»»»»»»»­¹¼DMP                  ©ªJUW»¤§]inXbeCJN»ÖØVR@hk»»kyl|l{rly|N[[3.	UT{£¡© ©¡©£ruPR32$8CBqrm}»kyl|l{rly|S[\299L:)Q:#F54!T-sE)vM1sJ0jA(d@(X:$5JPQqrm}»»»»»»»ottpm|~sdru	\Ô÷ùuÈÈrÇÈqÄÅwÍÎ`©ªf³¶Fy|6ce22
euymmoosu»v   {ÖÕpÌÌiÃÃFDtÌÌmÁÂd¶·b±°kÄÄi½¼nÉÉf·¶d´³gººe·¶b±±e·¶f¸¹i¼¼mÂÃpÈÉlÀÀk½¼pÈÇmÃÁnÃÁ}àÝf¹¶nÈÈlÅÆh¼¼kÄÃi¿¿a­¯a±±cµµCDvÒÐdº¹E¢dt{»»   ´»¼ÎÓÓdmo>CD   »»»»»»»»»º¨ºÂ|6HP      :LTw|LX\¨ºÂ|6HP      :LTw|LX\¨ºÂ|6HP      :LTw|LX\»¨ºÂ*<D
$(/  !08LX\¨ºÂ-?G&./7 $, ( 2:LX\¨ºÂ*<D"(/  "08LX\»»»»»»»»»»»»»»»»®»¾HSV                  ¢¥HRT»¡[eiYdhFNQ»ÐÐTRCmo»»n~nptBOOA<	qr¢¦¯©²¬´&²º*¶½'³¹&«±im<?,%0<9¢§ql{}»n~nptS]`>GEH9'{\ zmcDL;"A.R&j1xG+rG,rL2rP6cB+N0,
DJK¢¥ql{}»»»»»»»ptvn|qly|m|Xeg	   |Á¿Ìö÷Ýß~ÖÖãå]¡¢DtuM)HI[hkvk{nytq~lx|»l}   ÝÝuÒÒA~~e»¼oÄÅ=wyrÊÉh¼¼i¿¿j¿¿i¾¾h»»k¿¿h¸¹d³´c°²nÊÊgººg¹¹g»»hººk¿¿hº¹i»ºj½¼pÊÈpÉÈyÚÛnÆÆpÈÇjÀ¿kÃÂh¼¼fººdµ¶d¶¸D}Yª¬f½¾GsÎÎJ£ªx»»   ·¾¿áääÌÑÒÌÑÑAFG   »»»»»»»»»º«½Åpwp||wwQ^b«½Åpwp||wwQ^b«½Åpwp||wwQ^b»«½Åpwp||wwQ^b«½Åpwp||wwQ^b«½Åpwp||wwQ^b»»»»»»»»»»»»»»»»¨³¶JTW                  ®±MW[»¢¤]ilYdhJSV»ÔÔVRFsu»»m|pk{FTTC={{£¯­· ²¹'µ½*¸¿.¼Ã.¸¿-´½& ty]fpttzAD("9DC¡¬°~q»m|pk{PZ]GPP[Q;O6zR6©ªÕé»¤t[W7I6L#b-tD({S5{Y=wT8iG/W7"+NSU©­~q»»»»»»»stsyivyppl|BMN   ¥ìê´ïñÞáa¨©NI<df(&ANPtrpm}o~m|qo}»p   ÛÛoÇÈB~y××_®±<tw{ØÙkÂÃmÁÁtÏÏrÍÌqËÊqËÊj¾¾e´´h»»i½½pËËjÁÁi¿¿mÃÄi¼¼hº¹lÂÁpÇÇsÏÌrÌËtÐÐmÀ¿|ÝÜtÒÏh»»lÆÆfººa±²a²´B~QZ®¯;ppsÎÎ<qs
¦m~»»   âåå¸¿Á³º»²¹»¸¿À   »»»»»»»»»ºµÇÏª¼Ä¬´®¶¬´¬´¬´¬´¤¬µÇÏª¼Ä¬´®¶¬´¬´¬´¬´¤¬µÇÏª¼Ä¬´®¶¬´¬´¬´¬´¤¬»µÇÏª¼Ä¬´®¶¬´¬´¬´¬´¤¬µÇÏª¼Ä¬´®¶¬´¬´¬´¬´¤¬µÇÏª¼Ä¬´®¶¬´¬´¬´¬´¤¬»»»»»»»»»»»»»»»»«·¹KWY                  ¬®JRU»¡]jo_knMVX»ÎÏVWIvx»»pnUce1-qnª¶·¿(·¿/½Ä0½Ä.½Ä.»Â.·¿#s7H	ab6joms:;$\fi¢hw{»pnZgj;BD\`RZ@jJeFbF»ÀÔè¾µÒp{NK9@U$o=#|R6zR6yS7hE.O3!#
jst¢hw{»»»»»»»utptn|m|~n|kx|t)32((   #!Þõ÷wÅÅRBst8ac %.,jxzp~m|rjyk|ovkx|»    áámÂÂV£¤CDZª¬zÙØrÍÍj½½mÂÂrÊÉuÏÎuÐÑnÄÃf··i½½k¿¿mÅÆi¾¾nÄÅk½¿mÁÁmÁÀuÓÒnÅÄlÄÃhº¹nÄÃqÇÆrÊÉxÕÔnÇÆjÀÀjÀÁh¿Áh½À^°³?wx6ijId»¼7ij¥k{»»FLM                  @FG»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ªµ·GRT                  ¨«IRU»[gkYbeGNP»ÍÎTRDmn»»n~n.@?VQ£&ÂÌ1ÀÇ1»Â/¸¿/·¾.¶¾-²¸,°´qO,>Æ/]X]!\b'((%¦©s»n~nAJMT_[wbJrUzVyWiJrL2½ÆÖíÇÀÝ«¨qJI,9O$i7p@&vI-uN3aA,B,%¤§s»»»»»»»sp|sly}tn|zkx|vl{~  8MLÅÄL7``-,hwyp}m{}m{~m|l}ok}qm{»~	
X¥¦{ÖÕrËÊmÂÁuÓÓiº¹mÃÃnÅÄj¼¼nÅÆnÅÅoÅÅoÅÅtÎÎrÊÊpÅÅrËÊuÐÐpÆÇoÄÅmÁÁpÆÇmÂÁoÄÄtÎÎmÀÀpÆÆoÄÄuÏÎtËÊyÓÑvÑÐpÉÈtÎÎsÐÐpÊËrÍÍi½¿a³µW¤¥Q 4ef¡¬ds|»»»»»»»»»»»»»»»¹»»»»»»»»»»»»»»»¹»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»°¼¿GRU                  ¥µ¸IRU»eqv]hkPZ\»ÍÍ\VK{|»»k{Yil73&ÁÌ9ÈÎ4ºÀ,¦¬&%(&' QOÞ£âÆ)Chj#¢£	u|BD"cmn»k{`os7?A~|kwY~]uTgIcG\AoK1¸ÄÔîÃ³Ò³vYn@,&:b-o;#rB(qJ0Z=(+kmk»»»»»»»qtp~qsqn|viv{qYeh	Pwwz&CC	dsum|p~qk{opl}n~o|p»|;DG9:U¢£}ÙØyÔÓ|ÚØáß~ÙÙ|Ø×zÓÒ}Ø×~ÙÙ{ÔÔ|Ø×|ØÕ~ÚÙ{×Õ~ÚÙÛÚÝÝ|×ÖzÔÔzÔÔÛÚÛÛÝÜ|Ø×~ÙÙÝÝ}ÙØ}ÙØÝÜæäÝÜßÞààzÕÕáátÎÎkÅÆY£¥E/0)04wds{»                                             »                                             »»»»»»»»»»»»»»»»»»»»»»»»»»»» (( (0 (0 ,( (0$((,0 ,(( ((((0 (0((0 ((((0 (0(,0'//+( ,( $( (( (0 ((((0»»»»»»»»»»»»­¸»GPS                  «®P[]»¡¢eqvdpuJTW»ÒÒ\[Ftv»»n~:JJQK¯µ=Øá<¿Å+ssTWEFJKpr"Yd1®Sô¨ )d0!'ª±¦¬Z]('-87£¦»n~KVZHRRmwY}]DuQ9g2 c.P)V:(VZ?¶Êå³®Ð´xePOR/<![%o7 qB)dB*9$TPI£¦»»»»»»»n{~vn|lx|p|ttwpl{~wS`b
NxxS_am{ro|sssk{nwqs»xgw}Ygk7@DLX^[kqk{»   }N[];EG079?HK4;>?HK18;<EH3;==EH;DF4;>   »   Y7^_*GI"9:-JL%=?-JL#:<+GI$=>+GI*FH%=?   »»»»»»»»»»»»»»»»»»»»»»»»»»»» ((hx@PX@LPHT`HXXHT`HT`>JV<EH-86)15&/1&)-%(,'2428</8;3<@AIOGW_@PXHT`PX` ((»»»»»»»»»»»»®¹½JTW                  ¤§IUU»¤§eptalqMVZ»ÖØ\YIvy»»m!?A%ÓÜAÓÚ1¦¦kCYTQ:?3[Ynto}m~hw)«´)µ¼¬°ps 46 ¦©»m=GJhpkpeºÄ¡ÊÝ·ËÞ¸ÊÝ·ÃÕ°ÆÛ¶ÂÓ¯ÊÞ¹ÃÚ¯¯Ò¥Ê½|z eOf>:&U!r9 mF+E/2$¦©»»»»»»»jx{lz|jxzp~pm|wxttsw;FF#-,
+':FEttrsto~rpl}rtx» {ix}^lqWcgN[]M[\P\_HSVMW\ITXGQUKV[CNPBMPEPS>HK=FJ@JN?HL;CI7AC@KM<FIAKOBLQDMQNZ^NY_@JM6>A7AC;DE:BE5=?7?B7>B2:<8@C8AD,3518;GSVaqxsz»   ¯ÁÇÂÏÒ©¬crv§¬m|¨®jy~¢©ivy¦«KVX>FH   »   ÇËÕ×l¯±Fvyl­°Mm®²K}i¨­Kz|k¬¯5YZ,HJ   »»»»»»»»»»»»»»»»»»»»»»»»»»»» ((PX`(88XhpWfn9CN)19%+1;@EAGG:BEBIKAFH49;"')+26'.2&,/9CG'/0H\`((0»»»»»»»»»»»»°¼¾P[^                  ­®GPT»¤¥`kn`kpLUX»ÖÕXXHuw»»p(HJkÐÖMæï>ÅÌzh	w¯*Ã2n'7>(¥§,°²+­¯,¯¸*µ¼)·» ®³£	w| 9;ª³¶»p*/2¨vko®ÀÐò¾ÑíÂØðÊÖîÇÙïÉÈß¶¿Ú¬¶Ñ¡¥Á­Ï¸´{TvPM6 R pB(R7$+ª³¶»»»»»»»spt{n|sstpvvss"+( !*(qxrmzujy~ix~prm~tsx»|wutiw|reqwrro}wpuoujyqxaqwft|rlzyvywuroqsrvzvrn}yosdrwcqvur»   «¾ÃÐÛÞ£´¸y¨»Àv§¶¼s¢²¸r~©­NY\>FI   »   ÄÇ¢áãvº½V|ÁÄTz¼ÀRu¸¼Qm¯²7\^,HJ   »»»»»»»»»»»»»»»»»»»»»»»»»»»» ((`lpÀÄÀ0<8Vem>NQ-351:<0::$)*!#&6<@FLO%.-6AG(14088X`` ,(»»»»»»»»»»»»³¿ÂIRV                  «­FOR» ¡`knW`dJRV»ÐÐXQFrt»»p3PRÿÿZëó:½ÃzU!Þ4mÿÿ'ã=¯8	-1|*©®,²·,´¹,µ¼*·¼&²º!¬²¥z >Aª²´»p"')ÍÇ·®¡n~]{]³¾×ñÊÕéÅÔçÄÒæÁÄÜ±¶Ô£vaLV9EL3PN4[I1[O3_G-cC*l;#_B*$ª²´»»»»»»»m{}kx{stqm{~qswm|sxshvyjvyturjx|lz~iwzlz}k{pvwwu»¨±y~¥¥£ª³}®´~¡¨¡§y~u}xqxzyo|y{x~yzr}»   ÂÌÑÛäç¥¶»}ªºÀp¥¶ºt£´·q§¹¾LX\7@C   »   ÒÖ¬êìy¼ÀY}ÀÄOx¼¿Rvº¼P{¿Ã6[^'BD   »»»»»»»»»»»»»»»»»»»»»»»»»»»» ((P\`hpxO__IQXNZ_GSX$&(%*,1;;4AA2>>*/1!$/37MPR)-.(/207<OZ^X`h(00»»»»»»»»»»»»­¹¼MWZ                  ­°KUX» ^hjgsvPZ]»ÏÏW^K|~»»o2QRò÷lòù9¿ÁNsÿÍÿ×ãÿðÿÏ.U	<5y%¡&¥¬(©®(­³'°·#®µ¨®¢ IL ¤­¯»o$%ËÄ³¸«¡tgtUx]ÀÆ¢Ñé½ÕéÄÐæ½ÅÜ±¯Í¯u^{H"0W2k@)jB*nF/tO4`B,&¤­¯»»»»»»»m|rhuxm|sjx{tlx|n|l{~stn|o|rpo|rl|rm|rprqusuu»po¤­¤¼Äª°²¸§°´½­³ ´º©¿Ä¡·½¬±±µª±±· ²º¨®¢³º¦ª¯±®®¢±³ °³¥ª «¯¥¹¾©­ °´©¯¤¤¶¹§·¼¡°³¯½¿­½Àª¸»ª¸º¬¹»¯º»²¾À¬¸»¨´¸®²£§|»   ÂÎÒÕÝà °¶tª½Ât °³t¡²´t °¸R_f>HL   »   Ô×¦ãås¶ºR~ÃÆRs¶¸Rt¸¹Rt¶¼:bg,JM   »» (( (0 (0 ,( (0$((,0 ,(( ((((0 (0((0 ((((0 (0(,0'//+( ,( $( (( (0 ((((0» ((XdhHXXQYYmsyry|(-- %'?IL\dk@PPHXX@PXNY]=EH)15;@AGML*.1)/19EFW__(00»»»»»»»»»»»»³ÀÂUbe                  §ªLWZ»¡¤gsw]hiQZ\»ÒÔ^VK{|»»p3NPvÉÎøþEÊÍQôàÿìáÿíÿ«'Ó<[OJ|w~u}$£!¦¬£ª¡ IM!#§©»p $&¢Ã³¨{e}[qSbH´¿Ëá¸ÕèÃÍãº¼Ö¦¯Î ÇsU.03	Y1tH/yO4xU:[?,C>9§©»»»»»»»pm|n}vjx{skx{sqm|n|p~n{~n|n|ly|rlz|qlz|qlz~iwztstrps»i{Rbi$&
		   			

!            [ij§´¸ »   ÂÍÒÒÚÝ ²¸jzª½Ãv­±v¢²¶t§¹¿KU^=FL   »   Ó×£àât¸¼K~~ÃÇTo³¶Tu¸»R{¿Ã5X_+IM   »» ((hx@PX@LPHT`HXXHT`HT`>JV<EH-86)15&/1&)-%(,'2428</8;3<@AIOGW_@PXHT`PX` ((» ((PX`IQQhouDHJ"$LSSPX`P`hHPPP``P``H`hHT`:FL&,-!&(BGHBGI$,--58JYY(,0»»»»»»»»»»»»¯»½GQR                  «®HRT»¡¤iux[dfNVX»ÒÔ`TIvx»»n|6LOYôù\àåq*°@ö£ÿ±EïY«]*jlghCD
?0I2RT~¡¡¨ } AC+,»n|&+-mqkÀ³¦ytT~S7o=&h=&D;(®ÁÐèº½Ú©²Ô³ÔªÏ¾{sW4*I%Z-tI.qN4R;)WXU»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»z!$$&<FKLY]KX]Q`eHW[HVYIV[GTXALPCNSBMQCMRKX[JTWGQTLWYHRSOYYMVWO[[NYZLWZHTV>HJJVYR\`NW[P\`NY]LWYTafR_bP]_HRU<DG9AC<EEFPRP[_(-.eruª¸»»   ¿ÊÏÎ×Ù¦»Àhz©®x¬ÂÈo}¥µ¹z¢²¸JV^6>C   »   ÐÔÝßzÁÄJ~k¯²UÈÌOx»¾Wu¸¼5Y_&@D   »» ((PX`(88XhpWfn9CN)19%+1;@EAGG:BEBIKAFH49;"')+26'.2&,/9CG'/0H\`((0» (( P\`NV^lsuCJPPX`HTXHXXP\`H\``lxP\`@PXHW_;KN-48CGH%+-/9:KZa(00»»»»»»»»»»»»´¾ÂGPR                  ¢±µJUW»eqv`knGMO»ËÌ\XDlm»»pCRU<lkóôv÷ù6Á¹g(¨P1°Q7v@}x zf5 t|c&$`b¢§	 y;:BMN»p>EIFNOÄ¾«ª£xÊÚ²ÚáÆÐÖµÊÙ¹Íà¼Êà·ÁÜ¯±Ô£ËÍ£ÑÀ}£cI: T-xP6lL3H7*ckn»»»»»»»n¨¬²º¼µ¿Ã±¹¼²»¾°¹»²¹»²¼À¬¶º¯¹¿©³¸°º¾°¹½®·º²º¾²º½´¼À°¹¼°º¾±º¾®·»°¹¼²¼À¯¶¸±¸»³º½²¹»z»¨R_e_ntSbhrytWgl\lqVdkSahKW]JUZYhmZimsbqu`lpfrwbnqgsw]kl[iiboqaooS_b[jm\glcns`kodruanql|aor`nrcotS]aXeghwzl|NY]<DF;DGª¯}»   »ÅÉÏ×Ùª°aqv²¹m}ª°t°ÂÇs¦¶¼MZb9BG   »   ËÎ Ýßm°´Euxr¸½Mm°´RÈÌRy¼À7]c(EH   »» ((`lpÀÄÀ0<8Vem>NQ-351:<0::$)*!#&6<@FLO%.-6AG(14088X`` ,(» ((`dply¤¨DJL"(*QaaHX`P\`P\`HTXPX`PT`HXh@PXHT`HW_2;E &(7<<+46-78EOS(00»»»»»»»»»»»»­·ºGQT                  ¢±µHRT»¡¤alp^hlGNR»ÒÔYWDmp»»p[im6US|¿½ÿÿXîõ:ÄÆ'¢ %)£1¶Áqu «`çsî'¨SW¦«¥gn+(p{|p~»p`ms4;>ª¬À³b¡ÛõÏáðÓÚëÉÖèÆÒåÁÇß´´ÔµzXyN=A*ga?q_>q^;hO1sL5gJ3962p~»»»»»»»jz                        !o}»¤}p^pvIW[COP¤i{hwhyrYfmj|}`qtndrthw|qftzdssl|}gssn}~etvpkxtjy{hvvuuopp}`jmQ]`*12+12_kpKUXBIM¦´·z»   ÃÎÔÖßà£´¸t£¶¾jz°·§·¼u°³HV[;FJ   »   ÔÙ§åævº½Rw¼ÂK~r¶»[z½ÁSr¶¸3Y\*HK   »» ((P\`hpxO__IQXNZ_GSX$&(                  /37MPR)-.(/207<OZ^X`h(00» (( P\`®²²!##Y^cDSSHTXP`hHTXXdhP``XhpP``PdhP`hP\`COV&+-!18:+23?GH ,0»»»»»»»»»»»»°¼¾GPR                  §¬OZ]»£¥dnsYcfKTW»ÕÕ[RGtv»»pp6FHJxwïïÿÿZëõEÖà;ÊÔ7ÅÏ6ÄÊ7ÆÐymWÞn×ÿâÿÑ(bf¬µGH,;;o~»pp@JONWUÒÈµ¼­g{×îÄÜíÐÓæÂÏä¼ÁÜ¬³Ó¡År`10B>'aQ6w\<^CmO8WA0OUWo~»»»»»»»ix~>LN]èärÂÀÜÚ~×Ó|ÐÐr¿ÀÚÙ|ÒÑzÒÏÞÜÖ×~ÕÕ|ÔÖuÍÎ^¨¨e´µo¾ÂtÅÉvÅÉ~ÓÖØ×>QP?IJt»h{~ nGTZ]luw6?D´½luwpbswtqet|jzdszZhmdtz]lqgvwannp}grvn{~~k}brwvy||sdst,22_kmMX[/68apv@JN¨ºÂ~»   ÅÓÖÒÛà¦¬s¥¸¾{±¶o¨ºÀ|£³¸N[_AKO   »   ÙÛ¤áåj¬°Ry¾ÂWr·ºO|ÀÄXv¹½7^a.NP   »» ((XdhHXXQYYmsyry|(--                              ;@AGML*.1)/19EFW__(00» ((`hp°´¸fvP``HTXPX`P`hP\`XdhHT`HX`P``Xhp`hp[jj199	07:)25?LR(00»»»»»»»»»»»»°»ÀIRU                  ¬°KTW»¢¤]gkdquMVX»ÔÔV[Ivx»»m|rTch2IHa°ÿÿþÿcîõJÛã@ÐØ=ÌÒ=ÊÕ A³a¾÷Êmú­">3©²¬¹nq,)akltt»m|rWek)02}áÑ»¯¡cxÇÞ±ÜíË×èÆÇà´ÂÝ®©Î¾rVI=#F7"iD/tQ9bH3=;7luyst»»»»»»»on#/.äÞÚ×uÆÅ~×Õ×Ó|ÓÑÝÞÞßk¹·kº»xÒÒyÒÔ`©¬d¯²d¶»mÃÈwÓÖuÏÓqÁÄg¯²c­­	$.-tjy~»r   ¬³k~GSX ©fw=IL¨nctzhyymnuveu{`ottcrxanojz~k{hv|jy|bnsl{truvvyxxhwz/57bqtXei2:<]lsAKO!#¢«{»   ºÇÊÐØÛ°µx­ÁÈv¡²·o®³v§¹¾T_d;DG   »   ÍÏ¡Þàr¶ºUÇÌTu¸¼Oq´¸T{¿Ã<bf*FH   »» ((PX`IQQhouDHJ                                    BGHBGI$,--58JYY(,0» ((HPP±¶¸|P\`H\XP\`HX`P\`P`hXlpHX`PdhP`h`lp[ny088

:BF-78CMP(00»»»»»»»»»»»»°»¾HQS                  ¦ªLUX»£¦Ybf`lp@GJ»ÕÖRX=ef»»m{~l{k|BPRDli_®ÿÿªÿÿmöúOåíHÛâDÔÚ8ÂÇ% 2m~Px-®¸	®¼|B?JWTtql|»m{~l{k|IV[3<>¶³áÒ»³¥dnÁÒ«ÕéÅÕèÃÊâ·Çáµ¸Ú¥¹Ö£¥xd]A]F.fG3QB8ajnrql|»»»»»»»qk}jx~+GDìþþÔÓØÙvÄÃÝÛnº»×ÙnÂÂnÀÁvÐÓg³µk¾Áh¸¼c±¹kÃÈh¸¼qÅÊzÐÑqÃÅ+(jx}rw»£   ¦¯¤wP^bLY]i{j~fxpj~p|}vqvsnhy~^kpk|[koew{Weil~ttvrvttnrsaqx+24+24Q^dQ^c9AF®¸|»   ÕÞâÎ×Ù¡°µ}¬±q£¶¼}¦¸¾t¥µºvMVY   »   ¦äçÝßt¶ºYp²¶Pw¼ÀYz¾ÂRx»¿T7Y[   »» (( P\`NV^lsu                                    CGH%+-/9:KZa(00» ((PXXµ¸¼,--ju|\hkXhpPdhXdhP`hHTXP\`H\hP``P```hpQ_g7>D&')5@E-46EPS048»»»»»»»»»»»»·ÃÆJTW                  «¯KVY»PX[S\_NX[»ÈÉKz{M~Iz{»»l{oo~l}?MN@kf^çç¦ÿÿÿÿaòûVçëOÝÞCÎÎ:ÁÁ5»Á+Ä¾*ËÓ³¼x|DC@PPo~wtt»l{oo~l}BLO:DDáÓ¿¹«sn|^}`z^v\sXrXqYmcIgY@L9-X`aswtt»»»»»»»wm}t[hmP¶ðîÕÕyÉÈçæyÃÅrÃÅg°³uÈËsÂÇtÃÈd³·e±¸nÈÏ^«³mºÁpÆÊ{××0WUZhltru»   ±¸{j|qiziy~tu]nyh|wkwws~n}rhx}nk|n]lpscswxr~~tn{~kzzrvws`mrizWdjfv}cuzT`f<EJ¥­|»   ÑØÜÀÎÓ¹ÆÊ¢®±¸ÄÈ¡®²ÂÑÖ¡­±¸ÅÉ©®ºÇÊ¤±³§ª   »   ¢ÞáÔØÌÏt´¶ÊÍs´·×Ûs³¶ËÎo¯²ÍÏv·¸m­¯   »» ((`dply¤¨DJL                                       7<<+46-78EOS(00» ((HTX¸¼¾X\^HOOVffPdhXhpXdh`lpP``XhpPdhP\`^quGMS$++=@C1:93:?MU] ((»»»»»»»»»»»»´ÀÄKUX                  ¦¹½ITW»¡¤]gl[fjAHL»ÒÔVT?fi»»lz}lz~pppGUV1IHLroz¹¸òóóøøþ~ùþuõýcñúKáé7ÎÕ³ºjp55FTUvtpt|»lz}lz~pppISU7?@gi]Â¸¢Å¸£´¥¬smkgzbrXjPD8+U\]stpt|»»»»»»»tl|n~pIVXo²®Ãóô{ÐÏ}ÒÐo°±×Õa¦¨r¾ÁxÍÑk»½kÁÅuÔÙ`¯¸]¦¯Y¢c¯µDzyLY]stut»£   ¢¶¿¥¯li}cqxk|t{\nyz{k}x}qpqk}luqzsix~zuky|jy{ixxo}~qtsxm~dt{{ds|VchAKO¤r»                                             »                                             »» (( P\`®²²!##                                          !18:+23?GH ,0» ((X`hv¢§© "|r|XdhP``P\`XhpPX`XdhP\``hpT[aCNNNVX079AINH\`(,0»»»»»»»»»»»»°½ÀJTX                  ¬±P[^»dps[fjNWZ»ÍÍ[TIxz»»p~lz}k{}l{~ptZhk:IK9XVDjhZsÂÇëðøýs×ÝI¢¨)nqBD+EITcgsuqtn|p~»p~lz}k{}l{~ptT_cCLO598ijY}±¤¼®¿² °¥psbQM?2JE>\jnnuqtn|p~»»»»»»»qntop6ABÞÚèätÄÃi³¯yÌÈÞàn¶¸g³µg´¶\©©mÆÉU eµ¾W¡R	5ABtn}p~ww»z   ©³ymdv¥pi|smsk}vxrvzujyl}wt|zytssp~wyuywojzgv}csz?HM¡¨s»»»»»»»»»»»»»ºººººº¹ºº»»»»ºº»»»»»» ((`hp°´¸                                          	07:)25?LR(00» ((PX`jqx·»½RUV)-/|vL`\X`h`lpX``XdhXhhTddPZ]#))DGGIPV069HPWX`h$ »»»»»»»»»»»»«·¼LX[                  ¢´¸LXY»]jnanrCLN»ÅÅVY@kk»»m{m}lz}o}jxzp~m|rWdhAPQ5KM0LN.NO.NO,KL/JL<LO\kppqptqso~t»m{m}lz}o}jxzp~m|q`otHSV9AA58667131,>;3BB;MUU\gltpptqso~t»»»»»»»ml|n~qsl|&$%#²ïíèç{ÎÑÕØqÄÆnÀÁrÆÉkº»uÐÕrÍÒ]ª¯^¯´b«³%#qpm}up~p~»v   ®¶xjz¡t¤®¥¥|ql|wv}n~tjyy~|xwo~qjz~rm~kzrxywvvrix~^msDNS¨³¥°}©««­¢¤¦¨©«¢¤¤¦¨ª¨ª¦©¥¨yyy ¢¡£¦¨¢¤¡¤¦ ¬®¢®°§©©« ((HPP±¶¸                                          

:BF-78CMP(00» ((PTXXd`{¡¥¥¬²²DGI$)*z¢¤p}}ctxZiihswfptEMP$&=?Bcjn.7;7BHP\`HPP($(»»»»»»»»»»»»µÂÆLWZ                  ¡±¶MWX»ZfiervIRU»ÉËS\Ert»»qtm{l{}p}m{}m{~m|l}ok}qm{p}sstuuo}vqotn|»qtm{l{}p}m{}m{~m|l}ok}pm|p}rstuuo}vqotn|»»»»»»»ottpm|~sdru8QO©íëÖ×ÚÜ`©«oÂÂqÄÅk»¼i»¿e´¸`¯´V£44euymmoosu»©¯   ®ÃË¦o|tiy~z£s~y{wttyxqx{y~{¡xk}bsynm|zv{xofw~k|^ltGQW³¼rRY[NUVRXZIPRQXYOWXMUULSUOVXPWXHOOCKL;BC4:<057.23-23)-.),,&)*'+,,016;<8=>9=?=BC;AC:@@DKLMSURXZNUVLSU¦¨ ((PXXµ¸¼,--                                          &')5@E-46EPS048» ((P``PX`X``{§«¯­°³TYY<BCissfkp?FF !NRTJQW;BD=GKPX`PTX 0(»»»»»»»»»»»»®»¼KUX                  £µ¹MXY»YdgT]`HPR»ËÌRNDoq»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»ptvn|qly|m|Xeg	\Ô÷ùuÈÈrÇÈqÄÅwÎÏd°±uÎÑb«®]©¬2[\
[hkvk{nytq~lx|»¥    ²¹z w¥{q¡©{r}k|quuni|~}|ovfw{k{wy£snk{apyP\d;EJ§®|LSU¢®°wlwxQ[^ITVCMP?IL7@B;DG4=?5=?-46%+,$&(./+021556;<ELMCJKFNOW`bmxzRY[¦¨ ((HTX¸¼¾X\^                                          =@C1:93:?MU] ((» ((PTX088Xdgz¡©©®´¶SWX134/02LNRrvvqx}APQBGK000HTX((0»»»»»»»»»»»»²¾ÁP[^                  £µ¸NXZ» ¢cpsY`dFMP»ÑÒ[RClm»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»stsyivyppl|BMN!|Á¿Ìö÷Ýß~××ìîj¸¹^¡¢ßàK CPRtrpm}o~m|qo}»t   ©¿Ç¦°µ»r¢j}~¬¯£}l}l|tptgy~y|ruqovr~vtl~j|[kqT`hAKQ¤­¡LRT¢¤zajkZabx~tdnoHQT;DGAIKNX[ZhmO\aV`c>GJ=EHMW[R]a7AC(.0"#$((.12;@A@GHJQSV^_enoRXZ§© ((X`hv¢§©		                                    		NVX079AINH\`(,0» ((P\`ÀÀÀ088HXXWcfouu¦­­§¬¯º¿Áº¾À¹¿¿®²²££wM\]JZZP``ÀÄÈ088P\`$ »»»»»»»»»»»»­·ºIRU                  «®MVX»V`densMUX»ÆÇP\Iuw»U[]cjk^ef\bdipqipqagiipqipqagiipqipqipqipqipqipqagiipqs{{ipqs{{s{{s{{rxyrxyzz»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»utptn|m|~n|kx|t)320@?¥ìêµðòåèn¾¿l¶¸yÓÕk´·1EB*43jxzp~m|rjyk|ovkx|»w   ¤¬no¥¬woy£y§­{¥uquvsi|w|~{{swk{uquqtqk}fw~ctzZioALPª¯LTUw²¸ºclmwjuwXabCLOGQTZglxpiw{ ¢GPTivzsivy]jnEPT(01 !(,-278>DEIPQX`aoz|RY[¢®° ((PX`jqx·»½RUV                                    DGGIPV069HPWX`h$ » ((HPPHTXPX`PX`XdhHTXahnhru ¤¤gqtHPPP\`HTXP``PX`PTXHX`(,0»»»»»»»»»»»»´¿ÂGOR                  ­¯IRT» ¢dps\ej@FI»ÑÒ[T=de»                                                                                       »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»sp|sly}tn|zkx|vl{~%85ãûýØØn¾¿m½¿e¯±64hwyp}m{}m{~m|l}ok}qm{»q   ¦ºÅ¦±|¡|vs{u¢u{rxpq|oi|hz|qx|spm}qopn}l{wsk}aou]lqCMQ£´ºNUV¦¨xlxzclnFNQO\`qwy¡¤qy|}zyo|`mq=GJ!&'$()489>DEDKL_ghyIPQ¢¤ ((PTXXd`{¡¥¥¬²²DGI                              =?Bcjn.7;7BHP\`HPP($(» ((¤¨ p ((»»»»»»»»»»»»²½¾MX[                  ªº¿JTU»¤¦YdgfsvLVV»ÖÖR]Hvu»   uQZ^KUYKUYRUYRY`KUYISVHRVGMTEORDMQHNOCKNCMODNQLRRGQTIRUJPPLSZLVZLSSLSSLVZLSSLRR   |»»vp~trtsrtqz¦¨¥¯²®·¹­¶¸¢­¯¤©unzpvxrr»»»qtp~qsqn|viv{qYeh	F`_®îíxÎÍb¬­,QP	dsum|p~qk{opl}n~o|p»z   ºÔÛ¦ ¦«±p£xv¢©yp~w §zpttq{t|o~|}swwiyjyrk{otouhw}ndtx\jpDNQ¬± ¦IPR¥§]fhPXZOZ]anqr }vgsw[gk8AB,13%)*045DJKZbdwBII ¢ ((P``PX`X``{§«¯­°³TYY	

                  	

NRTJQW;BD=GKPX`PTX 0(» (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( ((»»»»»»»»»»»»³¾ÀMY[                  «®MX[» ¢\fi[egJTV»ÑÒTTFtu»   uNZ^===TdkTdkZbiRZaMT[GQT<HH?DD;BD=CG;BE=EG?HKAJLDIOIUUQ\`VbfVbfVbf>>>MSS   |»»m}rn~qo}ts|`hk=BC #$
 $%8>@irv¨¬¡zsn|rrs»»»n{~vn|lx|p|ttwpl{~wS`bm ¡Ìö÷IS_am{ro|sssk{nwqs»p   °ÇÌ¨®£¹½¯³¦ooyrkw|zhvcr{rpy~tqm~u~u}l~tm}jypn~vtsrgw|aot`psEOR§¸¼IPR¦¨ny{]gilvzKUZP\`v ¢y~£¤wakn6=?7?A*/1(-.49:JQR\egHOO£¥ ((PTX088Xdgz¡©©®´¶SWX134/02LNRrvvqx}APQBGK000HTX((0»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»´¿ÃGRT                  «®JTV»¥§YbeXbdEMN»×ØRRBll»   uVbnÎÒÖ>FFVbfT`dV^^MPT?JM8>@3;<:=@6<>5;=7=@8AB8?B5;>39;8>ADGIFLLISVVbfÎÒÖ>FFLRR   |»»i{l|on~rsaln+/1>GIYcedpslz}o|`npT_a6>?$)*mz|¥¨l{~rqu»»»jx{lz|jxzp~pm|wxttsw;FF#-,n©©'85:FEttrsto~rpl}rtx»}   ¦¹¿©°®³µ»|£~l}jx}yvrixl|ryuzroqxvzl}rkzn~yk|vu|xpl|`otEOR¦¶»NVW©«w[cejw{£ª¬ £S]bwxiz~cqv]inBIL39; "289<EHaknr~¤¦¡¢¢¤?GIAKM)//29:<ABRYZEJL¦¨ ((P\`ÀÀÀ088HXXWcfouu¦­­§¬¯º¿Áº¾À¹¿¿®²²££wM\]JZZP``ÀÄÈ088P\`$ » (( (0 (0 ,( (0$((,0 ,(( **(*2 *2(+3 **(*2 )1(,0'//+( ,( $( (( (0 ((((0»»»»»»»»»»»»¯»½KUW                  ¥µ¸LUX»`kn\gk<BD»ÎÎXT;^_»   ^bfVbf^fn\hlW^cLQT?KN6:>279167.24035.240356::4:;38:28;68:59:=EHORWU\\^fn^ffFPS   lst»»kyl|l{rly|MUVGPRm{tqrqqn|n~m}erv6>@FNQqrm}»»»spt{n|sstpvvss"+( !*(qxrmzujy~ix~prm~tsx»§   ¤¹¿¥¬¡§¬±¢©oq|wwul|ret{hwhyvw}|utgwuvl~yutuv}l}zq|vj{~`lrCLP©¹¼NWX{fqsbmr}£§¡¨«p{~dsw^lqFRT*03$+- !!%&5<?Zfg¥§¢¤¥¦lwy[hlFQT*01388CJK;AB ((HPPHTXPX`PX`XdhHTXahnhru ¤¤gqtHPPP\`HTXP``PX`PTXHX`(,0» ((hx@PX@LPHT`HXXHT`HVb>LX<GJ-;9)7;&46&-1%,0'572:>/:=3<@AIOGW_@PXHT`PX` ((»»»»»»»»»»»»©´·MXZ                  ¡­±T_a» bnsXbgIQT»ÎÏYREpr»   {V^^Vbf]alS_fHUU=CF8>?8=>EHIMQRV[[hmmiooaffUZ\AEG26805605727:37:=CGNRV^fnVffLPS   s{{»»n~nptHQS,12`mqo}oqro|o~lz~qpn}m|drvVad$(*=EF¢§ql{}»»»m{}kx{stqm{~qswm|sxshvyjvyturjx|lz~iwzlz}k{pvwwu»p   ¦¹¿·½¬ÊÏ£ª§´¨³o~¦}{{iw}hv~vrszpq{ywbq{njwx{xuwz}{yolrsaotITWª¼½IRS ¢q|~[gjt\kp@JN$%	
	

	

$%FQT¤¦tYef.45),-<AB@FG  ((¤¨ p ((» ((PX`(88XhpWhp9FQ)7?%498MR>TU7QT?WY>SU3DF"02+59'/3&,/9CG'/0H\`((0»»»»»»»»»»»»­¹¼GPR                  «®MUW»YdgYdhCJM»ÉËRR@hj»   {Vb^V^^R_eJT^AEJ=ADKPRRUVUYYKOP134567RXZcghTY[=?@/352461674:<@HKQ\`^bfSVa   s{{»»m|pk{CLM,12wprqrttto|n}qq~o}k{}o|p}+02FOR¡¬°~q»»»m|rhuxm|sjx{tlx|n|l{~stn|o|rpo|rl|rm|rprqusuu»Vgo   ¨¬®µ¢¢£rvv¡w~qs}v{qvuxyxjyl}l}wumt|ro\lqJUY§¹½OXY kwyo|¢¤]joAKL#$		    ##DNP¦§¤¦{o|LWY!$$0458=>¡ (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( ((» ((`lpÀÄÀ0<8Vhp>PS-<>/DF.KK!AB45*+*+02 8;4JNEVY%336CI(14088X`` ,(»¿¯GhY.H;»»»»»»»»©³µMX[                  ®±MVX» T`dT^bGQU»ÎÏNNDps»   {^bfT]^FPTAIOCGK_cedgiBCFHLMacg@DG/45/5759:6=>NTZ\`dSZa   lst»»pnYfip{~po~tl{vxo~qrqpqo~m|m|shvzgqu¢hw{»»»pm|n}vjx{skx{sqm|n|p~n{~n|n|ly|rlz|qlz|qlz~iwztstrps»j}   ­¿Ä·¿~n£evo£tnhxw}¡¤~{xrswyz{r{{zytuxxywj{S_d©º¿LTUmy{ª«£¤qR_a"$                        			"'(}¦®¯[eg)..&)*(+,»[gi8DG"% $"$#&"% $"% #"$ "(+$'$' #!$!$"%Ufjt»»»» ((P\`hpxOaaHT[KafCaf!@B..33;<AB>?:;./((-EIJ\^)46(1407<OZ^X`h(00»¥Ç·Vxh,F9»»»»»»»»­º¼ITW                  ¤´¸IRT»[gkVaeLVZ»ÇÇTPHvy»   {V^^QYYLUWJOTrx|prs133022lorDHK15628:489=@CM[bTX[   lst»»n~n&+,^gjtl|ptn}pn|typl|p}n|rrl{so}ISV#))¦©s»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»av}   ¤·¿§¯wpj|¤}w^nvupyu §|zpvxwuo~l|wsyl{syptsl|l|¤vrR_b¦¸½¥OUXzu¡®°¥§¢£{fuy5<=
	                              

5=?¥¦§©}jtv;BC ##%()º=NQ,=@Nbg_uzSej[rxYmrVjo\syWkoYns_ty\osbv{^rw]orTjnI\`4FK.2MY[»»»» ((XdhHYYP\\iw}j%HI11==KLWXabbb\]NN<< ''7QREYX*47)139EFW__(00»£Å´Jl\2M@»»»»»»»»«µ¸EOR                  §ªGRT»Vad]jnCMN»ÌÌPV@ll»   {U_aWZ^bggy-//122mrsBFH.3416849:KNRGQT   fmn»»k{`pt!%&tl{trn~qwptrtqtl|n|usskz}^eh»»»n¨¬²º¼µ¿Ã±¹¼²»¾°¹»²¹»²¼À¬¶º¯¹¿©³¸°º¾°¹½®·º²º¾²º½´¼À°¹¼°º¾±º¾®·»°¹¼²¼À¯¶¸±¸»³º½²¹»z»gz   ¢³¼¡}¡ª´¨²|hzvm}rrxz|{zt|xsm~xu{qyzv~vvi|w}vqQ]a«°{JRRr}µ¿Á¯º»¤¯±Xcg$)+                                 ""v¦®¯r}JTU !!"v~·"%[pu£u{u~nQfl3EJ,0»»»» ((PX`ISSfqwz=_a00??RTgi	uv
}npZ[?A ((?UV@PR$./-69JYY(,0»¤ÆµMn^2N@»»»»»»»»²¾ÁKVY                  ¢³·DLP»¢¤ZeiT^bGPR»ÔÔSNDoq»   zU]]VZ\JLLNPQejl,0116827:>FI?EIcjk»»n~GRVNVZqqtprtttporwtl|o|xm|~gtvq@JK179£¦»»»jz                        !o}»   ¤¬§j}yy{oj{gu}¦{r¡}{xqrxm}ul~xvwqn~~£~~rP]a£±·~Yaahsuª«¡KUX                                 Zfh«²´t}fqsKTV"&& t|~·#&v¢¡¡¡¤§£¡§|yy|xyiATY"%»»»» (( P\`MYa~c}12:<RRhi|~svXY9://ATU%36/;<KZa(00»¥Ç¸IjZ-H:»»»»»»»»²¾ÀKVY                  ¥µºEPR» ¢bnsV`dJRV»ÑÒYPFrt»   {U]]lqq§¬®|[^`CGG/571684;>>INcjk»»m$&r|ytpppn~s{tqqo~yuqrlx|ttp[gi!"¦©»»»ix~>LNlut¥³¶ª®¦©¡§¨®¢¨¢¦­±¦­¥«¤­¦nu¢¢£­§­?LL?IJt»¢   °¹¬¶¨±§ª}¥rbowr}|zt|ryy zoz~ry~}l~r|u{|qpR_b©¹¾OUWoz| oz{q} ¢|FQS!&'                                     #$FNQ¨¯±v~IPQ:@C(+,!"u~´" ¢ varv­±vxzrEV\ #»»»» ((`eqj{§«=`b23FF`awy¢¤ª¬ª¬ ¢	llJL..5KK+>@-9:EOS(00» Ã²Qsc0J>»»»»»»»»¬¸»FPS                  ¡FQT»T^bV_bMVY»ÆÇNPIvy»   {Vff­±±[[]KPPNQS.251685<>9CC   ipq»»pupm|pnsprttvwl|nzxo|~to}jx|qaorª³¶»»»on#,+¨°±©¬¦ª¦©£§ª²«³|}¢©¢«ott~¢¢­ «xs	$.-tjy~»«´   ªÂÊ¦~  ¦¨saqwizuxxyzy{sr{¤p{~v¥­{~|t{onR^a§¸½zMUUmx{¼ÃÆµ»¼iuw¡ITW"()                                 !&'>HJ¤«­¢§¬­KSU.45!$$v´#&¡£|u*7:"$mz}¯¾Â¥¨~wtnnH[a#(»»»» (( P^b¡µµAB88MMij}~$©«$²´³´ª¬y|WX57680DF+78?HI ,0»¼¬Tvg2M?»»»»»»»»¯½¾DNP                  ¡¥MY]» ¢bmr`knBIK»ÑÒYX@gh»   {dss¬±±´¸¸344344TX\(-.5;=5:<=GG   ipq»»p¡«®onjzm~qly|n|rp~ttwpp~qo~tttrqª²´»»»qk}jx~097ÀÌÏ¤©¦®ª°¦®¡ªw|ys|¢v¤¡©%#jx}rw»x   ¼ÕÛ¥©}°¸µ»­²nq£qw{|n}|ysw|~~v{ubrzhwoh{p| §¤¬jy~pw¡}qT_d±¸IPRnz|ºÁÄ¿ÅÇ¡£ «®yU`b                              #$DLO¥­¯ ¡¥¥hpq%*+"#y´#'¢¦¡¢¥{{+9;4+$`'F>Udg¡²¶£zupqDV\ »»»» ((`jr ¢·»4545OQ	km#*©«*±³!²´¬®]^78%&/CF)58?LR(00»Á±Jl\,F:»»»»»»»»²½ÀENR                  ¥©FPR» ¢_jn`jnNWZ»ÑÒWXIxz»   ulws²·µÇÊÊ%%&PUX*,/5;=4=?<DG   ipq»»o¡ª®wrskzspl|m{uqtkx|n|o~tp~n|~r{rq}¤­¯»»»wm}t[hm[ff³¼¿¥ª¡³¹w¤¡¢su©nz¤¦­8EEZhltru»¢   ¨¼Ã±¹­µ§¯£¢ytv|w¡tsix{£¨¦¢¥ rw~aowz~y wlz||vgx}Xeh$)+¥«n}KRSlxz§²µ©´¸¡¯±_ko                               GQU¤¦{hwz!%' v·"%¦©  {5EG$$Ásî}Ôy(IARbe¨®¤{zrf}I^f#»»»» ((HRR£¹»4645NO	ij}~$*¥¦'©« ©¬¦¨^_68
()8NR-:;CNQ(00»»«FhY2M@»»»»»»»»®¹»KUX                  ¯µITV»¡©«]gjequPX[»ÜÝV\Kz{»   {pzw³··ÄÉÇ)++LQS+-04<>5;==DG   agi»»prqqtoppstgvzn}oqtrwqtto|§©»»»tl|n~pIVXµÀÅ¡¦¢§x§«q©{| £°plgysO_bLY]stut»o   ²·£ª«³ª²w}vz}m~l|y u}¡qv~}¡¢vvusv|m}hwxyyoQ^`$+,ª¼ÁtNUVv¨²³ÆÍÏ¶ÁÃ£¥¢n|,02                        

"#%++PZ]Uac'-/#&&·"%¬°¤7GL"24'¬pì|ñ}ï}Õ{9XSM_c§«¤~qvhH\d!»»»» ((PZZ¨»¿)GI22HHbcwy  vwXY46$>@3LQ-8:EPS048»Â±Mo`.J=»»»»»»»»°»¼ISV                  ©­MX[»¤¦W`clx}GNQ»ÖÖQb £Dmo»   ^mm¬³´ÍÐÓ9::78:DIK.234:<;@ABHH   agi»»n|!#gqu£ptppo~po~tjy~yo}o~qtro|o~tp]jl#'(»»»qntop6AB¡«®¥³¶y ¬µ~uwk~£ctuew_r}	5ABtn}p~ww»^lt   £¶¼¥·Âsuw{jziv|vvl}tu~¢¬z}{ttopz£y¡fv~vowk|gw|LXY&,-¤¹»yLSUyÓÚÛ·ÁÃ¨ª¨´·IPR                        9ACq}~t?HJ&*,+/0º "¡7GI$77(¤mê|ñ}ë|ñ}ï}Ô}0PK%47¡²¶¢©vpxMck!»»»» ((HUY­¿ÁMnp/0?@WXno|}y{ffHI ..:PS1CB3=BMU] ((»½­GiY+F9»»»»»»»»®¸ºLWZ                  ¬±ITV» ¢ZdgT^`QZ^»ÑÒSNK|~»   {`oo¢ª§Ô×ÖbddOQSHLM2688<=>CHBGM   ipq»»p<CG4;=§«tpm}qql|prwxwiv|so~txrz8?AAFH»»»ml|n~qsl|&$" °»¾¡³¹©¤® ~¢}¡­ªlnq%#qpm}up~p~»k~   £¶¾¦²{xm~powuyvsqm~t{¨x~v}§®p¨°|©°~ol{rptoMXZ"()©¬vLSU{nz|ËÒÒ¿ÈÊ²½¿¤°²{055                !%&-35NZ\zgtv-34.34388 ¡»%(^qu!']â|ñ}Õ{J<Ìvï}ï} Îz&A>Rdh¢²·¢zsH]d!%»»»» ((X`hvª¬¡£0155GG\\	lmuvy{y{
tumm_aMN99--Hbd0?AAKPH\`(,0»¤Æ¶Km^0K>»»»»»»»»·ÄÆQ]_                  ©­DPR»¢¥]gjgtxMVX»ÔÕV^Ivx»   ryyÉÍÏ ¡$%%Z_`CGG5998=@<DGFLL   agi»»p`msrhvzpol{trumx}p~mx}vlx}ppn|o~ojsup~»»»ottpm|~sdru;FE®¹¼¥­¨±p|zupd{"-.euymmoosu»m   ¥¸À wvi|q} ¤k}qpm}vo}£}{~¤w¥¤ ¡||}uqm}Q]^¥yKRS¡£kwy ¢ÅÍÎ¾ÈÊ§´¶¥¨¢¥doq@DE
 #%(--FQRo|OY\$*+>DEDIK©«»"% 8HK!"*iÎx.JEAQT;SRÅtñ}í}Ìy%D?O`g­µ£¨oKbj »»»» ((PX`jqxª½¿Hfg--57GGUU^`ab^`XZOQDE77 ++?XXG[a0;>HQXX`h$ »£ÆµTvg0K>»»»»»»»»«·¹MY[                  ¨­AJM»[ej`lpKSV»ÎÎTXGsu»   jmq·¼¾ÍÏÏKOOTWXX]]BEF:>@9?BDLPJQQ   Z`b»»pp7?DFQU¥©xjzrqstuttn}vvn}qpn|l|EMQ*/0o~»»»ptvn|qly|m|Xeg	eqt¹ÅÉ¡¡§t©rl:JM
[hkvk{nytq~lx|»x   ¤¬¥±¬µ¦znvs||¢ª|k{vwt~z}~|ª°x} §¢£ wm~dsxyn}Q[]®´vLRT«­tp|~ÈÐÒ¿ÈÉ«®\gi9=?$%%!179KVWkwy~{u6=>078S[]FLN§©»"&¬±­°¦©2BG !53Xkp4BE 22¾rï}ï}Ý| TBEX^­µyPho"»»»» ((PTXXd`{§§´´?Z\,,12:<DEEFCD>>5500**7SV^rv.?C7DJP\`HPP($(»À°EfW,F:»»»»»»»»®¼¾M[^                  ¦«NY]»^ilT^bPZ^»ÌÌWNK|~»   VadsvzÉÍÏ¥§§,.-9<<^abMRR?BF9?B@FIRYYMTT   UZ]»»m|rWek!"iuy¤qptn}p~wwqn}s|pto~l{}drtbjmtt»»»stsyivyppl|BMN µÃÈª³¦­¸Àym}¬´VfkCPRtrpm}o~m|qo}»h{   ¬³£§²¹¨xt{¡z{stvxw}{¡¨£ z¢¤©sNYZ¯¶yQXY§©oz|®¹¼cmp{huwHPQ=CE%()%%#)*%*+ "#146GOPWbfw¡zPY\R\_ertUcd/56JQRkuwNUW£¯±» #¢§£§ª}CUYQch¡¥z<NQ!22!½tð}í}Úy;5Ugm CW^"»»»» ((P``PX`Xaaz­±²µIij	--,,-.-.*+++)*+,FdfyHX^;GI=HLPX`PTX 0(»¡Å´Suf*E8»»»»»»»»ª·ºDPR                  «¯GPT»¦©huzZdgELO»ØÚ_ SBkl»   {V^^lxty¨­­ÒÕÕ,--244lprTYYAGG<BECHIPWWSccNX[   QWY»»m{~l{k|IV[&,.|pm}up~p~qo~u|ukyn}v158QYZtql|»»»utptn|m|~n|kx|t)321;;¬¹½¯¼Ã±»{¢¬y0;:*43jxzp~m|rjyk|ovkx|»v   §­¦®NZ^LX^¥wu¢£¨{x|ytz|¡¡ª¡¥£»½ ¦£stxJUXKVYª®{LWY¢dt{OUWtitv¡£ÁÈË©±²bln¦²´¡~cpsP[^MX[FPRT_aWab`kowµ»½^jm[gj079<CC^fgNTU¢®°»"%¨­®±£§¡¦¦©£¦¤5FI!55ÄsÝ|" g!:KOG[d"»»»» ((PTX088Xehy««¢¶¸~Hgi-LM1234,GIF_ciozAUVBGK000HTX((0»£ÅµPrc*E9»»»»»»»»©²µKUY                  ¦¶¹MX[»^iljx|JRV»ÆÇW` £Frt»   {V^^[fgitx}©®®ÌÏÏ¨¬¬LNNJMMz~`eeKOPBHHJNQLVS[cjVbfOUU   MSU»»l{oo~l}BLO'-/r~¨­sosutsqo~o}w{046KRUo~wtt»»»sp|sly}tn|zkx|vl{~'20½ÉÍ§­~u"-,hwyp}m{}m{~m|l}ok}qm{»l}    ³¹­µIUX{DPU£|}|wt¢«|||}|¤¥£¥¶¾£ ¤}zzLTYhw}}OZ\©®R_b£ªxOUW©«|p{}jwzÒÖØ¿ÆÉª´·©µ¸¦³¶±¼¾¢¤£§¡£¢¤ ¦¨¨±²¶½¾u>GIAIKT[\luwX_a«­»$(®³©¬¢¥¬°£ ¤©9IN#A;(\ "2BGznVmw"»»»» ((P\`ÀÀÀ088HXXWehouu ¯¯®±®ÁÃ­ÀÂ­ÁÁ¢´´¥¥¡¡vM^_J[[P``ÀÄÈ088P\`$ »Á°No_0J>»»»»»»»»®¹¼LWZ                  ©­KUX» ¢`jnLSUPX[»ÑÒXHstKz{»   {VZ^FVV^gjgvvyª¬®ÈËËÊËÍgkk566677UY[}twwKPQBIKKOQKQRU`d^bfVfnQX_   Z`b»»lz}lz~pppGQS:BF¥±µ¤uvpr[ceU_bvtpt|»»»qtp~qsqn|viv{qYeh	ITU¯º¾¥r3@A
dsum|p~qk{opl}n~o|p»p   ¯¶¤IUX±·qCMS­´£§­¦¬¥©¡¨v|¤­¢~{ ¦«¬¦«­±§½Á­®£~stJUY^kpiz~?HJª¯BKN
¦m~T[\¤¦xo{}iwy¢¥®¶¸ÉÐÒµ¿Á¾ÈÉ²¼¿¬·¹©´·¤®±£¦¥¨ ¬®¡£¡¡¤£¦y<DF8ABHOPQY[vNUV¦²´» $±µ¡¥£¦ ®±©¬«¯¡§¢§7GI!1ADyqTis#'»»»» ((HPPHTXPX`PX`XdhHUYaiohru¢¥¥gqtHQQP\`HTXP``PX`PTXHX`(,0»¡Ã²GhX.I<»»»»»»»»®º½ENR                  £²·HRT»¢«­epu^gkNVZ»Þß\WIwz»   {V^^>>>Ydboyv{¶¼¾ÃÈÆÄÆÇÎÑÔ¸¼¼¹½½ÀÁÃº½½jruRWWKQQGNNNUUZfiVb^>>>QW^   QWY»»p~lz}k{}l{~ptNY]%*-HPTfpu £¦©r|~LTW!"%+,Vchsuqtn|p~»»»n{~vn|lx|p|ttwpl{~wS`buµÃÈVdhS_am{ro|sssk{nwqs»    ¦¹ÁfvzKVZKW\k|²¸¦¯} ¤¤ª¨±x~¥¡¬² | ££¨ ³· ¤qEOT;DGR]`z<FH¥k{OUW©«hqsU\^xvo{~¶¿ÁÐÖØÉÑÒ¼ÆÇºÄÆ©µ¸dprp}§©©¬«®ª­¤§`kn=FHBJLU]^W_`_ghU\]OUW«­»" ²·¡¦ ¥©­t©¬¢¥®²¨¬§«{¢^qucw|¡¦¢Qfl#&»»»» ((¤¨ p ((»À°Kl\1L?»»»»»»»»¯¼¾ENR                  ¯ÃÇKUX»¡juz`lpEMP»ÐÐ` XBlm»   {VZ^ÎÒÖ>FFVb^^bfdkkalps}¥ªª°··±³µª±³lvzgmuWeeX__OYVYaaVcd]be^bfÎÒÖ>FFKRR   QVY»»m{m}lz}o}jxzp~m|rT`e=GJ!#
'--JSW\inpqptqso~t»»»jx{lz|jxzp~pm|wxttsw;FF"+*v)20:FEttrsto~rpl}rtx»~	
hx{§«¢¨°·z ¥¢  ¨­ §¢¦¬£  ¥«¡¥©£«®¨¬£§«©± ©¤®tgv|^ns9BE¡¬ds|IQR¨ª´»½clnwp|}htv¶¿ÁËÓÔÉÐÒ¥²µËÑÔ¸ÀÁhtu«¶¸©´¶§²¶|NXZ=DFBJLX`bt~s~´»½oxzRZ[¢®°»!$fz±¶¡¦¨¬v ¤¤§¡¤¡¦©¡¥ª}|}¢vBUZ#'»»»» (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( (( ((»©Ì»No_5QC»»»»»»»»¯½Áeuz:DD>GI!&(6>@JUWMY[»¡£yW`dNW[»ÒÓl®±QIx{»   W[_NV^^ffV^^VZ^V^^^ffZfjW__krzknrkrrxqxxVbf^bf]flZ`bVb`WefVb^^bfVb^V^^Vb^V^^   SY[»»qtm{l{}p}m{}m{~m|l}ok}qm{p}sstuuo}vqotn|»»»spt{n|sstpvvss"+( !*(qxrmzujy~ix~prm~tsx»|;DGesw«¯©­±µ¦¹¼­²©¯¢¦ª®­³¤©ª­©­®³¨­®³¯µ¡²º©®¤ª£© °´°¶ ²¸ª°­³¡³¹­°­±¤³¶­ÃÆ ³¸¤¶»¤·¿¥­§ºÁ¡©¦hv}N[`)04wds{OWX£¯±~zwyoz}itwhtx©«¡­¯³½¿ËÐÑ¥¦rPZ^OZ\ENPHPRdmoluw}X_a§©»JX["%j§º¾¤·¼¦«­±²¶¤¨¯³¨«§«§«¥¨¦¨¬¯¦¬~^t{8LQ "»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»¿®Lm^2N@»»»»»»»»«º½uhy~AJMDMP>GIEPRn|JUW»r|R\`»ÈÈr´¶g¥¨M~»   ²¸· £{{n|}{{{{{{{t~|   W^_»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»m{}kx{stqm{~qswm|sxshvyjvyturjx|lz~iwzlz}k{pvwwu»xgw}Ygk7@DLX^[kqk{OVX¢¤¨ª ¡¢¤{vmx{ny|{~q}grugrumx{v¡­¯£¯±¢®°¢®°¡­¯U]^«­»`lnJY["#'!$$("% ##&(+*.+.*.*- #&)-1.2/3*-AMO»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» Ä³Oqa2OB»»»»»»»»ÉÒÔ©¬©µ¹©µº°¼¾¹ÅÉ±½À­·º¯º½»?EG8>@»=bcÊÌu»½7YZ»                                                                                    MRU»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»m|rhuxm|sjx{tlx|n|l{~stn|o|rpo|rl|rm|rprqusuu» {ix}^lqWcgN[]M[\P\_HSVMW\ITXGQUKV[CNPBMPEPS>HK=FJ@JN?HL;CI7AC@KM<FIAKOBLQDMQNZ^NY_@JM6>A7AC;DE:BE5=?7?B7>B2:<8@C8AD,3518;GSVaqxszKRSNUVLTUQXZOWXLTUZabELMLSUKRSLRTIPRHOP@GIGNOCJLCIK=DE@HI?FG@GI@FHAHIELMBIKHNPOWWKRSRXZX^`OWXRZ[U[]»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»pm|n}vjx{skx{sqm|n|p~n{~n|n|ly|rlz|qlz|qlz~iwztstrps»|wutiw|reqwrro}wpuoujyqxaqwft|rlzyvywuroqsrvzvrn}yosdrwcqvur        TRUEVISION-XFILE. //////////////////////////////////////////////////////////////////////////////
//
// Pandemic Studios
//


//
// Tool tip window class
//
ConfigureInterface()
{
  DefineControlType("Sys::ToolTip", "TipWindow")
  {
    Skin("Game::SolidClient");
    ColorGroup("Game::Text");
    Geometry("KeepVisible", "AutoSize");
    Size(16, 11);
    Pos(0, -20);
    Font("HeaderSmall");
    TextOffset(0, 4);
    Style("!DropShadow", "MultiLine");
    CreateControl("Panel", "Static")
    {
      Skin("Game::Panel");
      Geometry("ParentWidth", "ParentHeight", "HCentre", "VCentre");
      Style("Transparent");
      Size(-6, -6);

      CreateControl("RivetTL", "Static")
      {
        Pos(3, 3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetTR", "Static")
      {
        Geometry("Right");
        Pos(-3, 3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetBR", "Static")
      {
        Geometry("Bottom", "Right");
        Pos(-3, -3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }

      CreateControl("RivetBL", "Static")
      {
        Geometry("Bottom");
        Pos(3, -3);
        ColorGroup("Sys::Texture");
        Image("if_interface_game.tga", 63, 6, 2, 2);
        Size(2, 2);
      }
    }

  }
}
    
client.cfg8   Ì       if_game.cfg  ¹      if_game_abort.cfg½  Î      if_game_activate.cfg  f      if_game_ai.cfgñ  E      if_game_bonus.cfg6.        if_game_bonus.tgaI2  ,@      if_game_chat.cfgur  Ô
      if_game_code.cfgI}        if_game_colorgroups.cfgP  R      if_game_comms.cfg¢  p1      if_game_construction.cfg¸  *
      if_game_event.cfg<Â  x      if_game_facility.cfg´Ã  v      if_game_hud.cfg*Ñ  ]6      if_game_keybind.cfg °      if_game_mainmenu.cfg7 #      if_game_medalgoals.cfg88       if_game_messagewindow.cfgLT       if_game_minimap.cfgMX Ô	      if_game_mp3player.cfg!b B(      if_game_multiplayer.cfgc       if_game_options.cfg¨ ô      if_game_paused.cfgtÈ {      if_game_prereqdisplay.cfgïÉ       if_game_resourcewindow.cfgoÌ Ñ      if_game_restart.cfg@Õ 
      if_game_saveload.cfgNß 9      if_game_squadcontrol.cfg÷ '      if_game_templates.cfg® Æ      if_game_tommycd1.cfgt .      if_game_unitcontext.cfg¢ 5      if_game_unitdisplay.cfg× Q9      if_interfacealpha_game.tga(Ò ,      if_interface_bkgnd.tgaTÒ ,0      if_interface_game.tga ,      if_tipwindow.cfg¬   
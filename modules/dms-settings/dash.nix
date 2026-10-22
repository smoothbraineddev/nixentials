{ ... }:
{
  programs.dank-material-shell.settings = {
    dashTabs = [
      {
        enabled = true;
        id = "overview";
      }
      {
        enabled = true;
        id = "media";
      }
      {
        enabled = true;
        id = "wallpaper";
      }
      {
        enabled = true;
        id = "weather";
      }
      {
        enabled = true;
        id = "wellbeing";
      }
      {
        enabled = true;
        id = "notifications";
      }
    ];
    dashCards = [
      {
        col = 0;
        h = 1;
        id = "clock";
        row = 0;
        w = 2;
      }
      {
        col = 2;
        h = 1;
        id = "weather";
        row = 0;
        w = 1;
      }
      {
        col = 3;
        h = 6;
        id = "notifications";
        row = 0;
        w = 3;
      }
      {
        col = 0;
        h = 4;
        id = "calendar";
        row = 1;
        w = 3;
      }
      {
        col = 6;
        h = 2;
        id = "wellbeing";
        row = 4;
        w = 2;
      }
      {
        col = 0;
        h = 1;
        id = "media";
        row = 5;
        w = 3;
      }
      {
        col = 6;
        h = 1;
        id = "network";
        row = 0;
        w = 2;
      }
      {
        col = 6;
        h = 1;
        id = "cpu";
        row = 1;
        w = 2;
      }
      {
        col = 6;
        h = 1;
        id = "memory";
        row = 2;
        w = 2;
      }
      {
        col = 6;
        h = 1;
        id = "disk";
        row = 3;
        w = 2;
      }
    ];
    dashOptions = {
      calendar = {
        weekends = true;
      };
      clock = {
        seconds = false;
      };
      media = {
        artStyle = "circle";
        playerStyle = "material";
      };
      overview = {
        panelColumns = 8;
      };
      wallpaper = {
        panelRows = 5;
      };
      weather = {
        city = true;
        widgets = [
          {
            col = 0;
            graphics = true;
            h = 2;
            id = "conditions";
            row = 0;
            w = 2;
          }
          {
            col = 2;
            graphics = true;
            h = 2;
            id = "daily";
            row = 0;
            w = 2;
          }
          {
            col = 0;
            graphics = true;
            h = 2;
            id = "hourly";
            row = 2;
            w = 4;
          }
          {
            col = 1;
            graphics = true;
            h = 2;
            id = "humidity";
            row = 4;
            w = 1;
          }
          {
            col = 0;
            graphics = true;
            h = 2;
            id = "wind";
            row = 4;
            w = 1;
          }
          {
            col = 2;
            graphics = true;
            h = 2;
            id = "precipitation";
            row = 4;
            w = 1;
          }
          {
            col = 3;
            graphics = true;
            h = 2;
            id = "pressure";
            row = 4;
            w = 1;
          }
        ];
        panelColumns = 7;
      };
    };
  };
}

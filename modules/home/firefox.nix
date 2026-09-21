{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        # giới hạn content-process để giảm RAM so với Chromium
        "dom.ipc.processCount" = 2;
        # tắt tab khôi phục state nặng khi crash/restart
        "browser.sessionstore.restore_on_demand" = true;
        "browser.sessionstore.max_tabs_undo" = 25;
        # dừng background tab sau 1 phút
        "browser.tabs.unloadOnLowMemory" = true;
        # không telemetry/studies
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        # cách ứng xử tab mới: về new tab page
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      };
    };
  };
}
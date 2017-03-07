# Test ensures buildbot master comes up correctly and workers can connect

import ./make-test.nix ({ pkgs, lib, ... } : {
  name = "buildbot";

  nodes = {
    bbmaster = { config, pkgs, ... }: {
      services.buildbot-master = {
        enable = true;
        package = pkgs.buildbot-full;
        factorySteps = [
          "steps.Git(repourl='git://github.com/buildbot/pyflakes.git', mode='incremental')"
          "steps.ShellCommand(command=['trial', 'pyflakes'])"
        ];
        changeSource = [
          "changes.GitPoller('git://github.com/buildbot/pyflakes.git', workdir='gitpoller-workdir', branch='master', pollinterval=300)"
        ];
      };
      networking.firewall.allowedTCPPorts = [ 8010 8011 9989 ];
      environment.systemPackages = with pkgs; [ git buildbot-full ];
    };

    bbworker = { config, pkgs, ... }: {
      services.buildbot-worker = {
        enable = true;
        masterUrl = "bbmaster:9989";
      };
      environment.systemPackages = with pkgs; [ git buildbot-worker ];
    };
  };

  testScript = ''

    # Test start master and connect worker
    $bbmaster->waitForUnit("network-online.target");
    $bbmaster->waitForUnit("buildbot-master.service");
    $bbmaster->waitUntilSucceeds("curl -s --head http://bbmaster:8010") =~ /200 OK/;
    $bbworker->waitForUnit("network-online.target");
    $bbworker->execute("nc -z bbmaster 8010");
    $bbworker->execute("nc -z bbmaster 9989");
    $bbworker->waitForUnit("buildbot-worker.service");
    $bbworker->waitUntilSucceeds("curl -s --head http://bbmaster:8010") =~ /200 OK/;
    $bbworker->execute("tail -10 /home/bbworker/worker/twistd.log") =~ /started correctly/;

    # Test stop buildbot master and worker
    print($bbmaster->execute("systemctl -l --no-pager status buildbot-master"));
    $bbmaster->execute("systemctl -l --no-pager stop buildbot-master");
    $bbworker->fail("nc -z bbmaster 8010");
    $bbworker->fail("nc -z bbmaster 9989");
    print($bbworker->execute("systemctl -l --no-pager status buildbot-worker"));
    $bbworker->execute("systemctl -l --no-pager stop buildbot-worker");

    # Test buildbot daemon mode
    $bbmaster->execute("buildbot create-master /tmp");
    $bbmaster->execute("mv -fv /tmp/master.cfg.sample /tmp/master.cfg");
    $bbmaster->execute("sed -i 's/8010/8011/' /tmp/master.cfg");
    $bbmaster->execute("buildbot start /tmp");
    $bbworker->execute("nc -z bbmaster 8011");
    $bbworker->waitUntilSucceeds("curl -s --head http://bbmaster:8011") =~ /200 OK/;
    $bbmaster->execute("buildbot stop /tmp");
    $bbworker->fail("nc -z bbmaster 8011");

  '';

  meta.maintainers = with lib.maintainers; [ nand0p ];

})

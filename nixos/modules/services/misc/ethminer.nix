{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ethminer;
in

{

  ###### interface

  options = {

    services.ethminer = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable ethminer ether mining.";
      };

      recheckInterval = mkOption {
        type = types.int;
        default = 2000;
        description = "Time in milliseconds to farm recheck.";
      };

      toolkit = mkOption {
        type = types.enum [ "cuda" "opencl" ];
        default = "cuda";
        description = "Cuda or opencl toolkit.";
      };

      apiPort = mkOption {
        type = types.int;
        default = -3333;
        description = "Ethminer api port. minus sign puts api in read-only mode.";
      };

      wallet = mkOption {
        type = types.str;
        example = "0x0484A1EfB3C88B0C7dE21919D480fF51099c8113";
        description = "Ethereum wallet address.";
      };

      pool = mkOption {
        type = types.str;
        example = "eth-us-east1.nanopool.org";
        description = "Mining pool address.";
      };

      stratumPort = mkOption {
        type = types.port;
        default = 9999;
        description = "Stratum protocol tcp port.";
      };

      rig = mkOption {
        type = types.str;
        default = "mining-rig-name";
        description = "Mining rig name.";
      };

      registerMail = mkOption {
        type = types.str;
        example = "email%40example.org";
        description = "Url encoded email address to register with pool.";
      };

      maxPower = mkOption {
        type = types.int;
        default = 115;
        description = "Miner max watt usage.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.ethminer = {
      path = [ pkgs.cudatoolkit ];
      description = "ethminer ethereum mining service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStartPost = optional (cfg.toolkit == "cuda") "+${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi -pl ${toString cfg.maxPower}";
      };

      environment = {
        LD_LIBRARY_PATH = "${config.boot.kernelPackages.nvidia_x11}/lib";
      };

      script = ''
        ${pkgs.ethminer}/bin/.ethminer-wrapped \
          --farm-recheck ${toString cfg.recheckInterval} \
          --report-hashrate \
          --${cfg.toolkit} \
          --api-port ${toString cfg.apiPort} \
          --pool stratum1+tcp://${cfg.wallet}@${cfg.pool}:${toString cfg.stratumPort}/${cfg.rig}/${cfg.registerMail}
      '';

    };

  };

}

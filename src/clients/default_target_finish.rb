module Yast
  import 'Directory'
  import 'Mode'
  import 'SystemdTarget'

  class SystemdTargetFinish < Client

    module Target
      include SystemdTargetClass::BaseTargets
    end

    def initialize
      textdomain 'services-manager'
    end

    def call args
      function = args.shift.to_s
      Builtins.y2milestone "Starting systemd target finish"

      case function
        when "Info"  then info
        when "Write" then write
        else Builtins.y2error "Unknown function '#{function}'"
      end
    end

    def info
      {
        'steps' => 1,
        'title' => _('Saving default systemd target...'),
        'when'  => [ :installation, :live_installation, :update, :autoinst ]
      }
    end

    def write
      if Mode.update
        Builtins.y2milestone "Update mode, no need to set systemd target again.."
      else
        SystemdTarget.default_target = Target::MULTIUSER if SystemdTarget.default_target.empty?
        Builtins.y2milestone "Setting default target to #{SystemdTarget.default_target}"
        SystemdTarget.save
      end
    end
  end
  SystemdTargetFinish.new.call(WFM.Args)
end

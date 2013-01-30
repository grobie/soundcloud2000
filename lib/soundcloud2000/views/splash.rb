require_relative '../ui/view'

module Soundcloud2000
  module Views
    class Splash < UI::View
      CONTENT = %q{
                                         ohmmNNmmdyoo.
                                        dhMMMMMMMMMMMMMMMms-
                                   :m  .MMMMMMMMMMMMMMMMMMMMd-
                      .o`d:  o++./dMy  .MMMMMMMMMMMMMMMMMMMMMMd-
                    /y/M.Mo  MmdhMoMy  -MMMMMMMMMMMMMMMMMMMMMMMN-
                 .  +N+M-Ms  MNddMoMh /:MMMMMMMMMMMMMMMMMMMMMMMMN-
                hy  yMoM:My  MMddMsMd :oMMMMMMMMMMMMMMMMMMMMMMMMMMd
          _     dh  hMsM/Mh .MMdmMyMd /oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdhoo
    .  m  N   h:Nm  dMyM+Md DMMdNMyMm /MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMms.
   .m  M..M   NoMN  mMhMsMm dMMdMMhMN +MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN/
 d/MM  M/MM /oMhMM /MMdMyMN MMMdMMhMN /MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-
:MsMM  MsMM +MMNMM +MMmMhMM MMMdMMdMM +MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMy
/MyMM  MyMM +dMNMM dMMmMyMN dMMdMMdMM +oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMs
 N+MM  M+MM \+MdMM \NMhMoMm +MMdNMyMm \/MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm.
 \+-N  M-.M   MsNm  dMsM/Mh \MMdmMsMd  :MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMh.
    +  N  M   m+dy  +N+M-Ms  MmdhMoMy  .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNy:
               `:-  -/.+ +.  +: -+.o-   +/+oooooooooooooooooooooooooooo+/-


                            _      _                 _ ___   ___   ___   ___
                           | |    | |               | |__ \ / _ \ / _ \ / _ \
  ___  ___  _   _ _ __   __| | ___| | ___  _   _  __| |  ) | | | | | | | | | |
 / __|/ _ \| | | | '_ \ / _` |/ __| |/ _ \| | | |/ _` | / /| | | | | | | | | |
 \__ \ (_) | |_| | | | | (_| | (__| | (_) | |_| | (_| |/ /_| |_| | |_| | |_| |
 |___/\___/ \__,_|_| |_|\__,_|\___|_|\___/ \__,_|\__,_|____|\___/ \___/ \___/

                       Matthias Georgi and Tobias Schmidt
                         Music Hack Day Stockholm 2013
}

    protected

      def left
        (rect.width - lines.map(&:length).max) / 2
      end

      def top
        (rect.height - lines.size) / 2
      end

      def lines
        CONTENT.split("\n")
      end

      def draw
        0.upto(top) { line '' }
        lines.each do |row|
          with_color(:green) do
            line ' ' * left + row
          end
        end
      end

      def refresh
        super

        # show until any keypress
        @window.getch
      end

    end
  end
end

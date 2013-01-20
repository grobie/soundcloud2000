require_relative 'view'

module Soundcloud2000
  module UI
    class Splash < View
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
}

    protected

      def draw
        CONTENT.split("\n").each do |row|
          line row
        end
      end

      def refresh
        super
        @window.getch
      end

    end
  end
end

From: Karsten Wesser <wesserchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: fstab mount 0 Byte
Date: Fri, 05 Sep 2014 21:57:32 +0200
Message-ID: <540A15AC.3080306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hallo,

ich habe auf einer Raspberry Pi eine Cifs Freigabe in die fstab=20
geschrieben um Bilder und Videosequenzen zu einem Netzlaufwerk zu=20
senden. Die Freigabe funktioniert mit einem  Windows7 PC=20
(Ordnerfreigabe). Ich m=F6chte aber die Dateien auf dem Dateiserver ein=
es=20
Routers (Esybox803, Vodafone) speichern. Dort werden aber nur 0-Byte=20
Dateien angelegt obwohl ich Lese und Schreibfreigabe eingerichtet habe.=
=20
Mit Windows7 kann ich auch auf diese Freigabe schreiben.
Ich denke dass in der fstab etwas ver=E4ndert werden muss, komme aber=20
nicht weiter.



I can also try to write english if you don't understand me.

Thanks for your help!
Karsten Wesser


fstab:

proc            /proc           proc    defaults          0       0
/dev/mmcblk0p1  /boot           vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
# a swapfile is not a swap partition, so no using swapon|off from here=20
on, use  dphys-swapfile swap[on|off]  for that
//192.168.2.1/raspi /mnt/camshare  cifs=20
username=3Draspikw,password=3Draspikw,domain=3Dmeinnetz,iocharset=3Dutf=
8,file_mode=3D0777,dir_mode=3D0777=20
0  0

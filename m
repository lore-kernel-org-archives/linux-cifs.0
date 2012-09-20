From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: My changes to use socket callbacks have worked well enough to mount a
 Samba-SMB1-based File system
Date: Thu, 20 Sep 2012 15:49:07 -0700
Message-ID: <CACyXjPwp+dNPLk2TuUyeuuPrwqDZQcFV5W+RK6++fRaQsaEn+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Folks,

So, here is the evidence:

---------------------------------------------
[root@richards-centos62-01 cifs-2.6]# mount -t cifs richards-sw-01
/mnt -o unc=3D//richards-sw-01\\backup,ip=3D10.250.209.113,user=3Dadmin=
istrator,pass=3DSt0r@ge!
[root@richards-centos62-01 cifs-2.6]# df
=46ilesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vg_storage09-lv_root
                      52324100   5115200  44587460  11% /
tmpfs                  4097628         0   4097628   0% /dev/shm
/dev/sda1               508644     88730    394314  19% /boot
/dev/mapper/vg_storage09-lv_home
                     460511448  53195152 384264420  13% /home
richards-sw-01       160432112   2911480 157520632   2% /mnt
[root@richards-centos62-01 cifs-2.6]# ls /mnt/
[root@richards-centos62-01 cifs-2.6]#
----------------------------------------------

I need to clean up these changes and handle error cases and get it
working against a more recent tree ... but it is taking shape.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)

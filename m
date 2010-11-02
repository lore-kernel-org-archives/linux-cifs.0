From: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Tue, 02 Nov 2010 09:40:24 +0900
Message-ID: <4CCF5DF8.9030809@nttcom.co.jp>
References: <4CC65859.7040100@nttcom.co.jp> <4CC6642F.2040401@suse.de> <4CCA6FD3.4060907@nttcom.co.jp> <4CCA7177.40303@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CCA7177.40303-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thank you, Suresh.

I succeeded in building kernel and mount SAMBA share with mount.smb2.

However, it seems that mount.smb2 works as cifs client
(NOT works as SMB2 client).

Mount.smb2 doesn't offer to use SMB2 in it's SMB Negotiation Request.
(Payload is the same as that of mount.cifs .)

 From Windows Vista client, SMB2 works well, so server setting is valid=
=2E


Are there any mandatory settings (such as environment variables)
  to run mount.smb2 as SMB2 client?



"cifs" is displayed in File system type field of mount output.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  # mount.smb2 //server/share /mnt/smb2/ -o user=3Dxxxx,pass=3Dyyyy
  # mount
  ...
  //server/share on /mnt/smb2 type cifs (rw,mand)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Packet dump of SMB Negotioation packet of mount.smb2 is follow.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
IP6 Client.57486 > Server.445: Flags [P.], seq 1:83, ack 1, win 90,=20
options [nop,nop,TS val 5376161 ecr 758578309], length 82SMB PACKET:=20
SMBnegprot (REQUEST)
  0x0000:  6000 0000 0072 0640 2002 0192 0168 0001  `....r.@.....h..
  0x0010:  f6ce 46ff fe31 e4ca 2002 0192 0168 0001  ..F..1.......h..
  0x0020:  1aa9 05ff fec0 4fd1 e08e 01bd 2987 d46a  ......O.....)..j
  0x0030:  5e7d 0568 8018 005a d677 0000 0101 080a  ^}.h...Z.w......
  0x0040:  0052 08a1 2d36 fc85 0000 004e ff53 4d42  .R..-6.....N.SMB
  0x0050:  7200 0000 0000 01c0 0000 0000 0000 0000  r...............
  0x0060:  0000 0000 0000 6d5b 0000 0100 002b 0002  ......m[.....+..
  0x0070:  4c4d 312e 3258 3030 3200 024c 414e 4d41  LM1.2X002..LANMA
  0x0080:  4e32 2e31 0002 4e54 204c 4d20 302e 3132  N2.1..NT.LM.0.12
  0x0090:  0002 504f 5349 5820 3200                 ..POSIX.2.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



Thanks.


(2010/10/29 16:02), Suresh Jayaraman wrote:
>
> Just comment out the line
>
> obj-$(CONFIG_CIFS_COMMON)       +=3D cifs_common/
>
> in fs/Makefile and try. Seems Steve's fix is still missing in the smb=
2.git.
>
>


--=20
-------------------------------------
=E5=85=AB=E6=9C=A8 =E6=B8=85=E4=B9=8B=E4=BB=8B =EF=BC=88=E3=83=A4=E3=82=
=AE=E3=80=80=E3=82=B7=E3=83=B3=E3=83=8E=E3=82=B9=E3=82=B1=EF=BC=89
NTT=E3=82=B3=E3=83=A0=E3=82=A6=E3=82=A7=E3=82=A2=E6=A0=AA=E5=BC=8F=E4=BC=
=9A=E7=A4=BE
=E3=83=8D=E3=83=83=E3=83=88=E3=83=AF=E3=83=BC=E3=82=AF=E3=83=BB=E3=82=BD=
=E3=83=AA=E3=83=A5=E3=83=BC=E3=82=B7=E3=83=A7=E3=83=B3=E4=BA=8B=E6=A5=AD=
=E6=9C=AC=E9=83=A8
yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org
-------------------------------------

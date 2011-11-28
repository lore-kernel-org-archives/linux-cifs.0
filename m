From: Dan The Man <blammy8-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Occasional CIFS Errors with a Win 2003 Mount
Date: Mon, 28 Nov 2011 07:46:07 -0800 (PST)
Message-ID: <1322495167.9919.YahooMailNeo@web111014.mail.gq1.yahoo.com>
Reply-To: Dan The Man <blammy8-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We keep having issues accessing content on one of our Win 2003 servers.=
 We end up needing to restart the server.

Linux details:

Linux Version: Red Hat Enterprise Linux Server release 5.7 (Tikanga)

Kernel:2.6.18-274.7.1.el5

Output of /sbin/modinfo cifs:

filename:=A0=A0=A0=A0=A0=A0 /lib/modules/2.6.18-274.7.1.el5/kernel/fs/c=
ifs/cifs.ko
version:=A0=A0=A0=A0=A0=A0=A0 1.60RH
description:=A0=A0=A0 VFS to access servers complying with the SNIA CIF=
S Specification e.g. Samba and Windows
license:=A0=A0=A0=A0=A0=A0=A0 GPL
author:=A0=A0=A0=A0=A0=A0=A0=A0 Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:=A0=A0=A0=A0
 CB01A53173C481FE5E6FF69
depends:
vermagic:=A0=A0=A0=A0=A0=A0 2.6.18-274.7.1.el5 SMP mod_unload 686 REGPA=
RM 4KSTACKS gcc-4.1
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CIFSMaxBufSize:Network buffer size =
(not including header). Default: 16384 Range: 8192 to 130048 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_min_rcv:Network buffers in poo=
l. Default: 4 Range: 1 to 64 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_min_small:Small network buffer=
s in pool. Default: 30 Range: 2 to 256 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_max_pending:Simultaneous reque=
sts to server. Default: 50 Range: 2 to 256 (int)


/etc/fstab line:

//citpfile05.uwcx.net/apache/citpwebces004v=A0 /data/apache cifs=A0 use=
r,rw,credentials=3D/root/apache_cifs_credentials,uid=3D48,gid=3D48,file=
_mode=3D0755,dir_mode=3D0755



Errors:

Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 6536
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25973
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25988
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25914
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25896
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25968
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid
 25981
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25982
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25971
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25967
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25986
Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25991
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25979
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 26000
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to
 cmd 4 mid 25994
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 25985
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25980
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25975
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25974
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 25898
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25970
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 25965
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 25964
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25963
Nov 27 20:57:11 citpwebces004v
 kernel:=A0 CIFS VFS: Send error in Close =3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25972
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25966
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25943
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25256
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25997
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25960
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25639
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25931
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:11
 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd 4 mid 25959
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25594
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25287
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25955
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25956
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 25969
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25984
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25976
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov
 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd 16=
2 mid 25983
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 25978
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25977
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 26002
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 25796
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
46 mid 25915
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in read =
=3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25909
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 25957
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25958
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in
 Close =3D -11
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 25962
Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52227
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52228
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52229
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in read =
=3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52235
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D
 -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52221
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52187
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52053
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52161
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52224
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in read =
=3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52196
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid
 52204
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52222
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52207
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52223
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52160
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52182
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
46 mid 52244
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in read =
=3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid
 52232
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
46 mid 52188
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in read =
=3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52231
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 51858
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52022
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52249
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52256
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52253
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52156
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response
 for cmd 50 mid 52252
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52254
Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:21 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52270
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52275
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
46 mid 52272
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: Send error in read =
=3D -11
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 52171
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52263
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52250
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 52269
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS
 VFS: No response for cmd 162 mid 52040
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52260
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52246
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52230
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52133
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52052
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 51991
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52241
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52146
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52186
Nov 27
 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd 162 m=
id 52205
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52243
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52262
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52264
Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 52113
Nov 27 20:58:38 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 114 mid 52296
Nov 27 20:58:50 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 114 mid 52402
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected
 lookup error -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 114 mid 52668
Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: Unexpected
 lookup error -112
Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 46145
Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in read =
=3D -11
Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in read =
=3D -11
Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46997
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 47049
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid
 47058
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 47048
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46981
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46826
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46758
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46904
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 45209
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46906
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 47032
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46947
Nov 27 21:03:33 citpwebces004v kernel:=A0
 CIFS VFS: No response for cmd 162 mid 46912
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 44878
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46834
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 46898
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46903
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46896
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 47009
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 46819
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 46596
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 46820
Nov 27 21:03:33
 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 46741
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 47034
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 46833
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 47040
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 46932
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46866
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 47016
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 46988
Nov 27
 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close =3D -=
11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 47051
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 47050
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 47044
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 47026
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 47028
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 47046
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 47045
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid
 46941
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46663
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 46951
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 47017
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 47022
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 47020
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 41944
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 47037
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 50 mid 47039
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 162 mid 47038
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS
 VFS: No response for cmd 162 mid 47043
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to cmd =
4 mid 46850
Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Close=
 =3D -11
Nov 27 21:03:48 citpwebces004v kernel:=A0 CIFS VFS: No response for cmd=
 114 mid 47062
Nov 27 21:03:48 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112
Nov 27 21:03:48 citpwebces004v kernel:=A0 CIFS VFS: Unexpected lookup e=
rror -112

Thanks in advance for the help in resolving this.
-Dan

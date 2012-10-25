From: "Li, Mike" <Mike.Li-p4uxo6XH8FLYtjvyW6yDsg@public.gmane.org>
Subject: RE: mount.cifs 1.10 to mount share for windows 2008 R2
Date: Thu, 25 Oct 2012 15:52:15 +0000
Message-ID: <922A2A9451A38A49A39D9B2B2C41465C38F7AA40@KWAWNEXMBP002.corp.root.nasd.com>
References: <mailman.142.1351135138.413883.linux-cifs-client@lists.samba.org>
 <922A2A9451A38A49A39D9B2B2C41465C38F7A89D@KWAWNEXMBP002.corp.root.nasd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <922A2A9451A38A49A39D9B2B2C41465C38F7A89D-Ix8smZXprC3zEM4StB/8aAJNPb3QtMV0sHre07pBsdU@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I also tried going with port 445, and getting:

/root/mount.cifs //10.6.65.66/wwwlog$ /mnt/ny4wnwebtp033 -odom=3DEXT,us=
er=3DLiM2,port=3D445,sec=3Dntlmv2i; =20
Password:
mount error 22 =3D Invalid argument

11:46:09.729653 IP (tos 0x0, ttl  64, id 57474, offset 0, flags [DF], p=
roto: TCP (6), length: 60) 150.123.157.31.50075 > 10.6.65.66.microsoft-=
ds: S, cksum 0x271b (correct), 2967089806:2967089806(0) win 5840 <mss 1=
460,sackOK,timestamp 275173900 0,nop,wscale 5>
11:46:09.738708 IP (tos 0x28, ttl  62, id 0, offset 0, flags [DF], prot=
o: TCP (6), length: 60) 10.6.65.66.microsoft-ds > 150.123.157.31.50075:=
 S, cksum 0x8495 (correct), 4026420658:4026420658(0) ack 2967089807 win=
 5792 <mss 1432,sackOK,timestamp 920268344 275173900,nop,wscale 2>
11:46:09.738730 IP (tos 0x0, ttl  64, id 57475, offset 0, flags [DF], p=
roto: TCP (6), length: 52) 150.123.157.31.50075 > 10.6.65.66.microsoft-=
ds: ., cksum 0xc920 (correct), 1:1(0) ack 1 win 183 <nop,nop,timestamp =
275173909 920268344>
11:46:09.738830 IP (tos 0x0, ttl  64, id 57476, offset 0, flags [DF], p=
roto: TCP (6), length: 134) 150.123.157.31.50075 > 10.6.65.66.microsoft=
-ds: P 1:83(82) ack 1 win 183 <nop,nop,timestamp 275173909 920268344>
11:46:09.739294 IP (tos 0x28, ttl  62, id 25482, offset 0, flags [DF], =
proto: TCP (6), length: 52) 10.6.65.66.microsoft-ds > 150.123.157.31.50=
075: ., cksum 0xc3dc (correct), 1:1(0) ack 83 win 1448 <nop,nop,timesta=
mp 920268345 275173909>
11:46:09.749951 IP (tos 0x28, ttl  62, id 25484, offset 0, flags [DF], =
proto: TCP (6), length: 169) 10.6.65.66.microsoft-ds > 150.123.157.31.5=
0075: P 1:118(117) ack 83 win 1448 <nop,nop,timestamp 920268356 2751739=
09>
11:46:09.750005 IP (tos 0x0, ttl  64, id 57477, offset 0, flags [DF], p=
roto: TCP (6), length: 52) 150.123.157.31.50075 > 10.6.65.66.microsoft-=
ds: ., cksum 0xc841 (correct), 83:83(0) ack 118 win 183 <nop,nop,timest=
amp 275173921 920268356>
11:46:09.750053 IP (tos 0x0, ttl  64, id 57478, offset 0, flags [DF], p=
roto: TCP (6), length: 300) 150.123.157.31.50075 > 10.6.65.66.microsoft=
-ds: P 83:331(248) ack 118 win 183 <nop,nop,timestamp 275173921 9202683=
56>
11:46:09.760126 IP (tos 0x28, ttl  62, id 25486, offset 0, flags [DF], =
proto: TCP (6), length: 91) 10.6.65.66.microsoft-ds > 150.123.157.31.50=
075: P 118:157(39) ack 331 win 1716 <nop,nop,timestamp 920268366 275173=
921>
11:46:09.800471 IP (tos 0x0, ttl  64, id 57479, offset 0, flags [DF], p=
roto: TCP (6), length: 52) 150.123.157.31.50075 > 10.6.65.66.microsoft-=
ds: ., cksum 0xc6e6 (correct), 331:331(0) ack 157 win 183 <nop,nop,time=
stamp 275173971 920268366>
11:46:09.888773 IP (tos 0x0, ttl  64, id 57480, offset 0, flags [DF], p=
roto: TCP (6), length: 52) 150.123.157.31.50075 > 10.6.65.66.microsoft-=
ds: F, cksum 0xc68d (correct), 331:331(0) ack 157 win 183 <nop,nop,time=
stamp 275174059 920268366>
11:46:09.899433 IP (tos 0x28, ttl  62, id 25488, offset 0, flags [DF], =
proto: TCP (6), length: 52) 10.6.65.66.microsoft-ds > 150.123.157.31.50=
075: F, cksum 0xc005 (correct), 157:157(0) ack 332 win 1716 <nop,nop,ti=
mestamp 920268504 275174059>
11:46:09.899440 IP (tos 0x0, ttl  64, id 57481, offset 0, flags [DF], p=
roto: TCP (6), length: 52) 150.123.157.31.50075 > 10.6.65.66.microsoft-=
ds: ., cksum 0xc5f7 (correct), 332:332(0) ack 158 win 183 <nop,nop,time=
stamp 275174070 920268504>


-----Original Message-----
=46rom: Li, Mike=20
Sent: Thursday, October 25, 2012 10:48 AM
To: 'linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
Subject: mount.cifs 1.10 to mount share for windows 2008 R2

Hi,

Tried to mount a share from  windows 2008 R2 on Linux 2.6.19-1.2895.fc6=
, but have been not successful.=20
Not sure why I'm getting "NBT SessionReject" from the win2008 server. I=
s there any registry update needed or a newer version of mount.cifs?
Please help. Thanks.

My version of mount.cifs is 1.10. Not sure if there is a newer version.
       sec=3D   Security mode. Allowed values are:

              =C2.  none attempt to connection as a null user (no name)

              =C2.  krb5 Use Kerberos version 5 authentication

              =C2.  krb5i Use Kerberos authentication and packet signin=
g

              =C2.  ntlm Use NTLM password hashing (default)

              =C2.  ntlmi   Use   NTLM   password   hashing   with   si=
gning  (if
                 /proc/fs/cifs/PacketSigningEnabled on or if  server  r=
equires
                 signing also can be the default)

              =C2.  ntlmv2 Use NTLMv2 password hashing

              =C2.  ntlmv2i Use NTLMv2 password hashing with packet sig=
ning

              [NB This [sec parameter] is under development and expecte=
d to be
              available in cifs kernel module 1.40 and later]


# /root/mount.cifs //10.6.65.66/wwwlog$ /mnt/ny4wnwebtp033 -odom=3DEXT,=
LiM2,sec=3Dntlmv2i,port=3D139
mount error 112 =3D Host is down
# /root/mount.cifs //10.6.65.66/wwwlog$ /mnt/ny4wnwebtp033 -odom=3DEXT,=
user=3DLiM2,sec=3Dkrb5,port=3D139;
Password:
mount error 112 =3D Host is down
Refer to the mount.cifs(8) manual page (e.g.man mount.cifs)

tcpdump host 10.6.65.66 -n -vv
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 9=
6 bytes
16:08:00.714252 IP (tos 0x0, ttl  64, id 4663, offset 0, flags [DF], pr=
oto: TCP (6), length: 60) 150.123.157.31.56122 > 10.6.65.66.netbios-ssn=
: S, cksum 0x1f2f (correct), 1324558118:1324558118(0) win 5840 <mss 146=
0,sackOK,timestamp 204485905 0,nop,wscale 5>
16:08:00.729388 IP (tos 0x28, ttl  62, id 0, offset 0, flags [DF], prot=
o: TCP (6), length: 60) 10.6.65.66.netbios-ssn > 150.123.157.31.56122: =
S, cksum 0xc876 (correct), 2392791643:2392791643(0) ack 1324558119 win =
5792 <mss 1432,sackOK,timestamp 849574744 204485905,nop,wscale 2>
16:08:00.729396 IP (tos 0x0, ttl  64, id 4664, offset 0, flags [DF], pr=
oto: TCP (6), length: 52) 150.123.157.31.56122 > 10.6.65.66.netbios-ssn=
: ., cksum 0x0cfc (correct), 1:1(0) ack 1 win 183 <nop,nop,timestamp 20=
4485920 849574744>
16:08:00.729466 IP (tos 0x0, ttl  64, id 4665, offset 0, flags [DF], pr=
oto: TCP (6), length: 124) 150.123.157.31.56122 > 10.6.65.66.netbios-ss=
n: P 1:73(72) ack 1 win 183 <nop,nop,timestamp 204485920 849574744>
>>> NBT Session Packet
NBT Session Request
=46lags=3D0x0
Length=3D68 (0x44)
Destination=3D
WARNING: Short packet. Try increasing the snap length


16:08:00.729980 IP (tos 0x28, ttl  62, id 24837, offset 0, flags [DF], =
proto: TCP (6), length: 52) 10.6.65.66.netbios-ssn > 150.123.157.31.561=
22: ., cksum 0x07c2 (correct), 1:1(0) ack 73 win 1448 <nop,nop,timestam=
p 849574745 204485920>
16:08:00.730880 IP (tos 0x0, ttl  64, id 4666, offset 0, flags [DF], pr=
oto: TCP (6), length: 134) 150.123.157.31.56122 > 10.6.65.66.netbios-ss=
n: P 73:155(82) ack 1 win 183 <nop,nop,timestamp 204485922 849574745>
>>> NBT Session Packet
NBT Session Message
=46lags=3D0x0
Length=3D78 (0x4e)
WARNING: Short packet. Try increasing the snap length by 52

SMB PACKET: SMBnegprot (REQUEST)
SMB Command   =3D  0x72
Error class   =3D  0x0
Error code    =3D  0 (0x0)
=46lags1        =3D  0x0
=46lags2        =3D  0x1
Tree ID       =3D  0 (0x0)
Proc ID       =3D
WARNING: Short packet. Try increasing the snap length [|SMB]

16:08:00.731379 IP (tos 0x28, ttl  62, id 24839, offset 0, flags [DF], =
proto: TCP (6), length: 52) 10.6.65.66.netbios-ssn > 150.123.157.31.561=
22: ., cksum 0x076d (correct), 1:1(0) ack 155 win 1448 <nop,nop,timesta=
mp 849574746 204485922>
16:08:00.740412 IP (tos 0x28, ttl  62, id 24841, offset 0, flags [DF], =
proto: TCP (6), length: 57) 10.6.65.66.netbios-ssn > 150.123.157.31.561=
22: P, cksum 0x0255 (correct), 1:6(5) ack 155 win 1448 <nop,nop,timesta=
mp 849574755 204485922>
>>> NBT Session Packet
NBT SessionReject
=46lags=3D0x0
Length=3D1 (0x1)
Reason=3D0x82
Called name not present


16:08:00.740512 IP (tos 0x0, ttl  64, id 4667, offset 0, flags [DF], pr=
oto: TCP (6), length: 52) 150.123.157.31.56122 > 10.6.65.66.netbios-ssn=
: ., cksum 0x0c47 (correct), 155:155(0) ack 6 win 183 <nop,nop,timestam=
p 204485931 849574755>
16:08:00.747499 IP (tos 0x28, ttl  62, id 24843, offset 0, flags [DF], =
proto: TCP (6), length: 52) 10.6.65.66.netbios-ssn > 150.123.157.31.561=
22: F, cksum 0x074e (correct), 6:6(0) ack 155 win 1448 <nop,nop,timesta=
mp 849574762 204485931>
16:08:00.786870 IP (tos 0x0, ttl  64, id 4668, offset 0, flags [DF], pr=
oto: TCP (6), length: 52) 150.123.157.31.56122 > 10.6.65.66.netbios-ssn=
: ., cksum 0x0c10 (correct), 155:155(0) ack 7 win 183 <nop,nop,timestam=
p 204485978 849574762>
16:08:00.866869 IP (tos 0x0, ttl  64, id 4669, offset 0, flags [DF], pr=
oto: TCP (6), length: 52) 150.123.157.31.56122 > 10.6.65.66.netbios-ssn=
: R, cksum 0x0bbc (correct), 155:155(0) ack 7 win 183 <nop,nop,timestam=
p 204486058 849574762>


Confidentiality Notice:  This email, including attachments, may include=
 non-public, proprietary, confidential or legally privileged informatio=
n.  If you are not an intended recipient or an authorized agent of an i=
ntended recipient, you are hereby notified that any dissemination, dist=
ribution or copying of the information contained in or transmitted with=
 this e-mail is unauthorized and strictly prohibited.  If you have rece=
ived this email in error, please notify the sender by replying to this =
message and permanently delete this e-mail, its attachments, and any co=
pies of it immediately.  You should not retain, copy or use this e-mail=
 or any attachment for any purpose, nor disclose all or any part of the=
 contents to any other person. Thank you
=0D

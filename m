From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs 1.10 to mount share for windows 2008 R2
Date: Thu, 25 Oct 2012 15:02:38 -0500
Message-ID: <CADT32eKAkts3_T23t6CUDPOeVCAkA474jq_phZfryUwMV_mDzQ@mail.gmail.com>
References: <mailman.142.1351135138.413883.linux-cifs-client@lists.samba.org>
	<922A2A9451A38A49A39D9B2B2C41465C38F7A89D@KWAWNEXMBP002.corp.root.nasd.com>
	<922A2A9451A38A49A39D9B2B2C41465C38F7AA40@KWAWNEXMBP002.corp.root.nasd.com>
	<CADT32eJ9aiasV1Xn25y5mpSn=dhm1B4c9xc+EV0b7wFAv2AsMA@mail.gmail.com>
	<922A2A9451A38A49A39D9B2B2C41465C38F7AB87@KWAWNEXMBP002.corp.root.nasd.com>
	<CADT32eLLJko_DJXNE-6fu9r1d7_pfSAcJT0yWE_namVdWNKQkQ@mail.gmail.com>
	<922A2A9451A38A49A39D9B2B2C41465C38F7AF4B@KWAWNEXMBP002.corp.root.nasd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Li, Mike" <Mike.Li-p4uxo6XH8FLYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <922A2A9451A38A49A39D9B2B2C41465C38F7AF4B-Ix8smZXprC3zEM4StB/8aAJNPb3QtMV0sHre07pBsdU@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 25, 2012 at 2:13 PM, Li, Mike <Mike.Li-p4uxo6XH8FLYtjvyW6yDsg@public.gmane.org> wrote:
> Thanks Shirish. Worked with sec=3Dntlmv2i and 2 updates from the MS K=
B.
>
> Just for our info what is the latest version of mount.cifs?
> Man mount.cifs did not have sec=3Dntlmv2i as option

Mike, I think it is 5.7.


>
> -----Original Message-----
> From: Shirish Pargaonkar [mailto:shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, October 25, 2012 2:23 PM
> To: Li, Mike
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: mount.cifs 1.10 to mount share for windows 2008 R2
>
> On Thu, Oct 25, 2012 at 11:51 AM, Li, Mike <Mike.Li-p4uxo6XH8FLYtjvyW6yDsg@public.gmane.org> wrote:
>>
>> Thanks Shirish for reply and the KB. I added the key
>> AllowLegacySrvCall=3D1 and updated lmcompatibilitylevel from 4 to 3
>> /root/mount.cifs //10.6.65.66/wwwlog$ /mnt/ny4wnwebtp033
>> -odom=3DEXT,user=3DLiM2,sec=3Dntlmv2;
>
> Perhaps ntlmv2i might help if server mandates smb signing?
> A wireshark trace during this exchange would be helpful.
>
>> Password:
>> mount error 13 =3D Permission denied
>>
>>
>> 12:30:10.024515 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: S
>> 1463279188:1463279188(0) win 5840 <mss 1460,sackOK,timestamp 2778141=
20
>> 0,nop,wscale 5>
>> 12:30:10.039730 IP 10.6.65.66.microsoft-ds > 150.123.157.31.53669: S
>> 2511355381:2511355381(0) ack 1463279189 win 5792 <mss
>> 1432,sackOK,timestamp 922908730 277814120,nop,wscale 2>
>> 12:30:10.039746 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: .
>> ack 1 win 183 <nop,nop,timestamp 277814135 922908730>
>> 12:30:10.039779 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: P
>> 1:83(82) ack 1 win 183 <nop,nop,timestamp 277814135 922908730>
>> 12:30:10.040249 IP 10.6.65.66.microsoft-ds > 150.123.157.31.53669: .
>> ack 83 win 1448 <nop,nop,timestamp 922908730 277814135>
>> 12:30:10.050957 IP 10.6.65.66.microsoft-ds > 150.123.157.31.53669: P
>> 1:118(117) ack 83 win 1448 <nop,nop,timestamp 922908741 277814135>
>> 12:30:10.050978 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: .
>> ack 118 win 183 <nop,nop,timestamp 277814146 922908741>
>> 12:30:10.051013 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: P
>> 83:331(248) ack 118 win 183 <nop,nop,timestamp 277814146 922908741>
>> 12:30:10.062349 IP 10.6.65.66.microsoft-ds > 150.123.157.31.53669: P
>> 118:355(237) ack 331 win 1716 <nop,nop,timestamp 922908752 277814146=
>
>> 12:30:10.077153 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: P
>> 331:427(96) ack 355 win 216 <nop,nop,timestamp 277814172 922908752>
>> 12:30:10.086069 IP 10.6.65.66.microsoft-ds > 150.123.157.31.53669: P
>> 355:394(39) ack 427 win 1716 <nop,nop,timestamp 922908776 277814172>
>> 12:30:10.086262 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: P
>> 427:470(43) ack 394 win 216 <nop,nop,timestamp 277814181 922908776>
>> 12:30:10.095249 IP 10.6.65.66.microsoft-ds > 150.123.157.31.53669: P
>> 394:433(39) ack 470 win 1716 <nop,nop,timestamp 922908785 277814181>
>> 12:30:10.135767 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: .
>> ack 433 win 216 <nop,nop,timestamp 277814231 922908785>
>> 12:30:10.221774 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: F
>> 470:470(0) ack 433 win 216 <nop,nop,timestamp 277814317 922908785>
>> 12:30:10.231159 IP 10.6.65.66.microsoft-ds > 150.123.157.31.53669: F
>> 433:433(0) ack 471 win 1716 <nop,nop,timestamp 922908921 277814317>
>> 12:30:10.231176 IP 150.123.157.31.53669 > 10.6.65.66.microsoft-ds: .
>> ack 434 win 216 <nop,nop,timestamp 277814326 922908921>
>>
>> -----Original Message-----
>> From: Shirish Pargaonkar [mailto:shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Sent: Thursday, October 25, 2012 12:18 PM
>> To: Li, Mike
>> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: mount.cifs 1.10 to mount share for windows 2008 R2
>>
>> On Thu, Oct 25, 2012 at 10:52 AM, Li, Mike <Mike.Li-p4uxo6XH8FLYtjvyW6yDsg@public.gmane.org> wrote=
:
>>> I also tried going with port 445, and getting:
>>>
>>> /root/mount.cifs //10.6.65.66/wwwlog$ /mnt/ny4wnwebtp033
>>> -odom=3DEXT,user=3DLiM2,port=3D445,sec=3Dntlmv2i;
>>> Password:
>>> mount error 22 =3D Invalid argument
>>>
>>> 11:46:09.729653 IP (tos 0x0, ttl  64, id 57474, offset 0, flags [DF=
],
>>> proto: TCP (6), length: 60) 150.123.157.31.50075 >
>>> 10.6.65.66.microsoft-ds: S, cksum 0x271b (correct),
>>> 2967089806:2967089806(0) win 5840 <mss 1460,sackOK,timestamp
>>> 275173900 0,nop,wscale 5>
>>> 11:46:09.738708 IP (tos 0x28, ttl  62, id 0, offset 0, flags [DF],
>>> proto: TCP (6), length: 60) 10.6.65.66.microsoft-ds >
>>> 150.123.157.31.50075: S, cksum 0x8495 (correct),
>>> 4026420658:4026420658(0) ack 2967089807 win 5792 <mss
>>> 1432,sackOK,timestamp 920268344 275173900,nop,wscale 2>
>>> 11:46:09.738730 IP (tos 0x0, ttl  64, id 57475, offset 0, flags [DF=
],
>>> proto: TCP (6), length: 52) 150.123.157.31.50075 >
>>> 10.6.65.66.microsoft-ds: ., cksum 0xc920 (correct), 1:1(0) ack 1 wi=
n
>>> 183 <nop,nop,timestamp 275173909 920268344>
>>> 11:46:09.738830 IP (tos 0x0, ttl  64, id 57476, offset 0, flags [DF=
],
>>> proto: TCP (6), length: 134) 150.123.157.31.50075 >
>>> 10.6.65.66.microsoft-ds: P 1:83(82) ack 1 win 183 <nop,nop,timestam=
p
>>> 275173909 920268344>
>>> 11:46:09.739294 IP (tos 0x28, ttl  62, id 25482, offset 0, flags
>>> [DF],
>>> proto: TCP (6), length: 52) 10.6.65.66.microsoft-ds >
>>> 150.123.157.31.50075: ., cksum 0xc3dc (correct), 1:1(0) ack 83 win
>>> 1448 <nop,nop,timestamp 920268345 275173909>
>>> 11:46:09.749951 IP (tos 0x28, ttl  62, id 25484, offset 0, flags
>>> [DF],
>>> proto: TCP (6), length: 169) 10.6.65.66.microsoft-ds >
>>> 150.123.157.31.50075: P 1:118(117) ack 83 win 1448 <nop,nop,timesta=
mp
>>> 920268356 275173909>
>>> 11:46:09.750005 IP (tos 0x0, ttl  64, id 57477, offset 0, flags [DF=
],
>>> proto: TCP (6), length: 52) 150.123.157.31.50075 >
>>> 10.6.65.66.microsoft-ds: ., cksum 0xc841 (correct), 83:83(0) ack 11=
8
>>> win 183 <nop,nop,timestamp 275173921 920268356>
>>> 11:46:09.750053 IP (tos 0x0, ttl  64, id 57478, offset 0, flags [DF=
],
>>> proto: TCP (6), length: 300) 150.123.157.31.50075 >
>>> 10.6.65.66.microsoft-ds: P 83:331(248) ack 118 win 183
>>> <nop,nop,timestamp 275173921 920268356>
>>> 11:46:09.760126 IP (tos 0x28, ttl  62, id 25486, offset 0, flags
>>> [DF],
>>> proto: TCP (6), length: 91) 10.6.65.66.microsoft-ds >
>>> 150.123.157.31.50075: P 118:157(39) ack 331 win 1716
>>> <nop,nop,timestamp 920268366 275173921>
>>> 11:46:09.800471 IP (tos 0x0, ttl  64, id 57479, offset 0, flags [DF=
],
>>> proto: TCP (6), length: 52) 150.123.157.31.50075 >
>>> 10.6.65.66.microsoft-ds: ., cksum 0xc6e6 (correct), 331:331(0) ack
>>> 157 win 183 <nop,nop,timestamp 275173971 920268366>
>>> 11:46:09.888773 IP (tos 0x0, ttl  64, id 57480, offset 0, flags [DF=
],
>>> proto: TCP (6), length: 52) 150.123.157.31.50075 >
>>> 10.6.65.66.microsoft-ds: F, cksum 0xc68d (correct), 331:331(0) ack
>>> 157 win 183 <nop,nop,timestamp 275174059 920268366>
>>> 11:46:09.899433 IP (tos 0x28, ttl  62, id 25488, offset 0, flags
>>> [DF],
>>> proto: TCP (6), length: 52) 10.6.65.66.microsoft-ds >
>>> 150.123.157.31.50075: F, cksum 0xc005 (correct), 157:157(0) ack 332
>>> win 1716 <nop,nop,timestamp 920268504 275174059>
>>> 11:46:09.899440 IP (tos 0x0, ttl  64, id 57481, offset 0, flags [DF=
],
>>> proto: TCP (6), length: 52) 150.123.157.31.50075 >
>>> 10.6.65.66.microsoft-ds: ., cksum 0xc5f7 (correct), 332:332(0) ack
>>> 158 win 183 <nop,nop,timestamp 275174070 920268504>
>>>
>>>
>>> -----Original Message-----
>>> From: Li, Mike
>>> Sent: Thursday, October 25, 2012 10:48 AM
>>> To: 'linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
>>> Subject: mount.cifs 1.10 to mount share for windows 2008 R2
>>>
>>> Hi,
>>>
>>> Tried to mount a share from  windows 2008 R2 on Linux 2.6.19-1.2895=
=2Efc6, but have been not successful.
>>> Not sure why I'm getting "NBT SessionReject" from the win2008 serve=
r. Is there any registry update needed or a newer version of mount.cifs=
?
>>> Please help. Thanks.
>>>
>>> My version of mount.cifs is 1.10. Not sure if there is a newer vers=
ion.
>>>        sec=3D   Security mode. Allowed values are:
>>>
>>>               =C2.  none attempt to connection as a null user (no n=
ame)
>>>
>>>               =C2.  krb5 Use Kerberos version 5 authentication
>>>
>>>               =C2.  krb5i Use Kerberos authentication and packet
>>> signing
>>>
>>>               =C2.  ntlm Use NTLM password hashing (default)
>>>
>>>               =C2.  ntlmi   Use   NTLM   password   hashing   with =
  signing  (if
>>>                  /proc/fs/cifs/PacketSigningEnabled on or if  serve=
r  requires
>>>                  signing also can be the default)
>>>
>>>               =C2.  ntlmv2 Use NTLMv2 password hashing
>>>
>>>               =C2.  ntlmv2i Use NTLMv2 password hashing with packet
>>> signing
>>>
>>>               [NB This [sec parameter] is under development and exp=
ected to be
>>>               available in cifs kernel module 1.40 and later]
>>>
>>>
>>> # /root/mount.cifs //10.6.65.66/wwwlog$ /mnt/ny4wnwebtp033
>>> -odom=3DEXT,LiM2,sec=3Dntlmv2i,port=3D139
>>> mount error 112 =3D Host is down
>>> # /root/mount.cifs //10.6.65.66/wwwlog$ /mnt/ny4wnwebtp033
>>> -odom=3DEXT,user=3DLiM2,sec=3Dkrb5,port=3D139;
>>> Password:
>>> mount error 112 =3D Host is down
>>> Refer to the mount.cifs(8) manual page (e.g.man mount.cifs)
>>>
>>> tcpdump host 10.6.65.66 -n -vv
>>> tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture si=
ze
>>> 96 bytes
>>> 16:08:00.714252 IP (tos 0x0, ttl  64, id 4663, offset 0, flags [DF]=
,
>>> proto: TCP (6), length: 60) 150.123.157.31.56122 >
>>> 10.6.65.66.netbios-ssn: S, cksum 0x1f2f (correct),
>>> 1324558118:1324558118(0) win 5840 <mss 1460,sackOK,timestamp
>>> 204485905 0,nop,wscale 5>
>>> 16:08:00.729388 IP (tos 0x28, ttl  62, id 0, offset 0, flags [DF],
>>> proto: TCP (6), length: 60) 10.6.65.66.netbios-ssn >
>>> 150.123.157.31.56122: S, cksum 0xc876 (correct),
>>> 2392791643:2392791643(0) ack 1324558119 win 5792 <mss
>>> 1432,sackOK,timestamp 849574744 204485905,nop,wscale 2>
>>> 16:08:00.729396 IP (tos 0x0, ttl  64, id 4664, offset 0, flags [DF]=
,
>>> proto: TCP (6), length: 52) 150.123.157.31.56122 >
>>> 10.6.65.66.netbios-ssn: ., cksum 0x0cfc (correct), 1:1(0) ack 1 win
>>> 183 <nop,nop,timestamp 204485920 849574744>
>>> 16:08:00.729466 IP (tos 0x0, ttl  64, id 4665, offset 0, flags [DF]=
,
>>> proto: TCP (6), length: 124) 150.123.157.31.56122 >
>>> 10.6.65.66.netbios-ssn: P 1:73(72) ack 1 win 183 <nop,nop,timestamp
>>> 204485920 849574744>
>>>>>> NBT Session Packet
>>> NBT Session Request
>>> Flags=3D0x0
>>> Length=3D68 (0x44)
>>> Destination=3D
>>> WARNING: Short packet. Try increasing the snap length
>>>
>>>
>>> 16:08:00.729980 IP (tos 0x28, ttl  62, id 24837, offset 0, flags
>>> [DF],
>>> proto: TCP (6), length: 52) 10.6.65.66.netbios-ssn >
>>> 150.123.157.31.56122: ., cksum 0x07c2 (correct), 1:1(0) ack 73 win
>>> 1448 <nop,nop,timestamp 849574745 204485920>
>>> 16:08:00.730880 IP (tos 0x0, ttl  64, id 4666, offset 0, flags [DF]=
,
>>> proto: TCP (6), length: 134) 150.123.157.31.56122 >
>>> 10.6.65.66.netbios-ssn: P 73:155(82) ack 1 win 183 <nop,nop,timesta=
mp
>>> 204485922 849574745>
>>>>>> NBT Session Packet
>>> NBT Session Message
>>> Flags=3D0x0
>>> Length=3D78 (0x4e)
>>> WARNING: Short packet. Try increasing the snap length by 52
>>>
>>> SMB PACKET: SMBnegprot (REQUEST)
>>> SMB Command   =3D  0x72
>>> Error class   =3D  0x0
>>> Error code    =3D  0 (0x0)
>>> Flags1        =3D  0x0
>>> Flags2        =3D  0x1
>>> Tree ID       =3D  0 (0x0)
>>> Proc ID       =3D
>>> WARNING: Short packet. Try increasing the snap length [|SMB]
>>>
>>> 16:08:00.731379 IP (tos 0x28, ttl  62, id 24839, offset 0, flags
>>> [DF],
>>> proto: TCP (6), length: 52) 10.6.65.66.netbios-ssn >
>>> 150.123.157.31.56122: ., cksum 0x076d (correct), 1:1(0) ack 155 win
>>> 1448 <nop,nop,timestamp 849574746 204485922>
>>> 16:08:00.740412 IP (tos 0x28, ttl  62, id 24841, offset 0, flags
>>> [DF],
>>> proto: TCP (6), length: 57) 10.6.65.66.netbios-ssn >
>>> 150.123.157.31.56122: P, cksum 0x0255 (correct), 1:6(5) ack 155 win
>>> 1448 <nop,nop,timestamp 849574755 204485922>
>>>>>> NBT Session Packet
>>> NBT SessionReject
>>> Flags=3D0x0
>>> Length=3D1 (0x1)
>>> Reason=3D0x82
>>> Called name not present
>>>
>>>
>>> 16:08:00.740512 IP (tos 0x0, ttl  64, id 4667, offset 0, flags [DF]=
,
>>> proto: TCP (6), length: 52) 150.123.157.31.56122 >
>>> 10.6.65.66.netbios-ssn: ., cksum 0x0c47 (correct), 155:155(0) ack 6
>>> win 183 <nop,nop,timestamp 204485931 849574755>
>>> 16:08:00.747499 IP (tos 0x28, ttl  62, id 24843, offset 0, flags
>>> [DF],
>>> proto: TCP (6), length: 52) 10.6.65.66.netbios-ssn >
>>> 150.123.157.31.56122: F, cksum 0x074e (correct), 6:6(0) ack 155 win
>>> 1448 <nop,nop,timestamp 849574762 204485931>
>>> 16:08:00.786870 IP (tos 0x0, ttl  64, id 4668, offset 0, flags [DF]=
,
>>> proto: TCP (6), length: 52) 150.123.157.31.56122 >
>>> 10.6.65.66.netbios-ssn: ., cksum 0x0c10 (correct), 155:155(0) ack 7
>>> win 183 <nop,nop,timestamp 204485978 849574762>
>>> 16:08:00.866869 IP (tos 0x0, ttl  64, id 4669, offset 0, flags [DF]=
,
>>> proto: TCP (6), length: 52) 150.123.157.31.56122 >
>>> 10.6.65.66.netbios-ssn: R, cksum 0x0bbc (correct), 155:155(0) ack 7
>>> win 183 <nop,nop,timestamp 204486058 849574762>
>>>
>>>
>>> Confidentiality Notice:  This email, including attachments, may
>>> include non-public, proprietary, confidential or legally privileged
>>> information.  If you are not an intended recipient or an authorized
>>> agent of an intended recipient, you are hereby notified that any
>>> dissemination, distribution or copying of the information contained
>>> in or transmitted with this e-mail is unauthorized and strictly
>>> prohibited.  If you have received this email in error, please notif=
y
>>> the sender by replying to this message and permanently delete this
>>> e-mail, its attachments, and any copies of it immediately.  You
>>> should not retain, copy or use this e-mail or any attachment for an=
y
>>> purpose, nor disclose all or any part of the contents to any other =
person.
>>> Thank you
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordom=
o
>>> info at  http://vger.kernel.org/majordomo-info.html
>>
>> Perhaps the Windows 2008 server is missing this patch!
>>
>> http://support.microsoft.com/kb/957441/en-us
>>
>> Confidentiality Notice:  This email, including attachments, may
>> include non-public, proprietary, confidential or legally privileged
>> information.  If you are not an intended recipient or an authorized
>> agent of an intended recipient, you are hereby notified that any
>> dissemination, distribution or copying of the information contained =
in
>> or transmitted with this e-mail is unauthorized and strictly
>> prohibited.  If you have received this email in error, please notify
>> the sender by replying to this message and permanently delete this
>> e-mail, its attachments, and any copies of it immediately.  You shou=
ld
>> not retain, copy or use this e-mail or any attachment for any purpos=
e,
>> nor disclose all or any part of the contents to any other person.
>> Thank you
>>
>>
>
> Confidentiality Notice:  This email, including attachments, may inclu=
de non-public, proprietary, confidential or legally privileged informat=
ion.  If you are not an intended recipient or an authorized agent of an=
 intended recipient, you are hereby notified that any dissemination, di=
stribution or copying of the information contained in or transmitted wi=
th this e-mail is unauthorized and strictly prohibited.  If you have re=
ceived this email in error, please notify the sender by replying to thi=
s message and permanently delete this e-mail, its attachments, and any =
copies of it immediately.  You should not retain, copy or use this e-ma=
il or any attachment for any purpose, nor disclose all or any part of t=
he contents to any other person. Thank you
>
>

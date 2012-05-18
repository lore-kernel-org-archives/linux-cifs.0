From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu 12.04)
Date: Thu, 17 May 2012 23:27:15 -0500
Message-ID: <CADT32eJC5cm1KeyF0_bnRbXJiFjTP-iTpdUWcfo4uAoH91bifw@mail.gmail.com>
References: <B284DF0EE72EBA488F6C7ED035128BF5105B547675@AUSX7MCPS302.AMER.DELL.COM>
	<CADT32e+HONu1ABEyjbgeLQjEBCzMjc01FTewJoHsT1bWn7tkTg@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777B@AUSX7MCPS302.AMER.DELL.COM>
	<201205180302.45016.linux@kukkukk.com>
	<CADT32eJO=1zT5mXrjeH9SSTFHMcqY3Xt5o_abAZpez0erxb0wQ@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777D@AUSX7MCPS302.AMER.DELL.COM>
	<CADT32e+OuAfbFQ==AGBOOfhv7bX4XpvKGt6GN1NcxeEF+Zb5ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott_Purcell-8PEkshWhKlo@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+OuAfbFQ==AGBOOfhv7bX4XpvKGt6GN1NcxeEF+Zb5ZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 17, 2012 at 11:08 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, May 17, 2012 at 11:07 PM, =A0<Scott_Purcell-8PEkshWhKlo@public.gmane.org> wrote:
>> Hi all,
>>
>> I want to thank you for your help. =A0I will be in class tomorrow an=
d likely unable to test much, if at all. =A0I'll be able to re-engage w=
ith this problem on Monday. =A0My apologies for getting you all focused=
 on my problem just when I have to step away from it for a bit.
>>
>>
>>
>> Scott Purcell
>> Content Development: Linux, Virtualization, and Cloud Solutions
>> Dell | GSD Learning & Development
>> ________________________________________
>> From: Shirish Pargaonkar [shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Sent: Thursday, May 17, 2012 8:08 PM
>> To: G=FCnter Kukkukk
>> Cc: Purcell, Scott; samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
>> Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (=
Ubuntu 12.04)
>>
>> On Thu, May 17, 2012 at 8:02 PM, G=FCnter Kukkukk <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org=
> wrote:
>>> Am Donnerstag, 17. Mai 2012, 20:29:25 schrieb Scott_Purcell-AaCy+MCqJcQ@public.gmane.org=
m:
>>>> Modinfo reports:
>>>>
>>>> $ modinfo cifs
>>>> filename: =A0 =A0 =A0 /lib/modules/3.2.0-24-generic/kernel/fs/cifs=
/cifs.ko
>>>> version: =A0 =A0 =A0 =A01.76
>>>> description: =A0 =A0VFS to access servers complying with the SNIA =
CIFS
>>>> Specification e.g. Samba and Windows license: =A0 =A0 =A0 =A0GPL
>>>> author: =A0 =A0 =A0 =A0 Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>>> srcversion: =A0 =A0 B869252FD0961045466332F
>>>> depends:
>>>> intree: =A0 =A0 =A0 =A0 Y
>>>> vermagic: =A0 =A0 =A0 3.2.0-24-generic SMP mod_unload modversions
>>>> parm: =A0 =A0 =A0 =A0 =A0 CIFSMaxBufSize:Network buffer size (not =
including header).
>>>> Default: 16384 Range: 8192 to 130048 (int) parm:
>>>> cifs_min_rcv:Network buffers in pool. Default: 4 Range: 1 to 64 (i=
nt)
>>>> parm: =A0 =A0 =A0 =A0 =A0 cifs_min_small:Small network buffers in =
pool. Default: 30
>>>> Range: 2 to 256 (int) parm: =A0 =A0 =A0 =A0 =A0 cifs_max_pending:S=
imultaneous
>>>> requests to server. Default: 32767 Range: 2 to 32767. (int) parm:
>>>> =A0echo_retries:Number of echo attempts before giving up and recon=
necting
>>>> server. Default: 5. 0 means never reconnect. (ushort) parm:
>>>> enable_oplocks:Enable or disable oplocks (bool). Default:y/Y/1 (bo=
ol)
>>>>
>>>>
>>>>
>>>> Scott Purcell
>>>> Content Development: Linux, Virtualization, and Cloud Solutions
>>>> Dell | GSD Learning & Development
>>>> ________________________________________
>>>> From: Shirish Pargaonkar [shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>>>> Sent: Thursday, May 17, 2012 12:15 PM
>>>> To: Purcell, Scott
>>>> Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
>>>> Subject: Re: [Samba] Trouble with mount.cifs while smbclient works=
 (Ubuntu
>>>> 12.04)
>>>>
>>>> On Thu, May 17, 2012 at 11:38 AM, =A0<Scott_Purcell-8PEkshWhKlo@public.gmane.org> wrot=
e:
>>>> > Passing "sec=3Dntlmssp" did not help. =A0Nor did moving the opti=
ons prior to
>>>> > the device and mount-point specifications.
>>>> >
>>>> > I'm not comfortable sending a full tcpdump to the list whose mem=
bership I
>>>> > do not know (but I can send it directly to formal members of the=
 Samba
>>>> > team -- I see Gunter's name on the website. Shirish, are you on =
the team
>>>> > as well?) since it would reveal things about my network environm=
ent that
>>>> > our data security folks would not want revealed. =A0But I have p=
erformed
>>>> > such a capture -- are there specific things I should be looking =
for?
>>>>
>>>> I think your session setup is failing. =A0Basically what does nego=
tiate
>>>> protocol response
>>>> returns (capabilities etc.).
>>>> Also, what is the version of cifs module? (modinfo cifs =A0 comman=
d
>>>> would tell that)
>>>>
>>>> > --
>>> Hi Scott,
>>>
>>> just had a first look at your network trace:
>>> =A0- negprot =A0 =A0 ok
>>> =A0- sess_setup =A0ok
>>> =A0- treeconnect ok =A0(for shared tree and IPC$)
>>>
>>> Then cifs is doing a QUERY_PATH_INFO (query file all info (263))
>>> request on the shared tree (path =3D ""), which is failing with
>>> STATUS_ACCESS_DENIED.
>>>
>>> In a former post you used:
>>>
>>> $ sudo smbclient =A0//pc************.com/D******NAS2 -A /etc/.smb_c=
reds.txt
>>> Domain=3D[A*****S] OS=3D[EMC-SNAS:T5.6.50.205] Server=3D[NT1]
>>> smb: \> ls training/
>>> NT_STATUS_ACCESS_DENIED listing \training\
>>> smb: \> cd training
>>> smb: \training\> ls
>>> =A0. =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0DA =A0 =A0 =A0 =A00 =A0Tue Jan 10 13:17:11 2012
>>> =A0.. =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 DA =A0 =A0 =A0 =A00 =A0Thu Sep =A01 11:54:48 2011
>>> =A0Enterprise =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DA =A0=
 =A0 =A0 =A00 =A0Fri Oct 21 07:03:08 2011
>>> =A0enterprise_services_offering =A0 =A0 =A0 DA =A0 =A0 =A0 =A00 =A0=
Mon Jun 13 16:31:21 2011
>>> =A0Flash_Beta =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DA =A0=
 =A0 =A0 =A00 =A0Wed Apr 14 13:46:40 2010
>>> =A0Functions =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DA =
=A0 =A0 =A0 =A00 =A0Sat Feb 27 09:47:17 2010
>>> =A0GCSS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 DA =A0 =A0 =A0 =A00 =A0Wed Apr 14 13:46:49 2010
>>>
>>> After connect you do a "ls training/" and get access denied, but th=
en you
>>> cd into that subdir and "ls" is working.
>>> Do you _always_ see this behavior?
>>>
>>> When you use "ls" directly after connect, do you get some error?
>>>
>>> Cheers, G=FCnter
>>> --
>>> To unsubscribe from this list go to the following URL and read the
>>> instructions: =A0https://lists.samba.org/mailman/options/samba
>>
>> yes, I do not understand tree connect succeeding but query path info
>> failing on the very same share path.
>> The version of cifs module is 1.76 which is fairly recent.
>>
>> Regards,
>>
>> Shirish
>
> Perhaps you need an entry like this
>
> create =A0dns_resolver =A0 =A0* =A0 =A0 =A0 * =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /usr/sbin/cifs.upcall %k
>
> in file /etc/request-key.conf

This is strange.  Not sure if some bug has creeped in.

fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 23 with uid: 0
fs/cifs/connect.c: UNC: (null) ip: (null)
CIFS VFS: Connecting to DFS root not implemented yet
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D 23) rc =3D -22

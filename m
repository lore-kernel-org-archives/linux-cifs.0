From: Kong Li <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs failed with Mac OS X 10.7 (LION, Preview 4)
Date: Mon, 13 Jun 2011 17:07:57 -0700
Message-ID: <BANLkTikwsTH4B=WKtCxJrdVHqz1xTicBzw@mail.gmail.com>
References: <loom.20110613T211710-599@post.gmane.org>
	<BANLkTi=CKD9F2Msdxf587QQN+Z5e8_r7BQ@mail.gmail.com>
	<loom.20110613T222739-674@post.gmane.org>
	<BANLkTinPTPYgeUJom4jjCistSX+ndrBR9A@mail.gmail.com>
	<loom.20110614T001442-338@post.gmane.org>
	<BANLkTim_zT-y9aczu3kC1MdQe55mv=W4Ww@mail.gmail.com>
	<BANLkTimdeNdRYpf3WwTG7p19V2QRq07DyQ@mail.gmail.com>
	<BANLkTimwbU_TQNw6MRwOzMLgPdRircL4-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=90e6ba6e82be0f705004a5a0d480
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimwbU_TQNw6MRwOzMLgPdRircL4-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--90e6ba6e82be0f705004a5a0d480
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

mounting with "nounix,noserverino,sec=3Dntlmssp" fixed the empty output fro=
m "ls".
see enclosed trace from wireshark (running on Mac).

$ sudo /sbin/mount.cifs -v -o
user=3Dadministrator,pass=3DYYY,nounix,noserverino,sec=3Dntlmssp
//192.168.77.244/Misc mnt
mount.cifs kernel mount options:
ip=3D192.168.77.244,unc=3D\\192.168.77.244\Misc,nounix,noserverino,sec=3Dnt=
lmssp,ver=3D1,user=3Dadministrator,pass=3D********
$ ls mnt
me  rockandroll  test  us  you
$ ls mnt
me  rockandroll  test  us  you
$

Thanks.

Kong

On Mon, Jun 13, 2011 at 4:52 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Weird - two search requests are sent - level 261 and level 257, the
> former seems to be the problem. =C2=A0The trace shows that the server did
> respond with similar (identical?) lists of files (8) in both cases,
> but I expect that has trouble with generating server side inode
> numbers (unique identifiers for files) - can you try disabling use of
> server side inode numbers, for example
>
> "nounix,noserverino,sec=3Dntlmssp"
>
> On Mon, Jun 13, 2011 at 6:27 PM, Kong Li <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Steve,
>>
>> I have enclosed the trace from wireshark (running on mac).
>> /proc/fs/cifs/cifsFYI is set to 7.
>>
>> $ cat /proc/fs/cifs/cifsFYI
>> 7
>> $ sudo /sbin/mount.cifs -v -o
>> user=3Dadministrator,pass=3DYYY,nounix,sec=3Dntlmssp //192.168.77.244/Mi=
sc
>> mnt
>> mount.cifs kernel mount options:
>> ip=3D192.168.77.244,unc=3D\\192.168.77.244\Misc,nounix,sec=3Dntlmssp,ver=
=3D1,user=3Dadministrator,pass=3D********
>> $ ls mnt
>>
>> g$ ls mnt
>> me =C2=A0rockandroll =C2=A0test =C2=A0us =C2=A0you
>> $
>>
>> Any comment would be greatly appreciated.
>>
>> Thanks again.
>>
>> Kong
>>
>> On Mon, Jun 13, 2011 at 3:29 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>>> On Mon, Jun 13, 2011 at 5:16 PM, Kong <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>
>>>> mounting with "nounix,sec=3Dntlmssp" works!
>>>> However, the 1st "ls" does not return anything back until the 2nd "ls"=
 command.
>>>>
>>>> Do you think there is server-side bug? (which would not be surprising
>>>> since 10.7 is still "preview")
>>>
>>> Yes - probably, but hard to prove without a network trace of the
>>> server responses
>>> to the SMB Transaction2 FindFirst requests. =C2=A0 I am a little puzzle=
d why I don't
>>> see the "In FindFirst" debug message in the log (is /proc/fs/cifs/cifsF=
YI set to
>>> 3 or preferably 7?).
>>>
>>>
>>>> $ /sbin/mount.cifs -v -o user=3Dadministrator,pass=3DYYY,nounix,sec=3D=
ntlmssp
>>>> //192.168.77.244/Misc mnt
>>>> mount.cifs kernel mount options: ip=3D192.168.77.244,unc=3D\\192.168.7=
7.244\Misc,
>>>> nounix,sec=3Dntlmssp,ver=3D1,user=3Dadministrator,pass=3D********
>>>> $ ls mnt
>>>>
>>>> $ ls mnt
>>>> me =C2=A0rockandroll =C2=A0test =C2=A0us =C2=A0you
>>>>
>>>>
>>>> debug output:
>>>> [14359.414853] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c:
>>>> Devname: //192.168.77.244/Misc flags: 0
>>>> [14359.416284] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> CIFS VFS: in cifs_mount as Xid: 262 with uid: 0
>>>> [14359.416300] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> Username: administrator
>>>> [14359.416306] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> UNC: \\192.168.77.244\Misc ip: 192.168.77.244
>>>> [14359.416328] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> Socket created
>>>> [14359.416897] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
>>>> [14359.417936] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> CIFS VFS: in cifs_get_smb_ses as Xid: 263 with uid: 0
>>>> [14359.417941] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> Existing smb sess not found
>>>> [14359.417954] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> secFlags 0x80
>>>> [14359.417960] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> NTLMSSP only mechanism, enable extended security
>>>> [14359.417966] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 114
>>>> [14359.417970] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 82
>>>> [14359.418142] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> Demultiplex PID: 5409
>>>> [14359.418644] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0xd9
>>>> [14359.418684] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D114 mid=3D1 state=3D4
>>>> [14359.418696] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> Dialect: 2
>>>> [14359.418705] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>>>> OID len =3D 7 oid =3D 0x1 0x2 0x348 0xbb92
>>>> [14359.418712] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>>>> OID len =3D 7 oid =3D 0x1 0x2 0x348 0x1bb92
>>>> [14359.418718] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>>>> OID len =3D 6 oid =3D 0x1 0x2 0x2f0 0x2b
>>>> [14359.418724] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>>>> OID len =3D 7 oid =3D 0x1 0x3 0x6 0x1
>>>> [14359.418730] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>>>> OID len =3D 10 oid =3D 0x1 0x3 0x6 0x1
>>>> [14359.418736] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>>>> OID len =3D 7 oid =3D 0x1 0x3 0x5 0x1
>>>> [14359.418741] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>>>> OID len =3D 7 oid =3D 0x1 0x3 0x6 0x1
>>>> [14359.418748] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>>>> Need to call asn1_octets_decode() function for
>>>> not_defined_in_RFC4178@please_ignore
>>>> [14359.418753] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> Signing disabled
>>>> [14359.418763] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> negprot rc 0
>>>> [14359.418772] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> Security Mode: 0x3 Capabilities: 0x8080e2fc TimeAdjust: 0
>>>> [14359.418778] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> sess setup type 3
>>>> [14359.418789] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> ntlmssp session setup phase 1
>>>> [14359.418795] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 115
>>>> [14359.418798] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 210
>>>> [14359.460788] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0xf8
>>>> [14359.460825] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D115 mid=3D2 state=3D4
>>>> [14359.460831] Status code returned 0xc0000016
>>>> NT_STATUS_MORE_PROCESSING_REQUIRED
>>>> [14359.460837] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
>>>> Mapping smb error code 0xc0000016 to POSIX err -5
>>>> [14359.460841] /build/buildd/linux-2.6.38/fs/cifs/misc.c:
>>>> Null buffer passed to cifs_small_buf_release
>>>> [14359.460848] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> Guest login
>>>> [14359.460851] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> UID =3D 10
>>>> [14359.460855] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> bleft 86
>>>> [14359.460859] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> serverOS=3DDarwin
>>>> [14359.460865] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> serverNOS=3D@(#)PROGRAM:smbd =C2=A0PROJECT:smbx-102
>>>> [14359.460868] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> serverDomain=3D
>>>> [14359.460872] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> ssetup freeing small buf db8ab8c0
>>>> [14359.460878] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> ntlmssp session setup phase 3
>>>> [14359.460966] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 115
>>>> [14359.460970] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 396
>>>> [14359.486051] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0x86
>>>> [14359.486150] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D115 mid=3D3 state=3D4
>>>> [14359.486164] /build/buildd/linux-2.6.38/fs/cifs/misc.c:
>>>> Null buffer passed to cifs_small_buf_release
>>>> [14359.486177] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> UID =3D 10
>>>> [14359.486186] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> bleft 86
>>>> [14359.486201] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> serverOS=3DDarwin
>>>> [14359.486216] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> serverNOS=3D@(#)PROGRAM:smbd =C2=A0PROJECT:smbx-102
>>>> [14359.486227] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> serverDomain=3D
>>>> [14359.486239] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>>>> ssetup freeing small buf db8ab700
>>>> [14359.486271] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> CIFS Session Established successfully
>>>> [14359.486290] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> CIFS VFS: leaving cifs_get_smb_ses (xid =3D 263) rc =3D 0
>>>> [14359.486305] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> file mode: 0x1ed =C2=A0dir mode: 0x1ed
>>>> [14359.486322] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> CIFS VFS: in cifs_get_tcon as Xid: 264 with uid: 0
>>>> [14359.486349] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 117
>>>> [14359.486359] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 98
>>>> [14359.506870] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0x42
>>>> [14359.506963] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D117 mid=3D4 state=3D4
>>>> [14359.507000] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> disk share connection
>>>> [14359.507017] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> nativeFileSystem=3DNTFS
>>>> [14359.507027] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> Tcon flags: 0x0
>>>> [14359.507049] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> CIFS VFS: leaving cifs_get_tcon (xid =3D 264) rc =3D 0
>>>> [14359.507059] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> CIFS Tcon rc =3D 0
>>>> [14359.507072] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> In QFSDeviceInfo
>>>> [14359.507086] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 50
>>>> [14359.507096] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 72
>>>> [14359.507878] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0x44
>>>> [14359.507931] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D50 mid=3D5 state=3D4
>>>> [14359.507972] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> In QFSAttributeInfo
>>>> [14359.507986] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 50
>>>> [14359.507996] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 72
>>>> [14359.510754] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0x50
>>>> [14359.511016] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D50 mid=3D6 state=3D4
>>>> [14359.511048] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> Linux protocol extensions disabled
>>>> [14359.511070] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> CIFS VFS: leaving cifs_mount (xid =3D 262) rc =3D 0
>>>> [14359.511100] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>>>> CIFS VFS: in cifs_root_iget as Xid: 265 with uid: 0
>>>> [14359.511120] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>>>> Getting info on
>>>> [14359.511143] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 50
>>>> [14359.511153] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 78
>>>> [14359.512242] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0x90
>>>> [14359.512302] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D50 mid=3D7 state=3D4
>>>> [14359.512331] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> In GetSrvInodeNum for
>>>> [14359.512345] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 50
>>>> [14359.512355] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 78
>>>> [14359.514976] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0x48
>>>> [14359.515053] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D50 mid=3D8 state=3D4
>>>> [14359.515081] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>>>> looking for uniqueid=3D386428
>>>> [14359.515122] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>>>> cifs_revalidate_cache: revalidating inode 386428
>>>> [14359.515135] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>>>> cifs_revalidate_cache: inode 386428 is new
>>>> [14359.515149] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>>>> inode 0xdbda7d74 old_time=3D0 new_time=3D3514878
>>>> [14359.515174] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c:
>>>> export ops supported
>>>> [14360.542214] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> CIFS VFS: in cifs_lookup as Xid: 266 with uid: 1000
>>>> [14360.542236] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> parent inode =3D 0xdbda7d74 name is: .Trash and dentry =3D 0xde2b7b80
>>>> [14360.542252] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> NULL inode in lookup
>>>> [14360.542263] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> Full path: \.Trash inode =3D 0x =C2=A0(null)
>>>> [14360.542275] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>>>> Getting info on \.Trash
>>>> [14360.542298] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 50
>>>> [14360.542308] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 92
>>>> [14360.552637] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0x27
>>>> [14360.552671] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> invalid transact2 word count
>>>> [14360.558663] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D50 mid=3D9 state=3D4
>>>> [14360.558680] Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_N=
OT_FOUND
>>>> [14360.558694] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
>>>> Mapping smb error code 0xc0000034 to POSIX err -2
>>>> [14360.558716] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> Send error in QPathInfo =3D -2
>>>> [14360.558745] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> CIFS VFS: leaving cifs_lookup (xid =3D 266) rc =3D 0
>>>> [14360.558956] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> CIFS VFS: in cifs_lookup as Xid: 267 with uid: 1000
>>>> [14360.558972] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> parent inode =3D 0xdbda7d74 name is: .Trash-1000 and dentry =3D 0xde2b=
7e00
>>>> [14360.558986] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> NULL inode in lookup
>>>> [14360.558997] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> Full path: \.Trash-1000 inode =3D 0x =C2=A0(null)
>>>> [14360.559008] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>>>> Getting info on \.Trash-1000
>>>> [14360.559025] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> For smb_command 50
>>>> [14360.559035] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> Sending smb: =C2=A0total_len 102
>>>> [14360.561562] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> rfc1002 length 0x27
>>>> [14360.561602] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>>>> invalid transact2 word count
>>>> [14360.561678] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>>>> sync_mid_result: cmd=3D50 mid=3D10 state=3D4
>>>> [14360.561692] Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_N=
OT_FOUND
>>>> [14360.561705] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
>>>> Mapping smb error code 0xc0000034 to POSIX err -2
>>>> [14360.561722] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>>>> Send error in QPathInfo =3D -2
>>>> [14360.561743] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>>>> CIFS VFS: leaving cifs_lookup (xid =3D 267) rc =3D 0
>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" =
in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.htm=
l
>>>>
>>>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>>
>>
>
>
>
> --
> Thanks,
>
> Steve
>

--90e6ba6e82be0f705004a5a0d480
Content-Type: application/octet-stream; name=wireshark-smbx-noserverino
Content-Disposition: attachment; filename=wireshark-smbx-noserverino
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gow3c0ve0

1MOyoQIABAAAAAAAAAAAAP//AAABAAAAdaX2TaKiBwBKAAAASgAAAAAf80bJWQAbL7jhEggARQAA
PCyrQAA/BhMPwKgsvcCoTfTiuQG9XdKhxQAAAACgAjkIoScAAAIEBbQEAggKAFONbgAAAAABAwMF
daX2TSCjBwBOAAAATgAAAAAbL7jhEgAf80bJWQgARQAAQD/EQABABv7xwKhN9MCoLL0BveK5DR85
FV3SocawEv///DQAAAIEBbQBAwMDAQEICidWYycAU41uBAIAAHWl9k3dowcAQgAAAEIAAAAAH/NG
yVkAGy+44RIIAEUAADQsrEAAPwYTFsCoLL3AqE304rkBvV3SocYNHzkWgBAByTZuAAABAQgKAFON
bidWYyd1pfZNFaQHAEIAAABCAAAAABsvuOESAB/zRslZCABFAAA06PJAAEAGVc/AqE30wKgsvQG9
4rkNHzkWXdKhxoAQ///8KAAAAQEICidWYycAU41udaX2TbzABwCUAAAAlAAAAAAf80bJWQAbL7jh
EggARQAAhiytQAA/BhLDwKgsvcCoTfTiuQG9XdKhxg0fORaAGAHJFfoAAAEBCAoAU41wJ1ZjJwAA
AE7/U01CcgAAAAAAAcgAAAAAAAAAAAAAAAAAAPQcAAABAAArAAJMTTEuMlgwMDIAAkxBTk1BTjIu
MQACTlQgTE0gMC4xMgACUE9TSVggMgB1pfZN88AHAEIAAABCAAAAABsvuOESAB/zRslZCABFAAA0
DeVAAEAGMN3AqE30wKgsvQG94rkNHzkWXdKiGIAQ///8KAAAAQEICidWYy4AU41wdaX2TSPCBwAb
AQAAGwEAAAAbL7jhEgAf80bJWQgARQABDYPBQABABronwKhN9MCoLL0BveK5DR85Fl3SohiAGP//
/QEAAAEBCAonVmMuAFONcAAAANX/U01CcgAAAACAQcgAAAAAAAAAAAAAAAAAAPQcAAABABECAAdk
AAEAAABAAAAAAAAAAAAA/OKAgLcVjHz5KcwBAAAAkAAAAAAAAAAQAIAAAB/zRslZYH4GBisGAQUF
AqB0MHKgRDBCBgkqhkiC9xIBAgIGCSqGSIb3EgECAgYGKoVwKw4DBgYrBgEFBQ4GCisGAQQBgjcC
AgoGBisFAQUCBwYGKwYBBQIFoyowKKAmGyRub3RfZGVmaW5lZF9pbl9SRkM0MTc4QHBsZWFzZV9p
Z25vcmV1pfZND9IHAEIAAABCAAAAAB/zRslZABsvuOESCABFAAA0LK5AAD8GExTAqCy9wKhN9OK5
Ab1d0qIYDR8574AQAeo1GAAAAQEICgBTjXEnVmMudaX2TSPTBwAUAQAAFAEAAAAf80bJWQAbL7jh
EggARQABBiyvQAA/BhJBwKgsvcCoTfTiuQG9XdKiGA0fOe+AGAHqFsoAAAEBCAoAU41xJ1ZjLgAA
AM7/U01CcwAAAAAAAcgAAAAAAAAAAAAAAAAAAPQcAAACAAz/AAAAWEBkAAAAAAAAACAAAAAAANzA
gICTAE5UTE1TU1AAAQAAAAUCCKAAAAAAAAAAAAAAAAAAAAAAAEwAaQBuAHUAeAAgAHYAZQByAHMA
aQBvAG4AIAAyAC4ANgAuADMAOAAtADgALQBnAGUAbgBlAHIAaQBjAAAAQwBJAEYAUwAgAFYARgBT
ACAAQwBsAGkAZQBuAHQAIABmAG8AcgAgAEwAaQBuAHUAeAAAAHWl9k080wcAQgAAAEIAAAAAGy+4
4RIAH/NGyVkIAEUAADTF8kAAQAZ4z8CoTfTAqCy9Ab3iuQ0fOe9d0qLqgBD///woAAABAQgKJ1Zj
MgBTjXF1pfZN9GEKADoBAAA6AQAAABsvuOESAB/zRslZCABFAAEsT8VAAEAG7gTAqE30wKgsvQG9
4rkNHznvXdKi6oAY///9IAAAAQEICidWY9gAU41xAAAA9P9TTUJzFgAAwIBByAAAAAAAAAAAAAAA
AAAA9BwUAAIABP8AAAABAHIAyQBOVExNU1NQAAIAAAASABIAMAAAADWCiWAnXBr8bekpPQAAAAAA
AAAAMAAwAEIAAABIAE8AUwBUADcANwAyADQANAABABIASABPAFMAVAA3ADcAMgA0ADQAAgASAEgA
TwBTAFQANwA3ADIANAA0AAAAAAABRABhAHIAdwBpAG4AAABAACgAIwApAFAAUgBPAEcAUgBBAE0A
OgBzAG0AYgBkACAAIABQAFIATwBKAEUAQwBUADoAcwBtAGIAeAAtADEAMAAyAAAAAAB1pfZNz2YK
AM4BAADOAQAAAB/zRslZABsvuOESCABFAAHALLBAAD8GEYbAqCy9wKhN9OK5Ab1d0qLqDR8654AY
AgxIvgAAAQEICgBTjZsnVmPYAAABiP9TTUJzAAAAAAAByAAAAAAAAAAAAAAAAAAA9BwUAAMADP8A
AABYQGQAAAAAAAAA2gAAAAAA3MCAgE0BTlRMTVNTUAADAAAAAAAAAEAAAABcAFwAQAAAABIAEgCc
AAAAGgAaAK4AAAAAAAAAyAAAABAAEADKAAAABQKIoIhw+GD7NOjmF2iFBXZnQycBAQAAAAAAAAvG
IpAmKswBUSCs1I4w6BsAAAAAAQASAEgATwBTAFQANwA3ADIANAA0AAIAEgBIAE8AUwBUADcANwAy
ADQANAAAAAAASABPAFMAVAA3ADcAMgA0ADQAYQBkAG0AaQBuAGkAcwB0AHIAYQB0AG8AcgAAABkY
G/0YkPbHx/V/AbD0TpoATABpAG4AdQB4ACAAdgBlAHIAcwBpAG8AbgAgADIALgA2AC4AMwA4AC0A
OAAtAGcAZQBuAGUAcgBpAGMAAABDAEkARgBTACAAVgBGAFMAIABDAGwAaQBlAG4AdAAgAGYAbwBy
ACAATABpAG4AdQB4AAAAdaX2TRpnCgBCAAAAQgAAAAAbL7jhEgAf80bJWQgARQAANKWiQABABpkf
wKhN9MCoLL0BveK5DR86513SpHaAEP///CgAAAEBCAonVmPZAFONm3Wl9k1xiAsAyAAAAMgAAAAA
Gy+44RIAH/NGyVkIAEUAALrfkUAAQAZeqsCoTfTAqCy9Ab3iuQ0fOudd0qR2gBj///yuAAABAQgK
J1ZkIgBTjZsAAACC/1NNQnMAAAAAgEHIAAAAAAAAAAAAAAAAAAD0HBQAAwAE/wAAAAAAAABXAABE
AGEAcgB3AGkAbgAAAEAAKAAjACkAUABSAE8ARwBSAEEATQA6AHMAbQBiAGQAIAAgAFAAUgBPAEoA
RQBDAFQAOgBzAG0AYgB4AC0AMQAwADIAAAAAAHWl9k0ojAsApAAAAKQAAAAAH/NGyVkAGy+44RII
AEUAAJYssUAAPwYSr8CoLL3AqE304rkBvV3SpHYNHzttgBgCLS/NAAABAQgKAFONridWZCIAAABe
/1NNQnUAAAAAAAHAAAAAAAAAAAAAAAAAAAD0HBQABAAE/wAAAAgAAQAzAABcAFwAMQA5ADIALgAx
ADYAOAAuADcANwAuADIANAA0AFwATQBpAHMAYwAAAD8/Pz8/AHWl9k1xjAsAQgAAAEIAAAAAGy+4
4RIAH/NGyVkIAEUAADR3l0AAQAbHKsCoTfTAqCy9Ab3iuQ0fO21d0qTYgBD///woAAABAQgKJ1Zk
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
uA==
--90e6ba6e82be0f705004a5a0d480--

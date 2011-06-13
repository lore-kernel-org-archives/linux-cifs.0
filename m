From: Kong Li <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs failed with Mac OS X 10.7 (LION, Preview 4)
Date: Mon, 13 Jun 2011 16:27:51 -0700
Message-ID: <BANLkTimdeNdRYpf3WwTG7p19V2QRq07DyQ@mail.gmail.com>
References: <loom.20110613T211710-599@post.gmane.org>
	<BANLkTi=CKD9F2Msdxf587QQN+Z5e8_r7BQ@mail.gmail.com>
	<loom.20110613T222739-674@post.gmane.org>
	<BANLkTinPTPYgeUJom4jjCistSX+ndrBR9A@mail.gmail.com>
	<loom.20110614T001442-338@post.gmane.org>
	<BANLkTim_zT-y9aczu3kC1MdQe55mv=W4Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=90e6ba6e82bea7ed5504a5a044c4
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim_zT-y9aczu3kC1MdQe55mv=W4Ww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--90e6ba6e82bea7ed5504a5a044c4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Steve,

I have enclosed the trace from wireshark (running on mac).
/proc/fs/cifs/cifsFYI is set to 7.

$ cat /proc/fs/cifs/cifsFYI
7
$ sudo /sbin/mount.cifs -v -o
user=3Dadministrator,pass=3DYYY,nounix,sec=3Dntlmssp //192.168.77.244/Misc
mnt
mount.cifs kernel mount options:
ip=3D192.168.77.244,unc=3D\\192.168.77.244\Misc,nounix,sec=3Dntlmssp,ver=3D=
1,user=3Dadministrator,pass=3D********
$ ls mnt

g$ ls mnt
me  rockandroll  test  us  you
$

Any comment would be greatly appreciated.

Thanks again.

Kong

On Mon, Jun 13, 2011 at 3:29 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Jun 13, 2011 at 5:16 PM, Kong <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> mounting with "nounix,sec=3Dntlmssp" works!
>> However, the 1st "ls" does not return anything back until the 2nd "ls" c=
ommand.
>>
>> Do you think there is server-side bug? (which would not be surprising
>> since 10.7 is still "preview")
>
> Yes - probably, but hard to prove without a network trace of the
> server responses
> to the SMB Transaction2 FindFirst requests. =C2=A0 I am a little puzzled =
why I don't
> see the "In FindFirst" debug message in the log (is /proc/fs/cifs/cifsFYI=
 set to
> 3 or preferably 7?).
>
>
>> $ /sbin/mount.cifs -v -o user=3Dadministrator,pass=3DYYY,nounix,sec=3Dnt=
lmssp
>> //192.168.77.244/Misc mnt
>> mount.cifs kernel mount options: ip=3D192.168.77.244,unc=3D\\192.168.77.=
244\Misc,
>> nounix,sec=3Dntlmssp,ver=3D1,user=3Dadministrator,pass=3D********
>> $ ls mnt
>>
>> $ ls mnt
>> me =C2=A0rockandroll =C2=A0test =C2=A0us =C2=A0you
>>
>>
>> debug output:
>> [14359.414853] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c:
>> Devname: //192.168.77.244/Misc flags: 0
>> [14359.416284] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> CIFS VFS: in cifs_mount as Xid: 262 with uid: 0
>> [14359.416300] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> Username: administrator
>> [14359.416306] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> UNC: \\192.168.77.244\Misc ip: 192.168.77.244
>> [14359.416328] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> Socket created
>> [14359.416897] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
>> [14359.417936] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> CIFS VFS: in cifs_get_smb_ses as Xid: 263 with uid: 0
>> [14359.417941] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> Existing smb sess not found
>> [14359.417954] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> secFlags 0x80
>> [14359.417960] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> NTLMSSP only mechanism, enable extended security
>> [14359.417966] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 114
>> [14359.417970] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 82
>> [14359.418142] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> Demultiplex PID: 5409
>> [14359.418644] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0xd9
>> [14359.418684] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D114 mid=3D1 state=3D4
>> [14359.418696] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> Dialect: 2
>> [14359.418705] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>> OID len =3D 7 oid =3D 0x1 0x2 0x348 0xbb92
>> [14359.418712] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>> OID len =3D 7 oid =3D 0x1 0x2 0x348 0x1bb92
>> [14359.418718] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>> OID len =3D 6 oid =3D 0x1 0x2 0x2f0 0x2b
>> [14359.418724] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>> OID len =3D 7 oid =3D 0x1 0x3 0x6 0x1
>> [14359.418730] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>> OID len =3D 10 oid =3D 0x1 0x3 0x6 0x1
>> [14359.418736] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>> OID len =3D 7 oid =3D 0x1 0x3 0x5 0x1
>> [14359.418741] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>> OID len =3D 7 oid =3D 0x1 0x3 0x6 0x1
>> [14359.418748] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
>> Need to call asn1_octets_decode() function for
>> not_defined_in_RFC4178@please_ignore
>> [14359.418753] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> Signing disabled
>> [14359.418763] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> negprot rc 0
>> [14359.418772] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> Security Mode: 0x3 Capabilities: 0x8080e2fc TimeAdjust: 0
>> [14359.418778] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> sess setup type 3
>> [14359.418789] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> ntlmssp session setup phase 1
>> [14359.418795] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 115
>> [14359.418798] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 210
>> [14359.460788] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0xf8
>> [14359.460825] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D115 mid=3D2 state=3D4
>> [14359.460831] Status code returned 0xc0000016
>> NT_STATUS_MORE_PROCESSING_REQUIRED
>> [14359.460837] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
>> Mapping smb error code 0xc0000016 to POSIX err -5
>> [14359.460841] /build/buildd/linux-2.6.38/fs/cifs/misc.c:
>> Null buffer passed to cifs_small_buf_release
>> [14359.460848] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> Guest login
>> [14359.460851] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> UID =3D 10
>> [14359.460855] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> bleft 86
>> [14359.460859] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> serverOS=3DDarwin
>> [14359.460865] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> serverNOS=3D@(#)PROGRAM:smbd =C2=A0PROJECT:smbx-102
>> [14359.460868] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> serverDomain=3D
>> [14359.460872] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> ssetup freeing small buf db8ab8c0
>> [14359.460878] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> ntlmssp session setup phase 3
>> [14359.460966] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 115
>> [14359.460970] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 396
>> [14359.486051] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0x86
>> [14359.486150] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D115 mid=3D3 state=3D4
>> [14359.486164] /build/buildd/linux-2.6.38/fs/cifs/misc.c:
>> Null buffer passed to cifs_small_buf_release
>> [14359.486177] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> UID =3D 10
>> [14359.486186] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> bleft 86
>> [14359.486201] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> serverOS=3DDarwin
>> [14359.486216] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> serverNOS=3D@(#)PROGRAM:smbd =C2=A0PROJECT:smbx-102
>> [14359.486227] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> serverDomain=3D
>> [14359.486239] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
>> ssetup freeing small buf db8ab700
>> [14359.486271] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> CIFS Session Established successfully
>> [14359.486290] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> CIFS VFS: leaving cifs_get_smb_ses (xid =3D 263) rc =3D 0
>> [14359.486305] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> file mode: 0x1ed =C2=A0dir mode: 0x1ed
>> [14359.486322] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> CIFS VFS: in cifs_get_tcon as Xid: 264 with uid: 0
>> [14359.486349] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 117
>> [14359.486359] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 98
>> [14359.506870] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0x42
>> [14359.506963] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D117 mid=3D4 state=3D4
>> [14359.507000] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> disk share connection
>> [14359.507017] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> nativeFileSystem=3DNTFS
>> [14359.507027] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> Tcon flags: 0x0
>> [14359.507049] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> CIFS VFS: leaving cifs_get_tcon (xid =3D 264) rc =3D 0
>> [14359.507059] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> CIFS Tcon rc =3D 0
>> [14359.507072] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> In QFSDeviceInfo
>> [14359.507086] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 50
>> [14359.507096] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 72
>> [14359.507878] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0x44
>> [14359.507931] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D50 mid=3D5 state=3D4
>> [14359.507972] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> In QFSAttributeInfo
>> [14359.507986] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 50
>> [14359.507996] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 72
>> [14359.510754] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0x50
>> [14359.511016] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D50 mid=3D6 state=3D4
>> [14359.511048] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> Linux protocol extensions disabled
>> [14359.511070] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> CIFS VFS: leaving cifs_mount (xid =3D 262) rc =3D 0
>> [14359.511100] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>> CIFS VFS: in cifs_root_iget as Xid: 265 with uid: 0
>> [14359.511120] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>> Getting info on
>> [14359.511143] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 50
>> [14359.511153] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 78
>> [14359.512242] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0x90
>> [14359.512302] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D50 mid=3D7 state=3D4
>> [14359.512331] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> In GetSrvInodeNum for
>> [14359.512345] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 50
>> [14359.512355] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 78
>> [14359.514976] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0x48
>> [14359.515053] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D50 mid=3D8 state=3D4
>> [14359.515081] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>> looking for uniqueid=3D386428
>> [14359.515122] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>> cifs_revalidate_cache: revalidating inode 386428
>> [14359.515135] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>> cifs_revalidate_cache: inode 386428 is new
>> [14359.515149] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>> inode 0xdbda7d74 old_time=3D0 new_time=3D3514878
>> [14359.515174] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c:
>> export ops supported
>> [14360.542214] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> CIFS VFS: in cifs_lookup as Xid: 266 with uid: 1000
>> [14360.542236] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> parent inode =3D 0xdbda7d74 name is: .Trash and dentry =3D 0xde2b7b80
>> [14360.542252] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> NULL inode in lookup
>> [14360.542263] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> Full path: \.Trash inode =3D 0x =C2=A0(null)
>> [14360.542275] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>> Getting info on \.Trash
>> [14360.542298] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 50
>> [14360.542308] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 92
>> [14360.552637] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0x27
>> [14360.552671] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> invalid transact2 word count
>> [14360.558663] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D50 mid=3D9 state=3D4
>> [14360.558680] Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_NOT=
_FOUND
>> [14360.558694] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
>> Mapping smb error code 0xc0000034 to POSIX err -2
>> [14360.558716] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> Send error in QPathInfo =3D -2
>> [14360.558745] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> CIFS VFS: leaving cifs_lookup (xid =3D 266) rc =3D 0
>> [14360.558956] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> CIFS VFS: in cifs_lookup as Xid: 267 with uid: 1000
>> [14360.558972] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> parent inode =3D 0xdbda7d74 name is: .Trash-1000 and dentry =3D 0xde2b7e=
00
>> [14360.558986] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> NULL inode in lookup
>> [14360.558997] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> Full path: \.Trash-1000 inode =3D 0x =C2=A0(null)
>> [14360.559008] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
>> Getting info on \.Trash-1000
>> [14360.559025] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> For smb_command 50
>> [14360.559035] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> Sending smb: =C2=A0total_len 102
>> [14360.561562] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> rfc1002 length 0x27
>> [14360.561602] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
>> invalid transact2 word count
>> [14360.561678] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
>> sync_mid_result: cmd=3D50 mid=3D10 state=3D4
>> [14360.561692] Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_NOT=
_FOUND
>> [14360.561705] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
>> Mapping smb error code 0xc0000034 to POSIX err -2
>> [14360.561722] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
>> Send error in QPathInfo =3D -2
>> [14360.561743] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
>> CIFS VFS: leaving cifs_lookup (xid =3D 267) rc =3D 0
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Thanks,
>
> Steve
>

--90e6ba6e82bea7ed5504a5a044c4
Content-Type: application/octet-stream; name=wireshark-smbx
Content-Disposition: attachment; filename=wireshark-smbx
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gow1vwba0

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
AABYQGQAAAAAAAAA2gAAAAAA3MCAgE0BTlRMTVNTUAADAAAAAAAAAEAAAABcAFwAQAAAABIAEgCc
AAAAGgAaAK4AAAAAAAAAyAAAABAAEADKAAAABQKIoPQPb2yhQowyJYz1Ek6We6UBAQAAAAAAAELP
Jq0gKswBL9vLgyEeGk4AAAAAAQASAEgATwBTAFQANwA3ADIANAA0AAIAEgBIAE8AUwBUADcANwAy
ADQANAAAAAAASABPAFMAVAA3ADcAMgA0ADQAYQBkAG0AaQBuAGkAcwB0AHIAYQB0AG8AcgAAAN0x
J9cRBUthqtVhScz+s80ATABpAG4AdQB4ACAAdgBlAHIAcwBpAG8AbgAgADIALgA2AC4AMwA4AC0A
OAAtAGcAZQBuAGUAcgBpAGMAAABDAEkARgBTACAAVgBGAFMAIABDAGwAaQBlAG4AdAAgAGYAbwBy
ACAATABpAG4AdQB4AAAAlZv2TTJOBQBCAAAAQgAAAAAbL7jhEgAf80bJWQgARQAANIqgQABABrQh
wKhN9MCoLL0BvdrkSiGIWiJOF+iAEP///CgAAAEBCAonL9gGAEnokZWb9k1BkQYAyAAAAMgAAAAA
Gy+44RIAH/NGyVkIAEUAALpX80AAQAbmSMCoTfTAqCy9Ab3a5EohiFoiThfogBj///yuAAABAQgK
Jy/YWABJ6JEAAACC/1NNQnMAAAAAgEHIAAAAAAAAAAAAAAAAAAAAGxAAAwAE/wAAAAAAAABXAIVE
AGEAcgB3AGkAbgAAAEAAKAAjACkAUABSAE8ARwBSAEEATQA6AHMAbQBiAGQAIAAgAFAAUgBPAEoA
RQBDAFQAOgBzAG0AYgB4AC0AMQAwADIAAAAAAJWb9k2ElgYApAAAAKQAAAAAH/NGyVkAGy+44RII
AEUAAJb9dEAAPwZB68CoLL3AqE302uQBvSJOF+hKIYjggBgCLZ5DAAABAQgKAEnopicv2FgAAABe
/1NNQnUAAAAAAAHAAAAAAAAAAAAAAAAAAAAAGxAABAAE/wAAAAgAAQAzAABcAFwAMQA5ADIALgAx
ADYAOAAuADcANwAuADIANAA0AFwATQBpAHMAYwAAAD8/Pz8/AJWb9k3QlgYAQgAAAEIAAAAAGy+4
4RIAH/NGyVkIAEUAADQN5UAAQAYw3cCoTfTAqCy9Ab3a5EohiOAiThhKgBD///woAAABAQgKJy/Y
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
AAEBCAoASe+aJy/z6g==
--90e6ba6e82bea7ed5504a5a044c4--

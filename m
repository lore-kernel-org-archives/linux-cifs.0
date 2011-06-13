From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs failed with Mac OS X 10.7 (LION, Preview 4)
Date: Mon, 13 Jun 2011 17:29:27 -0500
Message-ID: <BANLkTim_zT-y9aczu3kC1MdQe55mv=W4Ww@mail.gmail.com>
References: <loom.20110613T211710-599@post.gmane.org>
	<BANLkTi=CKD9F2Msdxf587QQN+Z5e8_r7BQ@mail.gmail.com>
	<loom.20110613T222739-674@post.gmane.org>
	<BANLkTinPTPYgeUJom4jjCistSX+ndrBR9A@mail.gmail.com>
	<loom.20110614T001442-338@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kong <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110614T001442-338-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 13, 2011 at 5:16 PM, Kong <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> mounting with "nounix,sec=3Dntlmssp" works!
> However, the 1st "ls" does not return anything back until the 2nd "ls=
" command.
>
> Do you think there is server-side bug? (which would not be surprising
> since 10.7 is still "preview")

Yes - probably, but hard to prove without a network trace of the
server responses
to the SMB Transaction2 FindFirst requests.   I am a little puzzled why=
 I don't
see the "In FindFirst" debug message in the log (is /proc/fs/cifs/cifsF=
YI set to
3 or preferably 7?).


> $ /sbin/mount.cifs -v -o user=3Dadministrator,pass=3DYYY,nounix,sec=3D=
ntlmssp
> //192.168.77.244/Misc mnt
> mount.cifs kernel mount options: ip=3D192.168.77.244,unc=3D\\192.168.=
77.244\Misc,
> nounix,sec=3Dntlmssp,ver=3D1,user=3Dadministrator,pass=3D********
> $ ls mnt
>
> $ ls mnt
> me =A0rockandroll =A0test =A0us =A0you
>
>
> debug output:
> [14359.414853] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c:
> Devname: //192.168.77.244/Misc flags: 0
> [14359.416284] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: in cifs_mount as Xid: 262 with uid: 0
> [14359.416300] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Username: administrator
> [14359.416306] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> UNC: \\192.168.77.244\Misc ip: 192.168.77.244
> [14359.416328] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Socket created
> [14359.416897] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
> [14359.417936] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: in cifs_get_smb_ses as Xid: 263 with uid: 0
> [14359.417941] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Existing smb sess not found
> [14359.417954] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> secFlags 0x80
> [14359.417960] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> NTLMSSP only mechanism, enable extended security
> [14359.417966] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 114
> [14359.417970] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 82
> [14359.418142] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Demultiplex PID: 5409
> [14359.418644] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0xd9
> [14359.418684] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D114 mid=3D1 state=3D4
> [14359.418696] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> Dialect: 2
> [14359.418705] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x2 0x348 0xbb92
> [14359.418712] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x2 0x348 0x1bb92
> [14359.418718] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 6 oid =3D 0x1 0x2 0x2f0 0x2b
> [14359.418724] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x3 0x6 0x1
> [14359.418730] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 10 oid =3D 0x1 0x3 0x6 0x1
> [14359.418736] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x3 0x5 0x1
> [14359.418741] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x3 0x6 0x1
> [14359.418748] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> Need to call asn1_octets_decode() function for
> not_defined_in_RFC4178@please_ignore
> [14359.418753] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> Signing disabled
> [14359.418763] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> negprot rc 0
> [14359.418772] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Security Mode: 0x3 Capabilities: 0x8080e2fc TimeAdjust: 0
> [14359.418778] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> sess setup type 3
> [14359.418789] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> ntlmssp session setup phase 1
> [14359.418795] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 115
> [14359.418798] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 210
> [14359.460788] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0xf8
> [14359.460825] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D115 mid=3D2 state=3D4
> [14359.460831] Status code returned 0xc0000016
> NT_STATUS_MORE_PROCESSING_REQUIRED
> [14359.460837] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
> Mapping smb error code 0xc0000016 to POSIX err -5
> [14359.460841] /build/buildd/linux-2.6.38/fs/cifs/misc.c:
> Null buffer passed to cifs_small_buf_release
> [14359.460848] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> Guest login
> [14359.460851] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> UID =3D 10
> [14359.460855] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> bleft 86
> [14359.460859] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverOS=3DDarwin
> [14359.460865] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverNOS=3D@(#)PROGRAM:smbd =A0PROJECT:smbx-102
> [14359.460868] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverDomain=3D
> [14359.460872] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> ssetup freeing small buf db8ab8c0
> [14359.460878] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> ntlmssp session setup phase 3
> [14359.460966] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 115
> [14359.460970] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 396
> [14359.486051] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x86
> [14359.486150] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D115 mid=3D3 state=3D4
> [14359.486164] /build/buildd/linux-2.6.38/fs/cifs/misc.c:
> Null buffer passed to cifs_small_buf_release
> [14359.486177] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> UID =3D 10
> [14359.486186] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> bleft 86
> [14359.486201] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverOS=3DDarwin
> [14359.486216] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverNOS=3D@(#)PROGRAM:smbd =A0PROJECT:smbx-102
> [14359.486227] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverDomain=3D
> [14359.486239] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> ssetup freeing small buf db8ab700
> [14359.486271] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS Session Established successfully
> [14359.486290] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: leaving cifs_get_smb_ses (xid =3D 263) rc =3D 0
> [14359.486305] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> file mode: 0x1ed =A0dir mode: 0x1ed
> [14359.486322] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: in cifs_get_tcon as Xid: 264 with uid: 0
> [14359.486349] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 117
> [14359.486359] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 98
> [14359.506870] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x42
> [14359.506963] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D117 mid=3D4 state=3D4
> [14359.507000] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> disk share connection
> [14359.507017] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> nativeFileSystem=3DNTFS
> [14359.507027] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Tcon flags: 0x0
> [14359.507049] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: leaving cifs_get_tcon (xid =3D 264) rc =3D 0
> [14359.507059] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS Tcon rc =3D 0
> [14359.507072] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In QFSDeviceInfo
> [14359.507086] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [14359.507096] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 72
> [14359.507878] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x44
> [14359.507931] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D5 state=3D4
> [14359.507972] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In QFSAttributeInfo
> [14359.507986] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [14359.507996] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 72
> [14359.510754] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x50
> [14359.511016] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D6 state=3D4
> [14359.511048] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Linux protocol extensions disabled
> [14359.511070] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: leaving cifs_mount (xid =3D 262) rc =3D 0
> [14359.511100] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> CIFS VFS: in cifs_root_iget as Xid: 265 with uid: 0
> [14359.511120] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> Getting info on
> [14359.511143] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [14359.511153] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 78
> [14359.512242] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x90
> [14359.512302] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D7 state=3D4
> [14359.512331] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In GetSrvInodeNum for
> [14359.512345] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [14359.512355] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 78
> [14359.514976] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x48
> [14359.515053] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D8 state=3D4
> [14359.515081] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> looking for uniqueid=3D386428
> [14359.515122] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> cifs_revalidate_cache: revalidating inode 386428
> [14359.515135] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> cifs_revalidate_cache: inode 386428 is new
> [14359.515149] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> inode 0xdbda7d74 old_time=3D0 new_time=3D3514878
> [14359.515174] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c:
> export ops supported
> [14360.542214] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> CIFS VFS: in cifs_lookup as Xid: 266 with uid: 1000
> [14360.542236] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> parent inode =3D 0xdbda7d74 name is: .Trash and dentry =3D 0xde2b7b80
> [14360.542252] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> NULL inode in lookup
> [14360.542263] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> Full path: \.Trash inode =3D 0x =A0(null)
> [14360.542275] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> Getting info on \.Trash
> [14360.542298] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [14360.542308] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 92
> [14360.552637] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x27
> [14360.552671] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> invalid transact2 word count
> [14360.558663] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D9 state=3D4
> [14360.558680] Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_=
NOT_FOUND
> [14360.558694] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
> Mapping smb error code 0xc0000034 to POSIX err -2
> [14360.558716] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> Send error in QPathInfo =3D -2
> [14360.558745] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> CIFS VFS: leaving cifs_lookup (xid =3D 266) rc =3D 0
> [14360.558956] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> CIFS VFS: in cifs_lookup as Xid: 267 with uid: 1000
> [14360.558972] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> parent inode =3D 0xdbda7d74 name is: .Trash-1000 and dentry =3D 0xde2=
b7e00
> [14360.558986] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> NULL inode in lookup
> [14360.558997] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> Full path: \.Trash-1000 inode =3D 0x =A0(null)
> [14360.559008] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> Getting info on \.Trash-1000
> [14360.559025] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [14360.559035] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: =A0total_len 102
> [14360.561562] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x27
> [14360.561602] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> invalid transact2 word count
> [14360.561678] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D10 state=3D4
> [14360.561692] Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_=
NOT_FOUND
> [14360.561705] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
> Mapping smb error code 0xc0000034 to POSIX err -2
> [14360.561722] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> Send error in QPathInfo =3D -2
> [14360.561743] /build/buildd/linux-2.6.38/fs/cifs/dir.c:
> CIFS VFS: leaving cifs_lookup (xid =3D 267) rc =3D 0
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve

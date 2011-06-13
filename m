From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs failed with Mac OS X 10.7 (LION, Preview 4)
Date: Mon, 13 Jun 2011 16:36:15 -0500
Message-ID: <BANLkTinPTPYgeUJom4jjCistSX+ndrBR9A@mail.gmail.com>
References: <loom.20110613T211710-599@post.gmane.org>
	<BANLkTi=CKD9F2Msdxf587QQN+Z5e8_r7BQ@mail.gmail.com>
	<loom.20110613T222739-674@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kong <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110613T222739-674-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 13, 2011 at 3:49 PM, Kong <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> No, mounting with "sec=3Dntlmssp" does not work.

Looks like it got much farther.  Looks like some server problems here,
although with a trace it would be easier to verify for sure.  For examp=
le
looks like the server is claiming Unix support, but rejecting QueryFSUn=
ixInfo,
and has a bug with QueryPathInfo processing (not sure which level but
probably one of the Unix/Posix info levels which start at 0x200).

Can you add "nounix" as well (not just sec=3Dntlmssp but "nounix,sec=3D=
ntlmssp"
in the mount options.

> $ sudo /sbin/mount.cifs -v -o user=3Dadministrator,pass=3D'Upt1va2008=
!',sec=3Dntlmssp
> //192.168.77.244/Misc mnt
> mount.cifs kernel mount options:ip=3D192.168.77.244,
> unc=3D\\192.168.77.244\Misc,sec=3Dntlmssp,ver=3D1,user=3Dadministrato=
r,pass=3D********
> mount error(95): Operation not supported
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> debug output:
> [ 9063.356223] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c:
> Devname: //192.168.77.244/Misc flags: 0
> [ 9063.358102] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: in cifs_mount as Xid: 154 with uid: 0
> [ 9063.358117] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Username: administrator
> [ 9063.358122] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> UNC: \\192.168.77.244\Misc ip: 192.168.77.244
> [ 9063.358142] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Socket created
> [ 9063.370719] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
> [ 9063.376125] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: in cifs_get_smb_ses as Xid: 155 with uid: 0
> [ 9063.376132] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Existing smb sess not found
> [ 9063.376142] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> secFlags 0x80
> [ 9063.376149] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> NTLMSSP only mechanism, enable extended security
> [ 9063.376156] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 114
> [ 9063.376160] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 82
> [ 9063.376324] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Demultiplex PID: 4219
> [ 9063.377010] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0xd9
> [ 9063.377047] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D114 mid=3D1 state=3D4
> [ 9063.377057] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> Dialect: 2
> [ 9063.377065] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x2 0x348 0xbb92
> [ 9063.377069] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x2 0x348 0x1bb92
> [ 9063.377073] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 6 oid =3D 0x1 0x2 0x2f0 0x2b
> [ 9063.377077] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x3 0x6 0x1
> [ 9063.377121] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 10 oid =3D 0x1 0x3 0x6 0x1
> [ 9063.377126] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x3 0x5 0x1
> [ 9063.377130] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> OID len =3D 7 oid =3D 0x1 0x3 0x6 0x1
> [ 9063.377134] /build/buildd/linux-2.6.38/fs/cifs/asn1.c:
> Need to call asn1_octets_decode() function for
> not_defined_in_RFC4178@please_ignore
> [ 9063.377138] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> Signing disabled
> [ 9063.377148] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> negprot rc 0
> [ 9063.377156] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Security Mode: 0x3 Capabilities: 0x8080e2fc TimeAdjust: 0
> [ 9063.377159] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> sess setup type 3
> [ 9063.377165] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> ntlmssp session setup phase 1
> [ 9063.377171] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 115
> [ 9063.377175] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 210
> [ 9063.384412] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0xf8
> [ 9063.384458] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D115 mid=3D2 state=3D4
> [ 9063.384464] Status code returned 0xc0000016
> =A0NT_STATUS_MORE_PROCESSING_REQUIRED
> [ 9063.384470] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
> Mapping smb error code 0xc0000016 to POSIX err -5
> [ 9063.384474] /build/buildd/linux-2.6.38/fs/cifs/misc.c:
> Null buffer passed to cifs_small_buf_release
> [ 9063.384481] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> Guest login
> [ 9063.384485] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> UID =3D 4
> [ 9063.384489] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> bleft 86
> [ 9063.384494] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverOS=3DDarwin
> [ 9063.384499] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverNOS=3D@(#)PROGRAM:smbd =A0PROJECT:smbx-102
> [ 9063.384503] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverDomain=3D
> [ 9063.384507] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> ssetup freeing small buf db8ab540
> [ 9063.384513] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> ntlmssp session setup phase 3
> [ 9063.384681] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 115
> [ 9063.384686] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 396
> [ 9063.406617] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x86
> [ 9063.406666] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D115 mid=3D3 state=3D4
> [ 9063.406671] /build/buildd/linux-2.6.38/fs/cifs/misc.c:
> Null buffer passed to cifs_small_buf_release
> [ 9063.406677] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> UID =3D 4
> [ 9063.406681] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> bleft 86
> [ 9063.406687] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverOS=3DDarwin
> [ 9063.406692] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverNOS=3D@(#)PROGRAM:smbd =A0PROJECT:smbx-102
> [ 9063.406696] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> serverDomain=3D
> [ 9063.406700] /build/buildd/linux-2.6.38/fs/cifs/sess.c:
> ssetup freeing small buf db8ab700
> [ 9063.406707] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS Session Established successfully
> [ 9063.406714] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: leaving cifs_get_smb_ses (xid =3D 155) rc =3D 0
> [ 9063.406719] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> file mode: 0x1ed dir mode: 0x1ed
> [ 9063.406726] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: in cifs_get_tcon as Xid: 156 with uid: 0
> [ 9063.406738] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 117
> [ 9063.406741] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 98
> [ 9063.422924] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x42
> [ 9063.422961] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D117 mid=3D4 state=3D4
> [ 9063.422971] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> disk share connection
> [ 9063.423017] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> nativeFileSystem=3DNTFS
> [ 9063.423021] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> Tcon flags: 0x0
> [ 9063.423031] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: leaving cifs_get_tcon (xid =3D 156) rc =3D 0
> [ 9063.423035] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS Tcon rc =3D 0
> [ 9063.423040] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In QFSDeviceInfo
> [ 9063.423045] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [ 9063.423049] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 72
> [ 9063.423473] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x44
> [ 9063.423553] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D5 state=3D4
> [ 9063.423567] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In QFSAttributeInfo
> [ 9063.423572] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [ 9063.423576] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 72
> [ 9063.424468] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x50
> [ 9063.425066] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D6 state=3D4
> [ 9063.425085] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In QFSUnixInfo
> [ 9063.425092] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [ 9063.425096] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 72
> [ 9063.426194] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x27
> [ 9063.426204] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> invalid transact2 word count
> [ 9063.426226] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D7 state=3D4
> [ 9063.426239] Status code returned 0xc0000148 NT_STATUS_INVALID_LEVE=
L
> [ 9063.426244] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
> Mapping smb error code 0xc0000148 to POSIX err -95
> [ 9063.426251] CIFS VFS: Send error in QFSUnixInfo =3D -95
> [ 9063.426265] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: leaving cifs_mount (xid =3D 154) rc =3D 0
> [ 9063.426274] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> CIFS VFS: in cifs_root_iget as Xid: 157 with uid: 0
> [ 9063.426278] /build/buildd/linux-2.6.38/fs/cifs/inode.c:
> Getting info on
> [ 9063.426281] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In QPathInfo (Unix) the path
> [ 9063.426287] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 50
> [ 9063.426290] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 78
> [ 9063.426937] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x27
> [ 9063.426944] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> invalid transact2 word count
> [ 9063.426959] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D50 mid=3D8 state=3D4
> [ 9063.426963] Status code returned 0xc0000003 NT_STATUS_INVALID_INFO=
_CLASS
> [ 9063.426968] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
> Mapping smb error code 0xc0000003 to POSIX err -95
> [ 9063.426980] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> Send error in QPathInfo =3D -95
> [ 9063.426988] CIFS VFS: cifs_read_super: get root inode failed
> [ 9063.426996] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> cifs_put_tcon: tc_count=3D1
> [ 9063.426998]
> [ 9063.427002] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: in cifs_put_tcon as Xid: 158 with uid: 0
> [ 9063.427022] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In tree disconnect
> [ 9063.427027] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 113
> [ 9063.427031] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 39
> [ 9063.431190] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x27
> [ 9063.431234] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D113 mid=3D9 state=3D4
> [ 9063.431305] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> cifs_put_smb_ses: ses_count=3D1
> [ 9063.431307]
> [ 9063.431354] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> CIFS VFS: in cifs_put_smb_ses as Xid: 159 with uid: 0
> [ 9063.431360] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
> In SMBLogoff for session disconnect
> [ 9063.431386] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> For smb_command 116
> [ 9063.431390] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> Sending smb: total_len 43
> [ 9063.431847] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
> rfc1002 length 0x27
> [ 9063.431865] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
> sync_mid_result: cmd=3D116 mid=3D10 state=3D4
>
> On the mac, smbx logged the following:
> host77244\administrator connected to path /User/administrator/Misc
>
> Thanks.
>
> Kong
>
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

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Tue, 13 Dec 2011 12:12:15 -0600
Message-ID: <CADT32eKpH_FEm6oZKELotyQrj4JSAVxhRRuz01qrVPZkLNJh3Q@mail.gmail.com>
References: <4ED2FD48.7060108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ED2FD48.7060108-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Nov 27, 2011 at 9:17 PM, jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> hi,
>
> started using Xubuntu (11.10) and cannot get the mount.cifs to the NA=
S
> working.
>
> the following command works from my slackware system:
> =A0mount.cifs //server/share /mnt -o guest
>
> the same command (except added option ro) executed on Xubuntu gives e=
rror
> =A0CIFS VFS: Send error in SessSetup =3D -13
>
> I can access the NAS via smbclient.
>
> after days of googling, I'm still no wiser. =A0below is a listing of =
the dmesg
> output. =A0help, please.
>
>
> [92841.000417] /build/buildd/linux-3.0.0/fs/cifs/cifsfs.c: Devname:
> //nas/public flags: 1
> [92841.000428] /build/buildd/linux-3.0.0/fs/cifs/connect.c: null user
> [92841.000434] /build/buildd/linux-3.0.0/fs/cifs/connect.c: file mode=
: 0x1ed
> =A0dir mode: 0x1ed
> [92841.000506] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS:=
 in
> cifs_mount as Xid: 52 with uid: 0
> [92841.000510] /build/buildd/linux-3.0.0/fs/cifs/connect.c: UNC:
> \\nas\public ip: 192.168.0.10
> [92841.000530] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Socket cr=
eated
> [92841.000534] /build/buildd/linux-3.0.0/fs/cifs/connect.c: sndbuf 16=
384
> rcvbuf 87380 rcvtimeo 0x6d6
> [92841.001152] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS:=
 in
> cifs_get_smb_ses as Xid: 53 with uid: 0
> [92841.001157] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Existing =
smb
> sess not found
> [92841.001165] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: secFlags =
0x7
> [92841.001170] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
> smb_command 114
> [92841.001174] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending=
 smb:
> =A0total_len 82
> [92841.001194] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Demultipl=
ex PID:
> 6045
> [92841.243749] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 l=
ength
> 0x65
> [92841.243770] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
> cifs_sync_mid_result: cmd=3D114 mid=3D1 state=3D4
> [92841.243777] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: Dialect: =
2
> [92841.243783] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: negprot r=
c 0
> [92841.243787] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Security =
Mode:
> 0x3 Capabilities: 0xe3fd TimeAdjust: 0
> [92841.243791] /build/buildd/linux-3.0.0/fs/cifs/sess.c: sess setup t=
ype 1
> [92841.243828] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
> smb_command 115
> [92841.243832] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending=
 smb:
> =A0total_len 232
> [92841.247606] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 l=
ength
> 0x66
> [92841.247623] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
> cifs_sync_mid_result: cmd=3D115 mid=3D2 state=3D4
> [92841.247628] /build/buildd/linux-3.0.0/fs/cifs/misc.c: Null buffer =
passed
> to cifs_small_buf_release
> [92841.247632] /build/buildd/linux-3.0.0/fs/cifs/sess.c: Guest login
> [92841.247635] /build/buildd/linux-3.0.0/fs/cifs/sess.c: UID =3D 100
> [92841.247638] /build/buildd/linux-3.0.0/fs/cifs/sess.c: bleft 56
> [92841.247642] /build/buildd/linux-3.0.0/fs/cifs/sess.c: serverOS=3DU=
nix
> [92841.247646] /build/buildd/linux-3.0.0/fs/cifs/sess.c: serverNOS=3D=
Samba
> 3.0.34
> [92841.247650] /build/buildd/linux-3.0.0/fs/cifs/sess.c:
> serverDomain=3DWORKGROUP
> [92841.247654] /build/buildd/linux-3.0.0/fs/cifs/sess.c: ssetup freei=
ng
> small buf f1f32540
> [92841.247657] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Sess=
ion
> Established successfully
> [92841.247662] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS:
> leaving cifs_get_smb_ses (xid =3D 53) rc =3D 0
> [92841.247667] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS:=
 in
> cifs_get_tcon as Xid: 54 with uid: 0
> [92841.247673] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
> smb_command 117
> [92841.247677] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending=
 smb:
> =A0total_len 90
> [92841.248606] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 l=
ength
> 0x27
> [92841.248620] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
> cifs_sync_mid_result: cmd=3D117 mid=3D3 state=3D4
> [92841.248625] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIE=
D
> [92841.248630] /build/buildd/linux-3.0.0/fs/cifs/netmisc.c: Mapping s=
mb
> error code 0xc0000022 to POSIX err -13
> [92841.248635] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS:
> leaving cifs_get_tcon (xid =3D 54) rc =3D -13
> [92841.248639] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Tcon=
 rc =3D
> -13
> [92841.248643] /build/buildd/linux-3.0.0/fs/cifs/connect.c:
> build_unc_path_to_root: full_path=3D\\nas\public
> [92841.248648] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
> smb_command 117
> [92841.248652] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending=
 smb:
> =A0total_len 94
> [92841.251461] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 l=
ength
> 0x3c
> [92841.251473] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
> cifs_sync_mid_result: cmd=3D117 mid=3D4 state=3D4
> [92841.251478] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Tcon=
 rc =3D 0
> ipc_tid =3D 1
> [92841.251482] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: In GetDFS=
Refer
> the path \nas\public
> [92841.251487] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
> smb_command 50
> [92841.251490] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending=
 smb:
> =A0total_len 108
> [92841.252726] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 l=
ength
> 0x27
> [92841.252731] /build/buildd/linux-3.0.0/fs/cifs/connect.c: invalid
> transact2 word count
> [92841.252743] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
> cifs_sync_mid_result: cmd=3D50 mid=3D5 state=3D4
> [92841.252748] Status code returned 0xc0000002 NT_STATUS_NOT_IMPLEMEN=
TED
> [92841.252752] /build/buildd/linux-3.0.0/fs/cifs/netmisc.c: Mapping s=
mb
> error code 0xc0000002 to POSIX err -22
> [92841.252756] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: Send erro=
r in
> GetDFSRefer =3D -22
> [92841.252760] /build/buildd/linux-3.0.0/fs/cifs/connect.c:
> cifs_put_smb_ses: ses_count=3D1
> [92841.252762]
> [92841.252765] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS:=
 in
> cifs_put_smb_ses as Xid: 55 with uid: 0
> [92841.252769] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: In SMBLog=
off for
> session disconnect
> [92841.252773] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
> smb_command 116
> [92841.252776] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending=
 smb:
> =A0total_len 43
> [92841.253503] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 l=
ength
> 0x2b
> [92841.253515] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
> cifs_sync_mid_result: cmd=3D116 mid=3D6 state=3D4
> [92841.256596] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS:
> leaving cifs_mount (xid =3D 52) rc =3D -13
> [92841.256600] CIFS VFS: cifs_mount failed w/return code =3D -13
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

The Samba server on the NAS box, in response to negotiate protocol
request from the cifs client on the xubuntu box, is sending
security mode as 0x3 (user security mode).

The same Samba server on this NAS box, sends security mode bit as
0x2 (share security mode) in a response to a negprot request from
the cifs client on the slackware box..

Not sure why the difference.  global section of smb.conf has an
entry of
   security =3D user.

Regards,

Shirish

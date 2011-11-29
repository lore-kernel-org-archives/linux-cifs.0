From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Tue, 29 Nov 2011 09:23:39 -0500
Message-ID: <20111129092339.1ae61788@tlielax.poochiereds.net>
References: <4ED3017A.9030502@gmail.com>
 <20111128153207.163adbfe@tlielax.poochiereds.net>
 <CADT32eJ2oa--ER7NFf3wCbmRng7e_KL+D1PV8Lf+sk=_RH97bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJ2oa--ER7NFf3wCbmRng7e_KL+D1PV8Lf+sk=_RH97bQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 28 Nov 2011 14:47:20 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Nov 28, 2011 at 2:32 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Mon, 28 Nov 2011 03:35:22 +0000
> > jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >
> > --------------[snip]----------------
> >> [92841.247667] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS V=
=46S: in
> >> cifs_get_tcon as Xid: 54 with uid: 0
> >> [92841.247673] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
> >> smb_command 117
> >> [92841.247677] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Send=
ing
> >> smb: =C2=A0total_len 90
> >> [92841.248606] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc100=
2
> >> length 0x27
> >> [92841.248620] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
> >> cifs_sync_mid_result: cmd=3D117 mid=3D3 state=3D4
> >> [92841.248625] Status code returned 0xc0000022 NT_STATUS_ACCESS_DE=
NIED
> >> [92841.248630] /build/buildd/linux-3.0.0/fs/cifs/netmisc.c: Mappin=
g smb
> >> error code 0xc0000022 to POSIX err -13
> >> [92841.248635] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS V=
=46S:
> >> leaving cifs_get_tcon (xid =3D 54) rc =3D -13
> >> [92841.248639] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS T=
con rc
> >> =3D -13
> > --------------[snip]----------------
> >
> > Looks like the tree connect is falling down. Does the user you're
> > connecting as have access to the exported share? You may want to ch=
eck
> > the logs on the NAS and see why it's rejecting the tree connect req=
uest.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >

Ahh yeah, you're correct -- the cause of the failure is here:

[92841.251487] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For=20
smb_command 50
[92841.251490] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending=20
smb:  total_len 108
[92841.252726] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002=20
length 0x27
[92841.252731] /build/buildd/linux-3.0.0/fs/cifs/connect.c: invalid=20
transact2 word count
[92841.252743] /build/buildd/linux-3.0.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D5 state=3D4
[92841.252748] Status code returned 0xc0000002 NT_STATUS_NOT_IMPLEMENTE=
D
[92841.252752] /build/buildd/linux-3.0.0/fs/cifs/netmisc.c: Mapping smb=
=20
error code 0xc0000002 to POSIX err -22
[92841.252756] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: Send error=20
in GetDFSRefer =3D -22

and 22 is -EINVAL. This machine is running 3.0? What may be best is to
open a bug at bugzilla.samba.org so we can track this. We may need to
see a capture of the traffic between the client and server.

=46rom the supplied info:

[92841.243787] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Security Mo=
de: 0x3 Capabilities: 0xe3fd TimeAdjust: 0

CAP_DFS does not appear to be set. I also note that we never actually
check for SMBFLG2_DFS in the cifs.ko code.

It seems like if those bits aren't set, we ought not try to chase DFS
referrals at mount time...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

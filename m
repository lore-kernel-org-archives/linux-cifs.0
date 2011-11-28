From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Mon, 28 Nov 2011 14:47:20 -0600
Message-ID: <CADT32eJ2oa--ER7NFf3wCbmRng7e_KL+D1PV8Lf+sk=_RH97bQ@mail.gmail.com>
References: <4ED3017A.9030502@gmail.com>
	<20111128153207.163adbfe@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111128153207.163adbfe-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 28, 2011 at 2:32 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 28 Nov 2011 03:35:22 +0000
> jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>
> --------------[snip]----------------
>> [92841.247667] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS=
: in
>> cifs_get_tcon as Xid: 54 with uid: 0
>> [92841.247673] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
>> smb_command 117
>> [92841.247677] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sendin=
g
>> smb: =A0total_len 90
>> [92841.248606] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002
>> length 0x27
>> [92841.248620] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
>> cifs_sync_mid_result: cmd=3D117 mid=3D3 state=3D4
>> [92841.248625] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENI=
ED
>> [92841.248630] /build/buildd/linux-3.0.0/fs/cifs/netmisc.c: Mapping =
smb
>> error code 0xc0000022 to POSIX err -13
>> [92841.248635] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS=
:
>> leaving cifs_get_tcon (xid =3D 54) rc =3D -13
>> [92841.248639] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Tco=
n rc
>> =3D -13
> --------------[snip]----------------
>
> Looks like the tree connect is falling down. Does the user you're
> connecting as have access to the exported share? You may want to chec=
k
> the logs on the NAS and see why it's rejecting the tree connect reque=
st.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Not sure if tcon fails or not because, right below, another tree connec=
tion
request succeeds.

[92841.248643] /build/buildd/linux-3.0.0/fs/cifs/connect.c:
build_unc_path_to_root: full_path=3D\\nas\public
[92841.248648] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For
smb_command 117
[92841.248652] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending
smb:  total_len 94
[92841.251461] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 len=
gth 0x3c
[92841.251473] /build/buildd/linux-3.0.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=3D117 mid=3D4 state=3D4
[92841.251478] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Tcon
rc =3D 0 ipc_tid =3D 1

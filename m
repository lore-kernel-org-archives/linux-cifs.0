From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/6] CIFS: implement get_dfs_refer for SMB2+
Date: Tue, 28 Feb 2017 18:34:54 -0800
Message-ID: <CAKywueRy=-BQ+XjEce9wJnvy9i3UxrmcBk0H9hb-FOJ0zKuTXQ@mail.gmail.com>
References: <20170223144334.22320-1-aaptel@suse.com> <20170223144334.22320-4-aaptel@suse.com>
 <CAKywueSCHszmzBbfLfJTP66=w6FcKgR2p1UJJig4uxcgC4QSfA@mail.gmail.com>
 <mpsvarzfw5r.fsf@aaptelpc.suse.de> <CAKywueSw5+cBkitxVT47U-F-r4i8mXTDK4KLuBYhnGiGD0eJCQ@mail.gmail.com>
 <mpsshmzg1ka.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsshmzg1ka.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-27 6:17 GMT-08:00 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> We can pass both arguments: tcon and ipc_tid. If the 1st is specified
>> SMB_ioctl uses it, otherwise - use ipc_tid.
>
> I still don't get it. When tcon is not specified (I'm assuming that
> means passing NULL) and we just have ipc_tid (an int) we cannot:
> - access the struct cifs_ses*
> - access the struct TCP_Server_Info*
> - check if encryption is required
> - call any of the functions that requires the session or the server
>   struct (i.e. all the functions that do the real work).

Yes, we still need to pass "ses" argument which will create a whole
mess. But we probably need to clean this anyway because the number of
argument are getting too big.

>
>> Since we call get_dfs_refer() once we get ipc_tid, may be it is worth
>> to try ipc_tid at first and then, if EAGAIN is returned (probably due
>> to reconnection that makes ipc_tid equal 0), use the 1st tcon from
>> list for the session. This will also workaround the bug in Samba.
>
> What I'm proposing is to add a bool flag use_ipc to SMB2_ioctl. And do
> something like this:
>
>     if use_ipc:
>         if tcon->ses->ipc_tid =3D=3D 0:
>             return -ENOTCONN
>         else:
>             req->tid =3D tcon->ses->ipc_tid
>
> Now in smb2_get_dfs_referral can first try to call it with
> use_ipc=3Dtrue and if that fails with ENOTCONN try again with false.

This also works although it doesn't allow to call SMB2_ioctl() without
having at least one tcon.

--=20
Best regards,
Pavel Shilovsky

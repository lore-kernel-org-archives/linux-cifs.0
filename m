From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/6] CIFS: implement get_dfs_refer for SMB2+
Date: Fri, 24 Feb 2017 11:50:49 -0800
Message-ID: <CAKywueSw5+cBkitxVT47U-F-r4i8mXTDK4KLuBYhnGiGD0eJCQ@mail.gmail.com>
References: <20170223144334.22320-1-aaptel@suse.com> <20170223144334.22320-4-aaptel@suse.com>
 <CAKywueSCHszmzBbfLfJTP66=w6FcKgR2p1UJJig4uxcgC4QSfA@mail.gmail.com> <mpsvarzfw5r.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsvarzfw5r.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-24 7:25 GMT-08:00 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> Hi Pavel,
>
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> Accessing the tcon_list should be protected by spin_locks and also a
>> reference to the tcon should be acquired before using it safely.
>
> I've noticed we have the cifs_tcp_ses_lock but also a per-session
> session_mutex. I'm guessing we want cifs_tcp_ses_lock here.
>
> By acquiring a reference you mean incrementing/decrementing tc_count. Do
> we need to protect this inc/dec operation with cifs_tcp_ses_lock too?

Yes.

>
>> Also you can extend SMB2_ioctl argument list to allow passing ipc_tid.
>> In this case SMB2_ioctl() can choose what to use - ipc_tid or tcon; if
>> tcon is passed -use it, otherwise - use ipc_tid.
>>
>> In this case you can fallback to ipc_tid if no tcon is found in the list=
.
>>
>
> SMB2_ioctl() uses the tcon for many things. I don't see how we can just
> use ipc_tid number if we don't pass a tcon.
>
> Or do you mean: add a use_ipc bool to SMB2_ioctl arg list and use the tco=
n as
> usual except overwrite the Tid field with ses->ipc_tid before sending?

We can pass both arguments: tcon and ipc_tid. If the 1st is specified
SMB_ioctl uses it, otherwise - use ipc_tid.

Since we call get_dfs_refer() once we get ipc_tid, may be it is worth
to try ipc_tid at first and then, if EAGAIN is returned (probably due
to reconnection that makes ipc_tid equal 0), use the 1st tcon from
list for the session. This will also workaround the bug in Samba.

>
> Thanks,
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)



--=20
Best regards,
Pavel Shilovsky

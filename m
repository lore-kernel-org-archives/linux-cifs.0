From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/6] CIFS: implement get_dfs_refer for SMB2+
Date: Fri, 24 Feb 2017 16:25:36 +0100
Message-ID: <mpsvarzfw5r.fsf@aaptelpc.suse.de>
References: <20170223144334.22320-1-aaptel@suse.com> <20170223144334.22320-4-aaptel@suse.com> <CAKywueSCHszmzBbfLfJTP66=w6FcKgR2p1UJJig4uxcgC4QSfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSCHszmzBbfLfJTP66=w6FcKgR2p1UJJig4uxcgC4QSfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> Accessing the tcon_list should be protected by spin_locks and also a
> reference to the tcon should be acquired before using it safely.

I've noticed we have the cifs_tcp_ses_lock but also a per-session
session_mutex. I'm guessing we want cifs_tcp_ses_lock here.

By acquiring a reference you mean incrementing/decrementing tc_count. Do
we need to protect this inc/dec operation with cifs_tcp_ses_lock too?

> Also you can extend SMB2_ioctl argument list to allow passing ipc_tid.
> In this case SMB2_ioctl() can choose what to use - ipc_tid or tcon; if
> tcon is passed -use it, otherwise - use ipc_tid.
>
> In this case you can fallback to ipc_tid if no tcon is found in the list.
>

SMB2_ioctl() uses the tcon for many things. I don't see how we can just
use ipc_tid number if we don't pass a tcon.

Or do you mean: add a use_ipc bool to SMB2_ioctl arg list and use the tcon as
usual except overwrite the Tid field with ses->ipc_tid before sending?

Thanks,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)

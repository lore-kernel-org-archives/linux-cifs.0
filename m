From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/6] CIFS: implement get_dfs_refer for SMB2+
Date: Tue, 28 Feb 2017 19:44:07 +0100
Message-ID: <mpsh93ef954.fsf@aaptelpc.suse.de>
References: <20170223144334.22320-1-aaptel@suse.com> <20170223144334.22320-4-aaptel@suse.com> <CAKywueSCHszmzBbfLfJTP66=w6FcKgR2p1UJJig4uxcgC4QSfA@mail.gmail.com> <mpsvarzfw5r.fsf@aaptelpc.suse.de> <CAKywueSw5+cBkitxVT47U-F-r4i8mXTDK4KLuBYhnGiGD0eJCQ@mail.gmail.com> <mpsshmzg1ka.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsshmzg1ka.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Aurélien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> writes:
> What I'm proposing is to add a bool flag use_ipc to SMB2_ioctl. And do
> something like this:
>
>     if use_ipc:
>         if tcon->ses->ipc_tid == 0:
>             return -ENOTCONN
>         else:
>             req->tid = tcon->ses->ipc_tid
>
> Now in smb2_get_dfs_referral can first try to call it with
> use_ipc=true and if that fails with ENOTCONN try again with false.

I went ahead and implemented this along with small improvements in a v3
patchset. I'm still open to rework on this if can understand better what
you were proposing.

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)

From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/2] CIFS: use tcon_ipc instead of use_ipc parameter of SMB2_ioctl
Date: Mon, 22 Jan 2018 17:27:34 +0100
Message-ID: <874lnduadl.fsf@suse.com>
References: <20180117172200.3221-1-aaptel@suse.com> <20180119171258.14244-1-aaptel@suse.com> <20180119171258.14244-3-aaptel@suse.com> <CAKywueRY1G5GQznKtSiOuU8dtE6248h5+OfK7gC3154VwjSeaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRY1G5GQznKtSiOuU8dtE6248h5+OfK7gC3154VwjSeaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> Is it safe to try IPC share only and not retry with any normal tcon in
> the case of ENOTCONN like the current code does?

ENOTCONN was returned when SMB2_ioctl(with_ipc=true) was called and no
ipc was available so I believe it is functionnaly equivalent
currently. Unless other NT_STATUS mapped to ENOTCONN can be returned in
that scenario but I don't think it can.

While rebasing this on top of Steve's for-next I've realized since IPC
is not part of the tcon list anymore it's not automatically
reconnected. I have to do more testing :(

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)

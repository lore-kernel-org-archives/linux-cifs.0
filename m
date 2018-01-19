From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 2/3] CIFS: make IPC a regular tcon
Date: Fri, 19 Jan 2018 13:33:45 +0100
Message-ID: <87r2qmxc2e.fsf@suse.com>
References: <20180117172200.3221-1-aaptel@suse.com> <20180117172200.3221-3-aaptel@suse.com> <DM5PR2101MB0936C7D8EE43D6E069870B10B6E80@DM5PR2101MB0936.namprd21.prod.outlook.com> <87607z4fyr.fsf@suse.com> <CAKywueRdq2N=xaGuWrXiSMQkQ-TxcwTB7MirehtGbm7JexwMcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "smfrench\@gmail.com" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRdq2N=xaGuWrXiSMQkQ-TxcwTB7MirehtGbm7JexwMcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> I agree that accessing ses->tcon_ipc is not necessary to be under
> spinlock. Btw, why should we put this tcon to the list at the 1st
> place? We can leave to be accessed only by ses->tcon_ipc and do not
> bother with spinlocks at all.

I thought about it. Initially I thought I could reuse tcon get/put
functions but since its not the case (no mount points refer to the IPC
tcon so it's special) I agree it would make more sense now.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)

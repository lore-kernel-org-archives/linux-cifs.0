From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 2/3] CIFS: make IPC a regular tcon
Date: Thu, 18 Jan 2018 12:24:15 -0800
Message-ID: <CAKywueRdq2N=xaGuWrXiSMQkQ-TxcwTB7MirehtGbm7JexwMcQ@mail.gmail.com>
References: <20180117172200.3221-1-aaptel@suse.com> <20180117172200.3221-3-aaptel@suse.com>
 <DM5PR2101MB0936C7D8EE43D6E069870B10B6E80@DM5PR2101MB0936.namprd21.prod.outlook.com>
 <87607z4fyr.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87607z4fyr.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2018-01-18 2:30 GMT-08:00 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> writes:
>> Minor: it should probably work this way, but since we set ses->tcon_ipc =
under a spinlock in cifs_setup_ipc(), it would be better to do something si=
milar here.
>
> I was actually thinking that the spinlock might not be necessary for
> that pointer. It's always only set at session creation (new tcon) and
> destruction (to null). In between, it's only going to be read. What do
> you think?

I agree that accessing ses->tcon_ipc is not necessary to be under
spinlock. Btw, why should we put this tcon to the list at the 1st
place? We can leave to be accessed only by ses->tcon_ipc and do not
bother with spinlocks at all.

>
>>> -       /*
>>> -        * BB - map targetUNCs to dfs_info3 structures, here or in
>>> -        * ses->server->ops->get_dfs_refer.
>>> -        */
>>
>> Is this no longer needed?
>
> If you are talking about the tcon creation, it is now done all the time
> at session creation. If you are talking about that specific comment, I
> believe it's already done now in parse_dfs_referrals(). That function
> parses the packet into dfs_info3_param structures.
>

I was talking about the comment.


--
Best regards,
Pavel Shilovsky

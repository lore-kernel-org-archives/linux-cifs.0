From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Make cifsFileInfo_put work with strict cache mode
 (try #3)
Date: Sun, 28 Nov 2010 11:11:28 +0300
Message-ID: <AANLkTimCW5_=0LGCds9-0whUyMcjZ5ZRSjTHaXRW9sjN@mail.gmail.com>
References: <1290368618-12918-1-git-send-email-piastryyy@gmail.com>
	<AANLkTikhDHcSK2p6UJKtTS4rNq-bMWDarYd=PTHg-TUN@mail.gmail.com>
	<20101127073116.20f3a064@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101127073116.20f3a064-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 25 Nov 2010 13:51:29 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2010/11/21 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > On strict cache mode when we close the last file handle of the inode we
>> > should set invalid_mapping flag on this inode to prevent data coherency
>> > problem when we open it again but it has been modified by other clients.
>> >
>>
>> What's about this patch and other strictcache mode related things?
>>
>
> I'm not sure which ones need review at this point. Perhaps it would be
> best to re-post the set? If you do, make sure to attach
> Reviewed-by/Acked-by tags on patches that have already been reviewed.
>

Ok, it isn't a problem. Another problem that no one from the series
got Reviewed-by/Acked-by tags :)

So, I have several separate set of patches (strict cache,
ip_connect/port, cifs_open) - let's finised with them in the order,
because I am a bit confused about it. May be I shouldn't post second
and third rewritten set until we deal with the first successfully?

In general, I am not think that I understand correctly all the process
of linux kernel cifs client contributing, can you explain the main
points or point to a appropriate link, please?

-- 
Best regards,
Pavel Shilovsky.

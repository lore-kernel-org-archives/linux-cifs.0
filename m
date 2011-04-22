From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify invalidate part (try #2)
Date: Fri, 22 Apr 2011 16:05:31 +0400
Message-ID: <BANLkTik4=FZ2hfPtjd6DtwkPGBAg0ij_JQ@mail.gmail.com>
References: <1302635430-3575-1-git-send-email-piastry@etersoft.ru>
	<BANLkTi=7eNfZXZPWYoPYY1CWsKqwvXkKNA@mail.gmail.com>
	<BANLkTikfXi9U2A88S1_h8kXfyNhJcs9rzw@mail.gmail.com>
	<20110422075007.2e9c303b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110422075007.2e9c303b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/22 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 22 Apr 2011 12:09:20 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> After conversation with Steve, we decided to drop
>> filemap_write_and_wait from getattr, because we already do it in
>> cifs_file_aio_write. I also think that we should drop it from
>> cifs_llseek in this case too. I will repost this patch later (launder
>> page operation patch was merged earlier).
>>
>
> I wasn't privy to this discussion, but that makes no sense to me. Just
> because we initiated writeout in cifs_file_aio_write, does not mean
> that it's complete. If it's not complete then the size returned by the
> server may be bogus.
>

We call filemap_fdatawrite -> __filemap_fdatawrite(WB_SYNC_ALL) ->
__filemap_fdatawrite_range(WB_SYNC_ALL) -> do_writepages ->
cifs_writepages.

cifs_writepages with WB_SYNC_ALL is sync operations (even with you
async writepages set) - so we always get correct filesize from the
server. If the write from another process is in progress now, we don't
get better results to issues filemap_write_and_wait because another
process can dirty pages after this but before we request getattr to
the server.

-- 
Best regards,
Pavel Shilovsky.

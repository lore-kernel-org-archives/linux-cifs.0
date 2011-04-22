From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify invalidate part (try #2)
Date: Fri, 22 Apr 2011 07:50:07 -0400
Message-ID: <20110422075007.2e9c303b@tlielax.poochiereds.net>
References: <1302635430-3575-1-git-send-email-piastry@etersoft.ru>
	<BANLkTi=7eNfZXZPWYoPYY1CWsKqwvXkKNA@mail.gmail.com>
	<BANLkTikfXi9U2A88S1_h8kXfyNhJcs9rzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikfXi9U2A88S1_h8kXfyNhJcs9rzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Apr 2011 12:09:20 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> After conversation with Steve, we decided to drop
> filemap_write_and_wait from getattr, because we already do it in
> cifs_file_aio_write. I also think that we should drop it from
> cifs_llseek in this case too. I will repost this patch later (launder
> page operation patch was merged earlier).
> 

I wasn't privy to this discussion, but that makes no sense to me. Just
because we initiated writeout in cifs_file_aio_write, does not mean
that it's complete. If it's not complete then the size returned by the
server may be bogus.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

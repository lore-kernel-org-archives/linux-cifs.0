From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify invalidate part (try #2)
Date: Fri, 22 Apr 2011 08:28:47 -0400
Message-ID: <20110422082847.6192c0c2@tlielax.poochiereds.net>
References: <1302635430-3575-1-git-send-email-piastry@etersoft.ru>
	<BANLkTi=7eNfZXZPWYoPYY1CWsKqwvXkKNA@mail.gmail.com>
	<BANLkTikfXi9U2A88S1_h8kXfyNhJcs9rzw@mail.gmail.com>
	<20110422075007.2e9c303b@tlielax.poochiereds.net>
	<BANLkTik4=FZ2hfPtjd6DtwkPGBAg0ij_JQ@mail.gmail.com>
	<20110422120912.GA8969@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110422120912.GA8969-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Apr 2011 08:09:12 -0400
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Fri, Apr 22, 2011 at 04:05:31PM +0400, Pavel Shilovsky wrote:
> > We call filemap_fdatawrite -> __filemap_fdatawrite(WB_SYNC_ALL) ->
> > __filemap_fdatawrite_range(WB_SYNC_ALL) -> do_writepages ->
> > cifs_writepages.
> > 
> > cifs_writepages with WB_SYNC_ALL is sync operations (even with you
> > async writepages set)
> 
> It really shouldn't be synchronous.  The defintion of WB_SYNC_ALL
> is that it doesn't skip pages when initiating writeout, but you still
> have to wait for them to complete using filemap_fdatawait.
> 

Yes, I think my current patchset is wrong. It has cifs_writepages wait
for all of the writes to complete before returning in the WB_SYNC_ALL
case. I think it would probably be better to have it just return after
submitting the writes, and have the write completion handler resubmit
them if the error is retryable.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/13] cifs: don't fail writepages on -EAGAIN errors
Date: Thu, 16 Dec 2010 12:08:24 -0500
Message-ID: <20101216120824.37de7e38@tlielax.poochiereds.net>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-2-git-send-email-jlayton@redhat.com>
	<4D07383A.6000400@suse.de>
	<20101214071820.2aa4936b@tlielax.poochiereds.net>
	<AANLkTi=soXxgZMXoWrbx2_eJtGQR5iHncXtDO_dbWRX7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=soXxgZMXoWrbx2_eJtGQR5iHncXtDO_dbWRX7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 16 Dec 2010 10:35:12 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jeff,
> Sounds like this patch series is close to ready.  Are you respinning
> [only] patch 1 of 13?  Is this the easiest series of yours to
> review/merge (into cifs-2.6.git) first for 2.6.38-pre
> 

Getting close, yes. I've made some other changes and will end up
re-posting the set in the next week or so after a bit more testing.
FWIW, I made an effort to add in NT_CANCEL requests when the program is
killed, but it's really quite complicated.

Working on that has really demonstrated to me that there are some
significant problems with signal handling in the existing cifs code. I
don't think this patchset makes that any worse, but I'd like to be sure
before it goes in.

I've also got another set of patches that's probably easier to review
-- the one to clean up CONFIG_CIFS_EXPERIMENTAL. Let me know if
you want me to resend that one.

Beyond that, I have some one-off patches, at least one of which depends
on Pavel's cleanup of the open code. Some of those I haven't sent yet,
but will once you start merging things.

Finally, I'm still carrying this patch that I sent months ago:

    cifs: use CreationTime like an i_generation field

I'd like to know whether you plan to commit it or not.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

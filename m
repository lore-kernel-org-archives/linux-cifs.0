From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Mon, 13 Feb 2012 08:35:44 -0500
Message-ID: <20120213083544.486aa192@tlielax.poochiereds.net>
References: <1328810892-21925-1-git-send-email-piastry@etersoft.ru>
	<20120210132216.03badf59@tlielax.poochiereds.net>
	<4F38BB30.9030107@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F38BB30.9030107-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 13 Feb 2012 12:56:40 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> On 02/10/2012 11:52 PM, Jeff Layton wrote:
> > On Thu,  9 Feb 2012 21:08:12 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> > 
> >> Currently we do inc_nlink/drop_nlink for a parent directory for every
> >> mkdir and rmdir calls. That's wrong when POSIX extensions are disabled
> >> because in this case a server doesn't do the same things and returns
> >> the old value on the next QueryInfo request. As the result, we update
> >> our value with the server one and then decrement it on every rmdir
> >> call - go to negative nlink values.
> >>
> >> Fix this by doing inc_nlink/drop_nlink for parent directory in mkdir
> >> and rmdir in POSIX case only. Also add cERROR when nlink value <= 2
> >> and we still try to decrement it (possible broken servers).
> >>
> > 
> > Rather than doing that, I think it would be better not to do the
> > inc/dec_nlink in either case and instead to set cifsi->time on the
> > parent to 0 for both cases.
> > 
> > That should force it to have the directory attributes refetched at the
> > next opportunity. Since we're not doing that now, we're likely missing
> > out on stuff like directory mtime changes as well.
> > 
> 
> Hmm.. don't we have to do both? Keep the nlink value sane and force
> refetching attrs. Wondering if we don't update nlink what will happen in
> cases
> 
>    (a) when mkdir/rmdir is run in a tight loop
>    (b) when a dir is moved from one to another within the cifs mount
> 

I don't think so -- we either need to fake i_nlink and ignore the value
from the server, or treat the server as authoritative.

Trying to monkey with the nlink value on the client and overwriting it
with the value from the server is always going to be racy. I think the
only time it really matters is if you're using generic_drop_inode,
which we do when CIFS_MOUNT_SERVER_INUM is set.

That said, the values we get out of some servers for i_nlink are
non-sensical. Perhaps we'd be best off to just fake the i_nlink value
across the board. We have had people in the past complain that i_nlink
is always 0 in some cases.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

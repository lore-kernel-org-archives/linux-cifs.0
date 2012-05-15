From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] cifs: add a cache= option to better describe the
 different cache flavors
Date: Tue, 15 May 2012 15:11:40 -0400
Message-ID: <20120515151140.5fdd9577@tlielax.poochiereds.net>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
	<1335524179-1671-2-git-send-email-jlayton@redhat.com>
	<CAH2r5msGcUSo2JLq=qUvWUfm3ynA18-5dPyZDbMB=F-1=BtXCw@mail.gmail.com>
	<20120515150256.00206843@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120515150256.00206843-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 May 2012 15:02:56 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 15 May 2012 13:34:45 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Why is "fsc" (in particular caching of reads, to file, for oplocked
> > files) mutually exclusive with "strictcache" (write through of
> > non-oplocked files).
> > 
> 
> The main purpose of cache=fsc is to allow you to cache file data between
> reboots (or technically, between mounts). That is contingent on being
> able to tell whether the cache is actually valid after rebooting
> however.
> 
> cache=strict implies that you're following the cifs cache coherency
> protocol to the letter. The CIFS protocol effectively states that you
> are only allowed to cache file data while holding an oplock. Since you
> can't hold an oplock over a reboot, trusting fsc cached data across one
> would invalidate the guarantee that we try to provide with cache=strict.
> 

...and since we're on the subject, I got this back today from my
dochelp query about the protocol and windows' behavior:

---------------------------[snip]------------------------------------
Hi Jeff:

The SMB protocols do not have any specific requirement as to how much
or how little caching is allowed on the client side. An implementation
could very well "choose to batch writes for a short period of time"
even in the absence of an oplock/lease.  However, then there are no
data consistency guarantees between multiple readers and writers.
Oplocks/leases provide a mechanism for implementers to guarantee better
data consistency.

Windows in general does not do caching in the absence of oplock/lease.
The specific conditions in which caching without oplock/lease may
happen is implementation detail, not protocol.

Please let me know if it answers your question.

Regards,
Obaid Farooqi
Escalation Engineer | Microsoft
---------------------------[snip]------------------------------------

Which means precisely zilch to us of course. The only thing we can do
is try to behave as sanely as possible. I maintain that cache=strict as
a default is the safest course of action since it allows for reasonable
data integrity and locking behavior when multiple clients are
interacting with the same files.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

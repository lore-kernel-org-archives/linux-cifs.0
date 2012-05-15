From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] cifs: add a cache= option to better describe the
 different cache flavors
Date: Tue, 15 May 2012 15:02:56 -0400
Message-ID: <20120515150256.00206843@tlielax.poochiereds.net>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
	<1335524179-1671-2-git-send-email-jlayton@redhat.com>
	<CAH2r5msGcUSo2JLq=qUvWUfm3ynA18-5dPyZDbMB=F-1=BtXCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msGcUSo2JLq=qUvWUfm3ynA18-5dPyZDbMB=F-1=BtXCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 May 2012 13:34:45 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Why is "fsc" (in particular caching of reads, to file, for oplocked
> files) mutually exclusive with "strictcache" (write through of
> non-oplocked files).
> 

The main purpose of cache=fsc is to allow you to cache file data between
reboots (or technically, between mounts). That is contingent on being
able to tell whether the cache is actually valid after rebooting
however.

cache=strict implies that you're following the cifs cache coherency
protocol to the letter. The CIFS protocol effectively states that you
are only allowed to cache file data while holding an oplock. Since you
can't hold an oplock over a reboot, trusting fsc cached data across one
would invalidate the guarantee that we try to provide with cache=strict.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

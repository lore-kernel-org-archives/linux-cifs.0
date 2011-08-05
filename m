From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] cifs: cope with negative dentries in cifs_get_root
Date: Fri, 5 Aug 2011 15:54:29 +0100
Message-ID: <20110805145428.GS2203@ZenIV.linux.org.uk>
References: <1312549360-4317-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1312549360-4317-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 05, 2011 at 09:02:40AM -0400, Jeff Layton wrote:
> The loop around lookup_one_len doesn't handle the case where it might
> return a negative dentry, which can cause an oops on the next pass
> through the loop. Check for that and break out of the loop with an
> error of -ENOENT if there is one.

Ouch.  Nice catch and that one is my damn fault.  Do you want that one
to go through cifs or vfs tree?  ACK, in any case...

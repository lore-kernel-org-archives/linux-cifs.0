From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] cifs: move file_lock off stack in cifs_push_posix_locks
Date: Mon, 23 Jul 2012 18:40:16 +0100
Message-ID: <20120723174016.GG31729@ZenIV.linux.org.uk>
References: <1343064688-26053-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1343064688-26053-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 23, 2012 at 01:31:28PM -0400, Jeff Layton wrote:
> struct file_lock is pretty large, so we really don't want that on the
> stack in a potentially long call chain. Reorganize the arguments to
> CIFSSMBPosixLock to eliminate the need for that.
> 
> Eliminate the get_flag and simply use a non-NULL pLockInfo to indicate
> that this is a "get" operation. In order to do that, need to add a new
> loff_t argument for the start_offset.

Looks right...

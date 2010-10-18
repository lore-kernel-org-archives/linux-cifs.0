From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: update comments -
 [s/GlobalSMBSesLock/cifs_file_list_lock/g]
Date: Mon, 18 Oct 2010 14:38:32 -0400
Message-ID: <20101018143832.675f5be3@corrin.poochiereds.net>
References: <4CBC905A.5060007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBC905A.5060007-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Oct 2010 23:52:18 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> GlobalSMBSesLock is now cifs_file_list_lock. Update comments to reflect this.
> 
> OTOH, isn't there is a cleaner way instead of acquiring spin_lock and doing
> spin_unlock in succession in cifs_oplock_break to ensure we already grabbed
> the reference? Is this really needed?
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

I wish there were -- it's certainly ugly.

We need to make sure we have references held for the oplock break
workqueue job. Typically, we'd take those references first and then
queue the work. If something goes wrong however and we can't queue that
job, then we'd have to ensure that we put those references.

There's a problem here though, is_valid_oplock_break is run in cifsd
thread. If we end up putting the references in this context, we can end
up tearing things down and doing blocking SMB calls. If cifsd does
that, it'll deadlock.

We could (in principle) add a completion variable or something for
this, but the lock/unlock works just as well for this purpose.

Comment fix looks fine:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

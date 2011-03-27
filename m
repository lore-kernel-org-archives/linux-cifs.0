From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
 (try #2)
Date: Sun, 27 Mar 2011 15:42:46 -0500
Message-ID: <AANLkTikX82d36rS99JHyuG6yH0d_qki-Ak0dxuwQ6-x5@mail.gmail.com>
References: <1301127285-3573-1-git-send-email-piastry@etersoft.ru>
	<20110327064857.6fc346f0@tlielax.poochiereds.net>
	<AANLkTimOx-P95k-Jvg_ESiYii7bd7RzWYpjxQnkvAf7k@mail.gmail.com>
	<AANLkTi=b7k8eCRK0eT9DwDMkGFDkX0hJjPFVjx4se5=x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=b7k8eCRK0eT9DwDMkGFDkX0hJjPFVjx4se5=x@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Mar 27, 2011 at 2:10 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> 2011/3/27 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> As for fsycn logic - as I understand this call - it ought to
> synchronize data between a cache and storage device. But if we can't
> free pages, we don't successfully complete this synchronization - so,
> reporting -EBUSY error here doesn't seem wrong to me (may be we should
> set -EIO error code - according to the man page). If I am mistaken,
> please, explain your points.

To me synchronizing means that all data was written to the
server that was dirty at the time of the call.

When we try to free the page we have already flushed all data that
was dirty at the time the fsync call began, but there is nothing
that does or should prevent other processes from writing to that file.



-- 
Thanks,

Steve

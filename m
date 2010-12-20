From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 04/18] cifs: clean up accesses to midCount
Date: Mon, 20 Dec 2010 16:22:52 +0530
Message-ID: <4D0F3584.8040808@suse.de>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com> <1292598497-29796-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 08:38 PM, Jeff Layton wrote:
> It's an atomic_t and the code accesses the "counter" field in it directly
> instead of using atomic_read(). It also is sometimes accessed under a
> spinlock and sometimes not. Move it out of the spinlock since we don't need
> belt-and-suspenders for something that's just informational.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |    2 +-
>  fs/cifs/connect.c    |    2 +-
>  fs/cifs/transport.c  |    6 +++---
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

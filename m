From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 02/13] cifs: eliminate oflags option from cifs_new_fileinfo
Date: Sun, 17 Oct 2010 20:38:50 +0530
Message-ID: <4CBB1182.5050009@suse.de>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com> <1287171248-464-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287171248-464-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/16/2010 01:03 AM, Jeff Layton wrote:
> Eliminate the poor, misunderstood "oflags" option from cifs_new_fileinfo.
> The callers mostly pass in the filp->f_flags here.
> 
> That's not correct however since we're checking that value for
> the presence of FMODE_READ. Luckily that only affects how the f_list is
> ordered. What it really wants here is the file->f_mode. Just use that
> field from the filp to determine it.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |    3 +--
>  fs/cifs/dir.c       |    9 ++++-----
>  fs/cifs/file.c      |    5 ++---
>  3 files changed, 7 insertions(+), 10 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

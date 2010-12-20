From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 01/18] cifs: don't fail writepages on -EAGAIN errors
Date: Mon, 20 Dec 2010 16:23:02 +0530
Message-ID: <4D0F358E.3070603@suse.de>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com> <1292598497-29796-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 08:38 PM, Jeff Layton wrote:
> If CIFSSMBWrite2 returns -EAGAIN, then the error should be considered
> temporary. CIFS should retry the write instead of setting an error on
> the mapping and returning.
> 
> For WB_SYNC_ALL, just retry the write immediately. In the WB_SYNC_NONE
> case, call redirty_page_for_writeback on all of the pages that didn't
> get written out and then move on.
> 
> Also, fix up the handling of a short write with a successful return
> code. MS-CIFS says that 0 bytes_written means ENOSPC or EFBIG. It
> doesn't mention what a short, but non-zero write means, so for now
> treat it as we would an -EAGAIN return.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/file.c |   49 +++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 37 insertions(+), 12 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

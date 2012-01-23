From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 50/50] CIFS: Change Makefile to support CONFIG_CIFS_SMB2
Date: Mon, 23 Jan 2012 06:36:34 -0500
Message-ID: <20120123063634.4aa95a1d@tlielax.poochiereds.net>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
	<1327048511-2342-50-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-50-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Jan 2012 12:35:11 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/Makefile |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> index 005d524..0f72f14 100644
> --- a/fs/cifs/Makefile
> +++ b/fs/cifs/Makefile
> @@ -15,3 +15,7 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
>  cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
>  
>  cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
> +
> +cifs-$(CONFIG_CIFS_SMB2) += smb2pdu.o smb2misc.o smb2transport.o maperror.o \
> +			    smb2inode.o smb2dir.o smb2file.o smb2readdir.o \
> +			    smb2link.o


I'm a bit concerned about the order of the patches. The idea here
seems to be: "merge all of the code needed to support SMB2 with it
disabled, and then flip a switch to turn it all on". Experience has
shown that that strategy of merging large scale changes tends to be
problematic.

Bugs that creep in, but because the "switch" is in the last few patches
we can't bisect to narrow down the cause. What might be better is to
move the last few patches earlier in the series. That would allow
someone to mount a SMB2 filesystem, even if some things on it don't
actually work yet.

If, for instance, an oops creeps in and we're not sure what's causing
it, we could bisect down to an earlier patch and narrow down the amount
of changes that we'll need to look at.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: fix potential use-after-free in cifs_oplock_break_put
Date: Thu, 11 Nov 2010 14:08:16 +0530
Message-ID: <4CDBAB78.2020005@suse.de>
References: <1289402350-14218-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289402350-14218-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/10/2010 08:49 PM, Jeff Layton wrote:
> cfile may very well be freed after the cifsFileInfo_put. Make sure we
> have a valid pointer to the superblock for cifs_sb_deactive.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/file.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 06c3e83..b857ce5 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2271,8 +2271,10 @@ void cifs_oplock_break_get(struct cifsFileInfo *cfile)
>  
>  void cifs_oplock_break_put(struct cifsFileInfo *cfile)
>  {
> +	struct super_block *sb = cfile->dentry->d_sb;
> +
>  	cifsFileInfo_put(cfile);
> -	cifs_sb_deactive(cfile->dentry->d_sb);
> +	cifs_sb_deactive(sb);
>  }
>  

Looks correct to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

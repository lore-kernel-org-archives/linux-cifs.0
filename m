From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: fix automount for DFS shares
Date: Mon, 17 Oct 2011 06:45:42 -0400
Message-ID: <20111017064542.036ff6bb@tlielax.poochiereds.net>
References: <1318845543-15085-1-git-send-email-gerlando.falauto@keymile.com>
	<1318845543-15085-2-git-send-email-gerlando.falauto@keymile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318845543-15085-2-git-send-email-gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 17 Oct 2011 11:59:03 +0200
Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org> wrote:

> Automounting directories are now invalidated by .d_revalidate()
> so to be d_instantiate()d again with the right DCACHE_NEED_AUTOMOUNT
> flag
> 
> Signed-off-by: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/cifs/dir.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 9ea65cf..67f54d3 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -637,8 +637,13 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
>  	if (direntry->d_inode) {
>  		if (cifs_revalidate_dentry(direntry))
>  			return 0;
> -		else
> +		else {
> +			/* We want automonting inodes to be
> +			 * considered invalid or so */

The comment is a little unclear. A better comment might be -- "Forcibly
invalidate automounting inodes", or something along those lines...

> +			if (IS_AUTOMOUNT(direntry->d_inode))
> +				return 0;
>  			return 1;
> +		}
>  	}
>  
>  	/*

The patch itself looks reasonable though...

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

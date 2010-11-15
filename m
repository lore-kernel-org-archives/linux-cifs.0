From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: handle cifs_get_tcon() errors properly
Date: Mon, 15 Nov 2010 08:25:35 -0500
Message-ID: <20101115082535.0d7200a5@tlielax.poochiereds.net>
References: <1289825123-13716-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289825123-13716-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 15 Nov 2010 18:15:23 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> cifs_get_tcon() could return any of the following errors:
> -ENOMEM/-ENODEV/EREMOTEIO. We should follow the DFS referral code path only
> when we get -EREMOTEIO (STATUS_PATH_NOT_COVERED) from the server and not
> otherwise.
> 
> Compile-tested only.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/connect.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 251a17c..c3a2323 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2780,7 +2780,10 @@ try_mount_again:
>  	if (IS_ERR(tcon)) {
>  		rc = PTR_ERR(tcon);
>  		tcon = NULL;
> -		goto remote_path_check;
> +		if (rc == -EREMOTEIO)
> +			goto remote_path_check;
> +		else
> +			goto mount_fail_check;
>  	}
>  
>  	/* do not care if following two calls succeed - informational */

Don't you mean "EREMOTE" here? I've always interpreted "EREMOTEIO" to
mean that the server had the equivalent of an I/O error, whereas
"EREMOTE" means "Object is remote".

I don't see how this patch materially changes anything. Pseudocode,
assuming that rc == -EREMOTE:

remote_path_check:
        /* check if a whole path (including prepath) is not remote */
        if (!rc && cifs_sb->prepathlen && tcon) {
		/* stuff we won't hit because rc is non-zero */
	}

	if (rc == -EREMOTE) {
		/* handle a DFS referral */
	}

        if (rc)
                goto mount_fail_check;

I'll grant that cifs_mount is still a mess, but I'm not sure this
really improves anything.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Subject: [PATCH] mount.cifs: remove redundant error assignment
Date: Wed, 4 Aug 2010 06:53:38 -0400
Message-ID: <20100804065338.6fa9d16b@tlielax.poochiereds.net>
References: <4C591054.1070007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C591054.1070007-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 04 Aug 2010 12:31:40 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> 
> ... as it is done anyway at add_mtab_exit.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  mount.cifs.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 9f04261..49fdd08 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1513,7 +1513,6 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
>  	rc = lock_mtab();
>  	if (rc) {
>  		fprintf(stderr, "cannot lock mtab");
> -		rc = EX_FILEIO;
>  		goto add_mtab_exit;
>  	}
>  
		^^^^^^^^^^^
This seems to be fine.

> @@ -1521,7 +1520,6 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
>  	if (!pmntfile) {
>  		fprintf(stderr, "could not update mount table\n");
>  		unlock_mtab();
> -		rc = EX_FILEIO;
>  		goto add_mtab_exit;
>  	}
		^^^^^^^^^^^
This looks wrong. If we don't set rc here, then it'll still be 0 and
the code at add_mtab_exit won't set it to EX_FILEIO.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: make sure we ignore the credentials= and cred=
 options
Date: Thu, 03 May 2012 12:18:48 +0100
Message-ID: <1336043928.2948.13.camel@localhost>
References: <1335981808-3885-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ronald645-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335981808-3885-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2012-05-02 at 14:03 -0400, Jeff Layton wrote:
> Older mount.cifs programs passed this on to the kernel after parsing
> the file. Make sure the kernel ignores that option.
> 
> Should fix:
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=43195
> 
> Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Ronald <ronald645-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a75902b..5dcc551 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -215,6 +215,8 @@ static const match_table_t cifs_mount_option_tokens = {
>  
>  	{ Opt_ignore, "cred" },
>  	{ Opt_ignore, "credentials" },
> +	{ Opt_ignore, "cred=%s" },
> +	{ Opt_ignore, "credentials=%s" },

We don't expect cred/credentials by themselves in the mount options
list. Instead of adding the new checks, we can instead simply replace
the original lines with ones containing the string.

-       { Opt_ignore, "cred" },
-       { Opt_ignore, "credentials" },
+       { Opt_ignore, "cred=%s" },
+       { Opt_ignore, "credentials=%s" },

Sachin Prabhu

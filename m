From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cifs: fix misspelling of "forcedirectio"
Date: Wed, 16 May 2012 12:31:20 +0100
Message-ID: <1337167880.3236.1.camel@localhost>
References: <1337166781-18307-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337166781-18307-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2012-05-16 at 07:13 -0400, Jeff Layton wrote:
> ...and add a "directio" synonym since that's what the manpage has
> always advertised.
> 
> Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5dcc551..e0b56d7 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -164,7 +164,8 @@ static const match_table_t cifs_mount_option_tokens = {
>  	{ Opt_sign, "sign" },
>  	{ Opt_seal, "seal" },
>  	{ Opt_direct, "direct" },
> -	{ Opt_direct, "forceddirectio" },
> +	{ Opt_direct, "directio" },
> +	{ Opt_direct, "forcedirectio" },
>  	{ Opt_strictcache, "strictcache" },
>  	{ Opt_noac, "noac" },
>  	{ Opt_fsc, "fsc" },

ACK

Sachin Prabhu

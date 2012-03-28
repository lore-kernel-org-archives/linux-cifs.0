From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Remove unnecessary check for NULL in password parser
Date: Wed, 28 Mar 2012 13:23:01 -0400
Message-ID: <20120328132301.792d5f35@corrin.poochiereds.net>
References: <20120328104541.GC29022@elgon.mountain>
	<1332933181.2144.11.camel@localhost>
	<20120328113146.GE3200@mwanda>
	<1332954428.9998.5.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	smfrench <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332954428.9998.5.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 28 Mar 2012 18:07:08 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> The password parser has an unnecessary check for a NULL value which
> triggers warnings in source checking tools. The code contains artifacts
> from the old parsing code which are no longer required.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 302a15c..0511fdb 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1565,8 +1565,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  
>  			/* Obtain the value string */
>  			value = strchr(data, '=');
> -			if (value != NULL)
> -				*value++ = '\0';
> +			value++;
>  
>  			/* Set tmp_end to end of the string */
>  			tmp_end = (char *) value + strlen(value);

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

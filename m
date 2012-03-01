From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] cifs: writing past end of struct in
 cifs_convert_address()
Date: Thu, 1 Mar 2012 06:47:32 -0500
Message-ID: <20120301064732.135a5383@tlielax.poochiereds.net>
References: <20120301070652.GA6959@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120301070652.GA6959-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 1 Mar 2012 10:06:52 +0300
Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> "s6->sin6_scope_id" is an int bits but strict_strtoul() writes a long
> so this can corrupt memory on 64 bit systems.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 73e47e8..cab99b5 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -197,8 +197,7 @@ cifs_convert_address(struct sockaddr *dst, const char *src, int len)
>  		memcpy(scope_id, pct + 1, slen);
>  		scope_id[slen] = '\0';
>  
> -		rc = strict_strtoul(scope_id, 0,
> -					(unsigned long *)&s6->sin6_scope_id);
> +		rc = kstrtouint(scope_id, 0, &s6->sin6_scope_id);
>  		rc = (rc == 0) ? 1 : 0;
>  	}
>  

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

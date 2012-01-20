From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: fetch credentials out of keyring for non-krb5 auth
 multiuser mounts
Date: Fri, 20 Jan 2012 07:23:27 -0500
Message-ID: <20120120072327.20218d24@tlielax.poochiereds.net>
References: <20120120082132.GA21512@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120120082132.GA21512-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Jan 2012 11:21:32 +0300
Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Hi Jeff,
> 
> The patch 8a8798a5ff90: "cifs: fetch credentials out of keyring for 
> non-krb5 auth multiuser mounts" from Jan 17, 2012, has a problem here:
> 
> +       upayload = key->payload.data;
> +       if (IS_ERR_OR_NULL(upayload)) {
> +               rc = PTR_ERR(key);
>                              ^^^
> "key" is a valid pointer not an ERR_PTR.  Also "upayload" can be NULL
> and PTR_ERR(NULL) is success.
> 
> +               goto out_key_put;
> +       }
> 
> regards,
> dan carpenter
> 

Doh! Good catch. Steve has already queued this patch for inclusion, but
I'll spin up a patch to fix it.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

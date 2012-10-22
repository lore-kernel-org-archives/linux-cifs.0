From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] ASN.1: Define indefinite length marker constant
Date: Mon, 22 Oct 2012 14:40:21 -0400
Message-ID: <20121022144021.1b1a3135@corrin.poochiereds.net>
References: <20121022142318.6989.5077.stgit@warthog.procyon.org.uk>
	<20121022142333.6989.61832.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121022142333.6989.61832.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Oct 2012 15:23:33 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Define a constant to hold the marker value seen in an indefinite-length
> element.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  include/linux/asn1.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/asn1.h b/include/linux/asn1.h
> index 5c3f4e4..eed6982 100644
> --- a/include/linux/asn1.h
> +++ b/include/linux/asn1.h
> @@ -64,4 +64,6 @@ enum asn1_tag {
>  	ASN1_LONG_TAG	= 31	/* Long form tag */
>  };
>  
> +#define ASN1_INDEFINITE_LENGTH 0x80
> +
>  #endif /* _LINUX_ASN1_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks fine, though might make more sense to fold this into the next
patch since you actually make use of it there.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix srcip_matches() for ipv6
Date: Thu, 17 Jan 2013 11:24:12 -0500
Message-ID: <20130117112412.095f7aef@corrin.poochiereds.net>
References: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nickolai Zeldovich <nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358390177-24422-1-git-send-email-nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Jan 2013 21:36:17 -0500
Nickolai Zeldovich <nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org> wrote:

> srcip_matches() previously had code like this:
> 
>   srcip_matches(..., struct sockaddr *rhs) {
>     /* ... */
>     struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *) &rhs;
>     return ipv6_addr_equal(..., &vaddr6->sin6_addr);
>   }
> 
> which interpreted the values on the stack after the 'rhs' pointer as an
> ipv6 address.  The correct thing to do is to use 'rhs', not '&rhs'.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 17c3643..12b3da3 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1917,7 +1917,7 @@ srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
>  	}
>  	case AF_INET6: {
>  		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> -		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
> +		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
>  		return ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6_addr);
>  	}
>  	default:

Nice catch...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

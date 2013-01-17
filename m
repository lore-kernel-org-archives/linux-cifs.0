From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix srcip_matches() for ipv6
Date: Wed, 16 Jan 2013 21:51:42 -0600
Message-ID: <CAH2r5mv=hMN7yHLf0wLMnyjpeQRj-1SmN8n2581AMFZput5nqg@mail.gmail.com>
References: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nickolai Zeldovich <nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358390177-24422-1-git-send-email-nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Makes sense.

How did you discover this - did you have an ipv6 test case or by
inspection or ...?

On Wed, Jan 16, 2013 at 8:36 PM, Nickolai Zeldovich
<nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org> wrote:
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
>         }
>         case AF_INET6: {
>                 struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> -               struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
> +               struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
>                 return ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6_addr);
>         }
>         default:
> --
> 1.7.10.4
>



-- 
Thanks,

Steve

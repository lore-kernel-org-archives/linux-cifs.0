From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: switch CIFSSMBQAllEAs to use memcmp
Date: Wed, 24 Aug 2011 12:04:12 +0530
Message-ID: <4E549B64.6070308@suse.de>
References: <1313803104-31810-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313803104-31810-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/20/2011 06:48 AM, Jeff Layton wrote:
> ...as that's more efficient when we know that the lengths are equal.
> 
> Reported-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index f4d0988..7bac906 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -5849,7 +5849,7 @@ QAllEAsRetry:
>  
>  		if (ea_name) {
>  			if (ea_name_len == name_len &&
> -			    strncmp(ea_name, temp_ptr, name_len) == 0) {
> +			    memcmp(ea_name, temp_ptr, name_len) == 0) {
>  				temp_ptr += name_len + 1;
>  				rc = value_len;
>  				if (buf_size == 0)


Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

We generally don't query for all EAs very often. Not sure whether how
much it help improve efficiency. But, I do agree that memxxx variants
are better when we know the length.


-- 
Suresh Jayaraman

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Convert properly UTF-8 to UTF-16
Date: Tue, 31 Jul 2012 07:15:11 -0400
Message-ID: <20120731071511.7746b2f4@corrin.poochiereds.net>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDFFB08CFE@LONPMAILBOX01.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7CE799CC0E4DE04B88D5FDF226E18AC2CDFFB08CFE-aFusIB7tbcLeU4JHVX8hdHnr0TU713UqXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 31 Jul 2012 11:45:35 +0100
Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:

> 
> wchar_t is currently 16bit so converting a utf8 encoded characters not
> in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead to a
> -EINVAL return. This patch detect utf8 in cifs_strtoUTF16 and add
> special
> code calling utf8s_to_utf16s.
> 
> Signed-off-by: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_unicode.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 7dab9c0..a798e01 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -203,6 +203,19 @@ cifs_strtoUTF16(__le16 *to, const char *from, int
> len,
>  	int i;
>  	wchar_t wchar_to; /* needed to quiet sparse */
>  
> +	if (!strcmp(codepage->charset, "utf8")) {
> +		i  = utf8s_to_utf16s(from, len, UTF16_LITTLE_ENDIAN,
> +				       (wchar_t *) to, len);

	Much nicer, but...

	You're using "len" both for "inlen" and "maxout". Won't that
	give you a truncated string if there are single-byte characters
	that convert to multibyte ones?

> +		if (i >= 0)
> +			goto success;
> +		/*
> +		 * if fails fall back to UCS encoding as this
> +		 * function should not return negative values
> +		 * currently can fail only if source contains
> +		 * invalid encoded characters
> +		 */
> +	}
> +
>  	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
>  		charlen = codepage->char2uni(from, len, &wchar_to);
>  		if (charlen < 1) {
> @@ -215,6 +228,7 @@ cifs_strtoUTF16(__le16 *to, const char *from, int
> len,
>  		put_unaligned_le16(wchar_to, &to[i]);
>  	}
>  
> +success:
>  	put_unaligned_le16(0, &to[i]);
>  	return i;
>  }


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

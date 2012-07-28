From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: ALPHA: advice for a patch to CIFS
Date: Sat, 28 Jul 2012 08:06:51 -0400
Message-ID: <20120728080651.305f9bab@tlielax.poochiereds.net>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDF8E31455@LONPMAILBOX01.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7CE799CC0E4DE04B88D5FDF226E18AC2CDF8E31455-aFusIB7tbcLeU4JHVX8hdHnr0TU713UqXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Jul 2012 20:13:42 +0100
Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:

> Hi,
>   I'm currently trying to support utf-16 with characters not in plane 0.
> 
> I'm currently end up with this patch. Currently is not against latest
> kernel but the problem still reside in last git kernel.
> 
> wchar_t is currently 16bit so converting a utf8 encoded characters not
> in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead to a
> -EINVAL return. This patch detect utf8 in cifs_strtoUCS and add special
> code calling directly utf8_to_utf32.
> 
> Does it sound a good patch or just a bad hack. Perhaps would be better
> to change char2uni converting to unicode_t (32bit) instead of wchar_t
> but probably many code have to be checked in order to make sure it does
> not lead to wrong conversions, overflows or other bad stuff.
> 
> Is it worth working in this hacking way? I'd like to upstream this
> patch.
> 
> 
> diff -r c2325d754e8d fs/cifs/cifs_unicode.c
> --- a/fs/cifs/cifs_unicode.c	Fri Jul 27 15:12:23 2012 +0100
> +++ b/fs/cifs/cifs_unicode.c	Fri Jul 27 19:09:04 2012 +0100
> @@ -192,22 +192,40 @@ cifs_strtoUCS(__le16 *to, const char *fr

That function doesn't exist anymore. You should base this on a more
recent upstream tree.

>  {
>  	int charlen;
>  	int i;
> -	wchar_t *wchar_to = (wchar_t *)to; /* needed to quiet sparse */
> +	int is_utf8 = !strcmp(codepage->charset, "utf8");

Gross...there must be a better way to do that?


> +	wchar_t wchar_to; /* needed to quiet sparse */
> +	unicode_t uni;
>  
>  	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
>  
>  		/* works for 2.4.0 kernel or later */
> -		charlen = codepage->char2uni(from, len, &wchar_to[i]);
> +		if (is_utf8) {
> +			charlen = utf8_to_utf32(from, len, &uni);
> +		} else {
> +			charlen = codepage->char2uni(from, len, &wchar_to);
> +			uni = wchar_to;
> +		}
> +
>  		if (charlen < 1) {
>  			cERROR(1,
>  			       ("strtoUCS: char2uni of %d returned %d",
>  				(int)*from, charlen));
>  			/* A question mark */
> -			to[i] = cpu_to_le16(0x003f);
> +			wchar_to = 0x003f;
>  			charlen = 1;
> -		} else
> -			to[i] = cpu_to_le16(wchar_to[i]);
> -
> +		} else if (uni < 0x10000) {

	"uni" will be unintialized here if is_utf8 is false.

> +			wchar_to = uni;
> +		} else if (uni < 0x110000) {
> +			uni -= 0x10000;
> +			to[i++] = cpu_to_le16(0xD800 | (uni >> 10));
> +			wchar_to = 0xDC00 | (uni & 0x3FF);
> +		} else {
> +			cERROR(1,
> +			       ("strtoUCS: char2uni of %d returned %d",
> +				(int)*from, charlen));
> +			wchar_to = 0x003f;
> +		}
> +		to[i] = cpu_to_le16(wchar_to);
>  	}
>  
>  	to[i] = 0;
> 
> Signed-off-by: "Frediano Ziglio" <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> 
> Regards,
>   Frediano
> 

The basic idea looks ok, but I agree that this could use some more
commenting and/or some #define'd constants. Does the conversion of on
the wire characters to the local charset need similar work?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

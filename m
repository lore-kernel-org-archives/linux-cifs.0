From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: add missing unicode handling routines needed for
 smb2
Date: Mon, 7 Mar 2011 10:53:38 -0500
Message-ID: <20110307105338.69e862d0@tlielax.poochiereds.net>
References: <AANLkTinVkEHg-DOp6+0Jq+_vteYaix+nqt=QNFJ7nSML@mail.gmail.com>
	<20110307094123.065e59c6@tlielax.poochiereds.net>
	<AANLkTinnHSpJMMvTVU77fgcgZWum6Ovb5SfOSxPbSfSG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinnHSpJMMvTVU77fgcgZWum6Ovb5SfOSxPbSfSG-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 7 Mar 2011 09:07:52 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Mar 7, 2011 at 8:41 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> wrote:
> > On Sun, 6 Mar 2011 22:17:32 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > This patch appears to be malformed...
> 
> Cut-paste or mailer error.
> 
> commit 11471483dbfd2f4235346acf9e181a549b3979a1
> Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Date:   Mon Mar 7 04:15:05 2011 +0000
> 
>     [CIFS] Add missing unicode handling routines needed by smb2
> 
>     Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 

Given that there are no callers of these functions, it's hard to
understand the need for this. These look like cut and paste of the cifs
functions. Why do we need separate routines for this for smb2?

> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index fc0fd4f..9dd2682 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -333,3 +333,64 @@ ctoUCS_out:
>  	return i;
>  }
> 
> +#ifdef CONFIG_CIFS_SMB2
> +/*
> + * smb2_local_to_ucs2_bytes - how long will a string be after conversion?
> + * @from - pointer to input string
> + * @maxbytes - don't go past this many bytes of input string
> + * @codepage - source codepage
> + *
> + * Walk a string and return the number of bytes that the string will
> + * be after being converted to the given charset, not including any null
> + * termination required. Don't walk past maxbytes in the source buffer.
> + */
> +
> +int
> +smb2_local_to_ucs2_bytes(const char *from, int len,
> +			  const struct nls_table *codepage)
> +{
> +	int charlen;
> +	int i;
> +	wchar_t wchar_to;
> +
> +	if (from == NULL)
> +		return 0;
> +	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
> +		charlen = codepage->char2uni(from, len, &wchar_to);
> +		/* Failed conversion defaults to a question mark */
> +		if (charlen < 1)
> +			charlen = 1;
> +	}
> +	return 2 * i; /* UCS characters are two bytes */
> +}

Don't the converted characters need to be little-endian?

> +
> +/*
> + * smb2_strndup_to_ucs - copy a string to wire format from the local codepage
> + * @src - source string
> + * @maxlen - don't walk past this many bytes in the source string
> + * @ucslen - the length of the allocated string in bytes (including null)
> + * @codepage - source codepage
> + *
> + * Take a string convert it from the local codepage to UCS2 and
> + * put it in a new buffer. Returns a pointer to the new string or NULL on
> + * error.
> + */
> +__le16 *
> +smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs_len,
> +	     const struct nls_table *codepage)
> +{
> +	int len;
> +	__le16 *dst;
> +
> +	len = smb2_local_to_ucs2_bytes(src, maxlen, codepage);
> +	len += 2; /* NULL */
> +	dst = kmalloc(len, GFP_KERNEL);
> +	if (!dst) {
> +		*ucs_len = 0;
> +		return NULL;
> +	}
> +	cifs_strtoUCS(dst, src, maxlen, codepage);
> +	*ucs_len = len;
> +	return dst;
> +}
> +#endif /* CONFIG_CIFS_SMB2 */
> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> index 7fe6b52..a56dfbc 100644
> --- a/fs/cifs/cifs_unicode.h
> +++ b/fs/cifs/cifs_unicode.h
> @@ -377,4 +377,11 @@ UniStrlwr(register wchar_t *upin)
> 
>  #endif
> 
> +#ifdef CONFIG_CIFS_SMB2
> +extern int smb2_local_to_ucs2_bytes(const char *from, int len,
> +				    const struct nls_table *codepage);
> +extern __le16 *smb2_strndup_to_ucs(const char *src, const int maxlen,
> +				   int *ucs_len, const struct nls_table *cp);
> +#endif /* CONFIG_CIFS_SMB2 */
> +
>  #endif /* _CIFS_UNICODE_H */
> 

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

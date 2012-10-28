From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] CIFS: Use OID registry facility
Date: Sun, 28 Oct 2012 07:22:07 -0400
Message-ID: <20121028072207.0e69097d@tlielax.poochiereds.net>
References: <20121022142318.6989.5077.stgit@warthog.procyon.org.uk>
	<20121022142326.6989.45552.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121022142326.6989.45552.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Oct 2012 15:23:26 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Use the OID registry facility from fs/cifs/asn1.c as that converts known OIDs
> into an enum which should speed up comparison.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  fs/cifs/Kconfig              |    1 
>  fs/cifs/asn1.c               |  156 ++++++++----------------------------------
>  include/linux/oid_registry.h |    6 ++
>  3 files changed, 36 insertions(+), 127 deletions(-)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 2075ddf..0f7a0a7 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -10,6 +10,7 @@ config CIFS
>  	select CRYPTO_ECB
>  	select CRYPTO_DES
>  	select CRYPTO_SHA256
> +	select OID_REGISTRY
>  	help
>  	  This is the client VFS module for the Common Internet File System
>  	  (CIFS) protocol which is the successor to the Server Message Block
> diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
> index cfd1ce3..3a7b2b6 100644
> --- a/fs/cifs/asn1.c
> +++ b/fs/cifs/asn1.c
> @@ -22,6 +22,7 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
> +#include <linux/oid_registry.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifs_debug.h"
> @@ -76,17 +77,6 @@
>  #define ASN1_ERR_DEC_LENGTH_MISMATCH	4
>  #define ASN1_ERR_DEC_BADVALUE		5
>  
> -#define SPNEGO_OID_LEN 7
> -#define NTLMSSP_OID_LEN  10
> -#define KRB5_OID_LEN  7
> -#define KRB5U2U_OID_LEN  8
> -#define MSKRB5_OID_LEN  7
> -static unsigned long SPNEGO_OID[7] = { 1, 3, 6, 1, 5, 5, 2 };
> -static unsigned long NTLMSSP_OID[10] = { 1, 3, 6, 1, 4, 1, 311, 2, 2, 10 };
> -static unsigned long KRB5_OID[7] = { 1, 2, 840, 113554, 1, 2, 2 };
> -static unsigned long KRB5U2U_OID[8] = { 1, 2, 840, 113554, 1, 2, 2, 3 };
> -static unsigned long MSKRB5_OID[7] = { 1, 2, 840, 48018, 1, 2, 2 };
> -
>  /*
>   * ASN.1 context.
>   */
> @@ -397,95 +387,10 @@ asn1_octets_decode(struct asn1_ctx *ctx,
>  	return 1;
>  } */
>  
> -static unsigned char
> -asn1_subid_decode(struct asn1_ctx *ctx, unsigned long *subid)
> +static enum OID
> +asn1_oid_decode(struct asn1_ctx *ctx, unsigned char *eoc)
>  {
> -	unsigned char ch;
> -
> -	*subid = 0;
> -
> -	do {
> -		if (!asn1_octet_decode(ctx, &ch))
> -			return 0;
> -
> -		*subid <<= 7;
> -		*subid |= ch & 0x7F;
> -	} while ((ch & 0x80) == 0x80);
> -	return 1;
> -}
> -
> -static int
> -asn1_oid_decode(struct asn1_ctx *ctx,
> -		unsigned char *eoc, unsigned long **oid, unsigned int *len)
> -{
> -	unsigned long subid;
> -	unsigned int size;
> -	unsigned long *optr;
> -
> -	size = eoc - ctx->pointer + 1;
> -
> -	/* first subid actually encodes first two subids */
> -	if (size < 2 || size > UINT_MAX/sizeof(unsigned long))
> -		return 0;
> -
> -	*oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);
> -	if (*oid == NULL)
> -		return 0;
> -
> -	optr = *oid;
> -
> -	if (!asn1_subid_decode(ctx, &subid)) {
> -		kfree(*oid);
> -		*oid = NULL;
> -		return 0;
> -	}
> -
> -	if (subid < 40) {
> -		optr[0] = 0;
> -		optr[1] = subid;
> -	} else if (subid < 80) {
> -		optr[0] = 1;
> -		optr[1] = subid - 40;
> -	} else {
> -		optr[0] = 2;
> -		optr[1] = subid - 80;
> -	}
> -
> -	*len = 2;
> -	optr += 2;
> -
> -	while (ctx->pointer < eoc) {
> -		if (++(*len) > size) {
> -			ctx->error = ASN1_ERR_DEC_BADVALUE;
> -			kfree(*oid);
> -			*oid = NULL;
> -			return 0;
> -		}
> -
> -		if (!asn1_subid_decode(ctx, optr++)) {
> -			kfree(*oid);
> -			*oid = NULL;
> -			return 0;
> -		}
> -	}
> -	return 1;
> -}
> -
> -static int
> -compare_oid(unsigned long *oid1, unsigned int oid1len,
> -	    unsigned long *oid2, unsigned int oid2len)
> -{
> -	unsigned int i;
> -
> -	if (oid1len != oid2len)
> -		return 0;
> -	else {
> -		for (i = 0; i < oid1len; i++) {
> -			if (oid1[i] != oid2[i])
> -				return 0;
> -		}
> -		return 1;
> -	}
> +	return look_up_OID(ctx->pointer, eoc - ctx->pointer);
>  }
>  
>  	/* BB check for endian conversion issues here */
> @@ -497,8 +402,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	struct asn1_ctx ctx;
>  	unsigned char *end;
>  	unsigned char *sequence_end;
> -	unsigned long *oid = NULL;
> -	unsigned int cls, con, tag, oidlen, rc;
> +	unsigned int cls, con, tag, rc;
>  
>  	/* cifs_dump_mem(" Received SecBlob ", security_blob, length); */
>  
> @@ -519,12 +423,8 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	if (rc) {
>  		if ((tag == ASN1_OJI) && (con == ASN1_PRI) &&
>  		    (cls == ASN1_UNI)) {
> -			rc = asn1_oid_decode(&ctx, end, &oid, &oidlen);
> -			if (rc) {
> -				rc = compare_oid(oid, oidlen, SPNEGO_OID,
> -						 SPNEGO_OID_LEN);
> -				kfree(oid);
> -			}
> +			if (asn1_oid_decode(&ctx, end) != OID_SPNEGO)
> +				rc = 0;
>  		} else
>  			rc = 0;
>  	}
> @@ -588,26 +488,28 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  			return 0;
>  		}
>  		if ((tag == ASN1_OJI) && (con == ASN1_PRI)) {
> -			if (asn1_oid_decode(&ctx, end, &oid, &oidlen)) {
> -
> -				cFYI(1, "OID len = %d oid = 0x%lx 0x%lx "
> -					"0x%lx 0x%lx", oidlen, *oid,
> -					*(oid + 1), *(oid + 2), *(oid + 3));
> -
> -				if (compare_oid(oid, oidlen, MSKRB5_OID,
> -						MSKRB5_OID_LEN))
> -					server->sec_mskerberos = true;
> -				else if (compare_oid(oid, oidlen, KRB5U2U_OID,
> -						     KRB5U2U_OID_LEN))
> -					server->sec_kerberosu2u = true;
> -				else if (compare_oid(oid, oidlen, KRB5_OID,
> -						     KRB5_OID_LEN))
> -					server->sec_kerberos = true;
> -				else if (compare_oid(oid, oidlen, NTLMSSP_OID,
> -						     NTLMSSP_OID_LEN))
> -					server->sec_ntlmssp = true;
> -
> -				kfree(oid);
> +			enum OID oid = asn1_oid_decode(&ctx, end);
> +			if (oid != OID__NR)
> +				cFYI(1, "OID oid = %u", oid);
> +			switch (oid) {
> +			case OID_MSKRB5:
> +				server->sec_mskerberos = true;
> +				break;
> +			case OID_KRB5U2U:
> +				server->sec_kerberosu2u = true;
> +				break;
> +			case OID_KRB5:
> +				server->sec_kerberos = true;
> +				break;
> +			case OID_NTLMSSP:
> +				server->sec_ntlmssp = true;
> +				break;
> +			case OID__NR:
> +				cFYI(1, "OID len = %ld oid = %*pX",
> +				     end - ctx.pointer,
> +				     (int)(end - ctx.pointer), ctx.pointer);
> +			default:
> +				break;
>  			}
>  		} else {
>  			cFYI(1, "Should be an oid what is going on?");
> diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
> index 6926db7..4bff9c5 100644
> --- a/include/linux/oid_registry.h
> +++ b/include/linux/oid_registry.h
> @@ -82,6 +82,12 @@ enum OID {
>  	OID_authorityKeyIdentifier,	/* 2.5.29.35 */
>  	OID_extKeyUsage,		/* 2.5.29.37 */
>  
> +	OID_SPNEGO,			/* 1.3.6.1.5.5.2 */
> +	OID_NTLMSSP,			/* 1.3.6.1.4.1.311.2.2.10 */
> +	OID_KRB5,			/* 1.2.840.113554.1.2.2 */
> +	OID_KRB5U2U,			/* 1.2.840.113554.1.2.2.3 */
> +	OID_MSKRB5,			/* 1.2.840.48018.1.2.2 */
> +
>  	OID__NR
>  };
>  
> 

I forgot to mention that this patch looks fine to me after my earlier comments:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

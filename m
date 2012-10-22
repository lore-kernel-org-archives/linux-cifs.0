From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] CIFS: Use linux/asn1.h
Date: Mon, 22 Oct 2012 14:38:37 -0400
Message-ID: <20121022143837.684d5f15@corrin.poochiereds.net>
References: <20121022142318.6989.5077.stgit@warthog.procyon.org.uk>
	<20121022142340.6989.5702.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121022142340.6989.5702.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Oct 2012 15:23:41 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Use linux/asn1.h in CIFS's ASN.1 decoder to get common ASN.1 constants rather
> than redefining them for itself.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  fs/cifs/asn1.c |   76 ++++++++++++++++++--------------------------------------
>  1 file changed, 24 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
> index 3a7b2b6..2e46b81 100644
> --- a/fs/cifs/asn1.c
> +++ b/fs/cifs/asn1.c
> @@ -22,6 +22,7 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
> +#include <linux/asn1.h>
>  #include <linux/oid_registry.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
> @@ -34,40 +35,6 @@
>   *
>   *****************************************************************************/
>  
> -/* Class */
> -#define ASN1_UNI	0	/* Universal */
> -#define ASN1_APL	1	/* Application */
> -#define ASN1_CTX	2	/* Context */
> -#define ASN1_PRV	3	/* Private */
> -
> -/* Tag */
> -#define ASN1_EOC	0	/* End Of Contents or N/A */
> -#define ASN1_BOL	1	/* Boolean */
> -#define ASN1_INT	2	/* Integer */
> -#define ASN1_BTS	3	/* Bit String */
> -#define ASN1_OTS	4	/* Octet String */
> -#define ASN1_NUL	5	/* Null */
> -#define ASN1_OJI	6	/* Object Identifier  */
> -#define ASN1_OJD	7	/* Object Description */
> -#define ASN1_EXT	8	/* External */
> -#define ASN1_ENUM	10	/* Enumerated */
> -#define ASN1_SEQ	16	/* Sequence */
> -#define ASN1_SET	17	/* Set */
> -#define ASN1_NUMSTR	18	/* Numerical String */
> -#define ASN1_PRNSTR	19	/* Printable String */
> -#define ASN1_TEXSTR	20	/* Teletext String */
> -#define ASN1_VIDSTR	21	/* Video String */
> -#define ASN1_IA5STR	22	/* IA5 String */
> -#define ASN1_UNITIM	23	/* Universal Time */
> -#define ASN1_GENTIM	24	/* General Time */
> -#define ASN1_GRASTR	25	/* Graphical String */
> -#define ASN1_VISSTR	26	/* Visible String */
> -#define ASN1_GENSTR	27	/* General String */
> -
> -/* Primitive / Constructed methods*/
> -#define ASN1_PRI	0	/* Primitive */
> -#define ASN1_CON	1	/* Constructed */
> -
>  /*
>   * Error codes.
>   */
> @@ -155,7 +122,8 @@ asn1_tag_decode(struct asn1_ctx *ctx, unsigned int *tag)
>  
>  static unsigned char
>  asn1_id_decode(struct asn1_ctx *ctx,
> -	       unsigned int *cls, unsigned int *con, unsigned int *tag)
> +	       enum asn1_class *cls, enum asn1_method *con,
> +	       enum asn1_tag *tag)
>  {
>  	unsigned char ch;
>  
> @@ -166,7 +134,7 @@ asn1_id_decode(struct asn1_ctx *ctx,
>  	*con = (ch & 0x20) >> 5;
>  	*tag = (ch & 0x1F);
>  
> -	if (*tag == 0x1F) {
> +	if (*tag == ASN1_LONG_TAG) {
>  		if (!asn1_tag_decode(ctx, tag))
>  			return 0;
>  	}
> @@ -181,7 +149,7 @@ asn1_length_decode(struct asn1_ctx *ctx, unsigned int *def, unsigned int *len)
>  	if (!asn1_octet_decode(ctx, &ch))
>  		return 0;
>  
> -	if (ch == 0x80)
> +	if (ch == ASN1_INDEFINITE_LENGTH)
>  		*def = 0;
>  	else {
>  		*def = 1;
> @@ -212,7 +180,8 @@ asn1_length_decode(struct asn1_ctx *ctx, unsigned int *def, unsigned int *len)
>  static unsigned char
>  asn1_header_decode(struct asn1_ctx *ctx,
>  		   unsigned char **eoc,
> -		   unsigned int *cls, unsigned int *con, unsigned int *tag)
> +		   enum asn1_class *cls, enum asn1_method *con,
> +		   enum asn1_tag *tag)
>  {
>  	unsigned int def = 0;
>  	unsigned int len = 0;
> @@ -224,7 +193,7 @@ asn1_header_decode(struct asn1_ctx *ctx,
>  		return 0;
>  
>  	/* primitive shall be definite, indefinite shall be constructed */
> -	if (*con == ASN1_PRI && !def)
> +	if (*con == ASN1_PRIM && !def)
>  		return 0;
>  
>  	if (def)
> @@ -402,7 +371,10 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	struct asn1_ctx ctx;
>  	unsigned char *end;
>  	unsigned char *sequence_end;
> -	unsigned int cls, con, tag, rc;
> +	unsigned int rc;
> +	enum asn1_class cls;
> +	enum asn1_method con;
> +	enum asn1_tag tag;
>  
>  	/* cifs_dump_mem(" Received SecBlob ", security_blob, length); */
>  
> @@ -412,7 +384,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>  		cFYI(1, "Error decoding negTokenInit header");
>  		return 0;
> -	} else if ((cls != ASN1_APL) || (con != ASN1_CON)
> +	} else if ((cls != ASN1_APPL) || (con != ASN1_CONS)
>  		   || (tag != ASN1_EOC)) {
>  		cFYI(1, "cls = %d con = %d tag = %d", cls, con, tag);
>  		return 0;
> @@ -421,8 +393,8 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	/* Check for SPNEGO OID -- remember to free obj->oid */
>  	rc = asn1_header_decode(&ctx, &end, &cls, &con, &tag);
>  	if (rc) {
> -		if ((tag == ASN1_OJI) && (con == ASN1_PRI) &&
> -		    (cls == ASN1_UNI)) {
> +		if ((tag == ASN1_OID) && (con == ASN1_PRIM) &&
> +		    (cls == ASN1_UNIV)) {
>  			if (asn1_oid_decode(&ctx, end) != OID_SPNEGO)
>  				rc = 0;
>  		} else
> @@ -439,7 +411,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>  		cFYI(1, "Error decoding negTokenInit");
>  		return 0;
> -	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
> +	} else if ((cls != ASN1_CONT) || (con != ASN1_CONS)
>  		   || (tag != ASN1_EOC)) {
>  		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 0",
>  		     cls, con, tag, end, *end);
> @@ -450,7 +422,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>  		cFYI(1, "Error decoding negTokenInit");
>  		return 0;
> -	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
> +	} else if ((cls != ASN1_UNIV) || (con != ASN1_CONS)
>  		   || (tag != ASN1_SEQ)) {
>  		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 1",
>  		     cls, con, tag, end, *end);
> @@ -461,7 +433,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>  		cFYI(1, "Error decoding 2nd part of negTokenInit");
>  		return 0;
> -	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
> +	} else if ((cls != ASN1_CONT) || (con != ASN1_CONS)
>  		   || (tag != ASN1_EOC)) {
>  		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 0",
>  		     cls, con, tag, end, *end);
> @@ -473,7 +445,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	    (&ctx, &sequence_end, &cls, &con, &tag) == 0) {
>  		cFYI(1, "Error decoding 2nd part of negTokenInit");
>  		return 0;
> -	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
> +	} else if ((cls != ASN1_UNIV) || (con != ASN1_CONS)
>  		   || (tag != ASN1_SEQ)) {
>  		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 1",
>  		     cls, con, tag, end, *end);
> @@ -487,7 +459,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  			cFYI(1, "Error decoding negTokenInit hdr exit2");
>  			return 0;
>  		}
> -		if ((tag == ASN1_OJI) && (con == ASN1_PRI)) {
> +		if ((tag == ASN1_OID) && (con == ASN1_PRIM)) {
>  			enum OID oid = asn1_oid_decode(&ctx, end);
>  			if (oid != OID__NR)
>  				cFYI(1, "OID oid = %u", oid);
> @@ -524,7 +496,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  			goto decode_negtoken_exit;
>  		cFYI(1, "Error decoding last part negTokenInit exit3");
>  		return 0;
> -	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
> +	} else if ((cls != ASN1_CONT) || (con != ASN1_CONS)) {
>  		/* tag = 3 indicating mechListMIC */
>  		cFYI(1, "Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
>  			cls, con, tag, end, *end);
> @@ -535,7 +507,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>  		cFYI(1, "Error decoding last part negTokenInit exit5");
>  		return 0;
> -	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
> +	} else if ((cls != ASN1_UNIV) || (con != ASN1_CONS)
>  		   || (tag != ASN1_SEQ)) {
>  		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d)",
>  			cls, con, tag, end, *end);
> @@ -545,7 +517,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>  		cFYI(1, "Error decoding last part negTokenInit exit 7");
>  		return 0;
> -	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
> +	} else if ((cls != ASN1_CONT) || (con != ASN1_CONS)) {
>  		cFYI(1, "Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
>  			cls, con, tag, end, *end);
>  		return 0;
> @@ -555,7 +527,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>  		cFYI(1, "Error decoding last part negTokenInit exit9");
>  		return 0;
> -	} else if ((cls != ASN1_UNI) || (con != ASN1_PRI)
> +	} else if ((cls != ASN1_UNIV) || (con != ASN1_PRIM)
>  		   || (tag != ASN1_GENSTR)) {
>  		cFYI(1, "Exit10 cls = %d con = %d tag = %d end = %p (%d)",
>  			cls, con, tag, end, *end);
> 

Nice cleanup.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

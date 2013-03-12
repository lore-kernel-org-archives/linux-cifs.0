From: Yan Li <elliot.li.tech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: ignore everything in SPNEGO blob after mechTypes
Date: Tue, 12 Mar 2013 11:27:54 -0700
Message-ID: <D964BE89-1509-4A58-B079-37F17449F4F5@gmail.com>
References: <1363009939-2264-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jason-U1lxkLAfC+FTYOaJdQCKXFaTQe2KTcn/@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363009939-2264-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yes, this patch fixed the problem in the current kernel we encountered when trying to mount a directory shared from a Windows 8 Pro system.

Yan Li

On Mar 11, 2013, at 6:52 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> We've had several reports of people attempting to mount Windows 8 shares
> and getting failures with a return code of -EINVAL. The default sec=
> mode changed recently to sec=ntlmssp. With that, we expect and parse a
> SPNEGO blob from the server in the NEGOTIATE reply.
> 
> The current decode_negTokenInit function first parses all of the
> mechTypes and then tries to parse the rest of the negTokenInit reply.
> The parser however currently expects a mechListMIC or nothing to follow the
> mechTypes, but Windows 8 puts a mechToken field there instead to carry
> some info for the new NegoEx stuff.
> 
> In practice, we don't do anything with the fields after the mechTypes
> anyway so I don't see any real benefit in continuing to parse them.
> This patch just has the kernel ignore the fields after the mechTypes.
> We'll probably need to reinstate some of this if we ever want to support
> NegoEx.
> 
> Reported-by: Jason Burgess <jason-U1lxkLAfC+FTYOaJdQCKXFaTQe2KTcn/@public.gmane.org>
> Reported-by: Yan Li <elliot.li.tech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> fs/cifs/asn1.c | 53 +++++------------------------------------------------
> 1 file changed, 5 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
> index cfd1ce3..1d36db1 100644
> --- a/fs/cifs/asn1.c
> +++ b/fs/cifs/asn1.c
> @@ -614,53 +614,10 @@ decode_negTokenInit(unsigned char *security_blob, int length,
> 		}
> 	}
> 
> -	/* mechlistMIC */
> -	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
> -		/* Check if we have reached the end of the blob, but with
> -		   no mechListMic (e.g. NTLMSSP instead of KRB5) */
> -		if (ctx.error == ASN1_ERR_DEC_EMPTY)
> -			goto decode_negtoken_exit;
> -		cFYI(1, "Error decoding last part negTokenInit exit3");
> -		return 0;
> -	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
> -		/* tag = 3 indicating mechListMIC */
> -		cFYI(1, "Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
> -			cls, con, tag, end, *end);
> -		return 0;
> -	}
> -
> -	/* sequence */
> -	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
> -		cFYI(1, "Error decoding last part negTokenInit exit5");
> -		return 0;
> -	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
> -		   || (tag != ASN1_SEQ)) {
> -		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d)",
> -			cls, con, tag, end, *end);
> -	}
> -
> -	/* sequence of */
> -	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
> -		cFYI(1, "Error decoding last part negTokenInit exit 7");
> -		return 0;
> -	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
> -		cFYI(1, "Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
> -			cls, con, tag, end, *end);
> -		return 0;
> -	}
> -
> -	/* general string */
> -	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
> -		cFYI(1, "Error decoding last part negTokenInit exit9");
> -		return 0;
> -	} else if ((cls != ASN1_UNI) || (con != ASN1_PRI)
> -		   || (tag != ASN1_GENSTR)) {
> -		cFYI(1, "Exit10 cls = %d con = %d tag = %d end = %p (%d)",
> -			cls, con, tag, end, *end);
> -		return 0;
> -	}
> -	cFYI(1, "Need to call asn1_octets_decode() function for %s",
> -		ctx.pointer);	/* is this UTF-8 or ASCII? */
> -decode_negtoken_exit:
> +	/*
> +	 * We currently ignore anything at the end of the SPNEGO blob after
> +	 * the mechTypes have been parsed, since none of that info is
> +	 * used at the moment.
> +	 */
> 	return 1;
> }
> -- 
> 1.7.11.7
> 

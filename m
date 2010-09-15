From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH -v5 2/4] cifs NTLMv2/NTLMSSP ntlmv2 within ntlmssp
 autentication code
Date: Wed, 15 Sep 2010 19:13:09 -0400
Message-ID: <20100915191309.36414a56@tlielax.poochiereds.net>
References: <1284590224-5596-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284590224-5596-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 15 Sep 2010 17:37:04 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Attribue Value (AV) pairs or Target Info (TI) pairs are part of
> ntlmv2 authentication.
> Structure ntlmv2_resp had only definition for two av pairs.
> So removed it, and now allocation of av pairs is dynamic.
> For servers like Windows 7/2008, av pairs sent by server in
> challege packet (type 2 in the ntlmssp exchange/negotiation) can
> vary.
> 
> Server sends them during ntlmssp negotiation. So when ntlmssp is used
> as an authentication mechanism, type 2 challenge packet from server
> has this information.  Pluck it and use the entire blob for
> authenticaiton purpose.  If user has not specified, extract
> (netbios) domain name from the av pairs which is used to calculate
> ntlmv2 hash.  Servers like Windows 7 are particular about the AV pair
> blob.
> 
> Servers like Windows 2003, are not very strict about the contents
> of av pair blob used during ntlmv2 authentication.
> So when security mechanism such as ntlmv2 is used (not ntlmv2 in ntlmssp),
> there is no negotiation and so genereate a minimal blob that gets
> used in ntlmv2 authentication as well as gets sent.
> 
> Fields tilen and tilbob are session specific.  AV pair values are defined.
> 
> To calculate ntlmv2 response we need ti/av pair blob.
> 
> For sec mech like ntlmssp, the blob is plucked from type 2 response from
> the server.  From this blob, netbios name of the domain is retrieved,
> if user has not already provided, to be included in the Target String
> as part of ntlmv2 hash calculations.
> 
> For sec mech like ntlmv2, create a minimal, two av pair blob.
> 
> The allocated blob is freed in case of error.  In case there is no error,
> this blob is used in calculating ntlmv2 response (in CalcNTLMv2_response)
> and is also copied on the response to the server, and then freed.
> 
> The type 3 ntlmssp response is prepared on a buffer,
> 5 * sizeof of struct _AUTHENTICATE_MESSAGE, an empirical value large
> enough to hold _AUTHENTICATE_MESSAGE plus a blob with max possible
> 10 values as part of ntlmv2 response and lmv2 keys and domain, user,
> workstation  names etc.
> 
> Also, kerberos gets selected as a default mechanism if server supports it,
> over the other security mechanisms.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/cifs/cifsglob.h    |    2 +
>  fs/cifs/cifspdu.h     |    1 -
>  fs/cifs/cifsproto.h   |    2 +-
>  fs/cifs/cifssmb.c     |   16 ++++---
>  fs/cifs/connect.c     |    2 +
>  fs/cifs/ntlmssp.h     |   15 ++++++
>  fs/cifs/sess.c        |  114 ++++++++++++++++++++++++++++++---------------
>  8 files changed, 224 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index eed70ca..ab0533a 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -27,6 +27,7 @@
>  #include "md5.h"
>  #include "cifs_unicode.h"
>  #include "cifsproto.h"
> +#include "ntlmssp.h"
>  #include <linux/ctype.h>
>  #include <linux/random.h>
>  
> @@ -262,6 +263,92 @@ void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>  }
>  #endif /* CIFS_WEAK_PW_HASH */
>  
> +/* This is just a filler for ntlmv2 type of security mechanisms.
> + * Older servers are not very particular about the contents of av pairs
> + * in the blob and for sec mechs like ntlmv2, there is no negotiation
> + * as in ntlmssp, so unless domain and server  netbios and dns names
> + * are specified, there is no way to obtain name.  In case of ntlmssp,
> + * server provides that info in type 2 challenge packet
> + */
> +static int
> +build_avpair_blob(struct cifsSesInfo *ses)
> +{
> +	struct ntlmssp2_name *attrptr;
> +
> +	ses->tilen = 2 * sizeof(struct ntlmssp2_name);
> +	ses->tiblob = kzalloc(ses->tilen, GFP_KERNEL);
> +	if (!ses->tiblob) {
> +		ses->tilen = 0;
> +		cERROR(1, "Challenge target info allocation failure");
> +		return -ENOMEM;
> +	}
> +	attrptr = (struct ntlmssp2_name *) ses->tiblob;
> +	attrptr->type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
> +
> +	return 0;
> +}
> +
> +/* Server has provided av pairs/target info in the type 2 challenge
> + * packet and we have plucked it and stored within smb session.
> + * We parse that blob here to find netbios domain name to be used
> + * as part of ntlmv2 authentication (in Target String), if not already
> + * specified on the command line.
> + * If this function returns without any error but without fetching
> + * domain name, authentication may fail against some server but
> + * may not fail against other (those who are not very particular
> + * about target string i.e. for some, just user name might suffice.
> + */
> +static int
> +find_domain_name(struct cifsSesInfo *ses)
> +{
> +	unsigned int attrsize;
> +	unsigned int type;
> +	unsigned char *blobptr;
> +	unsigned char *blobend;
> +	struct ntlmssp2_name *attrptr;
> +
> +	if (!ses->tilen || !ses->tiblob)
> +		return 0;
> +
> +	if (ses->tilen < sizeof(struct ntlmssp2_name))
> +		return 0;
> +
> +	blobend = ses->tiblob + ses->tilen;
> +	blobptr = ses->tiblob;
> +	attrptr = (struct ntlmssp2_name *) blobptr;
> +
> +	while (blobptr <= blobend) {
> +		type = le16_to_cpu(attrptr->type);
> +		if (type == NTLMSSP_AV_EOL)
> +			break;
> +		blobptr += 2; /* advance attr type */
> +		attrsize = le16_to_cpu(attrptr->length);
> +		blobptr += 2; /* advance attr size */
> +		if (blobptr + attrsize > blobend) {
> +			cERROR(1, "%s: Invalid attribute size: %d",
> +					__func__, attrsize);
> +			return -EINVAL;
> +		}
> +		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
> +			if (!ses->domainName) {
> +				ses->domainName =
> +					kmalloc(attrsize + 1, GFP_KERNEL);
> +				if (!ses->domainName)
> +						return -ENOMEM;
> +				cifs_from_ucs2(ses->domainName,
> +					(__le16 *)blobptr,
> +					attrptr->length,
> +					attrptr->length,
> +					load_nls_default(), false);

				I'll also ask again...what's the point
				of continuing to parse the buffer
				once you reach this point? Why not
				break out of the loop at this point and
				return?
> +			}
> +		}
> +		blobptr += attrsize; /* advance attr  value */
> +		attrptr = (struct ntlmssp2_name *) blobptr;
> +	}
> +
> +	return 0;
> +}
> +


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

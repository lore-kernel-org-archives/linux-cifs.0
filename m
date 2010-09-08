From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 5/8] ntlmv2/ntlmssp  functions to either extract or
 create av pair/ti info blob
Date: Wed, 8 Sep 2010 16:09:30 -0400
Message-ID: <20100908160930.53ff6208@tlielax.poochiereds.net>
References: <1283921185-13114-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283921185-13114-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  7 Sep 2010 23:46:25 -0500
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
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/cifs/cifspdu.h     |    1 -
>  fs/cifs/connect.c     |    2 +
>  fs/cifs/sess.c        |   18 +++++++++++
>  4 files changed, 93 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 4772c4d..e53fbeb 100644
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
> @@ -263,6 +264,78 @@ void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
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
> +
^^^ nit: this blank line shouldn't be there

> +static int
> +build_avpair_blob(struct cifsSesInfo *ses)
> +{
> +	struct ntlmssp2_name *attrptr;
> +
> +	ses->tilen = 2 * sizeof(struct ntlmssp2_name);
		    ^^^
		Why 2 here? This deserves a comment.

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
> + * packet and we have plucked it and stored within smb connection.
> + * We parse that blob here to find netbios domain name to be used
> + * as part of ntlmv2 authentication, if not already specified on
> + * the command line
> + */
> +
^^^^
nit: again, blank line not needed there

> +static int
> +find_domain_name(struct cifsSesInfo *ses)
> +{
> +	int rc = 0;
> +	unsigned int attrsize;
> +	unsigned int type;
> +	unsigned char *blobptr;
> +	struct ntlmssp2_name *attrptr;
> +
> +	if (ses->tiblob) {
> +		blobptr = ses->tiblob;
> +		attrptr = (struct ntlmssp2_name *) blobptr;
> +
> +		while ((type = attrptr->type) != 0) {
> +			blobptr += 2; /* advance attr type */
> +			attrsize = attrptr->length;
> +			blobptr += 2; /* advance attr size */
> +			if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
> +				if (!ses->domainName) {
> +					ses->domainName =
> +						kmalloc(attrptr->length + 1,
> +								GFP_KERNEL);
> +					if (!ses->domainName)
> +							return -ENOMEM;
> +					cifs_from_ucs2(ses->domainName,
> +						(__le16 *)blobptr,
> +						attrptr->length,
> +						attrptr->length,
> +						load_nls_default(), false);
> +				}
> +			}
> +			blobptr += attrsize; /* advance attr  value */
> +			attrptr = (struct ntlmssp2_name *) blobptr;
> +		}
> +	}
> +
> +	return rc;
> +}
> +

I think the above function needs some bounds checking. What prevents
the client from trying to access data past the end of the tiblob? I see
no reference to the tilen in that function.


>  static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
>  			    const struct nls_table *nls_cp)
>  {
> @@ -334,10 +407,6 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  	buf->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
>  	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
>  	buf->reserved2 = 0;
> -	buf->names[0].type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
> -	buf->names[0].length = 0;
> -	buf->names[1].type = 0;
> -	buf->names[1].length = 0;
>  
>  	/* calculate buf->ntlmv2_hash */
>  	rc = calc_ntlmv2_hash(ses, nls_cp);
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index f5c78fb..dc90a36 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -670,7 +670,6 @@ struct ntlmv2_resp {
>  	__le64  time;
>  	__u64  client_chal; /* random */
>  	__u32  reserved2;
> -	struct ntlmssp2_name names[2];
>  	/* array of name entries could follow ending in minimum 4 byte struct */
>  } __attribute__((packed));
>  
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f5369e7..0621a72 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1768,6 +1768,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>  	if (ses == NULL)
>  		goto get_ses_fail;
>  
> +	ses->tilen = 0;
> +	ses->tiblob = NULL;
>  	/* new SMB session uses our server ref */
>  	ses->server = server;
>  	if (server->addr.sockAddr6.sin6_family == AF_INET6)
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 0a57cb7..756f410 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
>  static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>  				    struct cifsSesInfo *ses)
>  {
> +	unsigned int tioffset; /* challenge message target info area */
> +	unsigned int tilen; /* challenge message target info area length  */
> +
>  	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
>  
>  	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
> @@ -405,6 +408,20 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>  	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
>  		we must set the MIC field of the AUTHENTICATE_MESSAGE */
>  
> +	ses->server->ntlmssp.server_flags = le32_to_cpu(pblob->NegotiateFlags);
> +
> +	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
> +	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
> +	ses->tilen = tilen;
> +	if (ses->tilen) {
> +		ses->tiblob = kmalloc(tilen, GFP_KERNEL);
> +		if (!ses->tiblob) {
> +			cERROR(1, "Challenge target info allocation failure");
> +			return -ENOMEM;
> +		}
> +		memcpy(ses->tiblob,  bcc_ptr + tioffset, ses->tilen);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -533,6 +550,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  	sec_blob->SessionKey.Length = 0;
>  	sec_blob->SessionKey.MaximumLength = 0;
> +
>  	return tmp - pbuffer;
>  }
>  


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

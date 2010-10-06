From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/7 cifs] ntlm authentication and signing - Correct
 response length for ntlmv2 authentication without extended security
Date: Wed, 6 Oct 2010 11:54:44 -0400
Message-ID: <20101006115444.7c91d838@tlielax.poochiereds.net>
References: <1286240173-30716-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286240173-30716-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  4 Oct 2010 19:56:13 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Fix incorrect calculation of case sensitive response length in the
> ntlmv2 (without extended security) response.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/sess.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index af18a50..c926e6c 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -739,9 +739,6 @@ ssetup_ntlmssp_authenticate:
>  		pSMB->req_no_secext.CaseInsensitivePasswordLength = 0;
>  		/*	cpu_to_le16(LM2_SESS_KEY_SIZE); */
>  
> -		pSMB->req_no_secext.CaseSensitivePasswordLength =
> -			cpu_to_le16(sizeof(struct ntlmv2_resp));
> -
>  		/* calculate session key */
>  		rc = setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
>  		if (rc) {
> @@ -753,6 +750,11 @@ ssetup_ntlmssp_authenticate:
>  				sizeof(struct ntlmv2_resp));
>  		bcc_ptr += sizeof(struct ntlmv2_resp);
>  		kfree(v2_sess_key);
> +		/* set case sensitive password length after tilen may get
> +		 * assigned, tilen is 0 otherwise.
> +		 */
> +		pSMB->req_no_secext.CaseSensitivePasswordLength =
> +			cpu_to_le16(sizeof(struct ntlmv2_resp) + ses->tilen);
>  		if (ses->tilen > 0) {
>  			memcpy(bcc_ptr, ses->tiblob, ses->tilen);
>  			bcc_ptr += ses->tilen;
> @@ -761,6 +763,7 @@ ssetup_ntlmssp_authenticate:
>  			ses->tiblob = NULL;
>  			ses->tilen = 0;
>  		}
> +
>  		if (ses->capabilities & CAP_UNICODE) {
>  			if (iov[0].iov_len % 2) {
>  				*bcc_ptr = 0;


Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

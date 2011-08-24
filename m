From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: use memcpy for magic string in cifs signature generation
 BSRSPYL
Date: Wed, 24 Aug 2011 12:00:11 +0530
Message-ID: <4E549A73.9020801@suse.de>
References: <1313803157-31952-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313803157-31952-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/20/2011 06:49 AM, Jeff Layton wrote:
> ...it's more efficient since we know the length.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index e76bfeb..f11dfb6 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -92,7 +92,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
>  		return rc;
>  
>  	if (!server->session_estab) {
> -		strncpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
> +		memcpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
>  		return rc;
>  	}
>  
> @@ -189,7 +189,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
>  		return rc;
>  
>  	if (!server->session_estab) {
> -		strncpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
> +		memcpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
>  		return rc;
>  	}
>  


Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

Any reason why some of the strncpy/strncmp cases were only picked up
among the rest? May be depending on how hot the code path is?

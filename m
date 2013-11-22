From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/9] fix some cFYI in cifssmb.c
Date: Fri, 22 Nov 2013 09:32:44 -0500
Message-ID: <20131122093244.6050ad61@tlielax.poochiereds.net>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
	<1385116018-14068-1-git-send-email-gbeck@sernet.de>
	<1385116018-14068-8-git-send-email-gbeck@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-8-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Nov 2013 11:26:56 +0100
Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:

> ---
>  cifssmb.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/cifssmb.c b/cifssmb.c
> index 38be854..5d10afc 100644
> --- a/cifssmb.c
> +++ b/cifssmb.c
> @@ -3935,7 +3935,7 @@ QFileInfoRetry:
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>  	if (rc) {
> -		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
> +		cifs_dbg(FYI, "Send error in QFileInfo = %d", rc);
>  	} else {		/* decode response */
>  		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
>  
> @@ -4131,7 +4131,7 @@ UnixQFileInfoRetry:
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>  	if (rc) {
> -		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
> +		cifs_dbg(FYI, "Send error in UnixQFileInfo = %d", rc);
>  	} else {		/* decode response */
>  		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
>  
> @@ -4215,7 +4215,7 @@ UnixQPathInfoRetry:
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>  	if (rc) {
> -		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
> +		cifs_dbg(FYI, "Send error in UnixQPathInfo = %d", rc);
>  	} else {		/* decode response */
>  		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
>  

Nice fix. I'd go ahead and ask Steve to merge this independently of the others...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sync_smb2_mid_result
Date: Wed, 23 Mar 2011 12:06:17 -0400
Message-ID: <20110323120617.0379e0a1@corrin.poochiereds.net>
References: <AANLkTinnLUXF3O=AOYG8PrCG1guAA8vkM18wYKSLegk2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinnLUXF3O=AOYG8PrCG1guAA8vkM18wYKSLegk2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 12 Mar 2011 19:55:55 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Previously CIFS added a function, sync_mid_result, to better handle
> certain error conditions.
> This patch adds the equivalent for SMB2 mids (they are used by smb2_sendrcv2
> which is added in the next patch)
> 
> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index c62070a..a05b37b 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -250,6 +235,64 @@ smb2_mid_entry_free(struct smb2_mid_entry *mid_entry)
>  	mempool_free(mid_entry, smb2_mid_poolp);
>  }
> 
> +/* This is similar to cifs's wait_for_response but obviously for smb2 mids */
> +static int
> +wait_for_smb2_response(struct TCP_Server_Info *server,
> +			struct smb2_mid_entry *midq)
> +{
> +	int error;
> +
> +	error = wait_event_killable(server->response_q,
> +				    midq->mid_state != MID_REQUEST_SUBMITTED);
> +	if (error < 0)
> +		return -ERESTARTSYS;
> +
> +	return 0;
> +}
> +
> +/* This is similar to cifs's sync_mid_result but for smb2 mids */
> +static int
> +sync_smb2_mid_result(struct smb2_mid_entry *mid, struct
> TCP_Server_Info *server)
> +{
> +	int rc = 0;
> +
> +	cFYI(1, "%s: cmd=%d mid=%lld state=%d", __func__,
> +		le16_to_cpu(mid->command), mid->mid, mid->mid_state);
> +
> +	spin_lock(&GlobalMid_Lock);
> +	/* ensure that it's no longer on the pending_mid_q */
> +	list_del_init(&mid->qhead);
> +
> +	switch (mid->midState) {
> +	case MID_RESPONSE_RECEIVED:
> +		spin_unlock(&GlobalMid_Lock);
> +		return rc;
> +	case MID_REQUEST_SUBMITTED:
> +		/* socket is going down, reject all calls */
> +		if (server->tcpStatus == CifsExiting) {
> +			cERROR(1, "%s: canceling mid=%lld cmd=0x%x state=%d",
> +				__func__, mid->mid, le16_to_cpu(mid->command),
> +				mid->mid_state);
> +			rc = -EHOSTDOWN;
> +			break;
> +		}
> +	case MID_RETRY_NEEDED:
> +		rc = -EAGAIN;
> +		break;
> +	case MID_RESPONSE_MALFORMED:
> +		rc = -EIO;
> +		break;
> +	default:
> +		cERROR(1, "%s: invalid mid state mid=%lld state=%d", __func__,
> +			mid->mid, mid->mid_state);
> +		rc = -EIO;
> +	}
> +	spin_unlock(&GlobalMid_Lock);
> +
> +	smb2_mid_entry_free(mid);
> +	return rc;
> +}
> +
>  static void
>  free_smb2_mid(struct smb2_mid_entry *mid)
>  {
> 

Now that you've commented out all of the unneeded fields from the
struct smb2_mid_entry, it's clear that the smb2_mid_entry is a subset
of mid_q_entry. Some of the mid_q_entry fields might need to be
expanded (the mid number itself for example), but that hardly seems to
warrant a completely new struct and codebase for this.

Can you explain why we need all of this code duplication when it now
seems fairly clear that much of the existing code could be repurposed
for SMB2? This approach is going to vastly increase the maintenance
burden and I don't see that we gain anything from it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

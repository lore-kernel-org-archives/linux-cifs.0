From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v2 08/15] CIFS: SMBD: Support page offset in RDMA send
Date: Sat, 23 Jun 2018 22:11:39 -0400
Message-ID: <ad9b2249-7e26-be0d-997c-c1cc128f70d6@talpey.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
 <20180530194807.31657-9-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-9-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 5/30/2018 3:48 PM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> The RDMA send function needs to look at offset in the request pages, and
> send data starting from there.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>   fs/cifs/smbdirect.c | 27 +++++++++++++++++++--------
>   1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index c62f7c9..6141e3c 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -17,6 +17,7 @@
>   #include <linux/highmem.h>
>   #include "smbdirect.h"
>   #include "cifs_debug.h"
> +#include "cifsproto.h"
>   
>   static struct smbd_response *get_empty_queue_buffer(
>   		struct smbd_connection *info);
> @@ -2082,7 +2083,7 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
>   	struct kvec vec;
>   	int nvecs;
>   	int size;
> -	int buflen = 0, remaining_data_length;
> +	unsigned int buflen = 0, remaining_data_length;
>   	int start, i, j;
>   	int max_iov_size =
>   		info->max_send_size - sizeof(struct smbd_data_transfer);
> @@ -2113,10 +2114,17 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
>   		buflen += iov[i].iov_len;
>   	}
>   
> -	/* add in the page array if there is one */
> +	/*
> +	 * Add in the page array if there is one. The caller needs to set
> +	 * rq_tailsz to PAGE_SIZE when the buffer has multiple pages and
> +	 * ends at page boundary
> +	 */
>   	if (rqst->rq_npages) {
> -		buflen += rqst->rq_pagesz * (rqst->rq_npages - 1);
> -		buflen += rqst->rq_tailsz;
> +		if (rqst->rq_npages == 1)
> +			buflen += rqst->rq_tailsz;
> +		else
> +			buflen += rqst->rq_pagesz * (rqst->rq_npages - 1) -
> +					rqst->rq_offset + rqst->rq_tailsz;
>   	}

This code is really confusing and redundant. It tests npages > 0,
then tests npages == 1, then does an else. Why not call the helper
like the following smbd_send()?

Tom.

>   
>   	if (buflen + sizeof(struct smbd_data_transfer) >
> @@ -2213,8 +2221,9 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
>   
>   	/* now sending pages if there are any */
>   	for (i = 0; i < rqst->rq_npages; i++) {
> -		buflen = (i == rqst->rq_npages-1) ?
> -			rqst->rq_tailsz : rqst->rq_pagesz;
> +		unsigned int offset;
> +
> +		rqst_page_get_length(rqst, i, &buflen, &offset);
>   		nvecs = (buflen + max_iov_size - 1) / max_iov_size;
>   		log_write(INFO, "sending pages buflen=%d nvecs=%d\n",
>   			buflen, nvecs);
> @@ -2225,9 +2234,11 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
>   			remaining_data_length -= size;
>   			log_write(INFO, "sending pages i=%d offset=%d size=%d"
>   				" remaining_data_length=%d\n",
> -				i, j*max_iov_size, size, remaining_data_length);
> +				i, j*max_iov_size+offset, size,
> +				remaining_data_length);
>   			rc = smbd_post_send_page(
> -				info, rqst->rq_pages[i], j*max_iov_size,
> +				info, rqst->rq_pages[i],
> +				j*max_iov_size + offset,
>   				size, remaining_data_length);
>   			if (rc)
>   				goto done;
> 

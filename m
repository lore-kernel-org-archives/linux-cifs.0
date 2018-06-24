From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v2 05/15] CIFS: Calculate the correct request length based
 on page offset and tail size
Date: Sat, 23 Jun 2018 22:07:10 -0400
Message-ID: <183b5cd5-b12b-de08-7867-c2addf29c974@talpey.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
 <20180530194807.31657-6-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-6-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 5/30/2018 3:47 PM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> It's possible that the page offset is non-zero in the pages in a request,
> change the function to calculate the correct data buffer length.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>   fs/cifs/transport.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 927226a..d6b5523 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -212,10 +212,24 @@ rqst_len(struct smb_rqst *rqst)
>   	for (i = 0; i < rqst->rq_nvec; i++)
>   		buflen += iov[i].iov_len;
>   
> -	/* add in the page array if there is one */
> +	/*
> +	 * Add in the page array if there is one. The caller needs to make
> +	 * sure rq_offset and rq_tailsz are set correctly. If a buffer of
> +	 * multiple pages ends at page boundary, rq_tailsz needs to be set to
> +	 * PAGE_SIZE.
> +	 */
>   	if (rqst->rq_npages) {
> -		buflen += rqst->rq_pagesz * (rqst->rq_npages - 1);
> -		buflen += rqst->rq_tailsz;
> +		if (rqst->rq_npages == 1)
> +			buflen += rqst->rq_tailsz;
> +		else {
> +			/*
> +			 * If there is more than one page, calculate the
> +			 * buffer length based on rq_offset and rq_tailsz
> +			 */
> +			buflen += rqst->rq_pagesz * (rqst->rq_npages - 1) -
> +					rqst->rq_offset;
> +			buflen += rqst->rq_tailsz;
> +		}

Wouldn't it be simpler to keep the original code, but then just subtract
the rq_offset?

	buflen += rqst->rq_pagesz * (rqst->rq_npages - 1);
	buflen += rqst->rq_tailsz;
	buflen -= rqst->rq_offset;

It's kind of confusing as written. Also, what if it's just one page, but
has a non-zero offset? Is that somehow not possible? My suggested code
would take that into account, yours doesn't.

Tom.

>   	}
>   
>   	return buflen;
> 

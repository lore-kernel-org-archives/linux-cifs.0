From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v2 11/15] CIFS: Pass page offset for calculating signature
Date: Sat, 23 Jun 2018 22:27:18 -0400
Message-ID: <7a9ee28d-4c18-c4fd-259b-1feeeb3fb83b@talpey.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
 <20180530194807.31657-12-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-12-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 5/30/2018 3:48 PM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> When calculating signature for the packet, it needs to read into the
> correct page offset for the data.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>   fs/cifs/cifsencrypt.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index a6ef088..e88303c 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -68,11 +68,12 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>   
>   	/* now hash over the rq_pages array */
>   	for (i = 0; i < rqst->rq_npages; i++) {
> -		void *kaddr = kmap(rqst->rq_pages[i]);
> -		size_t len = rqst->rq_pagesz;
> +		void *kaddr;
> +		unsigned int len, offset;
>   
> -		if (i == rqst->rq_npages - 1)
> -			len = rqst->rq_tailsz;
> +		rqst_page_get_length(rqst, i, &len, &offset);
> +
> +		kaddr = (char *) kmap(rqst->rq_pages[i]) + offset;

I suppose it's more robust to map a page at a time, but it's pretty
expensive. Is this the only way to iterate over a potentially very
large block of data? For example, a 1MB segment means 256 kmap/kunmaps.

Tom.

>   
>   		crypto_shash_update(shash, kaddr, len);
>   
> 

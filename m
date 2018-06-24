From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v2 10/15] CIFS: SMBD: Support page offset in memory
 registration
Date: Sat, 23 Jun 2018 22:24:28 -0400
Message-ID: <fb6189b0-2fe6-fc98-8b3b-d8efaad9cef1@talpey.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
 <20180530194807.31657-11-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-11-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 5/30/2018 3:48 PM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> Change code to pass the correct page offset during memory registration for
> RDMA read/write.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>   fs/cifs/smb2pdu.c   | 18 ++++++++-----
>   fs/cifs/smbdirect.c | 76 +++++++++++++++++++++++++++++++----------------------
>   fs/cifs/smbdirect.h |  2 +-
>   3 files changed, 58 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index f603fbe..fc30774 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2623,8 +2623,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
>   
>   		rdata->mr = smbd_register_mr(
>   				server->smbd_conn, rdata->pages,
> -				rdata->nr_pages, rdata->tailsz,
> -				true, need_invalidate);
> +				rdata->nr_pages, rdata->page_offset,
> +				rdata->tailsz, true, need_invalidate);
>   		if (!rdata->mr)
>   			return -ENOBUFS;
>   
> @@ -3013,16 +3013,22 @@ smb2_async_writev(struct cifs_writedata *wdata,
>   
>   		wdata->mr = smbd_register_mr(
>   				server->smbd_conn, wdata->pages,
> -				wdata->nr_pages, wdata->tailsz,
> -				false, need_invalidate);
> +				wdata->nr_pages, wdata->page_offset,
> +				wdata->tailsz, false, need_invalidate);
>   		if (!wdata->mr) {
>   			rc = -ENOBUFS;
>   			goto async_writev_out;
>   		}
>   		req->Length = 0;
>   		req->DataOffset = 0;
> -		req->RemainingBytes =
> -			cpu_to_le32((wdata->nr_pages-1)*PAGE_SIZE + wdata->tailsz);
> +		if (wdata->nr_pages > 1)
> +			req->RemainingBytes =
> +				cpu_to_le32(
> +					(wdata->nr_pages - 1) * wdata->pagesz -
> +					wdata->page_offset + wdata->tailsz
> +				);
> +		else
> +			req->RemainingBytes = cpu_to_le32(wdata->tailsz);

Again, I think a helper that computed and returned this size would be
much clearer and compact. And I still am incredulous that a single page
io always has an offset of zero. :-)

>   		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
>   		if (need_invalidate)
>   			req->Channel = SMB2_CHANNEL_RDMA_V1;
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index ba53c52..e459c97 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -2299,37 +2299,37 @@ static void smbd_mr_recovery_work(struct work_struct *work)
>   		if (smbdirect_mr->state == MR_INVALIDATED ||
>   			smbdirect_mr->state == MR_ERROR) {
>   
> -			if (smbdirect_mr->state == MR_INVALIDATED) {
> +			/* recover this MR entry */
> +			rc = ib_dereg_mr(smbdirect_mr->mr);
> +			if (rc) {
> +				log_rdma_mr(ERR,
> +					"ib_dereg_mr failed rc=%x\n",
> +					rc);
> +				smbd_disconnect_rdma_connection(info);
> +				continue;
> +			}

Ok, we discussed this ib_dereg_mr() call at the plugfest last week.
It's unnecessary - the MR is reusable and does not need to be destroyed
after each use.

> +
> +			smbdirect_mr->mr = ib_alloc_mr(
> +				info->pd, info->mr_type,
> +				info->max_frmr_depth);
> +			if (IS_ERR(smbdirect_mr->mr)) {
> +				log_rdma_mr(ERR,
> +					"ib_alloc_mr failed mr_type=%x "
> +					"max_frmr_depth=%x\n",
> +					info->mr_type,
> +					info->max_frmr_depth);
> +				smbd_disconnect_rdma_connection(info);
> +				continue;
> +			}
> +

Not needed, for the same reason above.

> +			if (smbdirect_mr->state == MR_INVALIDATED)
>   				ib_dma_unmap_sg(
>   					info->id->device, smbdirect_mr->sgl,
>   					smbdirect_mr->sgl_count,
>   					smbdirect_mr->dir);
> -				smbdirect_mr->state = MR_READY;

As we observed, the smbdirect_mr is not protected by a lock, therefore
this MR_READY state transition needs a memory barrier in front of it!

> -			} else if (smbdirect_mr->state == MR_ERROR) {
> -
> -				/* recover this MR entry */
> -				rc = ib_dereg_mr(smbdirect_mr->mr);
> -				if (rc) {
> -					log_rdma_mr(ERR,
> -						"ib_dereg_mr failed rc=%x\n",
> -						rc);
> -					smbd_disconnect_rdma_connection(info);
> -				}
Why are you deleting the MR_ERROR handling? It seems this is precisely
the place where the MR needs to be destroyed, to prevent any later RDMA
operations from potentially reaching the original memory.

>   
> -				smbdirect_mr->mr = ib_alloc_mr(
> -					info->pd, info->mr_type,
> -					info->max_frmr_depth);
> -				if (IS_ERR(smbdirect_mr->mr)) {
> -					log_rdma_mr(ERR,
> -						"ib_alloc_mr failed mr_type=%x "
> -						"max_frmr_depth=%x\n",
> -						info->mr_type,
> -						info->max_frmr_depth);
> -					smbd_disconnect_rdma_connection(info);
> -				}
> +			smbdirect_mr->state = MR_READY;
>   
> -				smbdirect_mr->state = MR_READY;
> -			}
>   			/* smbdirect_mr->state is updated by this function
>   			 * and is read and updated by I/O issuing CPUs trying
>   			 * to get a MR, the call to atomic_inc_return
> @@ -2475,7 +2475,7 @@ static struct smbd_mr *get_mr(struct smbd_connection *info)
>    */
>   struct smbd_mr *smbd_register_mr(
>   	struct smbd_connection *info, struct page *pages[], int num_pages,
> -	int tailsz, bool writing, bool need_invalidate)
> +	int offset, int tailsz, bool writing, bool need_invalidate)
>   {
>   	struct smbd_mr *smbdirect_mr;
>   	int rc, i;
> @@ -2498,17 +2498,31 @@ struct smbd_mr *smbd_register_mr(
>   	smbdirect_mr->sgl_count = num_pages;
>   	sg_init_table(smbdirect_mr->sgl, num_pages);
>   
> -	for (i = 0; i < num_pages - 1; i++)
> -		sg_set_page(&smbdirect_mr->sgl[i], pages[i], PAGE_SIZE, 0);
> +	log_rdma_mr(INFO, "num_pages=0x%x offset=0x%x tailsz=0x%x\n",
> +			num_pages, offset, tailsz);
>   
> +	if (num_pages == 1) {
> +		sg_set_page(&smbdirect_mr->sgl[0], pages[0], tailsz, offset);
> +		goto skip_multiple_pages;

A simple "else" would be much preferable to this "goto".

> +	}
> +
> +	/* We have at least two pages to register */
> +	sg_set_page(
> +		&smbdirect_mr->sgl[0], pages[0], PAGE_SIZE - offset, offset);
> +	i = 1;
> +	while (i < num_pages - 1) {
> +		sg_set_page(&smbdirect_mr->sgl[i], pages[i], PAGE_SIZE, 0);
> +		i++;
> +	}
>   	sg_set_page(&smbdirect_mr->sgl[i], pages[i],
>   		tailsz ? tailsz : PAGE_SIZE, 0);
>   
> +skip_multiple_pages:
>   	dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>   	smbdirect_mr->dir = dir;
>   	rc = ib_dma_map_sg(info->id->device, smbdirect_mr->sgl, num_pages, dir);
>   	if (!rc) {
> -		log_rdma_mr(INFO, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
> +		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
>   			num_pages, dir, rc);
>   		goto dma_map_error;
>   	}
> @@ -2516,8 +2530,8 @@ struct smbd_mr *smbd_register_mr(
>   	rc = ib_map_mr_sg(smbdirect_mr->mr, smbdirect_mr->sgl, num_pages,
>   		NULL, PAGE_SIZE);
>   	if (rc != num_pages) {
> -		log_rdma_mr(INFO,
> -			"ib_map_mr_sg failed rc = %x num_pages = %x\n",
> +		log_rdma_mr(ERR,
> +			"ib_map_mr_sg failed rc = %d num_pages = %x\n",
>   			rc, num_pages);
>   		goto map_mr_error;
>   	}
> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
> index f9038da..1e419c2 100644
> --- a/fs/cifs/smbdirect.h
> +++ b/fs/cifs/smbdirect.h
> @@ -321,7 +321,7 @@ struct smbd_mr {
>   /* Interfaces to register and deregister MR for RDMA read/write */
>   struct smbd_mr *smbd_register_mr(
>   	struct smbd_connection *info, struct page *pages[], int num_pages,
> -	int tailsz, bool writing, bool need_invalidate);
> +	int offset, int tailsz, bool writing, bool need_invalidate);
>   int smbd_deregister_mr(struct smbd_mr *mr);
>   
>   #else
> 

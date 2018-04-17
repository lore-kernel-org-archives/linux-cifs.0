From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6/6] cifs: smbd: Dump SMB packet when configured
Date: Tue, 17 Apr 2018 09:29:54 +0200
Message-ID: <20180417072954.GE15310@kroah.com>
References: <20180417004918.29213-1-longli@linuxonhyperv.com>
 <20180417004918.29213-6-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org
To: longli@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180417004918.29213-6-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Apr 16, 2018 at 05:49:18PM -0700, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> When sending through SMB Direct, also dump the packet in SMB send path.
> 
> Also fixed a typo in debug message.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/smbdirect.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index f575e9a..6ff864a 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1029,7 +1029,7 @@ static int smbd_post_send(struct smbd_connection *info,
>  	for (i = 0; i < request->num_sge; i++) {
>  		log_rdma_send(INFO,
>  			"rdma_request sge[%d] addr=%llu length=%u\n",
> -			i, request->sge[0].addr, request->sge[0].length);
> +			i, request->sge[i].addr, request->sge[i].length);
>  		ib_dma_sync_single_for_device(
>  			info->id->device,
>  			request->sge[i].addr,
> @@ -2130,6 +2130,10 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
>  		goto done;
>  	}
>  
> +	cifs_dbg(FYI, "Sending smb (RDMA): smb_len=%u\n", buflen);
> +	for (i = 0; i < rqst->rq_nvec-1; i++)
> +		dump_smb(iov[i].iov_base, iov[i].iov_len);
> +
>  	remaining_data_length = buflen;
>  
>  	log_write(INFO, "rqst->rq_nvec=%d rqst->rq_npages=%d rq_pagesz=%d "
> -- 
> 2.7.4

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

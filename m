From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/6] cifs: smbd: Don't use RDMA read/write when signing
 is used
Date: Tue, 17 Apr 2018 09:29:46 +0200
Message-ID: <20180417072946.GD15310@kroah.com>
References: <20180417004918.29213-1-longli@linuxonhyperv.com>
 <20180417004918.29213-4-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org
To: longli@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180417004918.29213-4-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Apr 16, 2018 at 05:49:16PM -0700, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> SMB server will not sign data transferred through RDMA read/write. When
> signing is used, it's a good idea to have all the data signed.
> 
> In this case, use RDMA send/recv for all data transfers. This will degrade
> performance as this is not generally configured in RDMA environemnt. So
> warn the user on signing and RDMA send/recv.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/cifssmb.c |  3 +++
>  fs/cifs/smb2ops.c | 18 ++++++++++++++----
>  fs/cifs/smb2pdu.c |  4 ++--
>  3 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 6d3e40d..1529a08 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -455,6 +455,9 @@ cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
>  		server->sign = true;
>  	}
>  
> +	if (cifs_rdma_enabled(server) && server->sign)
> +		cifs_dbg(VFS, "Signing is enabled, and RDMA read/write will be disabled");
> +
>  	return 0;
>  }
>  
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 38ebf3f..b76b858 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -252,9 +252,14 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>  	wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
>  	wsize = min_t(unsigned int, wsize, server->max_write);
>  #ifdef CONFIG_CIFS_SMB_DIRECT
> -	if (server->rdma)
> -		wsize = min_t(unsigned int,
> +	if (server->rdma) {
> +		if (server->sign)
> +			wsize = min_t(unsigned int,
> +				wsize, server->smbd_conn->max_fragmented_send_size);
> +		else
> +			wsize = min_t(unsigned int,
>  				wsize, server->smbd_conn->max_readwrite_size);
> +	}
>  #endif
>  	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
>  		wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
> @@ -272,9 +277,14 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>  	rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
>  	rsize = min_t(unsigned int, rsize, server->max_read);
>  #ifdef CONFIG_CIFS_SMB_DIRECT
> -	if (server->rdma)
> -		rsize = min_t(unsigned int,
> +	if (server->rdma) {
> +		if (server->sign)
> +			rsize = min_t(unsigned int,
> +				rsize, server->smbd_conn->max_fragmented_recv_size);
> +		else
> +			rsize = min_t(unsigned int,
>  				rsize, server->smbd_conn->max_readwrite_size);
> +	}
>  #endif
>  
>  	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index abbefe2..6759035 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2596,7 +2596,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
>  	 * If we want to do a RDMA write, fill in and append
>  	 * smbd_buffer_descriptor_v1 to the end of read request
>  	 */
> -	if (server->rdma && rdata &&
> +	if (server->rdma && rdata && !server->sign &&
>  		rdata->bytes >= server->smbd_conn->rdma_readwrite_threshold) {
>  
>  		struct smbd_buffer_descriptor_v1 *v1;
> @@ -2974,7 +2974,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
>  	 * If we want to do a server RDMA read, fill in and append
>  	 * smbd_buffer_descriptor_v1 to the end of write request
>  	 */
> -	if (server->rdma && wdata->bytes >=
> +	if (server->rdma && !server->sign && wdata->bytes >=
>  		server->smbd_conn->rdma_readwrite_threshold) {
>  
>  		struct smbd_buffer_descriptor_v1 *v1;
> -- 
> 2.7.4

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

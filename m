From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/6] cifs: smbd: Enable signing with smbdirect
Date: Tue, 17 Apr 2018 09:29:40 +0200
Message-ID: <20180417072940.GC15310@kroah.com>
References: <20180417004918.29213-1-longli@linuxonhyperv.com>
 <20180417004918.29213-5-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org
To: longli@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180417004918.29213-5-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Apr 16, 2018 at 05:49:17PM -0700, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> Now signing is supported with RDMA transport.
> 
> Remove the code that disabled it.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/connect.c | 8 --------
>  fs/cifs/smb2pdu.c | 4 ----
>  2 files changed, 12 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index e8830f0..deef270 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1977,14 +1977,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  		goto cifs_parse_mount_err;
>  	}
>  
> -#ifdef CONFIG_CIFS_SMB_DIRECT
> -	if (vol->rdma && vol->sign) {
> -		cifs_dbg(VFS, "Currently SMB direct doesn't support signing."
> -			" This is being fixed\n");
> -		goto cifs_parse_mount_err;
> -	}
> -#endif
> -
>  #ifndef CONFIG_KEYS
>  	/* Muliuser mounts require CONFIG_KEYS support */
>  	if (vol->multiuser) {
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6759035..d71ce51 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -737,10 +737,6 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>  
>  	cifs_dbg(FYI, "validate negotiate\n");
>  
> -#ifdef CONFIG_CIFS_SMB_DIRECT
> -	if (tcon->ses->server->rdma)
> -		return 0;
> -#endif
>  	pneg_inbuf = kmalloc(sizeof(*pneg_inbuf), GFP_KERNEL);
>  	if (!pneg_inbuf)
>  		return -ENOMEM;
> -- 
> 2.7.4

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

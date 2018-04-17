From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/6] cifs: smbd: Check for iov length on sending the last
 iov
Date: Tue, 17 Apr 2018 09:29:23 +0200
Message-ID: <20180417072923.GA15310@kroah.com>
References: <20180417004918.29213-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org
To: longli@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180417004918.29213-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Apr 16, 2018 at 05:49:13PM -0700, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> When sending the last iov that breaks into smaller buffers to fit the
> transfer size, it's necessary to check if this is the last iov.
> 
> If this is the latest iov, stop and proceed to send pages.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/smbdirect.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 90e673c..b5c6c0d 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -2197,6 +2197,8 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
>  						goto done;
>  				}
>  				i++;
> +				if (i == rqst->rq_nvec)
> +					break;
>  			}
>  			start = i;
>  			buflen = 0;
> -- 
> 2.7.4

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

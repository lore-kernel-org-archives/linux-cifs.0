From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Decrease verbosity of ioctl call
Date: Mon, 05 Dec 2016 12:00:46 +0530
Message-ID: <1480919446.3464.1.camel@redhat.com>
References: <1480467416-13636-1-git-send-email-pshilov@microsoft.com>
         <1480467416-13636-2-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480467416-13636-2-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-11-29 at 16:56 -0800, Pavel Shilovsky wrote:
> Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.9+
> Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Ack
> ---
>  fs/cifs/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 9f51b81..0015287 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -189,7 +189,7 @@ long cifs_ioctl(struct file *filep, unsigned int
> command, unsigned long arg)
>  	xid = get_xid();
>  
>  	cifs_sb = CIFS_SB(inode->i_sb);
> -	cifs_dbg(VFS, "cifs ioctl 0x%x\n", command);
> +	cifs_dbg(FYI, "cifs ioctl 0x%x\n", command);
>  	switch (command) {
>  		case FS_IOC_GETFLAGS:
>  			if (pSMBFile == NULL)

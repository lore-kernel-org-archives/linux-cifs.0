From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
Date: Tue, 19 Dec 2017 13:39:15 +0100
Message-ID: <20171219133915.278a9a4e@endymion>
References: <20171219101327.2165797-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219101327.2165797-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 19 Dec 2017 11:12:57 +0100, Arnd Bergmann wrote:
> A built-in SMB file system cannot link against a modular
> infiniband core module:
> 
> fs/cifs/smbdirect.o: In function `smbd_destroy_rdma_work':
> smbdirect.c:(.text+0x28e3): undefined reference to `ib_drain_qp'
> smbdirect.c:(.text+0x2915): undefined reference to `rdma_destroy_qp'
> smbdirect.c:(.text+0x2d08): undefined reference to `ib_free_cq'
> smbdirect.c:(.text+0x2d3d): undefined reference to `ib_free_cq'
> smbdirect.c:(.text+0x2d6f): undefined reference to `ib_dealloc_pd'
> smbdirect.c:(.text+0x2d9a): undefined reference to `rdma_destroy_id'
> fs/cifs/smbdirect.o: In function `smbd_disconnect_rdma_work':
> smbdirect.c:(.text+0x3d3e): undefined reference to `rdma_disconnect'
> fs/cifs/smbdirect.o: In function `_smbd_get_connection':
> smbdirect.c:(.text+0x5bc2): undefined reference to `rdma_create_id'
> smbdirect.c:(.text+0x5cc5): undefined reference to `rdma_resolve_addr'
> smbdirect.c:(.text+0x5cda): undefined reference to `rdma_destroy_id'
> smbdirect.c:(.text+0x5da7): undefined reference to `rdma_destroy_id'
> smbdirect.c:(.text+0x5e89): undefined reference to `rdma_resolve_route'
> smbdirect.c:(.text+0x5f07): undefined reference to `rdma_destroy_id'
> 
> This changes the Kconfig dependency to enforce selecting one of the
> valid configurations.
> 
> Fixes: bbc50d2ad317 ("CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  fs/cifs/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 500fd69fb58b..3bfc55c08bef 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -199,6 +199,7 @@ config CIFS_SMB311
>  config CIFS_SMB_DIRECT
>  	bool "SMB Direct support (Experimental)"
>  	depends on CIFS && INFINIBAND
> +	depends on CIFS=m || INFINIBAND=y
>  	help
>  	  Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
>  	  SMB Direct allows transferring SMB packets over RDMA. If unsure,

Looks good to me.

Reviewed-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>

-- 
Jean Delvare
SUSE L3 Support

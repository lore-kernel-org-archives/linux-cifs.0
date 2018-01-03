From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH -next] cifs: fix build errors for SMB_DIRECT
Date: Wed, 3 Jan 2018 11:48:24 -0600
Message-ID: <CAH2r5mt8ENue0cfcqW_52A084dWaYYhhXLxV5Brmz3gnVSdz8g@mail.gmail.com>
References: <23f1bd9a-8c16-5893-e23e-ca1c04c80bad@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Steve French <sfrench@samba.org>
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <23f1bd9a-8c16-5893-e23e-ca1c04c80bad@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Jan 2, 2018 at 11:43 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Prevent build errors when CIFS=y and INFINIBAND=m.
>
> fs/cifs/smbdirect.o: In function `smbd_qp_async_error_upcall':
> smbdirect.c:(.text+0x28c): undefined reference to `ib_event_msg'
> fs/cifs/smbdirect.o: In function `smbd_destroy_rdma_work':
> smbdirect.c:(.text+0xfde): undefined reference to `ib_drain_qp'
> smbdirect.c:(.text+0xfea): undefined reference to `rdma_destroy_qp'
> smbdirect.c:(.text+0x12a0): undefined reference to `ib_free_cq'
> smbdirect.c:(.text+0x12ac): undefined reference to `ib_free_cq'
> smbdirect.c:(.text+0x12b8): undefined reference to `ib_dealloc_pd'
> smbdirect.c:(.text+0x12c4): undefined reference to `rdma_destroy_id'
> fs/cifs/smbdirect.o: In function `_smbd_get_connection':
> smbdirect.c:(.text+0x168c): undefined reference to `rdma_create_id'
> smbdirect.c:(.text+0x1713): undefined reference to `rdma_resolve_addr'
> smbdirect.c:(.text+0x1780): undefined reference to `rdma_resolve_route'
> smbdirect.c:(.text+0x17e3): undefined reference to `rdma_destroy_id'
> smbdirect.c:(.text+0x183d): undefined reference to `rdma_destroy_id'
> smbdirect.c:(.text+0x199d): undefined reference to `ib_alloc_cq'
> smbdirect.c:(.text+0x19d9): undefined reference to `ib_alloc_cq'
> smbdirect.c:(.text+0x1a89): undefined reference to `rdma_create_qp'
> smbdirect.c:(.text+0x1b3c): undefined reference to `rdma_connect'
> smbdirect.c:(.text+0x2538): undefined reference to `rdma_destroy_qp'
> smbdirect.c:(.text+0x2549): undefined reference to `ib_free_cq'
> smbdirect.c:(.text+0x255a): undefined reference to `ib_free_cq'
> smbdirect.c:(.text+0x2563): undefined reference to `ib_dealloc_pd'
> smbdirect.c:(.text+0x256c): undefined reference to `rdma_destroy_id'
> smbdirect.c:(.text+0x25f0): undefined reference to `__ib_alloc_pd'
> smbdirect.c:(.text+0x26bb): undefined reference to `rdma_disconnect'
> fs/cifs/smbdirect.o: In function `smbd_disconnect_rdma_work':
> smbdirect.c:(.text+0x62): undefined reference to `rdma_disconnect'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:     Steve French <sfrench@samba.org>
> Cc:     linux-cifs@vger.kernel.org
> Cc:     samba-technical@lists.samba.org (moderated for non-subscribers)
> ---
>  fs/cifs/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20180102.orig/fs/cifs/Kconfig
> +++ linux-next-20180102/fs/cifs/Kconfig
> @@ -197,7 +197,7 @@ config CIFS_SMB311
>
>  config CIFS_SMB_DIRECT
>         bool "SMB Direct support (Experimental)"
> -       depends on CIFS && INFINIBAND
> +       depends on CIFS=m && INFINIBAND || CIFS=y && INFINIBAND=y
>         help
>           Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
>           SMB Direct allows transferring SMB packets over RDMA. If unsure,
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve

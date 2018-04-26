From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 4/5] cifs: smbd: depend on INFINIBAND_ADDR_TRANS
Date: Thu, 26 Apr 2018 01:14:49 +0000
Message-ID: <MWHPR2101MB07293DD81DF86317C2A6917ECE8E0@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180425223412.207127-1-gthelen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Christoph Hellwig <hch@lst.de>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tarick Bedeir <tarick@google.com>
To: Greg Thelen <gthelen@google.com>, Steve French <sfrench@samba.org>,
        Bart Van Assche <Bart.VanAssche@wdc.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425223412.207127-1-gthelen@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> Subject: [PATCH 4/5] cifs: smbd: depend on INFINIBAND_ADDR_TRANS
>=20
> CIFS_SMB_DIRECT code depends on INFINIBAND_ADDR_TRANS provided
> symbols.
> So declare the kconfig dependency.  This is necessary to allow for enabli=
ng
> INFINIBAND without INFINIBAND_ADDR_TRANS.
>=20
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Cc: Tarick Bedeir <tarick@google.com>

Reviewed-by: Long Li <longli@microsoft.com>

> ---
>  fs/cifs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig index
> 741749a98614..5f132d59dfc2 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -197,7 +197,7 @@ config CIFS_SMB311
>=20
>  config CIFS_SMB_DIRECT
>  	bool "SMB Direct support (Experimental)"
> -	depends on CIFS=3Dm && INFINIBAND || CIFS=3Dy && INFINIBAND=3Dy
> +	depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS
> || CIFS=3Dy &&
> +INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
>  	help
>  	  Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
>  	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
> --
> 2.17.0.441.gb46fe60e1d-goog
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in =
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> https://na01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fvger.ke
> rnel.org%2Fmajordomo-
> info.html&data=3D02%7C01%7Clongli%40microsoft.com%7C680883705136432b
> 280b08d5aafcb355%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63
> 6602924686676279&sdata=3Dcn1DPTCOpL2%2BBa62wGlUp2dEe8BAzFVPxhfRxf
> 2N1Ek%3D&reserved=3D0

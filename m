From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [[PATCH v1] 24/37] [CIFS] SMBD: Support for SMBD keep alive
 protocol
Date: Mon, 14 Aug 2017 21:06:53 +0000
Message-ID: <CY4PR21MB0182CBEB4F76488B2FB9480FA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-25-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-25-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> owner@vger.kernel.org] On Behalf Of Long Li
> Sent: Wednesday, August 2, 2017 4:11 PM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [[PATCH v1] 24/37] [CIFS] SMBD: Support for SMBD keep alive
> protocol
>=20
> SMBD uses a keep alive protocol to help peers detect if the remote is dea=
d.
> When peer request keep alive, the transport needs to respond accordingly.

The keepalive exchange is also used to replenish credits in certain
pathological conditions.

> +               // send an emtpy response right away if requested
> +               if (le16_to_cpu(data_transfer->flags) |
> +                               le16_to_cpu(SMB_DIRECT_RESPONSE_REQUESTED=
)) {
> +                       info->keep_alive_requested =3D KEEP_ALIVE_PENDING=
;
> +               }

This is clearly a typo, the condition is always true. "&"??

Tom.

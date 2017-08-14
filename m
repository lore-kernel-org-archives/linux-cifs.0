From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [[PATCH v1] 26/37] [CIFS] SMBD: Send an immediate packet when
 it's needed
Date: Mon, 14 Aug 2017 21:15:33 +0000
Message-ID: <CY4PR21MB01821B871B31119849F56D2BA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-27-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-27-git-send-email-longli@exchange.microsoft.com>
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
> Subject: [[PATCH v1] 26/37] [CIFS] SMBD: Send an immediate packet when it=
's
> needed
>=20
> +/*
> + * Check and schedule to send an immediate packet
> + * This is used to extend credtis to remote peer to keep the transport b=
usy
> + */
> +static void check_and_send_immediate(struct cifs_rdma_info *info)
> +{
> +       info->send_immediate =3D true;
> +
> +       // promptly send a packet if running low on receive credits

...if *our peer* is running low on credits.

> +       if (atomic_read(&info->receive_credits) <
> +           atomic_read(&info->receive_credit_target) -1 )

Why read the receive_credit_target atomically? It's a mostly unchanging loc=
al value?

Tom.

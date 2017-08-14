From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 19/37] [CIFS] SMBD: Manage credits on SMBD client and
 server
Date: Mon, 14 Aug 2017 20:47:29 +0000
Message-ID: <CY4PR21MB01823211DE659BEAA7932309A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-20-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-20-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> Sent: Wednesday, August 2, 2017 4:11 PM
> To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: [[PATCH v1] 19/37] [CIFS] SMBD: Manage credits on SMBD client an=
d
> server
>=20
>  /*
> + * Extend the credits to remote peer
> + * This implements [MS-SMBD] 3.1.5.9
> + * The idea is that we should extend credits to remote peer as quickly a=
s
> + * it's allowed, to maintain data flow. We allocate as much as receive
> + * buffer as possible, and extend the receive credits to remote peer
> + * return value: the new credtis being granted.
> + */
> +static int manage_credits_prior_sending(struct cifs_rdma_info *info)
> +{
> +       int ret =3D 0;
> +       struct cifs_rdma_response *response;
> +       int rc;
> +
> +       if (atomic_read(&info->receive_credit_target) >

When does the receive_credit_target value change? It seems wasteful to
perform an atomic_read() on this local value each time.

Tom.

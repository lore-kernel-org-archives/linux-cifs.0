From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 15/37] [CIFS] SMBD: Post a SMBD data transfer message
 with data payload
Date: Mon, 14 Aug 2017 20:26:55 +0000
Message-ID: <CY4PR21MB0182DDC9D21E8F0166B57F4AA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-16-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-16-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> Sent: Wednesday, August 2, 2017 4:10 PM
> To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: [[PATCH v1] 15/37] [CIFS] SMBD: Post a SMBD data transfer messag=
e
> with data payload
>=20
=20
> Similar to sending transfer message with page payload, this function crea=
tes a
> SMBD data packet and send it over to RDMA, from iov passed from upper lay=
er.

The following routine is heavily redundant with 14/37 cifs_rdma_post_send_p=
age().
Because they share quite a bit of protocol and DMA mapping logic, strongly =
suggest
they be merged.

Tom.

> +static int cifs_rdma_post_send_data(
> +               struct cifs_rdma_info *info,
> +               struct kvec *iov, int n_vec, int remaining_data_length);
>  static int cifs_rdma_post_send_page(struct cifs_rdma_info *info,
>                 struct page *page, unsigned long offset,
>                 size_t size, int remaining_data_length);
> @@ -671,6 +674,122 @@ static int cifs_rdma_post_send_page(struct
> cifs_rdma_info *info, struct page *pa
>  }

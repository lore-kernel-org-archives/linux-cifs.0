From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 18/37] [CIFS] SMBD: Implement API for upper layer to
 send data
Date: Mon, 14 Aug 2017 20:44:18 +0000
Message-ID: <CY4PR21MB01827F735F570CCAECD5AD8BA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-19-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-19-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> Sent: Wednesday, August 2, 2017 4:10 PM
> To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: [[PATCH v1] 18/37] [CIFS] SMBD: Implement API for upper layer to
> send data
>=20
> +/*
> + * Write data to transport
> + * Each rqst is transported as a SMBDirect payload
> + * rqst: the data to write
> + * return value: 0 if successfully write, otherwise error code
> + */
> +int cifs_rdma_write(struct cifs_rdma_info *info, struct smb_rqst *rqst)
> +{

!!!
This is a VERY confusing name. It is not sending an RDMA Write, which will
confuse any RDMA-enlightened reader. It's performing an RDMA Send, so
that name is perhaps one possibility.=20

> +       if (info->transport_status !=3D CIFS_RDMA_CONNECTED) {
> +               log_cifs_write("disconnected returning -EIO\n");
> +               return -EIO;
> +       }

Isn't this optimizing the error case? There's no guarantee it's still conne=
cted by
the time the following request construction occurs. Why not just proceed wi=
thout
the check?=20

> +       /* Strip the first 4 bytes MS-SMB2 section 2.1
> +        * they are used only for TCP transport */
> +       iov[0].iov_base =3D (char*)rqst->rq_iov[0].iov_base + 4;
> +       iov[0].iov_len =3D rqst->rq_iov[0].iov_len - 4;
> +       buflen +=3D iov[0].iov_len;

Ok, that layering choice in the cifs.ko client code needs to be corrected. =
After all,
it will need to be RDMA-aware to build the SMB3 read/write channel structur=
es.
And, the code in cifs_post_send_data() is allocating and building a structu=
re that
could have been accounted for much earlier, avoiding the extra overhead.

That change could happen later, the hack is mostly ok for now. But somethin=
g
needs to be said in a comment.
=20
Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

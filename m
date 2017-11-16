From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [Patch v7 01/22] CIFS: SMBD: Add parameter rdata to
 smb2_new_read_req
Date: Thu, 16 Nov 2017 23:06:24 +0000
Message-ID: <CY4PR21MB0135049CE95731EA0DC7DFF9B62E0@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-2-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107085514.12693-2-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-11-07 0:54 GMT-08:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> This patch is for preparing upper layer for doing SMB read via RDMA write=
.
>
> When we assemble the SMB read packet header, we need to know the I/O layo=
ut
> if this request is to use a RDMA write. rdata has all the information we =
need
> for memory registration. Add rdata to smb2_new_read_req.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index bab3da6..32ad590 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2350,18 +2350,21 @@ SMB2_flush(const unsigned int xid, struct cifs_tc=
on *tcon, u64 persistent_fid,
>   */
>  static int
>  smb2_new_read_req(void **buf, unsigned int *total_len,
> -                 struct cifs_io_parms *io_parms, unsigned int remaining_=
bytes,
> -                 int request_type)
> +       struct cifs_io_parms *io_parms, struct cifs_readdata *rdata,
> +       unsigned int remaining_bytes, int request_type)
>  {
>         int rc =3D -EACCES;
>         struct smb2_read_plain_req *req =3D NULL;
>         struct smb2_sync_hdr *shdr;
> +       struct TCP_Server_Info *server;
>
>         rc =3D smb2_plain_req_init(SMB2_READ, io_parms->tcon, (void **) &=
req,
>                                  total_len);
>         if (rc)
>                 return rc;
> -       if (io_parms->tcon->ses->server =3D=3D NULL)
> +
> +       server =3D io_parms->tcon->ses->server;
> +       if (server =3D=3D NULL)
>                 return -ECONNABORTED;
>
>         shdr =3D &req->sync_hdr;
> @@ -2489,7 +2492,8 @@ smb2_async_readv(struct cifs_readdata *rdata)
>
>         server =3D io_parms.tcon->ses->server;
>
> -       rc =3D smb2_new_read_req((void **) &buf, &total_len, &io_parms, 0=
, 0);
> +       rc =3D smb2_new_read_req(
> +               (void **) &buf, &total_len, &io_parms, rdata, 0, 0);
>         if (rc) {
>                 if (rc =3D=3D -EAGAIN && rdata->credits) {
>                         /* credits was reset by reconnect */
> @@ -2557,7 +2561,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_pa=
rms *io_parms,
>         struct cifs_ses *ses =3D io_parms->tcon->ses;
>
>         *nbytes =3D 0;
> -       rc =3D smb2_new_read_req((void **)&req, &total_len, io_parms, 0, =
0);
> +       rc =3D smb2_new_read_req((void **)&req, &total_len, io_parms, NUL=
L, 0, 0);
>         if (rc)
>                 return rc;
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky

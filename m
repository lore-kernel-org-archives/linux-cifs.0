From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 18/37] [CIFS] SMBD: Implement API for upper layer to
 send data
Date: Wed, 30 Aug 2017 02:30:04 +0000
Message-ID: <MWHPR21MB0190E90448DDA01067016674CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-19-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB01827F735F570CCAECD5AD8BA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR21MB01827F735F570CCAECD5AD8BA08C0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 1:44 PM
> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>;
> linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [[PATCH v1] 18/37] [CIFS] SMBD: Implement API for upper laye=
r
> to send data
>=20
> > -----Original Message-----
> > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> > Sent: Wednesday, August 2, 2017 4:10 PM
> > To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > samba- technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Subject: [[PATCH v1] 18/37] [CIFS] SMBD: Implement API for upper layer
> > to send data
> >
> > +/*
> > + * Write data to transport
> > + * Each rqst is transported as a SMBDirect payload
> > + * rqst: the data to write
> > + * return value: 0 if successfully write, otherwise error code  */
> > +int cifs_rdma_write(struct cifs_rdma_info *info, struct smb_rqst
> > +*rqst) {
>=20
> !!!
> This is a VERY confusing name. It is not sending an RDMA Write, which wil=
l
> confuse any RDMA-enlightened reader. It's performing an RDMA Send, so
> that name is perhaps one possibility.

I have fixed that in v3.

>=20
> > +       if (info->transport_status !=3D CIFS_RDMA_CONNECTED) {
> > +               log_cifs_write("disconnected returning -EIO\n");
> > +               return -EIO;
> > +       }
>=20
> Isn't this optimizing the error case? There's no guarantee it's still con=
nected
> by the time the following request construction occurs. Why not just proce=
ed
> without the check?

I rearranged the shutdown logic in v3. Checking for transport status is sti=
ll needed, but it checks after checking for other counters on pending activ=
ities.

For example, on sending code:

info->smbd_send_pending++;
if (info->transport_status !=3D SMBD_CONNECTED) {
        info->smbd_send_pending--;
        wake_up(&info->wait_smbd_send_pending);       =20
}

On transport shutdown code:

        info->transport_status =3D SMBD_DISCONNECTING;
.......
.......
.......
        log_rdma_event(INFO, "wait for all send to finish\n");
        wait_event(info->wait_smbd_send_pending,
                info->smbd_send_pending =3D=3D 0);

It guarantees no sending code can enter transport after shutdown is finishe=
d. Shutdown is running on a separate work queue, so it is needed.

>=20
> > +       /* Strip the first 4 bytes MS-SMB2 section 2.1
> > +        * they are used only for TCP transport */
> > +       iov[0].iov_base =3D (char*)rqst->rq_iov[0].iov_base + 4;
> > +       iov[0].iov_len =3D rqst->rq_iov[0].iov_len - 4;
> > +       buflen +=3D iov[0].iov_len;
>=20
> Ok, that layering choice in the cifs.ko client code needs to be corrected=
. After
> all, it will need to be RDMA-aware to build the SMB3 read/write channel
> structures.
> And, the code in cifs_post_send_data() is allocating and building a struc=
ture
> that could have been accounted for much earlier, avoiding the extra
> overhead.
>=20
> That change could happen later, the hack is mostly ok for now. But
> something needs to be said in a comment.
>=20
> Tom.

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 21/37] [CIFS] SMBD: Implement API for upper layer to
 receive data
Date: Mon, 14 Aug 2017 23:24:31 +0000
Message-ID: <CY4PR21MB0182511B868E1AC83AF47B72CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-22-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB0182E84B76541E0EE6FCAF4EA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR21MB0182E84B76541E0EE6FCAF4EA08C0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 1:57 PM
> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>;
> linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [[PATCH v1] 21/37] [CIFS] SMBD: Implement API for upper laye=
r
> to receive data
>=20
> > -----Original Message-----
> > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> > Sent: Wednesday, August 2, 2017 4:11 PM
> > To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > samba- technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Subject: [[PATCH v1] 21/37] [CIFS] SMBD: Implement API for upper layer
> > to receive data
> >
> >  /*
> > + * Read data from receive reassembly queue
> > + * All the incoming data packets are placed in reassembly queue
> > + * buf: the buffer to read data into
> > + * size: the length of data to read
> > + * return value: actual data read
> > + */
> > +int cifs_rdma_read(struct cifs_rdma_info *info, char *buf, unsigned
> > +int size) {
> >...
> > +       spin_lock_irqsave(&info->reassembly_queue_lock, flags);
> > +       log_cifs_read("size=3D%d info->reassembly_data_length=3D%d\n", =
size,
> > +               atomic_read(&info->reassembly_data_length));
> > +       if (atomic_read(&info->reassembly_data_length) >=3D size) {
>=20
> If the reassembly queue is protected by a lock, why is an atomic_read() o=
f its
> length needed?

Will change this to non-atomic.

>=20
> > +                       // this is for reading rfc1002 length
> > +                       if (response->first_segment && size=3D=3D4) {
> > +                               unsigned int rfc1002_len =3D
> > +                                       data_length + remaining_data_le=
ngth;
> > +                               *((__be32*)buf) =3D cpu_to_be32(rfc1002=
_len);
> > +                               data_read =3D 4;
> > +                               response->first_segment =3D false;
> > +                               log_cifs_read("returning rfc1002 length=
 %d\n",
> > +                                       rfc1002_len);
> > +                               goto read_rfc1002_done;
> > +                       }
>=20
> I am totally confused. What does RFC1002 framing have to do with receivin=
g
> an SMB Direct packet???

The upper layer expects RFC1002 length at the beginning of the payload. A l=
ot of protocol processing logic check and act on this value. Returning this=
 value will avoid changes to lots of other upper layer code.

This will be eventually fixed when a transport layer is added to upper laye=
r code. I recommend we do it in another patch.

>=20
> > +
> > +                       to_copy =3D min_t(int, data_length - offset, to=
_read);
> > +                       memcpy(
> > +                               buf + data_read,
> > +                               (char*)data_transfer + data_offset + of=
fset,
> > +                               to_copy);
>=20
> Is it really necessary to perform all these data copies, especially under=
 the
> reassembly_queue spinlock? This seems quite inefficient. Can the receive
> buffers not be loaned out and chained logically?

This will require upper layer code changes to move to use new buffers alloc=
ated/loaned this way, and also deal with packet boundaries.

This code is not used to actually carry file data, which are normally done =
through RDMA read/write.

If we want to do it, I suggest do another patch since more changes other th=
an transport are involved.

>=20
> Tom.

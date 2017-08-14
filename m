From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [[PATCH v1] 21/37] [CIFS] SMBD: Implement API for upper layer to
 receive data
Date: Mon, 14 Aug 2017 23:35:32 +0000
Message-ID: <CY4PR21MB01821CE4F98CEDBE85C6BF13A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-22-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB0182E84B76541E0EE6FCAF4EA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
 <CY4PR21MB0182511B868E1AC83AF47B72CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CY4PR21MB0182511B868E1AC83AF47B72CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: Long Li
> Sent: Monday, August 14, 2017 7:25 PM
> To: Tom Talpey <ttalpey@microsoft.com>; Steve French <sfrench@samba.org>;
> linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [[PATCH v1] 21/37] [CIFS] SMBD: Implement API for upper laye=
r to
> receive data
>=20
>=20
>=20
> > -----Original Message-----
> > From: Tom Talpey
> > Sent: Monday, August 14, 2017 1:57 PM
> > To: Long Li <longli@microsoft.com>; Steve French <sfrench@samba.org>;
> > linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-
> > kernel@vger.kernel.org
> > Subject: RE: [[PATCH v1] 21/37] [CIFS] SMBD: Implement API for upper la=
yer
> > to receive data
> >
> > > -----Original Message-----
> > > From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> > > owner@vger.kernel.org] On Behalf Of Long Li
> > > Sent: Wednesday, August 2, 2017 4:11 PM
> > > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org;
> > > samba- technical@lists.samba.org; linux-kernel@vger.kernel.org
> > > Cc: Long Li <longli@microsoft.com>
> > > Subject: [[PATCH v1] 21/37] [CIFS] SMBD: Implement API for upper laye=
r
> > > to receive data
> > >
> > >  /*
> > > + * Read data from receive reassembly queue
> > > + * All the incoming data packets are placed in reassembly queue
> > > + * buf: the buffer to read data into
> > > + * size: the length of data to read
> > > + * return value: actual data read
> > > + */
> > > +int cifs_rdma_read(struct cifs_rdma_info *info, char *buf, unsigned
> > > +int size) {
> > >...
> > > +       spin_lock_irqsave(&info->reassembly_queue_lock, flags);
> > > +       log_cifs_read("size=3D%d info->reassembly_data_length=3D%d\n"=
, size,
> > > +               atomic_read(&info->reassembly_data_length));
> > > +       if (atomic_read(&info->reassembly_data_length) >=3D size) {
> >
> > If the reassembly queue is protected by a lock, why is an atomic_read()=
 of its
> > length needed?
>=20
> Will change this to non-atomic.
>=20
> >
> > > +                       // this is for reading rfc1002 length
> > > +                       if (response->first_segment && size=3D=3D4) {
> > > +                               unsigned int rfc1002_len =3D
> > > +                                       data_length + remaining_data_=
length;
> > > +                               *((__be32*)buf) =3D cpu_to_be32(rfc10=
02_len);
> > > +                               data_read =3D 4;
> > > +                               response->first_segment =3D false;
> > > +                               log_cifs_read("returning rfc1002 leng=
th %d\n",
> > > +                                       rfc1002_len);
> > > +                               goto read_rfc1002_done;
> > > +                       }
> >
> > I am totally confused. What does RFC1002 framing have to do with receiv=
ing
> > an SMB Direct packet???
>=20
> The upper layer expects RFC1002 length at the beginning of the payload. A=
 lot
> of protocol processing logic check and act on this value. Returning this =
value
> will avoid changes to lots of other upper layer code.
>=20
> This will be eventually fixed when a transport layer is added to upper la=
yer
> code. I recommend we do it in another patch.

It's totally non-obvious that you are *inserting* an RFC1002 length into th=
e received
message. Need to state that, and include the above explanation.

OK on deferring that work. So far so good!

> > > +                       to_copy =3D min_t(int, data_length - offset, =
to_read);
> > > +                       memcpy(
> > > +                               buf + data_read,
> > > +                               (char*)data_transfer + data_offset + =
offset,
> > > +                               to_copy);
> >
> > Is it really necessary to perform all these data copies, especially und=
er the
> > reassembly_queue spinlock? This seems quite inefficient. Can the receiv=
e
> > buffers not be loaned out and chained logically?
>=20
> This will require upper layer code changes to move to use new buffers
> allocated/loaned this way, and also deal with packet boundaries.
>=20
> This code is not used to actually carry file data, which are normally don=
e
> through RDMA read/write.

Disagree - RDMA will only be used when the size exceeds a threshold, perhap=
s 4KB or
even 8KB. That means you'll be performing several memcpy()s for such worklo=
ads.
RDMA is only used for bulk data.

At the very least, try to rearrange the code to avoid holding the reassembl=
y lock for
so long, definitely not when memcpy'ing. It will significantly single-threa=
d all your receives.

> If we want to do it, I suggest do another patch since more changes other =
than
> transport are involved.

Sure, that's fine but 1) we will definitely want to do it and 2) this needs=
 a comment.

Tom.

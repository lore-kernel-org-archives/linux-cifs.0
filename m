From: Long Li <longli@microsoft.com>
Subject: RE: [Patch v2 1/6] cifs: smbd: Check for iov length on sending the
 last iov
Date: Mon, 23 Apr 2018 19:34:23 +0000
Message-ID: <SN4PR2101MB07337EA730A456125CF72787CE890@SN4PR2101MB0733.namprd21.prod.outlook.com>
References: <20180417191710.14855-1-longli@linuxonhyperv.com>
 <DM5PR2101MB1030B8026AC0E48F3E96E739DC8A0@DM5PR2101MB1030.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DM5PR2101MB1030B8026AC0E48F3E96E739DC8A0@DM5PR2101MB1030.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> Subject: RE: [Patch v2 1/6] cifs: smbd: Check for iov length on sending t=
he last
> iov
>=20
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org
> > <linux-kernel-owner@vger.kernel.org> On Behalf Of Long Li
> > Sent: Tuesday, April 17, 2018 12:17 PM
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org;
> > samba- technical@lists.samba.org; linux-kernel@vger.kernel.org;
> > linux-rdma@vger.kernel.org
> > Cc: Long Li <longli@microsoft.com>; stable@vger.kernel.org
> > Subject: [Patch v2 1/6] cifs: smbd: Check for iov length on sending
> > the last iov
> >
> > From: Long Li <longli@microsoft.com>
> >
> > When sending the last iov that breaks into smaller buffers to fit the
> > transfer size, it's necessary to check if this is the last iov.
> >
> > If this is the latest iov, stop and proceed to send pages.
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
> > Cc: stable@vger.kernel.org
>=20
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>=20
> But a question unrelated to this change arose during my review:  At the
> beginning and end of smbd_send(), the field smbd_send_pending is
> incremented and decremented, respectively.   The increment/decrement
> are not done as atomic operations.  Is this code guaranteed to be single
> threaded?  If not, the count could become corrupted, and
> smbd_destroy_rdma_work(), which waits for the count to become zero,
> could hang.  A similar question applies to smbd_recv_pending in smbd_recv=
().

It is safe. The transport sending path is locked by TCP_Server_Info->srv_mu=
tex.

The transport receiving path is single threaded.

>=20
> > ---
> >  fs/cifs/smbdirect.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c index
> > 90e673c..b5c6c0d 100644
> > --- a/fs/cifs/smbdirect.c
> > +++ b/fs/cifs/smbdirect.c
> > @@ -2197,6 +2197,8 @@ int smbd_send(struct smbd_connection *info,
> struct smb_rqst *rqst)
> >  						goto done;
> >  				}
> >  				i++;
> > +				if (i =3D=3D rqst->rq_nvec)
> > +					break;
> >  			}
> >  			start =3D i;
> >  			buflen =3D 0;
> > --
> > 2.7.4

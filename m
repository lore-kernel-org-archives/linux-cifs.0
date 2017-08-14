From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 19/37] [CIFS] SMBD: Manage credits on SMBD client and
 server
Date: Mon, 14 Aug 2017 23:03:42 +0000
Message-ID: <CY4PR21MB0182FD5201C97A969C9B09A2CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-20-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB01823211DE659BEAA7932309A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR21MB01823211DE659BEAA7932309A08C0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 1:47 PM
> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>;
> linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [[PATCH v1] 19/37] [CIFS] SMBD: Manage credits on SMBD clien=
t
> and server
>=20
> > -----Original Message-----
> > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> > Sent: Wednesday, August 2, 2017 4:11 PM
> > To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > samba- technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Subject: [[PATCH v1] 19/37] [CIFS] SMBD: Manage credits on SMBD client
> > and server
> >
> >  /*
> > + * Extend the credits to remote peer
> > + * This implements [MS-SMBD] 3.1.5.9
> > + * The idea is that we should extend credits to remote peer as
> > +quickly as
> > + * it's allowed, to maintain data flow. We allocate as much as
> > +receive
> > + * buffer as possible, and extend the receive credits to remote peer
> > + * return value: the new credtis being granted.
> > + */
> > +static int manage_credits_prior_sending(struct cifs_rdma_info *info)
> > +{
> > +       int ret =3D 0;
> > +       struct cifs_rdma_response *response;
> > +       int rc;
> > +
> > +       if (atomic_read(&info->receive_credit_target) >
>=20
> When does the receive_credit_target value change? It seems wasteful to
> perform an atomic_read() on this local value each time.

It could be potentially changed while receiving a SMBD packet, as specified=
 in MS-SMBD 3.1.5.8.

I agree with you there is no need to use atomic since this value is not inc=
reased or decreased, just being set. Will change it.

>=20
> Tom.

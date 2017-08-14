From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 04/37] [CIFS] SMBD: Define per-channel SMBD transport
 parameters and default values
Date: Mon, 14 Aug 2017 22:57:22 +0000
Message-ID: <CY4PR21MB0182F9ED2FC8791190F4C947CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-5-git-send-email-longli@exchange.microsoft.com>
 <20170813101156.GB17287@infradead.org>
 <CY4PR21MB0182A8FC1B6900BD6EBA96B0A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR21MB0182A8FC1B6900BD6EBA96B0A08C0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 12:29 PM
> To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [[PATCH v1] 04/37] [CIFS] SMBD: Define per-channel SMBD
> transport parameters and default values
>=20
> > -----Original Message-----
> > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Christoph Hellwig
> > Sent: Sunday, August 13, 2017 6:12 AM
> > To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > samba- technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Long
> > Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Subject: Re: [[PATCH v1] 04/37] [CIFS] SMBD: Define per-channel SMBD
> > transport parameters and default values
> >
> > > +/*
> > > + * Per RDMA transport connection parameters
> > > + * as defined in [MS-SMBD] 3.1.1.1
> > > + */
> > > +static int receive_credit_max =3D 512; static int send_credit_target
> > > +=3D 512; static int max_send_size =3D 8192; static int
> > > +max_fragmented_recv_size =3D 1024*1024; static int max_receive_size =
=3D
> > > +8192;
> >
> > Are these protocol constants?  If so please use either #defines or
> > enums with upper case names for them.
>=20
> These are not defined constants, but the values beg for some explanatory
> text why they are chosen. Windows uses, and negotiates by default, a 1364=
-
> byte maximum send size, and caps credits to 255. The other values match.
>=20
> BTW, the parameters are defined in MS-SMBD 3.1.1.1 but the chosen values
> are in behavior notes 2 and 7.

I will change those values to more inline with what Windows choses. The dif=
ferent values don't have a visible impact to performance while RDMA read/wr=
ite is used.

>=20
> Tom.

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 23/37] [CIFS] SMBD: Implement API for upper layer to
 reconnect transport
Date: Mon, 14 Aug 2017 23:37:17 +0000
Message-ID: <CY4PR21MB0182F763422AFCCDB3D88361CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-24-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB0182025BB8A39FB3F7291F94A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR21MB0182025BB8A39FB3F7291F94A08C0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 2:03 PM
> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>;
> linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [[PATCH v1] 23/37] [CIFS] SMBD: Implement API for upper laye=
r
> to reconnect transport
>=20
> > -----Original Message-----
> > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> > Sent: Wednesday, August 2, 2017 4:11 PM
> > To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > samba- technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Subject: [[PATCH v1] 23/37] [CIFS] SMBD: Implement API for upper layer
> > to reconnect transport
> >
> > +int cifs_reconnect_rdma_session(struct TCP_Server_Info *server) {
> > +       log_rdma_event("reconnecting rdma session\n");
> > +
> > +       // why reconnect while it is still connected?
> > +       if (server->rdma_ses->transport_status =3D=3D CIFS_RDMA_CONNECT=
ED)
> {
> > +               log_rdma_event("still connected, not reconnecting\n");
> > +               return -EINVAL;
> > +       }
>=20
> Why is this check needed?

This was used in early stage of development. It's probably not needed anymo=
re. Will look into this.

>=20
> > +
> > +       // wait until the transport is destroyed
> > +       while (server->rdma_ses->transport_status !=3D
> CIFS_RDMA_DESTROYED)
> > +               msleep(1);
>=20
> Polling!? Please plan to implement a proper handshake for connection logi=
c.

Will look into using wait queue.

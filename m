From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with no
 payload
Date: Mon, 14 Aug 2017 23:12:31 +0000
Message-ID: <CY4PR21MB0182C79BF7C81C249A84F56EA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-17-git-send-email-longli@exchange.microsoft.com>
 <20170813102412.GH17287@infradead.org>
 <CY4PR21MB0182366FB8C2EC58B6A77910CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
 <CY4PR21MB0182AF2A752D333E367F2FC4A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
 <CY4PR21MB0182E3DB8E034407509E3205CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR21MB0182E3DB8E034407509E3205CE8C0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: Long Li
> Sent: Monday, August 14, 2017 6:51 PM
> To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Christoph Hellwig
> <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with no
> payload
>=20
>=20
>=20
> > -----Original Message-----
> > From: Tom Talpey
> > Sent: Monday, August 14, 2017 12:00 PM
> > To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Christoph Hellwig <hch-wEGCiKHe2LouzsEnZMApLA@public.gmane.org=
g>
> > Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba=
-
> > technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: RE: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with n=
o
> > payload
> >
> > > -----Original Message-----
> > > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> > > Sent: Monday, August 14, 2017 2:20 PM
> > > To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > > Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > samba- technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Subject: RE: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with
> > > no payload
> > >
> > > > > Implement the function to send a SMBD message with no payload.
> > > > > This is
> > > > required at times when we want to extend credtis to server to have
> > > > it continue to send data, without sending any actual data payload.
> > > >
> > > > Shouldn't this just be implemented as a special case in the version
> > > > that posts data?
> > >
> > > It uses a different packet format "struct smbd_data_transfer_no_data"=
.
> > > I can restructure some common code to share between packet sending
> > functions.
> >
> > The SMB Direct keepalive is just a Data Transfer Message with no payloa=
d
> > (MS-SMBD section 2.2.3) and the SMB_DIRECT_RESPONSE_REQUESTED flag
> > possibly set.  I don't see any need to define a special structure to de=
scribe
> > this?
>=20
> Data Transfer Message has the following extra fields at the end of an emp=
ty
> packet.
>=20
>         __le32 padding;

No need to omit the padding, it's ignored anyway and the DataLength is zero
so there's no other payload to consume. You can send a packet of pretty muc=
h
any length. Just send the regular struct.

BTW, the "padding" field is defined as variable array of bytes, meaning sem=
antically
you might want to code it as u8 padding[0] as well. However in practice it =
is
either 4 bytes or not present at all, so you'd probably end up writing extr=
a code
for that choice.

>         char buffer[0];
>=20
> I agree with you those can be merged to a special structure case. Will ma=
ke the
> change.

Tom.

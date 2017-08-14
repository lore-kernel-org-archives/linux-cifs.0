From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [[PATCH v1] 04/37] [CIFS] SMBD: Define per-channel SMBD transport
 parameters and default values
Date: Mon, 14 Aug 2017 19:28:45 +0000
Message-ID: <CY4PR21MB0182A8FC1B6900BD6EBA96B0A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-5-git-send-email-longli@exchange.microsoft.com>
 <20170813101156.GB17287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
        Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170813101156.GB17287@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Sunday, August 13, 2017 6:12 AM
> To: Long Li <longli@microsoft.com>
> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: Re: [[PATCH v1] 04/37] [CIFS] SMBD: Define per-channel SMBD
> transport parameters and default values
>=20
> > +/*
> > + * Per RDMA transport connection parameters
> > + * as defined in [MS-SMBD] 3.1.1.1
> > + */
> > +static int receive_credit_max =3D 512;
> > +static int send_credit_target =3D 512;
> > +static int max_send_size =3D 8192;
> > +static int max_fragmented_recv_size =3D 1024*1024;
> > +static int max_receive_size =3D 8192;
>=20
> Are these protocol constants?  If so please use either #defines
> or enums with upper case names for them.

These are not defined constants, but the values beg for some explanatory te=
xt
why they are chosen. Windows uses, and negotiates by default, a 1364-byte
maximum send size, and caps credits to 255. The other values match.

BTW, the parameters are defined in MS-SMBD 3.1.1.1 but the chosen values
are in behavior notes 2 and 7.

Tom.

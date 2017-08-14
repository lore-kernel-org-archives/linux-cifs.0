From: Long Li <longli@microsoft.com>
Subject: RE: [[PATCH v1] 30/37] [CIFS] SMBD: Add SMBDirect transport to
 Makefile
Date: Mon, 14 Aug 2017 23:30:56 +0000
Message-ID: <CY4PR21MB018280229D31930172B21412CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-31-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB0182D411A74EC17CEA5BD63BA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Tom Talpey <ttalpey@microsoft.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CY4PR21MB0182D411A74EC17CEA5BD63BA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 2:20 PM
> To: Long Li <longli@microsoft.com>; Steve French <sfrench@samba.org>;
> linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [[PATCH v1] 30/37] [CIFS] SMBD: Add SMBDirect transport to
> Makefile
>=20
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> > owner@vger.kernel.org] On Behalf Of Long Li
> > Sent: Wednesday, August 2, 2017 4:11 PM
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org;
> > samba- technical@lists.samba.org; linux-kernel@vger.kernel.org
> > Cc: Long Li <longli@microsoft.com>
> > Subject: [[PATCH v1] 30/37] [CIFS] SMBD: Add SMBDirect transport to
> > Makefile
> >
> >  cifs-$(CONFIG_CIFS_SMB2) +=3D smb2ops.o smb2maperror.o
> smb2transport.o \
> > -                           smb2misc.o smb2pdu.o smb2inode.o smb2file.o
> > +                           smb2misc.o smb2pdu.o smb2inode.o
> > + smb2file.o cifsrdma.o
>=20
> "cifsrdma.o" is a really confusing choice of names. SMB Direct is only po=
ssible
> when the negotiated SMB dialect is SMB3. "CIFS" historically means a dial=
ect
> of SMB1, which many of us would like to see be in a separate, and therefo=
re
> omittable, module. Please use a name more indicative of the function,
> perhaps "smbdirect.o".

Yes, I will make the naming changes.

>=20
> Tom.

From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 1/6] cifs: smbd: Check for iov length on sending the last
 iov
Date: Tue, 17 Apr 2018 17:55:00 +0000
Message-ID: <MWHPR2101MB0729066A1D5BB83987440EDECEB70@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180417004918.29213-1-longli@linuxonhyperv.com>
 <20180417072923.GA15310@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417072923.GA15310@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> Subject: Re: [PATCH 1/6] cifs: smbd: Check for iov length on sending the =
last
> iov
>=20
> On Mon, Apr 16, 2018 at 05:49:13PM -0700, Long Li wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > When sending the last iov that breaks into smaller buffers to fit the
> > transfer size, it's necessary to check if this is the last iov.
> >
> > If this is the latest iov, stop and proceed to send pages.
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
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
>=20
> <formletter>
>=20
> This is not the correct way to submit patches for inclusion in the stable=
 kernel
> tree.  Please read:
>=20
> https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.
> kernel.org%2Fdoc%2Fhtml%2Flatest%2Fprocess%2Fstable-kernel-
> rules.html&data=3D02%7C01%7Clongli%40microsoft.com%7Cec2fc0284244483b
> 25bf08d5a434f6dc%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C636
> 595469807590402&sdata=3DYXqnaTFgRyUyN1ubhCcyblT2ni%2F%2BCowPYJSFje
> 6PuCk%3D&reserved=3D0
> for how to do this properly.
>=20
> </formletter>

Will do. Thank you.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in =
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> https://na01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fvger.ke
> rnel.org%2Fmajordomo-
> info.html&data=3D02%7C01%7Clongli%40microsoft.com%7Cec2fc0284244483b2
> 5bf08d5a434f6dc%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6365
> 95469807590402&sdata=3Duu9VQ%2BHscmeFJH6kQEf39G2a7Y8M9hMmvBI2s9
> T1DXs%3D&reserved=3D0

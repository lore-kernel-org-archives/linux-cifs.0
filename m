From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 00/37] Implement SMBD protocol: Series 1
Date: Mon, 14 Aug 2017 17:04:00 +0000
Message-ID: <CY4PR21MB0182904214739513EA9A2DDCCE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <20170813102735.GI17287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813102735.GI17287-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org]
> Sent: Sunday, August 13, 2017 3:28 AM
> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Long Li
> <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: Re: [[PATCH v1] 00/37] Implement SMBD protocol: Series 1
>=20
> Hi Long,
>=20
> a few meta-comments:
>=20
> first the split into lots of tiny lists makes the series really hard to r=
ead, I'd split
> it into just a few:
>=20
>  Patch 1: add the protocol constants
>  Patch 2-n: core cifs modifcation required to implement SMBD  Patch n+1:
> add the actual SMBD code  Patch n+2..m: write up the core CIFS code to us=
e
> it.
>=20
> stcond a lot of the code doesn't seem to follow the usual Linux style.
> It might be a good idea to run it through scripts/checkpach.pl and at lea=
st fix
> the errors it generates.  The warnings are much more opinioned so feel fr=
ee
> to ignore them if they sound odd for now.

Hi Christoph

Thank you for reviewing the patch set.

I'll address those comments and update the patches.

Long

From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 30/37] [CIFS] SMBD: Add SMBDirect transport to
 Makefile
Date: Mon, 14 Aug 2017 21:20:01 +0000
Message-ID: <CY4PR21MB0182D411A74EC17CEA5BD63BA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-31-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-31-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> Sent: Wednesday, August 2, 2017 4:11 PM
> To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: [[PATCH v1] 30/37] [CIFS] SMBD: Add SMBDirect transport to Makef=
ile
>=20
>  cifs-$(CONFIG_CIFS_SMB2) +=3D smb2ops.o smb2maperror.o smb2transport.o \
> -                           smb2misc.o smb2pdu.o smb2inode.o smb2file.o
> +                           smb2misc.o smb2pdu.o smb2inode.o smb2file.o c=
ifsrdma.o

"cifsrdma.o" is a really confusing choice of names. SMB Direct is only
possible when the negotiated SMB dialect is SMB3. "CIFS" historically
means a dialect of SMB1, which many of us would like to see be in
a separate, and therefore omittable, module. Please use a name
more indicative of the function, perhaps "smbdirect.o".

Tom.

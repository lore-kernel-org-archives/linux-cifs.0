From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/2] cifs: remove rfc1002 header from all SMB2 response
 structures
Date: Wed, 3 Jan 2018 18:26:52 +0000
Message-ID: <DM5PR2101MB0886F4E951689CB179F9215FA01E0@DM5PR2101MB0886.namprd21.prod.outlook.com>
References: <20180102223524.8389-1-lsahlber@redhat.com>
 <20180102223524.8389-2-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102223524.8389-2-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ronnie Sahlberg
> Sent: Tuesday, January 2, 2018 5:35 PM
> To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Subject: [PATCH 1/2] cifs: remove rfc1002 header from all SMB2 response
> structures
>=20
> Separate out all the 4 byte rfc1002 headers so that they are no longer
> part of the SMB2 header structures to prepare for future work to add
> compounding support.
>=20
> When using compounding, the wire format will consist of a single
> rfc1002 length header followed by one, or more, SMB2 headers, like this :
>=20
> * 4 byte rfc1002 length
> * SMB2 header
> * SMB2 header
> * ...

Comment purely on the changelog.

This second paragraph is somewhat misleading, and should perhaps be omitted=
.
The RFC1002 length is a transport frame marker, and used only on stream-bas=
ed
transports such as TCP. For example, it's not present when the transport is
SMB Direct. There is no protocol dependency on its use by Compounding.

Tom.

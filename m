From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Patch v2 00/19] CIFS: Implement SMBDirect
Date: Wed, 30 Aug 2017 07:16:16 +0200
Message-ID: <8f07f19a-1fdf-b284-6fcc-e04920fe70db@samba.org>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <CAL1RGDUGiOqjB8n0mJmF079jm7vXrdzE2rHdzoNOexvgHScjUQ@mail.gmail.com>
 <CY4PR21MB01821B704C2F64F72A8A92A9CE9F0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ECq4buv9FHFDGCf3Udt3tH5PHNLRofpC2"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR21MB01821B704C2F64F72A8A92A9CE9F0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ECq4buv9FHFDGCf3Udt3tH5PHNLRofpC2
Content-Type: multipart/mixed; boundary="5Qea2WM35eg2H7AvU9ojP43XKRC3sjkNl";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
 LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Message-ID: <8f07f19a-1fdf-b284-6fcc-e04920fe70db-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Patch v2 00/19] CIFS: Implement SMBDirect
References: <1503255883-3041-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
 <CAL1RGDUGiOqjB8n0mJmF079jm7vXrdzE2rHdzoNOexvgHScjUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <CY4PR21MB01821B704C2F64F72A8A92A9CE9F0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <CY4PR21MB01821B704C2F64F72A8A92A9CE9F0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--5Qea2WM35eg2H7AvU9ojP43XKRC3sjkNl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

>> This is great to see.  Is there a Linux implementation of the server s=
ide (in
>> Samba?) so that the client can be tested without needing a Windows ser=
ver?
>=20
> I'm not aware of a Linux implementation on server side.

Here's a very early work in progress branch:
https://git.samba.org/?p=3Dmetze/samba/wip.git;a=3Dshortlog;h=3Drefs/head=
s/master3-rdma
It only explores how the protocol works, as it uses a userspace
smb-direct proxy (which works around the missing fork support of the
userspace libibverbs), which makes it really slow, but is required
in order to have the code tested in Samba's autobuild.

I think once this code lands in the kernel tree, we'll be able to
arrange a userspace api to it, in order to make a useful implementation,
so we can skip the userspace smb-dorect proxy.

metze


--5Qea2WM35eg2H7AvU9ojP43XKRC3sjkNl--

--ECq4buv9FHFDGCf3Udt3tH5PHNLRofpC2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJZpkokAAoJEA219WEoab1WmDcP/iueqmtLcz6B1a5QmFJq/GlJ
QTY+dAC0abylcjKEfQ9JoUkWRIyL3OsXB106KwaaQ2IZ6Tx0xgqblENGp8fkmEgb
tT/4XpvDUB4ZTApUXZJkfrb/UXum/CL7HlU44dhyrmC/pvNEGr76EH9ZXYsMrPQq
JWr2JmX3Igvuj769RGkgbx7ASBmo2aWIuYdkzu8n3yB9yg43EQfQFEBRzRqWmFEF
RvtXTa200hYAHiyC1J/btPJ4S9OpGtKJySUnyQ0e1bDwPMusJqkMrPDm94mRdlcv
Jd3r1S/VS4cW6fPPbLRyL8Dub8kVXlmvjeOUfrET88dbbwWdLEVMJzGntDA0woOo
6kLQs3T8PDGx7psLF00ycrjRLNWO6/YVg5FU+fQ994weytNRnB8Ir/9WTBg7l+mw
rLXOou8SnxMN/9lYTWx/LLVXeh+bGJQwyieKM9DvRjm9SUHsV0kX+bMQgxIcZd5q
2oGUJsF2TdxLpXNaruiJYpHpB4X8pNvgB2m1cN9blMYdozST1zNQVYJyHrMfJglN
DbOPnL2jjMCeQauKR1ZPF/DYlhh60ncPZg/0WsBFsvzUNDjWjuqHpP8prbJLxqAq
uxxHCQRYzF3teJ0lhNeP3BosX+QQogOZBqKE29/f546JEpTTe8rRV5ilb63R2NlK
ymi6CzOulXfXThVnK1zo
=Kfwr
-----END PGP SIGNATURE-----

--ECq4buv9FHFDGCf3Udt3tH5PHNLRofpC2--

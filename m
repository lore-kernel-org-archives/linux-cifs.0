From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Thu, 28 Feb 2013 16:11:51 -0800
Message-ID: <20130228161151.0fbbff98@corrin.poochiereds.net>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
	<20130227083419.0af9deaf@corrin.poochiereds.net>
	<512E8787.6070709@canonical.com>
	<20130228072637.3b71a4f7@corrin.poochiereds.net>
	<E1UBCMh-00FRaK-CC@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chiluk <dave.chiluk-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Dave Chiluk <chiluk-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: =?ISO-8859-1?B?Qmr2cm4=?= JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1UBCMh-00FRaK-CC-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Feb 2013 23:54:13 +0100
Bj=F6rn JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org> wrote:

> On 2013-02-28 at 07:26 -0800 Jeff Layton sent off:
> > NTFS doesn't support sparse files, so the OS has to zero-fill up to=
 the
> > point where you're writing. That can take a looooong time on slow
> > storage (minutes even).
>=20
> but you are talking about FAT here, right? NTFS does support sparse f=
iles if
> the sparse bit has been explicitly been set on it. Bit even if the sp=
arse bit
> is not set filling a file with zeros by writing after a seek long bey=
ond the
> end of the file is very fast because NTFS supports that feature what =
Unix
> filesystems like xfs call extents.
>=20
> If writing beyond the end of a file is really slow via cifs vfs in th=
e test
> case against a ntfs volume then I wonder if that operation is being r=
eally done
> optimally over the wire. ntfs really isn't that bad with handling thi=
s kind of
> files.
>=20

I'm not sure since I don't know the internals of NTFS. I had always
assumed that it didn't really handle sparse files well (hence the
"rabbit-pellet" thing that windows clients do).

All I can say however is that writes long past the EOF can take a
*really* long time to run. Typically we just issue a SMB_COM_WRITEX at
the offset to which we want to put the data. Is there some other way we
ought to be doing this?

In any case, it doesn't really change the fact that there is no
guaranteed time of response from CIFS servers. They can easily take a
really long time to respond to certain requests. The best method we
have to deal with that is to periodically "ping" the server with an
echo to see if it's still there.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

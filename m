From: Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Sun, 12 Jun 2016 20:01:44 +0200
Message-ID: <575DA388.5030002@fu-berlin.de>
References: <20160527194346.08416d79@aaptelpc>
 <20160609185027.7349f260@aaptelpc> <5759C326.5040508@fu-berlin.de>
 <20160610171649.3e12b95c@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160610171649.3e12b95c@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/10/2016 05:16 PM, Aur=C3=A9lien Aptel wrote:
> On Thu, 9 Jun 2016 21:27:34 +0200 Marcus Hoffmann
> <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org> wrote:
>> Hey Aur=C3=A9lien,
>> with your script I can reproduce the bug locally now.
>=20
> Good.
>=20
>> I can mount the share (which is on a Windows 8.1 vm) with a Windows =
7
>> PC with the restricted user account. (Even in hard mode.)
>> I can mount the share from Linux-cifs using the admin user but not t=
he
>> restricted user.
>=20
> I've moved some things around. All of the prefix path components are
> now checked for accessibility in cifs_do_mount(). This is more
> robust and it lets us set the CIFS_MOUNT_USE_PREFIX_PATH flag earlier=
=2E
>=20
> I've updated the cifs_root_iget() to use the prefix path when necessa=
ry
> which should take care of the last case (hard mode).
>=20
> Please test my latest patch (attached).

I can confirm it works with our setup now.
Any chance in getting this merged?

>=20
>> (I noticed though that no user has access to the file in the shared
>> dir. But this doesn't really matter for the test.)
>=20
> Indeed.
>=20

Thanks for your work on this,
Marcus

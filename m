From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable
 (aka solving bsc#8950 ...again)
Date: Fri, 29 Jul 2016 14:11:04 +0100
Message-ID: <1469797864.14723.15.camel@redhat.com>
References: <20160527194346.08416d79@aaptelpc>
	 <20160609185027.7349f260@aaptelpc> <5759C326.5040508@fu-berlin.de>
	 <20160610171649.3e12b95c@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
	Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160610171649.3e12b95c@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2016-06-10 at 17:16 +0200, Aur=C3=A9lien Aptel wrote:
> On Thu, 9 Jun 2016 21:27:34 +0200 Marcus Hoffmann
> <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org> wrote:
> >=20
> > Hey Aur=C3=A9lien,
> > with your script I can reproduce the bug locally now.
> Good.
>=20
> >=20
> > I can mount the share (which is on a Windows 8.1 vm) with a Windows
> > 7
> > PC with the restricted user account. (Even in hard mode.)
> > I can mount the share from Linux-cifs using the admin user but not
> > the
> > restricted user.
> I've moved some things around. All of the prefix path components are
> now checked for accessibility in cifs_do_mount(). This is more
> robust and it lets us set the CIFS_MOUNT_USE_PREFIX_PATH flag
> earlier.
>=20
> I've updated the cifs_root_iget() to use the prefix path when
> necessary
> which should take care of the last case (hard mode).
>=20
> Please test my latest patch (attached).
>=20
> >=20
> > (I noticed though that no user has access to the file in the shared
> > dir. But this doesn't really matter for the test.)
> Indeed.
>=20


Hello,

Sorry for the late reply but this has to be a NACK from me.

We need to check for=C2=A0CIFS_MOUNT_USE_PREFIX_PATH
and if set, check cifs_sb->prepath for both old and new
in=C2=A0cifs_match_super().

Else we have the following bug:

Consider 2 different mounts on a server where root access is limited. I
used the reproducer for this case but simply created a separate folder
in the root directory to which the user has access. I then attempt to
mount the 2 separate folders in 2 different locations.

# mount -t cifs -vvv -o username=3Dwintest1,password=3Dxxx //vm140-
52/test2/sub/dir /mnt
# mount -t cifs -vvv -o username=3Dwintest1,password=3Dxxx //vm140-
52/test2/sub2/ /mnt2

# grep mnt /proc/mounts
//vm140-52/test2/sub/dir /mnt cifs
rw,relatime,vers=3D1.0,cache=3Dstrict,username=3Dwintest1,domain=3DENG1=
,uid=3D0,n
oforceuid,gid=3D0,noforcegid,addr=3D192.168.140.52,file_mode=3D0755,dir=
_mode=3D
0755,nounix,serverino,mapposix,rsize=3D61440,wsize=3D16580,echo_interva=
l=3D60
,actimeo=3D1 0 0
//vm140-52/test2/sub2/ /mnt2 cifs
rw,relatime,vers=3D1.0,cache=3Dstrict,username=3Dwintest1,domain=3DENG1=
,uid=3D0,n
oforceuid,gid=3D0,noforcegid,addr=3D192.168.140.52,file_mode=3D0755,dir=
_mode=3D
0755,nounix,serverino,mapposix,rsize=3D61440,wsize=3D16580,echo_interva=
l=3D60
,actimeo=3D1 0 0

but since we do not compare the prepath, we end up with the same share
mounted at both mount points. This is the share mounted first.

To confirm.

# date >/mnt/test
# cat /mnt/test /mnt2/test
=46ri 29 Jul 14:05:19 BST 2016
=46ri 29 Jul 14:05:19 BST 2016

Steve,=C2=A0

Can you recall the earlier patch or should I write a fix for this?

Sachin Prabhu

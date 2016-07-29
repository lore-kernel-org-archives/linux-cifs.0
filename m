From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Fri, 29 Jul 2016 15:20:26 -0500
Message-ID: <CAH2r5mvmp9wNYOzeB03nynMZKa+pJrK35S_Y1dtj5GJMG-2DUA@mail.gmail.com>
References: <20160527194346.08416d79@aaptelpc> <20160609185027.7349f260@aaptelpc>
 <5759C326.5040508@fu-berlin.de> <20160610171649.3e12b95c@aaptelpc>
 <1469797864.14723.15.camel@redhat.com> <1469799107.14723.18.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
	Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469799107.14723.18.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Let's add your fix as a followon patch

On Fri, Jul 29, 2016 at 8:31 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> On Fri, 2016-07-29 at 14:11 +0100, Sachin Prabhu wrote:
>> On Fri, 2016-06-10 at 17:16 +0200, Aur=C3=A9lien Aptel wrote:
>> >
>> > On Thu, 9 Jun 2016 21:27:34 +0200 Marcus Hoffmann
>> > <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org> wrote:
>> > >
>> > >
>> > > Hey Aur=C3=A9lien,
>> > > with your script I can reproduce the bug locally now.
>> > Good.
>> >
>> > >
>> > >
>> > > I can mount the share (which is on a Windows 8.1 vm) with a
>> > > Windows
>> > > 7
>> > > PC with the restricted user account. (Even in hard mode.)
>> > > I can mount the share from Linux-cifs using the admin user but
>> > > not
>> > > the
>> > > restricted user.
>> > I've moved some things around. All of the prefix path components
>> > are
>> > now checked for accessibility in cifs_do_mount(). This is more
>> > robust and it lets us set the CIFS_MOUNT_USE_PREFIX_PATH flag
>> > earlier.
>> >
>> > I've updated the cifs_root_iget() to use the prefix path when
>> > necessary
>> > which should take care of the last case (hard mode).
>> >
>> > Please test my latest patch (attached).
>> >
>> > >
>> > >
>> > > (I noticed though that no user has access to the file in the
>> > > shared
>> > > dir. But this doesn't really matter for the test.)
>> > Indeed.
>> >
>>
>> Hello,
>>
>> Sorry for the late reply but this has to be a NACK from me.
>>
>> We need to check for CIFS_MOUNT_USE_PREFIX_PATH
>> and if set, check cifs_sb->prepath for both old and new
>> in cifs_match_super().
>>
>> Else we have the following bug:
>>
>> Consider 2 different mounts on a server where root access is limited=
=2E
>> I
>> used the reproducer for this case but simply created a separate
>> folder
>> in the root directory to which the user has access. I then attempt t=
o
>> mount the 2 separate folders in 2 different locations.
>>
>> # mount -t cifs -vvv -o username=3Dwintest1,password=3Dxxx //vm140-
>> 52/test2/sub/dir /mnt
>> # mount -t cifs -vvv -o username=3Dwintest1,password=3Dxxx //vm140-
>> 52/test2/sub2/ /mnt2
>>
>> # grep mnt /proc/mounts
>> //vm140-52/test2/sub/dir /mnt cifs
>> rw,relatime,vers=3D1.0,cache=3Dstrict,username=3Dwintest1,domain=3DE=
NG1,uid=3D0
>> ,n
>> oforceuid,gid=3D0,noforcegid,addr=3D192.168.140.52,file_mode=3D0755,=
dir_mod
>> e=3D
>> 0755,nounix,serverino,mapposix,rsize=3D61440,wsize=3D16580,echo_inte=
rval=3D
>> 60
>> ,actimeo=3D1 0 0
>> //vm140-52/test2/sub2/ /mnt2 cifs
>> rw,relatime,vers=3D1.0,cache=3Dstrict,username=3Dwintest1,domain=3DE=
NG1,uid=3D0
>> ,n
>> oforceuid,gid=3D0,noforcegid,addr=3D192.168.140.52,file_mode=3D0755,=
dir_mod
>> e=3D
>> 0755,nounix,serverino,mapposix,rsize=3D61440,wsize=3D16580,echo_inte=
rval=3D
>> 60
>> ,actimeo=3D1 0 0
>>
>> but since we do not compare the prepath, we end up with the same
>> share
>> mounted at both mount points. This is the share mounted first.
>>
>> To confirm.
>>
>> # date >/mnt/test
>> # cat /mnt/test /mnt2/test
>> Fri 29 Jul 14:05:19 BST 2016
>> Fri 29 Jul 14:05:19 BST 2016
>>
>> Steve,
>>
>> Can you recall the earlier patch or should I write a fix for this?
>>
>> Sachin Prabhu
>
> This bug in the patch was masked by another issue which was fixed by
> the patch
>
> cifs: unbreak TCP session reuse
> by Rabin Vincent which has been posted to go into upstream at the sam=
e
> time as this patch.
>
> Sachin Prabhu



--=20
Thanks,

Steve

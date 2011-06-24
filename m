From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [git pull] ->mount() regression fixes for cifs
Date: Fri, 24 Jun 2011 18:03:54 -0500
Message-ID: <BANLkTi=UfAtWB=H_azoRcgeHciJaZkT05A@mail.gmail.com>
References: <20110611111253.GD11521@ZenIV.linux.org.uk>
	<BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg@mail.gmail.com>
	<20110617035421.GO11521@ZenIV.linux.org.uk>
	<20110617140833.GA9563@ZenIV.linux.org.uk>
	<BANLkTi=mH-9F9N4Gz8JJqL==Hm5p8Y1_tQ@mail.gmail.com>
	<20110620085943.6371af1b@corrin.poochiereds.net>
	<BANLkTinfETnDdcBFkQNq8pLZPQOGsVRuGA@mail.gmail.com>
	<20110620161516.GU11521@ZenIV.linux.org.uk>
	<BANLkTi=nYfiy0qnHPXs2fckCPNJXwbpi7Q@mail.gmail.com>
	<20110624064810.495dec99@corrin.poochiereds.net>
	<20110624225414.GA11013@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110624225414.GA11013-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have reviewed most of it and am fine with it going out of your tree.

On Fri, Jun 24, 2011 at 5:54 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrot=
e:
>> > Al, what is the status of your patchset? Note, that you can add my
>> > "Acked-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>" tag as well if y=
ou
>> > need it.
>> >
>>
>> Yes, I've looked over the set and it looks good to me. Nice cleanup,
>> Al. You can add my:
>>
>> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> OK... =A0The patchset fixes breakage that got into cifs ->mount() sin=
ce
> cifs had started to play with shared superblocks - sget() races, leak=
s,
> etc. =A0Commit dates are recent due to added Acked-by and Reviewed-by=
;
> other than that, it's an exact copy of the stuff that sat in for-next=
=2E
> What is the proper way to deal with such situations, BTW? =A0I know t=
hat
> you seriously dislike being asked to pull just-created commits, but
> the normal reasons do not apply in this case... =A0Please, pull from
> the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-l=
inus
>
> Shortlog:
> Al Viro (15):
> =A0 =A0 =A0take bdi setup/destruction into cifs_mount/cifs_umount
> =A0 =A0 =A0cifs: double free on mount failure
> =A0 =A0 =A0cifs: don't leak nls on mount failure
> =A0 =A0 =A0cifs: don't pass superblock to cifs_mount()
> =A0 =A0 =A0cifs: leak on mount if we share superblock
> =A0 =A0 =A0cifs: allocate mountdata earlier
> =A0 =A0 =A0cifs: initialize ->tlink_tree in cifs_setup_cifs_sb()
> =A0 =A0 =A0sanitize cifs_umount() prototype
> =A0 =A0 =A0cifs: pull cifs_mount() call up
> =A0 =A0 =A0cifs: move cifs_umount() call into ->kill_sb()
> =A0 =A0 =A0cifs: pull freeing mountdata/dropping nls/freeing cifs_sb =
into cifs_umount()
> =A0 =A0 =A0cifs: close sget() races
> =A0 =A0 =A0cifs: more breakage on mount failures
> =A0 =A0 =A0cifs: tidy cifs_do_mount() up a bit
> =A0 =A0 =A0cifs: propagate errors from cifs_get_root() to mount(2)
>
> Diffstat:
> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0156 +++++++++++++++++++++-----------=
------------------
> =A0fs/cifs/cifsproto.h =A0| =A0 =A08 +-
> =A0fs/cifs/connect.c =A0 =A0| =A0 49 +++++++++-------
> =A04 files changed, 98 insertions(+), 116 deletions(-)
>



--=20
Thanks,

Steve

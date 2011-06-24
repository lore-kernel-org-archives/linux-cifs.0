From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [git pull] ->mount() regression fixes for cifs
Date: Fri, 24 Jun 2011 23:54:14 +0100
Message-ID: <20110624225414.GA11013@ZenIV.linux.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110624064810.495dec99-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> > Al, what is the status of your patchset? Note, that you can add my
> > "Acked-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>" tag as well if you
> > need it.
> > 
> 
> Yes, I've looked over the set and it looks good to me. Nice cleanup,
> Al. You can add my:
> 
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

OK...  The patchset fixes breakage that got into cifs ->mount() since
cifs had started to play with shared superblocks - sget() races, leaks,
etc.  Commit dates are recent due to added Acked-by and Reviewed-by;
other than that, it's an exact copy of the stuff that sat in for-next.
What is the proper way to deal with such situations, BTW?  I know that
you seriously dislike being asked to pull just-created commits, but
the normal reasons do not apply in this case...  Please, pull from
the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (15):
      take bdi setup/destruction into cifs_mount/cifs_umount
      cifs: double free on mount failure
      cifs: don't leak nls on mount failure
      cifs: don't pass superblock to cifs_mount()
      cifs: leak on mount if we share superblock
      cifs: allocate mountdata earlier
      cifs: initialize ->tlink_tree in cifs_setup_cifs_sb()
      sanitize cifs_umount() prototype
      cifs: pull cifs_mount() call up
      cifs: move cifs_umount() call into ->kill_sb()
      cifs: pull freeing mountdata/dropping nls/freeing cifs_sb into cifs_umount()
      cifs: close sget() races
      cifs: more breakage on mount failures
      cifs: tidy cifs_do_mount() up a bit
      cifs: propagate errors from cifs_get_root() to mount(2)

Diffstat:
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |  156 +++++++++++++++++++++-----------------------------
 fs/cifs/cifsproto.h  |    8 +-
 fs/cifs/connect.c    |   49 +++++++++-------
 4 files changed, 98 insertions(+), 116 deletions(-)

From: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Subject: CIFS fails to automount DFS shares
Date: Mon, 17 Oct 2011 11:59:02 +0200
Message-ID: <1318845543-15085-1-git-send-email-gerlando.falauto@keymile.com>
Cc: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I am new here, so please forgive me if I am abusing something or being
too verbose...
I found a problem with samba/CIFS when the server uses DFS.
The same problem (or at least a similar one) has also been reported in:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/740062
https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/809243

What happens is that when you mount a SAMBA share which has DFS folders
(i.e. folders which are physically located at another server, sort-of a
remote symlink), you get the following error when you try to access that
directory. 

$ mount -t cifs //server/dfs /mnt/dfs
$ cd /mnt/dfs
$ ls -l
total 0
drwx------ 0 user     root 0 May  4  2010 test
$ cd test
bash: cd: test: Is a directory

What should happen instead is that the remote share should get
automagically mounted under "/mnt/dfs/test".

Apparently it all started here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=01c64feac45cea1317263eabc4f7ee1b240f297f

which introduced automount for CIFS mounts as well (as opposed to
simulating a symlink), and was admittedly untested.
So apparently this problem has been lying around since 2.6.38-rc1.

I did some futher investigation and found that this behaviour only
appears when the name of the directory in question has been cached
somehow.
So, for instance, if you do not "ls" on "/mnt/dfs" before tryint to "cd
test", the remote share gets happily mounted.
Everything also works when trying to cd into "test" spelled with a
different case: "cd Test", "cd TEST", cd "TeSt" would always succeed.
Also in that case the direntry would not be present.
The missing point in the broken case is that follow_automount() is not
called beacuse DCACHE_NEED_AUTOMOUNT is not set, and apparently
d_instantiate() is the only way to go.

This patch seems to fix the problem by marking as no-longer-valid a
dentry whose inode turned out to be of automount type; I am no expert in
this area so I am not quite sure this is the best way to approach this.

Particularly, according to Documentation/filesystems/vfs.txt:
(((
d_revalidate may be called in rcu-walk mode (nd->flags & LOOKUP_RCU).
If in rcu-walk mode, the filesystem must revalidate the dentry without
blocking or storing to the dentry, d_parent and d_inode should not be
used without care (because they can go NULL), instead nd->inode should
be used.
)))

but nd->inode is definitely something different than direntry->d_inode.

Thank you.
Gerlando

P.S. I just noticed how nfs_lookup_verify_inode() does pretty much the
same thing, so maybe my proposal is not that foolish after all.

Gerlando Falauto (1):
  CIFS: fix automount for DFS shares

 fs/cifs/dir.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

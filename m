From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Don't replace dentries for dfs mounts
Date: Thu,  2 Apr 2015 14:51:35 +0100
Message-ID: <1427982695-29891-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Doing a readdir on a dfs root can result in the dentries for directorie=
s
with a dfs share mounted  being replaced by new dentries for objects
returned by the readdir call. These new dentries on shares mounted with
unix extenstions show up as symlinks pointing to the dfs share.

 # mount -t cifs -o sec=3Dnone  //vm140-31/dfsroot cifs
 # stat cifs/testlink/testfile; ls -l cifs
  File: =E2=80=98cifs/testlink/testfile=E2=80=99
  Size: 0         	Blocks: 0          IO Block: 16384  regular
empty file
Device: 27h/39d	Inode: 130120      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root=
)
Access: 2015-03-31 13:55:50.106018200 +0100
Modify: 2015-03-31 13:55:50.106018200 +0100
Change: 2015-03-31 13:55:50.106018200 +0100
 Birth: -
total 0
drwxr-xr-x 2 root root  0 Mar 31 13:54 testdir
lrwxrwxrwx 1 root root 19 Mar 24 14:25 testlink -> \vm140-31\test

In the example above, the stat command mounts the dfs share at
cifs/testlink. The subsequent ls on the dfsroot directory replaces the
dentry for testlink with a symlink.

In the earlier code, the d_invalidate command returned an -EBUSY error
when attempting to invalidate directories. This stopped the code from
replacing the directories with symlinks returned by the readdir call.
Changes were recently made to the d_invalidate() command so
that it no longer returns an error code. This results in the directory
with the mounted dfs share being replaced by a symlink which denotes a
dfs share.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index c295338..b4bda47 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -90,6 +90,8 @@ cifs_prime_dcache(struct dentry *parent, struct qstr =
*name,
 	if (dentry) {
 		inode =3D dentry->d_inode;
 		if (inode) {
+			if (d_mountpoint(dentry))
+				goto out;
 			/*
 			 * If we're generating inode numbers, then we don't
 			 * want to clobber the existing one with the one that
--=20
2.1.0

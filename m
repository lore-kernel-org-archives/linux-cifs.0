From: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: [BUG] Regression in mfsymlink handling introduced by "cifs: only
 set ops for inodes in I_NEW state"
Date: Wed, 31 Jul 2013 16:36:43 +0100
Message-ID: <51F92F0B.7030504@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following commit included in 3.10, and copied to some table-series
kernels:

 commit: c2b93e0699723700f886ce17bb65ffd771195a6d
 cifs: only set ops for inodes in I_NEW state

=2E.. causes a regression in mfsymlink handling under some circumstance=
s.

Specifically, this patch modified cifs_fattr_to_inode() to only invoke
cifs_set_ops() if that inode still had the I_NEW flag set --- preventin=
g
an inode's ops-set from from being changed after it had been
initialized, preventing an oops if another thread of execution was
already chasing that pointer.

However, mfsymlinks are also affected by this commit.  In the cold-cach=
e
case, a user invoking stat() on an mfsymlink will still see the correct
results.  But, if the dentry cache is instead populated via
cifs_readdir/filldir, then inode property population operates in a two
stage mode:

 - First, the inode is initialized as a regular file, with the
   CIFS_FATTR_NEED_REVAL flag set.

 - Later, when the file is stat()'d, then correct operation depends on
   the (re)validation steps from being able to update the inode's
   properties --- including the set of file operations permitted.

(A comment explains:  "trying to get the type and mode can be slow, so
 just call those regular files for now, and mark for reval")

With the above commit, this second revalidation step never updates the
operations field, resulting in symlinks not having the readlink(), etc.
functions correctly hooked up.

A na=C3=AFve fix-up is to modify the conditional to also permit (re)set=
ting
ops on S_IFLNK-mode files; however, I suspect a correct fix lies elsewh=
ere?

Cheers,
David
--=20
David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Unix Specialist, University Computing Service

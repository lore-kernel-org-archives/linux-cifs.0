From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 0/3] cifs: tighten up cifs_iget matching criteria
Date: Mon, 28 Jun 2010 07:10:10 -0400
Message-ID: <1277723413-23769-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

These patches are intended to help reduce the number of false matches
that cifs_iget does. They simply try to make the code do some extra
checking of the cached inodes against the new file's attributes when a
uniqueid matches one that's already in cache.

I've tested these against samba and windows. They seem to work and help
reduce the false positives that can cause server inode numbers to be
disabled.

This patchset is intended for 2.6.36. The patches are in the cifs-2.6.36
branch of my kernel.org tree:

http://git.kernel.org/?p=linux/kernel/git/jlayton/linux.git;a=shortlog;h=refs/heads/cifs-2.6.36

Jeff Layton (3):
  cifs: don't allow cifs_iget to match inodes of the wrong type
  cifs: use CreationTime like an i_generation field
  cifs: reduce false positives with inode aliasing serverino
    autodisable

 fs/cifs/cifsfs.c   |    2 +
 fs/cifs/cifsglob.h |    2 +
 fs/cifs/inode.c    |   54 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/cifs/readdir.c  |    1 +
 4 files changed, 47 insertions(+), 12 deletions(-)


From: Benjamin Coddington <bcodding@redhat.com>
Subject: [PATCH 0/3] Minor cleanup for locks API
Date: Thu, 22 Oct 2015 11:35:53 -0400
Message-ID: <cover.1445524157.git.bcodding@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Latchesar Ionkov <lucho@ionkov.net>, linux-fsdevel@vger.kernel.org,
 Trond Myklebust <trond.myklebust@primarydata.com>, devel@driverdev.osuosl.org,
 Yan Zheng <zyan@redhat.com>, cluster-devel@redhat.com,
 Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Christoph Hellwig <hch@infradead.org>, fuse-devel@lists.sourceforge.net,
 Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 linux-cifs@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
 Mark Fasheh <mfasheh@suse.com>, Oleg Drokin <oleg.drokin@intel.com>,
 Julia Lawall <Julia.Lawall@lip6.fr>, David Teigland <teigland@redhat.com>,
 Joel Becker <jlbec@evilplan.org>, ceph-devel@vger.kernel.org,
 Abdul Hussain <habdul@visteon.com>, Steven Whitehouse <swhiteho@redhat.com>,
 linux-nfs@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
 Greg K
To: Jeff Layton <jlayton@poochiereds.net>,
 "J. Bruce Fields" <bfields@fieldses.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-cifs.vger.kernel.org

NFS has recently been moving things around to cope with the situation where
a struct file may not be available during an unlock.  That work has
presented an opportunity to do a minor cleanup on the locks API.

Users of posix_lock_file_wait() (for FL_POSIX style locks) and
flock_lock_file_wait() (for FL_FLOCK style locks) can instead call
locks_lock_file_wait() for both lock types.  Because the passed-in file_lock
specifies its own type, the correct function can be selected on behalf of
the user.

This work allows further cleanup within NFS and lockd which will be
submitted separately.

Benjamin Coddington (3):
  locks: introduce locks_lock_inode_wait()
  Move locks API users to locks_lock_inode_wait()
  locks: cleanup posix_lock_inode_wait and flock_lock_inode_wait

 drivers/staging/lustre/lustre/llite/file.c |    8 +-----
 fs/9p/vfs_file.c                           |    4 +-
 fs/ceph/locks.c                            |    4 +-
 fs/cifs/file.c                             |    2 +-
 fs/dlm/plock.c                             |    4 +-
 fs/fuse/file.c                             |    2 +-
 fs/gfs2/file.c                             |    8 +++---
 fs/lockd/clntproc.c                        |   13 +----------
 fs/locks.c                                 |   31 +++++++++++++++++++++++----
 fs/nfs/file.c                              |   13 +----------
 fs/nfs/nfs4proc.c                          |   13 +----------
 fs/ocfs2/locks.c                           |    8 +++---
 include/linux/fs.h                         |   21 +++---------------
 13 files changed, 51 insertions(+), 80 deletions(-)

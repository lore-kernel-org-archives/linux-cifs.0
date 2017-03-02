From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 00/10] various fs subsystems refcounter conversions
Date: Thu,  2 Mar 2017 12:43:07 +0200
Message-ID: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com, sfrench@samba.org,
        eparis@parisplace.org, konishi.ryusuke@lab.ntt.co.jp,
        john@johnmccutchan.com, rlove@rlove.org, paul@paul-moore.com,
        Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Now when new refcount_t type and API are finally merged
(see include/linux/refcount.h), the following
patches convert various refcounters in different fs susystems from atomic_t
to refcount_t. By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

The below patches are fully independent and can be cherry-picked separately.
Since we convert all kernel subsystems in the same fashion, resulting
in about 300 patches, we have to group them for sending at least in some
fashion to be manageable. Please excuse the long cc list.

Elena Reshetova (10):
  fs, kernfs: convert kernfs_node.count from atomic_t to refcount_t
  fs, cachefiles: convert cachefiles_object.usage from atomic_t to
    refcount_t
  fs, proc: convert proc_dir_entry.count from atomic_t to refcount_t
  fs, nilfs: convert nilfs_root.count from atomic_t to refcount_t
  fs, hfs: convert hfs_bnode.refcnt from atomic_t to refcount_t
  fs, fscache: convert fscache_cache_tag.usage from atomic_t to
    refcount_t
  fs, fscache: convert fscache_operation.usage from atomic_t to
    refcount_t
  fs, fsnotify: convert fsnotify_group.refcnt from atomic_t to
    refcount_t
  fs, fsnotify: convert fsnotify_mark.refcnt from atomic_t to refcount_t
  fs, cifs: convert tcon_link.tl_count from atomic_t to refcount_t

 fs/cachefiles/bind.c             |  2 +-
 fs/cachefiles/interface.c        | 18 +++++++++---------
 fs/cachefiles/internal.h         |  3 ++-
 fs/cachefiles/namei.c            |  2 +-
 fs/cachefiles/rdwr.c             |  2 +-
 fs/cifs/cifsglob.h               |  5 +++--
 fs/cifs/connect.c                |  8 ++++----
 fs/fscache/cache.c               |  8 ++++----
 fs/fscache/operation.c           | 38 +++++++++++++++++++-------------------
 fs/fscache/page.c                |  2 +-
 fs/hfs/bnode.c                   | 14 +++++++-------
 fs/hfs/btree.c                   |  4 ++--
 fs/hfs/btree.h                   |  3 ++-
 fs/hfs/inode.c                   |  4 ++--
 fs/hfsplus/bnode.c               | 14 +++++++-------
 fs/hfsplus/btree.c               |  4 ++--
 fs/hfsplus/hfsplus_fs.h          |  3 ++-
 fs/hfsplus/inode.c               |  4 ++--
 fs/kernfs/dir.c                  | 12 +++++-------
 fs/nilfs2/the_nilfs.c            |  8 ++++----
 fs/nilfs2/the_nilfs.h            |  5 +++--
 fs/notify/group.c                |  6 +++---
 fs/notify/inotify/inotify_user.c |  4 ++--
 fs/notify/mark.c                 |  6 +++---
 fs/proc/generic.c                |  4 ++--
 fs/proc/internal.h               |  5 +++--
 fs/proc/root.c                   |  2 +-
 include/linux/fscache-cache.h    |  7 ++++---
 include/linux/fsnotify_backend.h |  5 +++--
 include/linux/kernfs.h           |  3 ++-
 kernel/audit_tree.c              |  2 +-
 31 files changed, 107 insertions(+), 100 deletions(-)

-- 
2.7.4

From: Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: [PATCH 0/9] vfs: move btrfs clone ioctls to common code
Date: Sun, 25 Oct 2015 07:17:07 +0800
Message-ID: <1445728636-10109-1-git-send-email-tao.peng@primarydata.com>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>,
	Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Hi all,

This patchset moves BTRFS_IOC_CLONE/BTRFS_IOC_CLONE_RANGE to common vfs
layer and adds NFS42 CLONE support to knfsd.

It is based on top of Trond's linux-next branch (a85240d254) and Anna's latest
sys_copy_file_range work (v7).

With this, btrfs/cifs/nfs all handle CLONE/CLONE_RANGE ioctls through the
.copy_file_range method instead of each implementing them in the private
ioctl handlers.

Cheers,
Tao

Anna Schumaker (2):
  nfsd: Pass filehandle to nfs4_preprocess_stateid_op()
  NFSD: Implement the CLONE call

Peng Tao (7):
  vfs: add COPY_FILE_CLONE_ONLY flag
  cifs: add .copy_file_range file operation
  nfs42: add .copy_file_range file operation
  vfs: pull btrfs clone API to vfs layer
  btrfs: remove btrfs_ioctl_clone(_range)
  cifs: remove private handler of BTRFS_IOC_CLONE
  nfs42: remove private clone ioctl handler

 fs/btrfs/ioctl.c        |  49 ------------------
 fs/cifs/cifsfs.c        |  22 ++++++++
 fs/cifs/cifsfs.h        |   4 +-
 fs/cifs/ioctl.c         | 103 ++++++++++++++++++++-----------------
 fs/ioctl.c              |  40 +++++++++++++++
 fs/nfs/nfs4file.c       | 133 +++++++++---------------------------------------
 fs/nfsd/nfs4proc.c      |  96 +++++++++++++++++++++++++++++++---
 fs/nfsd/nfs4state.c     |   6 +--
 fs/nfsd/nfs4xdr.c       |  21 ++++++++
 fs/nfsd/state.h         |   5 +-
 fs/nfsd/vfs.c           |  12 +++++
 fs/nfsd/vfs.h           |   1 +
 fs/nfsd/xdr4.h          |  10 ++++
 fs/read_write.c         |   9 ++--
 include/linux/fs.h      |   3 ++
 include/linux/nfs4.h    |   4 +-
 include/uapi/linux/fs.h |   9 ++++
 17 files changed, 303 insertions(+), 224 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Li Wang <liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
Subject: [PATCH 0/7] Cifs and Ceph: Uncache single no-data page in readpage()
Date: Mon, 11 Nov 2013 23:27:22 +0800
Message-ID: <cover.1384183054.git.liwang@ubuntukylin.com>
Cc: ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>,
	Li Wang <liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, the page allocated into fscache in readpage() 
for Cifs and Ceph does not be uncached if no data read due
to io error. This patch fixes this. fscache_readpages_cancel() 
is for this kind of job but taking list read * as input, so
a new routine take page * as input is introduced. 

Li Wang (7):
  Fscache: Introduce new API fscache_readpage_cancel()
  Fscache: Implement uncaching single no-data page
  Ceph: Introduce routine for uncaching single no-data page
  Ceph: Uncaching no-data page in readpage()
  Cifs: Introduce routine for uncaching single no-data page
  Cifs: Implement uncaching single no-data page
  Cifs: Uncaching no-data page in readpage()

 fs/ceph/addr.c          |    1 +
 fs/ceph/cache.h         |   13 +++++++++++++
 fs/cifs/file.c          |    4 +++-
 fs/cifs/fscache.c       |    7 +++++++
 fs/cifs/fscache.h       |   13 +++++++++++++
 fs/fscache/page.c       |    8 ++++++++
 include/linux/fscache.h |   11 +++++++++++
 7 files changed, 56 insertions(+), 1 deletion(-)

-- 
1.7.9.5

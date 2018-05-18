From: Long Li <longli@linuxonhyperv.com>
Subject: [RFC PATCH 01/09] Introduce offset for the 1st page in data transfer structures
Date: Thu, 17 May 2018 17:22:06 -0700
Message-ID: <20180518002214.5657-2-longli@linuxonhyperv.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Currently CIFS allocates its own pages for data transfer, they don't need offset
since it's always 0 in the 1st page.

Direct data transfer needs to define an offset because user-data may not start
on the page boundary

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index cb950a5..a51855c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -176,6 +176,7 @@ struct smb_rqst {
 	struct kvec	*rq_iov;	/* array of kvecs */
 	unsigned int	rq_nvec;	/* number of kvecs in array */
 	struct page	**rq_pages;	/* pointer to array of page ptrs */
+	unsigned int	rq_offset;	/* the offset to the 1st page */
 	unsigned int	rq_npages;	/* number pages in array */
 	unsigned int	rq_pagesz;	/* page size to use */
 	unsigned int	rq_tailsz;	/* length of last page */
@@ -1167,8 +1168,10 @@ struct cifs_readdata {
 	struct kvec			iov[2];
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	struct smbd_mr			*mr;
+	struct page			**direct_pages;
 #endif
 	unsigned int			pagesz;
+	unsigned int			page_offset;
 	unsigned int			tailsz;
 	unsigned int			credits;
 	unsigned int			nr_pages;
@@ -1192,8 +1195,10 @@ struct cifs_writedata {
 	int				result;
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	struct smbd_mr			*mr;
+	struct page			**direct_pages;
 #endif
 	unsigned int			pagesz;
+	unsigned int			page_offset;
 	unsigned int			tailsz;
 	unsigned int			credits;
 	unsigned int			nr_pages;
-- 
2.7.4

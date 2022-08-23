Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06487C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 15:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbiHWPFd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 11:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242759AbiHWPEe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 11:04:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9E231F1F1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 05:29:19 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MBnvM5cVhzkWK1;
        Tue, 23 Aug 2022 20:03:59 +0800 (CST)
Received: from fedora.huawei.com (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 20:07:28 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>
Subject: [PATCH -next 2/2] cifs: remove the release parameter form async_writev
Date:   Tue, 23 Aug 2022 21:06:37 +0800
Message-ID: <20220823130637.1164764-3-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220823130637.1164764-1-zhangxiaoxu5@huawei.com>
References: <20220823130637.1164764-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Release function can get directly from writedata, so remove this
parameter from async_writev function.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/cifsglob.h  | 3 +--
 fs/cifs/cifsproto.h | 3 +--
 fs/cifs/cifssmb.c   | 5 ++---
 fs/cifs/file.c      | 9 ++++-----
 fs/cifs/smb2pdu.c   | 5 ++---
 fs/cifs/smb2proto.h | 3 +--
 6 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 19223df189d0..187b32158da8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -394,8 +394,7 @@ struct smb_version_operations {
 	/* async read from the server */
 	int (*async_readv)(struct cifs_readdata *);
 	/* async write to the server */
-	int (*async_writev)(struct cifs_writedata *,
-			    void (*release)(struct kref *));
+	int (*async_writev)(struct cifs_writedata *);
 	/* sync read from the server */
 	int (*sync_read)(const unsigned int, struct cifs_fid *,
 			 struct cifs_io_parms *, unsigned int *, char **,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 10890c0c0910..f71b8141126b 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -573,8 +573,7 @@ void cifs_readdata_release(struct kref *refcount);
 int cifs_async_readv(struct cifs_readdata *rdata);
 int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
 
-int cifs_async_writev(struct cifs_writedata *wdata,
-		      void (*release)(struct kref *kref));
+int cifs_async_writev(struct cifs_writedata *wdata);
 void cifs_writev_complete(struct work_struct *work);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
 					    work_func_t complete,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 7aa91e272027..f562cb0f648a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1690,8 +1690,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 /* cifs_async_writev - send an async write, and set up mid to handle result */
 int
-cifs_async_writev(struct cifs_writedata *wdata,
-		  void (*release)(struct kref *kref))
+cifs_async_writev(struct cifs_writedata *wdata)
 {
 	int rc = -EACCES;
 	WRITE_REQ *smb = NULL;
@@ -1768,7 +1767,7 @@ cifs_async_writev(struct cifs_writedata *wdata,
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	else
-		kref_put(&wdata->refcount, release);
+		kref_put(&wdata->refcount, wdata->release);
 
 async_writev_out:
 	cifs_small_buf_release(smb);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 56d1b28fb476..69fb59d86721 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2357,7 +2357,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 				rc = -EBADF;
 		} else {
 			wdata2->pid = wdata2->cfile->pid;
-			rc = server->ops->async_writev(wdata2, wdata2->release);
+			rc = server->ops->async_writev(wdata2);
 		}
 
 		for (j = 0; j < nr_pages; j++) {
@@ -2635,7 +2635,7 @@ wdata_send_pages(struct cifs_writedata *wdata, unsigned int nr_pages,
 	if (wdata->cfile->invalidHandle)
 		rc = -EAGAIN;
 	else
-		rc = wdata->server->ops->async_writev(wdata, wdata->release);
+		rc = wdata->server->ops->async_writev(wdata);
 
 	return rc;
 }
@@ -3206,8 +3206,7 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 					wdata->mr = NULL;
 				}
 #endif
-				rc = server->ops->async_writev(wdata,
-							       wdata->release);
+				rc = server->ops->async_writev(wdata);
 			}
 		}
 
@@ -3368,7 +3367,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 			if (wdata->cfile->invalidHandle)
 				rc = -EAGAIN;
 			else
-				rc = server->ops->async_writev(wdata, wdata->release);
+				rc = server->ops->async_writev(wdata);
 		}
 
 		if (rc) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9b31ea946d45..c89f9253884e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4447,8 +4447,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 
 /* smb2_async_writev - send an async write, and set up mid to handle result */
 int
-smb2_async_writev(struct cifs_writedata *wdata,
-		  void (*release)(struct kref *kref))
+smb2_async_writev(struct cifs_writedata *wdata)
 {
 	int rc = -EACCES, flags = 0;
 	struct smb2_write_req *req = NULL;
@@ -4575,7 +4574,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 				     req->PersistentFileId,
 				     tcon->tid, tcon->ses->Suid, wdata->offset,
 				     wdata->bytes, rc);
-		kref_put(&wdata->refcount, release);
+		kref_put(&wdata->refcount, wdata->release);
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 	}
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 08f243757b9b..a478267c58ac 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -190,8 +190,7 @@ extern int SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
 extern int smb2_async_readv(struct cifs_readdata *rdata);
 extern int SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 		     unsigned int *nbytes, char **buf, int *buf_type);
-extern int smb2_async_writev(struct cifs_writedata *wdata,
-			     void (*release)(struct kref *kref));
+extern int smb2_async_writev(struct cifs_writedata *wdata);
 extern int SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec);
 extern int SMB2_echo(struct TCP_Server_Info *server);
-- 
2.31.1


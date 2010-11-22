From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH] cifs: remove unused CIFSSMBNotify
Date: Mon, 22 Nov 2010 15:31:02 -0500
Message-ID: <1290457863-10804-2-git-send-email-jlayton@redhat.com>
References: <1290457863-10804-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290457863-10804-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and the global variables that only it references.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    4 ---
 fs/cifs/cifsglob.h  |    5 ---
 fs/cifs/cifsproto.h |    4 ---
 fs/cifs/cifssmb.c   |   73 ---------------------------------------------------
 4 files changed, 0 insertions(+), 86 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0ab2e2f..041d7c3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -911,10 +911,6 @@ init_cifs(void)
 	int rc = 0;
 	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-	INIT_LIST_HEAD(&GlobalDnotifyReqList);
-	INIT_LIST_HEAD(&GlobalDnotifyRsp_Q);
-#endif
 /*
  *  Initialize Global counters
  */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bba731c..b4c2524 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -735,11 +735,6 @@ GLOBAL_EXTERN spinlock_t		cifs_tcp_ses_lock;
  */
 GLOBAL_EXTERN spinlock_t	cifs_file_list_lock;
 
-/* Outstanding dir notify requests */
-GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
-/* DirNotify response queue */
-GLOBAL_EXTERN struct list_head GlobalDnotifyRsp_Q;
-
 /*
  * Global transaction id (XID) information
  */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6ed59af..7b0ca3a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -383,10 +383,6 @@ extern int CIFSSMBCopy(int xid,
 			const char *toName, const int flags,
 			const struct nls_table *nls_codepage,
 			int remap_special_chars);
-extern int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
-			const int notify_subdirs, const __u16 netfid,
-			__u32 filter, struct file *file, int multishot,
-			const struct nls_table *nls_codepage);
 extern ssize_t CIFSSMBQAllEAs(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName,
 			const unsigned char *ea_name, char *EAData,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2f2632b..0ef7c3a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5381,79 +5381,6 @@ setPermsRetry:
 	return rc;
 }
 
-int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
-		  const int notify_subdirs, const __u16 netfid,
-		  __u32 filter, struct file *pfile, int multishot,
-		  const struct nls_table *nls_codepage)
-{
-	int rc = 0;
-	struct smb_com_transaction_change_notify_req *pSMB = NULL;
-	struct smb_com_ntransaction_change_notify_rsp *pSMBr = NULL;
-	struct dir_notify_req *dnotify_req;
-	int bytes_returned;
-
-	cFYI(1, "In CIFSSMBNotify for file handle %d", (int)netfid);
-	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
-		      (void **) &pSMBr);
-	if (rc)
-		return rc;
-
-	pSMB->TotalParameterCount = 0 ;
-	pSMB->TotalDataCount = 0;
-	pSMB->MaxParameterCount = cpu_to_le32(2);
-	/* BB find exact data count max from sess structure BB */
-	pSMB->MaxDataCount = 0; /* same in little endian or be */
-/* BB VERIFY verify which is correct for above BB */
-	pSMB->MaxDataCount = cpu_to_le32((tcon->ses->server->maxBuf -
-					     MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
-
-	pSMB->MaxSetupCount = 4;
-	pSMB->Reserved = 0;
-	pSMB->ParameterOffset = 0;
-	pSMB->DataCount = 0;
-	pSMB->DataOffset = 0;
-	pSMB->SetupCount = 4; /* single byte does not need le conversion */
-	pSMB->SubCommand = cpu_to_le16(NT_TRANSACT_NOTIFY_CHANGE);
-	pSMB->ParameterCount = pSMB->TotalParameterCount;
-	if (notify_subdirs)
-		pSMB->WatchTree = 1; /* one byte - no le conversion needed */
-	pSMB->Reserved2 = 0;
-	pSMB->CompletionFilter = cpu_to_le32(filter);
-	pSMB->Fid = netfid; /* file handle always le */
-	pSMB->ByteCount = 0;
-
-	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-			 (struct smb_hdr *)pSMBr, &bytes_returned,
-			 CIFS_ASYNC_OP);
-	if (rc) {
-		cFYI(1, "Error in Notify = %d", rc);
-	} else {
-		/* Add file to outstanding requests */
-		/* BB change to kmem cache alloc */
-		dnotify_req = kmalloc(
-						sizeof(struct dir_notify_req),
-						 GFP_KERNEL);
-		if (dnotify_req) {
-			dnotify_req->Pid = pSMB->hdr.Pid;
-			dnotify_req->PidHigh = pSMB->hdr.PidHigh;
-			dnotify_req->Mid = pSMB->hdr.Mid;
-			dnotify_req->Tid = pSMB->hdr.Tid;
-			dnotify_req->Uid = pSMB->hdr.Uid;
-			dnotify_req->netfid = netfid;
-			dnotify_req->pfile = pfile;
-			dnotify_req->filter = filter;
-			dnotify_req->multishot = multishot;
-			spin_lock(&GlobalMid_Lock);
-			list_add_tail(&dnotify_req->lhead,
-					&GlobalDnotifyReqList);
-			spin_unlock(&GlobalMid_Lock);
-		} else
-			rc = -ENOMEM;
-	}
-	cifs_buf_release(pSMB);
-	return rc;
-}
-
 #ifdef CONFIG_CIFS_XATTR
 /*
  * Do a path-based QUERY_ALL_EAS call and parse the result. This is a common
-- 
1.7.3.2

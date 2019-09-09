Return-Path: <SRS0=r/yF=XE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC62CC00307
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 05:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4AC2218AC
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 05:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfIIFaJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Sep 2019 01:30:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbfIIFaJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 9 Sep 2019 01:30:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 023328E2B66;
        Mon,  9 Sep 2019 05:30:08 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53F944F85;
        Mon,  9 Sep 2019 05:30:07 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: add a helper to find an existing readable handle to a file
Date:   Mon,  9 Sep 2019 15:30:00 +1000
Message-Id: <20190909053000.982-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Mon, 09 Sep 2019 05:30:08 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and convert smb2_query_path_info() to use it.
This will eliminate the need for a SMB2_Create when we already have an
open handle that can be used. This will also prevent a oplock break
in case the other handle holds a lease.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsproto.h |  2 ++
 fs/cifs/file.c      | 36 ++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2inode.c | 28 +++++++++++++++++++++++-----
 3 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7b69037bed24..99b1b1ef558c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -140,6 +140,8 @@ extern int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
 				  struct cifsFileInfo **ret_file);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
+extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
+				  struct cifsFileInfo **ret_file);
 extern unsigned int smbCalcSize(void *buf, struct TCP_Server_Info *server);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6124b1d1ab05..4b95700c507c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2008,6 +2008,42 @@ cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
 	return -ENOENT;
 }
 
+int
+cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
+		       struct cifsFileInfo **ret_file)
+{
+	struct list_head *tmp;
+	struct cifsFileInfo *cfile;
+	struct cifsInodeInfo *cinode;
+	char *full_path;
+
+	*ret_file = NULL;
+
+	spin_lock(&tcon->open_file_lock);
+	list_for_each(tmp, &tcon->openFileList) {
+		cfile = list_entry(tmp, struct cifsFileInfo,
+			     tlist);
+		full_path = build_path_from_dentry(cfile->dentry);
+		if (full_path == NULL) {
+			spin_unlock(&tcon->open_file_lock);
+			return -ENOMEM;
+		}
+		if (strcmp(full_path, name)) {
+			kfree(full_path);
+			continue;
+		}
+
+		kfree(full_path);
+		cinode = CIFS_I(d_inode(cfile->dentry));
+		spin_unlock(&tcon->open_file_lock);
+		*ret_file = find_readable_file(cinode, 0);
+		return *ret_file ? 0 : -ENOENT;
+	}
+
+	spin_unlock(&tcon->open_file_lock);
+	return -ENOENT;
+}
+
 static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 {
 	struct address_space *mapping = page->mapping;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 9bb0a5bc38c9..c866555b6278 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -125,15 +125,31 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		rqst[num_rqst].rq_iov = qi_iov;
 		rqst[num_rqst].rq_nvec = 1;
 
-		rc = SMB2_query_info_init(tcon, &rqst[num_rqst], COMPOUND_FID,
-				COMPOUND_FID, FILE_ALL_INFORMATION,
+		if (cfile)
+			rc = SMB2_query_info_init(tcon, &rqst[num_rqst],
+				cfile->fid.persistent_fid,
+				cfile->fid.volatile_fid,
+				FILE_ALL_INFORMATION,
 				SMB2_O_INFO_FILE, 0,
 				sizeof(struct smb2_file_all_info) +
 					  PATH_MAX * 2, 0, NULL);
+		else {
+			rc = SMB2_query_info_init(tcon, &rqst[num_rqst],
+				COMPOUND_FID,
+				COMPOUND_FID,
+				 FILE_ALL_INFORMATION,
+				SMB2_O_INFO_FILE, 0,
+				sizeof(struct smb2_file_all_info) +
+					  PATH_MAX * 2, 0, NULL);
+			if (!rc) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			}
+		}
+
 		if (rc)
 			goto finished;
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
+		num_rqst++;
 		trace_smb3_query_info_compound_enter(xid, ses->Suid, tcon->tid,
 						     full_path);
 		break;
@@ -421,6 +437,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	__u32 create_options = 0;
 	struct cifs_fid fid;
 	bool no_cached_open = tcon->nohandlecache;
+	struct cifsFileInfo *cfile;
 
 	*adjust_tz = false;
 	*symlink = false;
@@ -452,9 +469,10 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
+	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN, create_options,
-			      smb2_data, SMB2_OP_QUERY_INFO, NULL);
+			      smb2_data, SMB2_OP_QUERY_INFO, cfile);
 	if (rc == -EOPNOTSUPP) {
 		*symlink = true;
 		create_options |= OPEN_REPARSE_POINT;
-- 
2.13.6


Return-Path: <SRS0=BNow=DM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6325FC4363D
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 02:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B8E2072D
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 02:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCiZpDOC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJECiN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Oct 2020 22:38:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbgJECiN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Oct 2020 22:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601865492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=LSeRlQfK32FKryUo3y0Clt3/kQxkCj0X061YOS5hAXU=;
        b=KCiZpDOCEBrW1lsXpWD6O/TDTIah04QWO22jZWpFATVRMsSE8BSU+2Dr+UKWoJjdj3FDSD
        AIMDsPDZWHhgZv8/A0XrK92eQ8AG5Z3KVDeJIBSjQoSk4lhK7KkYWtJYcegeiOwzhLVT27
        RfssSwnKnk0D7L1/uxTgP94ZFZySMzI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-38BSLKTQOtOdAzhtWmL8ZA-1; Sun, 04 Oct 2020 22:38:10 -0400
X-MC-Unique: 38BSLKTQOtOdAzhtWmL8ZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99970801ADE;
        Mon,  5 Oct 2020 02:38:09 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-124.bne.redhat.com [10.64.54.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1E3E5C225;
        Mon,  5 Oct 2020 02:38:08 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/3] cifs: compute full_path already in cifs_readdir()
Date:   Mon,  5 Oct 2020 12:37:53 +1000
Message-Id: <20201005023754.13604-3-lsahlber@redhat.com>
In-Reply-To: <20201005023754.13604-1-lsahlber@redhat.com>
References: <20201005023754.13604-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/readdir.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 6df0922e7e30..31a18aae5e64 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -360,11 +360,11 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
  */
 
 static int
-initiate_cifs_search(const unsigned int xid, struct file *file)
+initiate_cifs_search(const unsigned int xid, struct file *file,
+		     char *full_path)
 {
 	__u16 search_flags;
 	int rc = 0;
-	char *full_path = NULL;
 	struct cifsFileInfo *cifsFile;
 	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
 	struct tcon_link *tlink = NULL;
@@ -400,12 +400,6 @@ initiate_cifs_search(const unsigned int xid, struct file *file)
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
 
-	full_path = build_path_from_dentry(file_dentry(file));
-	if (full_path == NULL) {
-		rc = -ENOMEM;
-		goto error_exit;
-	}
-
 	cifs_dbg(FYI, "Full path: %s start at: %lld\n", full_path, file->f_pos);
 
 ffirst_retry:
@@ -444,7 +438,6 @@ initiate_cifs_search(const unsigned int xid, struct file *file)
 		goto ffirst_retry;
 	}
 error_exit:
-	kfree(full_path);
 	cifs_put_tlink(tlink);
 	return rc;
 }
@@ -688,7 +681,8 @@ static int cifs_save_resume_key(const char *current_entry,
  */
 static int
 find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
-		struct file *file, char **current_entry, int *num_to_ret)
+		struct file *file, char *full_path,
+		char **current_entry, int *num_to_ret)
 {
 	__u16 search_flags;
 	int rc = 0;
@@ -741,7 +735,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 						ntwrk_buf_start);
 			cfile->srch_inf.ntwrk_buf_start = NULL;
 		}
-		rc = initiate_cifs_search(xid, file);
+		rc = initiate_cifs_search(xid, file, full_path);
 		if (rc) {
 			cifs_dbg(FYI, "error %d reinitiating a search on rewind\n",
 				 rc);
@@ -925,15 +919,22 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	char *tmp_buf = NULL;
 	char *end_of_smb;
 	unsigned int max_len;
+	char *full_path = NULL;
 
 	xid = get_xid();
 
+	full_path = build_path_from_dentry(file_dentry(file));
+	if (full_path == NULL) {
+		rc = -ENOMEM;
+		goto rddir2_exit;
+	}
+
 	/*
 	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
 	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
 	 */
 	if (file->private_data == NULL) {
-		rc = initiate_cifs_search(xid, file);
+		rc = initiate_cifs_search(xid, file, full_path);
 		cifs_dbg(FYI, "initiate cifs search rc %d\n", rc);
 		if (rc)
 			goto rddir2_exit;
@@ -960,8 +961,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	} */
 
 	tcon = tlink_tcon(cifsFile->tlink);
-	rc = find_cifs_entry(xid, tcon, ctx->pos, file, &current_entry,
-			     &num_to_fill);
+	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
+			     &current_entry, &num_to_fill);
 	if (rc) {
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
@@ -1019,6 +1020,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	kfree(tmp_buf);
 
 rddir2_exit:
+	kfree(full_path);
 	free_xid(xid);
 	return rc;
 }
-- 
2.13.6


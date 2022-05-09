Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C4BC4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  9 May 2022 23:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbiEIXs1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 May 2022 19:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiEIXrn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 May 2022 19:47:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDEF624D582
        for <linux-cifs@vger.kernel.org>; Mon,  9 May 2022 16:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652139745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xkymvY8JbCicQiNHW1ZV/vC9xg9m0aPvHGoAwurZi8=;
        b=MzlnFvtGC+zbutn3PoAaSOyJGjZBmtvsu33AVtEspkXUravG44zVavFqSvjOJKUP61zwBI
        XTr2h27sTUQ7SwmpNKBhv6MyL3euuj11rle0vm0MRFxNAHZtriPp0nGyAhP69L1tAfhkxR
        z3h1GAxLvLlm+Gu8QvR73ef9tKNiS1g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-OJ2z0YofPMu5XECwYx-Fxw-1; Mon, 09 May 2022 19:42:21 -0400
X-MC-Unique: OJ2z0YofPMu5XECwYx-Fxw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 228C7185A7A4;
        Mon,  9 May 2022 23:42:21 +0000 (UTC)
Received: from thinkpad (vpn2-54-168.bne.redhat.com [10.64.54.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 003A07C58;
        Mon,  9 May 2022 23:42:19 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 3/4] cifs: set the CREATE_NOT_FILE when opening the directory in use_cached_dir()
Date:   Tue, 10 May 2022 09:42:06 +1000
Message-Id: <20220509234207.2469586-4-lsahlber@redhat.com>
In-Reply-To: <20220509234207.2469586-1-lsahlber@redhat.com>
References: <20220509234207.2469586-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This enforces that we can only do this for directories and not normal files
or else the server will return an error.
This means that we will have conditionally check IF the path refers
to a directory or not in all the call-sites where we are unsure.
Right now this check is for "" i.e. root.

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 5 ++++-
 fs/cifs/smb2ops.c   | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index fe5bfa245fa7..0c3e4d2c6207 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -514,8 +514,11 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb2_data == NULL)
 		return -ENOMEM;
 
+	if (strcmp(full_path, ""))
+		rc = -ENOENT;
+	else
+		rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	/* If it is a root and its handle is cached then use it */
-	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	if (!rc) {
 		if (tcon->crfid.file_all_info_is_valid) {
 			move_smb2_info_to_cifs(data,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2c93ee27d54d..cbe56ed35694 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -825,7 +825,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms.tcon = tcon;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
 	oparms.disposition = FILE_OPEN;
 	oparms.fid = pfid;
@@ -2696,7 +2696,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
-	rc = open_cached_dir(xid, tcon, path, cifs_sb, &cfid);
+	if (!strcmp(path, ""))
+		rc = open_cached_dir(xid, tcon, path, cifs_sb, &cfid);
 
 	memset(&open_iov, 0, sizeof(open_iov));
 	rqst[0].rq_iov = open_iov;
-- 
2.30.2


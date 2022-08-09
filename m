Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E13C00140
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 02:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiHICM2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 22:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHICM1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 22:12:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FD5918B09
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 19:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660011145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HYnrwpqBmn4hfmQygj3FP9ktl9kU7vtyHT5wppxLS+s=;
        b=T1SzV5cerNrVRBMf2igAuVqrK+4hQNEwWha9PwAze/vq7RLr90ZEFrZs4XohZLUNPlS/z0
        r7Ln+lGXgBmSYPACt05XEXaWBGxHkdeFdVJ0MC63FnTlHxi0v7N2tn8FFjOkL/x5Cj7GsH
        shqKVosyKqEYt+8f8Z/lzjRGiccUbpM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-MCm9FHnIOr6VI0yjvE_Hjg-1; Mon, 08 Aug 2022 22:12:21 -0400
X-MC-Unique: MCm9FHnIOr6VI0yjvE_Hjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25A7F802D2C;
        Tue,  9 Aug 2022 02:12:21 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63936140EBE3;
        Tue,  9 Aug 2022 02:12:19 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/9] cifs: Do not use tcon->cfid directly, use the cfid we get from open_cached_dir
Date:   Tue,  9 Aug 2022 12:11:49 +1000
Message-Id: <20220809021156.3086869-3-lsahlber@redhat.com>
In-Reply-To: <20220809021156.3086869-1-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

They are the same right now but tcon-> will later point to a different
type of struct containing a list of cfids.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 4 ++--
 fs/cifs/smb2pdu.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index f6f9fc3f2e2d..09f01f70e020 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -519,9 +519,9 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	/* If it is a root and its handle is cached then use it */
 	if (!rc) {
-		if (tcon->cfid.file_all_info_is_valid) {
+		if (cfid->file_all_info_is_valid) {
 			move_smb2_info_to_cifs(data,
-					       &tcon->cfid.file_all_info);
+					       &cfid->file_all_info);
 		} else {
 			rc = SMB2_query_info(xid, tcon,
 					     cfid->fid->persistent_fid,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9ee1b6225619..5dbd2cac470c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1979,7 +1979,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 	spin_unlock(&ses->chan_lock);
 
-	close_cached_dir_lease(&tcon->cfid);
+	invalidate_all_cached_dirs(tcon);
 
 	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, ses->server,
 				 (void **) &req,
-- 
2.35.3


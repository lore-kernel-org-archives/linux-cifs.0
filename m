Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F02C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 12:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35EE02075D
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 12:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfCZMjf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:39:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:51144 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726175AbfCZMjf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Mar 2019 08:39:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 736C0AB87;
        Tue, 26 Mar 2019 12:39:34 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     linux@dominikbrodowski.net, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v1] CIFS: prevent refcount underflow
Date:   Tue, 26 Mar 2019 13:39:21 +0100
Message-Id: <20190326123921.4116-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190326071819.GA10639@light.dominikbrodowski.net>
References: <20190326071819.GA10639@light.dominikbrodowski.net>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Replace kref_t by a simple refcount. We do not care about the
atomicity of the operation as long as the mutex is held.

This fixes a false-positive memory leak warning from kref_put() where
we close the cached fid twice and make the kref underflow.

Link: https://lore.kernel.org/linux-cifs/20190319115151.GA2092@light.dominikbrodowski.net/

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsglob.h |  2 +-
 fs/cifs/smb2ops.c  | 34 ++++++++++++++--------------------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 38feae812b47..256cd48fb4c7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -972,7 +972,7 @@ struct cached_fid {
 	bool is_valid:1;	/* Do we have a useable root fid */
 	bool file_all_info_is_valid:1;
 
-	struct kref refcount;
+	refcount_t refcount;
 	struct cifs_fid *fid;
 	struct mutex fid_mutex;
 	struct cifs_tcon *tcon;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1022a3771e14..062c081a298c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -608,25 +608,21 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
 	return rc;
 }
 
-static void
-smb2_close_cached_fid(struct kref *ref)
-{
-	struct cached_fid *cfid = container_of(ref, struct cached_fid,
-					       refcount);
-
-	if (cfid->is_valid) {
-		cifs_dbg(FYI, "clear cached root file handle\n");
-		SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
-			   cfid->fid->volatile_fid);
-		cfid->is_valid = false;
-		cfid->file_all_info_is_valid = false;
-	}
-}
-
 void close_shroot(struct cached_fid *cfid)
 {
+	unsigned int n;
 	mutex_lock(&cfid->fid_mutex);
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	n = refcount_read(&cfid->refcount);
+	if (n > 0) {
+		refcount_dec(&cfid->refcount);
+		if (n == 1 && cfid->is_valid) {
+			cifs_dbg(FYI, "clear cached root file handle\n");
+			SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
+				   cfid->fid->volatile_fid);
+			cfid->is_valid = false;
+			cfid->file_all_info_is_valid = false;
+		}
+	}
 	mutex_unlock(&cfid->fid_mutex);
 }
 
@@ -662,7 +658,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 	if (tcon->crfid.is_valid) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
 		memcpy(pfid, tcon->crfid.fid, sizeof(struct cifs_fid));
-		kref_get(&tcon->crfid.refcount);
+		refcount_inc(&tcon->crfid.refcount);
 		mutex_unlock(&tcon->crfid.fid_mutex);
 		return 0;
 	}
@@ -728,9 +724,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 	memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
 	tcon->crfid.tcon = tcon;
 	tcon->crfid.is_valid = true;
-	kref_init(&tcon->crfid.refcount);
-	kref_get(&tcon->crfid.refcount);
-
+	refcount_set(&tcon->crfid.refcount, 1);
 
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
-- 
2.16.4


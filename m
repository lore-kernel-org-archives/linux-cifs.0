Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD35C0650E
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 20:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86ACA20838
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 20:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGFULm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Jul 2019 16:11:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:43308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726743AbfGFULl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 6 Jul 2019 16:11:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BFA12AFBE;
        Sat,  6 Jul 2019 20:11:40 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v2 4.20.y stable] CIFS: fix deadlock in cached root handling
Date:   Sat,  6 Jul 2019 22:11:31 +0200
Message-Id: <20190706201131.1941-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <CAKywueS6VDje+BAVOfdUuACdayoFz1-Q-fqtEOWP9jVp_SvvTA@mail.gmail.com>
References: <CAKywueS6VDje+BAVOfdUuACdayoFz1-Q-fqtEOWP9jVp_SvvTA@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Prevent deadlock between open_shroot() and
cifs_mark_open_files_invalid() by releasing the lock before entering
SMB2_open, taking it again after and checking if we still need to use
the result.

Link: https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com/T/#u
Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---

Changes since v1:
* added SMB2_close() of extra root handle
* copied valid handle to caller's pfid
* added reference get() of the handle

Please review carefuly, I haven't tested this.

 fs/cifs/smb2ops.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index aa71e620f3cd..53e14fd74abc 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -609,7 +609,49 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 	oparams.fid = pfid;
 	oparams.reconnect = false;
 
+	/*
+	 * We do not hold the lock for the open because in case
+	 * SMB2_open needs to reconnect, it will end up calling
+	 * cifs_mark_open_files_invalid() which takes the lock again
+	 * thus causing a deadlock
+	 */
+	mutex_unlock(&tcon->crfid.fid_mutex);
 	rc = SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, NULL);
+	mutex_lock(&tcon->crfid.fid_mutex);
+
+	/*
+	 * Now we need to check again as the cached root might have
+	 * been successfully re-opened from a concurrent process
+	 */
+
+	if (tcon->crfid.is_valid) {
+		/* work was already done */
+
+		/* stash fids for close() later */
+		struct cifs_fid fid = {
+			.persistent_fid = pfid->persistent_fid,
+			.volatile_fid = pfid->volatile_fid,
+		};
+
+		/*
+		 * caller expects this func to set pfid to a valid
+		 * cached root, so we copy the existing one and get a
+		 * reference.
+		 */
+		memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
+		kref_get(&tcon->crfid.refcount);
+
+		mutex_unlock(&tcon->crfid.fid_mutex);
+
+		if (rc == 0) {
+			/* close extra handle outside of crit sec */
+			SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+		}
+		return 0;
+	}
+
+	/* Cached root is still invalid, continue normaly */
+
 	if (rc == 0) {
 		memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
 		tcon->crfid.tcon = tcon;
@@ -617,6 +659,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 		kref_init(&tcon->crfid.refcount);
 		kref_get(&tcon->crfid.refcount);
 	}
+
 	mutex_unlock(&tcon->crfid.fid_mutex);
 	return rc;
 }
-- 
2.16.4


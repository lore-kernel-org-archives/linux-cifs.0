Return-Path: <SRS0=fkjb=YJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D550FC4360C
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 06:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBB242168B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 06:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbfJPGzV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Oct 2019 02:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18457 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfJPGzV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 16 Oct 2019 02:55:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B25ED10C092B
        for <linux-cifs@vger.kernel.org>; Wed, 16 Oct 2019 06:55:20 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-116.bne.redhat.com [10.64.54.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 177CA60852;
        Wed, 16 Oct 2019 06:55:19 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: use the cached root handle for readdir() if possible
Date:   Wed, 16 Oct 2019 16:55:10 +1000
Message-Id: <20191016065510.31291-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Wed, 16 Oct 2019 06:55:20 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4c0922596467..7aab18552dd8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -681,7 +681,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 
 	oparms.tcon = tcon;
 	oparms.create_options = 0;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
+	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
 	oparms.disposition = FILE_OPEN;
 	oparms.fid = pfid;
 	oparms.reconnect = false;
@@ -1999,6 +1999,14 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
+	bool no_cached_open = tcon->nohandlecache;
+
+	if (!strlen(path) && !no_cached_open) {
+		rc = open_shroot(xid, tcon, fid);
+		if (rc)
+			return rc;
+		goto after_open;
+	}
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path)
@@ -2021,6 +2029,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+ after_open:
 	srch_inf->entries_in_buffer = 0;
 	srch_inf->index_of_last_entry = 2;
 
@@ -2046,6 +2055,13 @@ static int
 smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 	       struct cifs_fid *fid)
 {
+	if (tcon->crfid.is_valid &&
+	    tcon->crfid.fid->persistent_fid == fid->persistent_fid &&
+	    tcon->crfid.fid->volatile_fid == fid->volatile_fid) {
+		close_shroot(&tcon->crfid);
+		return 0;
+	}
+
 	return SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 }
 
-- 
2.13.6


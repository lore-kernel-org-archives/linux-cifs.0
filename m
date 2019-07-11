Return-Path: <SRS0=SUdu=VI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA0EC74A45
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Jul 2019 03:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D42C20872
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Jul 2019 03:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfGKDrH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Jul 2019 23:47:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfGKDrH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Jul 2019 23:47:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 43E5C308A963;
        Thu, 11 Jul 2019 03:47:07 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-113.bne.redhat.com [10.64.54.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A6C61001B10;
        Thu, 11 Jul 2019 03:47:06 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix crash in cifs_dfs_do_automount
Date:   Thu, 11 Jul 2019 13:46:58 +1000
Message-Id: <20190711034658.21485-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 11 Jul 2019 03:47:07 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1649907

Fix a crash that happens while attempting to mount a DFS referral from the same server on the root of a filesystem.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8ad8bbe8003b..9b0f9f346c5b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4484,11 +4484,13 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
 					unsigned int xid,
 					struct cifs_tcon *tcon,
 					struct cifs_sb_info *cifs_sb,
-					char *full_path)
+					char *full_path,
+					int added_treename)
 {
 	int rc;
 	char *s;
 	char sep, tmp;
+	int skip = added_treename ? 1 : 0;
 
 	sep = CIFS_DIR_SEP(cifs_sb);
 	s = full_path;
@@ -4503,7 +4505,13 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
 		/* next separator */
 		while (*s && *s != sep)
 			s++;
-
+		/* if the treename is added, we then have to skip the first
+		 * part within the separators
+		 */
+		if (skip) {
+			skip = 0;
+			continue;
+		}
 		/*
 		 * temporarily null-terminate the path at the end of
 		 * the current component
@@ -4551,8 +4559,7 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 
 	if (rc != -EREMOTE) {
 		rc = cifs_are_all_path_components_accessible(server, xid, tcon,
-							     cifs_sb,
-							     full_path);
+			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
 			cifs_dbg(VFS, "cannot query dirs between root and final path, "
 				 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-- 
2.13.6


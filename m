Return-Path: <SRS0=LZk2=34=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909EDC35250
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Feb 2020 14:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7168620726
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Feb 2020 14:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBHOvI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Feb 2020 09:51:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:39576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgBHOvH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 8 Feb 2020 09:51:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26B9BAC2C;
        Sat,  8 Feb 2020 14:51:06 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 1/3] cifs: rename posix create rsp
Date:   Sat,  8 Feb 2020 15:50:56 +0100
Message-Id: <20200208145058.10429-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

little progress on the posix create response.

* rename struct to create_posix_rsp to match with the request
  create_posix context
* make struct packed
* pass smb info struct for parse_posix_ctxt to fill
* use smb info struct as param
* update TODO

What needs to be done:

SMB2_open() has an optional smb info out argument that it will fill.
Callers making use of this are:

- smb3_query_mf_symlink (need to investigate)
- smb2_open_file

Callers of smb2_open_file (via server->ops->open) are passing an
smbinfo struct but that struct cannot hold POSIX information. All the
call stack needs to be changed for a different info type. Maybe pass
SMB generic struct like cifs_fattr instead.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/smb2pdu.c | 13 +++++++++----
 fs/cifs/smb2pdu.h |  9 ++++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1234f9ccab03..7d4d7cdb2eb4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1940,13 +1940,18 @@ parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
 }
 
 static void
-parse_posix_ctxt(struct create_context *cc, struct smb_posix_info *pposix_inf)
+parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info)
 {
-	/* struct smb_posix_info *ppinf = (struct smb_posix_info *)cc; */
+	/* struct create_posix_rsp *posix = (struct create_posix_rsp *)cc; */
 
-	/* TODO: Need to add parsing for the context and return */
+	/*
+	 * TODO: Need to add parsing for the context and return. Can
+	 * smb2_file_all_info hold POSIX data? Need to change the
+	 * passed type from SMB2_open.
+	 */
 	printk_once(KERN_WARNING
 		    "SMB3 3.11 POSIX response context not completed yet\n");
+
 }
 
 void
@@ -1984,7 +1989,7 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
 			parse_query_id_ctxt(cc, buf);
 		else if ((le16_to_cpu(cc->NameLength) == 16)) {
 			if (memcmp(name, smb3_create_tag_posix, 16) == 0)
-				parse_posix_ctxt(cc, NULL);
+				parse_posix_ctxt(cc, buf);
 		}
 		/* else {
 			cifs_dbg(FYI, "Context not matched with len %d\n",
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index fa03df130f1a..c84405ed603c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1604,11 +1604,14 @@ struct smb2_file_id_information {
 extern char smb2_padding[7];
 
 /* equivalent of the contents of SMB3.1.1 POSIX open context response */
-struct smb_posix_info {
+struct create_posix_rsp {
 	__le32 nlink;
 	__le32 reparse_tag;
 	__le32 mode;
-	kuid_t	uid;
-	kuid_t	gid;
+	/*
+	  var sized owner SID
+	  var sized group SID
+	*/
+} __packed;
 };
 #endif				/* _SMB2PDU_H */
-- 
2.16.4


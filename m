Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6F8C76196
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCONFy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjCONFv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E220574E2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=cEfFtEnIZYJNmeBLa8ldPbNYOnS64MqRE09FsR6rbwA=; b=pQXGYHcKrORM9DtDJfGnz08gtV
        v7kmql46iaUdcz0WAEk5E+YsZFn5Qsrn1b4ywWaicURgo08iYx7rj7C05scclcpOc9obT/zufBalM
        7NDDqbtfjffYffHmgLAeKDWV+6tsdRjHDmKVyickfcSGgYYXMX0P7ejNYnKAfnhkn+huVGounJVWv
        pk71n/d7yY4s+zsizG0f4Mk+Scrt56Or5RQOP3Mps2XbjYeprr0Cox4hTVbu/N7f6OsYYMSpEjfWP
        0HMIXpwr7U41jDIYcHc4wbV+dKikOSHaakWG1Ul7MvpgcOy2VJI5snjqYMQZ9/DyFcdEiMDtAoGHI
        V7i2/5IVN5my5UKAcwTODAfjwC09+52qMnUCF09NoQiDyNV0GqiC5oiIKCRRZVIibrkXzUzEbSJ4C
        3NGpyM5uv1ul5Yvcb8lZFCpGHfsEbU9eDozOAdkK1/ymTFLxRDeePMa6j76MufMVMjpbg7tgxMBMh
        jWv+jh4nXiCpM6JZheh6hhnp;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp7-003KNd-1c; Wed, 15 Mar 2023 13:05:45 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 06/10] cifs: Slightly refactor smb2_compound_op()
Date:   Wed, 15 Mar 2023 13:05:27 +0000
Message-Id: <e80d68c8840895d4817c22bdafa4e4eec3119b52.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Simplify if-conditions a bit. The reason for this will become obvious
in the next patch.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2inode.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index aa848779bc22..1aafa79503ce 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -150,14 +150,14 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				SMB2_O_INFO_FILE, 0,
 				sizeof(struct smb2_file_all_info) +
 					  PATH_MAX * 2, 0, NULL);
-			if (!rc) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			}
 		}
 
 		if (rc)
 			goto finished;
+		if (!cfile) {
+			smb2_set_next_command(tcon, &rqst[num_rqst]);
+			smb2_set_related(&rqst[num_rqst]);
+		}
 		num_rqst++;
 		trace_smb3_query_info_compound_enter(xid, ses->Suid, tcon->tid,
 						     full_path);
@@ -185,14 +185,14 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				SMB2_O_INFO_FILE, 0,
 				sizeof(struct smb311_posix_qinfo *) + (PATH_MAX * 2) +
 				(sizeof(struct cifs_sid) * 2), 0, NULL);
-			if (!rc) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			}
 		}
 
 		if (rc)
 			goto finished;
+		if (!cfile) {
+			smb2_set_next_command(tcon, &rqst[num_rqst]);
+			smb2_set_related(&rqst[num_rqst]);
+		}
 		num_rqst++;
 		trace_smb3_posix_query_info_compound_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
@@ -234,13 +234,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 						FILE_END_OF_FILE_INFORMATION,
 						SMB2_O_INFO_FILE, 0,
 						data, size);
-			if (!rc) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			}
 		}
 		if (rc)
 			goto finished;
+		if (!cfile) {
+			smb2_set_next_command(tcon, &rqst[num_rqst]);
+			smb2_set_related(&rqst[num_rqst]);
+		}
 		num_rqst++;
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
@@ -266,14 +266,14 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				COMPOUND_FID, current->tgid,
 				FILE_BASIC_INFORMATION,
 				SMB2_O_INFO_FILE, 0, data, size);
-			if (!rc) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			}
 		}
 
 		if (rc)
 			goto finished;
+		if (!cfile) {
+			smb2_set_next_command(tcon, &rqst[num_rqst]);
+			smb2_set_related(&rqst[num_rqst]);
+		}
 		num_rqst++;
 		trace_smb3_set_info_compound_enter(xid, ses->Suid, tcon->tid,
 						   full_path);
@@ -307,13 +307,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					COMPOUND_FID, COMPOUND_FID,
 					current->tgid, FILE_RENAME_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
-			if (!rc) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			}
 		}
 		if (rc)
 			goto finished;
+		if (!cfile) {
+			smb2_set_next_command(tcon, &rqst[num_rqst]);
+			smb2_set_related(&rqst[num_rqst]);
+		}
 		num_rqst++;
 		trace_smb3_rename_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
-- 
2.30.2


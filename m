Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42944C7618B
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjCONFx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjCONFu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C37F574C5
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=SfouBEuyesxYwEZCCVsPRpPThrluuTkgd+OtrqRBYws=; b=ou3KhAR4fX7VqQPW86+VlGiG4m
        XPop2DiHPyjV9RlpMipjTAzOogAG/GPjKzkHcrh1MjyAYIxw8ptknmAWXEuXiZymOVu3jw1mDs96Y
        tHb/7jp5cJXeb5gFz0QB8GrzhuJfkMwULFiZ9jdoKA5tpST5TEYlk9PPdLVks+gLV4X36M+7NuHB6
        vDnUxlZGgdTcPNgoWqL6Ex04dC97n1SwWspx4Ll04MleKOCLeDcpl8D3It5LC+by81mS02LcEGn7T
        PKs/uVJCaXGqbL/kEUmKOtmmR+VYkGvL4aeBP7rSKBug0NrBmLY+m2jH4F4lzT51BIwvv2f3UrS1n
        //av4DMGJMHn6o0kCU/45BRCU7M2CoFsr+jHsUoMGQ5grXW27E3d9kS+JmnRHyOrbD+XwpXTTGNCw
        FQXsKgEdziPp8DYuz3xttF53HO0hS62rycWaYqO1ubP/qnNBhZSgiNOsgX+t1c85iOiInwioalcY2
        Ag3vJdbYyd6mekOwVF8r5tS5;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp6-003KNd-Sw; Wed, 15 Mar 2023 13:05:44 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 05/10] cifs: Simplify SMB2_OP_RMDIR with CREATE_DELETE_ON_CLOSE
Date:   Wed, 15 Mar 2023 13:05:26 +0000
Message-Id: <c83668c7ec7da2b9ee21c2196b539f1f1bdfd969.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Match SMB2_OP_DELETE, we don't need the intermediate
SMB2_set_info(FILE_DISPOSITION_INFORMATION)

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2inode.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index eb288836b06b..aa848779bc22 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -76,7 +76,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct cifs_open_info_data *idata;
 	int flags = 0;
-	__u8 delete_pending[8] = {1, 0, 0, 0, 0, 0, 0, 0};
 	unsigned int size[2];
 	void *data[2];
 	int len;
@@ -208,21 +207,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_mkdir_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_RMDIR:
-		rqst[num_rqst].rq_iov = &vars->si_iov[0];
-		rqst[num_rqst].rq_nvec = 1;
-
-		size[0] = 1; /* sizeof __u8 See MS-FSCC section 2.4.11 */
-		data[0] = &delete_pending[0];
-
-		rc = SMB2_set_info_init(tcon, server,
-					&rqst[num_rqst], COMPOUND_FID,
-					COMPOUND_FID, current->tgid,
-					FILE_DISPOSITION_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
-		if (rc)
-			goto finished;
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_rmdir_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_EOF:
@@ -738,7 +722,8 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 {
 	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
-				CREATE_NOT_FILE, ACL_NO_MODE,
+				CREATE_NOT_FILE|CREATE_DELETE_ON_CLOSE,
+				ACL_NO_MODE,
 				NULL, SMB2_OP_RMDIR, NULL, NULL, NULL, NULL, NULL);
 }
 
-- 
2.30.2


Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFFCC433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C4661A55
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354234AbhJAM1E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354364AbhJAM1C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A29C06177C
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=BBoHhSN5DUV/pw1fVGReAjPvezm7csgon7Kx/33ma/c=; b=0/eeiiiKzEihDk3lT1nd7lXd+q
        pq8P3YR7IKmAajt24/211jU1RCTv/f0mQYFiuFF4wQc9r2PrrJcOYk7jgNWFTdVTPJ4lqLFAkJqcT
        qvxuXfJ95mvItdblVWuRBKfClr98+AV33gd1TwSs1U24ZcGEg/NNbx/cHmXm2ndNdZJ5gGQU8mQ3N
        L8A/st3oxCFj2179L87wldUrnHFIhE1CyiIdupltuW/L0k6Qgz9Y1iptcAl4Jc5CBQfraKqSJcDTw
        Xa9qqxSR+jPfn3vpxWzsjANqSSLnB+vzfOAhZFGCQzPuqdvqVxnqmpZlnHJFEROjxcx9SpWk3m2VW
        YERpT0mBelep4kmmTo5ZNE0IDMgElqEVyn7MK9BBYtxgfefOmSwHn1660DOWQ0+Ejp6TlRVuNJon1
        KcoCjgVVZGKmiM/L65I/GNL0FLfkl66XSQy0V/MiBu1EC7379lY3NzBMeEeeBtA4ftNmz6xpOyrjL
        K1CdhkKsevQENeQrY61RX7pA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIM-0013Z3-5E; Fri, 01 Oct 2021 12:05:42 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>
Subject: [PATCH v5 03/20] ksmbd: use correct basic info level in set_file_basic_info()
Date:   Fri,  1 Oct 2021 14:04:04 +0200
Message-Id: <20211001120421.327245-4-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

Use correct basic info level in set/get_file_basic_info().

Reviewed-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 13 ++++++-------
 fs/ksmbd/smb2pdu.h |  9 +++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 9c0878862820..d874813aca90 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4161,7 +4161,7 @@ static void get_file_access_info(struct smb2_query_info_rsp *rsp,
 static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 			       struct ksmbd_file *fp, void *rsp_org)
 {
-	struct smb2_file_all_info *basic_info;
+	struct smb2_file_basic_info *basic_info;
 	struct kstat stat;
 	u64 time;
 
@@ -4171,7 +4171,7 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 		return -EACCES;
 	}
 
-	basic_info = (struct smb2_file_all_info *)rsp->Buffer;
+	basic_info = (struct smb2_file_basic_info *)rsp->Buffer;
 	generic_fillattr(file_mnt_user_ns(fp->filp), file_inode(fp->filp),
 			 &stat);
 	basic_info->CreationTime = cpu_to_le64(fp->create_time);
@@ -4184,9 +4184,8 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	basic_info->Attributes = fp->f_ci->m_fattr;
 	basic_info->Pad1 = 0;
 	rsp->OutputBufferLength =
-		cpu_to_le32(offsetof(struct smb2_file_all_info, AllocationSize));
-	inc_rfc1001_len(rsp_org, offsetof(struct smb2_file_all_info,
-					  AllocationSize));
+		cpu_to_le32(sizeof(struct smb2_file_basic_info));
+	inc_rfc1001_len(rsp_org, sizeof(struct smb2_file_basic_info));
 	return 0;
 }
 
@@ -5412,7 +5411,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 			       struct ksmbd_share_config *share)
 {
-	struct smb2_file_all_info *file_info;
+	struct smb2_file_basic_info *file_info;
 	struct iattr attrs;
 	struct timespec64 ctime;
 	struct file *filp;
@@ -5423,7 +5422,7 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
 		return -EACCES;
 
-	file_info = (struct smb2_file_all_info *)buf;
+	file_info = (struct smb2_file_basic_info *)buf;
 	attrs.ia_valid = 0;
 	filp = fp->filp;
 	inode = file_inode(filp);
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index bcec845b03f3..261825d06391 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -1464,6 +1464,15 @@ struct smb2_file_all_info { /* data block encoding of response to level 18 */
 	char   FileName[1];
 } __packed; /* level 18 Query */
 
+struct smb2_file_basic_info { /* data block encoding of response to level 18 */
+	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le32 Attributes;
+	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
+} __packed;
+
 struct smb2_file_alt_name_info {
 	__le32 FileNameLength;
 	char FileName[0];
-- 
2.31.1


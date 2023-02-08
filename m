Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2FBC05027
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Feb 2023 09:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBHJfS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Feb 2023 04:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBHJfM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Feb 2023 04:35:12 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34CDCC03
        for <linux-cifs@vger.kernel.org>; Wed,  8 Feb 2023 01:34:55 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id f15-20020a17090ac28f00b00230a32f0c9eso1695416pjt.4
        for <linux-cifs@vger.kernel.org>; Wed, 08 Feb 2023 01:34:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HC3WCFUJd4S3NLa2Q55HDMRScmD5Ala/7igqQ+ocFU4=;
        b=4k4vcKAilNDOF+f8EugjFNTPIut6b8MMxuZN9xB2RFFqoFRJkCP5+zwnvoyXoXIzWn
         T6L4PndsVfOd23lceZFHMjendBgYDPEwSBo7quxzPiWWPM/kuGJ58avwl56bSW+rLfgv
         WJKyxuOY9uHV7mOC1a+FqVJ3KURiWW5TPyXwVl23dD53DUMLslNduh97zAq+7igDNmmw
         NqqngjTfweP+Eq56ltmMEZzLyQZE2r87i9HVFjh7p8zbhSbhKAk2coBG45jV8RUaKfGr
         qE70ef+fUxasKuUKCeHyl4XMRQKVys35VDaECKS1OuDwcgfL3T95RoMV4rB8QgKWmh+f
         LE5Q==
X-Gm-Message-State: AO0yUKU/aN/tShFcmBX+DegFhNunoV75kKlx4Abi7F4y+y+n3m3oKW3j
        X7PPH9PUrstlCATiCIOnMhGAmQnyyGY=
X-Google-Smtp-Source: AK7set8XawToZCfYysV5A9Va8pqN3Fna9DBcN2MjUjeCSAIO3/ibqevnLu6F3n0blSkqyAEdl/Amzw==
X-Received: by 2002:a05:6a20:3943:b0:a2:c3b0:f637 with SMTP id r3-20020a056a20394300b000a2c3b0f637mr8157681pzg.26.1675848894908;
        Wed, 08 Feb 2023 01:34:54 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id w6-20020a63a746000000b004fad428d4aasm5521730pgo.78.2023.02.08.01.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 01:34:54 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] cifs: remove unneeded 2bytes of padding from smb2 tree connect
Date:   Wed,  8 Feb 2023 18:34:37 +0900
Message-Id: <20230208093437.10415-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Due to the 2bytes of padding from the smb2 tree connect request,
there is an unneeded difference between the rfc1002 length and the actual
frame length. In the case of windows client, it is sent by matching it
exactly.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/cifs/smb2pdu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2c9ffa921e6f..04cd001c76c2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1858,12 +1858,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if (unc_path == NULL)
 		return -ENOMEM;
 
-	unc_path_len = cifs_strtoUTF16(unc_path, tree, strlen(tree), cp) + 1;
-	unc_path_len *= 2;
-	if (unc_path_len < 2) {
+	unc_path_len = cifs_strtoUTF16(unc_path, tree, strlen(tree), cp);
+	if (unc_path_len <= 0) {
 		kfree(unc_path);
 		return -EINVAL;
 	}
+	unc_path_len *= 2;
 
 	/* SMB2 TREE_CONNECT request must be called with TreeId == 0 */
 	tcon->tid = 0;
@@ -1885,7 +1885,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	/* Testing shows that buffer offset must be at location of Buffer[0] */
 	req->PathOffset = cpu_to_le16(sizeof(struct smb2_tree_connect_req)
 			- 1 /* pad */);
-	req->PathLength = cpu_to_le16(unc_path_len - 2);
+	req->PathLength = cpu_to_le16(unc_path_len);
 	iov[1].iov_base = unc_path;
 	iov[1].iov_len = unc_path_len;
 
-- 
2.25.1


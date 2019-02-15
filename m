Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327ABC10F06
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A8E21927
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550198223;
	bh=OV/rdYHQmSlP/1aWBJ/SzhvP3Wu6ISfOiCoS98We1ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RBqtZ/tC1fMxiz8fznVHtgIjP1YBxAFqmOZz/k2jzllHHsTq9NHZD7p969hoPG+RR
	 yNSUmE1/Bleet5ck7yr7wsECr1xj1xbG1rfRQZoafdkS3OY7EZke2KQJT1Yax0TAHj
	 wGkC6+gQi+vL8YaNlPk/QyG3QiXYeY4AVe+AKrRU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390677AbfBOCKi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390663AbfBOCKi (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Feb 2019 21:10:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E206C222A1;
        Fri, 15 Feb 2019 02:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196637;
        bh=OV/rdYHQmSlP/1aWBJ/SzhvP3Wu6ISfOiCoS98We1ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhRroohjxB198FBOP3h/vR35FLzlmNqVhlBSei0920UJksMH0bBzXlN9PNnrgvpuK
         bmvOj/mpKGQRYfts8oU6/GgrZe+18AIlmT2eR2nGtquKe9lbFfgHKkGy0yRhqvuGYr
         FgS3L2UuOUmmHnM3sQOM76I2+MXeWs/quXHNehtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 62/77] cifs: fix memory leak of an allocated cifs_ntsd structure
Date:   Thu, 14 Feb 2019 21:08:40 -0500
Message-Id: <20190215020855.176727-62-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215020855.176727-1-sashal@kernel.org>
References: <20190215020855.176727-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 73aaf920cc72024c4a4460cfa46d56e5014172f3 ]

The call to SMB2_queary_acl can allocate memory to pntsd and also
return a failure via a call to SMB2_query_acl (and then query_info).
This occurs when query_info allocates the structure and then in
query_info the call to smb2_validate_and_copy_iov fails. Currently the
failure just returns without kfree'ing pntsd hence causing a memory
leak.

Currently, *data is allocated if it's not already pointing to a buffer,
so it needs to be kfree'd only if was allocated in query_info, so the
fix adds an allocated flag to track this.  Also set *dlen to zero on
an error just to be safe since *data is kfree'd.

Also set errno to -ENOMEM if the allocation of *data fails.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Dan Carpener <dan.carpenter@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c393ac255af7..d1ae7cdb236d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2714,6 +2714,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype = CIFS_NO_BUFFER;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
+	bool allocated = false;
 
 	cifs_dbg(FYI, "Query Info\n");
 
@@ -2753,14 +2754,21 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 					"Error %d allocating memory for acl\n",
 					rc);
 				*dlen = 0;
+				rc = -ENOMEM;
 				goto qinf_exit;
 			}
+			allocated = true;
 		}
 	}
 
 	rc = smb2_validate_and_copy_iov(le16_to_cpu(rsp->OutputBufferOffset),
 					le32_to_cpu(rsp->OutputBufferLength),
 					&rsp_iov, min_len, *data);
+	if (rc && allocated) {
+		kfree(*data);
+		*data = NULL;
+		*dlen = 0;
+	}
 
 qinf_exit:
 	SMB2_query_info_free(&rqst);
-- 
2.19.1


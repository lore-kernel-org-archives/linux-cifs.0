Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD4DC4320A
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jul 2021 03:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F13EC60F3A
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jul 2021 03:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhGWDR0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 23:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233837AbhGWDRJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE28260F02;
        Fri, 23 Jul 2021 03:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012663;
        bh=sLeRchgHxS9aI+LfQZzViXxZ6d3N3CoUQimmi9/VdbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POFWSNgs6NeYQTX052EJDBftFjAEXTIY/7nby/1vCrBpb7dC+yGcMclWmqxQwL+kh
         FICCuXrPCbgLogejzsUTcU2IQkyVFDn/cbiaJrReUjaQrV5bBDMC945PXE5GGJWVIa
         c8xAEQv4QrBnpLaPvRDyXfCykJLOpB2hxO7C+rTD2WAxq6L0nueRHOOmdELIL1Mxgf
         iHGQxggb/tnSvk8kfwVYLGxs9WrRghgstp1+OD6VMBiCTSyzKajezv+8cqtOqQQaPn
         pKyK6MRbPziSS2BY5pjxYYSUR804iHksH4InT7mBt0app3EMzK0558OASOZOHr3BOf
         keXiNGed0L3cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.13 16/19] cifs: fix the out of range assignment to bit fields in parse_server_interfaces
Date:   Thu, 22 Jul 2021 23:57:17 -0400
Message-Id: <20210723035721.531372-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035721.531372-1-sashal@kernel.org>
References: <20210723035721.531372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit c9c9c6815f9004ee1ec87401ed0796853bd70f1b ]

Because the out of range assignment to bit fields
are compiler-dependant, the fields could have wrong
value.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 903de7449aa3..1e5b707833aa 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -555,8 +555,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 	while (bytes_left >= sizeof(*p)) {
 		info->speed = le64_to_cpu(p->LinkSpeed);
-		info->rdma_capable = le32_to_cpu(p->Capability & RDMA_CAPABLE);
-		info->rss_capable = le32_to_cpu(p->Capability & RSS_CAPABLE);
+		info->rdma_capable = le32_to_cpu(p->Capability & RDMA_CAPABLE) ? 1 : 0;
+		info->rss_capable = le32_to_cpu(p->Capability & RSS_CAPABLE) ? 1 : 0;
 
 		cifs_dbg(FYI, "%s: adding iface %zu\n", __func__, *iface_count);
 		cifs_dbg(FYI, "%s: speed %zu bps\n", __func__, info->speed);
-- 
2.30.2


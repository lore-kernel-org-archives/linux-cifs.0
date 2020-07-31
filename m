Return-Path: <SRS0=14TU=BK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97E9C433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 31 Jul 2020 17:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10072245C
	for <linux-cifs@archiver.kernel.org>; Fri, 31 Jul 2020 17:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732693AbgGaRNx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 31 Jul 2020 13:13:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39314 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730924AbgGaRNx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 31 Jul 2020 13:13:53 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k1YbH-0006cL-66; Fri, 31 Jul 2020 17:13:43 +0000
From:   Colin King <colin.king@canonical.com>
To:     Steve French <sfrench@samba.org>, Aurelien Aptel <aaptel@suse.com>,
        Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] cifs: fix double free error on share and prefix
Date:   Fri, 31 Jul 2020 18:13:42 +0100
Message-Id: <20200731171342.36636-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently if the call dfs_cache_get_tgt_share fails we cannot
fully guarantee that share and prefix are set to NULL and the
next iteration of the loop can end up potentially double freeing
these pointers. Since the semantics of dfs_cache_get_tgt_share
are ambiguous for failure cases with the setting of share and
prefix (currently now and the possibly the future), it seems
prudent to set the pointers to NULL when the objects are
free'd to avoid any double frees.

Addresses-Coverity: ("Double free")
Fixes: 96296c946a2a ("cifs: handle RESP_GET_DFS_REFERRAL.PathConsumed in reconnect")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3c4dd4e1b9eb..4b2f5f5b3a8e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5574,6 +5574,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 		kfree(share);
 		kfree(prefix);
+		share = NULL;
+		prefix = NULL;
 
 		rc = dfs_cache_get_tgt_share(tcon->dfs_path + 1, it, &share, &prefix);
 		if (rc) {
-- 
2.27.0


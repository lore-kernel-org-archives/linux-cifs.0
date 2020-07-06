Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BCBC433DF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F42520720
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="UgHLb3s9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgGFPcD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:32:03 -0400
Received: from mx.cjr.nz ([51.158.111.142]:53952 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729316AbgGFPcC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jul 2020 11:32:02 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id B29DC807DA;
        Mon,  6 Jul 2020 15:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1594049130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iW9xnn99/V73gNVIYLzhHSmVHQECit90ZLe5SFmjiKk=;
        b=UgHLb3s94c53z0yL6XDYBwcUWz79Ef0cFmD8mQLinAg/txMdHmOKtJt3ygSG2HFBNa3NSF
        iQH2tlR/PuV8OU7u8iSmg5ZCzOPY7FuyXe5x0SaC0MPr77A8veKKJVsLKlNVpme3pJD0nm
        663140Ob5rlm2nAYiwb4mK4ZWqoa61zCBOBDR5sbJGRzo+iEA0rCcbMRKGgqXMlClVzS+P
        VRkE6UVN4wQ9QIarFP/kGsv8fYXb+kFEvislboyeUT0+jLw3ltKuHvPO6cyxYMzlq3W8ko
        CL8TT18PAmXxM/JOjeP3m8lFM19ujMI38HHmmkIgbA/+B4TWTG0Tfh2xxEHNJg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 6/7] cifs: only update prefix path of DFS links in cifs_tree_connect()
Date:   Mon,  6 Jul 2020 12:24:01 -0300
Message-Id: <20200706152402.5721-7-pc@cjr.nz>
In-Reply-To: <20200706152402.5721-1-pc@cjr.nz>
References: <20200706152402.5721-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

For DFS root mounts that contain a prefix path, do not change them
after failover.

E.g., if the user mounts

	//srvA/root/dir1

and then lost connection to srvA, it will reconnect to

	//srvB/root/dir1

In case of DFS links, which may resolve to different prefix paths
depending on their list of targets, the following must be supported:

	- mount //srvA/root/link/bar
	- connect to //srvA/share
	- set prefix path to "bar"
	- lost connection to srvA
	- reconnect to next target: //srvB/share/foo
	- set new prefix path to "foo/bar"

In cifs_tree_connect(), check the server_type field of the cached DFS
referral to determine whether or not prefix path should be updated.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2abef1c8feb3..af0c19495626 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5549,6 +5549,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	const char *dfs_host;
 	size_t dfs_host_len;
 	char *share = NULL, *prefix = NULL;
+	struct dfs_info3_param ref = {0};
+	bool isroot;
 
 	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
 	if (!tree)
@@ -5564,9 +5566,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		goto out;
 	}
 
-	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, NULL, &tl);
+	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl);
 	if (rc)
 		goto out;
+	isroot = ref.server_type == DFS_TYPE_ROOT;
+	free_dfs_info_param(&ref);
 
 	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
 
@@ -5608,7 +5612,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		} else {
 			scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
-			if (!rc) {
+			/* Only handle prefix paths of DFS link targets */
+			if (!rc && !isroot) {
 				rc = update_super_prepath(tcon, prefix);
 				break;
 			}
-- 
2.27.0


Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2ADC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 01:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8DF64F8C
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 01:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhCQBUT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Mar 2021 21:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231679AbhCQA5a (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A3D664FC7;
        Wed, 17 Mar 2021 00:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942649;
        bh=v4aQ1C+PHdEewD1wIyzJBQ9dILGTKmpEYaUkaBDltbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWtQYK8xMZttJa6+tsZvRgK+4JlQxCK7ZNKk1llp/dzPAmhfDgH0ZNT9WRe6/xzDR
         IT9BhFwhz3kc8OiNeT9ipy6lmK4lZKhi7Pm9ZKgc6liWnF1nxzE4X/8VveeOVWvSwo
         gt5i5L+xr4njE5837nuLnwasyATfjCVubbdkg9hF5wUL1Vh8dG+mtrZOnuUfAozjRL
         67Zdfse0pHU8/1OVc1FmPvXKVfpjqpm/VRkUCOKv52bLeEXldBDFqHmMQmjmVhCiFb
         uywSV7E+/a58MRaDtvhIxi//S90gygYMWmVWZl3snhl6JIDg3kEWt2qneg2M8zAl6R
         XnAmvH3FFlxmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 28/54] cifs: change noisy error message to FYI
Date:   Tue, 16 Mar 2021 20:56:27 -0400
Message-Id: <20210317005654.724862-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit e3d100eae44b42f309c1366efb8397368f1cf8ed ]

A customer has reported that their dmesg were being flooded by

  CIFS: VFS: \\server Cancelling wait for mid xxx cmd: a
  CIFS: VFS: \\server Cancelling wait for mid yyy cmd: b
  CIFS: VFS: \\server Cancelling wait for mid zzz cmd: c

because some processes that were performing statfs(2) on the share had
been interrupted due to their automount setup when certain users
logged in and out.

Change it to FYI as they should be mostly informative rather than
error messages.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 9391cd17a2b5..fc9278ca26c0 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1167,7 +1167,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 	if (rc != 0) {
 		for (; i < num_rqst; i++) {
-			cifs_server_dbg(VFS, "Cancelling wait for mid %llu cmd: %d\n",
+			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 			send_cancel(server, &rqst[i], midQ[i]);
 			spin_lock(&GlobalMid_Lock);
-- 
2.30.1


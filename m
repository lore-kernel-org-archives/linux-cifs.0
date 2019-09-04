Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99025C3A5A8
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 16:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 697142087E
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567613048;
	bh=/rmc9NLfm/pz4W0O5meL4AxVK3L8eJHMTEIcV7QNcSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=H7DbyNAkGq6GC3p2ktMxX9w4bcbzJepjYt9Eno6Wll8hcyW0G0FztM1qS9Zn4t3eZ
	 f+DLcLR6NR3d0EEs49til006Nui8Zqurev01B5h0R54ACn5ogycnM9fEQqphULezpO
	 dhZHlUrmQQvbEMD1Dakvq0hyzUmh7K3XGdZCPEyM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbfIDQD1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Sep 2019 12:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732982AbfIDQD0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 4 Sep 2019 12:03:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4AD62070C;
        Wed,  4 Sep 2019 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567613005;
        bh=/rmc9NLfm/pz4W0O5meL4AxVK3L8eJHMTEIcV7QNcSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsUsSnKOcVxiXacPdHYUr/YDlQv1XJpEJb8CwbhI97UWVAvpcfq8ay+PFKhG8RF1B
         TM65B+30+v1ByOkkXrJ+7fVhrFgwGENckhHB9C6nA+SO7GtEtCU/GEN67V3zZlpZyB
         2v2+pqYsNBWG6OBfaBcFzARMCJ3Fq5Q9Qk42Wae8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/20] cifs: Use kzfree() to zero out the password
Date:   Wed,  4 Sep 2019 12:02:57 -0400
Message-Id: <20190904160303.5062-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160303.5062-1-sashal@kernel.org>
References: <20190904160303.5062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 478228e57f81f6cb60798d54fc02a74ea7dd267e ]

It's safer to zero out the password so that it can never be disclosed.

Fixes: 0c219f5799c7 ("cifs: set domainName when a domain-key is used in multiuser")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 90e0c51ac0450..63108343124af 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2586,7 +2586,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 			rc = -ENOMEM;
 			kfree(vol->username);
 			vol->username = NULL;
-			kfree(vol->password);
+			kzfree(vol->password);
 			vol->password = NULL;
 			goto out_key_put;
 		}
-- 
2.20.1


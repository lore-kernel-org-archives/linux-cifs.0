Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB8EC43214
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Aug 2021 11:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D55866109F
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Aug 2021 11:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbhHCLox (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Aug 2021 07:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235946AbhHCLoO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1B360EE9;
        Tue,  3 Aug 2021 11:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991043;
        bh=q4kLnBUtg70BAak9qRJZeHe9ng5xHLv4QKUDSg6mxrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxOj/7iB2Oj8hiS/e/RsLfwfj7783S4P5f4yL7nlH6Gqc5C7tOzFJM4Yf/W116a4U
         qvKzlZhthEwK1KNK/osUXDQ22QLutGYJfPJh2MGrmvRvyJ1Lv0G92t0pn5ZynRTg4H
         +4uay/Hpa+WG7YaH2GM6xGipc8BYHP2I0nSqlQiOYKxaoklogeP3gwaQe8HaVUPxLy
         S87m7C4dCcG34NGSHrow9q+60RIsc0BZCRE4oCjO2MlGIFalp+WU4AcpaRyrOAY4zL
         NYMr5DZcDmOsujKiJqpyEaPTGGo2d4agIc9Kc5BZhYsTYmSjLqb3C9w0SHX7jNxzSS
         hNBUXIldapPXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Paulo Alcantara <pc@cjr.nz>, Sasha Levin <sashal@kernel.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.13 08/11] smb3: rc uninitialized in one fallocate path
Date:   Tue,  3 Aug 2021 07:43:49 -0400
Message-Id: <20210803114352.2252544-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114352.2252544-1-sashal@kernel.org>
References: <20210803114352.2252544-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 5ad4df56cd2158965f73416d41fce37906724822 ]

Clang detected a problem with rc possibly being unitialized
(when length is zero) in a recently added fallocate code path.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 398c941e3897..f77156187a0a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3613,7 +3613,8 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int rc, nbytes;
+	int nbytes;
+	int rc = 0;
 	struct kvec iov[2];
 
 	io_parms.netfid = cfile->fid.netfid;
-- 
2.30.2


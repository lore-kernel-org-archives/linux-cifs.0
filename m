Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D87C3A5AA
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 16:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 642FC20820
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567613240;
	bh=XoWVh8zkxqQBH7vyK96N6HQzgw676k1kvoxSzDKHeGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ffgrlLrma6jm8UxdaOW6NK2FGRODq+pu77JlhyM2oWEcEomRgCSnaLqO4EzCwckvG
	 vL2HLSXfiYu/bB20JWHPZezhbTcwq3EYgN6cEH7oRNucJ1/pYhucb7Y1js7fDegolh
	 vWZDrlRz8ZF543vP3seixN7KkzTdkHFsDd8NatWg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732528AbfIDQCB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Sep 2019 12:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733153AbfIDQCB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8984C2087E;
        Wed,  4 Sep 2019 16:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612920;
        bh=XoWVh8zkxqQBH7vyK96N6HQzgw676k1kvoxSzDKHeGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZ/vjFM0tRAi22icgSD7JlfwngxZQm8hHFXfrNjhPULzcvHeicldm/ne8p+a1tALQ
         b/mXc66CKXcPfi8ixKxkzKp0e0qf2glMsv6zW9siCE6Oj87hHiPNSJg4m7/+QYnY7b
         DMBE7xMcH5hJsn9L8I5U9IlLrWmbMR6NJ3WPal+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 24/36] cifs: Use kzfree() to zero out the password
Date:   Wed,  4 Sep 2019 12:01:10 -0400
Message-Id: <20190904160122.4179-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
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
index 699e763ea671a..f523a9ca9574f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2662,7 +2662,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
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


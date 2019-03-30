Return-Path: <SRS0=0xI7=SB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4E7C10F05
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 01:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 793502064A
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553908105;
	bh=6i0S6zJFG1Q40c58r4bonoIhc1v3eXHM4YsFxEsHxX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XjNqOG5JWn2AgkJgkS39Z3BIRezbcxl8dITwIBhFt6IcDtQ4Sh5egPV0vg3PBBW1Z
	 8NzVv8TIWSTgWR/deqdBhK0khb/D2hFKwZq5FazfrYziFINjtJTUWg6oeevmNHMc3x
	 bHSLPzAam5LxFNF+d7b/4xT1P5dPNSxgnsxvCqvk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbfC3BIT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 21:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731129AbfC3Aww (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 29 Mar 2019 20:52:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F50206DD;
        Sat, 30 Mar 2019 00:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553907171;
        bh=6i0S6zJFG1Q40c58r4bonoIhc1v3eXHM4YsFxEsHxX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtALCwdX2JiChKlM4vBPpj9FBJCb1OwdpAG3LhmaoClCafM1+dXDiMJHMJUytDotl
         qTLjvnMx+hkriTiBtJV67Vkqo/goNsUU1afv/SJiaAG4nVoVEfbywqY5ZqrJEFgmcN
         rAAjI6GJI4qzxrAhI2jiXJALbleHQmqobDfv9DSw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 64/67] fix incorrect error code mapping for OBJECTID_NOT_FOUND
Date:   Fri, 29 Mar 2019 20:50:44 -0400
Message-Id: <20190330005047.25998-64-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330005047.25998-1-sashal@kernel.org>
References: <20190330005047.25998-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 85f9987b236cf46e06ffdb5c225cf1f3c0acb789 ]

It was mapped to EIO which can be confusing when user space
queries for an object GUID for an object for which the server
file system doesn't support (or hasn't saved one).

As Amir Goldstein suggested this is similar to ENOATTR
(equivalently ENODATA in Linux errno definitions) so
changing NT STATUS code mapping for OBJECTID_NOT_FOUND
to ENODATA.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2maperror.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 924269cec135..e32c264e3adb 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -1036,7 +1036,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_UNFINISHED_CONTEXT_DELETED, -EIO,
 	"STATUS_UNFINISHED_CONTEXT_DELETED"},
 	{STATUS_NO_TGT_REPLY, -EIO, "STATUS_NO_TGT_REPLY"},
-	{STATUS_OBJECTID_NOT_FOUND, -EIO, "STATUS_OBJECTID_NOT_FOUND"},
+	/* Note that ENOATTTR and ENODATA are the same errno */
+	{STATUS_OBJECTID_NOT_FOUND, -ENODATA, "STATUS_OBJECTID_NOT_FOUND"},
 	{STATUS_NO_IP_ADDRESSES, -EIO, "STATUS_NO_IP_ADDRESSES"},
 	{STATUS_WRONG_CREDENTIAL_HANDLE, -EIO,
 	"STATUS_WRONG_CREDENTIAL_HANDLE"},
-- 
2.19.1


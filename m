Return-Path: <SRS0=0xI7=SB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263D0C10F05
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 00:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED3B02064A
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 00:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553907489;
	bh=TOvrNNfLSD2nytXgIuqfq5xYudGVN8xc9NdeIP6d5qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ju+iuU4kRs1AKf3cFBpsgGyQtg2F8JZaiW2yYtXq0Mmc5ZJhF+llgA3bFIacd3OaG
	 XFDjj9JdQTmtKTeIDz/3jqEl15whbXTArxb2tRt0iQcaGI/ySd5PmnN5POXIi6ONZ1
	 3nuSyCSLlDoYr1GBbVfhH6jr7VPu5eG6og+1EOK8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbfC3A6D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 20:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732228AbfC3A6A (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 29 Mar 2019 20:58:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC76D218AC;
        Sat, 30 Mar 2019 00:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553907479;
        bh=TOvrNNfLSD2nytXgIuqfq5xYudGVN8xc9NdeIP6d5qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iBJY3Ewmpug+4KlzJoIzmZ94ZNlc0XSxQPPCGzUot2rCXhM4dOXJIJcFDZm06Cf9
         XzZAmL8hS/r0KV5i5EZJLyrEDQenEEyIjCj3G/HOXVEbpbM+69RSowpWFRL2YQBVGg
         01zXckZSGXJDiKdF8zp8OvA4z3n6czypZxF4tq/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 15/15] fix incorrect error code mapping for OBJECTID_NOT_FOUND
Date:   Fri, 29 Mar 2019 20:57:30 -0400
Message-Id: <20190330005730.28777-15-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330005730.28777-1-sashal@kernel.org>
References: <20190330005730.28777-1-sashal@kernel.org>
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
index 98c25b969ab8..7e93d5706bf6 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -1034,7 +1034,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
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


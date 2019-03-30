Return-Path: <SRS0=0xI7=SB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD07C10F0A
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 01:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36F4F2064A
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 01:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553907738;
	bh=uOPriazYxEMhJNuDW4ck+4JdjpO7vbXs66C879b8UII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FZjBM/TlubGQeWdiys6VU+GyxUOL3EeiW+UpZ9c0YYF47wCSDG0Kpx0gcOwlU4jVp
	 pdgvi1N1RYW0Ra2hj91Upvtp7WDW7BpUhoqConU2GLEW/GqiIWJepV4d6PGjscXN6E
	 JX926YHr2tqUrA41mlAWFLSiIAKV2CUP3A7Yc8ag=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731851AbfC3Az6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 20:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731838AbfC3Azw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 29 Mar 2019 20:55:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BB11218D3;
        Sat, 30 Mar 2019 00:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553907352;
        bh=uOPriazYxEMhJNuDW4ck+4JdjpO7vbXs66C879b8UII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqYQlOdExKKXK14bEh+0c17dboQOFtIMzVPtq2Qvl5j9CKCaWK+oRoVT/CaFcECoY
         sV1vtvKfasYKwOASuvPPUI1OWb838JUZ+FzuZwGVWK+pEC/mGl5sn4QAKwGH2AfhvB
         ReKcdOY23Rn2BennNO3GZZeyTqdy7bYOV5deHenY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 36/37] fix incorrect error code mapping for OBJECTID_NOT_FOUND
Date:   Fri, 29 Mar 2019 20:54:37 -0400
Message-Id: <20190330005441.27540-36-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330005441.27540-1-sashal@kernel.org>
References: <20190330005441.27540-1-sashal@kernel.org>
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
index d7e839cb773f..92c9cdf4704d 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -1035,7 +1035,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
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


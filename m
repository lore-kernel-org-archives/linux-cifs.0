Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9CBC3065A
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352316AbjHQPgN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352654AbjHQPfn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:43 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC5630D8
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:42 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5SRCLltgqEHZcEHjqTcOLrWrO6ltmayS//elFhRyvY=;
        b=Mu+osz2popbSH/qK19T2D+mRWd+ZEAh0UuW5XYnHoqB52FC5JXPc2Mv3z9nEeWzJOt+P/D
        /a/PSjQjZtyLB/bE6a6QtuvbnjWABjrzOHpmjF+2drcQiGmEyHja0W74kK+KZLpGR/6Hgu
        C6BMfZPmy0gObgV8n0uLGXlaeXL4G7E295h+tsp39/o6hUAmIVUG6HxtsikJX4yZwkfpvN
        8tOnjtHhHEQo8q0FvBR5GZjQUgNrXJASwGgRFMyeChwtTa8Kenj1yWE++tNDqL7eGhvDTN
        iJBodlTyVLnLY3aF7nfccq4LlPItCOsa0wLgxgX22Xl3WWw3CQPEFzyu5FGhPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5SRCLltgqEHZcEHjqTcOLrWrO6ltmayS//elFhRyvY=;
        b=ME+4xnS7+wHzKmlLN8oY/sLUdCEAMc3bNGDT85xwIfthu2SftbB/eepN6XLmDwJHOjwDeg
        wExbWBc6v1sxZRq/mAO3eDxZ/IkzF6TTGPgz9LlCsUvU90xbF5nHeCE8wEeHPuSV10qdO2
        rkdG6Md2DUfxLRlmg/S5cckyVMNxddYI0JTJpq3SDQ27SrZCFg54MCAk82otwzP1HsNtG8
        k9rFPz6ZS65A6Umt+yBcGjMBvoAEnjw5s3GTEDTbNi/M5uJwA4rurGXV+8z90KQF5tIZVp
        hBJXS/sVLJLhm61o92P+AKA1PlN+whpCwD2yXoF/lD5p9z2jYsoQ8LU129MhBQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286540; a=rsa-sha256;
        cv=none;
        b=ZcqA6umjtJPXlh1pyGz2Ee61qsDdD6rPSlzpKC88NHR48/uYRj7+xO9PALF0dC4Y/4QPx+
        Qpv/wTVSD5AyFMOKdGSVpnyXDfEK9+vfVTQhFP1s59TapWrj9x88MPmMCKqCbgmYqqfpK7
        5Tr8ZyJN3prX0WAGd1Yfg/MmHkvuF73tPnf37EFDryRm/sbC56EzHTX/78u6nZDzzSnfbw
        8FSitvdkOGoPURiiZjqkCdC2urba0upYTBMmdcpZeyuUmj1PUGTs1tUnbIR2SaqpNLxxAN
        08hErAjYXpUYTcSR132vbckL1g2qpEj31ZxnWoGagi3J0eGue+7sCih0nKUWTA==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 10/17] smb: client: query reparse points in older dialects
Date:   Thu, 17 Aug 2023 12:34:08 -0300
Message-ID: <20230817153416.28083-11-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enable the client to query reparse points in SMB2+.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 5eb2720f4aa7..91c7b7e52a72 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5178,6 +5178,7 @@ struct smb_version_operations smb20_operations = {
 	.can_echo = smb2_can_echo,
 	.echo = SMB2_echo,
 	.query_path_info = smb2_query_path_info,
+	.query_reparse_point = smb2_query_reparse_point,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
 	.set_path_size = smb2_set_path_size,
@@ -5279,6 +5280,7 @@ struct smb_version_operations smb21_operations = {
 	.can_echo = smb2_can_echo,
 	.echo = SMB2_echo,
 	.query_path_info = smb2_query_path_info,
+	.query_reparse_point = smb2_query_reparse_point,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
 	.set_path_size = smb2_set_path_size,
-- 
2.41.0


Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF7BEB64D9
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jun 2023 09:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjF2JAN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Jun 2023 05:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbjF2JAD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Jun 2023 05:00:03 -0400
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BEB10FF
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jun 2023 02:00:00 -0700 (PDT)
X-QQ-mid: bizesmtp71t1688029192tjp6xhh7
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 29 Jun 2023 16:59:46 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: 7jw2iSiCazpkOTl9O4nSALZ0LxINjsbdBRmPSbN8nEf8IcgWFDt+ruMMTDloD
        VE3F05W8/FmabXktO2CHRy6A2FwnSLiVD63IymYwWWYBi88yUa1lx9vJasICz00JJHHIn3T
        E/DAibnLj4VbILzCd/gum068UGBNLFD8CwE7xey9iyx6ZDRWU1xszEfk62BCvce5vq0Q45F
        LZkITfRxyLKWgZhD1GnrUqCjHPcgTZQ5LP8ZsROjwzLpqbPd9ABd4XUNkIKmpLFWy+Xsso3
        tXU1Hd38nwkGCO6C2I/bMI5AkMXtDagSZipaeLHPpSI7rXWOadBiKq7Ux4iIwAj6wUxatOz
        NB7G4W96gclXHHrmZd3gz+U8u3ppyPgk0qzFYLHi3+9ChxTTnMZEf/g7veEwaspQ9jhEwlY
        IW3TZELVjCXuqu+mbyJYOw==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16652897333829944861
From:   Winston Wen <wentao@uniontech.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com,
        nspmangalore@gmail.com
Cc:     Winston Wen <wentao@uniontech.com>
Subject: [PATCH 3/3] cifs: add signal check in the loop in smb2_get_dfs_refer()
Date:   Thu, 29 Jun 2023 16:58:58 +0800
Message-Id: <20230629085858.2834937-3-wentao@uniontech.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230629085858.2834937-1-wentao@uniontech.com>
References: <20230629085858.2834937-1-wentao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If a process has a pending fatal signal, the request will not be sent in
__smb_send_rqst(), but will return -ERESTARTSYS instead.

In the loop in smb2_get_dfs_refer(), -ERESTARTSYS returned from
SMB_ioctl will cause an retry that still can't succeed and will do some
unnecessary work, like allocating/releasing buffer, getting/adding
credits.

So let us add signal check in the loop to avoid unnecessary retries and
return faster.

Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 fs/smb/client/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index eb1340b9125e..64f78e1b5ea7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2818,7 +2818,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 				FSCTL_DFS_GET_REFERRALS,
 				(char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
 				(char **)&dfs_rsp, &dfs_rsp_size);
-		if (!is_retryable_error(rc))
+		if (!is_retryable_error(rc) || fatal_signal_pending(current))
 			break;
 		usleep_range(512, 2048);
 	} while (++retry_count < 5);
-- 
2.40.1


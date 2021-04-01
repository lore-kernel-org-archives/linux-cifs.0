Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EC0C433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 07:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BABFC60BD3
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 07:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhDAHvy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:51:54 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:59950 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhDAHvf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 03:51:35 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id A640E98016A;
        Thu,  1 Apr 2021 15:51:30 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] fs: cifs: Remove unnecessary struct declaration
Date:   Thu,  1 Apr 2021 15:51:17 +0800
Message-Id: <20210401075117.998330-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTEoeShlOH0lDTh9MVkpNSkxJTUhPQktCS01VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBw6Lzo6Hj8XFisUKhI#MAIV
        MzNPCkNVSlVKTUpMSU1IT0JKSk5NVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKT0JPNwY+
X-HM-Tid: 0a788c6a76ffd992kuwsa640e98016a
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

struct cifs_readdata is declared twice. One is declared
at 208th line.
And struct cifs_readdata is defined blew.
The declaration here is not needed. Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 fs/cifs/cifsglob.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 67c056a9a519..ec824ab8c5ca 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1283,8 +1283,6 @@ struct cifs_aio_ctx {
 	bool			direct_io;
 };
 
-struct cifs_readdata;
-
 /* asynchronous read support */
 struct cifs_readdata {
 	struct kref			refcount;
-- 
2.25.1


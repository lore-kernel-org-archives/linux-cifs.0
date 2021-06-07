Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE457C47082
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 05:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE2D360C3E
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 05:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbhFGFDD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Jun 2021 01:03:03 -0400
Received: from mail-m121144.qiye.163.com ([115.236.121.144]:35532 "EHLO
        mail-m121144.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhFGFDD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Jun 2021 01:03:03 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jun 2021 01:03:02 EDT
Received: from Wanjb.localdomain (unknown [36.152.145.182])
        by mail-m121144.qiye.163.com (Hmail) with ESMTPA id BAA46AC01D9;
        Mon,  7 Jun 2021 12:54:43 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] [-next] cifsd: remove duplicated argument
Date:   Mon,  7 Jun 2021 12:54:32 +0800
Message-Id: <20210607045432.19359-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZQk1CGVYZTB5NSxpDTkpMHh5VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pk06Ajo*Hz8WCQ9DDDYqChhN
        QxNPCxdVSlVKTUlIS09KTUNPSExDVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFJSkxKNwY+
X-HM-Tid: 0a79e4d2b1f6b039kuuubaa46ac01d9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix the following coccicheck warning:
./fs/cifsd/smb2pdu.c:1713:27-41: duplicated argument to & or |

FILE_DELETE_LE is duplicated. Remove one and reorder argument to
make coding style reasonable. 

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 fs/cifsd/smb2pdu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifsd/smb2pdu.c b/fs/cifsd/smb2pdu.c
index 3e112fbdc2d9..9a46897d39c9 100644
--- a/fs/cifsd/smb2pdu.c
+++ b/fs/cifsd/smb2pdu.c
@@ -1710,10 +1710,10 @@ int smb2_tree_connect(struct ksmbd_work *work)
 					KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			rsp->MaximalAccess |= FILE_WRITE_DATA_LE |
 				FILE_APPEND_DATA_LE | FILE_WRITE_EA_LE |
-				FILE_DELETE_CHILD_LE | FILE_DELETE_LE |
-				FILE_WRITE_ATTRIBUTES_LE | FILE_DELETE_LE |
-				FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE |
-				FILE_WRITE_OWNER_LE | FILE_SYNCHRONIZE_LE;
+				FILE_DELETE_LE | FILE_WRITE_ATTRIBUTES_LE |
+				FILE_DELETE_CHILD_LE | FILE_READ_CONTROL_LE |
+				FILE_WRITE_DAC_LE | FILE_WRITE_OWNER_LE |
+				FILE_SYNCHRONIZE_LE;
 		}
 	}
 
-- 
2.20.1


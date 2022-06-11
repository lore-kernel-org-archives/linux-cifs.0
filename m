Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADDFC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Jun 2022 08:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiFKIcw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 11 Jun 2022 04:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiFKIcv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 11 Jun 2022 04:32:51 -0400
Received: from smtp.smtpout.orange.fr (smtp01.smtpout.orange.fr [80.12.242.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CA7C50
        for <linux-cifs@vger.kernel.org>; Sat, 11 Jun 2022 01:32:48 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id zwY1ngKWqeg3pzwY1nrXI9; Sat, 11 Jun 2022 10:32:46 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 11 Jun 2022 10:32:46 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: smbd: Remove useless license text when SPDX-License-Identifier is already used
Date:   Sat, 11 Jun 2022 10:32:44 +0200
Message-Id: <f9540b1a52a5d20ccfdc9c59e8016dd6a32a5b9f.1654936354.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

An SPDX-License-Identifier is already in place. There is no need to
duplicate part of the corresponding license.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/ksmbd/transport_rdma.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index d035e060c2f0..35b55ee94fe5 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -5,16 +5,6 @@
  *
  *   Author(s): Long Li <longli@microsoft.com>,
  *		Hyunchul Lee <hyc.lee@gmail.com>
- *
- *   This program is free software;  you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation; either version 2 of the License, or
- *   (at your option) any later version.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU General Public License for more details.
  */
 
 #define SUBMOD_NAME	"smb_direct"
-- 
2.34.1


Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BC0C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 15:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF9060EB4
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 15:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhKGPZp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 10:25:45 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:49459 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbhKGPZo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 10:25:44 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id jk0ZmSGDff6fnjk0ZmDN46; Sun, 07 Nov 2021 16:23:00 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 07 Nov 2021 16:23:00 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     linkinjeon@kernel.org, senozhatsky@chromium.org, sfrench@samba.org,
        hyc.lee@gmail.com, mmakassikis@freebox.fr
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ksmbd: Fix an error handling path in 'smb2_sess_setup()'
Date:   Sun,  7 Nov 2021 16:22:57 +0100
Message-Id: <17d0c2af6d0a35c2951f0ac5c7a1dfea04df410f.1636298480.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

All the error handling paths of 'smb2_sess_setup()' end to 'out_err'.

All but the new error handling path added by the commit given in the Fixes
tag below.

Fix this error handling path and branch to 'out_err' as well.

Fixes: 0d994cd482ee ("ksmbd: add buffer validation in session setup")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/ksmbd/smb2pdu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ba68a27cabf8..bb0d1b155b34 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1698,8 +1698,10 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
 	if (negblob_off < offsetof(struct smb2_sess_setup_req, Buffer) ||
-	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags))
-		return -EINVAL;
+	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags)) {
+		rc = -EINVAL;
+		goto out_err;
+	}
 
 	negblob = (struct negotiate_message *)((char *)&req->hdr.ProtocolId +
 			negblob_off);
-- 
2.30.2


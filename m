Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8022EC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 11:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5467D610CC
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 11:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhJGLtM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 07:49:12 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:35508
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232299AbhJGLtL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Oct 2021 07:49:11 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id F05A43FFF1;
        Thu,  7 Oct 2021 11:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633607237;
        bh=W5VeJU99qrffKHo2PFpLiNDswouhdVFOZ9YaoL8Ua4Q=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=wE2cyQY6ja4OBsfC944YdFfwic8S0z1n683j/0ZSz/FpOuWeZaXcJ2z/NHv7L2bcx
         uj/vfv1bTeQDtvLGp7xoUb4C1NV8KUEOl22V+LAhl0WY2d5Im1edufhEU/BmUk5UZ3
         gVbjQSjUMCcc1aynYZbLS7KiBBk8UV/qRKayX2Y2GZH+jv2MrBYYGDFu6DrORcZkj9
         obE1w8faFf+tByNs19Zw1zgcCc0puBJveUA9zC82tc2mEnD9rp0QUY88MKRI/1f91q
         nuoavNcE0D3zy9775dpoaGzjwhR15DTR2/jOHZhHXXQKuBjsvINoCJIcM0ra0HXJtj
         HUyrwl30kMC1w==
From:   Colin King <colin.king@canonical.com>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] cifsd: Fix a less than zero comparison with the unsigned int nbytes
Date:   Thu,  7 Oct 2021 12:47:16 +0100
Message-Id: <20211007114716.13123-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the check for nbytes < 0 is always false because nbytes
is an unsigned int and can never be less than zero.  Fix this by
using ret for the assignment and comparison and assigning nbytes
to ret later if the check is successful. The fix also passes the
error return in ret to the error handling path that caters for
various values of ret.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ksmbd/smb2pdu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 8ceac0ebdbea..9be82d08b722 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7537,9 +7537,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
 		break;
 	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
-		nbytes = fsctl_query_iface_info_ioctl(conn, rsp, out_buf_len);
-		if (nbytes < 0)
+		ret = fsctl_query_iface_info_ioctl(conn, rsp, out_buf_len);
+		if (ret < 0)
 			goto out;
+		nbytes = ret;
 		break;
 	case FSCTL_REQUEST_RESUME_KEY:
 		if (out_buf_len < sizeof(struct resume_key_ioctl_rsp)) {
-- 
2.32.0


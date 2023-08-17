Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB72C3DA45
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352326AbjHQPgP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353228AbjHQPfu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:50 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722CC30D8
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:49 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTjDRReiGjyTPvMeCsJB3obpBf0aVkmd6MiO7iIGZ0Q=;
        b=RYaydkuGIhmRJ6ldNmGeKm3HqcyZ40IDuVS6V6vFh0NKmybIZi03I+yHs8HN/yM4HRuvtO
        ZbyO6HC9NziRCCfOsgF/jpWt//YIm2gVZ5uFVNMQNdJCnVcTWPfoPU+rby+2oxV7G/2wSi
        HURBDokKcAVKRvKTqP6N19m9B8vCGgpQpeIN0AmWSmAiTz06BF8qcEq6e+7+9v0fqtCBO9
        Dh5TaDz/00NzrxAwMOyav3XPUtGfEwxM6yNJbCCypY6JyrN925KbwXaVmq2ubMMNphrF1U
        KsVz2Cz+5l58nfRb27E0a+xxzX9NDMlCaMMSLD08mTmwjiE/EpaF+42MpvRXxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTjDRReiGjyTPvMeCsJB3obpBf0aVkmd6MiO7iIGZ0Q=;
        b=Im5JqXFihzjQehsQXvhWy6aVzapswBvthu8Mt/AMAAytmoDyMfhgcsGE2jTULbQHW0Sf40
        156eVyZvjyQusN/8pdtHT6p01QWfgooh8RG06sJe0pCfiERAK8mfZM4IL81YaXyLDu6nxo
        hKmKaYlP6kssPA0BxlgIcXptAn4smxr05IfXMtqR3n45no7Me0j4tssbURUjO5gBdx0ecj
        9GM5kYo7m8fGduJ08RqcpHBosfZGnHkSAbWb/Nx4L6TswBJZa3iamCuosoZ4XlaL22LoyB
        GUlA0/sVA6eW0cxv0mPOSUir813/J4DJvTf6YVNhkXLwjrx4PeulASvm9WG1Qw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286548; a=rsa-sha256;
        cv=none;
        b=EhK/aZU8BEg5tKdlGSvBBCAF1TzsMnabvLwQB78lpgLtAe0BI1jJAieo9iwXERVaaVqsV2
        3ckCAidqZBHTcLk4zK7IDXxpmaj1LI5zrLPbq6vKEo5KYtkVgbTw+AENSB6u/5PeYqr7B6
        19+9F7muppi9GjpffROX31KTpp9fwwgSdEBlN7IPOVzCSEu1TszvUSEBzogJ74y4CZQVuR
        hhGaHYznd3AyfpJmebafYUCfPQ4Rw0gbgsrrvw8T0N5RFTXpZnMZ+Md8s4ZCKCf7BJBD5j
        Az8kG513ngJLMBG/D4+b4ByWph7Qr1RonzzH5O7oWoKwtM735N9DSUdc7i3qLA==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 14/17] smb: client: reduce stack usage in smb_send_rqst()
Date:   Thu, 17 Aug 2023 12:34:12 -0300
Message-ID: <20230817153416.28083-15-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/transport.c:420:1: warning: stack frame size (1048)
  exceeds limit (1024) in 'smb_send_rqst' [-Wframe-larger-than]

Fix this by allocating a structure that will hold transform header and
compound requests.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/transport.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index f280502a2aee..1b5d9794ed5b 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -416,13 +416,19 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	return rc;
 }
 
+struct send_req_vars {
+	struct smb2_transform_hdr tr_hdr;
+	struct smb_rqst rqst[MAX_COMPOUND];
+	struct kvec iov;
+};
+
 static int
 smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	      struct smb_rqst *rqst, int flags)
 {
-	struct kvec iov;
-	struct smb2_transform_hdr *tr_hdr;
-	struct smb_rqst cur_rqst[MAX_COMPOUND];
+	struct send_req_vars *vars;
+	struct smb_rqst *cur_rqst;
+	struct kvec *iov;
 	int rc;
 
 	if (!(flags & CIFS_TRANSFORM_REQ))
@@ -436,16 +442,15 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		return -EIO;
 	}
 
-	tr_hdr = kzalloc(sizeof(*tr_hdr), GFP_NOFS);
-	if (!tr_hdr)
+	vars = kzalloc(sizeof(*vars), GFP_NOFS);
+	if (!vars)
 		return -ENOMEM;
+	cur_rqst = vars->rqst;
+	iov = &vars->iov;
 
-	memset(&cur_rqst[0], 0, sizeof(cur_rqst));
-	memset(&iov, 0, sizeof(iov));
-
-	iov.iov_base = tr_hdr;
-	iov.iov_len = sizeof(*tr_hdr);
-	cur_rqst[0].rq_iov = &iov;
+	iov->iov_base = &vars->tr_hdr;
+	iov->iov_len = sizeof(vars->tr_hdr);
+	cur_rqst[0].rq_iov = iov;
 	cur_rqst[0].rq_nvec = 1;
 
 	rc = server->ops->init_transform_rq(server, num_rqst + 1,
@@ -456,7 +461,7 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	rc = __smb_send_rqst(server, num_rqst + 1, &cur_rqst[0]);
 	smb3_free_compound_rqst(num_rqst, &cur_rqst[1]);
 out:
-	kfree(tr_hdr);
+	kfree(vars);
 	return rc;
 }
 
-- 
2.41.0


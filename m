Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14F7C001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbjG1TuY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbjG1TuX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:50:23 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E74420F
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:50:22 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTjDRReiGjyTPvMeCsJB3obpBf0aVkmd6MiO7iIGZ0Q=;
        b=Lwu6WayQMhUAE4lf9yLEAhTB3e0PrlsVQfHShCSgzbcwdvTdIn6ndMfBdqdzKrYGlI5Qlz
        jnm/N7DugEtq9WFmB8oXlYACXxhDb+uudQ5YPIZXD/zR43zTHfIhDwu0lKyoymhF7GOnVL
        CAdH5V74FCQkTVAdzDd/BQh8j+dgnDb61pr4LAMS+CZdyRu3W5IoE3Q3LgikAetPFieGT9
        8nlu/yKKnjjbG4FvXJZTpIAaXhRJo3b3K7VZzyaUsS/e6qg+2LxZ7THyUPGf3muqsGDE+p
        X0GjkFYsRcN6DPmFzXnLL756FBrPsCNphAmSgjwhIBG/4tOdSfkOUYvT0pGRxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTjDRReiGjyTPvMeCsJB3obpBf0aVkmd6MiO7iIGZ0Q=;
        b=q8sCaPmYHQso24SwyZWUsaCi7qF3cQeSVlvT3SOC0FKI1xYh/JSMPA3cj4pyamXIOQQqKL
        0n68IU2r85GRF/HjV9w7RzxyJfY9Xdh2yeL66qGDDQaaQh5qZnAS6miTgGbTp7WSdhBTQC
        Ud1zlA/g0P1Kicww5RDiIXGRXHBCUYtWhks2kceUnIkUHMdNG0CINnpWWYTunoRZos9OUX
        ZiTgzNSnvy2uASh2v7ke4oxpUyP4fm1jldclxy2p68jZ/WQFkip5KTb8X+YO6neSLL4UJa
        aAdvhN4IYLT9Kt8t1NNAMzTY7j9h0iSNCh0OSLMKDYIGEvWOUBaNz23i32Um2Q==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1690573821; a=rsa-sha256;
        cv=none;
        b=U7XJMFJybny7jGT4MdQLGOkMDZ8fX50etqg1IpavuFmPRzZEVo6XWxdM9bQQEJ25XYv8cG
        hZhSu+/nrUYrMvw8r0qRFyLGvBFDYTHfCJmEW+yGGWdU7BC+AmwqKKLqt5QF3OBaq3itGT
        tBNe9AzWRsTNocF7Pg5LsMDA1sVtllOfCpjcxjseD3eSoIDFpPy8yyPCQseidx+geLO9r5
        2WPhJQPpqeeCgf7lZiDvof/B7PXrroKuvMeXLb/H15APgAbAk8R5hR5E8rhmbPhiUIFHad
        Kl+IvnEqAQife+nXYRFhW5EoHAnFrMxmqqL6pWjRfyTc0W4i8166G6zrO36g0w==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/8] smb: client: reduce stack usage in smb_send_rqst()
Date:   Fri, 28 Jul 2023 16:50:04 -0300
Message-ID: <20230728195010.19122-2-pc@manguebit.com>
In-Reply-To: <20230728195010.19122-1-pc@manguebit.com>
References: <20230728195010.19122-1-pc@manguebit.com>
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


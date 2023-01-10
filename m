Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671F6C54EBC
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 20:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbjAJUzm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 15:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbjAJUzd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 15:55:33 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086B51B1C9
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 12:55:29 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9B88D7FC04;
        Tue, 10 Jan 2023 20:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673384128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DeTARiNzmrNr80TQHJV5AcZCh+S+iMSmZvb8259FPY8=;
        b=zo9PhW4nQABMLS46DwrBgdMdQp+oZUXvD8b0Y1DjNC9kpWX16vjA7L+sB2o5K1FLG+J+dS
        Jgblcf6bZnE+YgsHxZkJ8ZcPrSGaVwSaMbC2M4xjd2m7GeSVxTqiQiJssGt3VuMZZIMtHb
        Do61ftrs7oaoQnHSp/rERIxfZ8jkxUa9kBRli7atjDVnEH/3C/8aJi+TdNFmZSpMPyoZ0T
        1zN9FrlVx+RHSexNiqkawKLJJwO8RDAAfTtgBhtLKTlspP0aPK55anGGRieFH/xbtorsTA
        taenoYqksnpZvJi4sWslailLXh4iyxg4+R2beL7d3LXwJm/tb34rxjbKcIcrmw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix double free on failed kerberos auth
Date:   Tue, 10 Jan 2023 17:55:20 -0300
Message-Id: <20230110205520.4425-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If session setup failed with kerberos auth, we ended up freeing
cifs_ses::auth_key.response twice in SMB2_auth_kerberos() and
sesInfoFree().

Fix this by zeroing out cifs_ses::auth_key.response after freeing it
in SMB2_auth_kerberos().

Fixes: a4e430c8c8ba ("cifs: replace kfree() with kfree_sensitive() for sensitive data")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2c484d47c592..727f16b426be 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1482,8 +1482,11 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 out_put_spnego_key:
 	key_invalidate(spnego_key);
 	key_put(spnego_key);
-	if (rc)
+	if (rc) {
 		kfree_sensitive(ses->auth_key.response);
+		ses->auth_key.response = NULL;
+		ses->auth_key.len = 0;
+	}
 out:
 	sess_data->result = rc;
 	sess_data->func = NULL;
-- 
2.39.0


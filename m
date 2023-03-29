Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2E1C761A6
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjC2UOo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjC2UOo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:14:44 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A8B4ED5
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:14:43 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ApBFYKjUkyC5IY65UbHkiGfR1ySS2y4rREOzpnyUlbA=;
        b=Egd2Zw0IhCPG7Ra5w9I0XGwVQ9Sp/wAxbOkaHUCrTegjK3i2NMdFxKMypg2cl6HIpnMt9m
        r6KbebYOz5fiNwMQLv2LAA/JqezTsi2yUSnJDG+V3qQIBXLiE4DkGRzFPkXsC6KvyDlprv
        d38KiVfpxnmhIQSVhCwmWOoAyMdL2wE9SKPpUoynDTDY8phWV4/p4qO0ebJ0DajMWNoZUc
        ZH5Ec4zNy3NkMQoFM5TZEeA2SRqwJJOX6UxnQT/EBo9H8ZozDvsRrsDXObppn6En5MREp8
        5aeNGC+bNCNe+MyMlicJ9bPhrlmsVuQRhennbADpHM977utcJgHGmP6xjRjubQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1680120882; a=rsa-sha256;
        cv=none;
        b=LTYCn7hA/3CwuMGQ9XALAVRG+EC301V+3wqNNpkrGo81cxovGDOawAYMdqh8z9oOc5De+D
        y6029c0YnrHmmCvex/L5Fps1QVGPyjozBwXN9FK3QDqSu/WqTLBl3bXk7TUizPhe7dTTjj
        o+Gffgqn2RIEDuM9KkYl4QIWhSDAVMvcw9bXImd+ZtiUrkz6nM6FnewIHDawOQ2XPqBxXv
        mS31og2aQca9tLZ1opOlyj0zhMetGDDpkd95lCZClAZrfnffceiTS+WuNQtOeNal43Xbhq
        gFKJnXq7/URNkjgfiMgWaU3Q3JhD+XxyGKv2GwKJtqxgUniQEJBfzUo1BqkMGA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ApBFYKjUkyC5IY65UbHkiGfR1ySS2y4rREOzpnyUlbA=;
        b=NVUzxnuqX8/kE8bmTMnMxjK/rSGz7MZ8D4amgAQvP6P91mpo98Zc1059NxPIObzkDgKeQP
        3/sTWySErcX+6BeA4Bs1bLytNA+M/4C3ux4zzRbt+9PT2jzeqJAK8g9rIb2GEhDCBj3dWX
        mFCpsSyHKjb+x4Qg/L360RGb98/dRxiZEVavxBfANvAyn+PAQZv+5AbBVocD/vXoesUNRz
        9YV4wN2jZx9xnvF8KSZ/3LDNXgdwdezZWqkw8kEVY7qkDuL0Lf9qdCI4f2PgDOREflPAGV
        40JXnFV1CxKFN3+SvDfS6JdEmx9VtqHjVr/WyJAb7V5oZyirI2HBbE/EvC2Zzw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/5] cifs: avoid races in parallel reconnects in smb1
Date:   Wed, 29 Mar 2023 17:14:21 -0300
Message-Id: <20230329201423.32134-3-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-1-pc@manguebit.com>
References: <20230329201423.32134-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Prevent multiple threads of doing negotiate, session setup and tree
connect by holding @ses->session_mutex in cifs_reconnect_tcon() while
reconnecting session and tcon.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifssmb.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 38a697eca305..c9d57ba84be4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -71,7 +71,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	int rc;
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
-	struct nls_table *nls_codepage;
+	struct nls_table *nls_codepage = NULL;
 
 	/*
 	 * SMBs NegProt, SessSetup, uLogoff do not have tcon yet so check for
@@ -99,6 +99,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	}
 	spin_unlock(&tcon->tc_lock);
 
+again:
 	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
 	if (rc)
 		return rc;
@@ -110,8 +111,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	}
 	spin_unlock(&ses->chan_lock);
 
-	nls_codepage = load_nls_default();
-
+	mutex_lock(&ses->session_mutex);
 	/*
 	 * Recheck after acquire mutex. If another thread is negotiating
 	 * and the server never sends an answer the socket will be closed
@@ -120,29 +120,38 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedReconnect) {
 		spin_unlock(&server->srv_lock);
+		mutex_lock(&ses->session_mutex);
+
+		if (tcon->retry)
+			goto again;
 		rc = -EHOSTDOWN;
 		goto out;
 	}
 	spin_unlock(&server->srv_lock);
 
+	nls_codepage = load_nls_default();
+
 	/*
 	 * need to prevent multiple threads trying to simultaneously
 	 * reconnect the same SMB session
 	 */
+	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
-	if (!cifs_chan_needs_reconnect(ses, server)) {
+	if (!cifs_chan_needs_reconnect(ses, server) &&
+	    ses->ses_status == SES_GOOD) {
 		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
 
 		/* this means that we only need to tree connect */
 		if (tcon->need_reconnect)
 			goto skip_sess_setup;
 
-		rc = -EHOSTDOWN;
+		mutex_unlock(&ses->session_mutex);
 		goto out;
 	}
 	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
 
-	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (!rc)
 		rc = cifs_setup_session(0, ses, server, nls_codepage);
-- 
2.40.0


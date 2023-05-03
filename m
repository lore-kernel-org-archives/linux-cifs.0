Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93931C7EE2C
	for <linux-cifs@archiver.kernel.org>; Wed,  3 May 2023 22:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjECWVv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 May 2023 18:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjECWVt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 May 2023 18:21:49 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80267D8E;
        Wed,  3 May 2023 15:21:48 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rDyRVZwOQAjEEnKyBT8vMShxV4eGFJEG2e1sZvcJu8M=;
        b=s9+8pfyGDIb/WMrgKFw+x1wg8VgWieU7Jy9NquSrK5K3HKPNasLW+JFsn3MG5/q78TqXYI
        aW5/jY5ccqppB5tO0PdY9Apq9Lfz+B9BVbaIrVbg3VtqX6R5SjwDBcgSS7QtLgbAw+qEq8
        T+znweb0lFPkmu90EEM1CXJBN3uWl/g06RFwOq8zVscwZ3lG8fJFBwoyIjQF1oesFMxbIf
        2H126HBjDBp/gmVrIDqr7hZwGG8ULqxiFneJfty876TulVVypnw7QZPQuUWN+WrnL4pZRw
        Ncn62sO/rqqlGN6gzD4g/wA2y9gePvkr6Em410rozDy0osuSdvbpIGkNLgm8TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rDyRVZwOQAjEEnKyBT8vMShxV4eGFJEG2e1sZvcJu8M=;
        b=G841ZMZ4otPDl7nODSv/KKKJsXYo0vtDz4HeYa0QOifkcR9V97h0idKU/hgZOQE7BEPx7b
        UPO/8BBA/SSGYg4OQvENMY7HwGScKKgriWHH+15l391ofVF2UCoswsnKEfYvGfA3NYGrEB
        cGPyrzMzIlpUg6P56kQboj1fvVynZG4eqwccwI9ZvDICRZof6EC160H85RzFyaOlyqisbM
        5TedUNOt3Mprtixqy44knTc82rLMtcKdbOszRsJNrH+dqwn6tWx00aSFSYScePNZnKyj/Q
        rMZY0wIZuRYy9AT2JI4Dgq229UYIznY1XNmb8OmtVWKb2ueVbgh1mfVVOpfRyA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1683152507; a=rsa-sha256;
        cv=none;
        b=pRSBdtcylnArF6uaa/FKlbOWANdDU+/Mui/qjN8OQJRWuYrF4Rc8jt94Pul0PSLIQngnpk
        IrhfYkhcdgEgYxtq0N8FOUp99J/j3ZifD6LhDemDcSLUQ2x/pFkPW8E2vZO343evlz4Scr
        qPcstIpbe7tt8VfHjFj6ac7bSlIDDcOikhCdWJcb8aW0kz0Vb4GpP/wQtDRS3cflPMsWUQ
        8fPsa3zzlCl4kgSQI9uCmdDXiyInDq7p/mQAXNDcDMkR3onoywhp+JbCJ86dZyE3IaOKS+
        XzIHDSSN4eNHOQYBaJIHDHS7O9lq74/ABiI2tmFUEx7puIiLFCuf74jPRiAZ3Q==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/7] cifs: protect session status check in smb2_reconnect()
Date:   Wed,  3 May 2023 19:21:13 -0300
Message-Id: <20230503222117.7609-4-pc@manguebit.com>
In-Reply-To: <20230503222117.7609-1-pc@manguebit.com>
References: <20230503222117.7609-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use @ses->ses_lock to protect access of @ses->ses_status.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/smb2pdu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4245249dbba8..6a9661f3d324 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -175,8 +175,17 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		}
 	}
 	spin_unlock(&tcon->tc_lock);
-	if ((!tcon->ses) || (tcon->ses->ses_status == SES_EXITING) ||
-	    (!tcon->ses->server) || !server)
+
+	ses = tcon->ses;
+	if (!ses)
+		return -EIO;
+	spin_lock(&ses->ses_lock);
+	if (ses->ses_status == SES_EXITING) {
+		spin_unlock(&ses->ses_lock);
+		return -EIO;
+	}
+	spin_unlock(&ses->ses_lock);
+	if (!ses->server || !server)
 		return -EIO;
 
 	spin_lock(&server->srv_lock);
@@ -204,8 +213,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	ses = tcon->ses;
-
 	spin_lock(&ses->chan_lock);
 	if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconnect) {
 		spin_unlock(&ses->chan_lock);
-- 
2.40.1


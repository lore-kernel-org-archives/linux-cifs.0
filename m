Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E64EB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Jun 2023 03:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjFSDfM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 18 Jun 2023 23:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjFSDfL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 18 Jun 2023 23:35:11 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8B5E4F
        for <linux-cifs@vger.kernel.org>; Sun, 18 Jun 2023 20:35:03 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-62fe6773c4fso20768346d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 18 Jun 2023 20:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687145703; x=1689737703;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=pTC6KiuSPHbv9DN9h9PIHCqMwbj903uzNxWXj1sN6g4=;
        b=GoJwbX1OnzuWFo+fkQsbZUMT6cFUdlBiG4cbRcmN8ADU+PM5stm+quOA8rDLD5+eX0
         cfO6FgUI7vnVOYSIJLunaj5uwD+JHRA5xgFaIyfl4yW9WAq4McIT0uqZCQLv2tni1ejT
         641QgbO3fxjV6tsfuQXbCkZvah7Tat0AqWsOsJmJ0ghdKiZB21J0S+98FWA+T01rikny
         XEBZIjpvJIyxVM6FlrkSPbhTeosOH7KsPOIIwqITIfjHbrwJURKdmXdGopTxpnPgs45l
         +T461W8BIL4ueIY3QwrUiIGnS+qh4jClPbHDxdJGM+dNagI57AeqAJ0zGkWMdbqkL+U0
         ZiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687145703; x=1689737703;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pTC6KiuSPHbv9DN9h9PIHCqMwbj903uzNxWXj1sN6g4=;
        b=W4HPWazsb7DduOTIeNEcpgn1a998/K8XrP/8ILc/+/kPSkvCOWC1S3vFHAizVzzGbI
         PFyAkLaobGXAccflTV4gmd4ip1nJoOLKSyCcitO/Q/CHAvc+rBustRrUBaw0uz671TJb
         MoiDWDYOBKgL/gcPEXqAoyVw9jjtbwj3XO3uCZ2GkEEoBv8fyZNcp4pILZEV9dvzA8Mc
         tTgcIZs/VDAM604xzYZ1n+ZaWajmMJMwN8GG40fLbi4qSUbdelItG9sw/750pLuEIQCk
         OhOMDOE0MfNfpDVBDWeh0LRYg6Y0c7y2XHDPVfDrZVI4zofNT18kAsI1Iv839n4IVoao
         Lq0w==
X-Gm-Message-State: AC+VfDzSByrCUSf2x0/GnWzOd0vkKwLz5S88M0YMmwDvBR3ycwZneLut
        bwR0ODLe1dnpwfsLQS8HA0o=
X-Google-Smtp-Source: ACHHUZ5KZFcS8x/nDyS8+i2nVSCGB+filCt8YECjm/fwlGbzuyCDuaPwSPTPZpXhG1dq2o3XsQpm+w==
X-Received: by 2002:a05:6214:23ca:b0:625:83ab:8a42 with SMTP id hr10-20020a05621423ca00b0062583ab8a42mr9777552qvb.46.1687145702941;
        Sun, 18 Jun 2023 20:35:02 -0700 (PDT)
Received: from ubuntu2004.1qqixozwsnuevircicbvxjrsib.bx.internal.cloudapp.net ([20.84.44.103])
        by smtp.googlemail.com with ESMTPSA id u20-20020a0cdd14000000b0062ded562c53sm5225441qvk.37.2023.06.18.20.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 20:35:02 -0700 (PDT)
From:   Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com, nspmangalore@gmail.com
Subject: [PATCH] SMB3: Do not send lease break acknowledgment if all file handles have been closed
Date:   Mon, 19 Jun 2023 03:34:36 +0000
Message-Id: <20230619033436.808928-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In case if all existing file handles are deferred handles and if all of
them gets closed due to handle lease break then we dont need to send
lease break acknowledgment to server, because last handle close will be
considered as lease break ack.
After closing deferred handels, we check for openfile list of inode,
if its empty then we skip sending lease break ack.

Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending oplock break")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/file.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 051283386e22..b8a3d60e7ac4 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *work)
 	 * not bother sending an oplock release if session to server still is
 	 * disconnected since oplock already released by the server
 	 */
-	if (!oplock_break_cancelled) {
+	spin_lock(&cinode->open_file_lock);
+	if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
+		spin_unlock(&cinode->open_file_lock);
 		/* check for server null since can race with kill_sb calling tree disconnect */
 		if (tcon->ses && tcon->ses->server) {
 			rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
@@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *work)
 			cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 		} else
 			pr_warn_once("lease break not sent for unmounted share\n");
-	}
+	} else
+		spin_unlock(&cinode->open_file_lock);
 
 	cifs_done_oplock_break(cinode);
 }
-- 
2.34.1


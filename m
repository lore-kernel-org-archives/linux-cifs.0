Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3DDC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Dec 2021 16:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhLVQEy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Dec 2021 11:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241680AbhLVQEp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Dec 2021 11:04:45 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E47C061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Dec 2021 08:04:45 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id m2so1109362qkd.8
        for <linux-cifs@vger.kernel.org>; Wed, 22 Dec 2021 08:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vIG2t5+LtGXZOPLhVlhtsrjR+79QaX0lEIveEZrE/2I=;
        b=iLNjWPcYRc9cg9frCns2r1QE5HFv2HGr6nN5Tt/zx6KpJbYhqb4xds3KqwwfEYgsUK
         Sh+gRYOKGtDDj6BfoHzYwhb4+JHv4gWyTm5Kn5122PXdIJAPzU4EWr7nX1Km8krSBDkT
         umfoBcIe2gA+yakDxTqLhEE1T1hHYxqfrYbqBRwhmng9IU53kxf7UFXCdgRl/VbN/JW3
         5dF4G51Bf2uK8qdbt3Y8htrDR7SXK9J9INXB0qHDuaEVjyUi1/lX3g3Ue0NRDIoTtayp
         P1rMMPQU9YHSLnU2r6uJ8ALaHefxjYyKWSwltT4bFkWBhELAv5cLIwSkYABs/TlooyhJ
         2n0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vIG2t5+LtGXZOPLhVlhtsrjR+79QaX0lEIveEZrE/2I=;
        b=463rzg/NZ7leusWFANHY1GesmQs7xo880HuivJ2oRT0a7VWtj56387+L1JyZyct5gV
         C59QIXJK8J1YYwG2StS/ybb+WvK5KD8ctMffrp2N1lMROVlDrqHg/xOHm+QCPYmlmGIy
         ClG1NvLsTbMhNEZeB5tDgkGieOkOAA/s0qak4IL9IlYv3bHrIggHuNFHmHI7DvtOdm5p
         Lz0B3LE+81apmpLoOXWWz7TiXdDZH34qm30wXvMvqVy8H1vtfruebGkD77//otjKvX4o
         juKg+KmgTqNHeOX+uGrc1B7DKqjq88Yy+IyRxy2SnQRjPjWsmFaWtXsVCsVdOKZygkx5
         0YdQ==
X-Gm-Message-State: AOAM531FPbYcUjIr73qTmP2H35M+TqrIzvRmSVntAfzmPsaD7Gyv0DIj
        tKdOw89f7r4N5xJZOYj452UORBOajQk=
X-Google-Smtp-Source: ABdhPJwdi5DHcWOVRde2QfudgL+W4Pgpq2fODT5OSt594N/N6jtYp2wltTArPa+PZ7WF/4zGDAGUCg==
X-Received: by 2002:a37:752:: with SMTP id 79mr1473190qkh.98.1640189084376;
        Wed, 22 Dec 2021 08:04:44 -0800 (PST)
Received: from pascal.home.bair.one (2603-7000-0d07-ad00-0000-0000-0000-081b.res6.spectrum.com. [2603:7000:d07:ad00::81b])
        by smtp.googlemail.com with ESMTPSA id d17sm1909361qtx.96.2021.12.22.08.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 08:04:44 -0800 (PST)
From:   Ryan Bair <ryandbair@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Ryan Bair <ryandbair@gmail.com>
Subject: [PATCH] cifs: fix workstation_name for multiuser mounts
Date:   Wed, 22 Dec 2021 11:04:05 -0500
Message-Id: <20211222160405.3174438-2-ryandbair@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222160405.3174438-1-ryandbair@gmail.com>
References: <20211222160405.3174438-1-ryandbair@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set workstation_name from the master_tcon for multiuser mounts.

Just in case, protect size_of_ntlmssp_blob against a NULL workstation_name.

Signed-off-by: Ryan Bair <ryandbair@gmail.com>
---
 fs/cifs/connect.c | 13 +++++++++++++
 fs/cifs/sess.c    |  6 +++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1060164b984a..cefd0e9623ba 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1945,6 +1945,19 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 		}
 	}
 
+	ctx->workstation_name = kstrdup(ses->workstation_name, GFP_KERNEL);
+	if (!ctx->workstation_name) {
+		cifs_dbg(FYI, "Unable to allocate memory for workstation_name\n");
+		rc = -ENOMEM;
+		kfree(ctx->username);
+		ctx->username = NULL;
+		kfree_sensitive(ctx->password);
+		ctx->password = NULL;
+		kfree(ctx->domainname);
+		ctx->domainname = NULL;
+		goto out_key_put;
+	}
+
 out_key_put:
 	up_read(&key->sem);
 	key_put(key);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 035dc3e245dc..42133939f35d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -675,7 +675,11 @@ static int size_of_ntlmssp_blob(struct cifs_ses *ses, int base_size)
 	else
 		sz += sizeof(__le16);
 
-	sz += sizeof(__le16) * strnlen(ses->workstation_name, CIFS_MAX_WORKSTATION_LEN);
+	if (ses->workstation_name)
+		sz += sizeof(__le16) * strnlen(ses->workstation_name,
+			CIFS_MAX_WORKSTATION_LEN);
+	else
+		sz += sizeof(__le16);
 
 	return sz;
 }
-- 
2.33.1


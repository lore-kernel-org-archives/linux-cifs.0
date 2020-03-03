Return-Path: <SRS0=S2CZ=4U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E1FC3F2D1
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 23:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBF9A206DB
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 23:39:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9W5ElJ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgCCXju (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 18:39:50 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37637 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbgCCXju (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 18:39:50 -0500
Received: by mail-pl1-f194.google.com with SMTP id b8so136039plx.4;
        Tue, 03 Mar 2020 15:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MlgGONKkRLK3NcvigeAJc91a/0y8Apuj7MwQf/mg+U0=;
        b=D9W5ElJ2zxSPQm4mNWtoIMwwurVR9+YB+QwzGyMNY+2dod40+OQtgHk1q3WL8pPRYi
         btF0N+R5jBEgLjFYe+UritcA0LB7O2LpRC4TF6WnkYIUYHQs2oGEIJ1hopgAuDvLOrbR
         99Qf4VTvjXvqXXGOSr71qqkt90axZRtZIeQPSx8NvO1TBgPdE6OLFDWyWyF8FnFv1zVK
         Yz+DCu48XhqgPtdAbDal/QSFSEcakC1n7h8nk1PThpkRVStI262AVvSFq3ySlUCtivXo
         XQlWw9ME8wwoKH0ZSOnwzO5dDtOWIsubW9wOPAxXlpbo0OnNiijNI6XopU+6aksokKYA
         gQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MlgGONKkRLK3NcvigeAJc91a/0y8Apuj7MwQf/mg+U0=;
        b=EotNq3q6mQ9zpSwPJfZUn/XQstN44AQVF4eNIqYAkTHFf6K72YT552pwBtUpQToW7J
         1gQrq+UP8jKBErruAdePjC6d0Avj7Xm50lOG/CjZZ1BGScd7APKPbKzLP/eO8+wOOmuK
         1iv0GjB+YsOS0rTHbRFWI6nV00xQMKL8m+7kG0X3GTCx9DMg/JDI1y/OaKlmOKDgiQlt
         41lIyuViECOc+QOz4kB/3H30St8KYomXp/ykizOm0A6IMylhvYSzkhjX+n3hWu164GhD
         Mfvg80V6RZSfuu/ZSRUgsXBY0DAv62fZXMx//OU6I3etuhmDW4uhVS2iqTydOMe4LEDz
         Xi9Q==
X-Gm-Message-State: ANhLgQ0tAE/Tf9jh1+/y40AF7+qoBli8GNRzE6Es8kbrsuJnjJwb66TM
        IZtTZ6qCKllZdreHUFlQicM=
X-Google-Smtp-Source: ADFU+vtQ/e7DsvLk4ksjt5EmjwpakcglqQtUHEch5z+psuTO23FwIqq98Hw/eHUDA5CdkXvxchABqA==
X-Received: by 2002:a17:90a:c390:: with SMTP id h16mr399pjt.131.1583278788877;
        Tue, 03 Mar 2020 15:39:48 -0800 (PST)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id d1sm25569029pgi.63.2020.03.03.15.39.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 15:39:48 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, smfrench@gmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] fs/cifs/cifsacl: remove set but not used variable 'rc'
Date:   Wed,  4 Mar 2020 07:39:43 +0800
Message-Id: <1583278783-11584-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

 It is set but not used, So can be removed.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 fs/cifs/cifsacl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 716574a..1cf3916 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -342,7 +342,6 @@
 sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		struct cifs_fattr *fattr, uint sidtype)
 {
-	int rc;
 	struct key *sidkey;
 	char *sidstr;
 	const struct cred *saved_cred;
@@ -403,7 +402,6 @@
 	saved_cred = override_creds(root_cred);
 	sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
 	if (IS_ERR(sidkey)) {
-		rc = -EINVAL;
 		cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
 			 __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
 		goto out_revert_creds;
@@ -416,7 +414,6 @@
 	 */
 	BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
 	if (sidkey->datalen != sizeof(uid_t)) {
-		rc = -EIO;
 		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
 			 __func__, sidkey->datalen);
 		key_invalidate(sidkey);
-- 
1.8.3.1


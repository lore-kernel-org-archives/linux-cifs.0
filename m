Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1985AC11D30
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5C9520838
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="O2gBoUey"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgBXNP6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:15:58 -0500
Received: from hr2.samba.org ([144.76.82.148]:41900 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNP6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:15:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=mtilYb3PJCQGi4skmKYWlpj2keUF1IlKC3+yztwWDW8=; b=O2gBoUeyMO3U7+MlunXW3NeLmo
        tNAsTg1xaSfTjhJLvhhlwfaUfpvHBWKK9UafdBKKU1iEBkNWZlINCJIFppJg5EDjQPtEFCJ3S9iug
        xkpvnAPSeQz7F/I04p5FAtfe7tZgRxsOkaQ32acaD9yinIrm/uUYQxmlbaaUyOD7WZtbaW6oN4Fcc
        F7aQyqbob9fGgR0ZtYDiR2Vh6Ht3bPju89v8XTdWjI4U89JQ8bv2gIdeFrLuVrY6mnIJ+S3KfK1R5
        jKUWwBxJ7UOhG926UyfU9NidFtiFmJEyJSpEPy0fo1x6UQ70clyvRKbRJiJEp83ZWN5oGQN5YEz5J
        lPDX7YZ+Z12cnPLOrI+WAZGbGihxRYwibgiEun2Mn0sEW8flSOFwKia9WPO71cwuDw49Aexsd4xx6
        Ja0OD8VkfGumzaGlfZVXULe3kGJl2ca6YMC6EuxF12qWACtaZF8rbFyCn1v6u3Sq/AiD12KKYxY5A
        5QzduxmtaqOnYRqh4G3EAF3/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaQ-00061e-0N; Mon, 24 Feb 2020 13:15:50 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 03/13] cifs: make use of cap_unix(ses) in cifs_reconnect_tcon()
Date:   Mon, 24 Feb 2020 14:15:00 +0100
Message-Id: <20200224131510.20608-4-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cap_unix(ses) defaults to false for SMB2.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 01206e12975a..d2b92770384b 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -320,7 +320,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	atomic_inc(&tconInfoReconnectCount);
 
 	/* tell server Unix caps we support */
-	if (ses->capabilities & CAP_UNIX)
+	if (cap_unix(ses))
 		reset_cifs_unix_caps(0, tcon, NULL, NULL);
 
 	/*
-- 
2.17.1


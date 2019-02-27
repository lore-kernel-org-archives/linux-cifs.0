Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34165C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 22:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA3762133D
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 22:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kragniz.eu header.i=@kragniz.eu header.b="gM3M7+Qd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfB0W0t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 17:26:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39348 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbfB0W0t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 17:26:49 -0500
Received: by mail-wr1-f67.google.com with SMTP id l5so19784887wrw.6
        for <linux-cifs@vger.kernel.org>; Wed, 27 Feb 2019 14:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kragniz.eu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HFQymW7lkonBYtHk5p1grH/aoc0bHXbbxA997+Pc4mU=;
        b=gM3M7+QdfSbXP9eSSvqY2GHxg7Vp7IWad4eolQYU6er+8nvFxtRej96mVNIES8NcYe
         arsQp6VGR7fx0d5EASAvp+t8huIDkG0iDQQvGTOMQNQ2aOLzuv4yv3esfM0UYxbCzSUj
         9uCrHdcGE0os5lRTSkstzOLHg//EJHyEMcHW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HFQymW7lkonBYtHk5p1grH/aoc0bHXbbxA997+Pc4mU=;
        b=H5s9U2NzVCHxTxeZpEhNW+HWLk7WhweqrtYZu/dRPP6QgOdLgkdUqv1SK0BlOmFaav
         sfIqO44SdTKAde+U42ECT41vpjBHQmaex7AMCfX7/3eJ1z7yqURwB7NCYys1DrQVoj9r
         H/uqktwXtUOWVe9CSTvlJlNsYST/IawWQzzBdpoSUARjA8fgHA/qDjgIIbj/oSjqiYSF
         29/qZS6FSIBypJtkaZqRz6wC34T6elKKDfg0GPbg2jBvPCitttVjymVn4+nYLVtMizUh
         UdiXdlJhw4T1uze4N6qnu4sTZM7S0j17P4ydWGeKPrMS8DhggnarDZhbT1dneOqdOiMG
         qNxA==
X-Gm-Message-State: APjAAAXvYHK5Z8jtRO6HtIRdcBK+VvPUnZ0/tdFXaiaphSujkl7fKr+2
        5laJ4ABClmdh20xTYoSPmAu2+A==
X-Google-Smtp-Source: APXvYqy/9NZly/kPOg9/HXRX5bFLD/QiNnGPPyR8OIFJhggqChma44Ld7+YGIcfEanamfu5ZNS7PXw==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr3900764wrx.43.1551306407520;
        Wed, 27 Feb 2019 14:26:47 -0800 (PST)
Received: from localhost.localdomain ([95.149.160.3])
        by smtp.gmail.com with ESMTPSA id j5sm22572026wrw.59.2019.02.27.14.26.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 14:26:46 -0800 (PST)
From:   Louis Taylor <louis@kragniz.eu>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        ndesaulniers@google.com, jflat@chromium.org,
        Louis Taylor <louis@kragniz.eu>
Subject: [PATCH v2] cifs: use correct format characters
Date:   Wed, 27 Feb 2019 22:25:15 +0000
Message-Id: <20190227222515.32579-1-louis@kragniz.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190227202202.21817-1-louis@kragniz.eu>
References: <20190227202202.21817-1-louis@kragniz.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When compiling with -Wformat, clang emits the following warnings:

fs/cifs/smb1ops.c:312:20: warning: format specifies type 'unsigned
short' but the argument has type 'unsigned int' [-Wformat]
                         tgt_total_cnt, total_in_tgt);
                                        ^~~~~~~~~~~~

fs/cifs/cifs_dfs_ref.c:289:4: warning: format specifies type 'short'
but the argument has type 'int' [-Wformat]
                 ref->flags, ref->server_type);
                 ^~~~~~~~~~

fs/cifs/cifs_dfs_ref.c:289:16: warning: format specifies type 'short'
but the argument has type 'int' [-Wformat]
                 ref->flags, ref->server_type);
                             ^~~~~~~~~~~~~~~~

fs/cifs/cifs_dfs_ref.c:291:4: warning: format specifies type 'short'
but the argument has type 'int' [-Wformat]
                 ref->ref_flag, ref->path_consumed);
                 ^~~~~~~~~~~~~

fs/cifs/cifs_dfs_ref.c:291:19: warning: format specifies type 'short'
but the argument has type 'int' [-Wformat]
                 ref->ref_flag, ref->path_consumed);
                                ^~~~~~~~~~~~~~~~~~
The types of these arguments are unconditionally defined, so this patch
updates the format character to the correct ones for ints and unsigned
ints.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Louis Taylor <louis@kragniz.eu>
---
 fs/cifs/cifs_dfs_ref.c | 4 ++--
 fs/cifs/smb1ops.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index d9b99abe1243..5d83c924cc47 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -285,9 +285,9 @@ static void dump_referral(const struct dfs_info3_param *ref)
 {
 	cifs_dbg(FYI, "DFS: ref path: %s\n", ref->path_name);
 	cifs_dbg(FYI, "DFS: node path: %s\n", ref->node_name);
-	cifs_dbg(FYI, "DFS: fl: %hd, srv_type: %hd\n",
+	cifs_dbg(FYI, "DFS: fl: %d, srv_type: %d\n",
 		 ref->flags, ref->server_type);
-	cifs_dbg(FYI, "DFS: ref_flags: %hd, path_consumed: %hd\n",
+	cifs_dbg(FYI, "DFS: ref_flags: %d, path_consumed: %d\n",
 		 ref->ref_flag, ref->path_consumed);
 }
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 32a6c020478f..20a88776f04d 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -308,7 +308,7 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	remaining = tgt_total_cnt - total_in_tgt;
 
 	if (remaining < 0) {
-		cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%hu\n",
+		cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%u\n",
 			 tgt_total_cnt, total_in_tgt);
 		return -EPROTO;
 	}
-- 
2.20.1


Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55375C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 20:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0719A213A2
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 20:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kragniz.eu header.i=@kragniz.eu header.b="Cp+6Gg4b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfB0UXQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 15:23:16 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36169 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729825AbfB0UXQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 15:23:16 -0500
Received: by mail-wm1-f68.google.com with SMTP id j125so6826828wmj.1
        for <linux-cifs@vger.kernel.org>; Wed, 27 Feb 2019 12:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kragniz.eu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y/dFnjmZuAw52ZSUBR0cfm9daDVyd21tpaBzQADzF3o=;
        b=Cp+6Gg4beyy05cml1Tcl7Shw+1yemr6FtHi7j/h9VTIOBuIzG2EskP6mYaqoQ4HrLl
         GuVllxIiK+C6ZgczpCMnEosiKvdIt9TOyYFDSId1g3AEj/N/Wa3PqbNPGParfAfO2/82
         iCNtfsDTYtJEou6lgkzYXLb6crcylb8fj2ANY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y/dFnjmZuAw52ZSUBR0cfm9daDVyd21tpaBzQADzF3o=;
        b=Wnthx/7ou60ILaMQMK0n9JQWsWhrlfEE6dcp1hrsw0JkHoPyrRAOU8Cs+QCmT+vv4H
         3+GB+zujBr3GUycv3S/BnoVrQt6pJCWOOgTQmvumF7yhq2K/xTGv0UYOMmwKjScARQQq
         JE1IHUrF57qw8S4QCBLJOx0wUkCxng1kv7Ae9P0EDuWxbGDkFpmqpuxN1Z+GDBDJeSi3
         GIy8LQ+Wk21fJH3+U/4VAOZfLevUT3P0hK+1yfuRD+Dy5byyi0bq31U2kTgSkWXCs3c6
         LZB+vjq0jAOyDHIrJ7keipAvXRS6xfJIgx1kyALY7bTVAhQzOQNvjj/vioIBf6EgauPH
         7/IA==
X-Gm-Message-State: AHQUAubYF8H1Qs+eoyZ1VAjuWivoU3ytrmk1Iax5oDTUI0yqOZ4/c23N
        qxKoWpF8Dc5dWErrVn6QoaaSLQ==
X-Google-Smtp-Source: APXvYqwvSnLjAZKuNeeLhw+Nrt423DtAoWsh8GqG3xBNDXMXJst6IDY+qZ+h3xCrnoft1m4rytU3SQ==
X-Received: by 2002:a1c:2d4c:: with SMTP id t73mr652575wmt.142.1551298993748;
        Wed, 27 Feb 2019 12:23:13 -0800 (PST)
Received: from localhost.localdomain ([95.149.160.3])
        by smtp.gmail.com with ESMTPSA id x24sm4495180wmi.5.2019.02.27.12.23.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 12:23:13 -0800 (PST)
From:   Louis Taylor <louis@kragniz.eu>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        ndesaulniers@google.com, jflat@chromium.org,
        Louis Taylor <louis@kragniz.eu>
Subject: [PATCH] cifs: use correct format characters
Date:   Wed, 27 Feb 2019 20:22:02 +0000
Message-Id: <20190227202202.21817-1-louis@kragniz.eu>
X-Mailer: git-send-email 2.20.1
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
 fs/cifs/smb1ops.c      | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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
index 32a6c020478f..52e1ae6744de 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -300,7 +300,7 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
 
 	if (tgt_total_cnt != src_total_cnt)
-		cifs_dbg(FYI, "total data count of primary and secondary t2 differ source=%hu target=%hu\n",
+		cifs_dbg(FYI, "total data count of primary and secondary t2 differ source=%hu target=%u\n",
 			 src_total_cnt, tgt_total_cnt);
 
 	total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
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


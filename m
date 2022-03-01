Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA693C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 11:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiCALB1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiCALB1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 06:01:27 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31328C7D4
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 03:00:44 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id r133so30025wma.2
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 03:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WYXSGsBd6JR2rrUNdraJ4rFPHq4RYe7ALp/R/m+51Rg=;
        b=YaSIMbefWtsAn6tvrOH03VF3vMxVkT9DrjoF58kWURFIxqV0f2nYc3eIIAIMO6yIZJ
         dwBZ3Ok82nsr98D2bEP/dVnMUiwsDSTD0cLYNyUhHbnkhyLOEkZpo7THEYJGToebKKTs
         vYVvfv3zajL4mmIbnegtK8OVNfajMGnSSSjKEvsmHN17her4Q7WZTQDucwy+jcc3FlLw
         WI2g0ZLJYyr8Lbpemk6lsilD/ixZKGbBq1gRlPii6fbvmmhlAibgkxcnhyaK5/SEMp0G
         2tQ4x9OtSeZIK8ZqLXlPgX5Tu/SpjKmaF7mf5Mt0RxhM2Ycvd8KTvYl2ocBbT9b53hjF
         N/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WYXSGsBd6JR2rrUNdraJ4rFPHq4RYe7ALp/R/m+51Rg=;
        b=M2OtbSStv6Z58MyLy6IRMSh1ZLbU8AAWiw6xeL523AYIaoT8hKDMtitJpGoJnzyxmd
         LH0HERIvVEH30+cxvDt+RfqYL0L1j+NgWaDjeFiLU65WH2i/5SxOmvBGr3dlT8Mu4hQK
         FGDJ2HDYTUG3J0clqvpnkmgF6Ap6cHkQnn8375SoyEanPEHaS0/8sBnjtb2piU8rfY8d
         ZvS2o/zpCbZoOm4dPCaqDxEVSbsi4NIQLN5IZ4ISHm+GYrxbswK5VmtTN8Xb5WYKw+E3
         pRnmwAM386Jnn4GBaaperzwIN1dDJwhvD6hOSU25C7TKjsxSsRdsY5PjFeLCVdOqYD1k
         rFZg==
X-Gm-Message-State: AOAM531ATMzVuVl50GmZKmLEDk86UHe9fvd3vbw6ysAtnc+wK45tgBl4
        zxFLNY9LFb6YPWKCRqqDueUW9KC9cOV3Cw==
X-Google-Smtp-Source: ABdhPJzKvmzQ1ukUCvAjVnl6MD8exWNKtA2TQwVynmmpHUZ0BtYJyijR9WFYgxM0bJ+ZfJ8Mbw3b1g==
X-Received: by 2002:a05:600c:4a02:b0:380:deae:2c2d with SMTP id c2-20020a05600c4a0200b00380deae2c2dmr16520739wmp.133.1646132443257;
        Tue, 01 Mar 2022 03:00:43 -0800 (PST)
Received: from marios-t5500.iliad.local ([2a01:e0a:0:22a0:fa5e:e68e:157b:df1d])
        by smtp.gmail.com with ESMTPSA id m6-20020a5d56c6000000b001edb64e69cdsm13306904wrw.15.2022.03.01.03.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:00:42 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH 1/4] ksmbd-tools: Fix function name typo
Date:   Tue,  1 Mar 2022 12:00:04 +0100
Message-Id: <20220301110006.4033351-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename ndr_*_uniq_vsting_ptr to ndr_*_uniq_vstring_ptr.

No functional change.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 include/rpc.h       | 4 ++--
 mountd/rpc.c        | 4 ++--
 mountd/rpc_lsarpc.c | 2 +-
 mountd/rpc_samr.c   | 6 +++---
 mountd/rpc_srvsvc.c | 4 ++--
 mountd/rpc_wkssvc.c | 4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/rpc.h b/include/rpc.h
index 6d6b8bdc127c..63d79bc724c8 100644
--- a/include/rpc.h
+++ b/include/rpc.h
@@ -319,10 +319,10 @@ int ndr_write_string(struct ksmbd_dcerpc *dce, char *str);
 int ndr_write_lsa_string(struct ksmbd_dcerpc *dce, char *str);
 char *ndr_read_vstring(struct ksmbd_dcerpc *dce);
 void ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr *ctr);
-void ndr_read_uniq_vsting_ptr(struct ksmbd_dcerpc *dce,
+void ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
 			      struct ndr_uniq_char_ptr *ctr);
 void ndr_free_vstring_ptr(struct ndr_char_ptr *ctr);
-void ndr_free_uniq_vsting_ptr(struct ndr_uniq_char_ptr *ctr);
+void ndr_free_uniq_vstring_ptr(struct ndr_uniq_char_ptr *ctr);
 void ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr);
 void ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ctr);
 int __ndr_write_array_of_structs(struct ksmbd_rpc_pipe *pipe, int max_entry_nr);
diff --git a/mountd/rpc.c b/mountd/rpc.c
index 2361634f1a55..4db422abe9b0 100644
--- a/mountd/rpc.c
+++ b/mountd/rpc.c
@@ -540,7 +540,7 @@ void ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr *ctr)
 	ctr->ptr = ndr_read_vstring(dce);
 }
 
-void ndr_read_uniq_vsting_ptr(struct ksmbd_dcerpc *dce,
+void ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
 			      struct ndr_uniq_char_ptr *ctr)
 {
 	ctr->ref_id = ndr_read_int32(dce);
@@ -557,7 +557,7 @@ void ndr_free_vstring_ptr(struct ndr_char_ptr *ctr)
 	ctr->ptr = NULL;
 }
 
-void ndr_free_uniq_vsting_ptr(struct ndr_uniq_char_ptr *ctr)
+void ndr_free_uniq_vstring_ptr(struct ndr_uniq_char_ptr *ctr)
 {
 	ctr->ref_id = 0;
 	free(ctr->ptr);
diff --git a/mountd/rpc_lsarpc.c b/mountd/rpc_lsarpc.c
index 5caf4d9ef3ac..cc99a147b239 100644
--- a/mountd/rpc_lsarpc.c
+++ b/mountd/rpc_lsarpc.c
@@ -350,7 +350,7 @@ static int lsarpc_lookup_names3_invoke(struct ksmbd_rpc_pipe *pipe)
 			break;
 		ndr_read_int16(dce); // length
 		ndr_read_int16(dce); // size
-		ndr_read_uniq_vsting_ptr(dce, &username);
+		ndr_read_uniq_vstring_ptr(dce, &username);
 		if (strstr(STR_VAL(username), "\\")) {
 			strtok(STR_VAL(username), "\\");
 			name = strtok(NULL, "\\");
diff --git a/mountd/rpc_samr.c b/mountd/rpc_samr.c
index 7fe942cf3f08..6425215f6d34 100644
--- a/mountd/rpc_samr.c
+++ b/mountd/rpc_samr.c
@@ -84,7 +84,7 @@ static int samr_connect5_invoke(struct ksmbd_rpc_pipe *pipe)
 	struct ksmbd_dcerpc *dce = pipe->dce;
 	struct ndr_uniq_char_ptr server_name;
 
-	ndr_read_uniq_vsting_ptr(dce, &server_name);
+	ndr_read_uniq_vstring_ptr(dce, &server_name);
 	ndr_read_int32(dce); // Access mask
 	dce->sm_req.level = ndr_read_int32(dce); // level in
 	ndr_read_int32(dce); // Info in
@@ -184,7 +184,7 @@ static int samr_lookup_domain_invoke(struct ksmbd_rpc_pipe *pipe)
 	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
 	ndr_read_int16(dce); // name len
 	ndr_read_int16(dce); // name size
-	ndr_read_uniq_vsting_ptr(dce, &dce->sm_req.name); // domain name
+	ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name); // domain name
 
 	return KSMBD_RPC_OK;
 }
@@ -254,7 +254,7 @@ static int samr_lookup_names_invoke(struct ksmbd_rpc_pipe *pipe)
 	ndr_read_int16(dce); // name len
 	ndr_read_int16(dce); // name size
 
-	ndr_read_uniq_vsting_ptr(dce, &dce->sm_req.name); // names
+	ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name); // names
 
 	return KSMBD_RPC_OK;
 }
diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
index f3b4d069031a..7e9fa675d34a 100644
--- a/mountd/rpc_srvsvc.c
+++ b/mountd/rpc_srvsvc.c
@@ -272,7 +272,7 @@ static int srvsvc_share_get_info_return(struct ksmbd_rpc_pipe *pipe)
 static int srvsvc_parse_share_info_req(struct ksmbd_dcerpc *dce,
 				       struct srvsvc_share_info_request *hdr)
 {
-	ndr_read_uniq_vsting_ptr(dce, &hdr->server_name);
+	ndr_read_uniq_vstring_ptr(dce, &hdr->server_name);
 
 	if (dce->req_hdr.opnum == SRVSVC_OPNUM_SHARE_ENUM_ALL) {
 		int ptr;
@@ -330,7 +330,7 @@ static int srvsvc_clear_headers(struct ksmbd_rpc_pipe *pipe,
 	if (status == KSMBD_RPC_EMORE_DATA)
 		return 0;
 
-	ndr_free_uniq_vsting_ptr(&pipe->dce->si_req.server_name);
+	ndr_free_uniq_vstring_ptr(&pipe->dce->si_req.server_name);
 	if (pipe->dce->req_hdr.opnum == SRVSVC_OPNUM_GET_SHARE_INFO)
 		ndr_free_vstring_ptr(&pipe->dce->si_req.share_name);
 
diff --git a/mountd/rpc_wkssvc.c b/mountd/rpc_wkssvc.c
index 32b7893eb2c6..ba7f9a841e3d 100644
--- a/mountd/rpc_wkssvc.c
+++ b/mountd/rpc_wkssvc.c
@@ -31,7 +31,7 @@
 static int wkssvc_clear_headers(struct ksmbd_rpc_pipe *pipe,
 				int status)
 {
-	ndr_free_uniq_vsting_ptr(&pipe->dce->wi_req.server_name);
+	ndr_free_uniq_vstring_ptr(&pipe->dce->wi_req.server_name);
 	return 0;
 }
 
@@ -141,7 +141,7 @@ static int
 wkssvc_parse_netwksta_info_req(struct ksmbd_dcerpc *dce,
 			       struct wkssvc_netwksta_info_request *hdr)
 {
-	ndr_read_uniq_vsting_ptr(dce, &hdr->server_name);
+	ndr_read_uniq_vstring_ptr(dce, &hdr->server_name);
 	hdr->level = ndr_read_int32(dce);
 	return 0;
 }
-- 
2.25.1


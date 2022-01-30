Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3AFC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Jan 2022 09:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354323AbiA3JfH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Jan 2022 04:35:07 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:50827 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiA3JfF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 Jan 2022 04:35:05 -0500
Received: by mail-pj1-f48.google.com with SMTP id o11so10829322pjf.0
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 01:35:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mreh1xcakx/Ki8oc8LKYbi6a4wCQOW17xUOm8jgz59w=;
        b=0DJjlNxVqG9EMYSXfL9qKRt/vCiGqFg0tldHMpvQfCShYFGGQMwn7HgbncCptczl8R
         5oNagAnhU1QtTtCRxRDezNkwJrd/JGP61s7eXrZ6Dz3rJZDM7aZ45FIzFTCpivKfRQ9K
         An7L09NLppNGOckBFrOKfooibNbhRKqp+r4yjYxic0ChRGf4ZFJpQakBnKFhVMJaqWsm
         x8XRzEQam+b2PoHVpwYmLTSWxVX6VOwAe5fixaOtbUF1IGhe9ywEigb4XO9XBjyoELj7
         EC/qNVEoOX64c83LaBsEfZmv3UyyhFPHSNG/+l21DIxlHAWBih3gFmowBaQAU2DarFPr
         CO+A==
X-Gm-Message-State: AOAM533ZXbGxMGT2BAp9MwpVuptSCiY/dZI/wNvcKhJwqkymrJ/Yc5ca
        Mb4mZD+LqWicJaAt7dVgUOtGalh/eCk=
X-Google-Smtp-Source: ABdhPJzzTQwf1ip6ijdvpQhPL9XbCenTluqjoX2LHsyH/3ZD4rqBQnAH0kW7m6sa+GZAAx7CTaOa8Q==
X-Received: by 2002:a17:902:e541:: with SMTP id n1mr15892199plf.108.1643535305323;
        Sun, 30 Jan 2022 01:35:05 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id l22sm14991798pfc.191.2022.01.30.01.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 01:35:05 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: don't align last entry offset in smb2 query directory
Date:   Sun, 30 Jan 2022 18:34:33 +0900
Message-Id: <20220130093433.8319-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220130093433.8319-1-linkinjeon@kernel.org>
References: <20220130093433.8319-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When checking smb2 query directory packets from other servers,
OutputBufferLength is different with ksmbd. Other servers add an unaligned
next offset to OutputBufferLength for the last entry.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 7 ++++---
 fs/ksmbd/vfs.h     | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 6806994383d9..67e8e28e3fc3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3422,9 +3422,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		goto free_conv_name;
 	}
 
-	struct_sz = readdir_info_level_struct_sz(info_level);
-	next_entry_offset = ALIGN(struct_sz - 1 + conv_len,
-				  KSMBD_DIR_INFO_ALIGNMENT);
+	struct_sz = readdir_info_level_struct_sz(info_level) - 1 + conv_len;
+	next_entry_offset = ALIGN(struct_sz, KSMBD_DIR_INFO_ALIGNMENT);
+	d_info->last_entry_off_align = next_entry_offset - struct_sz;
 
 	if (next_entry_offset > d_info->out_buf_len) {
 		d_info->out_buf_len = 0;
@@ -3976,6 +3976,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 		((struct file_directory_info *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
+		d_info.data_count -= d_info.last_entry_off_align;
 
 		rsp->StructureSize = cpu_to_le16(9);
 		rsp->OutputBufferOffset = cpu_to_le16(72);
diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
index adf94a4f22fa..8c37aaf936ab 100644
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -47,6 +47,7 @@ struct ksmbd_dir_info {
 	int		last_entry_offset;
 	bool		hide_dot_file;
 	int		flags;
+	int		last_entry_off_align;
 };
 
 struct ksmbd_readdir_data {
-- 
2.25.1


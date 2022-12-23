Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8EFC4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Dec 2022 10:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLWK7x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Dec 2022 05:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLWK7w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Dec 2022 05:59:52 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209DA389FB
        for <linux-cifs@vger.kernel.org>; Fri, 23 Dec 2022 02:59:51 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso3293765wmo.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Dec 2022 02:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoXvp33psGYtXMiqsoSNoafVmD/Bcn57gXLNXDWPr/U=;
        b=dadBh011qGbolT4XAuF/LUFkCfWVmwjz0KMSOhix7Lm4JnNzvqBIeLgELerplLnoky
         friqVZWotKWavAspzno/OFrkqPPmrvJUZneHqusUsy/cNvrfpiSBGEZlpk9AtH0sVgMy
         Qz1cFal85Fa/3UMakehpjDK0FGx4pcYd/rXrMiR+Mcm77ZWMZQRcDS53sABMDUxBnxUg
         t3DnCBX/jOOrswnkUkxGI9xCz8GI+/GVdG28i1XHGxdbmwL8cn+dSgCBTTd0B9lVpe6S
         iHtnTxW8k8pz0NPlhWj2//8QVMWPjFlYfumrIOZM1KgKrhfqGqKkPtkDXaQE2xxi4zFq
         fs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qoXvp33psGYtXMiqsoSNoafVmD/Bcn57gXLNXDWPr/U=;
        b=nVilNxtZqoe2X51LOAt65E5o3Tu2zSOr4nctHxBJQ9+TkznVG9quK+8LF7mdC5iXTR
         8AfEBg9WMD+GuB1IarFjLZCle8Ko2lfKWAx1SHMSMlre1MhkatlboBVr0F2W8at4tq64
         INiD6n5nhzIIXw3OoAmlaQ5zxuC1rM9gK0PZdvwZ0BWIxhSXjfTEcIrJrYW+Vy83D63g
         agUtyrB5C2P99qQP8+T9x556UyrdtOYqfK4yxNbzZxWq1Bmzsec9Gdj1ibsrmDS83sAN
         V/yMV9Rep0lw+92P/n/rPw/0agEIWc4hVbiz8+aogqLzgr4cRUo+PFcAePbzpwhJNNti
         ZCYg==
X-Gm-Message-State: AFqh2kriBbSkh+7kFv/r0Cx048XD/Qkm3dKOgVQft5cOeSz4l1+oF/FE
        hPtoTVBKTZJIh4Fn1ziD6vF//tki/Nr7H0Dl
X-Google-Smtp-Source: AMrXdXuXb0vI6odKkOnvmESLrzLBzvb3zH5aH6W2i81y8XYIpftnGA9iFbdmlpcjdkKFXItilK0K3Q==
X-Received: by 2002:a7b:c4da:0:b0:3d3:864a:1173 with SMTP id g26-20020a7bc4da000000b003d3864a1173mr6712255wmk.18.1671793189451;
        Fri, 23 Dec 2022 02:59:49 -0800 (PST)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id k1-20020a5d5181000000b0024207478de3sm2791652wrv.93.2022.12.23.02.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 02:59:49 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH v2] ksmbd: send proper error response in smb2_tree_connect()
Date:   Fri, 23 Dec 2022 11:59:31 +0100
Message-Id: <20221223105930.1405307-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221222104701.717586-1-mmakassikis@freebox.fr>
References: <20221222104701.717586-1-mmakassikis@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently, smb2_tree_connect doesn't send an error response packet on
error.

This causes libsmb2 to skip the specific error code and fail with the
following:
 smb2_service failed with : Failed to parse fixed part of command
 payload. Unexpected size of Error reply. Expected 9, got 8

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
v2:
 move smb2_set_err_rsp() call to the end to simplify, as suggested by Namjae

 fs/ksmbd/smb2pdu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 14d7f3599c63..38fbda52e06f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1928,13 +1928,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (conn->posix_ext_supported)
 		status.tree_conn->posix_extensions = true;
 
-out_err1:
 	rsp->StructureSize = cpu_to_le16(16);
+	inc_rfc1001_len(work->response_buf, 16);
+out_err1:
 	rsp->Capabilities = 0;
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
-	inc_rfc1001_len(work->response_buf, 16);
 
 	if (!IS_ERR(treename))
 		kfree(treename);
@@ -1967,6 +1967,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_ACCESS_DENIED;
 	}
 
+	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+		smb2_set_err_rsp(work);
+
 	return rc;
 }
 
-- 
2.25.1


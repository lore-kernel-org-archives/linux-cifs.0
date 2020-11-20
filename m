Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11658C63798
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Nov 2020 18:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC78D2224C
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Nov 2020 18:24:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tp6nVUnU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgKTSYJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728922AbgKTSYJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 20 Nov 2020 13:24:09 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D601522470;
        Fri, 20 Nov 2020 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896648;
        bh=mpyL3M3UHNmTHw6jtbMYJ6Ta7FfLT/3asKhrb85KYKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tp6nVUnU9ZE7vxSUtNncsyNB8EdK2O7k1xJmjRvoGDu0yzy6R8Wj8J0L7Dtcc5cYY
         ESDCBj9x6O+saLjWGOOK/ERuJq9fK8z92CJPXmGz8fxhMbYdXCOcTtV4SYnhlsyH/V
         M4dqv0OlXAJnYHjASpYL9EiPuppe8VCb5b2IKUWI=
Date:   Fri, 20 Nov 2020 12:24:14 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 003/141] cifs: Fix fall-through warnings for Clang
Message-ID: <8a35ff7132f95e24f6d9501e1bec644854fc5078.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break/goto statements instead of
just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/cifs/inode.c     | 1 +
 fs/cifs/sess.c      | 1 +
 fs/cifs/smbdirect.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9ee5f304592f..ac01f9684b39 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -771,6 +771,7 @@ cifs_get_file_info(struct file *filp)
 		 */
 		rc = 0;
 		CIFS_I(inode)->time = 0;
+		goto cgfi_exit;
 	default:
 		goto cgfi_exit;
 	}
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index de564368a887..6c2c42f8d893 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -812,6 +812,7 @@ cifs_select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
 				return NTLMv2;
 			if (global_secflags & CIFSSEC_MAY_NTLM)
 				return NTLM;
+			break;
 		default:
 			break;
 		}
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b029ed31ef91..10dfe5006792 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -246,6 +246,7 @@ smbd_qp_async_error_upcall(struct ib_event *event, void *context)
 	case IB_EVENT_CQ_ERR:
 	case IB_EVENT_QP_FATAL:
 		smbd_disconnect_rdma_connection(info);
+		break;
 
 	default:
 		break;
-- 
2.27.0


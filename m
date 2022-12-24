Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822FEC3DA7C
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Dec 2022 01:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbiLXBge (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Dec 2022 20:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiLXBgE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Dec 2022 20:36:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181464DE6B;
        Fri, 23 Dec 2022 17:32:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB040B8219D;
        Sat, 24 Dec 2022 01:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FFBC433F0;
        Sat, 24 Dec 2022 01:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845517;
        bh=zXeIEdGsPt+Rd8CctHFIqXp9zpSxzNDtFBNAJY1pjLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIRU96JCiMFWx2Q5V1Pzb33yEH1AxFe80ZDjuUyhKfLfI8rYorwptci+egp9Ihoio
         ZztQngDDQyr/PpmuJ6iswOAs2SRd2fmlzditrmpmHp3F/LyxuYNkYSgBX9F2sJzOFf
         EQTYhtzFj/MEqXOz+Syv82ze4y24E3ZfpnR85suowKC5+8y9BVMCgMCKPShBxPQIb9
         YlW6Jzd+/S+AKJFlRWtnW/gcVguCnDJ0PYsyz33mltsSS/zPH77SwEW14bpsvxjnDN
         Fl0Z7N/VatnP1gf2rngjB8+dBAbTXAdI3dHD9lVdjpChsZGNDkCTOO99rYf9fGbGDh
         eO1yqZoDAu1SQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/14] ksmbd: Fix resource leak in smb2_lock()
Date:   Fri, 23 Dec 2022 20:31:24 -0500
Message-Id: <20221224013127.393187-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013127.393187-1-sashal@kernel.org>
References: <20221224013127.393187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 01f6c61bae3d658058ee6322af77acea26a5ee3a ]

"flock" is leaked if an error happens before smb2_lock_init(), as the
lock is not added to the lock_list to be cleaned up.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 65c85ca71ebe..4596f8efbf5f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6818,6 +6818,7 @@ int smb2_lock(struct ksmbd_work *work)
 		if (lock_start > U64_MAX - lock_length) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6837,6 +6838,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
 				    flock->fl_end, flock->fl_start);
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6848,6 +6850,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    flock->fl_type != F_UNLCK) {
 					pr_err("conflict two locks in one request\n");
 					err = -EINVAL;
+					locks_free_lock(flock);
 					goto out;
 				}
 			}
@@ -6856,6 +6859,7 @@ int smb2_lock(struct ksmbd_work *work)
 		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
+			locks_free_lock(flock);
 			goto out;
 		}
 	}
-- 
2.35.1


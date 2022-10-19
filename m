Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95524C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Oct 2022 14:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJSOku (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Oct 2022 10:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJSOkT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Oct 2022 10:40:19 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D266F159D74
        for <linux-cifs@vger.kernel.org>; Wed, 19 Oct 2022 07:25:04 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 32AC87FD02;
        Wed, 19 Oct 2022 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1666189485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g9wLAVoklBj+85WHheG+RGjlb68aVHKVLKPiLHGQ9cA=;
        b=eSsZVTbswiQVORviSb6Yfgc+Wffyob+XCix2554aqMdVNzYI1w2Zuj0WHErhlG6RWpN9E4
        r6puNhHYwzOlM9baKWfaVkG6unHHAxEXL6RhwK5kmdiHj6v7aRwIzAhNL6l8ErtG5j/plZ
        zHxiSg5ruEuoklT1XRJE7xHTtbcbAE8WjnXbXbJb4uwH0NH1RGSlUmfBweUV4dGSF7jHCh
        wn2Fe/imYUM9qdYFNcSaOW0NWkHeVjYEjJai7YPQ0WCHipbkP/xWrhBk42HTGr8pAqzpGk
        En0vRiwkdoVlf/V5VlUNlzum+3QMC5sMsXjTlg4f+n+kxU9DKHFu0kd9RZLczw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: fix memory leaks in session setup
Date:   Wed, 19 Oct 2022 11:25:37 -0300
Message-Id: <20221019142537.23718-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We were only zeroing out the ntlmssp blob but forgot to free the
allocated buffer in the end of SMB2_sess_auth_rawntlmssp_negotiate()
and SMB2_sess_auth_rawntlmssp_authenticate() functions.

This fixes below kmemleak reports:

unreferenced object 0xffff88800ddcfc60 (size 96):
  comm "mount.cifs", pid 758, jiffies 4294696066 (age 42.967s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d0beeb29>] __kmalloc+0x39/0xa0
    [<00000000e3834047>] build_ntlmssp_smb3_negotiate_blob+0x2c/0x110 [cifs]
    [<00000000e85f5ab2>] SMB2_sess_auth_rawntlmssp_negotiate+0xd3/0x230 [cifs]
    [<0000000080fdb897>] SMB2_sess_setup+0x16c/0x2a0 [cifs]
    [<000000009af320a8>] cifs_setup_session+0x13b/0x370 [cifs]
    [<00000000f15d5982>] cifs_get_smb_ses+0x643/0xb90 [cifs]
    [<00000000fe15eb90>] mount_get_conns+0x63/0x3e0 [cifs]
    [<00000000768aba03>] mount_get_dfs_conns+0x16/0xa0 [cifs]
    [<00000000cf1cf146>] cifs_mount+0x1c2/0x9a0 [cifs]
    [<000000000d66b51e>] cifs_smb3_do_mount+0x10e/0x710 [cifs]
    [<0000000077a996c5>] smb3_get_tree+0xf4/0x200 [cifs]
    [<0000000094dbd041>] vfs_get_tree+0x23/0xc0
    [<000000003a8561de>] path_mount+0x2d3/0xb50
    [<00000000ed5c86d6>] __x64_sys_mount+0x102/0x140
    [<00000000142142f3>] do_syscall_64+0x3b/0x90
    [<00000000e2b89731>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
unreferenced object 0xffff88801437f000 (size 512):
  comm "mount.cifs", pid 758, jiffies 4294696067 (age 42.970s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d0beeb29>] __kmalloc+0x39/0xa0
    [<00000000004f53d2>] build_ntlmssp_auth_blob+0x4f/0x340 [cifs]
    [<000000005f333084>] SMB2_sess_auth_rawntlmssp_authenticate+0xd4/0x250 [cifs]
    [<0000000080fdb897>] SMB2_sess_setup+0x16c/0x2a0 [cifs]
    [<000000009af320a8>] cifs_setup_session+0x13b/0x370 [cifs]
    [<00000000f15d5982>] cifs_get_smb_ses+0x643/0xb90 [cifs]
    [<00000000fe15eb90>] mount_get_conns+0x63/0x3e0 [cifs]
    [<00000000768aba03>] mount_get_dfs_conns+0x16/0xa0 [cifs]
    [<00000000cf1cf146>] cifs_mount+0x1c2/0x9a0 [cifs]
    [<000000000d66b51e>] cifs_smb3_do_mount+0x10e/0x710 [cifs]
    [<0000000077a996c5>] smb3_get_tree+0xf4/0x200 [cifs]
    [<0000000094dbd041>] vfs_get_tree+0x23/0xc0
    [<000000003a8561de>] path_mount+0x2d3/0xb50
    [<00000000ed5c86d6>] __x64_sys_mount+0x102/0x140
    [<00000000142142f3>] do_syscall_64+0x3b/0x90
    [<00000000e2b89731>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb2pdu.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c930b63bc422..a5695748a89b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1341,14 +1341,13 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 static void
 SMB2_sess_free_buffer(struct SMB2_sess_data *sess_data)
 {
-	int i;
+	struct kvec *iov = sess_data->iov;
 
-	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
-	for (i = 0; i < 2; i++)
-		if (sess_data->iov[i].iov_base)
-			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
+	/* iov[1] is already freed by caller */
+	if (sess_data->buf0_type != CIFS_NO_BUFFER && iov[0].iov_base)
+		memzero_explicit(iov[0].iov_base, iov[0].iov_len);
 
-	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
+	free_rsp_buf(sess_data->buf0_type, iov[0].iov_base);
 	sess_data->buf0_type = CIFS_NO_BUFFER;
 }
 
@@ -1578,7 +1577,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 	}
 
 out:
-	memzero_explicit(ntlmssp_blob, blob_length);
+	kfree_sensitive(ntlmssp_blob);
 	SMB2_sess_free_buffer(sess_data);
 	if (!rc) {
 		sess_data->result = 0;
@@ -1662,7 +1661,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 	}
 #endif
 out:
-	memzero_explicit(ntlmssp_blob, blob_length);
+	kfree_sensitive(ntlmssp_blob);
 	SMB2_sess_free_buffer(sess_data);
 	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
-- 
2.38.0


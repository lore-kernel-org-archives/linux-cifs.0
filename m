Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6F9C001DC
	for <linux-cifs@archiver.kernel.org>; Thu, 27 Jul 2023 19:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjG0TSz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbjG0TSw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 Jul 2023 15:18:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76812735
        for <linux-cifs@vger.kernel.org>; Thu, 27 Jul 2023 12:18:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4552F1F86C;
        Thu, 27 Jul 2023 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690485523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=K22gbBGYKqxSAlgDYxobBpk+NQn6DHAfbWs8cu3DbgM=;
        b=tbWXlG5ElMgzOCDxEoJKug8XJBgttbFLm0qwXbpIG6Z86vn+l8QyMULgJNlJAtbdyUPp/6
        xXK8CPxZ/GaYG7L6LrpqA1q131KZDo7yWh5ZlTwetY9zkEIvv0OKgdoc9msWdSL0MNeten
        4earTqaugnbJf/eWC2+8b32/hmEg4GE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690485523;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=K22gbBGYKqxSAlgDYxobBpk+NQn6DHAfbWs8cu3DbgM=;
        b=Nli0z31wGMG3qYpN7KGmWkEzfadpJRGRhkqqwJLsP0iLDZd0M8zTeXDU05sPLhRFFAJuUd
        d6dUsYQKWBz4vvDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB145138E5;
        Thu, 27 Jul 2023 19:18:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6W/gJBLDwmTXGgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 27 Jul 2023 19:18:42 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH] cifs: rename module to "smbfs.ko"
Date:   Thu, 27 Jul 2023 16:18:33 -0300
Message-Id: <20230727191833.5227-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change the kernel object name to "smbfs.ko".
Also create a MODULE_ALIAS_FS for "smbfs".

Keep "cifs" and "smb3" module aliases for compatibility with existing
scripts/tools.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---

Ideally (IMHO) we should:
1) have a single "smbfs" file_system_type struct, but that needs a respective
   patch in cifs-utils (I can send one if interested) and some time so such
   modification can get widespread adoption
2) rename Kconfig CONFIG_CIFS* as well
3) remove dependency on file system type/disable_legacy_dialects flag for SMB1
   abandonment and rely only on the build-time CONFIG_CIFS_ALLOW_INSECURE_LEGACY

Cheers,
Enzo

 fs/smb/client/Makefile | 20 ++++++++++----------
 fs/smb/client/cifsfs.c |  2 ++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 304a7f6cc13a..e78b8b4ad2ee 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -3,9 +3,9 @@
 # Makefile for Linux CIFS/SMB2/SMB3 VFS client
 #
 ccflags-y += -I$(src)		# needed for trace events
-obj-$(CONFIG_CIFS) += cifs.o
+obj-$(CONFIG_CIFS) += smbfs.o
 
-cifs-y := trace.o cifsfs.o cifs_debug.o connect.o dir.o file.o \
+smbfs-y := trace.o cifsfs.o cifs_debug.o connect.o dir.o file.o \
 	  inode.o link.o misc.o netmisc.o smbencrypt.o transport.o \
 	  cached_dir.o cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o unc.o winucase.o \
@@ -17,18 +17,18 @@ $(obj)/asn1.o: $(obj)/cifs_spnego_negtokeninit.asn1.h
 
 $(obj)/cifs_spnego_negtokeninit.asn1.o: $(obj)/cifs_spnego_negtokeninit.asn1.c $(obj)/cifs_spnego_negtokeninit.asn1.h
 
-cifs-$(CONFIG_CIFS_XATTR) += xattr.o
+smbfs-$(CONFIG_CIFS_XATTR) += xattr.o
 
-cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
+smbfs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 
-cifs-$(CONFIG_CIFS_DFS_UPCALL) += cifs_dfs_ref.o dfs_cache.o dfs.o
+smbfs-$(CONFIG_CIFS_DFS_UPCALL) += cifs_dfs_ref.o dfs_cache.o dfs.o
 
-cifs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o cifs_swn.o
+smbfs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o cifs_swn.o
 
-cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o
+smbfs-$(CONFIG_CIFS_FSCACHE) += fscache.o
 
-cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
+smbfs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
 
-cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
+smbfs-$(CONFIG_CIFS_ROOT) += cifsroot.o
 
-cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o
+smbfs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a4d8b0ea1c8c..b6f42a0ef9ee 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1109,6 +1109,8 @@ cifs_setlease(struct file *file, long arg, struct file_lock **lease, void **priv
 		return -EAGAIN;
 }
 
+MODULE_ALIAS_FS("smbfs");
+
 struct file_system_type cifs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "cifs",
-- 
2.35.3


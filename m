Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB793C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiCGBfG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbiCGBfF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:05 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAE813F0F
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:12 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2B3E9210ED;
        Mon,  7 Mar 2022 01:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ncawbqa6M80oHrUdZW7Y47IzHu+OPdxE6ab1dMvSiSE=;
        b=DaLscTU2plvV4I69PpCyyvldOjRU8iU1bxMYji1VLkST5pXIsbwBuOussDdmIMDacF0vBz
        rj8sjaYz0ja5K0Jqf2oxP35xdTVOZqRaQbseQyv20JNF35a30HemZg0wlkwX33akWhqgsd
        pY2uBx/NKNcd87Jun3TMrDQRewNp5iE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616851;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ncawbqa6M80oHrUdZW7Y47IzHu+OPdxE6ab1dMvSiSE=;
        b=rtsaFK4qPCqjjD6ksHY0VYGrbcEGEZ7qcv3hrdTljDWrfvkVFI5q0mxFkjEFQ684UegCY1
        cKAd3Smcso6rP/CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A69CE1340A;
        Mon,  7 Mar 2022 01:34:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id I37eGhJhJWISdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:10 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 1/9] ksmbd-tools: rename dirs to reflect new commands
Date:   Sun,  6 Mar 2022 22:33:36 -0300
Message-Id: <20220307013344.29064-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename directories to reflect command names, in preparation for binary
unification.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 Makefile.am                        | 2 +-
 configure.ac                       | 6 +++---
 {mountd => daemon}/Makefile.am     | 2 +-
 mountd/mountd.c => daemon/daemon.c | 0
 {mountd => daemon}/ipc.c           | 0
 {mountd => daemon}/rpc.c           | 0
 {mountd => daemon}/rpc_lsarpc.c    | 0
 {mountd => daemon}/rpc_samr.c      | 0
 {mountd => daemon}/rpc_srvsvc.c    | 0
 {mountd => daemon}/rpc_wkssvc.c    | 0
 {mountd => daemon}/smbacl.c        | 0
 {mountd => daemon}/worker.c        | 0
 {addshare => share}/Makefile.am    | 0
 {addshare => share}/addshare.c     | 0
 {addshare => share}/share_admin.c  | 0
 {addshare => share}/share_admin.h  | 0
 {adduser => user}/Makefile.am      | 0
 {adduser => user}/adduser.c        | 0
 {adduser => user}/md4_hash.c       | 0
 {adduser => user}/md4_hash.h       | 0
 {adduser => user}/user_admin.c     | 0
 {adduser => user}/user_admin.h     | 0
 22 files changed, 5 insertions(+), 5 deletions(-)
 rename {mountd => daemon}/Makefile.am (95%)
 rename mountd/mountd.c => daemon/daemon.c (100%)
 rename {mountd => daemon}/ipc.c (100%)
 rename {mountd => daemon}/rpc.c (100%)
 rename {mountd => daemon}/rpc_lsarpc.c (100%)
 rename {mountd => daemon}/rpc_samr.c (100%)
 rename {mountd => daemon}/rpc_srvsvc.c (100%)
 rename {mountd => daemon}/rpc_wkssvc.c (100%)
 rename {mountd => daemon}/smbacl.c (100%)
 rename {mountd => daemon}/worker.c (100%)
 rename {addshare => share}/Makefile.am (100%)
 rename {addshare => share}/addshare.c (100%)
 rename {addshare => share}/share_admin.c (100%)
 rename {addshare => share}/share_admin.h (100%)
 rename {adduser => user}/Makefile.am (100%)
 rename {adduser => user}/adduser.c (100%)
 rename {adduser => user}/md4_hash.c (100%)
 rename {adduser => user}/md4_hash.h (100%)
 rename {adduser => user}/user_admin.c (100%)
 rename {adduser => user}/user_admin.h (100%)

diff --git a/Makefile.am b/Makefile.am
index 00a6148ff29d..e3ee928691bf 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,7 +2,7 @@
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = lib mountd adduser addshare control
+SUBDIRS = lib daemon user share control
 
 # other stuff
 EXTRA_DIST =			\
diff --git a/configure.ac b/configure.ac
index 6aceade6ed01..1f107805325f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -62,9 +62,9 @@ AM_CONDITIONAL(HAVE_LIBKRB5, [test "$enable_krb5" != "no"])
 AC_CONFIG_FILES([
 	Makefile
 	lib/Makefile
-	mountd/Makefile
-	adduser/Makefile
-	addshare/Makefile
+	daemon/Makefile
+	user/Makefile
+	share/Makefile
 	control/Makefile
 ])
 
diff --git a/mountd/Makefile.am b/daemon/Makefile.am
similarity index 95%
rename from mountd/Makefile.am
rename to daemon/Makefile.am
index 4719170f2d05..6249a098025d 100644
--- a/mountd/Makefile.am
+++ b/daemon/Makefile.am
@@ -4,5 +4,5 @@ ksmbd_mountd_LDADD = $(top_builddir)/lib/libksmbdtools.a
 
 sbin_PROGRAMS = ksmbd.mountd
 
-ksmbd_mountd_SOURCES = worker.c ipc.c rpc.c rpc_srvsvc.c rpc_wkssvc.c mountd.c \
+ksmbd_mountd_SOURCES = worker.c ipc.c rpc.c rpc_srvsvc.c rpc_wkssvc.c daemon.c \
 		       smbacl.c rpc_samr.c rpc_lsarpc.c
diff --git a/mountd/mountd.c b/daemon/daemon.c
similarity index 100%
rename from mountd/mountd.c
rename to daemon/daemon.c
diff --git a/mountd/ipc.c b/daemon/ipc.c
similarity index 100%
rename from mountd/ipc.c
rename to daemon/ipc.c
diff --git a/mountd/rpc.c b/daemon/rpc.c
similarity index 100%
rename from mountd/rpc.c
rename to daemon/rpc.c
diff --git a/mountd/rpc_lsarpc.c b/daemon/rpc_lsarpc.c
similarity index 100%
rename from mountd/rpc_lsarpc.c
rename to daemon/rpc_lsarpc.c
diff --git a/mountd/rpc_samr.c b/daemon/rpc_samr.c
similarity index 100%
rename from mountd/rpc_samr.c
rename to daemon/rpc_samr.c
diff --git a/mountd/rpc_srvsvc.c b/daemon/rpc_srvsvc.c
similarity index 100%
rename from mountd/rpc_srvsvc.c
rename to daemon/rpc_srvsvc.c
diff --git a/mountd/rpc_wkssvc.c b/daemon/rpc_wkssvc.c
similarity index 100%
rename from mountd/rpc_wkssvc.c
rename to daemon/rpc_wkssvc.c
diff --git a/mountd/smbacl.c b/daemon/smbacl.c
similarity index 100%
rename from mountd/smbacl.c
rename to daemon/smbacl.c
diff --git a/mountd/worker.c b/daemon/worker.c
similarity index 100%
rename from mountd/worker.c
rename to daemon/worker.c
diff --git a/addshare/Makefile.am b/share/Makefile.am
similarity index 100%
rename from addshare/Makefile.am
rename to share/Makefile.am
diff --git a/addshare/addshare.c b/share/addshare.c
similarity index 100%
rename from addshare/addshare.c
rename to share/addshare.c
diff --git a/addshare/share_admin.c b/share/share_admin.c
similarity index 100%
rename from addshare/share_admin.c
rename to share/share_admin.c
diff --git a/addshare/share_admin.h b/share/share_admin.h
similarity index 100%
rename from addshare/share_admin.h
rename to share/share_admin.h
diff --git a/adduser/Makefile.am b/user/Makefile.am
similarity index 100%
rename from adduser/Makefile.am
rename to user/Makefile.am
diff --git a/adduser/adduser.c b/user/adduser.c
similarity index 100%
rename from adduser/adduser.c
rename to user/adduser.c
diff --git a/adduser/md4_hash.c b/user/md4_hash.c
similarity index 100%
rename from adduser/md4_hash.c
rename to user/md4_hash.c
diff --git a/adduser/md4_hash.h b/user/md4_hash.h
similarity index 100%
rename from adduser/md4_hash.h
rename to user/md4_hash.h
diff --git a/adduser/user_admin.c b/user/user_admin.c
similarity index 100%
rename from adduser/user_admin.c
rename to user/user_admin.c
diff --git a/adduser/user_admin.h b/user/user_admin.h
similarity index 100%
rename from adduser/user_admin.h
rename to user/user_admin.h
-- 
2.34.1


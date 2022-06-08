Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FF0C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jun 2022 21:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiFHVzM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jun 2022 17:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiFHVzL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Jun 2022 17:55:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6C891562
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jun 2022 14:55:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B34F821B4F;
        Wed,  8 Jun 2022 21:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654725307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dTVhqk3+JWD/g1KjfWDNQ7hAxtkozHllEncsg3IBdSY=;
        b=rlSg+1DpX12AOjDggsVuLa3/0lC7cYffb86WN4cmcEoHRh6Otg0LY3vWB3z7V6stEvfjaY
        o7dv75u+19mpM7ERHAu5LiE8z7LhpNok7O/wrdZeLJnFBTuNHXyj6zXaW46K7x1SQTUaYl
        ruhR8Bbh1D23iQEOxXdfo7buBMlVVg4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654725307;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dTVhqk3+JWD/g1KjfWDNQ7hAxtkozHllEncsg3IBdSY=;
        b=0fmzWaJpoxvzpHU7RxOWUDAjQdkgcTN8KFqt8dAjAR9GWpt1/Qk9NVBvc69Swiddz0L0/4
        EyB2FBTlO0jmThAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 379A413AD9;
        Wed,  8 Jun 2022 21:55:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DHH/OroaoWKlFwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 08 Jun 2022 21:55:06 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 1/2] cifs: create procfs for dns_interval setting
Date:   Wed,  8 Jun 2022 18:54:43 -0300
Message-Id: <20220608215444.1216-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608215444.1216-1-ematsumiya@suse.de>
References: <20220608215444.1216-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch introduces the /proc/fs/cifs/dns_interval setting, used to
configure the interval that DNS resolutions must be done.

Enforces the minimum value SMB_DNS_RESOLVE_INTERVAL_MIN (currently 120),
but allows it to be lower (10, arbitrarily chosen) when debugging (i.e.
cifsFYI > 0).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c | 63 ++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifs_debug.h |  2 ++
 fs/cifs/cifsfs.c     |  1 +
 3 files changed, 66 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 1dd995efd5b8..96ff549a103e 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -695,6 +695,7 @@ PROC_FILE_DEFINE(smbd_receive_credit_max);
 
 static struct proc_dir_entry *proc_fs_cifs;
 static const struct proc_ops cifsFYI_proc_ops;
+static const struct proc_ops cifs_dns_interval_proc_ops;
 static const struct proc_ops cifs_lookup_cache_proc_ops;
 static const struct proc_ops traceSMB_proc_ops;
 static const struct proc_ops cifs_security_flags_proc_ops;
@@ -716,6 +717,7 @@ cifs_proc_init(void)
 
 	proc_create("Stats", 0644, proc_fs_cifs, &cifs_stats_proc_ops);
 	proc_create("cifsFYI", 0644, proc_fs_cifs, &cifsFYI_proc_ops);
+	proc_create("dns_interval", 0644, proc_fs_cifs, &cifs_dns_interval_proc_ops);
 	proc_create("traceSMB", 0644, proc_fs_cifs, &traceSMB_proc_ops);
 	proc_create("LinuxExtensionsEnabled", 0644, proc_fs_cifs,
 		    &cifs_linux_ext_proc_ops);
@@ -759,6 +761,7 @@ cifs_proc_clean(void)
 	remove_proc_entry("DebugData", proc_fs_cifs);
 	remove_proc_entry("open_files", proc_fs_cifs);
 	remove_proc_entry("cifsFYI", proc_fs_cifs);
+	remove_proc_entry("dns_interval", proc_fs_cifs);
 	remove_proc_entry("traceSMB", proc_fs_cifs);
 	remove_proc_entry("Stats", proc_fs_cifs);
 	remove_proc_entry("SecurityFlags", proc_fs_cifs);
@@ -821,6 +824,66 @@ static const struct proc_ops cifsFYI_proc_ops = {
 	.proc_write	= cifsFYI_proc_write,
 };
 
+static int cifs_dns_interval_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%u\n", dns_interval);
+	return 0;
+}
+
+static int cifs_dns_interval_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_dns_interval_show, NULL);
+}
+
+static ssize_t cifs_dns_interval_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *ppos)
+{
+	int rc;
+	unsigned int interval;
+	char buf[12] = { 0 };
+	/* allow the minimum interval to be 10 (arbritrary) when debugging */
+	unsigned int min_interval = cifsFYI ? 10 : SMB_DNS_RESOLVE_INTERVAL_MIN;
+
+	if ((count < 1) || (count > 11))
+		return -EINVAL;
+
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+
+	if (count < 3) {
+		if (!isdigit(buf[0])) {
+			cifs_dbg(VFS, "Invalid value for dns_interval: %s\n",
+					buf);
+			return -EINVAL;
+		}
+	}
+
+	rc = kstrtouint(buf, 0, &interval);
+	if (rc) {
+		cifs_dbg(VFS, "Invalid value for dns_interval: %s\n",
+				buf);
+		return rc;
+	}
+
+	if (interval < min_interval) {
+		cifs_dbg(VFS, "minimum value for dns_interval is %u, default value is %u\n",
+				SMB_DNS_RESOLVE_INTERVAL_MIN,
+				SMB_DNS_RESOLVE_INTERVAL_DEFAULT);
+		return -EINVAL;
+	}
+
+	dns_interval = interval;
+	return count;
+}
+
+static const struct proc_ops cifs_dns_interval_proc_ops = {
+	.proc_open	= cifs_dns_interval_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= cifs_dns_interval_write,
+};
+
 static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "%d\n", linuxExtEnabled);
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index ee4ea2b60c0f..40ef322450a3 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -33,6 +33,8 @@ extern int cifsFYI;
 #endif
 #define ONCE 8
 
+extern unsigned int dns_interval;
+
 /*
  *	debug ON
  *	--------
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 325423180fd2..284645da8cd3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -66,6 +66,7 @@ bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
 bool enable_negotiate_signing; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
+unsigned int dns_interval = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
 /* unsigned int ntlmv2_support = 0; */
 unsigned int sign_CIFS_PDUs = 1;
 static const struct super_operations cifs_super_ops;
-- 
2.36.1


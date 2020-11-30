Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B906C83011
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 18:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5793E206F9
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 18:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgK3SDx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:03:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:45330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387902AbgK3SDx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 30 Nov 2020 13:03:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 389AAAF1B
        for <linux-cifs@vger.kernel.org>; Mon, 30 Nov 2020 18:03:11 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     Samuel Cabrero <scabrero@suse.de>
Subject: [PATCH v4 04/11] cifs: add witness mount option and data structs
Date:   Mon, 30 Nov 2020 19:02:50 +0100
Message-Id: <20201130180257.31787-5-scabrero@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130180257.31787-1-scabrero@suse.de>
References: <20201130180257.31787-1-scabrero@suse.de>
Reply-To: scabrero@suse.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add 'witness' mount option to register for witness notifications.

Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/cifsfs.c   |  5 +++++
 fs/cifs/cifsglob.h |  4 ++++
 fs/cifs/connect.c  | 35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8111d0109a2e..c2bbc444b463 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -637,6 +637,11 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",multichannel,max_channels=%zu",
 			   tcon->ses->chan_max);
 
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	if (tcon->use_witness)
+		seq_puts(s, ",witness");
+#endif
+
 	return 0;
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 484ec2d8c5c9..f45b7c0fbceb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -619,6 +619,7 @@ struct smb_vol {
 	unsigned int max_channels;
 	__u16 compression; /* compression algorithm 0xFFFF default 0=disabled */
 	bool rootfs:1; /* if it's a SMB root file system */
+	bool witness:1; /* use witness protocol */
 };
 
 /**
@@ -1177,6 +1178,9 @@ struct cifs_tcon {
 	int remap:2;
 	struct list_head ulist; /* cache update list */
 #endif
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	bool use_witness:1; /* use witness protocol */
+#endif
 };
 
 /*
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a938371af6ef..22d46c8acc7f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -102,7 +102,7 @@ enum {
 	Opt_resilient, Opt_noresilient,
 	Opt_domainauto, Opt_rdma, Opt_modesid, Opt_rootfs,
 	Opt_multichannel, Opt_nomultichannel,
-	Opt_compress,
+	Opt_compress, Opt_witness,
 
 	/* Mount options which take numeric value */
 	Opt_backupuid, Opt_backupgid, Opt_uid,
@@ -276,6 +276,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_ignore, "relatime" },
 	{ Opt_ignore, "_netdev" },
 	{ Opt_rootfs, "rootfs" },
+	{ Opt_witness, "witness" },
 
 	{ Opt_err, NULL }
 };
@@ -1540,6 +1541,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->rootfs = true;
 #endif
 			break;
+		case Opt_witness:
+#ifndef CONFIG_CIFS_SWN_UPCALL
+			cifs_dbg(VFS, "Witness support needs CONFIG_CIFS_SWN_UPCALL kernel config option set\n");
+			goto cifs_parse_mount_err;
+#endif
+			vol->witness = true;
+			break;
 		case Opt_posixpaths:
 			vol->posix_paths = 1;
 			break;
@@ -3160,6 +3168,8 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 		return;
 	}
 
+	/* TODO witness unregister */
+
 	list_del_init(&tcon->tcon_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -3321,6 +3331,26 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		tcon->use_resilient = true;
 	}
 
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	tcon->use_witness = false;
+	if (volume_info->witness) {
+		if (ses->server->vals->protocol_id >= SMB30_PROT_ID) {
+			if (tcon->capabilities & SMB2_SHARE_CAP_CLUSTER) {
+				/* TODO witness register */
+				tcon->use_witness = true;
+			} else {
+				cifs_dbg(VFS, "witness requested on mount but no CLUSTER capability on share\n");
+				rc = -EOPNOTSUPP;
+				goto out_fail;
+			}
+		} else {
+			cifs_dbg(VFS, "SMB3 or later required for witness option\n");
+			rc = -EOPNOTSUPP;
+			goto out_fail;
+		}
+	}
+#endif
+
 	/* If the user really knows what they are doing they can override */
 	if (tcon->share_flags & SMB2_SHAREFLAG_NO_CACHING) {
 		if (volume_info->cache_ro)
@@ -5072,6 +5102,9 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	vol_info->sectype = master_tcon->ses->sectype;
 	vol_info->sign = master_tcon->ses->sign;
 	vol_info->seal = master_tcon->seal;
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	vol_info->witness = master_tcon->use_witness;
+#endif
 
 	rc = cifs_set_vol_auth(vol_info, master_tcon->ses);
 	if (rc) {
-- 
2.29.2


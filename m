Return-Path: <SRS0=MPEU=Y3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B49CA9ED0
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 01:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 995F1215EA
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 01:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfKCBV1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Nov 2019 21:21:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:57532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727350AbfKCBV1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Nov 2019 21:21:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CF93AE68;
        Sun,  3 Nov 2019 01:21:25 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v4 2/6] cifs: add multichannel mount options and data structs
Date:   Sun,  3 Nov 2019 02:21:08 +0100
Message-Id: <20191103012112.12212-3-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191103012112.12212-1-aaptel@suse.com>
References: <20191103012112.12212-1-aaptel@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

adds:
- [no]multichannel to enable/disable multichannel
- max_channels=N to control how many channels to create

these options are then stored in the volume struct.

- store channels and max_channels in cifs_ses

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsfs.c   |  4 ++++
 fs/cifs/cifsglob.h | 16 ++++++++++++++++
 fs/cifs/connect.c  | 38 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e4e3b573d20c..44c9f95a0a34 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -613,6 +613,10 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	/* convert actimeo and display it in seconds */
 	seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
 
+	if (tcon->ses->chan_max > 1)
+		seq_printf(s, ",multichannel,max_channel=%zu",
+			   tcon->ses->chan_max);
+
 	return 0;
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d78bfcc19156..132dd8fd81ff 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -591,6 +591,10 @@ struct smb_vol {
 	bool resilient:1; /* noresilient not required since not fored for CA */
 	bool domainauto:1;
 	bool rdma:1;
+	bool multichannel:1;
+	bool use_client_guid:1;
+	/* reuse existing guid for multichannel */
+	u8 client_guid[SMB2_CLIENT_GUID_SIZE];
 	unsigned int bsize;
 	unsigned int rsize;
 	unsigned int wsize;
@@ -607,6 +611,7 @@ struct smb_vol {
 	__u64 snapshot_time; /* needed for timewarp tokens */
 	__u32 handle_timeout; /* persistent and durable handle timeout in ms */
 	unsigned int max_credits; /* smb3 max_credits 10 < credits < 60000 */
+	unsigned int max_channels;
 	__u16 compression; /* compression algorithm 0xFFFF default 0=disabled */
 	bool rootfs:1; /* if it's a SMB root file system */
 };
@@ -953,6 +958,11 @@ struct cifs_server_iface {
 	struct sockaddr_storage sockaddr;
 };
 
+struct cifs_chan {
+	struct TCP_Server_Info *server;
+	__u8 signkey[SMB3_SIGN_KEY_SIZE];
+};
+
 /*
  * Session structure.  One of these for each uid session with a particular host
  */
@@ -1002,6 +1012,12 @@ struct cifs_ses {
 	struct cifs_server_iface *iface_list;
 	size_t iface_count;
 	unsigned long iface_last_update; /* jiffies */
+
+#define CIFS_MAX_CHANNELS 16
+	struct cifs_chan chans[CIFS_MAX_CHANNELS];
+	size_t chan_count;
+	size_t chan_max;
+	atomic_t chan_seq; /* round robin state */
 };
 
 static inline bool
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccaa8bad336f..d50f0676bf8a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -97,6 +97,7 @@ enum {
 	Opt_persistent, Opt_nopersistent,
 	Opt_resilient, Opt_noresilient,
 	Opt_domainauto, Opt_rdma, Opt_modesid, Opt_rootfs,
+	Opt_multichannel, Opt_nomultichannel,
 	Opt_compress,
 
 	/* Mount options which take numeric value */
@@ -106,7 +107,7 @@ enum {
 	Opt_min_enc_offload,
 	Opt_blocksize, Opt_rsize, Opt_wsize, Opt_actimeo,
 	Opt_echo_interval, Opt_max_credits, Opt_handletimeout,
-	Opt_snapshot,
+	Opt_snapshot, Opt_max_channels,
 
 	/* Mount options which take string value */
 	Opt_user, Opt_pass, Opt_ip,
@@ -199,6 +200,8 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_noresilient, "noresilienthandles"},
 	{ Opt_domainauto, "domainauto"},
 	{ Opt_rdma, "rdma"},
+	{ Opt_multichannel, "multichannel" },
+	{ Opt_nomultichannel, "nomultichannel" },
 
 	{ Opt_backupuid, "backupuid=%s" },
 	{ Opt_backupgid, "backupgid=%s" },
@@ -218,6 +221,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_echo_interval, "echo_interval=%s" },
 	{ Opt_max_credits, "max_credits=%s" },
 	{ Opt_snapshot, "snapshot=%s" },
+	{ Opt_max_channels, "max_channels=%s" },
 	{ Opt_compress, "compress=%s" },
 
 	{ Opt_blank_user, "user=" },
@@ -1672,6 +1676,10 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 	vol->echo_interval = SMB_ECHO_INTERVAL_DEFAULT;
 
+	/* default to no multichannel (single server connection) */
+	vol->multichannel = false;
+	vol->max_channels = 1;
+
 	if (!mountdata)
 		goto cifs_parse_mount_err;
 
@@ -1965,6 +1973,12 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_rdma:
 			vol->rdma = true;
 			break;
+		case Opt_multichannel:
+			vol->multichannel = true;
+			break;
+		case Opt_nomultichannel:
+			vol->multichannel = false;
+			break;
 		case Opt_compress:
 			vol->compression = UNKNOWN_TYPE;
 			cifs_dbg(VFS,
@@ -2128,6 +2142,15 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			}
 			vol->max_credits = option;
 			break;
+		case Opt_max_channels:
+			if (get_option_ul(args, &option) || option < 1 ||
+				option > CIFS_MAX_CHANNELS) {
+				cifs_dbg(VFS, "%s: Invalid max_channels value, needs to be 1-%d\n",
+					 __func__, CIFS_MAX_CHANNELS);
+				goto cifs_parse_mount_err;
+			}
+			vol->max_channels = option;
+			break;
 
 		/* String Arguments */
 
@@ -2772,7 +2795,11 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	       sizeof(tcp_ses->srcaddr));
 	memcpy(&tcp_ses->dstaddr, &volume_info->dstaddr,
 		sizeof(tcp_ses->dstaddr));
-	generate_random_uuid(tcp_ses->client_guid);
+	if (volume_info->use_client_guid)
+		memcpy(tcp_ses->client_guid, volume_info->client_guid,
+		       SMB2_CLIENT_GUID_SIZE);
+	else
+		generate_random_uuid(tcp_ses->client_guid);
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
@@ -2861,6 +2888,13 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
 	    vol->sectype != ses->sectype)
 		return 0;
 
+	/*
+	 * If an existing session is limited to less channels than
+	 * requested, it should not be reused
+	 */
+	if (ses->chan_max < vol->max_channels)
+		return 0;
+
 	switch (ses->sectype) {
 	case Kerberos:
 		if (!uid_eq(vol->cred_uid, ses->cred_uid))
-- 
2.16.4


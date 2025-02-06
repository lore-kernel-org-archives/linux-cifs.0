Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7661FC0ED;
	Thu,  6 Feb 2025 06:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824678; cv=none; b=GBHI9CkG0PBqx0+7lut+C3VIZQ53AFiqDpX/Uf/S+k3yaXO7DxySYr8FDRDcllWf7a5uht73je5Mwqvkazvr/JG8OT29z01kub28GaORkZQOlPOOCPQ/wz587RN1YU2qtYJG/ateYgTEch6mfCqNZ++5sHhjqPapzFrvTT59RVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824678; c=relaxed/simple;
	bh=W207mP0jcnmjStXnf5hc7cwKs++y+DnzP/lWeZHqjG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Er3hrP7H5X0uKhTy7A2AMgAgR3KtL8hyycqnuxR6+f8O3rb18GByt8wDBoHVDwEy6Yp5mhOelXRwRO9aCpaIU2/D6j2vcdBkVE868C7uyeB/p+GvYLbkBPeAvW+KcYQHrENdXdyhvDQx/6bgR6cDWFmamzopqprZPTFhZlB88g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CSs+4FTK; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CSs+4FTK"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2166f1e589cso14057815ad.3;
        Wed, 05 Feb 2025 22:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738824675; x=1739429475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wI9ZpMw7Gy7qg2Uts/pom0IsswPhT1sIy/kO+FUrGLM=;
        b=CSs+4FTKRjVc5u1Z9GemnYLMwAqgka1/++1iMfmvVPnkCp7K8ik55+/u+HZLztmwuo
         kZzAbYfo652pmQYN+p07ZZpIc+R/OSKvMlrj4fKqtsFyf4W339htcF8cR04qBWh1L9ND
         zY3uzH+joCdfXniU5kijGq3hfKM04jqkqAuVKKe7UZIDSa2oaC1BbeEza8KETuoSoDa+
         ASVASY1uN4JbafM8p6Ah/AJMWRB88JjsOwSCpB/4E1XrJNY0IXUE3v8LTOC26lL7vjJ6
         zpXXqs5qzLNdJYYSiYhyeWPAGuLGA4I70JFWcZ+xj82CGbS2C6jl2lW6HloDdsOmtsuB
         BKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738824675; x=1739429475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wI9ZpMw7Gy7qg2Uts/pom0IsswPhT1sIy/kO+FUrGLM=;
        b=rvQl8/v3U+Gtpu/keZS/p4sNYKQOLOuoaAvgKSFLtAY85w9s37UvUCkK4Vvpt6Ziy0
         Kh5EM9L9JfcwZDAmOX7qb2DeudtFE11Kyba0vmojnrGg4CJ796MDB1A7l4SN6lOS2P0p
         3xbND0nma3RXp/+yYjQKUAS2LUfgLK2uifzoqJN+7G4aH+Dzb1UpAyKkKMpaI8her2Wd
         ERYGrobZlFwMHFq/4HAQ8ZeYdm16E0vAwBE0vIfp/2hy8E1hQivgRZ2weo2vF4/sn91r
         Lm9zLztJ0vlOvub7+1pcGj//fcAn48mv4EMIEQIS27JMxRpHRhaJ+QuQdlHuTvcx6q/x
         BDug==
X-Forwarded-Encrypted: i=1; AJvYcCVOvaZOMfTjmRnKEPNtBJ9JitnYc2KByRqbb9uEAJEWtTGHiOLHZ7X0jfYef/niKynhDV4/FbFoqzOs@vger.kernel.org, AJvYcCWA81p0J7D3uT4uU81Ixsk2vvy+PrVzGN9gMvvZlP42fzkVdGs/3rveW86V2rFzIoZ7+dMljMDLnLV2ANZu@vger.kernel.org, AJvYcCWmRbJhiAvFcyfQgWpaWR1118JyTZ8EMZ+OXt2REsu7wRxyleSmaOy0naNmUGmDN76tqzeUiIJ0@vger.kernel.org
X-Gm-Message-State: AOJu0YySEt22cgstwi7V+Vr71Mex8/i6lHmV9DozErGjn9MpHi0x4OXK
	lss/xAdxYkR4v0LgP4Z5AdEhfcc7ge5q+q0QVklqc0SBeotKZF1L
X-Gm-Gg: ASbGncvRlqWemc2gOdcejd1gt6IeWwyqZOksWklKei0rC+M+3sbvFA3P4u6GZ/P43/K
	6vT0GgYB4ziNQnQOUgIblv6v90endp5EYdIodW57O0/k+JUskRt6MAxT85fnvVYhbXlsOHm/uky
	6YvGqxZLHPMjeFtAV2+lOLu9M/a/VULviXMPK24qu14Q5b+oP68P9NPlwW+VXncK0dZGfN3m33A
	Q/UGa8pwmxs1etRyrwjeMMYS8ty3TfNFvDrg17YYT3shbhI3Pce3mgvkE/3cMuV2mqcltK2BcVn
	yCiCQxE+D8zIkayRro3PTX2ZWTAB5UQeR52Mcx7m+A==
X-Google-Smtp-Source: AGHT+IFCSk9bei0s7d9S8Plb0v82TXjv46ncAdySuahsCcNj1H9jo7JiH6fmo1DXl1oIX/c9KDyWwQ==
X-Received: by 2002:a17:902:f687:b0:216:4cc0:aa4e with SMTP id d9443c01a7336-21f17f11399mr92063645ad.47.1738824675334;
        Wed, 05 Feb 2025 22:51:15 -0800 (PST)
Received: from met-Virtual-Machine.. ([131.107.159.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f36538c26sm5169325ad.55.2025.02.05.22.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 22:51:14 -0800 (PST)
From: meetakshisetiyaoss@gmail.com
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	nspmangalore@gmail.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org,
	bharathsm.hsk@gmail.com,
	bharathsm@microsoft.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] smb: client: change lease epoch type from unsigned int to __u16
Date: Thu,  6 Feb 2025 01:50:41 -0500
Message-ID: <20250206065101.339850-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

MS-SMB2 section 2.2.13.2.10 specifies that 'epoch' should be a 16-bit
unsigned integer used to track lease state changes. Change the data
type of all instances of 'epoch' from unsigned int to __u16. This
simplifies the epoch change comparisons and makes the code more
compliant with the protocol spec.

Cc: stable@vger.kernel.org
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h  | 12 ++++++------
 fs/smb/client/smb1ops.c   |  2 +-
 fs/smb/client/smb2ops.c   | 18 +++++++++---------
 fs/smb/client/smb2pdu.c   |  2 +-
 fs/smb/client/smb2proto.h |  2 +-
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a68434ad744a..2c1b0438fe7d 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -357,7 +357,7 @@ struct smb_version_operations {
 	int (*handle_cancelled_mid)(struct mid_q_entry *, struct TCP_Server_Info *);
 	void (*downgrade_oplock)(struct TCP_Server_Info *server,
 				 struct cifsInodeInfo *cinode, __u32 oplock,
-				 unsigned int epoch, bool *purge_cache);
+				 __u16 epoch, bool *purge_cache);
 	/* process transaction2 response */
 	bool (*check_trans2)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     char *, int);
@@ -552,12 +552,12 @@ struct smb_version_operations {
 	/* if we can do cache read operations */
 	bool (*is_read_op)(__u32);
 	/* set oplock level for the inode */
-	void (*set_oplock_level)(struct cifsInodeInfo *, __u32, unsigned int,
+	void (*set_oplock_level)(struct cifsInodeInfo *, __u32, __u16,
 				 bool *);
 	/* create lease context buffer for CREATE request */
 	char * (*create_lease_buf)(u8 *lease_key, u8 oplock);
 	/* parse lease context buffer and return oplock/epoch info */
-	__u8 (*parse_lease_buf)(void *buf, unsigned int *epoch, char *lkey);
+	__u8 (*parse_lease_buf)(void *buf, __u16 *epoch, char *lkey);
 	ssize_t (*copychunk_range)(const unsigned int,
 			struct cifsFileInfo *src_file,
 			struct cifsFileInfo *target_file,
@@ -1447,7 +1447,7 @@ struct cifs_fid {
 	__u8 create_guid[16];
 	__u32 access;
 	struct cifs_pending_open *pending_open;
-	unsigned int epoch;
+	__u16 epoch;
 #ifdef CONFIG_CIFS_DEBUG2
 	__u64 mid;
 #endif /* CIFS_DEBUG2 */
@@ -1480,7 +1480,7 @@ struct cifsFileInfo {
 	bool oplock_break_cancelled:1;
 	bool status_file_deleted:1; /* file has been deleted */
 	bool offload:1; /* offload final part of _put to a wq */
-	unsigned int oplock_epoch; /* epoch from the lease break */
+	__u16 oplock_epoch; /* epoch from the lease break */
 	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
@@ -1577,7 +1577,7 @@ struct cifsInodeInfo {
 	spinlock_t	open_file_lock;	/* protects openFileList */
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
-	unsigned int epoch;		/* used to track lease state changes */
+	__u16 epoch;		/* used to track lease state changes */
 #define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
 #define CIFS_INODE_PENDING_WRITERS	  (1) /* Writes in progress */
 #define CIFS_INODE_FLAG_UNUSED		  (2) /* Unused flag */
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 9756b876a75e..d6e2fb669c40 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -377,7 +377,7 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 static void
 cifs_downgrade_oplock(struct TCP_Server_Info *server,
 		      struct cifsInodeInfo *cinode, __u32 oplock,
-		      unsigned int epoch, bool *purge_cache)
+		      __u16 epoch, bool *purge_cache)
 {
 	cifs_set_oplock_level(cinode, oplock);
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 77309217dab4..ec36bed54b0b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3904,22 +3904,22 @@ static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
 static void
 smb2_downgrade_oplock(struct TCP_Server_Info *server,
 		      struct cifsInodeInfo *cinode, __u32 oplock,
-		      unsigned int epoch, bool *purge_cache)
+		      __u16 epoch, bool *purge_cache)
 {
 	server->ops->set_oplock_level(cinode, oplock, 0, NULL);
 }
 
 static void
 smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
-		       unsigned int epoch, bool *purge_cache);
+		       __u16 epoch, bool *purge_cache);
 
 static void
 smb3_downgrade_oplock(struct TCP_Server_Info *server,
 		       struct cifsInodeInfo *cinode, __u32 oplock,
-		       unsigned int epoch, bool *purge_cache)
+		       __u16 epoch, bool *purge_cache)
 {
 	unsigned int old_state = cinode->oplock;
-	unsigned int old_epoch = cinode->epoch;
+	__u16 old_epoch = cinode->epoch;
 	unsigned int new_state;
 
 	if (epoch > old_epoch) {
@@ -3939,7 +3939,7 @@ smb3_downgrade_oplock(struct TCP_Server_Info *server,
 
 static void
 smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
-		      unsigned int epoch, bool *purge_cache)
+		      __u16 epoch, bool *purge_cache)
 {
 	oplock &= 0xFF;
 	cinode->lease_granted = false;
@@ -3963,7 +3963,7 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 
 static void
 smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
-		       unsigned int epoch, bool *purge_cache)
+		       __u16 epoch, bool *purge_cache)
 {
 	char message[5] = {0};
 	unsigned int new_oplock = 0;
@@ -4000,7 +4000,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 
 static void
 smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
-		      unsigned int epoch, bool *purge_cache)
+		      __u16 epoch, bool *purge_cache)
 {
 	unsigned int old_oplock = cinode->oplock;
 
@@ -4114,7 +4114,7 @@ smb3_create_lease_buf(u8 *lease_key, u8 oplock)
 }
 
 static __u8
-smb2_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
+smb2_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key)
 {
 	struct create_lease *lc = (struct create_lease *)buf;
 
@@ -4125,7 +4125,7 @@ smb2_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
 }
 
 static __u8
-smb3_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
+smb3_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key)
 {
 	struct create_lease_v2 *lc = (struct create_lease_v2 *)buf;
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 40ad9e79437a..51204ff58bf6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2329,7 +2329,7 @@ parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 
 int smb2_parse_contexts(struct TCP_Server_Info *server,
 			struct kvec *rsp_iov,
-			unsigned int *epoch,
+			__u16 *epoch,
 			char *lease_key, __u8 *oplock,
 			struct smb2_file_all_info *buf,
 			struct create_posix_rsp *posix)
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 2336dfb23f36..4662c7e2d259 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -283,7 +283,7 @@ extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
 int smb2_parse_contexts(struct TCP_Server_Info *server,
 			struct kvec *rsp_iov,
-			unsigned int *epoch,
+			__u16 *epoch,
 			char *lease_key, __u8 *oplock,
 			struct smb2_file_all_info *buf,
 			struct create_posix_rsp *posix);
-- 
2.46.0.46.g406f326d27


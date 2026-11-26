Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795714699;
	b=ZFhcFwHRea6ZwlooUL9U6Tcxiy9/+uPYodzQGKoCBpHoPdGmLTU1Bu73ECStsDNqcHVb
	 X0Xdknp8JO/es9dFTs9bv9S0H6onnExg7II4U31Y99NIezTgtfgtbbb9GUqX8GcS1hyak
	 WG0PjAeoEcP7Ou6iHG6kdlVhB3rmtDqzgAqxJQUy+i5oNtPOom10+M+Gw8814zU3Be9Zf
	 es4zm8gG98SO/k7XXqZIY/hz32fuwxk8NOVGrZyaGfJsexR8fx+YRHKpXquVgiLBWHgi1
	 ZdUkFoz+WXq0aDLYgJXtAuXaA79uFEUCB+Xyj+Qa2GSPsf8+fk7q4vPVQR5vEqdgDzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795714699;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=GgNH8huiywuV/ATseZ+D8jh3PPCbaNCwkIwoUJwmRtM=;
	b=L0Ddfk948pAzWRoYvVkURULtnLuvB6VKvaOPO3bZgPd3CMfCPA7jtsS76wUHGZkrjIX/
	 8JKFrEh9b2d+5fe4pw54gpZEIrdut18KxgwLtR78M/x3nKiNxf4DQz9p8p14RUn174Mqj
	 Ipqk13qmtRAkbhBzm1nHICLQb7pcREDdiZBjuNBsPAZZaJLF4tqU+TBu/7mAa+h9Es6Mr
	 qJrZFSxvAGa92+NXIRdjZaMJA3RY8XOLFCPonh+XnjH+B++7PPWGxRqs8I3NaMB6GzLGw
	 jAb1dKoaegOmVbEHyoTXJ25x07GPA3w7qije/GHWdQhMJW1EIjYb530rnqyoKBx9TJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tZNb6NSA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dRgQeLkT;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tZNb6NSA;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dRgQeLkT;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F288D606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 17:38:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F288D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tZNb6NSA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dRgQeLkT;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tZNb6NSA;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dRgQeLkT
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 13A5E227C5;
	Thu, 26 Nov 2026 17:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795714697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GgNH8huiywuV/ATseZ+D8jh3PPCbaNCwkIwoUJwmRtM=;
	b=tZNb6NSA8Bs3KWRsxQoaMGMAyApacui62Ablafg+RWEFWNdX+GI4puX5+OWn2bYnMwwp6+
	2dKRWEwEC+c+06lwLJ8Q3uc/nN3KdQznFSeGDDs0Wzudz+oeBvAISDXMCbZ0GcD8nlPNbP
	FaTGTEIdYIasXRHr0//T8FP4wB6G8Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795714697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GgNH8huiywuV/ATseZ+D8jh3PPCbaNCwkIwoUJwmRtM=;
	b=dRgQeLkTnDaLLo3JqFVwNAN3mar+NJjVk3gvSsV7vf/OX6so6d+5Tl/d46j9em/kqCI/nS
	ea8stcM1IBFdK2CQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tZNb6NSA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dRgQeLkT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795714697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GgNH8huiywuV/ATseZ+D8jh3PPCbaNCwkIwoUJwmRtM=;
	b=tZNb6NSA8Bs3KWRsxQoaMGMAyApacui62Ablafg+RWEFWNdX+GI4puX5+OWn2bYnMwwp6+
	2dKRWEwEC+c+06lwLJ8Q3uc/nN3KdQznFSeGDDs0Wzudz+oeBvAISDXMCbZ0GcD8nlPNbP
	FaTGTEIdYIasXRHr0//T8FP4wB6G8Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795714697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GgNH8huiywuV/ATseZ+D8jh3PPCbaNCwkIwoUJwmRtM=;
	b=dRgQeLkTnDaLLo3JqFVwNAN3mar+NJjVk3gvSsV7vf/OX6so6d+5Tl/d46j9em/kqCI/nS
	ea8stcM1IBFdK2CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 737AB13432;
	Thu, 26 Nov 2026 17:38:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oZw4AohuCGvhagAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 26 Nov 2026 17:38:16 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Michael Brunner <michael.brunner@noel.gv.at>
Subject: [PATCH] smb: client: fix -EACCES when creating read-only file without O_EXCL
Date: Thu, 26 Nov 2026 14:38:06 -0300
Message-ID: <20261126173806.1051181-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.de,noel.gv.at];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 13A5E227C5

Non-root users get -EACCES when trying to create a read-only file,
without O_EXCL set.  An empty file still gets created on the server.

Fix this by setting FMODE_CREATED based on server CreateAction response,
not on open flags.

Reproducer:
  # mount.cifs -o ...,uid=1000 //srv/share /mnt

As UID=1000:
  $ (umask 0222; echo test > /mnt/file.txt)
  -bash: /mnt/file.txt: Permission denied
  $ ls -l /mnt
  total 0
  -r-xr-xr-x 1 enzo root 0 Nov 26 13:18 file.txt

Tested-by: Michael Brunner <michael.brunner@noel.gv.at>
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/dir.c     | 45 +++++++++++++++++++++++++++++------------
 fs/smb/client/smb2pdu.c |  8 ++++++++
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 2f6d769a9c83..519909ad089d 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -199,7 +199,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 			    struct tcon_link *tlink, unsigned int oflags,
 			    umode_t mode, __u32 *oplock, struct cifs_fid *fid,
 			    struct cifs_open_info_data *buf,
-			    struct inode **inode, bool *opened)
+			    struct inode **inode, int *opened)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
@@ -216,7 +216,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 	__le32 lease_flags = 0;
 
 	*inode = NULL;
-	*opened = false;
+	*opened = 0;
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
@@ -233,7 +233,10 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 				     oflags, oplock, &fid->netfid, xid);
 		switch (rc) {
 		case 0:
-			*opened = true;
+			*opened = FILE_OPEN;
+			if (*oplock & CIFS_CREATE_ACTION)
+				*opened = FILE_CREATE;
+
 			if (newinode == NULL) {
 				/* query inode info */
 				goto cifs_create_get_file_info;
@@ -384,7 +387,12 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 		}
 		return rc;
 	}
-	*opened = true;
+
+	*opened = FILE_OPEN;
+	if (oparms.disposition == FILE_CREATE ||
+	    (*oplock & CIFS_CREATE_ACTION)) /* SMB1 */
+		*opened = FILE_CREATE;
+
 	if (rdwr_for_fscache == 2)
 		cifs_invalidate_cache(dir, FSCACHE_INVAL_DIO_WRITE);
 
@@ -487,7 +495,7 @@ static int cifs_do_create(struct inode *dir, struct dentry *direntry,
 			  unsigned int oflags, umode_t mode,
 			  __u32 *oplock, struct cifs_fid *fid,
 			  struct cifs_open_info_data *buf,
-			  struct inode **inode, bool *opened)
+			  struct inode **inode, int *opened)
 {
 	void *page = alloc_dentry_path();
 	const char *full_path;
@@ -496,7 +504,7 @@ static int cifs_do_create(struct inode *dir, struct dentry *direntry,
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
 		rc = PTR_ERR(full_path);
-		*opened = false;
+		*opened = 0;
 	} else {
 		rc = __cifs_do_create(dir, direntry, full_path, xid,
 				      tlink, oflags, mode, oplock,
@@ -529,10 +537,9 @@ int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 	struct dentry *alias;
 	struct inode *inode;
 	unsigned int xid;
-	__u32 oplock;
 	bool is_regular;
-	bool opened;
-	int rc;
+	int opened, rc;
+	u32 oplock;
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
@@ -612,9 +619,21 @@ int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 		d_instantiate(direntry, inode);
 	}
 
-	if (is_regular && opened &&
-	    (oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+	/*
+	 * @oflags is only meaningful before cifs_do_create().  At this point,
+	 * only the server response can tell us whether the file was opened or
+	 * created.
+	 */
+	if (is_regular && opened == FILE_CREATE)
 		file->f_mode |= FMODE_CREATED;
+	else if (WARN_ON_ONCE(opened == FILE_OPEN && (oflags & O_EXCL))) {
+		 /* Bug in server->ops->open() */
+		rc = -EEXIST;
+		if (server->ops->close)
+			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
+		goto out;
+	}
 
 	if (!is_regular || !opened) {
 		rc = finish_no_open(file, NULL);
@@ -683,7 +702,7 @@ int cifs_create(const struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	struct cifs_fid fid;
 	__u32 oplock;
-	bool opened;
+	int opened;
 	struct cifs_open_info_data buf = {};
 
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
@@ -1102,8 +1121,8 @@ int cifs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	unsigned int xid;
 	__u32 oplock;
-	bool opened;
 	int namelen;
+	int opened;
 	int rc;
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7b7d25364e20..e2f77e0bdeee 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3373,6 +3373,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	struct kvec iov[SMB2_CREATE_IOV_SIZE];
 	struct kvec rsp_iov = {NULL, 0};
 	int resp_buftype = CIFS_NO_BUFFER;
+	int disp = oparms->disposition;
 	int rc = 0;
 	int flags = 0;
 	int retries = 0, cur_sleep = 0;
@@ -3392,6 +3393,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	flags = 0;
 	server = cifs_pick_channel(ses);
 	/* reissue the same create: a durable reconnect clears ->reconnect */
+	oparms->disposition = disp;
 	oparms->reconnect = reconnect;
 	/* with no_replay the caller owns oparms->replay */
 	if (!oparms->no_replay)
@@ -3455,6 +3457,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	oparms->fid->persistent_fid = rsp->PersistentFileId;
 	oparms->fid->volatile_fid = rsp->VolatileFileId;
 	oparms->fid->access = oparms->desired_access;
+	/*
+	 * Reuse oparms->disposition to let callers know whether the file was
+	 * opened or created.
+	 * Currently, this is only checked post-open by cifs_atomic_open().
+	 */
+	oparms->disposition = le32_to_cpu(rsp->CreateAction);
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
-- 
2.55.0


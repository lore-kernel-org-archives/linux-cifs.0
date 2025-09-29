Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770ED30DD04
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 17:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759166285; cv=none; b=cT+s8UBYR4gV3PjCsWBhMXlTQzKPigXaf6VzcZYwdndGefbcq5j7x/UcS6lUqJlkDsdplT93QJjIIaGwj0WjOxeeQTH11SxC09cQ4PIQPh+cXI6CEkV/NZvu8ucnwHhJjVbWBtNk8vvBy68tTxcVJoPqW6CSjiihVBqHze1sJ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759166285; c=relaxed/simple;
	bh=wDGejSdzIBVgshKgisYWP5j7mnG48Ej6ryMnEDh/oj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StaAsMZsQR+ArpSYAFlc/t5nC8QW68nq7gMuIlwjzeYQioalnfSN3ScNuWfATkkF1RZRBD1HCTI9LMhGHnyNqqQ1c2Cfk5nUXZQQ+THVB91u+sDV3hK8XZL+cO6xti1DmktxSsYllO5ARZU4nA3ktorZFVTUR4MKLnuWp8ZTznI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xv91MYzg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=75Z5sAop; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xv91MYzg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=75Z5sAop; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xv91MYzg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="75Z5sAop";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xv91MYzg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="75Z5sAop"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F8C8374F7;
	Mon, 29 Sep 2025 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759166275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UULy/mAV3WLsBN6/GL+8r86++CgGL/D9QRMehabo2/E=;
	b=Xv91MYzgNl5IaowF6J2z8c7q9kZON3HziX8d+M6eChGVpiEyDZhW3FWSaT/HIhAWBCIiXj
	t+jVlIO8MZwsU5VKHeoAHWvNs4MjGqRgK+wnRJA1bLDI5h7Kslw7iwutNeIWicYenQNgAs
	8FKreMuiP8EE8Gn2TUd62F7bvFuAAyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759166275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UULy/mAV3WLsBN6/GL+8r86++CgGL/D9QRMehabo2/E=;
	b=75Z5sAopoLA/DZfxrZhZE+rLXfnk9XCQZ/Kr+tLIYnJffpeg4V/2UDE7R4N4z7lJCIXBtJ
	KOQocDNcIoNzbnBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759166275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UULy/mAV3WLsBN6/GL+8r86++CgGL/D9QRMehabo2/E=;
	b=Xv91MYzgNl5IaowF6J2z8c7q9kZON3HziX8d+M6eChGVpiEyDZhW3FWSaT/HIhAWBCIiXj
	t+jVlIO8MZwsU5VKHeoAHWvNs4MjGqRgK+wnRJA1bLDI5h7Kslw7iwutNeIWicYenQNgAs
	8FKreMuiP8EE8Gn2TUd62F7bvFuAAyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759166275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UULy/mAV3WLsBN6/GL+8r86++CgGL/D9QRMehabo2/E=;
	b=75Z5sAopoLA/DZfxrZhZE+rLXfnk9XCQZ/Kr+tLIYnJffpeg4V/2UDE7R4N4z7lJCIXBtJ
	KOQocDNcIoNzbnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EEC1C13782;
	Mon, 29 Sep 2025 17:17:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wWrLLEK/2miqZQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 17:17:54 +0000
Date: Mon, 29 Sep 2025 14:17:48 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH 12/20] smb: client: prevent lease breaks of cached
 parents when opening children
Message-ID: <rlraektlgtrukh5qx35fjspvaknb3xcxwhnekfp2tep6pnoga7@ww7auxaysqkj>
References: <20250929132805.220558-1-ematsumiya@suse.de>
 <20250929132805.220558-13-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250929132805.220558-13-ematsumiya@suse.de>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.80

On 09/29, Enzo Matsumiya wrote:
>In SMB2_open_init(), when opening (not creating/deleting) a path, lookup
>for a cached parent and set ParentLeaseKey in lease context if found.
>
>Other:
>- set oparms->cifs_sb in open_cached_dir() as we need it in
>  add_parent_lease_key(); use CIFS_OPARMS() too

This patch is from a rebase gone wrong.

- the function above is now called check_cached_parent() instead of
   add_parent_lease_key()
- the conditions to add ParentLeaseKey needs to be refreshed because of
   the above
- it should've already include Bharath's fix in cifs_do_create()
   (setting dirents.is_failed to true)

I'll fix these in V2.


Enzo

>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>---
> fs/smb/client/cached_dir.c | 42 ++++---------------
> fs/smb/client/dir.c        | 26 +++---------
> fs/smb/client/smb2inode.c  |  2 +
> fs/smb/client/smb2pdu.c    | 86 ++++++++++++++++++++++++++++++++------
> 4 files changed, 88 insertions(+), 68 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index ff71f2c06b72..9dd74268b2d8 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -226,7 +226,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
> 	struct cached_fids *cfids;
> 	const char *npath;
> 	int retries = 0, cur_sleep = 1;
>-	__le32 lease_flags = 0;
>
> 	if (cifs_sb->root == NULL)
> 		return -ENOENT;
>@@ -236,9 +235,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
>
> 	ses = tcon->ses;
> 	cfids = tcon->cfids;
>-
> 	if (!cfids)
> 		return -EOPNOTSUPP;
>+
> replay_again:
> 	/* reinitialize for possible replay */
> 	flags = 0;
>@@ -306,24 +305,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
> 			rc = -ENOENT;
> 			goto out;
> 		}
>-		if (dentry->d_parent && server->dialect >= SMB30_PROT_ID) {
>-			struct cached_fid *parent_cfid;
>-
>-			spin_lock(&cfids->cfid_list_lock);
>-			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
>-				if (parent_cfid->dentry == dentry->d_parent) {
>-					if (!cfid_is_valid(parent_cfid))
>-						break;
>-
>-					cifs_dbg(FYI, "found a parent cached file handle\n");
>-					lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
>-					memcpy(pfid->parent_lease_key, parent_cfid->fid.lease_key,
>-					       SMB2_LEASE_KEY_SIZE);
>-					break;
>-				}
>-			}
>-			spin_unlock(&cfids->cfid_list_lock);
>-		}
> 	}
> 	cfid->dentry = dentry;
> 	cfid->tcon = tcon;
>@@ -350,20 +331,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
> 	rqst[0].rq_iov = open_iov;
> 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
>
>-	oparms = (struct cifs_open_parms) {
>-		.tcon = tcon,
>-		.path = path,
>-		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
>-		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES |
>-				   FILE_READ_EA,
>-		.disposition = FILE_OPEN,
>-		.fid = pfid,
>-		.lease_flags = lease_flags,
>-		.replay = !!(retries),
>-	};
>-
>-	rc = SMB2_open_init(tcon, server,
>-			    &rqst[0], &oplock, &oparms, utf16_path);
>+	oparms = CIFS_OPARMS(cifs_sb, tcon, path,
>+			     FILE_READ_DATA | FILE_READ_ATTRIBUTES | FILE_READ_EA, FILE_OPEN,
>+			     cifs_create_options(cifs_sb, CREATE_NOT_FILE), 0);
>+	oparms.fid = pfid;
>+	oparms.replay = !!retries;
>+
>+	rc = SMB2_open_init(tcon, server, &rqst[0], &oplock, &oparms, utf16_path);
> 	if (rc)
> 		goto oshr_free;
> 	smb2_set_next_command(tcon, &rqst[0]);
>diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
>index e5372c2c799d..b60af27668bb 100644
>--- a/fs/smb/client/dir.c
>+++ b/fs/smb/client/dir.c
>@@ -189,10 +189,9 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
> 	struct inode *newinode = NULL;
> 	int disposition;
> 	struct TCP_Server_Info *server = tcon->ses->server;
>+	struct cached_fid *parent_cfid;
> 	struct cifs_open_parms oparms;
>-	struct cached_fid *parent_cfid = NULL;
> 	int rdwr_for_fscache = 0;
>-	__le32 lease_flags = 0;
>
> 	*oplock = 0;
> 	if (tcon->ses->server->oplocks)
>@@ -314,25 +313,11 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
> 	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
> 		create_options |= CREATE_OPTION_READONLY;
>
>-
> retry_open:
>-	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
>-		parent_cfid = NULL;
>-		spin_lock(&tcon->cfids->cfid_list_lock);
>-		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
>-			if (parent_cfid->dentry == direntry->d_parent) {
>-				if (!cfid_is_valid(parent_cfid))
>-					break;
>-
>-				cifs_dbg(FYI, "found a parent cached file handle\n");
>-				lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
>-				memcpy(fid->parent_lease_key, parent_cfid->fid.lease_key,
>-				       SMB2_LEASE_KEY_SIZE);
>-				parent_cfid->dirents.is_valid = false;
>-				break;
>-			}
>-		}
>-		spin_unlock(&tcon->cfids->cfid_list_lock);
>+	parent_cfid = find_cached_dir(tcon->cfids, direntry->d_parent, CFID_LOOKUP_DENTRY);
>+	if (parent_cfid) {
>+		parent_cfid->dirents.is_valid = false;
>+		close_cached_dir(parent_cfid);
> 	}
>
> 	oparms = (struct cifs_open_parms) {
>@@ -343,7 +328,6 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
> 		.disposition = disposition,
> 		.path = full_path,
> 		.fid = fid,
>-		.lease_flags = lease_flags,
> 		.mode = mode,
> 	};
> 	rc = server->ops->open(xid, &oparms, oplock, buf);
>diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
>index 8ccdd1a3ba2c..6d643b8b9547 100644
>--- a/fs/smb/client/smb2inode.c
>+++ b/fs/smb/client/smb2inode.c
>@@ -1120,6 +1120,8 @@ smb2_mkdir(const unsigned int xid, struct inode *parent_inode, umode_t mode,
> {
> 	struct cifs_open_parms oparms;
>
>+	drop_cached_dir(tcon->cfids, name, CFID_LOOKUP_PATH);
>+
> 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES,
> 			     FILE_CREATE, CREATE_NOT_FILE, mode);
> 	return smb2_compound_op(xid, tcon, cifs_sb,
>diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>index 07ba61583114..2474ac18b85e 100644
>--- a/fs/smb/client/smb2pdu.c
>+++ b/fs/smb/client/smb2pdu.c
>@@ -2419,7 +2419,8 @@ add_lease_context(struct TCP_Server_Info *server,
> 	if (iov[num].iov_base == NULL)
> 		return -ENOMEM;
> 	iov[num].iov_len = server->vals->create_lease_size;
>-	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
>+	/* keep the requested oplock level in case of just setting ParentLeaseKey */
>+	req->RequestedOplockLevel = *oplock;
> 	*num_iovec = num + 1;
> 	return 0;
> }
>@@ -3001,6 +3002,50 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
> 	return rc;
> }
>
>+/*
>+ * When opening a path, set ParentLeaseKey in @oparms if its parent is cached.
>+ * We only have RH caching for dirs, so skip this on mkdir, unlink, rmdir.
>+ *
>+ * Ref: MS-SMB2 3.3.5.9 and MS-FSA 2.1.5.1
>+ *
>+ * Return: 0 if ParentLeaseKey was set in @oparms, -errno otherwise.
>+ */
>+static int check_cached_parent(struct cached_fids *cfids, struct cifs_open_parms *oparms)
>+{
>+	struct cached_fid *cfid;
>+	const char *parent_path, *path;
>+
>+	if (!cfids || !oparms || !oparms->cifs_sb || !*oparms->path)
>+		return -EINVAL;
>+
>+	if ((oparms->disposition == FILE_CREATE && oparms->create_options == CREATE_NOT_FILE) ||
>+	    oparms->desired_access == DELETE)
>+		return -EOPNOTSUPP;
>+
>+	path = oparms->path;
>+	parent_path = strrchr(path, CIFS_DIR_SEP(oparms->cifs_sb));
>+	if (!parent_path)
>+		return -ENOENT;
>+
>+	parent_path = kstrndup(path, parent_path - path, GFP_KERNEL);
>+	if (!parent_path)
>+		return -ENOMEM;
>+
>+	cfid = find_cached_dir(cfids, parent_path, CFID_LOOKUP_PATH);
>+	kfree(parent_path);
>+
>+	if (!cfid)
>+		return -ENOENT;
>+
>+	cifs_dbg(FYI, "%s: found cached parent for path: %s\n", __func__, oparms->path);
>+
>+	memcpy(oparms->fid->parent_lease_key, cfid->fid.lease_key, SMB2_LEASE_KEY_SIZE);
>+	oparms->lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
>+	close_cached_dir(cfid);
>+
>+	return 0;
>+}
>+
> int
> SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
> 	       struct smb_rqst *rqst, __u8 *oplock,
>@@ -3077,20 +3122,35 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
> 	iov[1].iov_len = uni_path_len;
> 	iov[1].iov_base = path;
>
>-	if ((!server->oplocks) || (tcon->no_lease))
>+	if (!server->oplocks || tcon->no_lease)
> 		*oplock = SMB2_OPLOCK_LEVEL_NONE;
>
>-	if (!(server->capabilities & SMB2_GLOBAL_CAP_LEASING) ||
>-	    *oplock == SMB2_OPLOCK_LEVEL_NONE)
>-		req->RequestedOplockLevel = *oplock;
>-	else if (!(server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING) &&
>-		  (oparms->create_options & CREATE_NOT_FILE))
>-		req->RequestedOplockLevel = *oplock; /* no srv lease support */
>-	else {
>-		rc = add_lease_context(server, req, iov, &n_iov,
>-				       oparms->fid->lease_key, oplock,
>-				       oparms->fid->parent_lease_key,
>-				       oparms->lease_flags);
>+	req->RequestedOplockLevel = *oplock;
>+
>+	/*
>+	 * MS-SMB2 "Product Behavior" says Windows only checks/sets ParentLeaseKey when a lease is
>+	 * requested for the child/target.
>+	 * Practically speaking, adding the lease context with ParentLeaseKey set, even with oplock
>+	 * none, works fine.
>+	 * As a precaution, however, only set it for oplocks != none.
>+	 */
>+	if ((server->capabilities & SMB2_GLOBAL_CAP_LEASING) &&
>+	    *oplock != SMB2_OPLOCK_LEVEL_NONE) {
>+		rc = -EOPNOTSUPP;
>+		if (server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
>+			rc = check_cached_parent(tcon->cfids, oparms);
>+
>+		/*
>+		 * -ENOENT just means we couldn't find a cached parent, but we do have dir leasing,
>+		 * so try requesting a level II oplock for the child path.
>+		 */
>+		if ((!rc || rc == -ENOENT) && *oplock == SMB2_OPLOCK_LEVEL_NONE)
>+			*oplock = SMB2_OPLOCK_LEVEL_II;
>+
>+		if (*oplock != SMB2_OPLOCK_LEVEL_NONE)
>+			rc = add_lease_context(server, req, iov, &n_iov, oparms->fid->lease_key,
>+					       oplock, oparms->fid->parent_lease_key,
>+					       oparms->lease_flags);
> 		if (rc)
> 			return rc;
> 	}
>-- 
>2.49.0
>
>

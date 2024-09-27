Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6713B19AD85;
	Fri, 27 Sep 2024 17:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727459662; cv=none; b=JqBuD3yTh01BEVNNhrl76AjVAHQowAeLOLoeBlAgYrcofBqU7KQdRE/KO4I0HvwhWHiTkYk6tVFz68vjaCiZZ9RDU3DG26oitw1qvVHHhfUGBWsYaQoo3aqr3EYIqzCDpO4U8uWrFx3gt0CqDaCVacqWQWFexUrvQkQ6hf3UzdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727459662; c=relaxed/simple;
	bh=Bs0+ZQ00k6b6n77D5RwR3tpkdSUu21GqAYaGbrL5ToM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6bvn+Mljc2YexkJtDr1vksgmyPluc6k1YtaNMafl01vAyGS5OZ2/LGXu0H+D+YT6WpUpO/sLON+1nh/O6nGPqMaEtOSjg59s6pJ4NT0lTDBJ75i90i1wGZuc1b3Mf5hvxGQ+AgeG/zvUtB8GR9dbWJl4U/mPkpDcKOju+CFJl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yYz3gLwR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=raTATjTl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yYz3gLwR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=raTATjTl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yYz3gLwR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="raTATjTl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yYz3gLwR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="raTATjTl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A3711F395;
	Fri, 27 Sep 2024 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727459652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRksCyNsjAZYOqep4hPfKpRSgu7uZlJnzWFD6Ch4CZo=;
	b=yYz3gLwRjMMczsWPHiZVgKr2VVxTDcE0BZqLJh2Wde94yit+CJzHesgspsuPEjtQKkrVCq
	qBRfXpmR+Wy3TGp5K0DWamE7QXPLr0pWQRLNGapfMAuwv8PePauXi1TGoKktxayzw4bTXs
	2GXH52cfHyzb9QAvQce+n8vbmYNnicA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727459652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRksCyNsjAZYOqep4hPfKpRSgu7uZlJnzWFD6Ch4CZo=;
	b=raTATjTlNe7T4qM0ymlU+j329vCvNKyRGUfzm1Ra89vTyUbHJWthV/Oce+3JorgKY+a3SP
	JirAueGPTsF+1nDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yYz3gLwR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=raTATjTl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727459652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRksCyNsjAZYOqep4hPfKpRSgu7uZlJnzWFD6Ch4CZo=;
	b=yYz3gLwRjMMczsWPHiZVgKr2VVxTDcE0BZqLJh2Wde94yit+CJzHesgspsuPEjtQKkrVCq
	qBRfXpmR+Wy3TGp5K0DWamE7QXPLr0pWQRLNGapfMAuwv8PePauXi1TGoKktxayzw4bTXs
	2GXH52cfHyzb9QAvQce+n8vbmYNnicA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727459652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRksCyNsjAZYOqep4hPfKpRSgu7uZlJnzWFD6Ch4CZo=;
	b=raTATjTlNe7T4qM0ymlU+j329vCvNKyRGUfzm1Ra89vTyUbHJWthV/Oce+3JorgKY+a3SP
	JirAueGPTsF+1nDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27AB51386E;
	Fri, 27 Sep 2024 17:54:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FKoYOEPx9mYOYQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 27 Sep 2024 17:54:11 +0000
Date: Fri, 27 Sep 2024 14:54:31 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] cifs: Add support for creating SFU symlinks
Message-ID: <re4m7ihhapjrjiu6acrnuex3jgbanz27uacig37xkereilmdcp@jzsjtdeg5wnb>
References: <20240912120548.15877-7-pali@kernel.org>
 <20240915194545.14779-1-pali@kernel.org>
 <20240915194545.14779-2-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240915194545.14779-2-pali@kernel.org>
X-Rspamd-Queue-Id: 9A3711F395
X-Spam-Score: -6.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-6.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,manguebit.com,gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Hi Pali,

On 09/15, Pali Roh=E1r wrote:
>Linux cifs client can already detect SFU symlinks and reads it content
>(target location). But currently is not able to create new symlink. So
>implement this missing support.
>
>When 'sfu' mount option is specified and 'mfsymlinks' is not specified then
>create new symlinks in SFU-style. This will provide full SFU compatibility
>of symlinks when mounting cifs share with 'sfu' option. 'mfsymlinks' option
>override SFU for better Apple compatibility as explained in fs_context.c
>file in smb3_update_mnt_flags() function.
>
>Extend __cifs_sfu_make_node() function, which now can handle also S_IFLNK
>type and refactor structures passed to sync_write() in this function, by
>splitting SFU type and SFU data from original combined struct win_dev as
>combined fixed-length struct cannot be used for variable-length symlinks.
>
>Signed-off-by: Pali Roh=E1r <pali@kernel.org>
>---
> fs/smb/client/cifspdu.h    |  6 ---
> fs/smb/client/cifsproto.h  |  4 ++
> fs/smb/client/fs_context.c | 13 ++++---
> fs/smb/client/link.c       |  3 ++
> fs/smb/client/smb2ops.c    | 80 +++++++++++++++++++++++++++++---------
> 5 files changed, 77 insertions(+), 29 deletions(-)
>
>diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
>index a2072ab9e586..c3b6263060b0 100644
>--- a/fs/smb/client/cifspdu.h
>+++ b/fs/smb/client/cifspdu.h
>@@ -2573,12 +2573,6 @@ typedef struct {
> } __attribute__((packed)) FIND_FILE_STANDARD_INFO; /* level 0x1 FF resp d=
ata */
>
>
>-struct win_dev {
>-	unsigned char type[8]; /* IntxCHR or IntxBLK or LnxFIFO or LnxSOCK */
>-	__le64 major;
>-	__le64 minor;
>-} __attribute__((packed));
>-
> struct fea {
> 	unsigned char EA_flags;
> 	__u8 name_len;
>diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
>index 497bf3c447bc..791bddac0396 100644
>--- a/fs/smb/client/cifsproto.h
>+++ b/fs/smb/client/cifsproto.h
>@@ -676,6 +676,10 @@ char *extract_sharename(const char *unc);
> int parse_reparse_point(struct reparse_data_buffer *buf,
> 			u32 plen, struct cifs_sb_info *cifs_sb,
> 			bool unicode, struct cifs_open_info_data *data);
>+int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
>+			 struct dentry *dentry, struct cifs_tcon *tcon,
>+			 const char *full_path, umode_t mode, dev_t dev,
>+			 const char *symname);
> int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> 		       struct dentry *dentry, struct cifs_tcon *tcon,
> 		       const char *full_path, umode_t mode, dev_t dev);
>diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
>index bc926ab2555b..2f0c3894b0f7 100644
>--- a/fs/smb/client/fs_context.c
>+++ b/fs/smb/client/fs_context.c
>@@ -1896,14 +1896,17 @@ void smb3_update_mnt_flags(struct cifs_sb_info *ci=
fs_sb)
> 	if (ctx->mfsymlinks) {
> 		if (ctx->sfu_emul) {
> 			/*
>-			 * Our SFU ("Services for Unix" emulation does not allow
>-			 * creating symlinks but does allow reading existing SFU
>-			 * symlinks (it does allow both creating and reading SFU
>-			 * style mknod and FIFOs though). When "mfsymlinks" and
>+			 * Our SFU ("Services for Unix") emulation allows now
>+			 * creating new and reading existing SFU symlinks.
>+			 * Older Linux kernel versions were not able to neither
>+			 * read existing nor create new SFU symlinks. But
>+			 * creating and reading SFU style mknod and FIFOs was
>+			 * supported for long time. When "mfsymlinks" and
> 			 * "sfu" are both enabled at the same time, it allows
> 			 * reading both types of symlinks, but will only create
> 			 * them with mfsymlinks format. This allows better
>-			 * Apple compatibility (probably better for Samba too)
>+			 * Apple compatibility, compatibility with older Linux
>+			 * kernel clients (probably better for Samba too)
> 			 * while still recognizing old Windows style symlinks.
> 			 */
> 			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
>diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
>index 80099bbb333b..47ddeb7fa111 100644
>--- a/fs/smb/client/link.c
>+++ b/fs/smb/client/link.c
>@@ -606,6 +606,9 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *in=
ode,
> 	/* BB what if DFS and this volume is on different share? BB */
> 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
> 		rc =3D create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
>+	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
>+		rc =3D __cifs_sfu_make_node(xid, inode, direntry, pTcon,
>+					  full_path, S_IFLNK, 0, symname);
> #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> 	} else if (pTcon->unix_ext) {
> 		rc =3D CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
>diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>index 9c2d065d3cc4..2c251e9a3a30 100644
>--- a/fs/smb/client/smb2ops.c
>+++ b/fs/smb/client/smb2ops.c
>@@ -5055,9 +5055,10 @@ static int smb2_next_header(struct TCP_Server_Info =
*server, char *buf,
> 	return 0;
> }
>
>-static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
>+int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> 				struct dentry *dentry, struct cifs_tcon *tcon,
>-				const char *full_path, umode_t mode, dev_t dev)
>+				const char *full_path, umode_t mode, dev_t dev,
>+				const char *symname)
> {
> 	struct TCP_Server_Info *server =3D tcon->ses->server;
> 	struct cifs_open_parms oparms;
>@@ -5065,30 +5066,64 @@ static int __cifs_sfu_make_node(unsigned int xid, =
struct inode *inode,
> 	struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> 	struct cifs_fid fid;
> 	unsigned int bytes_written;
>-	struct win_dev pdev =3D {};
>-	struct kvec iov[2];
>+	u8 type[8];
>+	int type_len =3D 0;
>+	struct {
>+		__le64 major;
>+		__le64 minor;
>+	} __packed pdev =3D {};
>+	__le16 *symname_utf16 =3D NULL;
>+	u8 *data =3D NULL;
>+	int data_len =3D 0;
>+	struct kvec iov[3];
> 	__u32 oplock =3D server->oplocks ? REQ_OPLOCK : 0;
> 	int rc;
>
> 	switch (mode & S_IFMT) {
> 	case S_IFCHR:
>-		memcpy(pdev.type, "IntxCHR\0", 8);
>+		type_len =3D 8;
>+		memcpy(type, "IntxCHR\0", type_len);
> 		pdev.major =3D cpu_to_le64(MAJOR(dev));
> 		pdev.minor =3D cpu_to_le64(MINOR(dev));
>+		data =3D (u8 *)&pdev;
>+		data_len =3D sizeof(pdev);
> 		break;
> 	case S_IFBLK:
>-		memcpy(pdev.type, "IntxBLK\0", 8);
>+		type_len =3D 8;
>+		memcpy(type, "IntxBLK\0", type_len);
> 		pdev.major =3D cpu_to_le64(MAJOR(dev));
> 		pdev.minor =3D cpu_to_le64(MINOR(dev));
>+		data =3D (u8 *)&pdev;
>+		data_len =3D sizeof(pdev);
>+		break;
>+	case S_IFLNK:
>+		type_len =3D 8;
>+		memcpy(type, "IntxLNK\1", type_len);
>+		symname_utf16 =3D cifs_strndup_to_utf16(symname, strlen(symname),
>+						      &data_len, cifs_sb->local_nls,
>+						      NO_MAP_UNI_RSVD);
>+		if (!symname_utf16) {
>+			rc =3D -ENOMEM;
>+			goto out;
>+		}
>+		data_len -=3D 2; /* symlink is without trailing wide-nul */
>+		data =3D (u8 *)symname_utf16;

Can't S_IFLNK be handled somewhere else/other function?  mknod doesn't
support S_IFLNK, so this seems out of place.

And even though it's unreachable (AFAICS), cifs_sfu_make_node() calls
this with @symname =3D=3D NULL (caught with gcc -fanalyzer).


Cheers,

Enzo

> 		break;
> 	case S_IFSOCK:
>-		strscpy(pdev.type, "LnxSOCK");
>+		type_len =3D 8;
>+		strscpy(type, "LnxSOCK");
>+		data =3D (u8 *)&pdev;
>+		data_len =3D sizeof(pdev);
> 		break;
> 	case S_IFIFO:
>-		strscpy(pdev.type, "LnxFIFO");
>+		type_len =3D 8;
>+		strscpy(type, "LnxFIFO");
>+		data =3D (u8 *)&pdev;
>+		data_len =3D sizeof(pdev);
> 		break;
> 	default:
>-		return -EPERM;
>+		rc =3D -EPERM;
>+		goto out;
> 	}
>
> 	oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path, GENERIC_WRITE,
>@@ -5098,17 +5133,26 @@ static int __cifs_sfu_make_node(unsigned int xid, =
struct inode *inode,
>
> 	rc =3D server->ops->open(xid, &oparms, &oplock, NULL);
> 	if (rc)
>-		return rc;
>+		goto out;
>
>-	io_parms.pid =3D current->tgid;
>-	io_parms.tcon =3D tcon;
>-	io_parms.length =3D sizeof(pdev);
>-	iov[1].iov_base =3D &pdev;
>-	iov[1].iov_len =3D sizeof(pdev);
>+	if (type_len + data_len > 0) {
>+		io_parms.pid =3D current->tgid;
>+		io_parms.tcon =3D tcon;
>+		io_parms.length =3D type_len + data_len;
>+		iov[1].iov_base =3D type;
>+		iov[1].iov_len =3D type_len;
>+		iov[2].iov_base =3D data;
>+		iov[2].iov_len =3D data_len;
>+
>+		rc =3D server->ops->sync_write(xid, &fid, &io_parms,
>+					     &bytes_written,
>+					     iov, ARRAY_SIZE(iov)-1);
>+	}
>
>-	rc =3D server->ops->sync_write(xid, &fid, &io_parms,
>-				     &bytes_written, iov, 1);
> 	server->ops->close(xid, tcon, &fid);
>+
>+out:
>+	kfree(symname_utf16);
> 	return rc;
> }
>
>@@ -5120,7 +5164,7 @@ int cifs_sfu_make_node(unsigned int xid, struct inod=
e *inode,
> 	int rc;
>
> 	rc =3D __cifs_sfu_make_node(xid, inode, dentry, tcon,
>-				  full_path, mode, dev);
>+				  full_path, mode, dev, NULL);
> 	if (rc)
> 		return rc;

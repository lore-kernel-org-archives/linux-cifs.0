Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477E233595A
	for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 19:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758136522; cv=none; b=oOUzMCoJiP5yXGFqn2j1dOHJDnt7EgFLB7QZbYEELZWpmBQgaM+y0PxV9n2gJSiD1+NWca2uCYXTszs9+WzihmrHS/HiAfQnmHz8i+sRiyn7Yy46bwh3JVmevDndaLpMuWU94sNSvXv89djbtWUAw3Tcahaw2Tv2PSVVfLoMGZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758136522; c=relaxed/simple;
	bh=hjE9T1joDxYFqm5lw/vgcTuMep5i4PtB4grwE1AKHao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfAkuDU7LpwNEkM3vHV7PdUED7fnSDIzheTTIqz4HrVzzg4sOu01CHKZP3yL9Idf5ePWpvfPZm7zzDLZPqMmxsTaq4VVs1gOjtGq/wnuScz0wbZLOrHfdt07HGPCaD0fq9LmHL9r8ckuiYcqe5gBnbJ5q2fDRtz2OO2knKU9xjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BQcl+ttx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jt6R/jDx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BQcl+ttx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jt6R/jDx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BQcl+ttx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jt6R/jDx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BQcl+ttx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jt6R/jDx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A171344B8;
	Wed, 17 Sep 2025 19:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758136518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tYggm7KuuOlYhxl4DtR8YXDLUTROJKeuf6ipNsoAsiU=;
	b=BQcl+ttxlgb88XbT+jBquvE+5gVCus8RAiSUROQP1XBiA7fXcNEAevt+Hbnt0+vKIPa997
	DiXoLIFT7yVDvXNebsKRsJUMsSrgPqW+oW6OX+SWXgmersX/rsH24FyU2c1HE1EdHwY+ix
	u5AFOK5mLykT3vV8fExIorNNLwdmXd8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758136518;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tYggm7KuuOlYhxl4DtR8YXDLUTROJKeuf6ipNsoAsiU=;
	b=jt6R/jDxljtrQ09rlBxmrldgUwCEal++osfTqiTBFC4fQy7ot+5DlEfEuoB9eUcyCIX+sg
	DSEUm5SPJXYjCABA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BQcl+ttx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="jt6R/jDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758136518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tYggm7KuuOlYhxl4DtR8YXDLUTROJKeuf6ipNsoAsiU=;
	b=BQcl+ttxlgb88XbT+jBquvE+5gVCus8RAiSUROQP1XBiA7fXcNEAevt+Hbnt0+vKIPa997
	DiXoLIFT7yVDvXNebsKRsJUMsSrgPqW+oW6OX+SWXgmersX/rsH24FyU2c1HE1EdHwY+ix
	u5AFOK5mLykT3vV8fExIorNNLwdmXd8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758136518;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tYggm7KuuOlYhxl4DtR8YXDLUTROJKeuf6ipNsoAsiU=;
	b=jt6R/jDxljtrQ09rlBxmrldgUwCEal++osfTqiTBFC4fQy7ot+5DlEfEuoB9eUcyCIX+sg
	DSEUm5SPJXYjCABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A3B81368D;
	Wed, 17 Sep 2025 19:15:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aJFYGMUIy2hMYQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 17 Sep 2025 19:15:17 +0000
Date: Wed, 17 Sep 2025 16:15:07 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, Frank Sorenson <sorenson@redhat.com>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix filename matching of deferred files
Message-ID: <v4g2cku4itpiqvfiy6aktcey5rjc2jt5kcoknf36hm45p3nxgu@wb5ho6aoy6dc>
References: <20250917190322.765293-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250917190322.765293-1-pc@manguebit.org>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 1A171344B8
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01

On 09/17, Paulo Alcantara wrote:
>Fix the following case where the client would end up closing both
>deferred files (foo.tmp & foo) after unlink(foo) due to strstr() call
>in cifs_close_deferred_file_under_dentry():
>
>  fd1 = openat(AT_FDCWD, "foo", O_WRONLY|O_CREAT|O_TRUNC, 0666);
>  fd2 = openat(AT_FDCWD, "foo.tmp", O_WRONLY|O_CREAT|O_TRUNC, 0666);
>  close(fd1);
>  close(fd2);
>  unlink("foo");
>
>Fixes: e3fc065682eb ("cifs: Deferred close performance improvements")
>Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>Cc: Enzo Matsumiya <ematsumiya@suse.de>
>Cc: Frank Sorenson <sorenson@redhat.com>
>Cc: David Howells <dhowells@redhat.com>
>Cc: linux-cifs@vger.kernel.org
>---
> fs/smb/client/cifsproto.h |  4 ++--
> fs/smb/client/inode.c     |  6 +++---
> fs/smb/client/misc.c      | 36 +++++++++++++++---------------------
> 3 files changed, 20 insertions(+), 26 deletions(-)
>
>diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
>index c34c533b2efa..e8fba98690ce 100644
>--- a/fs/smb/client/cifsproto.h
>+++ b/fs/smb/client/cifsproto.h
>@@ -312,8 +312,8 @@ extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
>
> extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
>
>-extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
>-				const char *path);
>+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
>+					   struct dentry *dentry);
>
> extern void cifs_mark_open_handles_for_deleted_file(struct inode *inode,
> 				const char *path);
>diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>index 11d442e8b3d6..1703f1285d36 100644
>--- a/fs/smb/client/inode.c
>+++ b/fs/smb/client/inode.c
>@@ -1984,7 +1984,7 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
> 	}
>
> 	netfs_wait_for_outstanding_io(inode);
>-	cifs_close_deferred_file_under_dentry(tcon, full_path);
>+	cifs_close_deferred_file_under_dentry(tcon, dentry);
> #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> 	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
> 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
>@@ -2538,10 +2538,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
> 		goto cifs_rename_exit;
> 	}
>
>-	cifs_close_deferred_file_under_dentry(tcon, from_name);
>+	cifs_close_deferred_file_under_dentry(tcon, source_dentry);
> 	if (d_inode(target_dentry) != NULL) {
> 		netfs_wait_for_outstanding_io(d_inode(target_dentry));
>-		cifs_close_deferred_file_under_dentry(tcon, to_name);
>+		cifs_close_deferred_file_under_dentry(tcon, target_dentry);
> 	}
>
> 	rc = cifs_do_rename(xid, source_dentry, from_name, target_dentry,
>diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
>index da23cc12a52c..350542d57249 100644
>--- a/fs/smb/client/misc.c
>+++ b/fs/smb/client/misc.c
>@@ -832,33 +832,28 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
> 		kfree(tmp_list);
> 	}
> }
>-void
>-cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
>+
>+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
>+					   struct dentry *dentry)
> {
>-	struct cifsFileInfo *cfile;
> 	struct file_list *tmp_list, *tmp_next_list;
>-	void *page;
>-	const char *full_path;
>+	struct cifsFileInfo *cfile;
> 	LIST_HEAD(file_head);
>
>-	page = alloc_dentry_path();
> 	spin_lock(&tcon->open_file_lock);
> 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>-		full_path = build_path_from_dentry(cfile->dentry, page);
>-		if (strstr(full_path, path)) {
>-			if (delayed_work_pending(&cfile->deferred)) {
>-				if (cancel_delayed_work(&cfile->deferred)) {
>-					spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>-					cifs_del_deferred_close(cfile);
>-					spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>+		if (cfile->dentry == dentry &&
>+		    delayed_work_pending(&cfile->deferred) &&
>+		    cancel_delayed_work(&cfile->deferred)) {
>+			spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>+			cifs_del_deferred_close(cfile);
>+			spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>
>-					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>-					if (tmp_list == NULL)
>-						break;
>-					tmp_list->cfile = cfile;
>-					list_add_tail(&tmp_list->list, &file_head);
>-				}
>-			}
>+			tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>+			if (tmp_list == NULL)
>+				break;
>+			tmp_list->cfile = cfile;
>+			list_add_tail(&tmp_list->list, &file_head);
> 		}
> 	}
> 	spin_unlock(&tcon->open_file_lock);
>@@ -868,7 +863,6 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
> 		list_del(&tmp_list->list);
> 		kfree(tmp_list);
> 	}
>-	free_dentry_path(page);
> }
>
> /*

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers,

Enzo

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DE222A4EB
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 18:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308176; cv=none; b=aHFwqrw0CzdZyr90h7P4e3jI3nt8zchiyqWMKG5a7L/N7keRrqUKtA4APZjvz5H+MjP6mGhev7qxw4x/Q34D4PJ40B0EYO8LemxqY+LudnLjpfv3l4EACbzQwJ+YYp+fuPDwWtIoN6mMmoSf4VNvM93WN6sfflL0Esv3tJqyJzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308176; c=relaxed/simple;
	bh=ZcwLgUgawzYvYInpoVDZo1QCEfzesncVjT4D2wiMxAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eomuwQgn+Wa2Z8Ug80NiqqQ3EhVDAjoxd3TrzvPt5BACCSjdDhh1CeVTMbYuCmrjeTwrVrl+1U1tgetXMGuZzjGuVEYJNGYpzHKf6mL0/iRKc0RNLuEal+bcEsZZE7itZpHXVioqePY4LLwUTxJeakT9xCAfV4+rYlS6u+ToFlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xNwqe6GZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UY5E5T+U; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZMEywGl2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IARbdsy1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xNwqe6GZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UY5E5T+U";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZMEywGl2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IARbdsy1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AB14A21B34;
	Fri, 19 Sep 2025 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758308172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=670QiZtAVNf9cd9mI+4PY2Nvr0nXc0lN8xJQCYgCvV0=;
	b=xNwqe6GZjcnZaiDl6YymzrrHkvVoDYh8gVdDXaZ/tIa3sob8uVesVK/3HEph0fk4apxQZm
	MlvsY9MWB/+tWWuSJxuGi4GW5BDVp6bgGO25nT1zL4Eskqa8aB9rhxvEDTW8SschlHPQDF
	MER4MYiBEXvBM1nhO7tZIIja45pzDkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758308172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=670QiZtAVNf9cd9mI+4PY2Nvr0nXc0lN8xJQCYgCvV0=;
	b=UY5E5T+Ubb7affln1zherHoGY6SV2F2h8Nl0NTv5wn460RMmnHpGgbvaMLnogfdRHsjVHX
	eXODyh54mabdUzCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZMEywGl2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IARbdsy1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758308171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=670QiZtAVNf9cd9mI+4PY2Nvr0nXc0lN8xJQCYgCvV0=;
	b=ZMEywGl2Z80JJhFHzuUrq2s1RCoh25pBnO40MDycC8iM0E4miVPL/j1eA/ZcWI7FnN3kIe
	HPM9tTsl3tjlpwdnQQPGO5wKcwC/J8kxd9kWtHDrSgnh/RkWwLGtyPRZ59pR2tkT5+4cI+
	uFx6SEW9w8CUJrFhaKVrzSGAPu9lplA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758308171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=670QiZtAVNf9cd9mI+4PY2Nvr0nXc0lN8xJQCYgCvV0=;
	b=IARbdsy1cgh6xTSHMit/CIc0tnVGku3mHUyKVUxqFhaAS4nZrY3sQfHq4GbcV65VI1uJOR
	dJhiAwTHvOEb4HDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3617D13A78;
	Fri, 19 Sep 2025 18:56:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pwlzO0qnzWhUfAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 19 Sep 2025 18:56:10 +0000
Date: Fri, 19 Sep 2025 15:56:04 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 6/6] smb: client: remove unused fid_lock
Message-ID: <vejzedrdjdxuhvhcncgu55wbjdx3hgnhwwtsu5745kltrbqdz6@ifl5dvvoby3f>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
 <20250919152441.228774-6-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250919152441.228774-6-henrique.carvalho@suse.com>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: AB14A21B34
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:dkim,suse.de:email]
X-Spam-Score: -4.01

On 09/19, Henrique Carvalho wrote:
>The fid_lock in struct cached_fid does not currently provide any real
>synchronization. Previously, it had the intention to prevent a double
>release of the dentry, but every change to cfid->dentry is already
>protected either by cfid_list_lock (while the entry is in the list) or
>happens after the cfid has been removed (so no other thread should find
>it).
>
>Since there is no scenario in which fid_lock prevents any race, it is
>vestigial and can be removed along with its associated
>spin_lock()/spin_unlock() calls.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/cached_dir.c | 17 +++--------------
> fs/smb/client/cached_dir.h |  1 -
> 2 files changed, 3 insertions(+), 15 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index 22b1c5dd4913..eba7ce047b63 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -527,10 +527,9 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
> 				spin_unlock(&cifs_sb->tlink_tree_lock);
> 				goto done;
> 			}
>-			spin_lock(&cfid->fid_lock);
>+
> 			tmp_list->dentry = cfid->dentry;
> 			cfid->dentry = NULL;
>-			spin_unlock(&cfid->fid_lock);
>
> 			list_add_tail(&tmp_list->entry, &entry);
> 		}
>@@ -613,14 +612,9 @@ static void cached_dir_put_work(struct work_struct *work)
> {
> 	struct cached_fid *cfid = container_of(work, struct cached_fid,
> 					       put_work);
>-	struct dentry *dentry;
>-
>-	spin_lock(&cfid->fid_lock);
>-	dentry = cfid->dentry;
>+	dput(cfid->dentry);
> 	cfid->dentry = NULL;
>-	spin_unlock(&cfid->fid_lock);
>
>-	dput(dentry);
> 	queue_work(serverclose_wq, &cfid->close_work);
> }
>
>@@ -678,7 +672,6 @@ static struct cached_fid *init_cached_dir(const char *path)
> 	INIT_LIST_HEAD(&cfid->entry);
> 	INIT_LIST_HEAD(&cfid->dirents.entries);
> 	mutex_init(&cfid->dirents.de_mutex);
>-	spin_lock_init(&cfid->fid_lock);
> 	kref_init(&cfid->refcount);
> 	return cfid;
> }
>@@ -730,7 +723,6 @@ static void cfids_laundromat_worker(struct work_struct *work)
> {
> 	struct cached_fids *cfids;
> 	struct cached_fid *cfid, *q;
>-	struct dentry *dentry;
> 	LIST_HEAD(entry);
>
> 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
>@@ -757,12 +749,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
> 	list_for_each_entry_safe(cfid, q, &entry, entry) {
> 		list_del(&cfid->entry);
>
>-		spin_lock(&cfid->fid_lock);
>-		dentry = cfid->dentry;
>+		dput(cfid->dentry);
> 		cfid->dentry = NULL;
>-		spin_unlock(&cfid->fid_lock);
>
>-		dput(dentry);
> 		if (cfid->is_open) {
> 			spin_lock(&cifs_tcp_ses_lock);
> 			++cfid->tcon->tc_count;
>diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
>index aa12382b4249..f4bdb8b28ffa 100644
>--- a/fs/smb/client/cached_dir.h
>+++ b/fs/smb/client/cached_dir.h
>@@ -41,7 +41,6 @@ struct cached_fid {
> 	unsigned long last_access_time; /* jiffies of when last accessed */
> 	struct kref refcount;
> 	struct cifs_fid fid;
>-	spinlock_t fid_lock;
> 	struct cifs_tcon *tcon;
> 	struct dentry *dentry;
> 	struct work_struct put_work;
>-- 
>2.50.1

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>

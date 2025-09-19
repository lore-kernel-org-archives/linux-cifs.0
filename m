Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF63F31C584
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758297354; cv=none; b=mLrmLIW3zHE9haf1Lcn7yMKLMtEUuJ2nVe51X2yvuvYOeHW/u2cEgj5hYI2F6a2/YI8YLbhW29QuOb8a+XKLZDLpCat6Xm12P/s2XBuYQY74v9PcAIs4KEHX0fyU2XMK5dQreqvr+5Z/XZ+xOXxk7ft9ZZdVn4l5uOhcV3bizCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758297354; c=relaxed/simple;
	bh=gBq+yGq0UJNtK5oz9gcUaVnW6nxBhLGWLdPaMeNMZZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kp3kqa67WzTLydV1GhikCtzHOihY/HIPO905J96izYHITssRIPAzyRLT4pc8kkQJVcBwLLZRWzGS8j+KVZZXbn0YnBLPKi34/BnixrLlrQhZh4xrJAbDHlwATeTh7W3cxmvWQvahLLpw8C1Ii1s3O5XeXIxft148aSu5u68Z38A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RWqWKW4K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rNV0zsVw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RWqWKW4K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rNV0zsVw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RWqWKW4K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rNV0zsVw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RWqWKW4K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rNV0zsVw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BEDA833684;
	Fri, 19 Sep 2025 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758297349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uucD3FdTf22K9sHNkn2dKBWYpWxPy9D3FGLWK/l3rbs=;
	b=RWqWKW4KOxXqHWJHLLXszBFTc+tRD41wKP1WHsLlUDy3a0+eYGRreaOiaWNHlK8tlJgDiE
	3SfBlcUt9TFwvpoQEdk5MY//20FLo75OulAIW7OgydaYzuzvAP6Rm/rramx4femab2lZig
	oBuRQ10KlEb2w/UmCaNVizaVLWv93Hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758297349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uucD3FdTf22K9sHNkn2dKBWYpWxPy9D3FGLWK/l3rbs=;
	b=rNV0zsVwFHQDdKq9NlS70TCyt5EpU/QpJpPzIRHOmfSD4NNXCpp+bSe4l7e2J85vHm5+qj
	deyUjCIuJV7HoaDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RWqWKW4K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rNV0zsVw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758297349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uucD3FdTf22K9sHNkn2dKBWYpWxPy9D3FGLWK/l3rbs=;
	b=RWqWKW4KOxXqHWJHLLXszBFTc+tRD41wKP1WHsLlUDy3a0+eYGRreaOiaWNHlK8tlJgDiE
	3SfBlcUt9TFwvpoQEdk5MY//20FLo75OulAIW7OgydaYzuzvAP6Rm/rramx4femab2lZig
	oBuRQ10KlEb2w/UmCaNVizaVLWv93Hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758297349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uucD3FdTf22K9sHNkn2dKBWYpWxPy9D3FGLWK/l3rbs=;
	b=rNV0zsVwFHQDdKq9NlS70TCyt5EpU/QpJpPzIRHOmfSD4NNXCpp+bSe4l7e2J85vHm5+qj
	deyUjCIuJV7HoaDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D14313A39;
	Fri, 19 Sep 2025 15:55:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Izl8BQV9zWjqRwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 19 Sep 2025 15:55:49 +0000
Date: Fri, 19 Sep 2025 12:55:43 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/6] smb: client: ensure open_cached_dir_by_dentry() only
 returns valid cfid
Message-ID: <u6r7m2pum2gusoazpzerzxu2attq5a4blighytwnkqnujayr7m@rzr6i6triw63>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250919152441.228774-1-henrique.carvalho@suse.com>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: BEDA833684
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
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.de:dkim,suse.de:email]
X-Spam-Score: -4.01

On 09/19, Henrique Carvalho wrote:
>open_cached_dir_by_dentry() was exposing an invalid cached directory to
>callers. The validity check outside the function was exclusively based
>on cfid->time.
>
>Add validity check before returning success and introduce
>is_valid_cached_dir() helper for consistent checks across the code.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/cached_dir.c | 9 +++++----
> fs/smb/client/cached_dir.h | 6 ++++++
> fs/smb/client/dir.c        | 2 +-
> fs/smb/client/inode.c      | 2 +-
> 4 files changed, 13 insertions(+), 6 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index b69daeb1301b..63dc9add4f13 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -36,9 +36,8 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
> 			 * fully cached or it may be in the process of
> 			 * being deleted due to a lease break.
> 			 */
>-			if (!cfid->time || !cfid->has_lease) {
>+			if (!is_valid_cached_dir(cfid))
> 				return NULL;
>-			}
> 			kref_get(&cfid->refcount);
> 			return cfid;
> 		}
>@@ -194,7 +193,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 	 * Otherwise, it is either a new entry or laundromat worker removed it
> 	 * from @cfids->entries.  Caller will put last reference if the latter.
> 	 */
>-	if (cfid->has_lease && cfid->time) {
>+	if (is_valid_cached_dir(cfid)) {
> 		cfid->last_access_time = jiffies;
> 		spin_unlock(&cfids->cfid_list_lock);
> 		*ret_cfid = cfid;
>@@ -233,7 +232,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
> 				if (parent_cfid->dentry == dentry->d_parent) {
> 					cifs_dbg(FYI, "found a parent cached file handle\n");
>-					if (parent_cfid->has_lease && parent_cfid->time) {
>+					if (is_valid_cached_dir(parent_cfid)) {
> 						lease_flags
> 							|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
> 						memcpy(pfid->parent_lease_key,
>@@ -420,6 +419,8 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> 	spin_lock(&cfids->cfid_list_lock);
> 	list_for_each_entry(cfid, &cfids->entries, entry) {
> 		if (dentry && cfid->dentry == dentry) {
>+			if (!is_valid_cached_dir(cfid))
>+				break;
> 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
> 			kref_get(&cfid->refcount);
> 			*ret_cfid = cfid;
>diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
>index 46b5a2fdf15b..aa12382b4249 100644
>--- a/fs/smb/client/cached_dir.h
>+++ b/fs/smb/client/cached_dir.h
>@@ -64,6 +64,12 @@ struct cached_fids {
> 	struct delayed_work laundromat_work;
> };
>
>+static inline bool
>+is_valid_cached_dir(struct cached_fid *cfid)
>+{
>+	return cfid->time && cfid->has_lease;
>+}
>+
> extern struct cached_fids *init_cached_dirs(void);
> extern void free_cached_dirs(struct cached_fids *cfids);
> extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
>index 5223edf6d11a..56c59b67ecc2 100644
>--- a/fs/smb/client/dir.c
>+++ b/fs/smb/client/dir.c
>@@ -322,7 +322,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
> 		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
> 			if (parent_cfid->dentry == direntry->d_parent) {
> 				cifs_dbg(FYI, "found a parent cached file handle\n");
>-				if (parent_cfid->has_lease && parent_cfid->time) {
>+				if (is_valid_cached_dir(parent_cfid)) {
> 					lease_flags
> 						|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
> 					memcpy(fid->parent_lease_key,
>diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>index fe453a4b3dc8..9c8b8bd20edd 100644
>--- a/fs/smb/client/inode.c
>+++ b/fs/smb/client/inode.c
>@@ -2639,7 +2639,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
> 		return true;
>
> 	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
>-		if (cfid->time && cifs_i->time > cfid->time) {
>+		if (cifs_i->time > cfid->time) {
> 			close_cached_dir(cfid);
> 			return false;
> 		}
>-- 
>2.50.1

Reviwed-by: Enzo Matsumiya <ematsumiya@suse.de>

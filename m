Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D20217F3D
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 18:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308097; cv=none; b=uIUHKSQeYKWFCsnrbMTV/B9VwBkgbusI6by02UrwygY3RUHDBe8YOs0AR//9tU4sovEtYP2f67F+AV/qyReoyoOFmx7JkOtv4P5/5iZzqn2Un69e4ktTktmK9809mcQMpdIBmRhh8SDDjHeHe1IlSRi11aeXMqPQLkQScQXepGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308097; c=relaxed/simple;
	bh=VG+x0o8oCCV6xzGU4Q2Xb4tNsW6G8GsEMMQYnbY4gP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMZDPMscffL9d2PGItULbUZzDBgx+hpZ+b31C8eUx46dAS5X8uDQOXRsrE+5wy9XCtj2s5fVzswMn/4VtvENn2sxSVx0QjsRrFchGR/hNddnhkF/F2eHL3G2XQP+GnLPP5QkUWwx1OnMD1Qued5+96bpeMhJc9fiSD0rt9KAb7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fkro3dHm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CMnnvXXT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fkro3dHm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CMnnvXXT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fkro3dHm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CMnnvXXT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fkro3dHm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CMnnvXXT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 36B3A22407;
	Fri, 19 Sep 2025 18:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758308093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nLiJBEshFxQzrl+9qpwViaLe/SrQpJQQgbpaVnjoQYI=;
	b=fkro3dHmUKF1cy85uXWmJa72XZO0GtcIEdKvVpFzJseUH5+NIofjej5l8Qoxy429rxYTdE
	cKunWg/MFE7ApkleUYG78ZZrDr15j8BPWddgooMcdMuZkkePOcIzmB0OkJrUBomZxwQKBg
	YEDLdUCDWCtlCjspqqLaJ8BiLWkvc7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758308093;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nLiJBEshFxQzrl+9qpwViaLe/SrQpJQQgbpaVnjoQYI=;
	b=CMnnvXXTuPVAbs0O9Gtg46ixJLpyYHSFgaYYFnF1U+N1mTssoj4JSb0haxmYWd416V7Li5
	sfS7ZxvX3T8XGeDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758308093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nLiJBEshFxQzrl+9qpwViaLe/SrQpJQQgbpaVnjoQYI=;
	b=fkro3dHmUKF1cy85uXWmJa72XZO0GtcIEdKvVpFzJseUH5+NIofjej5l8Qoxy429rxYTdE
	cKunWg/MFE7ApkleUYG78ZZrDr15j8BPWddgooMcdMuZkkePOcIzmB0OkJrUBomZxwQKBg
	YEDLdUCDWCtlCjspqqLaJ8BiLWkvc7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758308093;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nLiJBEshFxQzrl+9qpwViaLe/SrQpJQQgbpaVnjoQYI=;
	b=CMnnvXXTuPVAbs0O9Gtg46ixJLpyYHSFgaYYFnF1U+N1mTssoj4JSb0haxmYWd416V7Li5
	sfS7ZxvX3T8XGeDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9B4E13A78;
	Fri, 19 Sep 2025 18:54:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cQZAIPymzWgAfAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 19 Sep 2025 18:54:52 +0000
Date: Fri, 19 Sep 2025 15:54:46 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 3/6] smb: client: short-circuit negative lookups when
 parent dir is fully cached
Message-ID: <grz6l27jndyzc4mztngv2wslloimamsvu6jztchbijsmzitybr@nl6xeyjqh3wp>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
 <20250919152441.228774-3-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250919152441.228774-3-henrique.carvalho@suse.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On 09/19, Henrique Carvalho wrote:
>When the parent directory has a valid and complete cached enumeration we
>can assume that negative dentries are not present in the directory, thus
>we can return without issuing a request.
>
>This reduces traffic for common ENOENT when the directory entries are
>cached.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/dir.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
> 1 file changed, 47 insertions(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
>index 56c59b67ecc2..d382fc76974f 100644
>--- a/fs/smb/client/dir.c
>+++ b/fs/smb/client/dir.c
>@@ -683,6 +683,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
> 	const char *full_path;
> 	void *page;
> 	int retry_count = 0;
>+	struct cached_fid *cfid = NULL;
>
> 	xid = get_xid();
>
>@@ -722,6 +723,29 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
> 		cifs_dbg(FYI, "non-NULL inode in lookup\n");
> 	} else {
> 		cifs_dbg(FYI, "NULL inode in lookup\n");

(unrelated to the patch)
Can a dentry ever get here being positive?  AFAICS it can't, but I might
have missed some obscure code path.

>+
>+		/*
>+		 * We can only rely on negative dentries having the same
>+		 * spelling as the cached dirent if case insensitivity is
>+		 * forced on mount.
>+		 *
>+		 * XXX: if servers correctly announce Case Sensitivity Search
>+		 * on GetInfo of FileFSAttributeInformation, then we can take
>+		 * correct action even if case insensitive is not forced on
>+		 * mount.
>+		 *
>+		 */

If you're going into the case-sensitiveness hole, several other things
can be fixed re: cached dirs (and other areas, as we know lol):

   # mount ... /mnt # not using nocase
   # cd /mnt
   # mkdir abc
   # ls
   # ls abc
   # ls ABC
   # ls ABc
   # cat /proc/fs/cifs/open_dirs
   # Version:1
   # Format:
   # <tree id> <sess id> <persistent fid> <path>
   Num entries: 4
   0x5 0x1d800a8000021 0x760051e015     \ABc       valid file info, valid dirents
   0x5 0x1d800a8000021 0x760051e012     \ABC       valid file info, valid dirents
   0x5 0x1d800a8000021 0x760051e00f     \abc       valid file info, valid dirents
   0x5 0x1d800a8000021 0x760051e00c        valid file info, valid dirents

So, as I understand, for the 'nocase' cases, it might be worth building
the path string and comparing with strcasecmp().

Other than that, this seems to work fine though.

(also, extra line at the end of the comment)

>+		if (pTcon->nocase && !open_cached_dir_by_dentry(pTcon, direntry->d_parent, &cfid)) {
>+			/*
>+			 * dentry is negative and parent is fully cached:
>+			 * we can assume file does not exist
>+			 */
>+			if (cfid->dirents.is_valid) {
>+				close_cached_dir(cfid);
>+				goto out;
>+			}
>+			close_cached_dir(cfid);
>+		}
> 	}
> 	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
> 		 full_path, d_inode(direntry));
>@@ -755,6 +779,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
> 		}
> 		newInode = ERR_PTR(rc);
> 	}
>+
>+out:
> 	free_dentry_path(page);
> 	cifs_put_tlink(tlink);
> 	free_xid(xid);
>@@ -765,7 +791,11 @@ static int
> cifs_d_revalidate(struct inode *dir, const struct qstr *name,
> 		  struct dentry *direntry, unsigned int flags)
> {
>-	struct inode *inode;
>+	struct inode *inode = NULL;
>+	struct cifs_sb_info *cifs_sb;
>+	struct cifs_tcon *tcon;
>+	struct cached_fid *cfid;
>+

extra line

> 	int rc;
>
> 	if (flags & LOOKUP_RCU)
>@@ -812,6 +842,22 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
>
> 			return 1;
> 		}
>+	} else {
>+		inode = d_inode(direntry->d_parent);

arg @dir == d_inode(direntry->d_parent))

>+		cifs_sb = CIFS_SB(inode->i_sb);
>+		tcon = cifs_sb_master_tcon(cifs_sb);

Positive dentries are the common case, so maybe move tcon and cifs_sb
declarations to this scope?

>+
>+		if (!open_cached_dir_by_dentry(tcon, direntry->d_parent, &cfid)) {
>+			/*
>+			 * dentry is negative and parent is fully cached:
>+			 * we can assume file does not exist
>+			 */
>+			if (cfid->dirents.is_valid) {
>+				close_cached_dir(cfid);
>+				return 1;
>+			}
>+			close_cached_dir(cfid);
>+		}
> 	}
>
> 	/*
>-- 
>2.50.1


Cheers,

Enzo

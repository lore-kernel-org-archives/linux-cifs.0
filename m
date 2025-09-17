Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F7732129F
	for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 15:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758123852; cv=none; b=SaXM4npSn/b2QwnVvP2OvNzPIfKRnP5my2t31KcgiuPJ4JUgQ8iC7dczT/bcgf7nXSvzZACiu2X1S9w2VvSxk4psGgf/XmutWFxcx0dBmsb3bmEfGMct7TnE9KRDNqnN5PBtb4xIZNxTMnWA/amupcEDRv1pQch/XZIZNcX5Hag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758123852; c=relaxed/simple;
	bh=PJmoD/E8O8uxpsqeSypLtYbo8FmTldXE1zVyfEVlzFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLC+KJjynCk0lHYnguqxRjdVu5STZjC6vdOCv/MkhwhPTlgYcVWxUpLex9rWZRapA+DFiLTz65ZK3V9RsV2eSf1ZKMMECydWn1N687RXc5tFruDkulBgoqZX6OSi24iWcf53b5HgxmRYTPsaxMSgzLZnydwz9PjlFdwYdEHfbPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tn2ywudo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=48nzq6rb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tn2ywudo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=48nzq6rb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tn2ywudo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="48nzq6rb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tn2ywudo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="48nzq6rb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A59720A6E;
	Wed, 17 Sep 2025 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758123848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xNisu7KOHochkZfaDmdXl5yHp4zuov5jJ/9YPIvrK64=;
	b=tn2ywudoySnG6ih5Cln+tw+0k1CTHAuW5oxhFPK5QYOg9fI6mWtoXHYFk38vjvYKWo7ZQV
	H44OBV4DhysFsb71Lkao0b4/y6CU/D8Co8a933c84Z9eAYXaGunklLz2wxwM7wjjFO9dvT
	o4vfIWXoNSFD3tjfoaN64qUH8W5u4qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758123848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xNisu7KOHochkZfaDmdXl5yHp4zuov5jJ/9YPIvrK64=;
	b=48nzq6rbddFJL3zalUR6p66xCFbveBaD61wirNT+vNBKg9BMOB8G8LbBSlv45exTSv24KS
	HdkVd/drL+YOeaDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758123848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xNisu7KOHochkZfaDmdXl5yHp4zuov5jJ/9YPIvrK64=;
	b=tn2ywudoySnG6ih5Cln+tw+0k1CTHAuW5oxhFPK5QYOg9fI6mWtoXHYFk38vjvYKWo7ZQV
	H44OBV4DhysFsb71Lkao0b4/y6CU/D8Co8a933c84Z9eAYXaGunklLz2wxwM7wjjFO9dvT
	o4vfIWXoNSFD3tjfoaN64qUH8W5u4qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758123848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xNisu7KOHochkZfaDmdXl5yHp4zuov5jJ/9YPIvrK64=;
	b=48nzq6rbddFJL3zalUR6p66xCFbveBaD61wirNT+vNBKg9BMOB8G8LbBSlv45exTSv24KS
	HdkVd/drL+YOeaDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB75B137C3;
	Wed, 17 Sep 2025 15:44:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sKBZJEfXymjjIwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 17 Sep 2025 15:44:07 +0000
Date: Wed, 17 Sep 2025 12:43:57 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, Frank Sorenson <sorenson@redhat.com>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix filename matching of deferred files
Message-ID: <6crvzn6sgy7ia35jeim3wpvliww3alxkaije6sh55ggyvhitwm@nefxffuhgn3z>
References: <20250917003701.694520-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250917003701.694520-1-pc@manguebit.org>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.80

On 09/16, Paulo Alcantara wrote:
>Fix the following case where the client would end up closing both
>deferred files (foo.tmp & foo) after unlink(foo) due to strstr() call
>in cifs_close_deferred_file_under_dentry():
>
>  fd1 = openat(AT_FDCWD, "foo", O_WRONLY|O_CREAT|O_TRUNC, 0666);
>  fd2 = openat(AT_FDCWD, "foo.tmp", O_WRONLY|O_CREAT|O_TRUNC, 0666);
>  close(fd1);
>  close(fd2);
>  unlink("foo");

Good catch, but since you're at it, wouldn't it be more elegant to
replace @path with @dentry and just compare cfile->dentry == dentry?

Would also improve performance by saving calls to
build_path_from_dentry().


Cheers,

Enzo

>Fixes: e3fc065682eb ("cifs: Deferred close performance improvements")
>Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>Cc: Frank Sorenson <sorenson@redhat.com>
>Cc: David Howells <dhowells@redhat.com>
>Cc: linux-cifs@vger.kernel.org
>---
> fs/smb/client/misc.c | 25 ++++++++++++-------------
> 1 file changed, 12 insertions(+), 13 deletions(-)
>
>diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
>index da23cc12a52c..09d5fa3638c9 100644
>--- a/fs/smb/client/misc.c
>+++ b/fs/smb/client/misc.c
>@@ -845,20 +845,19 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
> 	spin_lock(&tcon->open_file_lock);
> 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
> 		full_path = build_path_from_dentry(cfile->dentry, page);
>-		if (strstr(full_path, path)) {
>-			if (delayed_work_pending(&cfile->deferred)) {
>-				if (cancel_delayed_work(&cfile->deferred)) {
>-					spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>-					cifs_del_deferred_close(cfile);
>-					spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>+		if (IS_ERR(full_path) || strcmp(full_path, path))
>+			continue;
>+		if (delayed_work_pending(&cfile->deferred) &&
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
>-- 
>2.51.0
>
>

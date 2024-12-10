Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3A4BA3D
	for <linux-cifs@vger.kernel.org>; Tue, 10 Dec 2024 05:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806971; cv=none; b=gBFK/7cudpZMNozBiBQG3XSWgB8v1NbRhwveR0yb0yXc5l3EWMd6/lwnQN0vLYZHxwga4MLELeHikVpupFKs3MMHit4njR1e3FuKOwGgwZ45vU39IprGYhFSXqcYl/wS/WqgHfzcjd1S+prfdZPTsOdnmOxTFx2u1SNEsPJVyVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806971; c=relaxed/simple;
	bh=bYaUhYHNFSUaWQL5OhthbAPx91wVK1k0WhnrOs7PLMM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q6GkTNZRLwdk1nq10aUTEbpzJSxKshMJHzaz0J76pboG/KCxRroquZ7U2zeSgws5GvPoG0mjGPsVeefph7wmetifEekm+ax5RpePiis9U3NoGFJpHCOlZHVPyQA3odbpzT5BAy6hgMy6yWCJ4tq95P46dr0dcCB+s/qIG7fyUbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z2XPeCJF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8NRShMiq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z2XPeCJF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8NRShMiq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z2XPeCJF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8NRShMiq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z2XPeCJF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8NRShMiq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 77F9B210FA;
	Tue, 10 Dec 2024 05:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733806967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LczjmvcsrmS/zvZIOKtz8Znhhh36up0GmbZNOvVmtQI=;
	b=z2XPeCJF6vTVM3KBAHt6Of8k9N8a+rph7ocdG7hrOj9zvYvgSf3x0RlwT3j6qkkEkyRzc2
	RLORBFjFBjS7ROK/D+S0LvIeaDUicyp/AMcEB3FCb7OPg4EZwTnERiBgQIQNm1VDkPrtzk
	WwwS2hr1WngzIlDrqKi9oL+Q3/aajC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733806967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LczjmvcsrmS/zvZIOKtz8Znhhh36up0GmbZNOvVmtQI=;
	b=8NRShMiqus7YVJGyFvVsgREVNFBMFF5QySfx7ACdsmwGt0T2apjfvw5e7lZQH4jhOIb+1p
	SerRD5xbGzm7QmCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z2XPeCJF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8NRShMiq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733806967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LczjmvcsrmS/zvZIOKtz8Znhhh36up0GmbZNOvVmtQI=;
	b=z2XPeCJF6vTVM3KBAHt6Of8k9N8a+rph7ocdG7hrOj9zvYvgSf3x0RlwT3j6qkkEkyRzc2
	RLORBFjFBjS7ROK/D+S0LvIeaDUicyp/AMcEB3FCb7OPg4EZwTnERiBgQIQNm1VDkPrtzk
	WwwS2hr1WngzIlDrqKi9oL+Q3/aajC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733806967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LczjmvcsrmS/zvZIOKtz8Znhhh36up0GmbZNOvVmtQI=;
	b=8NRShMiqus7YVJGyFvVsgREVNFBMFF5QySfx7ACdsmwGt0T2apjfvw5e7lZQH4jhOIb+1p
	SerRD5xbGzm7QmCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36CCD138D2;
	Tue, 10 Dec 2024 05:02:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +GvZN3TLV2fJaQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 10 Dec 2024 05:02:44 +0000
Date: Tue, 10 Dec 2024 16:02:30 +1100
From: David Disseldorp <ddiss@suse.de>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com,
 senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH] ksmbd: set ATTR_CTIME flags when setting mtime
Message-ID: <20241210160230.5318c4a9.ddiss@suse.de>
In-Reply-To: <20241206153858.12505-1-linkinjeon@kernel.org>
References: <20241206153858.12505-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 77F9B210FA
X-Spam-Level: 
X-Spamd-Result: default: False [-2.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,chromium.org,talpey.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -2.01
X-Spam-Flag: NO

Hi Namjae,

On Sat,  7 Dec 2024 00:38:58 +0900, Namjae Jeon wrote:
...
>  fs/smb/server/smb2pdu.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 5a70df87074c..803b35b89513 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -6026,15 +6026,13 @@ static int set_file_basic_info(struct ksmbd_file *fp,
>  		attrs.ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
>  	}
>  
> -	attrs.ia_valid |= ATTR_CTIME;

This will mean that we now only call through to notify_change() on atime
or mtime updates, which doesn't seem right. Can we get here with a valid
file_info->ChangeTime only (i.e. no atime/mtime change)?

>  	if (file_info->ChangeTime)
> -		attrs.ia_ctime = ksmbd_NTtimeToUnix(file_info->ChangeTime);
> -	else
> -		attrs.ia_ctime = inode_get_ctime(inode);
> +		inode_set_ctime_to_ts(inode,
> +				ksmbd_NTtimeToUnix(file_info->ChangeTime));
>  
>  	if (file_info->LastWriteTime) {
>  		attrs.ia_mtime = ksmbd_NTtimeToUnix(file_info->LastWriteTime);
> -		attrs.ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET);
> +		attrs.ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET | ATTR_CTIME);
>  	}
>  
>  	if (file_info->Attributes) {
> @@ -6076,8 +6074,6 @@ static int set_file_basic_info(struct ksmbd_file *fp,
>  			return -EACCES;
>  
>  		inode_lock(inode);
> -		inode_set_ctime_to_ts(inode, attrs.ia_ctime);
> -		attrs.ia_valid &= ~ATTR_CTIME;
>  		rc = notify_change(idmap, dentry, &attrs, NULL);
>  		inode_unlock(inode);
>  	}


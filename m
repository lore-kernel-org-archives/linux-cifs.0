Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC0A34BA2A
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298547; cv=none; b=rv5HrywoblUPDGlM6WO3WweCDvg5azTfe2pz1hbRzatnem6+7/3F/vWK50SVD7qAeaFPdgIMKBWvr/J3IszDtyJtdlaa6MOLSiRGJgNSaPmjT8JJZKkNr2L+aCzNs3mxh4rsXB4472ZJYKW7Ku54tdkyjV+Bd7s9DO2NvF4hfuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298547; c=relaxed/simple;
	bh=Ek9mRw3TkUKknlRlOa+LGjlTOliwzQHtd9lAHStO4qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcWlpca9fcPZPVS7N3Vlmg250B0cuALDSUq7kPETyOk8gJ1OLOGE4nszwoedc4GgIbenLFqlGHRlCx3St63WEroRClbAGPW4GRqYXmtn4uve7sMfx4tcfVey12k2BiHOpNJkWn6xQoacuv0ZbHfs3CaHIpz/qcZ6MWirhzquvJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FK+NLAlE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=K+rB12FZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FK+NLAlE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=K+rB12FZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FK+NLAlE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="K+rB12FZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FK+NLAlE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="K+rB12FZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 980BC1F7E3;
	Fri, 19 Sep 2025 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758298543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xjWrFyE6Vs/GxEouqGVmhTkxaoDKb/3kpQadOYw7xTM=;
	b=FK+NLAlE9G85IyueEV4W3Dojw/M+Qtk1WwGpREBi8F+HZIH+0bGxQpEHdvy3ozGEvojVam
	YmixowKIASWm4uJDLlIt9M1xzpdgneSW+PxWDIfvH8IljxlF+cs7tPdp7LezCYVVZSY9L7
	9GkP3u8hCILJ5pMZHkSUzHbKHftG5BE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758298543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xjWrFyE6Vs/GxEouqGVmhTkxaoDKb/3kpQadOYw7xTM=;
	b=K+rB12FZRkCxso/ndd7iASyOSx9lv83ItVsjuRLyOj/5Xxlaaf9Zf6Fx3fhGm3TUREi7Xt
	KpnFuxRZ6pFlHrDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758298543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xjWrFyE6Vs/GxEouqGVmhTkxaoDKb/3kpQadOYw7xTM=;
	b=FK+NLAlE9G85IyueEV4W3Dojw/M+Qtk1WwGpREBi8F+HZIH+0bGxQpEHdvy3ozGEvojVam
	YmixowKIASWm4uJDLlIt9M1xzpdgneSW+PxWDIfvH8IljxlF+cs7tPdp7LezCYVVZSY9L7
	9GkP3u8hCILJ5pMZHkSUzHbKHftG5BE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758298543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xjWrFyE6Vs/GxEouqGVmhTkxaoDKb/3kpQadOYw7xTM=;
	b=K+rB12FZRkCxso/ndd7iASyOSx9lv83ItVsjuRLyOj/5Xxlaaf9Zf6Fx3fhGm3TUREi7Xt
	KpnFuxRZ6pFlHrDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 24BBF13A39;
	Fri, 19 Sep 2025 16:15:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OAwgN66BzWg3TgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 19 Sep 2025 16:15:42 +0000
Date: Fri, 19 Sep 2025 13:15:32 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/6] smb: client: short-circuit in
 open_cached_dir_by_dentry() if !dentry
Message-ID: <ymccofyxeol5vvdm5rbxg37qmegfwrifnhmxfk25h474frgo55@dxpmgtsqucdc>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
 <20250919152441.228774-2-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250919152441.228774-2-henrique.carvalho@suse.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.991];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On 09/19, Henrique Carvalho wrote:
>When dentry is NULL,

I know this is good practice, but... Is a NULL dentry ever passed
down to open_cached_dir_by_dentry()?

All callers I checked (even with your series applied), seems to
guarantee a non-NULL dentry at this point.

Either way,
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>

> the current code acquires the spinlock and traverses
>the entire list, but the condition (dentry && cfid->dentry == dentry)
>ensures no match will ever be found.
>
>Return -ENOENT early in this case, avoiding unnecessary lock acquisition
>and list traversal.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/cached_dir.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index 63dc9add4f13..df6cabd0966d 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -416,9 +416,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> 	if (cfids == NULL)
> 		return -EOPNOTSUPP;
>
>+	if (!dentry)
>+		return -ENOENT;
>+
> 	spin_lock(&cfids->cfid_list_lock);
> 	list_for_each_entry(cfid, &cfids->entries, entry) {
>-		if (dentry && cfid->dentry == dentry) {
>+		if (cfid->dentry == dentry) {
> 			if (!is_valid_cached_dir(cfid))
> 				break;
> 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
>-- 
>2.50.1
>

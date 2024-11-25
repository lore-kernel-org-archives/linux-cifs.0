Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F272C2AD25
	for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551813; cv=none; b=Lw6hIaA5ikP4A7BFV7qMWj/AxyunhHg8NESRzAkKjPbxwzFYPAKdOPwcFB2yf7Q6YuKWCqMueHvqPB1sWnJqIw0ZRlU20XwRcbsLu8WbolT4gem4baH8wKUaRPyhv3hcjgHwDMfcSFlyMLBQV1kr7xT5tu4VmUJYTbN9y4Mc2n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551813; c=relaxed/simple;
	bh=2MipmUeX50xs/NCWz2nDTbgSpGFkLcZ/+24FvGOEyqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4nik7J/PN6GphS5IxSIVnRuWLpjY5+mjgYTi5a3v0AgfecZUq/Hkc7q5CPtxWOav40W8OXhVTG2MzKW20j1WKe1xsoGbWX9OAa/qOyLoeH+QY8lVhlJc71k3BpXU6teUiUBN+8zmTH9xX5RjjqebrwdPcSAUYsj9hoiIYaEpdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vyyeD/ct; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BXHk/hzp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vyyeD/ct; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BXHk/hzp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vyyeD/ct";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BXHk/hzp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vyyeD/ct";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BXHk/hzp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 045A4211A3;
	Mon, 25 Nov 2024 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732551810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J9FqqRlYrXUm2ypWIRGTFgmcMEzbPzbnXVP06Wn9QMU=;
	b=vyyeD/ctqLsGFlEoFVtl8v/yaLrhZFkZ8DlU9z5KNXGjpSpeSZ/cdOUhQqXaTqT7dRe08X
	FPvUHQ1AxSEsx9pZyc2grCjht5HT6rgNc7arzpM1BOKr9bQ+bt5xEh7EidE5Y/9O0wVdS/
	SWchBEqDnS9eC0jOCQnTZ1vA8pI5UFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732551810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J9FqqRlYrXUm2ypWIRGTFgmcMEzbPzbnXVP06Wn9QMU=;
	b=BXHk/hzpy6avtfTogxbn7Zu+ySRykdd9Q8G5bPijBpMKAWmC3El/0X2FIvrRalcVPJEUCI
	sW1AFZy2buqI/nCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="vyyeD/ct";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="BXHk/hzp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732551810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J9FqqRlYrXUm2ypWIRGTFgmcMEzbPzbnXVP06Wn9QMU=;
	b=vyyeD/ctqLsGFlEoFVtl8v/yaLrhZFkZ8DlU9z5KNXGjpSpeSZ/cdOUhQqXaTqT7dRe08X
	FPvUHQ1AxSEsx9pZyc2grCjht5HT6rgNc7arzpM1BOKr9bQ+bt5xEh7EidE5Y/9O0wVdS/
	SWchBEqDnS9eC0jOCQnTZ1vA8pI5UFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732551810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J9FqqRlYrXUm2ypWIRGTFgmcMEzbPzbnXVP06Wn9QMU=;
	b=BXHk/hzpy6avtfTogxbn7Zu+ySRykdd9Q8G5bPijBpMKAWmC3El/0X2FIvrRalcVPJEUCI
	sW1AFZy2buqI/nCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80DB613890;
	Mon, 25 Nov 2024 16:23:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oT5oEoGkRGcIcAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 25 Nov 2024 16:23:29 +0000
Date: Mon, 25 Nov 2024 13:21:12 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] smb: client: change return value in
 open_cached_dir_by_dentry() if !cfids
Message-ID: <jd3kud65onl4sylbhis7qdgce7jxliekvoofknmrmswxrvnhd4@dnukbqq663hc>
References: <20241123011437.375637-1-henrique.carvalho@suse.com>
 <20241123011437.375637-3-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241123011437.375637-3-henrique.carvalho@suse.com>
X-Rspamd-Queue-Id: 045A4211A3
X-Spam-Score: -4.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,manguebit.com,gmail.com,microsoft.com,talpey.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 11/22, Henrique Carvalho wrote:
>Change return value from -ENOENT to -EOPNOTSUPP to maintain consistency
>with the return value of open_cached_dir() for the same case. This
>change is safe as the only calling function does not differentiate
>between these return values.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
>V1 -> V2: Split patch and addressed review comments
>
> fs/smb/client/cached_dir.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index 85a8cc04e2c81..d8b1cf1043c35 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -396,7 +396,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> 	struct cached_fids *cfids = tcon->cfids;
>
> 	if (cfids == NULL)
>-		return -ENOENT;
>+		return -EOPNOTSUPP;
>
> 	spin_lock(&cfids->cfid_list_lock);
> 	list_for_each_entry(cfid, &cfids->entries, entry) {

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers

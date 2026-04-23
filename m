Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCA224BD03
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776934909; cv=none; b=jIbExj9+njWvLjZnLTfj5ad28NP84kN5ph8zSxn4VALTmaUVAw8uGeLsJJuOxT+2rH65IO7z1k9+zdj7kqQmuKtJPqfXCZ75mba4lhg8DCV2P8sSivBOFRZuAcKX2XREj3J1zedLqgc1ax/E+Oe8CmDZ7BLcVvLaZKZL4L83caU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776934909; c=relaxed/simple;
	bh=AARDKdCZFp0Qa9px4VGp2Y1JL3GvGbPcvZWxmzhmIhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzzj4fMS8o3CUeYyd7BDMtJ70OuMJ2EuJEQscZpCNmXxQOsR3Ir9ysuY0QFO5n6QOySrF+vzBcesN7EteQt6aUPiRpoF92XMNLX9CK1OdZGxKWLuqVCs02SN1WhjOzbAjUGYGB4WsB3cKCHuT0KkqfPxko8RfL9n5piQpphEHoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tb5XswPU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JysKAtO2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Txrjz0Pd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fbc61vYn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tb5XswPU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JysKAtO2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Txrjz0Pd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fbc61vYn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4E3E45BCCE;
	Thu, 23 Apr 2026 09:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776934905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vE4xbqj/Z+7+PQqRMBff6aTnGkKRnIEEMe0PYzFUraE=;
	b=tb5XswPU6iG53RgzKmOlHes81QbwtZZvw4v0jVlrP6GfDhm7JdVRJpSVL5nEP/NFyOdJeP
	Hu03YK++cwxnlwFrHJoH+zOH2SmNcJHnr5kNqzNOqKot2UvozDwJ5u6cfeHNFcv1CPTTfH
	eYWYYzr+jq0T4dukXiw2oTfhFn6zqE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776934905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vE4xbqj/Z+7+PQqRMBff6aTnGkKRnIEEMe0PYzFUraE=;
	b=JysKAtO2pAKyXbmUcuAAmGZZCHEHVzX3WUBHg1XWZY3MOBmSck7WV5fsSJ2rgCpVKzQ1yW
	N2K93HIdHxlt7vCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776934900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vE4xbqj/Z+7+PQqRMBff6aTnGkKRnIEEMe0PYzFUraE=;
	b=Txrjz0Pdp+9J9EvHuMbJkyd34B5Gt1fMHTkaN4PoHLAnh275VIS/EYzDgiq/j8YD27c3Q/
	wtcFSWzWWdcODTbIozVgpzJfd6WQlWkO/Ya2fHK8SNUi0lXdYUx9/u/sQUA20mboIX9IQE
	vXI+pGQGjZwFFlqTHeBdk8Ssm3a3aaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776934900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vE4xbqj/Z+7+PQqRMBff6aTnGkKRnIEEMe0PYzFUraE=;
	b=Fbc61vYnb3LZflzNLv1d41/Vg0bLMV+Vt/tilHbcEEf3s6vGP3MhjeUp9QFnOSXSiFB7b+
	V2Qrd8qjzhD7FhBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30EAD593A3;
	Thu, 23 Apr 2026 09:01:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OV8VCvTf6WnOEwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 23 Apr 2026 09:01:40 +0000
Date: Thu, 23 Apr 2026 11:01:39 +0200
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Steve French <sfrench@samba.org>, Arnd Bergmann <arnd@arndb.de>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Stefan Metzmacher <metze@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: hide unused cifs_debug_dirs_proc_ops
Message-ID: <mrqkpq5tp3pair2gkvgfvkf2gfniav4npp5phd6qv4j36oce6o@j4zwqqzbqjir>
References: <20260423065042.1898971-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260423065042.1898971-1-arnd@kernel.org>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,arndb.de,manguebit.org,gmail.com,microsoft.com,talpey.com,kernel.org,vger.kernel.org,lists.samba.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On 04/23, Arnd Bergmann wrote:
>From: Arnd Bergmann <arnd@arndb.de>
>
>When CONFIG_CIFS_DEBUG2 is disabled, the only reference to this
>function is hidden, causing a harmless warning:
>
>fs/smb/client/cifs_debug.c:395:30: error: 'cifs_debug_dirs_proc_ops' defined but not used [-Werror=unused-const-variable=]
>  395 | static const struct proc_ops cifs_debug_dirs_proc_ops = {
>      |                              ^~~~~~~~~~~~~~~~~~~~~~~~
>
>Make the #ifdef checks around them consistent by always using
>the DEBUG2 variant.
>
>Fixes: 63bff18d4aa0 ("smb: client: fix (remove) drop_dir_cache module parameter")

Thanks for catching that.

I sent v2/v3 of that patch changing the dependency from
CONFIG_CIFS_DEBUG2 to CONFIG_CIFS_DEBUG, can you adjust to the
latter please?


Cheers,

>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>---
> fs/smb/client/cifs_debug.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
>index f55e5cabdaee..9a2e796161d0 100644
>--- a/fs/smb/client/cifs_debug.c
>+++ b/fs/smb/client/cifs_debug.c
>@@ -306,7 +306,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
> 	LIST_HEAD(entry);
>
> 	seq_puts(m, "# Version:1\n");
>-#ifdef CONFIG_CIFS_DEBUG
>+#ifdef CONFIG_CIFS_DEBUG2
> 	seq_puts(m, "# Write 0 to this file to drop all cached directory entries\n");
> #endif /* CONFIG_CIFS_DEBUG */
> 	seq_puts(m, "# Format:\n");
>@@ -356,7 +356,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
> 	return 0;
> }
>
>-#ifdef CONFIG_CIFS_DEBUG
>+#ifdef CONFIG_CIFS_DEBUG2
> static int cifs_debug_dirs_proc_open(struct inode *inode, struct file *file)
> {
> 	return single_open(file, cifs_debug_dirs_proc_show, NULL);
>-- 
>2.39.5
>
>

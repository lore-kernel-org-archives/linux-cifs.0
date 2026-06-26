Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B003403EC
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 19:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782503664; cv=none; b=nIFoa/9CxJGpP+XCxQ3za9Wd+/fdNln4jXpGNTVEdp9EI6nSAAwdZOdxORk4FqEGP4pU5pgS+kjta5spNzotYEwGXe7RT2nMq4ML8mPzlT4x4p0biULKzvxRLuLbBL25lT/1r+avi/gcH/s/Op72bQ7uMf1ksgeMFc0M4es8KCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782503664; c=relaxed/simple;
	bh=Sy2AF2pmJueWdj4nR9iRVBEq+FcxtPAK6dR1VFaTM6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhh+SAsPaqXF7S9SbGWrXwYy1OV1jEnNaYMGGJjRNmZHrDAX+HuBLph4QJC9mWd/8D6I3gUIq7UbZBpU1GQXKmAOP/CGjSnVSVqXG7r0Avb5bvFyfyq9+8+e5eBSITrDJIeA6ZDQuUM17RZQeRfwq6Y4dG+QQc2MQRvjniuQhTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tzZUIK+8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nec67Lev; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tzZUIK+8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nec67Lev; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tzZUIK+8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nec67Lev";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tzZUIK+8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nec67Lev"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 57B337011A;
	Fri, 26 Jun 2026 19:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782503661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhwRsHZ1bbPdY2NsUegSNNtydbBFnq8I9tpd+1G17SM=;
	b=tzZUIK+8hCSnVFXAQGcDuzzHpfOe5r+bjaZsLhXMdCz+ImmNIBsyS/S5GWtyEqiUqmRLNq
	qzMOcteZKvbFCl1yPOb1K3g2iCeCSeiju4GaymL37k4HIhdg2vJ+snZ9fGJaClJTs1tZ7C
	fx9WIk9qHRjtszvxLi+iVHKWAWkaZMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782503661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhwRsHZ1bbPdY2NsUegSNNtydbBFnq8I9tpd+1G17SM=;
	b=nec67LevRUCpTIddtqVVI1d+JMd4r0Vt48SG1lfy7PZqiVs/Ucv1ZwgdrfJf556CbYsLPF
	/+zyrnohRI65RKAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782503661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhwRsHZ1bbPdY2NsUegSNNtydbBFnq8I9tpd+1G17SM=;
	b=tzZUIK+8hCSnVFXAQGcDuzzHpfOe5r+bjaZsLhXMdCz+ImmNIBsyS/S5GWtyEqiUqmRLNq
	qzMOcteZKvbFCl1yPOb1K3g2iCeCSeiju4GaymL37k4HIhdg2vJ+snZ9fGJaClJTs1tZ7C
	fx9WIk9qHRjtszvxLi+iVHKWAWkaZMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782503661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhwRsHZ1bbPdY2NsUegSNNtydbBFnq8I9tpd+1G17SM=;
	b=nec67LevRUCpTIddtqVVI1d+JMd4r0Vt48SG1lfy7PZqiVs/Ucv1ZwgdrfJf556CbYsLPF
	/+zyrnohRI65RKAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D51F3779A8;
	Fri, 26 Jun 2026 19:54:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i3FfJuzYPmrlHQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 26 Jun 2026 19:54:20 +0000
Date: Fri, 26 Jun 2026 16:54:14 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [RFC PATCH for-next] smb: client: parallelize multichannel write
 issue
Message-ID: <aj7NFpbFWdE1d0UC@suse.de>
References: <20260626161953.593789-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260626161953.593789-1-henrique.carvalho@suse.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,manguebit.org,gmail.com,microsoft.com,talpey.com,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -4.30

On 06/26, Henrique Carvalho wrote:
>I'm sending this as an RFC PATCH first so the approach and results can
>be sanity checked more broadly.
>
>The netfs writeback path issues write subrequests through the filesystem
>issue_write() callback. For multichannel, those subrequests may target
>different channels, but the issue callback is still entered serially by
>the netfs issuing context.
>
>As a result, while one channel is running the write issue path, write
>subrequests for other channels may be left waiting to be issued. This
>can limit multichannel writeback throughput because the channels are not
>kept busy independently.
>
>For multichannel sessions, queue the existing write issue path to a
>workqueue. This lets the netfs issuing context return quickly and
>continue issuing subsequent write subrequests for other channels.
>Single-channel sessions keep the existing synchronous issue path.
>
>Preliminary fio testing showed improvments in throughput by up to 2.5x
>in 4MiB writes with larger dirty limits (1g/256m), 1.4x improvement for
>1GiB writes with larger dirty limits, and is neutral when dirty limits
>keep the pipeline shallow (4m/1m).

Works great.

A few concerns for a next version inlined below.

>+	destroy_workqueue(cifs_write_issue_wq);

Make sure to flush the workqueue at the appropriate time for a clean
destroy.

>+static void __cifs_issue_write(struct netfs_io_subrequest *subreq);
>+
>+struct cifs_issue_write_work {
>+	struct work_struct work;
>+	struct netfs_io_subrequest *subreq;
>+};
>+
>+static bool cifs_write_is_mchan(struct cifs_ses *ses)
>+{
>+	bool is_mchan;
>+
>+	spin_lock(&ses->chan_lock);
>+	is_mchan = ses->chan_count > 1;
>+	spin_unlock(&ses->chan_lock);
>+
>+	return is_mchan;
>+}

Not really a concern here, but why limit it to multichannel?
AFAICS single channel mounts would also benefit from this, no?

>+static void cifs_issue_write_work_fn(struct work_struct *work)
>+{
>+	struct cifs_issue_write_work *w = container_of(work, struct cifs_issue_write_work, work);
>+
>+	__cifs_issue_write(w->subreq);
>+	kfree(w);
>+}
>+
>+static int cifs_issue_parallel_write(struct cifs_ses *ses,
>+				      struct netfs_io_subrequest *subreq)
>+{
>+	struct cifs_issue_write_work *w = kmalloc_obj(*w, GFP_NOFS);
>+
>+	if (!w)
>+		return -ENOMEM;
>+
>+	w->subreq = subreq;
>+	INIT_WORK(&w->work, cifs_issue_write_work_fn);
>+	queue_work(cifs_write_issue_wq, &w->work);
>+
>+	return 0;
>+}

I think you need to find a way to track these works somehow, so you can
e.g.:
- capture/propagate -ERESTARTSYS/-EINTR
- (and thus) properly cancel_work() when needed

I tested the patch with 4 channels and thousands of writer processes and
it worked great on a healthy scenario.

Dropping the network mid-operation shows that, after reconnect is
successful, if I kill my writers and try to umount, there are several
cifs_write_issue kworkers hanging (didn't investigate further).

>+static void cifs_issue_write(struct netfs_io_subrequest *subreq)
>+{
>+	struct cifs_io_subrequest *wdata = container_of(subreq, struct cifs_io_subrequest, subreq);
>+	struct cifs_ses *ses = tlink_tcon(wdata->req->cfile->tlink)->ses;
>+
>+	if (cifs_write_is_mchan(ses)) {
>+		int err = cifs_issue_parallel_write(ses, subreq);
>+
>+		if (!err)
>+			return;
>+	}
>+
>+	__cifs_issue_write(subreq);
>+}

cifs_issue_parallel_write() returns -ENOMEM or 0.  If it returns
-ENOMEM you really shouldn't fallback to __cifs_issue_write(), but
rather follow __cifs_issue_write() "fail" case (to make netfs aware
of the error).


Cheers,

Enzo

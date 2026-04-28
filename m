Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67744103C
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777397289; cv=none; b=gWccnsM7r7WRdsuNaKk46GirRTxGhi5chTeli/TxXmiTbOn7GyfIfjdGuqmvymD2Y5PyiaTcyvTPo+lZb2BriV7Kxdce9uqmBhW8OoXjQxRHcVpVGm4JalqC7L5ZWbHbE6X2UP1dPJgY4XdaSs/K4xdBxphQXBUURibwx8XljAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777397289; c=relaxed/simple;
	bh=KPbX1pv30BTC0s3A7tmPtHp5/BDggebdBfVKS9thBXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0+80GwPeQNqmp+HH92ez+cSMaDK0fsFC/T7dYm9c5RzIR3E1NIESXczOEENfL6CwbK/k37F3+3CgSL9EJ3ZdQgwGpCMxdIBJRRDuvmK1YTSjEiTmaM3IY44s+iGTuhnZWEflX3qAFHaci4BZFjBFhzVDbb1QbCuPnOAkSAonEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X0LrqWT8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c9rH7dtH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hCP90OEV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d7YCZN6l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X0LrqWT8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c9rH7dtH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hCP90OEV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d7YCZN6l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF7B16A846;
	Tue, 28 Apr 2026 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777397285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWMBQQmIQlrOLGZvdct5Jnr66DK2Ly0a7v6fe55vrwQ=;
	b=X0LrqWT81acP9PlwDsO+mZcNWsg39GIAusBeCn67kd4nzKjQQucOyKhLE5TkoCu8QK4SuG
	rlvtRb30wg0BHBmAN3WewpevS7jimsOMW3FG0WMfexAKbjyKt8xd71KarusneCA9cRkjMI
	D9TIY8EBqi8MVaLAKqkyJ8RdmLp7TTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777397285;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWMBQQmIQlrOLGZvdct5Jnr66DK2Ly0a7v6fe55vrwQ=;
	b=c9rH7dtHK0n5xavWlcOSbCVFsZxrcPC5EcNTPys0aIisbMQLdqEz8oua62HzLnAHHiOYdS
	g/I3kMaeERgNsBBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777397284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWMBQQmIQlrOLGZvdct5Jnr66DK2Ly0a7v6fe55vrwQ=;
	b=hCP90OEVxSywiLF6F+LnibgN6B+7t2m0KITdGENoRa2V4GHQx10sxDWK3LqM1bjBrAagqE
	LA6tVC5uxJnhfhB43y9Hvcu4VTDrmNRX5SaksrGtsqDC5Rskm8Zd7kDYDD5+/nAZ42Bfvk
	/vCjKI9FwmA4ru6o4FoiEttSuObT3n8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777397284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWMBQQmIQlrOLGZvdct5Jnr66DK2Ly0a7v6fe55vrwQ=;
	b=d7YCZN6lHzIV+RcyJrKTZGYM4SnBCXf6RpjdlGI23qIDLe87kjjemKCf+IKBIrvrVWVNI2
	K7/Kh5pCNOIBKzAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 75BD9593B0;
	Tue, 28 Apr 2026 17:28:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IGGSDiTu8GmyXgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 28 Apr 2026 17:28:04 +0000
Date: Tue, 28 Apr 2026 14:27:53 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH v3 17/19] cifs: discard functions should not return
 failure
Message-ID: <afDr5VhyWx9MIQHU@suse.de>
References: <20260428160804.281745-1-sprasad@microsoft.com>
 <20260428160804.281745-17-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260428160804.281745-17-sprasad@microsoft.com>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,manguebit.org,microsoft.com,redhat.com,suse.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 04/28, nspmangalore@gmail.com wrote:
>From: Shyam Prasad N <sprasad@microsoft.com>
>
>If discard functions for readv and query_dir return error, the
>callback functions can be skipped. This can end up with hung
>syscalls due to the completion functions not getting called.
>
>This change ensures that both these discard functions return
>success even when discard from socket returned error. This
>ensures that at least after the mid for the response is found,
>the callback doesn't get skipped, and we do not leave syscalls
>waiting.

Then we'll also be returning wrong errors to callers?

Either way, if this is a special case for query dir, just
call __cifs_readv_discard() from the new
cifs_query_dir_receive() and ignore the error there
(but you really shouldn't).

__cifs_readv_discard() is used in other places (mostly indirectly)
and returns important errors from deep down cifs_readv_from_socket()
(e.g. -ECONNABORTED, -ESHUTDOWN, -EINTR) so modifying it for all
callers doesn't sound good.

>Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>---
> fs/smb/client/transport.c | 16 ++++++++--------
> 1 file changed, 8 insertions(+), 8 deletions(-)
>
>diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
>index 1e9e6f3f9a06f..85fa5751781a8 100644
>--- a/fs/smb/client/transport.c
>+++ b/fs/smb/client/transport.c
>@@ -1137,13 +1137,13 @@ static int
> __cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
> 		     bool malformed)
> {
>-	int length;
>-
>-	length = cifs_discard_remaining_data(server);
>+	cifs_discard_remaining_data(server);
> 	dequeue_mid(server, mid, malformed);
> 	mid->resp_buf = server->smallbuf;
> 	server->smallbuf = NULL;
>-	return length;
>+
>+	/* Once the mid is dequeued, the callback must run to terminate the subreq. */
>+	return 0;
> }
>
> static int
>@@ -1158,13 +1158,13 @@ static int
> cifs_query_dir_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
> 		      bool malformed)
> {
>-	int length;
>-
>-	length = cifs_discard_remaining_data(server);
>+	cifs_discard_remaining_data(server);
> 	dequeue_mid(server, mid, malformed);
> 	mid->resp_buf = server->smallbuf;
> 	server->smallbuf = NULL;
>-	return length;
>+
>+	/* Once the mid is dequeued, the callback must run to complete qd_io->done. */
>+	return 0;
> }
>
> /*
>-- 
>2.43.0
>
>

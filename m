Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DBD32AABD
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 11:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776253843; cv=none; b=Fr7gGCahTNxSAkzYjXfN7qN/UXbBeg+8h6ObijuHYXUydt4n3XIPUwPSDc/3V7sz1pHR9NdQiVyaGhlL3ZlOLeF1zkiiDM6L4TYFtvfRI53BCurT7g3ET7Lf5/2hKroCypOhbI5iK2W5t8uqOuOyK1bb1a5MG1PLoH0/9CvYGQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776253843; c=relaxed/simple;
	bh=mUwAMAovOgb92nsIM1r3PWuaBRbK2s3Qe3chtxmTnYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txnILZMm+NfRTzpsQA8mZxNtbU54RWpYKvn088rqG9evAUb7zisodLR5jMwIrHjLEv0xXP5wzWsq3K9BXPJ+1+yf8oVImLT8yi+S22Joe0B7f/NfDyLEQyTVg1P/c7mDCBjGOhPl6vzahpvRsNJVYAM796U/StUL2A1IacFfpqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rq4y1pmA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qUX+wXbJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rq4y1pmA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qUX+wXbJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rq4y1pmA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qUX+wXbJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rq4y1pmA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qUX+wXbJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D2E495BD23;
	Wed, 15 Apr 2026 11:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776253840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/cFEYEDFGm3FgmMyMQYDFi2Uz6ERCGXKrccZY1RQek=;
	b=rq4y1pmASKAxq+l750nLj61OjfliszDT3CwRhLJc3nYWw84r4ZDFVISuA3/HTviRtZ7qmK
	DZOQRyp721PS+s2SqAVSHibMCdAv24u32Ab8jcxZq8LoYE3SFxj4KJI/h3APc64DMZJQA2
	2s2hKBGm584K65P0AsQdi5R7FDpJDn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776253840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/cFEYEDFGm3FgmMyMQYDFi2Uz6ERCGXKrccZY1RQek=;
	b=qUX+wXbJPvPEVx4FToJqlWBYMVrXXSzVLnGTtzcU/DR2PFa7xcvUvJbXQ5k6tgz3XLnqNw
	DvvlV/0V4y+j5TAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776253840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/cFEYEDFGm3FgmMyMQYDFi2Uz6ERCGXKrccZY1RQek=;
	b=rq4y1pmASKAxq+l750nLj61OjfliszDT3CwRhLJc3nYWw84r4ZDFVISuA3/HTviRtZ7qmK
	DZOQRyp721PS+s2SqAVSHibMCdAv24u32Ab8jcxZq8LoYE3SFxj4KJI/h3APc64DMZJQA2
	2s2hKBGm584K65P0AsQdi5R7FDpJDn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776253840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/cFEYEDFGm3FgmMyMQYDFi2Uz6ERCGXKrccZY1RQek=;
	b=qUX+wXbJPvPEVx4FToJqlWBYMVrXXSzVLnGTtzcU/DR2PFa7xcvUvJbXQ5k6tgz3XLnqNw
	DvvlV/0V4y+j5TAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D2464B9BF;
	Wed, 15 Apr 2026 11:50:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8bIJCZB732n2AgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 15 Apr 2026 11:50:40 +0000
Date: Wed, 15 Apr 2026 08:50:37 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Dudu Lu <phx0fer@gmail.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix integer underflow in
 receive_encrypted_read()
Message-ID: <mbrdhvinfbr53a5k7ybmeahzezkboundsgqk4ohdyaz2m3xyu4@64oxh33do2bv>
References: <20260415102424.65161-1-phx0fer@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260415102424.65161-1-phx0fer@gmail.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO

On 04/15, Dudu Lu wrote:
>In receive_encrypted_read(), the length of data to read from the socket
>is computed as:
>
>  len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
>        server->vals->read_rsp_size;
>
>OriginalMessageSize comes from the server's transform header and is
>untrusted. If a malicious server sends a value smaller than
>read_rsp_size, the unsigned subtraction wraps to a very large value
>(~4GB). This value is then passed to netfs_alloc_folioq_buffer() and
>cifs_read_iter_from_socket(), causing either a massive allocation
>attempt that fails with -ENOMEM (DoS), or under extreme memory
>pressure, potential heap corruption.
>
>Fix by adding a check that OriginalMessageSize is at least
>read_rsp_size before the subtraction. On failure, jump to
>discard_data to drain the remaining PDU from the socket, preventing
>desync of subsequent reads on the connection.
>
>Signed-off-by: Dudu Lu <phx0fer@gmail.com>
>---
> fs/smb/client/smb2ops.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>index 509fcea28a42..a2105f4b54db 100644
>--- a/fs/smb/client/smb2ops.c
>+++ b/fs/smb/client/smb2ops.c
>@@ -4943,6 +4943,14 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
> 		goto free_dw;
> 	server->total_read += rc;
>
>+	if (le32_to_cpu(tr_hdr->OriginalMessageSize) <
>+	    server->vals->read_rsp_size) {
>+		cifs_server_dbg(VFS, "OriginalMessageSize %u too small for read response (%zu)\n",
>+			le32_to_cpu(tr_hdr->OriginalMessageSize),
>+			server->vals->read_rsp_size);
>+		rc = -EINVAL;
>+		goto discard_data;
>+	}

You could replace it with:

	if (check_sub_overflow(le32_to_cpu(tr_hdr->OriginalMessageSize),
			       server->vals->read_rsp_size, &len) {
		...
	}

for subtraction + check in one shot.

Patch is ok nonetheless.


Cheers,

Enzo

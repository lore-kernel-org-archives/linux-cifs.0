Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9046DF9CB
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741700388; cv=none; b=jHfKTnnGJrlwPIPgUlEBsr2MqamWxViLfnx2R8WO2hslL9ToChuc31ay7VE1nmiDXhw/gFLS3EaqTytR5j8XSpKh9V+wY2vMbuQHMIyWqVQ1TcSPqE4QcYPUMLioct1Sjyopgv9FZSYY33rQB+qDQ24IZDYVoknzkL+bxRxgBjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741700388; c=relaxed/simple;
	bh=+bzmzN1qAR3YtS3MC9OrOdFQZlRN9XdAJVlpsG2YGow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+Rv7u5WDvC4KulkcSe3JFnjq/lmDWjCeAiLrCoEhHbxR4SpCAb0zqlp2QFt1QTyStOo8VGBR0dw+QiTMuYlLzUs59BMPzIHAruAfjch/f5BF65nSQ9hdjnMpVG+1DLYekbPzyaauBGcZxDHGPAyLqpEIyURpU7f71Mh3yR/ll4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1SFrxcDD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y6fMp4ks; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1SFrxcDD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y6fMp4ks; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1SFrxcDD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y6fMp4ks";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1SFrxcDD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y6fMp4ks"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B3AE21168;
	Tue, 11 Mar 2025 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741700384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cjdv2+oogttHfFx3vumfIOyCmOlfaDhdHYcDcv6JGLA=;
	b=1SFrxcDD6JzPB5RWvUKjnA3ZCu/Ku86YCfb0beDCuWHMsR5OfaxCxfMBWIUgGXD5M1ZOys
	92vASXS3HCUdOodRw7KIb2TFp2C8Qp7TXF6GUWgoDRG3xQIPHhTHqa4lQsgu8/yBzGOhqM
	SjbWI3TWovSG6hWsfBFViIMNA0gzDa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741700384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cjdv2+oogttHfFx3vumfIOyCmOlfaDhdHYcDcv6JGLA=;
	b=y6fMp4kstnxd9nE1yENQX9xqOi0h8VnYDgb9s79oMNe+0PuLkUrtbht51T9mZYu14Y8M7S
	FFHUo2QjF9DHVcAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1SFrxcDD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y6fMp4ks
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741700384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cjdv2+oogttHfFx3vumfIOyCmOlfaDhdHYcDcv6JGLA=;
	b=1SFrxcDD6JzPB5RWvUKjnA3ZCu/Ku86YCfb0beDCuWHMsR5OfaxCxfMBWIUgGXD5M1ZOys
	92vASXS3HCUdOodRw7KIb2TFp2C8Qp7TXF6GUWgoDRG3xQIPHhTHqa4lQsgu8/yBzGOhqM
	SjbWI3TWovSG6hWsfBFViIMNA0gzDa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741700384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cjdv2+oogttHfFx3vumfIOyCmOlfaDhdHYcDcv6JGLA=;
	b=y6fMp4kstnxd9nE1yENQX9xqOi0h8VnYDgb9s79oMNe+0PuLkUrtbht51T9mZYu14Y8M7S
	FFHUo2QjF9DHVcAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A1A2134A0;
	Tue, 11 Mar 2025 13:39:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NiYhMR890GeBSQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 11 Mar 2025 13:39:43 +0000
Date: Tue, 11 Mar 2025 10:39:37 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: Fix match_session bug causing duplicate
 session creation
Message-ID: <qzsu6rfpof7ipuaaszyt6opjoepnmxfgdgqzecmrnz4itdl5rn@gb3haoqrul55>
References: <20250311013231.2684868-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250311013231.2684868-1-henrique.carvalho@suse.com>
X-Rspamd-Queue-Id: 7B3AE21168
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,manguebit.com,gmail.com,microsoft.com,talpey.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:email,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Hi Henrique,

On 03/10, Henrique Carvalho wrote:
>Fix a bug in match_session() that can result in duplicate sessions being
>created even when the session data is identical.
>
>match_session() compares ctx->sectype against ses->sectype only. This is
>flawed because ses->sectype could be Unspecified while ctx->sectype
>could be the same selected security type for the compared session. This
>causes the function to mismatch the potential same session, resulting in
>two of the same sessions.
>
>Reproduction steps:
>
>mount.cifs //server/share /mnt/a -o credentials=creds
>mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
>cat /proc/fs/cifs/DebugData | grep SessionId | wc -l  # output is 1
>
>mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
>mount.cifs //server/share /mnt/a -o credentials=creds
>cat /proc/fs/cifs/DebugData | grep SessionId | wc -l  # output is 2

Minor nit: I think your reproducer results are inverted -- on my tests,
the session is reused when sec=ntlmssp is passed on first mount, not the
other way around.

>Fixes: 3f618223dc0bd ("move sectype to the cifs_ses instead of
>TCP_Server_Info")
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/connect.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>index f917de020dd5..0c8c523d52be 100644
>--- a/fs/smb/client/connect.c
>+++ b/fs/smb/client/connect.c
>@@ -1825,8 +1825,11 @@ static int match_session(struct cifs_ses *ses,
> 			 struct smb3_fs_context *ctx,
> 			 bool match_super)
> {
>+	struct TCP_Server_Info *server = ses->server;
>+	enum securityEnum selected_sectype = server->ops->select_sectype(ses->server, ctx->sectype);

Calling select_sectype() with ctx->sectype as argument works fine for
Unspecified and ntlmssp* cases (because Unspecified will default to
ntlmssp if server supports it), but if you do the first mount with
sec=krb5 and the second with sec=ntlmssp/no sec=, the krb5 session
will be reused (which is wrong).

I would suggest something like (quickly tested only):

{
-       if (ctx->sectype != Unspecified &&
-           ctx->sectype != ses->sectype)
+       struct TCP_Server_Info *server = ses->server;
+       enum securityEnum requested_sectype = server->ops->select_sectype(server, ctx->sectype),
+                         selected_sectype = server->ops->select_sectype(server, ses->sectype);
+
+       if (requested_sectype != selected_sectype)
		 return 0;

i.e. comparing what the new session would negotiate as sectype vs what
was negotiated for the previous session.

>+
> 	if (ctx->sectype != Unspecified &&
>-	    ctx->sectype != ses->sectype)
>+	    ctx->sectype != selected_sectype)
> 		return 0;
>
> 	if (!match_super && ctx->dfs_root_ses != ses->dfs_root_ses)
>-- 

Other than that,

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers,

Enzo

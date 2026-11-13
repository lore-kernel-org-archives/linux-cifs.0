Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794572222;
	b=Zqgepw6UOWN3icekake4FrvJEQFohuTrXb3BzjhSmHh+db8kNDdld7k6yiyOGTO2nS4a
	 p3MP7psZeVcq34kiKbL5FLJbfp6S4zoydEJ+QiGgnnF9T1/VtC1+NoDYrTW8FTFj8Gxby
	 uD/f+rvjLOElZR2+lztadiMqdK6TSWWGtWC8WYLZT9y6VjjXTlQ0BVjiTD9VTZgRcxDcq
	 8DpqQKsbPfy6t8Kgy/sjv7MukCIqznM/NZow0fpusVlZj2FOcJDJyT0C9QtwcylQOUeTf
	 W9d8BXOrvC5V6uwxVfO+b0QLBAAKI1DqtIdOvlj2r+O6OaT4q9YyuSjehXASj3Wo/Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794572222;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=RkCxsTE7UpoOTRo2gEh6+gpKeHmTHzxM3PCv6l/f2Nc=;
	b=mRTzZcrSlbdQgWdpCMv1dWYVLeHg+4j3DbjZPTekbkc94fEnoIMJCW7lHFVbYWrtHztm
	 OkmHgJfF9SOQ55oKqWG4gpS5lBXqq7Z5/TNlSpW0tikpKwiAa4t9pcwZQHtapcStKuDkl
	 jqTp+L4Kj9cQiTjV16bwwvjLTdSogjLZ1tfCo8MxMapkGKSpyJI2LojHn11uoXzGDDZIx
	 rMz8gVrEJYkSX7WMUmMkYlZLFHzei0RuJZDx2kxAIQ4xJ3ZLpjqaLIttWVkADWOIWXFwn
	 PdsETYkEofwTWsUVezf6HGLwHRR7a5cLwWrl8VEX1ls/dI4pZwBR23XIdu6381kxuXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eYwF0+gr;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IET5H4dL;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eYwF0+gr;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IET5H4dL;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44770606A323;
	Fri, 13 Nov 2026 12:17:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44770606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eYwF0+gr;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IET5H4dL;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eYwF0+gr;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IET5H4dL
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 149961F7E0;
	Fri, 13 Nov 2026 12:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794572219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RkCxsTE7UpoOTRo2gEh6+gpKeHmTHzxM3PCv6l/f2Nc=;
	b=eYwF0+grD5yz822qXK4j4lZQA7+F5zFTtAIdrpbbteFpryBUKCagoTK/s4IY3biPfYGGOm
	ArKMietOFeQj4+szkoNRRdLwtOUcWpACYrdRtMXev6tG143iyltzpQBFIxTpDs67lu94ZA
	z4mhBhxF8ppfUECccQdfyMTRfxyw3rs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794572219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RkCxsTE7UpoOTRo2gEh6+gpKeHmTHzxM3PCv6l/f2Nc=;
	b=IET5H4dLdgIFtMe2xgdA7dNRE7n52M+khxDID5uijIqx6HFvkz+d4Fs7hWMhXtJsBkCXux
	vixNgNzRV0d3G7CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eYwF0+gr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IET5H4dL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794572219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RkCxsTE7UpoOTRo2gEh6+gpKeHmTHzxM3PCv6l/f2Nc=;
	b=eYwF0+grD5yz822qXK4j4lZQA7+F5zFTtAIdrpbbteFpryBUKCagoTK/s4IY3biPfYGGOm
	ArKMietOFeQj4+szkoNRRdLwtOUcWpACYrdRtMXev6tG143iyltzpQBFIxTpDs67lu94ZA
	z4mhBhxF8ppfUECccQdfyMTRfxyw3rs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794572219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RkCxsTE7UpoOTRo2gEh6+gpKeHmTHzxM3PCv6l/f2Nc=;
	b=IET5H4dLdgIFtMe2xgdA7dNRE7n52M+khxDID5uijIqx6HFvkz+d4Fs7hWMhXtJsBkCXux
	vixNgNzRV0d3G7CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D6E61344A;
	Fri, 13 Nov 2026 12:16:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iNJmO7n/9mrVcQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 13 Nov 2026 12:16:58 +0000
Date: Fri, 13 Nov 2026 09:16:56 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: shyckless@gmail.com
Cc: pc@manguebit.org, linkinjeon@kernel.org, linux-cifs@vger.kernel.org, 
	sprasad@microsoft.com, smfrench@gmail.com, ronniesahlberg@gmail.com, 
	bharathsm@microsoft.com, linux-kernel@vger.kernel.org, 
	daniel.birtwhistle@gehealthcare.com, samba-technical@lists.samba.org, tom@talpey.com
Subject: Re: [PATCH] smb: client: fail SMB2 responses with a bad signature
Message-ID: <avb81ry-kS6GfWkO@suse.de>
References: <20261113-smb2-sign-v1-1-937ee7c20f08@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261113-smb2-sign-v1-1-937ee7c20f08@gmail.com>
X-Rspamd-Queue-Id: 149961F7E0
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,vger.kernel.org,microsoft.com,gmail.com,gehealthcare.com,lists.samba.org,talpey.com];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,ntu.edu.sg:email,suse.de:dkim,gehealthcare.com:email,hust.edu.cn:email]
X-Spam-Score: -13.51

On 11/13, Suyuan Wang via B4 Relay wrote:
>From: Suyuan Wang <stevewong@hust.edu.cn>
>
>smb2_check_receive() checks the response signature when signing is on,
>but a failed check is only logged:
>
>    rc = smb2_verify_signature(&rqst, server);
>    if (rc)
>            cifs_server_dbg(VFS, "SMB signature verification returned ...",
>                            rc);
>    ...
>    return map_smb2_to_linux_error(mid->resp_buf, log_error);
>
>The status from the response is returned as usual, and the caller goes
>on to use a response whose signature is wrong. This is the path for
>synchronous requests and for smb2_writev_callback(). On a signed but
>unencrypted connection, anyone who can modify the traffic can change
>e.g. a directory listing, and the client accepts it.
>
>Return the verification error instead.
>
>Unlike the SMB1 fix in commit dc96f01d54cc ("smb: client: terminate
>session upon failed client required signing"), don't reconnect: this
>runs in the thread that sent the request, and only cifsd should call
>cifs_reconnect(). And fail the request whichever side required signing,
>since a response with a bad signature can't be trusted either way.
>
>Found with a static analysis tool and checked by hand.
>
>Reported-by: Daniel Birtwhistle <daniel.birtwhistle@gehealthcare.com>
>Closes: https://lore.kernel.org/linux-cifs/SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com/
>Fixes: 3c1bf7e48e9e ("CIFS: Enable signing in SMB2")
>Cc: stable@vger.kernel.org
>Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
>Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
>Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
>---
>We found this on our own and only saw Daniel's report afterwards.
>
>For SMB1 Steve wanted to keep just logging when the server, but not the
>client, required signing:
>https://lore.kernel.org/all/CAH2r5msfYRdaGAMuTbni-0T20tQi=N=fT4qxiaQ3siQ_WVm=Qg@mail.gmail.com/
>This patch doesn't make that exception. If you want it here too, I can
>send a v2 that remembers whether the client required signing.
>
>Tested in QEMU with Samba 4.15 (server signing = mandatory, mounted with
>vers=3.1.1,sign) and a proxy in between that renames a file in
>QUERY_DIRECTORY responses and leaves the signature as is. Before the
>patch the renamed file shows up in getdents64(), after it getdents64()
>fails with EACCES. Mount, read and write on the same connection still
>work, and lockdep stayed quiet.
>---
> fs/smb/client/smb2transport.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
>index 080864b24a0c..62121d7a44a8 100644
>--- a/fs/smb/client/smb2transport.c
>+++ b/fs/smb/client/smb2transport.c
>@@ -711,9 +711,11 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
> 		int rc;
>
> 		rc = smb2_verify_signature(&rqst, server);
>-		if (rc)
>+		if (rc) {
> 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
> 				 rc);
>+			return rc;
>+		}

Reading my reply to that other patch again https://lore.kernel.org/all/s4kmfu25glkgu44wl46e3q3bjvyhlbcvnlaiuqkuey4qlg4d5o@s7ispothcved/
I now think that, indeed, reconnecting on mismatching signatures might
be too much.

However, I still think the error should only be returned if signing is
required (*) AND rc == -EACCES.

Any other error should always be returned unconditionally.

(*) Note that "signing required" at that point means that either/both
client and server required signing, and the other side agreed -- it
doesn't really matter who asked for it.

> 	}
>
> 	return map_smb2_to_linux_error(mid->resp_buf, log_error);
>
>---

You might want to strip the lines below.

>base-commit: 630059a5a632377b9b7b487baccde92b7ae1dd47
>change-id: 20261113-smb2-sign-2f316c91c873
>
>Best regards,
>--
>Suyuan Wang <shyckless@gmail.com>


Cheers,

Enzo

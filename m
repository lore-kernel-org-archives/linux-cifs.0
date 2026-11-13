Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585575;
	b=INvyBC7gkjG9q9VoA34uRiHqbCeUsTcW/g2UUBknNBJnHdBYFHi2Qq+kF6S2laMtNrFm
	 1tAF/Bd16U9wDpdia494jhSocRPy3d1VnXHqB/I7amrPnXyLOnANey+TxVYqsNSXkIMcb
	 NeGdcWgnhBWTbjEh0RD3kXGlcUPLFXtAj3au/94ovhHdqvIyc32wfBIbJItE2QFuaXOBC
	 tislJAYufKvG5pMawswaUrUPLy9Nth+29uotSFNbH7oGkwxvrE5ol+896H6s5aDptWQoE
	 Z9vUAv73KhWe7PWF+EybpOTd9vioLhFo8g/qskdWk8OD7rZAYWF679gfpe/FQUtICfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585575;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=YK5qULkzf7ooh118Tvb3RLqnjqawl89i+ZXQ4lfC3CU=;
	b=ii6bL3bVO6Ye09o5StbSYmO7rc1NUTc54aBS9Cgo4QUzAGug91oYGohZGi5HdvWy/Fv8
	 b9rd1OdhFOVGrDdBchwzasXG9SnQjyw+JAmjGQra+vCy1GnQ6CDwmtJZ60mqnM1M1umqB
	 u85adTBox346UVCOWATkuU66Lcc5mPwvB/Oj0JefzchmLwkWw46pS88MBAXf5kb8frJrZ
	 z92eAQ55wqE3rXldvQcfmU1rjI6QvpXx1dN0uAkNrESA/yV7EEcnMaE6LU0Mip3+1B/ZL
	 CXCjYTSSlbg4xb4S3lcQ7R2SkZdUzPyj95BTENCyHtJHVQJ9+RePGLu6ak4OkulTHWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VzDCrXz5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HkZDHMOF;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VzDCrXz5;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HkZDHMOF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E478606BABC;
	Fri, 13 Nov 2026 15:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E478606BABC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VzDCrXz5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HkZDHMOF;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VzDCrXz5;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HkZDHMOF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 06CFF21F07;
	Fri, 13 Nov 2026 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794585571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YK5qULkzf7ooh118Tvb3RLqnjqawl89i+ZXQ4lfC3CU=;
	b=VzDCrXz5jPyMOdbYzZbm5W3ASbGhNyzhTiWsJ3TcODlV31ustoZZY8ZsnxzVhVRc8vnOoj
	/OoWYmEqI/X9TquEGwQd+GLerG/bZhD5XwAhEvcXUELUzW7b41BAhKY0fT5YshUVI+al3N
	l3dcx2RhD4ItnfVdZdk+ZTBUnjMWqzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794585571;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YK5qULkzf7ooh118Tvb3RLqnjqawl89i+ZXQ4lfC3CU=;
	b=HkZDHMOFdP44PbXekWBQkQ2XMotATh+UoZvr/fDiUkc/GUMp6L3vILiqwdxr0w5YLYqJ4M
	1wU6GYoEODp+SGBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VzDCrXz5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HkZDHMOF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794585571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YK5qULkzf7ooh118Tvb3RLqnjqawl89i+ZXQ4lfC3CU=;
	b=VzDCrXz5jPyMOdbYzZbm5W3ASbGhNyzhTiWsJ3TcODlV31ustoZZY8ZsnxzVhVRc8vnOoj
	/OoWYmEqI/X9TquEGwQd+GLerG/bZhD5XwAhEvcXUELUzW7b41BAhKY0fT5YshUVI+al3N
	l3dcx2RhD4ItnfVdZdk+ZTBUnjMWqzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794585571;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YK5qULkzf7ooh118Tvb3RLqnjqawl89i+ZXQ4lfC3CU=;
	b=HkZDHMOFdP44PbXekWBQkQ2XMotATh+UoZvr/fDiUkc/GUMp6L3vILiqwdxr0w5YLYqJ4M
	1wU6GYoEODp+SGBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C3D51344A;
	Fri, 13 Nov 2026 15:59:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yAHVN+Ez92rsVgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 13 Nov 2026 15:59:30 +0000
Date: Fri, 13 Nov 2026 12:59:28 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Wong Steve <shyckless@gmail.com>
Cc: pc@manguebit.org, linkinjeon@kernel.org, linux-cifs@vger.kernel.org, 
	sprasad@microsoft.com, smfrench@gmail.com, ronniesahlberg@gmail.com, 
	bharathsm@microsoft.com, linux-kernel@vger.kernel.org, 
	daniel.birtwhistle@gehealthcare.com, samba-technical@lists.samba.org, tom@talpey.com
Subject: Re: [PATCH] smb: client: fail SMB2 responses with a bad signature
Message-ID: <avcoB7XgP3i0xd9C@suse.de>
References: <20261113-smb2-sign-v1-1-937ee7c20f08@gmail.com>
 <avb81ry-kS6GfWkO@suse.de>
 <CA+X8Sdi6adfL0jr=t9jDoJ5M+AWHxAw7NzQaVaOoT4O+awfEPA@mail.gmail.com>
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
In-Reply-To: <CA+X8Sdi6adfL0jr=t9jDoJ5M+AWHxAw7NzQaVaOoT4O+awfEPA@mail.gmail.com>
X-Rspamd-Queue-Id: 06CFF21F07
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,vger.kernel.org,microsoft.com,gmail.com,gehealthcare.com,lists.samba.org,talpey.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email]
X-Spam-Score: -13.51

On 11/13, Wong Steve wrote:
>On 11/13, Enzo Matsumiya wrote:
>> However, I still think the error should only be returned if signing is
>> required (*) AND rc == -EACCES.
>>
>> Any other error should always be returned unconditionally.
>>
>> (*) Note that "signing required" at that point means that either/both
>> client and server required signing, and the other side agreed -- it
>> doesn't really matter who asked for it.
>
>Thanks for looking at it.
>
>I think the existing server->sign check already covers that.
>cifs_enable_signing() only sets server->sign when the server requires
>signing and the client allows it, or when the client requires it (mount
>option or SecurityFlags) and the server supports it. Both sides merely
>supporting signing doesn't turn it on.
>
>smb2_verify_signature() is only called under that check, so the new
>return passes on -EACCES for a mismatch, and any other error from it
>(e.g. from smb3_calc_signature()) as well.
>
>Is there a case I'm missing where server->sign is set but signing isn't
>required in your sense?

Not really, you're 100% correct, sorry.

I just remembered that there's a very specific exception to that, and it's
currently not handled;  SMB 3.1.1 tcon requests (!anonymous && !guest) are
signed unconditionally, but the responses are never verified because
they're gated by server->sign.

While your patch fix this indirectly, I couldn't find in the spec
whether such tcon responses should also fail if signing isn't required.

Anyway, I think this can be discussed later in a follow up patch.

@Paulo, @Namjae:
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers,

Enzo

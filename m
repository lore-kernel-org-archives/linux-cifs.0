Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9891C68A6
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 14:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749739696; cv=none; b=usJ0WoYdrkUEwW51hdlvXdMfLfqrq3kNt3y54DnIY3Ard+sVmleUnx1xv77vnvEZYkZoisYQK4Iyq558Hz9V5L44tfF9wAVkca+UE2XWwGTNmjauPtYwztwXAUbF4GE7TaTHQFMf4rQfEkPw/cLGI4IkRf7Y3LsKMCCgOV8zcks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749739696; c=relaxed/simple;
	bh=EnZfqnkmfgLiWLHZXeNA3h/KyTILOPegXiDhTsKF05Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKDBtWZD5Yg6zlATPuhrIGlPukkpLH2ZPwQYv8XLEz2f5NiNbsHsF0rm44+vAAOAL+s1YHldEf2nmzCLjJuhO0ZJJQuhunsnuuJO0BKHnx9Qw4ahaK81WMKM5+Ph1i5sZIYVuxvr04hQPArJ1utMVNaYrSHh9Fwgm2wW17emUIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hLMmW1Pb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tlf+AYOP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IwVITaIB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kMA6udTv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hLMmW1Pb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tlf+AYOP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IwVITaIB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kMA6udTv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E220E216E0;
	Thu, 12 Jun 2025 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749739693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I7mNQH+568DnqQZkeh6PXGVwXhl1wgFhpG6VKxSeI04=;
	b=hLMmW1PbayD+vvDtKHUbfHd6ANXrMV8LBF2C4KSATiXzJYdBOpumIPfxcQ5msLz+rdan3O
	NciqgG71zmu54hohkhGdU8vQITj8lCtZJIjRxMwW46jOuUVDUUybhM4cX4ejE5R46Nnm3j
	y0YENew5xf6QL18qezBjQbxWKRbELbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749739693;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I7mNQH+568DnqQZkeh6PXGVwXhl1wgFhpG6VKxSeI04=;
	b=tlf+AYOPz/04U0au88pgnPEqPcjs4iXLoIxQI5cEUmTgn8zt/UMR0yhQPy7BzN+QHhcNYl
	5cPmOeiPcv/6UiAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwVITaIB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kMA6udTv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749739692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I7mNQH+568DnqQZkeh6PXGVwXhl1wgFhpG6VKxSeI04=;
	b=IwVITaIBlPEMf3AdKq+RaTdQ/GZkmNDdFDiewKwxFP1rS1wnxVUZGNY9TqmaNZEBbAw7PE
	CIHOkcvaHSyfUaO5W16jPIttAsWBO6GlxR1tWIU2y4gmHeAYPUYqdKdHTGkAun4g4wcTUU
	xlVH/Q4nC1udl5EneLy6F+LYXo8G2kw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749739692;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I7mNQH+568DnqQZkeh6PXGVwXhl1wgFhpG6VKxSeI04=;
	b=kMA6udTv1tYOE3yOBJtygSyu47ZVR1+146QrhtYkBKh67U7RErFLdJCko9qQET1hCMaFX1
	WiknosEgXapLfVAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67F8E139E2;
	Thu, 12 Jun 2025 14:48:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vPRIC6zoSmjAIgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 12 Jun 2025 14:48:12 +0000
Date: Thu, 12 Jun 2025 11:48:09 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath S M <bharathsm@microsoft.com>
Subject: Re: netfs hang in xfstest generic/013
Message-ID: <ecuf27sge23drhun5h3gckvzibwuienqwnyvvzxn4aong5ovd5@rlsymwdyrxk4>
References: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
 <466171.1749738030@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <466171.1749738030@warthog.procyon.org.uk>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,manguebit.com,microsoft.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,fedora29:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: E220E216E0
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.01

I'm not sure this is the same issue I saw a while ago...

generic/013 sends a lot of ioctls (copychunk writes and set zero data)
which can take a good amount of time to process (~10s each on my test
machine, for example).

When/if the server gets too busy processing them, it starts responding
with STATUS_PENDING (mostly for reads and writes, AFAICS).

Currently we just release the mid for such responses, this means:
- write callbacks are not reached:
   mostly dangling/wrong metadata left on cifs side, but netfs
   reqs/subreqs are not terminated (probably leaking)
- for reads, similarly, mid ("metadata") is gone now, but netfs keeps
   waiting for the data (because of unterminated reqs/subreqs too)

I have a WIP patch for that, I'll test and send to the list later.


Cheers,

enzo

On 06/12, David Howells wrote:
>Steve French <smfrench@gmail.com> wrote:
>
>> I saw a hang in xfstest generic/013 once today (with 6.16-rc1 and a
>> directory lease patch from Bharath and the fix for the readdir
>> regression from Neil which look unrelated to the hang).
>>
>> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/487/steps/29/logs/stdio
>>
>> There were no requests in flight, and the share worked fine (could
>> e.g. ls /mnt/test) but fsstress was hung so looks like a locking leak,
>> or lock ordering issue with netfs. Any thoughts?
>>
>> root@fedora29:~# cat /proc/fs/cifs/open_files
>> # Version:1
>> # Format:
>> # <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>
>> <filename> <mid>
>> 0x5 0x234211540000091 0x5c5698c8 0xc000 2 32005 0
>> f24XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6928
>
>Can you grab the contents of /proc/fs/netfs/{stats,requests} ?
>
>I presume you're running without a cache?
>
>Would you be able to try reproducing it with some netfs tracing on?
>
>David
>
>

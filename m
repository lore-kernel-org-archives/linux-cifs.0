Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3509B156F45
	for <linux-cifs@vger.kernel.org>; Tue, 30 Sep 2025 13:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759238012; cv=none; b=YUGnyK6NkMFvgJA0gzrhr53OmqHNoEaWzaXGege1I4BNRdmjVF9Z2GRMEO2XqiXOjue9WLN9gtfUOT5ZOQwHPoy2kMUOr1AbcOkWDvMdFcXLS6hLTrj4AbQVSglGwJOFPUptBSp2pBziKOUszx1yP1pZP40IjEYfM9QJ8qtXytA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759238012; c=relaxed/simple;
	bh=5VF9hm8ISI650ciXXoPmBXppyK2uKWaoS5cA3GkrKRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZuZtN2aSlGk3fxOFUnoo8+o9lAEv+z/mqbU3O1DW2bLjrelIMFSjnrDtjjoE25uE5aiZHk9hoYfA7Mf9m4PpL9YWCDbU+iqDeNcMoChJZ00GIysuvUxb/dNUkHVJNqEDuYRjJdqEKhqqiv4CPGKGEmI84vbeutiF06TSJ1T8lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w8pwdMW5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nI7REnMO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w8pwdMW5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nI7REnMO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w8pwdMW5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nI7REnMO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w8pwdMW5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nI7REnMO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2EC2A336CF;
	Tue, 30 Sep 2025 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759238009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RYHA5ZJ3p9Ee/kHXmjdkofw9rcsqJJhwGQ4ong0C7k4=;
	b=w8pwdMW54r9DkmJptVRJ7/0B7Ygy+k0Zfd6Zo45TNM9paz1OyuypfdzuK268E2w1CVsZa0
	pKMfGYbv0nd+9KMw8UQk4Xb3nQopyV54LbcnuA5sosLtSgdbiFeFbYz6lJ1w4M3oro/Yyu
	Fh0ebUuRuJnuee/KjUDXTUIDx8Kxjqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759238009;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RYHA5ZJ3p9Ee/kHXmjdkofw9rcsqJJhwGQ4ong0C7k4=;
	b=nI7REnMOfv3T2c3B9Dsc1CAkeF+eD9HX2oI7ldTU0MSTMJhyFZ5i0Xt958MGA2ykRU7BYZ
	mvgFQATprnvr0rCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759238009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RYHA5ZJ3p9Ee/kHXmjdkofw9rcsqJJhwGQ4ong0C7k4=;
	b=w8pwdMW54r9DkmJptVRJ7/0B7Ygy+k0Zfd6Zo45TNM9paz1OyuypfdzuK268E2w1CVsZa0
	pKMfGYbv0nd+9KMw8UQk4Xb3nQopyV54LbcnuA5sosLtSgdbiFeFbYz6lJ1w4M3oro/Yyu
	Fh0ebUuRuJnuee/KjUDXTUIDx8Kxjqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759238009;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RYHA5ZJ3p9Ee/kHXmjdkofw9rcsqJJhwGQ4ong0C7k4=;
	b=nI7REnMOfv3T2c3B9Dsc1CAkeF+eD9HX2oI7ldTU0MSTMJhyFZ5i0Xt958MGA2ykRU7BYZ
	mvgFQATprnvr0rCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFD491342D;
	Tue, 30 Sep 2025 13:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1UC5HXjX22j+PgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 30 Sep 2025 13:13:28 +0000
Date: Tue, 30 Sep 2025 10:13:18 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	Bharath S M <bharathsm@microsoft.com>, samba-technical <samba-technical@lists.samba.org>
Subject: Re: [SMB CLIENT][PATCHES] directory lease debugging and configuration
Message-ID: <gstdotvoko2a4ibpqpfwwvkskjiklqjzrv4fu3zlgeegpwwzwe@sbofqypjf27i>
References: <CAH2r5muGJTYxfNN9kcnBtX0JaJDeGa6SLiiuMg+zQVkNRjP1Yw@mail.gmail.com>
 <aztzqdkslkjs6jjtrxlir65hujpl4euikgaxwq67ulfeoqnitb@wnalncavigju>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aztzqdkslkjs6jjtrxlir65hujpl4euikgaxwq67ulfeoqnitb@wnalncavigju>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	ARC_NA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On 09/30, Enzo Matsumiya wrote:
>Hi Steve, Bharath,
>
>Sending my review based on the commit messages and the patches applied
>manually on my local tree.
>
>Please try sending the patches with git-send-email next time, as it's
>much easier to apply and review.  Thanks!
>
>On 09/29, Steve French via samba-technical wrote:
>>4 patches from Bharath to improve directory lease handling (see
>>attached).  Lightly updated and rebased on current mainline, and
>>merged into cifs-2.6.git for-next.  Feedback/review/comments welcome
>>
>>commit a50843f864205ea4576638cb32321313d9c06e54
>>Author: Bharath SM <bharathsm@microsoft.com>
>>Date:   Tue Sep 2 14:18:21 2025 +0530
>>
>>   smb: client: cap smb directory cache memory via module parameter
>>
>>   The CIFS directory entry cache could grow without a global
>>   bound across mounts. Add a module-wide cap to limit memory
>>   used by cached dirents and avoid unbounded growth.
>>
>>   Introduce a new module parameter, dir_cache_max_memory_kb
>>   (KB units; 0 = unlimited). When unset and directory caching
>
>"0 = unlimited" should be "0 = ~10% of RAM"
>
>>   is enabled (dir_cache_timeout != 0), default the cap to ~10%
>>   of system RAM during module init. The parameter is exposed
>>   under: /sys/module/cifs/parameters/dir_cache_max_memory_kb.
>>
>>   Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>>   Signed-off-by: Steve French <stfrench@microsoft.com>
>
>I think this should be a sysfs module parameter, as it assumes users

shouldn't *

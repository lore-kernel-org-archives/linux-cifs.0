Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39654EDCA8
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 12:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790684729; cv=none; b=tlbuajmy+G0BHlFumwS3nrGm78iU1NtvbG4L3L6Rw3XXVNwO+wsfd+tHeAZWBVaBpLdCwIBGZGlL1kh0VJ4M/YdBm4Vw4SDgUpr46nsRlwMmZt/ViUNRrwwRWmqukFSxgqrK9kkpLFSghKg7FtUdEn5kmXdUaEUA0gQPqpo9Ds0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790684729; c=relaxed/simple;
	bh=4CFkkm9dRBYJzBfyr6rHV1AYIBoZ8Ia5eLZbjwtjuIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZGfz1wst9I4SUp5hPu6cL/RVwcNhCabYleEydn6GN/5lGbaHZ0MUEKRQc8Kn9vf8neqpjVm/NakmV6ayrQmhH2ufl15vx30iAgSArqwZ+wzALuZmMFlLr+VqgVLDarMqmOvR4gYHsnX7SvnyzaSBSlmPBMSUWf946UCTNRHT4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=duDs1/yP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UT/RKiti; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E4lASWBY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gomXZbgE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="duDs1/yP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UT/RKiti";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E4lASWBY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gomXZbgE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACF011F391;
	Tue, 29 Sep 2026 12:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790684721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+6KiDjBICQKqXNka/7Z751pkaMZnPB6P7U6h/yUanHs=;
	b=duDs1/yPAcD9Qmh34k7IvfQ5TH0q0r658N47YQUAlIuFgZmI+Ue9vxu0S5TJQwEF8BE1me
	xJ3UjwYQxBzbE/9Yjg5lZ9RRwpciG//ryywdmiSCuI4GtPls8e3kki8Y/cWQ1fSPXE6Jq2
	W1ycjjLaBp/aj+V79XnhHE9Fdvb2+kU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790684721;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+6KiDjBICQKqXNka/7Z751pkaMZnPB6P7U6h/yUanHs=;
	b=UT/RKitir3jRjtBdQ3mMKExdEd7iCRTuNNbalb6NZas6dHhMB5lB4JjUVSAZDeHPv+Y5gG
	3JWDFxNwuyyTt/Bg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=E4lASWBY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gomXZbgE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790684717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+6KiDjBICQKqXNka/7Z751pkaMZnPB6P7U6h/yUanHs=;
	b=E4lASWBYttguZYl7/eAFWofnpC01bf4vADqwRsXJm27hFEcCtE3TJ4jESTPqkSSU3+JXdy
	qbcFXjjwBjwE2BWUpyzyC+IElyIdeN4/DMxYy2nJfN/ipb+TFMQIx0DHgmiJit/I38L8kN
	c5RaxEZLA/Qch8UcAfP1znkCjj6+VGs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790684717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+6KiDjBICQKqXNka/7Z751pkaMZnPB6P7U6h/yUanHs=;
	b=gomXZbgE0JjlemjJhETlz2uGFpidHKUjG0ur07iJX4sbJhzt2E749nhSgE692YDPoH/ghJ
	btgC9gkFwROT+hAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C508133F1;
	Tue, 29 Sep 2026 12:25:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x0hnKCyuu2onVQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 29 Sep 2026 12:25:16 +0000
Date: Tue, 29 Sep 2026 09:25:14 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v2 1/2] smb: client: fast fail sends if need to reconnect
Message-ID: <arur-tfIfGJAVjWK@suse.de>
References: <20260928150355.850472-1-ematsumiya@suse.de>
 <20260928150355.850472-2-ematsumiya@suse.de>
 <CAKYAXd9oL+fGZopR7+yx4Pin4eJKCbYW=ZXpdNSXMSjzw_JRiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKYAXd9oL+fGZopR7+yx4Pin4eJKCbYW=ZXpdNSXMSjzw_JRiA@mail.gmail.com>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,manguebit.org,gmail.com,microsoft.com,talpey.com,suse.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: ACF011F391
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 09/29, Namjae Jeon wrote:
>> @@ -184,6 +214,9 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
>>                 }
>>         }
>>
>> +       if (shutdown)
>> +               kill_socket_queues(server);
>> +
>>         spin_lock(&cifs_tcp_ses_lock);
>Since this loop still holds cifs_tcp_ses_lock, It can sleep while
>holding a spinlock, causing a scheduling-while-atomic failure.

I totally missed that second loop, will handle that in v3.

AFAICS, the new set_need_reco() can be moved to after unlocking
cifs_tcp_ses_lock, as tcpStatus is already protected by srv_lock.
Any objections to that?

>The
>previous set_need_reco macro did not acquire a mutex.

Yes, the server mutex is needed to access/shutdown server->ssocket,
which is part of the core change in this patch.

>Please check sashiko's review comments.
>
>https://sashiko.dev/#/patchset/20260928150355.850472-1-ematsumiya%40suse.de

The other concerns could be ignored, but I'll address them anyway in v3.


Cheers,

Enzo

>Thanks.
>>         list_for_each_entry_safe(server, nserver, &reco, rlist) {
>>                 list_del_init(&server->rlist);
>> @@ -365,9 +398,10 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
>>         cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
>>         trace_smb3_reconnect(server->current_mid, server->conn_id,
>>                              server->hostname);
>> -       server->tcpStatus = CifsNeedReconnect;
>> -
>>         spin_unlock(&server->srv_lock);
>> +
>> +       set_need_reco(server);
>> +
>>         return true;

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256E21993B8
	for <linux-cifs@vger.kernel.org>; Thu,  6 Jun 2024 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717697267; cv=none; b=XYEgA0VlMo7UYs7yh0jbMldUfE+8mP5uigtHFrs0iPtMRpyac4CvKhI/9Pijpp5q2ttmxTvdTFi+CYcqlpLl2iCmSmnvDWDiofS/ZwvjmIxs65+/l5vUqi8Nuj0oqShtOb6PF9g7aVd0up1/z5N8Aaun6goaI61CZy+azngF7CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717697267; c=relaxed/simple;
	bh=onqDx1rnKXVm7FXmDb3pU0+HxGYhPvSZQ0Sxg76UOSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBd2rjwRHldSrqpz/AKm71q0/jr1JdvkSDezxMHx1AahciXb//c7Du8knP+zOglhWziRS50ir0pGUAiZkV2xXI0+oUuLl5BfB4GskYFuE6+1aZPLgryyX6gyheHpDgHuzkdY+QF2AQzaBJyrdfw34n0/8L5g9TE+8hGqzMUS4WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aCNtik2E; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2xarWe85; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hlnZKQCP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9nfkVDjC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aCNtik2E";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2xarWe85";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hlnZKQCP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9nfkVDjC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A20071FB49;
	Thu,  6 Jun 2024 18:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717697263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TfSybsfW0EvBVyRBAwmf2WoA450WR6guTNd0EENItC0=;
	b=aCNtik2Eoc6GamhvLwOAkW8HbjZILMAlhwk3h0qjyvJNqJn556GA6wad2ywJ4eh3MjoZc/
	PZnmoO8PFF8EVIvPUr7QmxZRjjgg3yuTtPGgA7MHDz0hdsnmbZCfBCzEguJZIK70J746ZZ
	6PKmL2TnY754GKEf2ajhA5waY22HOAY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717697263;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TfSybsfW0EvBVyRBAwmf2WoA450WR6guTNd0EENItC0=;
	b=2xarWe85dx37Imo2CMRatxAEz7pZygQSevyv8hFd/JihtXgc5kTUit4A/GJesFLV8QU4Wk
	Can8mDCCJX2+u3DA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hlnZKQCP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9nfkVDjC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717697262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TfSybsfW0EvBVyRBAwmf2WoA450WR6guTNd0EENItC0=;
	b=hlnZKQCPiyNTylkRpRRjeIOa7rhezXeA2leS0gvZ+IJeF+3j7dyGGTkZEC5wc6CYlB8bW6
	zKPcRlrxNmpabiDiHDMYQJcc/k9IZdgvOsXBj8kkgqFVibmfV+jFiohyivu53QT74/dt5G
	4gQXhhIPQRBnubN44TkjeOjPAwkJFV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717697262;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TfSybsfW0EvBVyRBAwmf2WoA450WR6guTNd0EENItC0=;
	b=9nfkVDjCKMufl7X7AprgrI7qIikGH7jjkz7RkHD7xOnhpw2sRLWBUQHTLR3FSsu7BBSDoU
	9NBCdvrrFoogK1DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 306FE13A1E;
	Thu,  6 Jun 2024 18:07:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id usliOu36YWYZIQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 06 Jun 2024 18:07:41 +0000
Date: Thu, 6 Jun 2024 15:07:43 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com
Subject: Re: [PATCH] smb: client: fix deadlock in smb2_find_smb_tcon()
Message-ID: <pnsrye6e2xe45m53ouwmrfj26djyevqp4q36m5taz3ijjh6seh@7zubjukz65ui>
References: <20240606161313.25521-1-ematsumiya@suse.de>
 <CAH2r5muDs3V_dVZZcozr-6bXE5pxo66kjaLHFdBpRo1hGpJyJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5muDs3V_dVZZcozr-6bXE5pxo66kjaLHFdBpRo1hGpJyJQ@mail.gmail.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,manguebit.com,gmail.com,microsoft.com,talpey.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A20071FB49
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.01

On 06/06, Steve French wrote:
>Merged into cifs-2.6.git for-next.  Is this an easy repro scenario?

Not really. I'm still assessing the actual root cause, but the whole
superblock got corrupted (my assumption so far is probably because of
an umount + mount + restart of autofs with a very specific timing).

>Shouldn't we Cc: stable or tag Fixes for 24a9799aa8ef smb: client: fix
>UAF in smb2_reconnect_server()

Ok.


>On Thu, Jun 6, 2024 at 11:14=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>>
>> Unlock cifs_tcp_ses_lock before calling cifs_put_smb_ses() to avoid such
>> deadlock.
>>
>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>> ---
>>  fs/smb/client/smb2transport.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport=
=2Ec
>> index 02135a605305..1476c445cadc 100644
>> --- a/fs/smb/client/smb2transport.c
>> +++ b/fs/smb/client/smb2transport.c
>> @@ -216,8 +216,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, _=
_u64 ses_id, __u32  tid)
>>         }
>>         tcon =3D smb2_find_smb_sess_tcon_unlocked(ses, tid);
>>         if (!tcon) {
>> -               cifs_put_smb_ses(ses);
>>                 spin_unlock(&cifs_tcp_ses_lock);
>> +               cifs_put_smb_ses(ses);
>>                 return NULL;
>>         }
>>         spin_unlock(&cifs_tcp_ses_lock);
>> --
>> 2.45.1
>>
>
>
>--
>Thanks,
>
>Steve

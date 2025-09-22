Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEEC2820D7
	for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 14:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758553184; cv=none; b=t0WsIFIB2qUN2Ua+AKt8Gt7JRL/3/Fd8UdH12t/PC+V6X7b3DzNrfYMs1RQgOeU1WZ+bCEm8Qf0nE4nc++gwwqUhuOIqrNTRTIF9LPPnN+Otvw6/kH1CA4Uavi2mXnYB8EER5UX9zDijZMW6lBcZPIYmhcA03lPeS6ghU4AakTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758553184; c=relaxed/simple;
	bh=AR4pkQB5ZMS03TGgf3rPdwsxz5cOrdA4kxpYZBvDgu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IOhwnVxs9156QVN+CYXHpimFEe41Wj9LERVUXMOOoIQGTC4bHtyqiRxiCP1GWIRhS0hT/pofMuPxXwiQi8X/Y3bVOkGlNo7nK/zV4qhdiCFUUWcGHvZ5fvpEf8PVkp9XHiK+jAUTokPWvMDG/9lctqU996F4fboaliy3ZIO/x50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k1+H2M+Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iirexlPL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k1+H2M+Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iirexlPL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k1+H2M+Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iirexlPL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k1+H2M+Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iirexlPL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 689C42273A;
	Mon, 22 Sep 2025 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758553180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PoiKPHtcWcnHD1XvSkOL4QmCp9+zlGaimvOVSIUNhVU=;
	b=k1+H2M+ZPD0rJWTWHOpW1YIGUiWRtgDmxgT2JgAolgdoAOp57tY1BcPGnoR0jlT9mgRRqt
	EDBI1z8Im5RlxO+mjMNj+XfhD55jtBQzQL31I6Cf6cCmaCXS6CEavzX3baYory4PQsQ9VI
	TmpFRS1ZMLFNsGlmX4obwryI7Izn8CE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758553180;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PoiKPHtcWcnHD1XvSkOL4QmCp9+zlGaimvOVSIUNhVU=;
	b=iirexlPL0YMFkuzXAWB4sQHH8Yl3E8jV9/u7yYal0Cr99dAEvkYurQcfkGTr8j3bGvIFZb
	2fcmplSBosWwDWBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k1+H2M+Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iirexlPL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758553180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PoiKPHtcWcnHD1XvSkOL4QmCp9+zlGaimvOVSIUNhVU=;
	b=k1+H2M+ZPD0rJWTWHOpW1YIGUiWRtgDmxgT2JgAolgdoAOp57tY1BcPGnoR0jlT9mgRRqt
	EDBI1z8Im5RlxO+mjMNj+XfhD55jtBQzQL31I6Cf6cCmaCXS6CEavzX3baYory4PQsQ9VI
	TmpFRS1ZMLFNsGlmX4obwryI7Izn8CE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758553180;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PoiKPHtcWcnHD1XvSkOL4QmCp9+zlGaimvOVSIUNhVU=;
	b=iirexlPL0YMFkuzXAWB4sQHH8Yl3E8jV9/u7yYal0Cr99dAEvkYurQcfkGTr8j3bGvIFZb
	2fcmplSBosWwDWBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA5E51388C;
	Mon, 22 Sep 2025 14:59:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +yMDLFtk0WjiGgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 22 Sep 2025 14:59:39 +0000
Date: Mon, 22 Sep 2025 11:59:37 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: rajasimandalos@gmail.com, linux-cifs@vger.kernel.org, 
	sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Subject: Re: [PATCH 1/2] cifs: client: force multichannel=off when
 max_channels=1
Message-ID: <qmf3xwqq4hqj4issgci2g76eghytaqxihnrp236ithh2istkkf@n4s54vp3hblr>
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
 <da3e2b5a-a5da-4526-9884-8789990ebf95@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <da3e2b5a-a5da-4526-9884-8789990ebf95@suse.com>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 689C42273A
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,samba.org,manguebit.org,microsoft.com,talpey.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Spam-Score: -4.01

On 09/22, Henrique Carvalho wrote:
>Hi Rajasi,
>
>On 9/22/25 5:24 AM, rajasimandalos@gmail.com wrote:
>> From: Rajasi Mandal <rajasimandal@microsoft.com>
>>
>> Previously, specifying both multichannel and max_channels=1 as mount
>> options would leave multichannel enabled, even though it is not
>> meaningful when only one channel is allowed. This led to confusion and
>> inconsistent behavior, as the client would advertise multichannel
>> capability but never establish secondary channels.
>>
>> Fix this by forcing multichannel to false whenever max_channels=1,
>> ensuring the mount configuration is consistent and matches user intent.
>> This prevents the client from advertising or attempting multichannel
>> support when it is not possible.
>>
>> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
>> ---
>>  fs/smb/client/fs_context.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
>> index 072383899e81..43552b44f613 100644
>> --- a/fs/smb/client/fs_context.c
>> +++ b/fs/smb/client/fs_context.c
>> @@ -1820,6 +1820,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>>  		goto cifs_parse_mount_err;
>>  	}
>>
>> +	/*
>> +	 * Multichannel is not meaningful if max_channels is 1.
>> +	 * Force multichannel to false to ensure consistent configuration.
>> +	 */
>> +	if (ctx->multichannel && ctx->max_channels == 1)
>> +		ctx->multichannel = false;
>> +
>>  	return 0;
>>
>>   cifs_parse_mount_err:
>
>Do we even need ->multichannel flag at all? Maybe we could replace
>->multichannel for a function that checks for max_channels > 1?

I agree with Henrique.

I'd actually like to propose going even further and having the whole
module behaving as if multichannel was always on, even with
max_channels=1 -- the only difference being the need to run the
query_interfaces worker.

This is probably work for another patch/series though.


Cheers,

Enzo

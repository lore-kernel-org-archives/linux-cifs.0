Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCE754BD0
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jan 2024 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b4WiDj5A";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VSNAmRZL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b4WiDj5A";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VSNAmRZL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A0BE21A44;
	Mon,  8 Jan 2024 18:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704737874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnX6ipO5Et8uSKZ6QpR/U4DH7wzjvjb3DDbGBhY65qE=;
	b=b4WiDj5AUEiY2IBAiuXY2c7Yei5NSm83IcU1AC3MQm85SnyDZxeo2BWAyWOqTW/l3cfbkh
	Q4/SaEXu+l0/AI1FzhZeXAgkxOen8oBxM4s1CyDmMs3ZFhy93cFeliswDCPBWAOAz17dvO
	Rs3vNkrAED7RWl1WtOCsejgQjPhOV9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704737874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnX6ipO5Et8uSKZ6QpR/U4DH7wzjvjb3DDbGBhY65qE=;
	b=VSNAmRZLPF0pfvdq9U6ta377nHamNu6GZxhZNXN4ZVxhws2IGnUMwB8F4aVTvitj8TZNHj
	GwpiEJJrja/r4PDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704737874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnX6ipO5Et8uSKZ6QpR/U4DH7wzjvjb3DDbGBhY65qE=;
	b=b4WiDj5AUEiY2IBAiuXY2c7Yei5NSm83IcU1AC3MQm85SnyDZxeo2BWAyWOqTW/l3cfbkh
	Q4/SaEXu+l0/AI1FzhZeXAgkxOen8oBxM4s1CyDmMs3ZFhy93cFeliswDCPBWAOAz17dvO
	Rs3vNkrAED7RWl1WtOCsejgQjPhOV9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704737874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnX6ipO5Et8uSKZ6QpR/U4DH7wzjvjb3DDbGBhY65qE=;
	b=VSNAmRZLPF0pfvdq9U6ta377nHamNu6GZxhZNXN4ZVxhws2IGnUMwB8F4aVTvitj8TZNHj
	GwpiEJJrja/r4PDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1676A13686;
	Mon,  8 Jan 2024 18:17:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9NsAMlE8nGWsXgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 08 Jan 2024 18:17:53 +0000
Date: Mon, 8 Jan 2024 15:17:51 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Jacob Shivers <jshivers@redhat.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Linux client SMB and DFS site awareness
Message-ID: <20240108181751.natpy6fac7fzdjqd@suse.de>
References: <CALe0_77CgEXNiXrM4oQ47sfHnDoML18oz5rmEu-_57Av0KRTkg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALe0_77CgEXNiXrM4oQ47sfHnDoML18oz5rmEu-_57Av0KRTkg@mail.gmail.com>
X-Spam-Level: 
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=b4WiDj5A;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VSNAmRZL
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.51 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[40.31%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 TO_DN_ALL(0.00)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -1.51
X-Rspamd-Queue-Id: 9A0BE21A44
X-Spam-Flag: NO

On 01/08, Jacob Shivers wrote:
>Hello,
>
>I have a use-case for a Linux SMB client to mount DFS replicated
>shares, with a preference for sites that are closer geographically.
>DNS site discovery/awareness exists within DFS[0], but I have not read
>of any work currently under investigation.

DFS supports referral responses based both on site location and site costing,
which are done on the _server_ (MS-DFSC 3.2.1.1 and 3.2.1.2).

For site location, the targets are sorted with targets on the same site as
the client first, in random order, and then targets outside of client's site
are appended, also in random order.

If supported and enabled, referral responses based on site cost will, practically,
sort the targets from lowest to highest cost (relative to the client,
and in random order if same cost).

On either case, the client will try to connect to the targets in order
it was received.

>[0] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/7fcdce70-5205-44d6-9c3a-260e616a2f04?redirectedfrom=MSDN

I don't see how the info on that link would apply to this particular
scenario, as doing such discovery on the client would be redundant since
the server, if properly implemented, already did it.

Please clarify if you think I misunderstood your case.


Cheers,

Enzo

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5D84A2A69
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320429; cv=none; b=RunxdY446VHwHdpch3eSRoqA4rUTZ//yCOanS/Sqr+9R8UIXYn+K43tLZdEm+XikCt4w9ExmiONWx9HlfRcRWZaKfK14ujByf0a4sjnpBHNpavpUB3sMO9tD/Ao9UuwWkt0GqS3E0JPKWHp82Fi7nWci0Lzl4Cbj8POanc2pWPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320429; c=relaxed/simple;
	bh=DP95SIxjtRi5izyDzJw+1Q5lHBWMTDyd4wGrwoKCJ84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjhquUSw/Mmw0WX3B+8MzJF3WNB6XXXU8bPq02FQhfAZbhNhecxh0MGTlJINuK/Osg1ltpVpoEAGnt31o9Z8Zgow+/fuLA1rB+RKluhvaRyWPBN0mwkPfS+kby9rh+A/FnzNm93Zq79hi8KOHpET6YXSvqrjCmfBtuCBgxMDms4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Pcx6mjKz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GN84NZ5q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p5d7/JRZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=je/k5GgG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Pcx6mjKz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GN84NZ5q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p5d7/JRZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="je/k5GgG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6C50B1F7DF;
	Tue,  6 Oct 2026 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791320420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=piwF4ou41UutJI9PugBbaLR0BvMemdEEew84nzrpxyw=;
	b=Pcx6mjKz+VUXWo/yM28xj7ptmuZg5TtaM48F2V/43wmOsd08h2cHfmpDtor9bjK4QrPUQt
	MYbQMTpw02JmJd9ibiZZQ64rblmLQeex0xnHOB5L3U8NiKYbCuFw4dhz1xLwn60xXeYLAw
	ZPsv57Qv5iHkNMsKc6UgK88RCRJRw7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791320420;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=piwF4ou41UutJI9PugBbaLR0BvMemdEEew84nzrpxyw=;
	b=GN84NZ5qqspHcGbeTpGWfNkXrqGcbry9x7BNpjLjilqlhhz4bvRrQX9wdDpVW7rr1QuUHg
	gOkw9Ubl6h0gJmAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791320416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=piwF4ou41UutJI9PugBbaLR0BvMemdEEew84nzrpxyw=;
	b=p5d7/JRZq9jcxwbmewgqSgqXH0fx3h/idV5T22xcXpe0fuIWkqqqkO7tZjtSMvcwsNTfzD
	Iqhwcpc/RO0aJAoEswwoIlHTcASCxh2aClyeUeNRzPZJLXcc9YCgCx/2iFYu4W28hmMDoe
	5eCwKpRSlX0lnFWYG8RqJNRAyMGdTzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791320416;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=piwF4ou41UutJI9PugBbaLR0BvMemdEEew84nzrpxyw=;
	b=je/k5GgGgvKRpEnaZSXhzfOgUZinsrCzSBossH3OqjBmT7kvHnDfWXM1oX3yq9waVP73OF
	7xwmUlbfVau9MADg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C95DF137AC;
	Tue,  6 Oct 2026 21:00:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j+OYFl9hxWp8SwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 06 Oct 2026 21:00:15 +0000
Date: Tue, 6 Oct 2026 18:00:05 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v3 2/2] smb: client: prevent premature discard of
 requests if reconnecting
Message-ID: <asVQ8CHNUY3bxbaz@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <20260929170358.270612-2-ematsumiya@suse.de>
 <b0f37e56c4559eb51624f76f92c23ee8@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b0f37e56c4559eb51624f76f92c23ee8@manguebit.org>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 10/06, Paulo Alcantara wrote:
>Enzo Matsumiya <ematsumiya@suse.de> writes:
>
>> Add TCP_Server_Info::reconnecting to track cifs_reconnect() lifetime.
>> Wait for it to be true in cifs_wait_for_server_reconnect(), and only
>> then wait for tcpStatus change.
>>
>> Also, return -ECONNRESET (instead of -EHOSTDOWN) if reconnect is still
>> ongoing at the end, so requests are not discarded unnecessarily;
>> -ECONNRESET is not immediately retried by intermediate layers, e.g. VFS
>> or netfs, but still serves as an indication to userspace that retrying
>> the operation might be successful.
>>
>> Changes (refactor cifs_wait_for_server_reconnect()):
>> - remove unnecessary do/while loop; use wait_event_interruptible()
>>   for hard mounts
>> - increase timeout, and base it on echo_interval to match user
>>   preferences
>> - remove useless debug log for interrupt errors
>>
>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>> ---
>> v2 -> v3:
>> - handle CifsExiting status on hard mounts (from sashiko report)
>>
>> v1 -> v2 (fix issues detected by sashiko):
>> - handle condition changes post-wait_event timeouts
>> - return -ECONNRESET instead of -EAGAIN when leaving still reconnecting
>>
>> (not from sashiko):
>> - add missing wake_up() after setting server->reconnecting to true in
>>   cifs_tcp_ses_needs_reconnect()
>> - handle tcpStatus == CifsExiting in cifs_wait_for_server_reconnect()
>>  fs/smb/client/cifsglob.h |  1 +
>>  fs/smb/client/connect.c  |  4 ++
>>  fs/smb/client/misc.c     | 94 ++++++++++++++++++++++++++++------------
>>  3 files changed, 72 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
>> index e49140d5c4a4..61191a167b89 100644
>> --- a/fs/smb/client/cifsglob.h
>> +++ b/fs/smb/client/cifsglob.h
>> @@ -803,6 +803,7 @@ struct TCP_Server_Info {
>>  	struct delayed_work reconnect; /* reconnect workqueue job */
>>  	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
>>  	bool need_sock_shutdown; /* true when CifsNeedReconnect was first set by non-cifsd task */
>> +	bool reconnecting; /* if cifs_reconnect() is indeed running */
>>  	unsigned long echo_interval;
>>
>>  	/*
>> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>> index 733d50b042fd..8ea60965ae06 100644
>> --- a/fs/smb/client/connect.c
>> +++ b/fs/smb/client/connect.c
>> @@ -374,6 +374,8 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
>>  	shutdown = (server->tcpStatus != CifsNeedReconnect || server->need_sock_shutdown);
>>  	server->need_sock_shutdown = false;
>>  	server->tcpStatus = CifsNeedReconnect;
>> +	server->reconnecting = true;
>> +	wake_up(&server->response_q);
>>  	spin_unlock(&server->srv_lock);
>>
>>  	if (shutdown) {
>> @@ -457,6 +459,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
>>  	spin_lock(&server->srv_lock);
>>  	if (server->tcpStatus == CifsNeedNegotiate)
>>  		mod_delayed_work(cifsiod_wq, &server->echo, 0);
>> +	server->reconnecting = false;
>>  	spin_unlock(&server->srv_lock);
>>
>>  	wake_up(&server->response_q);
>> @@ -599,6 +602,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
>>  	spin_lock(&server->srv_lock);
>>  	if (server->tcpStatus == CifsNeedNegotiate)
>>  		mod_delayed_work(cifsiod_wq, &server->echo, 0);
>> +	server->reconnecting = false;
>>  	spin_unlock(&server->srv_lock);
>>
>>  	wake_up(&server->response_q);
>> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
>> index 05168284f205..3fa4e36aac32 100644
>> --- a/fs/smb/client/misc.c
>> +++ b/fs/smb/client/misc.c
>> @@ -1077,44 +1077,84 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
>>
>>  int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
>>  {
>> -	int timeout = 10;
>> -	int rc;
>> +	int timeout, rc = 0;
>>
>>  	spin_lock(&server->srv_lock);
>>  	if (server->tcpStatus != CifsNeedReconnect) {
>> +		if (unlikely(server->tcpStatus == CifsExiting))
>> +			rc = -ESHUTDOWN;
>>  		spin_unlock(&server->srv_lock);
>> -		return 0;
>> +
>> +		return rc;
>> +	}
>> +
>> +	/* Hard mounts keep waiting until process is killed or server comes back on-line. */
>> +	if (retry) {
>> +		spin_unlock(&server->srv_lock);
>> +
>> +		return wait_event_interruptible(server->response_q,
>> +						(server->tcpStatus != CifsNeedReconnect));
>
>Hrm - given the above comment, makes me think that we should be calling
>wait_event_killable() instead on hard mounts.  But that would change
>current behavior, so it's probably better to handle it separately.
>
>What do you think?

Well, I don't see any real change in behavior, but can you elaborate
further please?  I don't understand what would be the advantage or
necessity of this change.

>>  	}
>> -	timeout *= server->nr_targets;
>> +
>> +	/*
>> +	 * Soft mounts, wait with timeout.
>> +	 * Compute timeout based on echo_interval, to match user expectations wrt. time to recover
>> +	 * from network interruptions.
>> +	 *
>> +	 * Minimum is 17 seconds (per reconnect target):
>> +	 *   7s for cifs socket timeout
>> +	 *   3s sleep after a failed attempt
>> +	 *   7s spare, to cover at least a full attempt
>> +	 *
>> +	 * Maximum is 60s; might not be enough in some rare cases, but >60s is too much.
>> +	 */
>> +	timeout = max(server->echo_interval / HZ, 17) * server->nr_targets;
>> +	timeout = min(timeout, 60);
>
>I know you've intentionally increased the timeout, but my worry is that
>I/O will now fail with -ECONNRESET/-EHOSTDOWN after 180-240s instead of
>10s on soft mounts with a single target server?

Note that max timeout is capped at 60s.
But yes, without patch 1, it's entirely possible to wait that much.

(I'm assuming we're both considering the server to be down for >60s)

I just increased the timeout as a preventive measure, because now we
can afford to wait longer (because of patch 1 "fail fast").

The core idea is to have more requests retried after a reconnect,
instead of just missing most of them (-EHOSTDOWN, not retryable).

>Are you sure that the best option is to rely on the echo_interval value?

 From the comment:

>> +	 * Compute timeout based on echo_interval, to match user expectations wrt. time to recover
>> +	 * from network interruptions.

Since we compute a time based on echo_interval to consider a server
as unresponsive on the receiving side, I thought it'd be fair to use
the same base on the sending side.

Also, it's a way to have it:
- (somewhat) user-configurable
- (somewhat) standardized, e.g. "why are my requests failing in 10s if
   my server has been down for only 30s, and echo_interval is 60s?"

>The rest looks good, thanks for fixing this issue.

Thanks for reviewing!

Since you mentioned "180-240s" timeout, I assume you considered
3*echo_interval (like e.g. server_unresponsive()), which sure looks
excessive, but I used echo_interval (1x) only.

But again, echo_interval is just a base, maximum is 60s.
Let me know if I should still change that.


Cheers,

Enzo


============
Extra topics:

cifs_wait_for_server_reconnect() is just waiting for server to
reconnect.  When it times out, it means reconnect took too long.
i.e it has no ability whatsoever to determine whether the server is
really down, other than tcpStatus still begin CifsNeedReconnect.

- shouldn't it always return some retryable error because of that?

cifs_reconnect() keeps running indefinitely, even on soft mounts, even
if the server is never coming back again.

- shouldn't it have limited retries (for soft mounts)?  it could be
   re-triggered e.g. on the next send attempt

This would also allow cifs_wait_for_server_reconnect() to return a
retryable error safely, as I/O would never get into some infinite retry
loop.

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F49134BA50
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 18:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791312780; cv=none; b=Nz+XP8e+YrcnQCC6zPut1p1jDJIJeViryjGMZROSMlkmkuYdIpoYhVRZQnHwa+JQLsDRtM/GPGheqFArFJrhxN8ld+DMUO3pVKYKqrpYAi/5eFsnKxcsjwI1PvcDiX2/84/E3+nGys5Z49moxabHBaoLGUe7HWtTjk3eZpLXE/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791312780; c=relaxed/simple;
	bh=V3BYy+Uz/chS/Wm0oCgjMrO3ffMOoxkOHDtJXZPiqbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BG3iqegnTd6zLc3/Unq9WhcjFJqD8FVFgjpir/MleI2wcTbx+BEfeuCqUTCG4lo68Sk4i9HVA2pCUxWm2toxK5H9o2XHpbCIeBM6Z8KPLlwKVaNz/MPvFFk93hw5QBQA43esHc85XTDEhTmYqNDTR7tJa5Wt0UcGOZ0J/BxYy8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TgV2/TYa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kbpRp1eq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XLdH1k0P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BdXDNJ4p; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TgV2/TYa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kbpRp1eq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XLdH1k0P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BdXDNJ4p"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C018E1F790;
	Tue,  6 Oct 2026 18:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791312772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruIdQcMt3eD8Eo3IGE2Oase70KS1iLCSHU6lTXu/WQ4=;
	b=TgV2/TYahUMdk8pdn0AJoa0hw9g4jKVzLDywvNbpfCwZyH3xeJlwKruEYBKkT8B77MmSfz
	ZpeMK/03u0XhDNgLHe8m3Y+A80kBkgWS0Tcube96UYhpZDpzIxwR1/a7CE84alnY0TZVia
	nooPEKGA9DKLnCr36C3+fvyxxszMRfI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791312772;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruIdQcMt3eD8Eo3IGE2Oase70KS1iLCSHU6lTXu/WQ4=;
	b=kbpRp1eqiZ5fiK22GybUxguAhwQoAWtzrAgPQ59/XVjsS7+WRVAfOomdRV/hczw3U2MKmb
	n5HeNhFQucwUYBAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XLdH1k0P;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BdXDNJ4p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791312768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruIdQcMt3eD8Eo3IGE2Oase70KS1iLCSHU6lTXu/WQ4=;
	b=XLdH1k0PSDbt8v3+Dvzf7ho479mteev5rVkvehBzLlhMJY0KlygYXCPCLnD5nvD+ztxS5Y
	GomSbJLSUW+TrNQWaqH03xP8J7AYfG5uOYL9TDbSDv6a+NVG8o8AQLhaVfY0nF8xVLfpV8
	BJh1W4VPtQkTogwPhMR1T5XmQGmZ464=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791312768;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruIdQcMt3eD8Eo3IGE2Oase70KS1iLCSHU6lTXu/WQ4=;
	b=BdXDNJ4p0AdpcgIBxXo8V193eSfhDDCT4+NqUzrm7M1+WMO1tm9E4/A6InCjf4OWvPvvOI
	dy1lhnQOiKNkiwCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F0F7137AC;
	Tue,  6 Oct 2026 18:52:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ESG3LH9DxWoCRwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 06 Oct 2026 18:52:47 +0000
Date: Tue, 6 Oct 2026 15:52:45 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v3 1/2] smb: client: fast fail sends if need to reconnect
Message-ID: <asU7Jr6Q_PJuubBJ@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <4627cfd704304e43bed6825ae68699ad@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4627cfd704304e43bed6825ae68699ad@manguebit.org>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C018E1F790
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 10/06, Paulo Alcantara wrote:
>Enzo Matsumiya <ematsumiya@suse.de> writes:
>
>> smb_send_kvec() keeps retrying when server needs to reconnect, which
>> makes no sense as cifs_reconnect() will never run in parallel (because
>> both need server mutex).
>> IOW, retrying will never succeed, but only delay reconnects further.
>>
>> Bail out early from smb_send_kvec() when need to reconnect.
>>
>> Also shutdown socket queues when CifsNeedReconnect is first detected,
>> so any sends/receives fails immediately (and don't wait for socket to
>> timeout).
>>
>> Add TCP_Server_Info::need_sock_shutdown to ensure socket is shutdown
>> only once.
>>
>> kernel_sock_shutdown() will be called from whichever task detects it
>> first;  cifsd (cifs_tcp_ses_needs_reconnect()), or sending tasks,
>> through cifs_call_async() or compound_send_recv().
>>
>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>> ---
>> v2 -> v3 (patch refactor, change strategy but keep concept):
>> - remove TCP_Server_Info::mutex_owner (covers sashiko report)
>> - shutdown socket directly from sender functions (when need to reconnect)
>> - bail out from smb_send_kvec() when need to reconnect only if rc <= 0
>>   (from sasiko report)
>>
>> v1 -> v2 (fix issues detected by sashiko):
>> - move kernel_sock_shutdown() call out of cifs_tcp_ses_lock
>> - use server mutex to check/shutdown socket
>>
>>
>>  fs/smb/client/cifsglob.h  |  1 +
>>  fs/smb/client/connect.c   | 22 +++++++++++++++++++---
>>  fs/smb/client/transport.c | 30 ++++++++++++++++++++++++++++++
>>  3 files changed, 50 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
>> index 79e4e84f8985..e49140d5c4a4 100644
>> --- a/fs/smb/client/cifsglob.h
>> +++ b/fs/smb/client/cifsglob.h
>> @@ -802,6 +802,7 @@ struct TCP_Server_Info {
>>  	bool	posix_ext_supported;
>>  	struct delayed_work reconnect; /* reconnect workqueue job */
>>  	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
>> +	bool need_sock_shutdown; /* true when CifsNeedReconnect was first set by non-cifsd task */
>>  	unsigned long echo_interval;
>>
>>  	/*
>> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>> index 28e1ddeb6182..733d50b042fd 100644
>> --- a/fs/smb/client/connect.c
>> +++ b/fs/smb/client/connect.c
>> @@ -126,12 +126,14 @@ void smb2_query_server_interfaces(struct work_struct *work)
>>  	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
>>  			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
>>  }
>> -
>
>Why are you removing the blank line?

Probably just because I saw it.
Not sure why it should stay there, but I'll drop it.

>>  #define set_need_reco(server) \
>>  do { \
>>  	spin_lock(&server->srv_lock); \
>> -	if (server->tcpStatus != CifsExiting) \
>> +	if (server->tcpStatus != CifsExiting) { \
>> +		if (server->tcpStatus != CifsNeedReconnect) \
>> +			server->need_sock_shutdown = true; \
>>  		server->tcpStatus = CifsNeedReconnect; \
>> +	} \
>>  	spin_unlock(&server->srv_lock); \
>>  } while (0)
>>
>> @@ -353,6 +355,8 @@ cifs_abort_connection(struct TCP_Server_Info *server)
>>
>>  static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
>>  {
>> +	bool shutdown;
>> +
>>  	spin_lock(&server->srv_lock);
>>  	server->nr_targets = num_targets;
>>  	if (server->tcpStatus == CifsExiting) {
>> @@ -365,9 +369,21 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
>>  	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
>>  	trace_smb3_reconnect(server->current_mid, server->conn_id,
>>  			     server->hostname);
>> -	server->tcpStatus = CifsNeedReconnect;
>>
>> +	/* Cover cases where sender tasks didn't manage to shutdown the socket for some reason */
>> +	shutdown = (server->tcpStatus != CifsNeedReconnect || server->need_sock_shutdown);
>> +	server->need_sock_shutdown = false;
>> +	server->tcpStatus = CifsNeedReconnect;
>>  	spin_unlock(&server->srv_lock);
>> +
>> +	if (shutdown) {
>> +		cifs_server_lock(server);
>> +		if (server->ssocket)
>> +			/* Don't release it here/yet! */
>> +			kernel_sock_shutdown(server->ssocket, SHUT_RDWR);
>> +		cifs_server_unlock(server);
>> +	}
>> +
>
>The new TCP_Server_Info::need_sock_shutdown field seems unnecessary.
>
>You could simply call kernel_sock_shutdown() if @server->ssocket != NULL
>after releasing ->srv_sock, as the socket can be shut down only once.

The idea is to ensure the socket is shutdown only once from cifs POV,
not TCP/net -- e.g. there could be simultaneous threads reaching the
same code and shutdown the socket right after cifs_reconnect()
successfully connected.

>>  }
>>
>> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
>> index 6e21b5f8754a..a1ae8548cf16 100644
>> --- a/fs/smb/client/transport.c
>> +++ b/fs/smb/client/transport.c
>> @@ -179,7 +179,18 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
>>  		 * to avoid unnecessary reconnects.
>>  		 */
>>  		rc = sock_sendmsg(ssocket, smb_msg);
>> +
>> +		/*
>> +		 * If need to reconnect, blame it for any non-interrupt error and bail out early,
>> +		 * even if -EAGAIN;  reconnect will never happen in parallel as cifs_reconnect()
>> +		 * needs server mutex (which we're already holding), so it's pointless to retry.
>> +		 */
>
>Long lines.  Keep them at 80 columns max.
>
>Consider doing the same for the rest of the series.

checkpatch.pl has a default max_line_length = 100.  I was (have been)
just following that, but sure I can change it.

>
>> +		if (unlikely(rc <= 0 && server->tcpStatus == CifsNeedReconnect &&
>> +			     !is_interrupt_error(rc)))
>> +			return -ECONNRESET;
>
>You are reading tcpStatus without holding ->srv_lock.  Is that OK?  If
>so, you should use READ_ONCE() here.

Ack, I'll add READ_ONCE().
Unlocked read should be ok; it's a very specific condition, and even if
it changes e.g. after returning, it means it reconnected, and we need to
return some error anyway.

>> +
>>  		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
>> +
>
>Remove this new blank line.

Wait, I thought we were keeping blank lines?! lol I'll remove it.

>
>>  			retries++;
>>  			if (retries >= 14 ||
>>  			    (!server->noblocksnd && (retries > 2))) {
>> @@ -654,6 +665,23 @@ int wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>>  	return 0;
>>  }
>>
>> +static inline void cond_sock_shutdown(struct TCP_Server_Info *server)
>
>inline is unnecessary.  This isn't even hot path.

Ack.

>> +{
>> +	bool shutdown;
>> +
>> +	lockdep_assert_held(&server->_srv_mutex);
>> +
>> +	spin_lock(&server->srv_lock);
>> +	/* No need to check status, need_sock_shutdown is only set if CifsNeedReconnect */
>> +	shutdown = (server->need_sock_shutdown && server->ssocket);
>
>Again, TCP_Server_info::need_sock_shutdown doesn't seem to be required
>as you could have done
>
>        shutdown = server->tcpStatus == CifsNeedReconnect && server->ssocket;

cf. comment above -- it's specially true for this case, as
cond_sock_shutdown() is called from cifs_call_async() and
compound_send_recv(), which increases the chances of them shutting
down the socket right after it's connected.

(because they're reachable from userspace, whereas the above shutdown is
done by cifsd, which we control)

>Besides, the parentheses are unnecessary, so remove them.

Ack.

>Otherwise, looks good.


Thanks!  I'll send v4 addressing the issues you pointed out.


Enzo

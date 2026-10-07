Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D0737F31D
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791385508; cv=none; b=KS3xRWIOq5cyZ1z+D36k9tvmrhZd0zpEnYSVBG6J2PCnzME9Btx5S3IQltEJ7r5ktVqnMSYNaixuDJ7t24drFDsLPvFkLxaV6kV1DlrOpC+eiE0leMWo9dDjynxlKziAfaKFRBezfQ1h+PIz+Cg1whN+spfyaSmByJ3yLRVO9uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791385508; c=relaxed/simple;
	bh=ZlJfkBs0upsY4VDTxvRrKcd+c7A0WGbK9fZ+37lXCp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gvp9PophWl/QAxdJL12hmgAVOP5UASV83FUVwEWJCWETpz1UFvYPq/LW9P0G40qcgRPZoRxEXOfHu0S94Ye3iyCsDl/E/CoGcfWV9N/4IXyRFHy5+aX24ooy7e0kOXHPAQWxvf9huabFsQFc1p3iqYPmVVpj4x3g8C+dY994MF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wLZkXKXG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dTqd8kz1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wLZkXKXG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dTqd8kz1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wLZkXKXG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dTqd8kz1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wLZkXKXG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dTqd8kz1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B3F221B9C;
	Wed,  7 Oct 2026 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791385498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=alOrbn9iL0ufh3RZngpjGORwM58lr7kCg3F4vmxk7jQ=;
	b=wLZkXKXGgr/KCsOHN6WQBrk6X08nxLEqgjXskJ6gOz/LeNW/u0uDz5H+51iTrBtD3XmLG3
	cbxxNOwt0B0qwOhZvFGOW3INSsr3faRPT4rMNIfauRUd45PaUxRaDft1lvIASHIkPaP+pb
	sFf6lM/URmbluMwKxomzlFkiUAmxQ88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791385498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=alOrbn9iL0ufh3RZngpjGORwM58lr7kCg3F4vmxk7jQ=;
	b=dTqd8kz1cVotYVEsmbjTrzfvIU5ibl/A4o21PJN4a1+0OzKrTxvF3k0BeRKShKIWpiryN+
	RTRm2NvOt9zd+JDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791385498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=alOrbn9iL0ufh3RZngpjGORwM58lr7kCg3F4vmxk7jQ=;
	b=wLZkXKXGgr/KCsOHN6WQBrk6X08nxLEqgjXskJ6gOz/LeNW/u0uDz5H+51iTrBtD3XmLG3
	cbxxNOwt0B0qwOhZvFGOW3INSsr3faRPT4rMNIfauRUd45PaUxRaDft1lvIASHIkPaP+pb
	sFf6lM/URmbluMwKxomzlFkiUAmxQ88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791385498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=alOrbn9iL0ufh3RZngpjGORwM58lr7kCg3F4vmxk7jQ=;
	b=dTqd8kz1cVotYVEsmbjTrzfvIU5ibl/A4o21PJN4a1+0OzKrTxvF3k0BeRKShKIWpiryN+
	RTRm2NvOt9zd+JDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74F6513354;
	Wed,  7 Oct 2026 15:04:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vSCmAZlfxmrjdAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 07 Oct 2026 15:04:57 +0000
Date: Wed, 7 Oct 2026 12:04:51 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v3 2/2] smb: client: prevent premature discard of
 requests if reconnecting
Message-ID: <asZBhhspdoKMRfCd@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <20260929170358.270612-2-ematsumiya@suse.de>
 <b0f37e56c4559eb51624f76f92c23ee8@manguebit.org>
 <asVQ8CHNUY3bxbaz@suse.de>
 <00e0fcdfdde0a281ed3f080040d6fb63@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <00e0fcdfdde0a281ed3f080040d6fb63@manguebit.org>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]

On 10/06, Paulo Alcantara wrote:
>Enzo Matsumiya <ematsumiya@suse.de> writes:
>
>> On 10/06, Paulo Alcantara wrote:
>>>> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
>>>> index 05168284f205..3fa4e36aac32 100644
>>>> --- a/fs/smb/client/misc.c
>>>> +++ b/fs/smb/client/misc.c
>>>> @@ -1077,44 +1077,84 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
>>>>
>>>>  int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
>>>>  {
>>>> -	int timeout = 10;
>>>> -	int rc;
>>>> +	int timeout, rc = 0;
>>>>
>>>>  	spin_lock(&server->srv_lock);
>>>>  	if (server->tcpStatus != CifsNeedReconnect) {
>>>> +		if (unlikely(server->tcpStatus == CifsExiting))
>>>> +			rc = -ESHUTDOWN;
>>>>  		spin_unlock(&server->srv_lock);
>>>> -		return 0;
>>>> +
>>>> +		return rc;
>>>> +	}
>>>> +
>>>> +	/* Hard mounts keep waiting until process is killed or server comes back on-line. */
>>>> +	if (retry) {
>>>> +		spin_unlock(&server->srv_lock);
>>>> +
>>>> +		return wait_event_interruptible(server->response_q,
>>>> +						(server->tcpStatus != CifsNeedReconnect));
>>>
>>>Hrm - given the above comment, makes me think that we should be calling
>>>wait_event_killable() instead on hard mounts.  But that would change
>>>current behavior, so it's probably better to handle it separately.
>>>
>>>What do you think?
>>
>> Well, I don't see any real change in behavior, but can you elaborate
>> further please?  I don't understand what would be the advantage or
>> necessity of this change.
>
>What I mean is that calling wait_event_interruptible() doesn't exactly match
>
>        /* Hard mounts keep waiting until process is killed or server comes back on-line. */
>
>or 'hard' mount description in mount.cifs(8).
>
>SIGINT could interrupt that.  That's why I suggested calling
>wait_event_killable() instead.  This isn't a problem with your patch, so
>don't need to worry about that.

Got it.  Your suggestion indeed makes sense.

>>>>  	}
>>>> -	timeout *= server->nr_targets;
>>>> +
>>>> +	/*
>>>> +	 * Soft mounts, wait with timeout.
>>>> +	 * Compute timeout based on echo_interval, to match user expectations wrt. time to recover
>>>> +	 * from network interruptions.
>>>> +	 *
>>>> +	 * Minimum is 17 seconds (per reconnect target):
>>>> +	 *   7s for cifs socket timeout
>>>> +	 *   3s sleep after a failed attempt
>>>> +	 *   7s spare, to cover at least a full attempt
>>>> +	 *
>>>> +	 * Maximum is 60s; might not be enough in some rare cases, but >60s is too much.
>>>> +	 */
>>>> +	timeout = max(server->echo_interval / HZ, 17) * server->nr_targets;
>>>> +	timeout = min(timeout, 60);
>>>
>>>I know you've intentionally increased the timeout, but my worry is that
>>>I/O will now fail with -ECONNRESET/-EHOSTDOWN after 180-240s instead of
>>>10s on soft mounts with a single target server?
>>
>> Note that max timeout is capped at 60s.
>
>Yes, but you're changing it from 10s to 60s with default mount options.
>That's a big difference.  I recall people complaining about having to
>wait 10s on soft mounts.  There was even an early patch sent to the ML
>getting rid of that default 10s.

Ack.

>> But yes, without patch 1, it's entirely possible to wait that much.
>>
>> (I'm assuming we're both considering the server to be down for >60s)
>>
>> I just increased the timeout as a preventive measure, because now we
>> can afford to wait longer (because of patch 1 "fail fast").
>>
>> The core idea is to have more requests retried after a reconnect,
>> instead of just missing most of them (-EHOSTDOWN, not retryable).
>
>I understand.  But with soft mounts, we ought to fail it as quickly as
>possible and then let caller decide whether it will retry the request or
>not.  Having them now to wait for ~60s to either get either -EHOSTDOWN
>or -EAGAIN doesn't look good to me.

I kind of agree with that, it's just that increasing the timeout was the
smoothest way to handle the scenario I mentioned.

Just a small note here regarding "let caller decide to retry":
-EHOSTDOWN is not considered, or aliased to, a retryable error
anywhere in cifs, and usually neither by most userspace applications.

i.e. it always bubbles up to userspace and applications are terminated.

>>>Are you sure that the best option is to rely on the echo_interval value?
>>
>>  From the comment:
>>
>>>> +	 * Compute timeout based on echo_interval, to match user expectations wrt. time to recover
>>>> +	 * from network interruptions.
>>
>> Since we compute a time based on echo_interval to consider a server
>> as unresponsive on the receiving side, I thought it'd be fair to use
>> the same base on the sending side.
>>
>> Also, it's a way to have it:
>> - (somewhat) user-configurable
>> - (somewhat) standardized, e.g. "why are my requests failing in 10s if
>>    my server has been down for only 30s, and echo_interval is 60s?"
>>
>>>The rest looks good, thanks for fixing this issue.
>>
>> Thanks for reviewing!
>>
>> Since you mentioned "180-240s" timeout, I assume you considered
>> 3*echo_interval (like e.g. server_unresponsive()), which sure looks
>> excessive, but I used echo_interval (1x) only.
>>
>> But again, echo_interval is just a base, maximum is 60s.
>> Let me know if I should still change that.
>
>It's fine, as long as we don't hang too long on soft mounts.
>
>> cifs_wait_for_server_reconnect() is just waiting for server to
>> reconnect.  When it times out, it means reconnect took too long.
>> i.e it has no ability whatsoever to determine whether the server is
>> really down, other than tcpStatus still begin CifsNeedReconnect.
>>
>> - shouldn't it always return some retryable error because of that?
>
>No.  It is up to the caller to decide whether it will return a retryable
>error.  Returning a retryable error when the server is down might not
>make sense.

My point was that cifs_wait_for_server_reconnect() has no way to
know/determine whether the server is really down -- especially in a 10s
window, and even more especially when it waited 10s but
cifs_reconnect() didn't even start yet.

cifs_reconnect() is the only one that could possibly determine that
in this case;  it can count the number of failed attempts, act based
on error code, check socket state, etc.

Ideally, IMHO, that could be identifiable by yet another tcpStatus,
one that represents something like "we failed to reconnect too many
times to this server, but it's not supposed to go away yet", e.g.
CifsReconnectFailed, or CifsServerDown, or whatever.

Then set it after e.g. 3 reconnect failures in cifs_reconnect(),
but keep retrying regardless.

This way, cifs_wait_for_server_reconnect() could interpret it as:
- CifsNeedReconnect -> cifs_reconnect() might be running, not many
   failures -> can wait a little longer, return -EAGAIN
- CifsServerDown -> cifs_reconnect() already tried and failed too
   many times -> don't wait, return -EHOSTDOWN

Thoughts on that?

> smb2_reconnect() does return a retryable error from certain
>SMB commands, but at that point the TCP connection and SMB session were
>re-established.
>
>> cifs_reconnect() keeps running indefinitely, even on soft mounts, even
>> if the server is never coming back again.
>
>Do you mean in cifsd?  If so, I don't see any problem with that.  Better
>than keeping it idle.
>
>That could even help the next I/O to not waste any time trying to
>reconnect to the server, as cifsd already did that.
>smb2_reconnect_server() worker also helps with trying to re-establish a
>session with the server.

Ack.

>> - shouldn't it have limited retries (for soft mounts)?  it could be
>>    re-triggered e.g. on the next send attempt
>>
>> This would also allow cifs_wait_for_server_reconnect() to return a
>> retryable error safely, as I/O would never get into some infinite retry
>> loop.
>
>Note that there's currently no backoff mechanism in either CIFS or
>netfslib for writeback, meaning that the write requests will be retried
>forever if the server goes offline.  You'll end up with tasks hanging
>forever on close or fsync.

Yes, that was actually the main bug I wanted to fix with patch 1.

I don't know if you said "forever" as an exaggeration or literally, but
from my tests, I did experience an application taking like 2h to terminate
after dropping the network.

I could observe the number of writer tasks decreasing, slowly, but I
never got an indication that they'd be hanging forever (literally).

Can you try patch 1 with your reproducer please?  And let me know how it
works for you.

This patch 2 should not be necessary for that case.

>Trying to fix that in the reconnect path
>doesn't seem the right way to do it, IMO.
>
>In the non-writepack path, we definitely want to return as quickly as
>possible on soft mounts and then let userspace decide whether it will
>retry the request or not.
>
>Please let me know what I'm missing as you could have more information
>on the issues that your customers reported.

Not really.  Your observation about the writeback path is spot on -- it
was precisely what the reports were about.

Handling in cifs reconnect path was just easier given that we have
kernels that are pre- or mid-netfs migration.

I'll send v4 addressing the solid concerns you mentioned.

However, I'd like very much to keep discussing the other concerns.
I think reconnect in cifs needs a lot more attention, e.g. I've had
(non-customer) issues with failover in DFS, multichannel, and
Windows clusters.


Cheers,

Enzo

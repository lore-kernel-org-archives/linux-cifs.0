Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BCE4D09EF
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 22:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791327111; cv=none; b=E5ImM991O1IyDBNzj+4rKu8wKumdOcG0QN2UI8RWLpZRT0JJbpNmbdeIYD5ByeLx9RgVQ1XICpVkNUlFInlbV4kiM9IkIs7YJiPL0V7pJcUfmOfljfQzTstJ8GEUpTjQxTh+ASbjaFACi6BL0yG8u0x/Y1qaPK55km5WpAHyGz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791327111; c=relaxed/simple;
	bh=QXu7dn5rxoC/F1cJM/QpR3f3D7qGq9UfqJoIHoM+tsU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=t9qcpBqXP9Uf6SDuOJHcVEDJ+YfZwwgpt/OMD7L1F8fu+tlMPqUYcKRR/y3AY9DKP504I24UVtqyStTBDQ4LBXqP7elG1W9nOp00CFlCCG6KNcjNDrVBcBhazZmJbYJa1m0MN036vbLrjUctS0XlFDE7fQuJRxSDG7jVVCJpe4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=PaVcQGU7; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="PaVcQGU7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=swPnh9YOpdK9UymP2fXJrzGUsJi7DeWE6ADqVMC+CfM=; b=PaVcQGU75NOQhxtVYc52PTuiAM
	dOspUSsRskD87vcdNUwk84dIvxDa3+RbKOiYHI7dpUQntGF2kp0M94K1GMZVPWuGQauDTeVch1/1I
	z3vTuVW/xk9qaoYLxjmxPCguKYHB/gd+0BA8epczl1hqdKIyRKbSu/9FZLpwBln75SiXRX6zaG3wv
	Ir3Cbx32c2/uDkhqXXfieEWq6ayBhFupJaFMmelxEEkVrOHAEwfEKozlY2XJm92tVIdkVnf+61U7u
	Zn9ncSabMk+WYHTb87zxfccaUTB2ETtZEvQ1Myf3603iBoT50ZJcOtHVY9NMBCRLpOzQAWlrNglL7
	ZEAMv5uA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xEE0e-00000003416-2Jq5;
	Tue, 06 Oct 2026 19:51:44 -0300
Message-ID: <00e0fcdfdde0a281ed3f080040d6fb63@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH v3 2/2] smb: client: prevent premature discard of
 requests if reconnecting
In-Reply-To: <asVQ8CHNUY3bxbaz@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <20260929170358.270612-2-ematsumiya@suse.de>
 <b0f37e56c4559eb51624f76f92c23ee8@manguebit.org>
 <asVQ8CHNUY3bxbaz@suse.de>
Date: Tue, 06 Oct 2026 19:51:44 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> On 10/06, Paulo Alcantara wrote:
>>> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
>>> index 05168284f205..3fa4e36aac32 100644
>>> --- a/fs/smb/client/misc.c
>>> +++ b/fs/smb/client/misc.c
>>> @@ -1077,44 +1077,84 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
>>>
>>>  int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
>>>  {
>>> -	int timeout = 10;
>>> -	int rc;
>>> +	int timeout, rc = 0;
>>>
>>>  	spin_lock(&server->srv_lock);
>>>  	if (server->tcpStatus != CifsNeedReconnect) {
>>> +		if (unlikely(server->tcpStatus == CifsExiting))
>>> +			rc = -ESHUTDOWN;
>>>  		spin_unlock(&server->srv_lock);
>>> -		return 0;
>>> +
>>> +		return rc;
>>> +	}
>>> +
>>> +	/* Hard mounts keep waiting until process is killed or server comes back on-line. */
>>> +	if (retry) {
>>> +		spin_unlock(&server->srv_lock);
>>> +
>>> +		return wait_event_interruptible(server->response_q,
>>> +						(server->tcpStatus != CifsNeedReconnect));
>>
>>Hrm - given the above comment, makes me think that we should be calling
>>wait_event_killable() instead on hard mounts.  But that would change
>>current behavior, so it's probably better to handle it separately.
>>
>>What do you think?
>
> Well, I don't see any real change in behavior, but can you elaborate
> further please?  I don't understand what would be the advantage or
> necessity of this change.

What I mean is that calling wait_event_interruptible() doesn't exactly match

        /* Hard mounts keep waiting until process is killed or server comes back on-line. */

or 'hard' mount description in mount.cifs(8).

SIGINT could interrupt that.  That's why I suggested calling
wait_event_killable() instead.  This isn't a problem with your patch, so
don't need to worry about that.

>>>  	}
>>> -	timeout *= server->nr_targets;
>>> +
>>> +	/*
>>> +	 * Soft mounts, wait with timeout.
>>> +	 * Compute timeout based on echo_interval, to match user expectations wrt. time to recover
>>> +	 * from network interruptions.
>>> +	 *
>>> +	 * Minimum is 17 seconds (per reconnect target):
>>> +	 *   7s for cifs socket timeout
>>> +	 *   3s sleep after a failed attempt
>>> +	 *   7s spare, to cover at least a full attempt
>>> +	 *
>>> +	 * Maximum is 60s; might not be enough in some rare cases, but >60s is too much.
>>> +	 */
>>> +	timeout = max(server->echo_interval / HZ, 17) * server->nr_targets;
>>> +	timeout = min(timeout, 60);
>>
>>I know you've intentionally increased the timeout, but my worry is that
>>I/O will now fail with -ECONNRESET/-EHOSTDOWN after 180-240s instead of
>>10s on soft mounts with a single target server?
>
> Note that max timeout is capped at 60s.

Yes, but you're changing it from 10s to 60s with default mount options.
That's a big difference.  I recall people complaining about having to
wait 10s on soft mounts.  There was even an early patch sent to the ML
getting rid of that default 10s.

> But yes, without patch 1, it's entirely possible to wait that much.
>
> (I'm assuming we're both considering the server to be down for >60s)
>
> I just increased the timeout as a preventive measure, because now we
> can afford to wait longer (because of patch 1 "fail fast").
>
> The core idea is to have more requests retried after a reconnect,
> instead of just missing most of them (-EHOSTDOWN, not retryable).

I understand.  But with soft mounts, we ought to fail it as quickly as
possible and then let caller decide whether it will retry the request or
not.  Having them now to wait for ~60s to either get either -EHOSTDOWN
or -EAGAIN doesn't look good to me.

>>Are you sure that the best option is to rely on the echo_interval value?
>
>  From the comment:
>
>>> +	 * Compute timeout based on echo_interval, to match user expectations wrt. time to recover
>>> +	 * from network interruptions.
>
> Since we compute a time based on echo_interval to consider a server
> as unresponsive on the receiving side, I thought it'd be fair to use
> the same base on the sending side.
>
> Also, it's a way to have it:
> - (somewhat) user-configurable
> - (somewhat) standardized, e.g. "why are my requests failing in 10s if
>    my server has been down for only 30s, and echo_interval is 60s?"
>
>>The rest looks good, thanks for fixing this issue.
>
> Thanks for reviewing!
>
> Since you mentioned "180-240s" timeout, I assume you considered
> 3*echo_interval (like e.g. server_unresponsive()), which sure looks
> excessive, but I used echo_interval (1x) only.
>
> But again, echo_interval is just a base, maximum is 60s.
> Let me know if I should still change that.

It's fine, as long as we don't hang too long on soft mounts.

> cifs_wait_for_server_reconnect() is just waiting for server to
> reconnect.  When it times out, it means reconnect took too long.
> i.e it has no ability whatsoever to determine whether the server is
> really down, other than tcpStatus still begin CifsNeedReconnect.
>
> - shouldn't it always return some retryable error because of that?

No.  It is up to the caller to decide whether it will return a retryable
error.  Returning a retryable error when the server is down might not
make sense.  smb2_reconnect() does return a retryable error from certain
SMB commands, but at that point the TCP connection and SMB session were
re-established.

> cifs_reconnect() keeps running indefinitely, even on soft mounts, even
> if the server is never coming back again.

Do you mean in cifsd?  If so, I don't see any problem with that.  Better
than keeping it idle.

That could even help the next I/O to not waste any time trying to
reconnect to the server, as cifsd already did that.
smb2_reconnect_server() worker also helps with trying to re-establish a
session with the server.

> - shouldn't it have limited retries (for soft mounts)?  it could be
>    re-triggered e.g. on the next send attempt
>
> This would also allow cifs_wait_for_server_reconnect() to return a
> retryable error safely, as I/O would never get into some infinite retry
> loop.

Note that there's currently no backoff mechanism in either CIFS or
netfslib for writeback, meaning that the write requests will be retried
forever if the server goes offline.  You'll end up with tasks hanging
forever on close or fsync.  Trying to fix that in the reconnect path
doesn't seem the right way to do it, IMO.

In the non-writepack path, we definitely want to return as quickly as
possible on soft mounts and then let userspace decide whether it will
retry the request or not.

Please let me know what I'm missing as you could have more information
on the issues that your customers reported.

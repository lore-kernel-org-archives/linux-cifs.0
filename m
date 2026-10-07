Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436ED4A2E2E
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 23:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791415568; cv=none; b=O02erdBlKWRMF4CtJBVZnLprGBtdvLeVQg+S2zUXEbKUIUXnIhcBWC0t3zt800mQXHFmTf0P/8rUG/nPIfnd8VAprRwiR8LQADI9jyKyhLu+Z3EyGAleF0MZhBETquqO2uppiMBZO8Q8+E8HnI4SRgRHb8JtFx37RD7q0086i4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791415568; c=relaxed/simple;
	bh=6xzYu87qBLIOQHS6gvQHLQwbUK4CpYo+tWCH5OgPQBI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=o6GrhJkAf41/C7+Xc6kdf8O45h+RC+/V4bv90UBTa5L7fFUjjqbx2gUdXQej2ihF61MHLlrzhbpA0ARQWx11N99nbYoZ3h2XAR7DIQEoyE9RkugU1mHY3qyNBH6g/7dFKuvsGfW1u8oLxAuQyEVdXZ5CLpnVXjVCPgSP70e+BsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=qvmoBLzK; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="qvmoBLzK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gkrEGh+aqEwrpOk1hebjqdBDh44FpubVU+nxy4FnCXE=; b=qvmoBLzKQtkoti7PHtOK6ND8yM
	HblwEkMo9iPGCSDP1IInkDuiLhp2tiRNxqUsRade+Xz+Yc17EtC7JcTBo6OVidQDWbLXD94e9TlgT
	FP7GiRX72ShGkebWF4nVK1+g8IOrF8ywyNeuHSdryoxomZ8mOL6w5e12S1a1V1KT0Fj3uaSpwgUrY
	9Ah9BxiD2gzGluV8xBlsM2mqvDIm3mzqF52f1trnDNvimW90ViQsos88oJddI70xbBxN7xUqt/iVa
	a71wzY0/yo67FyKqTcDl459kaqYUdyvj0BNujy0TU7goLCNc8trxoTTG1EoZ36BmJuDUxRqOxnkE1
	jAgn86bA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xEb1G-000000038I0-25S7;
	Wed, 07 Oct 2026 20:25:54 -0300
Message-ID: <1b2a354f2c7bb75f6593fe28f5033623@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH v3 2/2] smb: client: prevent premature discard of
 requests if reconnecting
In-Reply-To: <asZBhhspdoKMRfCd@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <20260929170358.270612-2-ematsumiya@suse.de>
 <b0f37e56c4559eb51624f76f92c23ee8@manguebit.org>
 <asVQ8CHNUY3bxbaz@suse.de>
 <00e0fcdfdde0a281ed3f080040d6fb63@manguebit.org>
 <asZBhhspdoKMRfCd@suse.de>
Date: Wed, 07 Oct 2026 20:25:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> On 10/06, Paulo Alcantara wrote:
>>Enzo Matsumiya <ematsumiya@suse.de> writes:
>>>
>>> But yes, without patch 1, it's entirely possible to wait that much.
>>>
>>> (I'm assuming we're both considering the server to be down for >60s)
>>>
>>> I just increased the timeout as a preventive measure, because now we
>>> can afford to wait longer (because of patch 1 "fail fast").
>>>
>>> The core idea is to have more requests retried after a reconnect,
>>> instead of just missing most of them (-EHOSTDOWN, not retryable).
>>
>>I understand.  But with soft mounts, we ought to fail it as quickly as
>>possible and then let caller decide whether it will retry the request or
>>not.  Having them now to wait for ~60s to either get either -EHOSTDOWN
>>or -EAGAIN doesn't look good to me.
>
> I kind of agree with that, it's just that increasing the timeout was the
> smoothest way to handle the scenario I mentioned.
>
> Just a small note here regarding "let caller decide to retry":
> -EHOSTDOWN is not considered, or aliased to, a retryable error
> anywhere in cifs, and usually neither by most userspace applications.

Yes, I know.

Consider an userspace application that reads and writes to a file and
retries on -EAGAIN without any backoff mechanism.  If we return a
retryable error when the server goes offline and it never comes back,
the userspace application will hang.

If the user _really_ wants to make sure that every read and write call
goes to the server -- even when it goes offline for a while -- then
'hard' mount option is the best option.

>>> cifs_wait_for_server_reconnect() is just waiting for server to
>>> reconnect.  When it times out, it means reconnect took too long.
>>> i.e it has no ability whatsoever to determine whether the server is
>>> really down, other than tcpStatus still begin CifsNeedReconnect.
>>>
>>> - shouldn't it always return some retryable error because of that?
>>
>>No.  It is up to the caller to decide whether it will return a retryable
>>error.  Returning a retryable error when the server is down might not
>>make sense.
>
> My point was that cifs_wait_for_server_reconnect() has no way to
> know/determine whether the server is really down -- especially in a 10s
> window, and even more especially when it waited 10s but
> cifs_reconnect() didn't even start yet.
>
> cifs_reconnect() is the only one that could possibly determine that
> in this case;  it can count the number of failed attempts, act based
> on error code, check socket state, etc.

I disagree.  I'd rather keep it simple to just care about
re-establishing TCP connection to the server.  Handle the retries
somewhere else.  See below.

> Ideally, IMHO, that could be identifiable by yet another tcpStatus,
> one that represents something like "we failed to reconnect too many
> times to this server, but it's not supposed to go away yet", e.g.
> CifsReconnectFailed, or CifsServerDown, or whatever.
>
> Then set it after e.g. 3 reconnect failures in cifs_reconnect(),
> but keep retrying regardless.
>
> This way, cifs_wait_for_server_reconnect() could interpret it as:
> - CifsNeedReconnect -> cifs_reconnect() might be running, not many
>    failures -> can wait a little longer, return -EAGAIN
> - CifsServerDown -> cifs_reconnect() already tried and failed too
>    many times -> don't wait, return -EHOSTDOWN
>
> Thoughts on that?

Well, I assumed that the new @reconnecting field you introduced would
help with that.

Why wouldn't checking CifsNeedReconnect and
TCP_Server_Info::reconnecting be enough to know that reconnect actually
started but then failed?

About the retries, we already have 'retrans=' mount option.  Why
couldn't we fix that and then handle such retries gracefully?  If
someone doesn't care about retries and wants it to fail as quickly as
possible, 

>> smb2_reconnect() does return a retryable error from certain
>>SMB commands, but at that point the TCP connection and SMB session were
>>re-established.
>>
>>> cifs_reconnect() keeps running indefinitely, even on soft mounts, even
>>> if the server is never coming back again.
>>
>>Do you mean in cifsd?  If so, I don't see any problem with that.  Better
>>than keeping it idle.
>>
>>That could even help the next I/O to not waste any time trying to
>>reconnect to the server, as cifsd already did that.
>>smb2_reconnect_server() worker also helps with trying to re-establish a
>>session with the server.
>
> Ack.
>
>>> - shouldn't it have limited retries (for soft mounts)?  it could be
>>>    re-triggered e.g. on the next send attempt
>>>
>>> This would also allow cifs_wait_for_server_reconnect() to return a
>>> retryable error safely, as I/O would never get into some infinite retry
>>> loop.
>>
>>Note that there's currently no backoff mechanism in either CIFS or
>>netfslib for writeback, meaning that the write requests will be retried
>>forever if the server goes offline.  You'll end up with tasks hanging
>>forever on close or fsync.
>
> Yes, that was actually the main bug I wanted to fix with patch 1.
>
> I don't know if you said "forever" as an exaggeration or literally, but
> from my tests, I did experience an application taking like 2h to terminate
> after dropping the network.
>
> I could observe the number of writer tasks decreasing, slowly, but I
> never got an indication that they'd be hanging forever (literally).
>
> Can you try patch 1 with your reproducer please?  And let me know how it
> works for you.
>
> This patch 2 should not be necessary for that case.
>
>>Trying to fix that in the reconnect path
>>doesn't seem the right way to do it, IMO.
>>
>>In the non-writepack path, we definitely want to return as quickly as
>>possible on soft mounts and then let userspace decide whether it will
>>retry the request or not.
>>
>>Please let me know what I'm missing as you could have more information
>>on the issues that your customers reported.
>
> Not really.  Your observation about the writeback path is spot on -- it
> was precisely what the reports were about.
>
> Handling in cifs reconnect path was just easier given that we have
> kernels that are pre- or mid-netfs migration.

Yes, I get it.  Let me know what you think on having 'retrans=' fixed
for soft mounts.

> I'll send v4 addressing the solid concerns you mentioned.

Awesome, thanks!

> However, I'd like very much to keep discussing the other concerns.
> I think reconnect in cifs needs a lot more attention, e.g. I've had
> (non-customer) issues with failover in DFS, multichannel, and
> Windows clusters.

Absolutely.  Unfortunately it was designed to handle reconnects to a
single target server, but then we started changing it to handle more
complex scenarios like DFS failover, multichannel, etc.

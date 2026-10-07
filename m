Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B376547078
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 23:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791416122; cv=none; b=cZPNniW9kM5eC/ISlQmEEncUlJT5jAom88oTKQh9BHggwMCTizNSdI+oezjYZ0fPdnb1+VEyjxOwwI7Iftrca3WOI87DV+fXFl6QQnRZU21tSPR9KgL2F9m709N7OAnysWDDOmHOOkyYVdIy7LCrRzgUruBfOnPOKU8X0gZMBDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791416122; c=relaxed/simple;
	bh=ig63wu8Qo3nGGMb39Y8sLp3b7U6Y+r7BLEvZWN5ud1Q=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=q/cAu49bcTKt0+Q+USGsBbV9ZeNw/oTG4Q8qUKN9e93+IlL8vpjdi+zlf/UFenuED1RlN1m+nH4533QX/Q1gMLbs9JrAywhIJCcvcVJuUTtzFSu/tEWjoe5lMcxhO1KmS18mQZa12w4HZ1PNTPzNXsI1pC8brp6x1Yxfdvqp1Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=rCBC0eAa; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="rCBC0eAa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=whPJKcowSQx9e4tOJpTFnAzgcJ2qA9U6xjGOuWeQkGI=; b=rCBC0eAaV2przA79vU/87Q+v9E
	grcpcRlwqTrFml0kW4TGyoQm7cdfe2Pd6sNFe4kGhHIB1X5x4GrCalnEU+OaUwaR/uOCm6gYzPStK
	m1IA0bdpeye3DZKKmK2THbg1p9POGSnX0HuHTzEy8PRtnqeGISPo8IhkisiX9PCfMzHHx3hcC96zS
	FogzZ/WZh0C+Lx8BGgOPerqr/Wg+R3S0FeBObEadAe5r9QYQ5HbVgJC+HTzKJ03m4o8+HjhaBAelG
	d1zyw5dBO7uNpDSDeRFHHKta0nIS9xo3ilfUdtTCTIqgwKLKoHHgPVOmLAQL0CjHrovCIdZfVTtMR
	J0pjFq4Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xEbAM-000000038JN-3oeZ;
	Wed, 07 Oct 2026 20:35:18 -0300
Message-ID: <ceb83f1d34307ebcbe203abe2cab40a1@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH v3 2/2] smb: client: prevent premature discard of
 requests if reconnecting
In-Reply-To: <asZ12ZKIHpc5yPsn@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <20260929170358.270612-2-ematsumiya@suse.de>
 <b0f37e56c4559eb51624f76f92c23ee8@manguebit.org>
 <asVQ8CHNUY3bxbaz@suse.de>
 <00e0fcdfdde0a281ed3f080040d6fb63@manguebit.org>
 <asZ12ZKIHpc5yPsn@suse.de>
Date: Wed, 07 Oct 2026 20:35:18 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> On 10/06, Paulo Alcantara wrote:
>>Note that there's currently no backoff mechanism in either CIFS or
>>netfslib for writeback, meaning that the write requests will be retried
>>forever if the server goes offline.  You'll end up with tasks hanging
>>forever on close or fsync.  Trying to fix that in the reconnect path
>>doesn't seem the right way to do it, IMO.
>
> Btw, I forgot perhaps the most important bit here -- whenever there's
> a reconnect during a write, the file gets corrupted.
>
> That's regardless of how long the downtime was.  As soon as the first
> task times out in cifs_wait_for_server_reconnect(), returning
> -EHOSTDOWN, that request is lost, and data is corrupted.

Yes, because we explicitly return a non-retryable error if the server
neve came back online.

Then we're back to whether using 'hard' mount option or 'retrans=' to
handle such cases.

> Note that the writes (operations) _are_ resumed, but what was lost,
> stays lost.
>
> Again, I agree that retrying indefinitely might be wrong, but so is
> corrupting data due to a short network outage.

I agree.  Check the available mount options (hard and retrans=) to see
if they help with your case.

> I did try to relieve this situation with this patch, and TBH, after
> reassessing it, I fail to see how/where this could be handled in netfs
> or cifs I/O path.

Reconnects and retries are definitely not easy to handle.  This,
however, makes network filesystems quite interesting to work with,
though :-)

> The closest I got to a PoC was by loosening the restrictions to set
> NETFS_SREQ_NEED_RETRY on smb2_writev_callback() and smb2_async_writev(),
> and then we're obviously back to the retry-forever-but-no-corruption
> dilemma.

Yes.  Let me know what you think and let's keep talking on how to solve
these issues.

Thanks for looking into them!

Received: from hua.moonlit-rail.com (hua.moonlit-rail.com [45.79.167.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DCB748D
	for <linux-cifs@vger.kernel.org>; Sun, 15 Sep 2024 01:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.167.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726362601; cv=none; b=Z/4E30DmvXsEk55xYtQy3lAkAx+UXNskR4qGUQu9Rlf/SNGDd2WU3Z3WGqa9JrkF+vwfHwwLZdJDxsLF5okHD892ErGVj/YvuroiYZEFi0MsadNd9lJ1L+W6sfwUTBHxPmUiyRs+bTjQ7asVBShg1onKrNBbCN0jtjjZOsdJofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726362601; c=relaxed/simple;
	bh=z5IAYXQZCLsmWE/Ico/kj9kpg8SDgkKcGrwlDsEhHGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hdgcdZEmtcnWBQ70l5Xvv5+rx6tPurUiV8sgs0t1zQI0sxvtW6d6AU1esUlEYNqV6/wVkxXga8nD48V39FoBIToEHFHmhr67xl2Ql/97k+MZpUQRUdfcBFl8U+aAXhVOpGTE90NsMlqM+ATPkHpXr6nd8hfTs4g7SNBQ7A6ycl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com; spf=pass smtp.mailfrom=moonlit-rail.com; dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=Cp6w8jdF; dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=cTMxmv0R; arc=none smtp.client-ip=45.79.167.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="Cp6w8jdF";
	dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="cTMxmv0R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=rsa2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=S8HYWvcaQ/e2F2NQwDRcE1cv+9UZufGbAzPBbuYR9/Q=; t=1726361468; x=1728953468; 
	b=Cp6w8jdFs2bpCASwVfp+BvaMNH2RetdcWZCqVlOMDATUlOm/CrINz/8hHzWZPyZN5ZIPl486wEp
	Af4jbZPbSnLbKHlU0hlp8FufCp1QE9e9ky9PPQNvuqlPvWjt8CnJz7Yv9B29168mlxntTX6MJCdqa
	WL3+5IEH5meF3QkvRGFZBjZhIL8xfkHvchdj4fTT7vIZn09zOiU2Bfw57QYDm3tM+I8KfW5iQK6jU
	BCrxhr3QmP2YpyVkP5t5ztMVQbHD4KxVh79ErbaBDv3G41BP3PEJxMtLT6e1ERNr1XHWkGRhT5sMc
	DcYlndnYMEfRXsfsmc3n0pnSSvV0YZH9RdbA==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=edd2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=S8HYWvcaQ/e2F2NQwDRcE1cv+9UZufGbAzPBbuYR9/Q=; t=1726361468; x=1728953468; 
	b=cTMxmv0ReQv0fksSru4SHoH/FX0Kz0hQFSD62AKXDaHpCFhnLnfryZ9yMRaQWHDWrX3qWabgG2m
	xlV07WZjeDQ==;
Message-ID: <70b36bc9-8b50-4765-b9fa-aa40db873d13@moonlit-rail.com>
Date: Sat, 14 Sep 2024 20:51:07 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CIFS lockup regression on SMB1 in 6.10
To: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
 Bruno Haible <bruno@clisp.org>, Linux Cifs <linux-cifs@vger.kernel.org>
References: <CAH2r5mtDbD2uNdodE5WsOmzSoswn67eHAqGVjZJPHbX1ipkhSw@mail.gmail.com>
 <cca852e55291d5bb86ea646589b197d5@matoro.tk>
 <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
 <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
 <4c563891-973c-46a4-8964-0ef90b1c7e49@moonlit-rail.com>
 <CAH2r5mugVqy=jd_9x1xKYym6id1F2O-QuSX8C0HKbZPHybgCDQ@mail.gmail.com>
 <90134f35-acb3-4124-b172-2de6d70dd0b4@moonlit-rail.com>
 <2925a37f946d1b96a7251f7be72ba341@matoro.tk>
 <2322699.1725442054@warthog.procyon.org.uk>
 <c8027078-bd61-449e-8199-908af20b1f10@moonlit-rail.com>
 <97a71be9-d274-4e9e-9928-dce062ba2a22@moonlit-rail.com>
 <693dc625d6be7f0154bcb5e4ee6a3561@matoro.tk>
From: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Content-Language: en-US, en-GB
In-Reply-To: <693dc625d6be7f0154bcb5e4ee6a3561@matoro.tk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Matoro wrote:
> Kris Karas wrote:
>> Just need a backport for 6.10.x to fix the missing NETFS_SREQ_HIT_EOF 
>> and rdata->actual_len.
> 
> Hey, I haven't tested this myself but if it fixes the issue for others, 
> is there any way this can go into tip so that it lands in 6.11?

The fix has already landed in 6.10.10.  Big thanks to Greg KH, David 
Howells, and Steve French for pushing this through the queue.

Given 6.10.10, I assume the fix is upstream already, or should land with 
6.11-rc8.  And if for some reason not, the patch that David Howells 
emailed earlier (Message-ID: 
<2322699.1725442054@warthog.procyon.org.uk>) applies cleanly against 
6.11-rc should you wish to remediate manually.

Well, let's hope this email makes it to matoro.tk via IPv4, as it was 
bouncing emails awhile earlier unless I was using a backup IPv6 MTA.  :-)

Kris

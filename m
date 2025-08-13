Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698D2283FE4;
	Wed, 13 Aug 2025 08:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755072256; cv=none; b=GSxsTe8iGPu1ZJupnyZ+IRfFDo77TQgviMWcinD4hsHcsVgr+hNcr2LEoPRijjahLN1Zjh1vh03Fk65v5lUFiuc7lTWU19o8ZN7LTl7T2gME2uR2q/gqfKU5nMXD9Igz0NPM6dI6dT2PS/yOKxgRpQAFitb5wshHX7sYmgMzU14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755072256; c=relaxed/simple;
	bh=7Ion3UP8B9fA+uBaM3uvmJWfijF3w170N7Wn1SCIwqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y2RKA09+M/9HjfjNHsCGYY3y9XbYJRXICxxHqdDGkq0sFpz9h+4Qn6VQWzcQAesSLimIntr5Zq671jFGPBbrcHEnHS5UzR/30TG316UIoROhWjtVWUa3Habq5NCkhGvDuSY6PDFIU21KfirK5DhPnva8dXMihNzyWLqwPc8VkJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=W6ayLcY4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="W6ayLcY4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=eTj2xK0JjrVYUVjqCZt/ynIcthZVkTyVVS5/VGlr/VQ=; b=W6ayLcY4xJXQooKGBjSj1mNdPO
	9cdj28OarATld6hBYhHfv3mj1tMNAuGYYu2Qn1/skxHBeyONbN/8+OToaBp9nmk/QfLTQKvUoGPlQ
	mRC06+DCZwZDH5d7Z5wJnQS9IWSXaSZ4k8ZUtBdujsH1AClNkBMVnsJkLXpqc3Iskjluhq2LFrFgY
	jLnfXmZhWSoo6FF6oNc+DmszsExr5yY708X760YOg8AdYco7VsUo3JpV69ujOF05f5hJsta6s+OOr
	yoW10LESPEcKMZ6lFl5HSR0QTQI6wC4VVBOiOiXp6Q9TEqBRLjhtBsKz+uwFJMDLnTwC/pMZyNUti
	USX1uS2u0SWZc7SksipvL3ABl89vwq5Dh9LPuBUXz0cfvYsUgEkYW+d3cS3gJmieIba+BcGokOZcH
	ZyXMxkYkUgcdzRxRJp/R29CmqWWm7cjAJ+hOyux3JnnLE64LouldU9dminZobE7Oz4+y4CcdKP49L
	12K6IjS9sWoQJRcwuH+ierK2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1um6Sy-002aI4-02;
	Wed, 13 Aug 2025 08:04:12 +0000
Message-ID: <6acc8228-da51-4528-87c4-4cb2c96d3e8a@samba.org>
Date: Wed, 13 Aug 2025 10:04:11 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 563/627] smb: client: let send_done() cleanup before
 calling smbd_disconnect_rdma_connection()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Steve French <stfrench@microsoft.com>,
 Sasha Levin <sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173453.306156678@linuxfoundation.org>
 <527dc1db-762e-4aa0-82a2-f147a76f8133@samba.org>
 <2025081325-movable-popcorn-4eb8@gregkh>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <2025081325-movable-popcorn-4eb8@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 13.08.25 um 09:59 schrieb Greg Kroah-Hartman:
> On Wed, Aug 13, 2025 at 08:17:53AM +0200, Stefan Metzmacher wrote:
>> Hi Greg,
>>
>> Am 12.08.25 um 19:34 schrieb Greg Kroah-Hartman:
>>> 6.16-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Stefan Metzmacher <metze@samba.org>
>>>
>>> [ Upstream commit 5349ae5e05fa37409fd48a1eb483b199c32c889b ]
>>
>> This needs this patch
>> https://lore.kernel.org/linux-cifs/20250812164506.29170-1-metze@samba.org/T/#u
>> as follow up fix that is not yet upstream.
>>
>> The same applies to all other branches (6.15, 6.12, 6.6, ...)
> 
> Thanks, now queued up.

Even if it's not upstream yet?
I thought the policy is that upstream is required first...

It's only here
https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
as
https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=8b2b8a6a5827848250c0caf075b23256bab4ac88

But that commit hash can change on rebase.

metze


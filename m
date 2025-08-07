Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2A94A06;
	Thu,  7 Aug 2025 06:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754549669; cv=none; b=E5XAd3su1QB0zsO63mQAE7zdDwLLna3DjSow3grgeBuR9/Gcj66h5vaP8Byns1rPhgqPI4Bgo9oHYdlT4emsPhDD91xWew5gT0z5wTnumRoEKZuwAbYQYkfT/IbZEEMay54pyH5sAZcJEj0t7jrpDbWhsCJ8667jF+kte61mQi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754549669; c=relaxed/simple;
	bh=UZ3kKz+L6SWuJovjfZtF+5IceB2C1ZXCCNzn8WYBsCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CvPikMW/roPPboRiIVdoZqYmLFV4sjRVUAYUFjTaQO8b0QEEnhnjSoEA/5NcUJDLkRfSPMjb58YuYPPxkFJuCDRX5afdvfjqAteV6NaZx2wdAxKWYS/VC6DdVminMm7YrE7V/vAOePhvRzvS7A80DLNIvrXGZiOu4WBAz1d/9gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gOrDFONM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gOrDFONM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=iDHkx2i7fBVZgz1YuVRDZzIJYfP4Gyp3ojsDJpTljHk=; b=gOrDFONMqUif6vPO7Y4heUdtIY
	lLumL+5dV672BzupH9aytka2SXD2kpU75jZ1Bm1WVCt6od2e0TPbZ0ZfBbj3BSK4KTeGjPpDzHn3h
	O7gdRO5XBzWK2v7ijt2tHwNUN0ut4UoJQKnBEgWZcnCXgkQko4WwUASCqyzC4EKF5m/znv5dXUoND
	bekjg0u5Ndl/JUD/J22NoQJPz8Zjah4QfAiylmlxRp8Iu+d3dfisTyklVvD2m9pzMkRC+jrrQIX6q
	4Y8+fiGkXVZQpD+bfjjmcWNo0EYO7EmVNUaJBcazkJbtSlbZuyhH1diJuc8SkO5z0ips9m+sQfJSi
	/l6Ik7rftaPsxQlLi1xEW5oj/pZNBQhWDRjt8M8xHOHVuAub9q917xS8jfOdMIoettm2Knp5GLTCq
	zfOEnhIyuczZvIQCPYimSLpiGbgglY+vKEErFrUE1iTQwp9G/+gSkZgIHHsNqpL5XsbEhY8fGb9Wb
	KWDOqNrpq9Q7dI+aZNwCa3ji;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujuW7-001VqH-2G;
	Thu, 07 Aug 2025 06:54:23 +0000
Message-ID: <40d1f78c-d437-4ab4-8e5e-8708af6486ab@samba.org>
Date: Thu, 7 Aug 2025 08:54:20 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES
 and use netmem allocator
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Wang Zhaolong <wangzhaolong@huaweicloud.com>,
 Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <c213ace1-7845-4454-a746-8a5926ab41d0@samba.org>
 <20250806203705.2560493-1-dhowells@redhat.com>
 <2572846.1754547848@warthog.procyon.org.uk>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <2572846.1754547848@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 07.08.25 um 08:24 schrieb David Howells:
> Stefan Metzmacher <metze@samba.org> wrote:
> 
>> So the current situation is that we memcpy (at least) in sendmsg()
>> and with your patches we do a memcpy higher in the stack, but then
>> use MSG_SPLICE_PAGES in order to do it twice. Is that correct?
> 
> Not twice, no.  MSG_SPLICE_PAGES allows sendmsg() to splice the supplied pages
> into the sk_buffs directly, thereby avoiding a copy in the TCP layer and
> cutting out the feeder loop in cifs.

Yes, and we must be careful to not touch the pages after
calling sendmsg(MSG_SPLICE_PAGES).

And unlike MSG_ZEROCOPY tcp_sendmsg_locked() has no
no struct ubuf_info *uarg when MSG_SPLICE_PAGES is used
and there's no way to know when the pages are no longer
used by the tcp stack.

Can you explain how/where we allocate the memory and where
we unreference it in the caller of sendmsg(MSG_SPLICE_PAGES).

> However, this is meant to be an intermediate step.  I actually want to
> assemble the fragment list in a bvecq in the smb_create_request() as called by
> the PDU encoders, with everything aligned for crypto so that the crypto layer
> doesn't copy it also.  But cleaning up the transport first should hopefully
> reduce the size of the later patches.

Sounds good :-)

metze


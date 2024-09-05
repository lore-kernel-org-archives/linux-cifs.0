Received: from coa.moonlit-rail.com (coa.moonlit-rail.com [38.145.205.58])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B13D19D897
	for <linux-cifs@vger.kernel.org>; Thu,  5 Sep 2024 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=38.145.205.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725552112; cv=none; b=JRNOejL6giCu6BsX27it6scOtglw9Y5vbKTjnT6NVG1o4vBJONWUt4aYuR0cTtmE1iycuCdLQvYrUbanOKZATnJH/dlwOfvUyVdF6sGxY31ZmHz9vcYmoYyrRm1BNq592JXHf5Jj8ErlUWIBM+Dl76gcgQJF2DC/khuCL4ZcIGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725552112; c=relaxed/simple;
	bh=k11DKX5vXDljG1oGhHo/sJWs6SJU//qp6k3szzGWZqo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=pZABEZvhpaicVXC/76whu4NYjS2CIofP18XTI8AyA58L2WV2/kK1AQYGevaCYDNqszkaUruPFfxQZSCRs8yo6uLtqCxJbrmLuNOmgf3/pJUy15/2z52u9llYiqv0Gsoq05BJ/ydaadYORl7dWN/TXBVC0c5lkt6HdPXhsSrpp6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com; spf=pass smtp.mailfrom=moonlit-rail.com; dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=Khrdkv7e; dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=tkqxdrDF; arc=none smtp.client-ip=38.145.205.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="Khrdkv7e";
	dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="tkqxdrDF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=rsa2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=AaUHqicgJGG0YRvFPVOk2647TTXo1/9A9ljS8mxYhXc=; t=1725550843; x=1728142843; 
	b=Khrdkv7eJETMFNcB8dkJ66h201hAyqOKW0fL0LLBIWnwqhDmzrw361vP9Mz28MHKD0vOMSh9tHZ
	Jx7m6IjveBlmFMnODgXQQufS6t9Wm7rTRs4PKLOeySuzCtYRIrQnagZWW3yi/mjzoDAzBxd0qkrTv
	wkxcToIc2AX0DRPuMCaWrK0tj691E3JdmOT873Tnz0qx3bm+Xl6QfA9ghugn2j85V/rPj0y2td4j+
	dSeIkA4lJHXbqfsTPRETWMNaRxlcxDl/t9Z7UgouJt93teNFJ8Qto5uY4Z8gv1OtPxRqBogBQjr8I
	6ImFCdNO1h8akItCzDoJIqhukJvuIXHm9JMw==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=edd2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=AaUHqicgJGG0YRvFPVOk2647TTXo1/9A9ljS8mxYhXc=; t=1725550843; x=1728142843; 
	b=tkqxdrDFYyi26UzB6UalqKAiBL1xgNZZ51DM53Tf6xxFK1onxqSsnq19NFCbqwbbYNefOF3NCJm
	8pepuWSHfCA==;
Message-ID: <97a71be9-d274-4e9e-9928-dce062ba2a22@moonlit-rail.com>
Date: Thu, 5 Sep 2024 11:40:42 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CIFS lockup regression on SMB1 in 6.10
From: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
To: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>
Cc: matoro <matoro_mailinglist_kernel@matoro.tk>,
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
Content-Language: en-US, en-GB
In-Reply-To: <c8027078-bd61-449e-8199-908af20b1f10@moonlit-rail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Kris Karas wrote:
> David Howells wrote:
>> The attached may help.
> 
> Thanks.  Gave it a whirl.  Alas, FTBFS against 6.10.8:

OK, I tried this against git master, compiles fine there.
Success!  The lockup with vers=1.0/unix is gone for me.

Just need a backport for 6.10.x to fix the missing NETFS_SREQ_HIT_EOF 
and rdata->actual_len.

Thanks!
Kris


Received: from hua.moonlit-rail.com (hua.moonlit-rail.com [45.79.167.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453931922E4
	for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 20:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.167.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724446337; cv=none; b=Dn5a+FjXVYhZzKp2V1kYiBaEbDz2KS19Q8eHnZIOd/wgVcrZC5pWOBtkwmayP9TWakDNh0pZQ0YSWpqvxg4C5l/D7OrgS72DA30GVxVWMm8ajzxSQpQRwILHQXwj8JlUNFdPDZ5oqVHYvyFe2RQveWaA+jkyEiX7sniG12NPIXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724446337; c=relaxed/simple;
	bh=Wf2pbWV8/FYJt9lnMXYXLqt1x8AnOzua1fNujo1ZyGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NjV5+ZkedPnroNhDi2q6qCJ+LP8Hu5J36BV18a6DwOuOwSPcKozGC+2DPMYfwa5sR5Ehi1Tx+weN7mvGjzRU4T2lFk1OnR01unFSAdERJTlqrBBcJTedGmE2P/7Y7tCLTcNe081jI/sFH/KAHYFqXzpiJbtBPO63bKS1siu01Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com; spf=pass smtp.mailfrom=moonlit-rail.com; dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=EgZMUree; dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=UXcORdFJ; arc=none smtp.client-ip=45.79.167.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="EgZMUree";
	dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="UXcORdFJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=rsa2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EDVTAYLe3EvjFMupTR3LazR8LBvcxEZHCifv37jvTuI=; t=1724446328; x=1727038328; 
	b=EgZMUreepTc7i0w2QLWC2giny2YlLaxN1nf2wxQbH13BsCrgRcqepKMBABmTlrFcWfCwXtmfXUY
	/xnn1RTnszvpdBow3z5qzFqHZGmf3NLA6h5S7JbOnYPTKUNZFzm+SR1zX5fkveXJuPTxTlNxX5Pq+
	CYz83nzC7fcRzRBqT4WVWeBHvMlYs6isftqI0jkT0k7Mdc/zkLf2+eBG0Ogu5RdtRuVa9lKe4L78K
	2rcujwShOUXdXA9k99wfp9QCJpyUuvz0SX++AISvLep2/80t/FeWbxVwN5Pr+y4duGIP73CImlukz
	ni/YuBI4xfAQWJ6OAy+k5Vx6USiOVTW8mhjQ==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=edd2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EDVTAYLe3EvjFMupTR3LazR8LBvcxEZHCifv37jvTuI=; t=1724446328; x=1727038328; 
	b=UXcORdFJxOF845ZKoWnx4KRfnpRckMRFipeZcOxp5oFURt6jmxJqsyo2C9aZXQz9E0o1Ya/Lo97
	qyefndILqDA==;
Message-ID: <90134f35-acb3-4124-b172-2de6d70dd0b4@moonlit-rail.com>
Date: Fri, 23 Aug 2024 16:51:59 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CIFS lockup regression on SMB1 in 6.10
To: Steve French <smfrench@gmail.com>, Linux Cifs <linux-cifs@vger.kernel.org>
Cc: matoro <matoro_mailinglist_kernel@matoro.tk>,
 Bruno Haible <bruno@clisp.org>
References: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
 <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
 <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
 <4c563891-973c-46a4-8964-0ef90b1c7e49@moonlit-rail.com>
 <CAH2r5mugVqy=jd_9x1xKYym6id1F2O-QuSX8C0HKbZPHybgCDQ@mail.gmail.com>
From: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Content-Language: en-US, en-GB
In-Reply-To: <CAH2r5mugVqy=jd_9x1xKYym6id1F2O-QuSX8C0HKbZPHybgCDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Steve French wrote:
> On Aug 20 Kris Karas wrote:
>> Don't remember just when this started, maybe around
>> 6.10.3 or 6.10.4?  Can bisect if need be.

I neglected to ask if any of the devs on Linux-CIFS know the culprit and 
thus what to fix, or whether somebody would like me to bisect?  Happy to 
do so.  Let me know.

> Smb311 Linux extensions work to ksmbd but for those extensions to samba 
> there is a server bug with qfsinfo but patch is available for that

Super!  I'm glad to hear it.  I've been stubbornly stuck using vers=1.0 
because I know of no other alternative.  I have heard of unofficial 
patches to Samba going back at least a couple years, and have been 
patiently awaiting official blessing; I'm sadly ignorant of the reasons 
for rebuff.

Kris

Received: from hua.moonlit-rail.com (hua.moonlit-rail.com [45.79.167.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442511547D1
	for <linux-cifs@vger.kernel.org>; Tue, 20 Aug 2024 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.167.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724183773; cv=none; b=qi1ACuqge1S39Dla4+Qet+WFDoennPTuFF8bIxCNxAd/s0dedLsAKAcUju7gpbPaCss5AkHDgO9mUk9eYvLOkLtNpZox7kr88RvvpI/iVlzLcmeONZkAS5N5690x1Axnp5Po9La9D6p7ipZlDfk0QeKORWcBMc/x+JbBCMwNTDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724183773; c=relaxed/simple;
	bh=bgxP1K3EHDN+0qetcPDJ8+MzG2NCZziiXQwzHM7KGxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MiO8m5dFtfCBUFyatpAGTiFhOjYFwNpvo749JFgGLKofr64XcXabel7R/GiQPULldGTrcjuOtMVgXQQ4AB8jRV39WdSvXf9XspyI4sGrwa6XQGJRBx4IVwMXLhshMyo6mfBrv/qkN0WQSdXwPgPfrE1zxKjnHq5b1knVBPsLMmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com; spf=pass smtp.mailfrom=moonlit-rail.com; dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=MPQYBEMO; dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=ZLYrX+pz; arc=none smtp.client-ip=45.79.167.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="MPQYBEMO";
	dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="ZLYrX+pz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=rsa2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fYz/49UhLPCJC42P3oJF0I1uubIHC+nwlrTBNzmM1Ao=; t=1724182399; x=1726774399; 
	b=MPQYBEMOknTSO/q/y/OtozbUYLZUcRSzjpLWsLeWxfvDyLaf6/v075LI72m+6oQbmNllGDm/CQf
	ahgqSBSUutTSBrho2udCqQndNUcqj+cJEMyKS3oEG5SrUpdst90b/6b92saivZvs3D5wTagcglHDR
	6CLrAJgj3WbfpSq0/Issi8HL+UnRXBrJjG6013cL9XzIb3c5xw2fNRfMWWS54ITNs/ERdLatrRxAK
	51b4Z59VgbNza3P5SPp9cSOTAC8n1+bqEpco3MNMANxBIPC7ffQNmjIjrW2UsY3ws1BAy1vTIj7GR
	JPJMumNTnWDv+mQSnnwBtvqQVIP+7fyMyp/w==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=edd2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fYz/49UhLPCJC42P3oJF0I1uubIHC+nwlrTBNzmM1Ao=; t=1724182399; x=1726774399; 
	b=ZLYrX+pzal/vt9Ahq4PjDcysu5cUcEBKAo2ZRXr9sU/wUN7uUL+EINIum6ThJud/DF1Z31y02Wb
	yodVR0oxtDA==;
Message-ID: <4c563891-973c-46a4-8964-0ef90b1c7e49@moonlit-rail.com>
Date: Tue, 20 Aug 2024 15:33:18 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CIFS lockup regression on SMB1 in 6.10
To: Steve French <smfrench@gmail.com>,
 matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: Linux Cifs <linux-cifs@vger.kernel.org>, Bruno Haible <bruno@clisp.org>
References: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
 <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
 <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
Content-Language: en-US, en-GB
From: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
In-Reply-To: <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Steve French wrote:
> What is the simplest repro you have seen - e.g. is there a git tree
> with very small source that fails with configure that you could share?

Simplest and easiest way to reproduce is:
   1. Put a bunch of photographs on the server
   2. rm -rf $HOME/.cache/thumbnails
   3. mount -t cifs -o vers=1.0 //Server/Photos /mnt
   4. { geeqie | gwenview | digikam | ...}  /mnt

Just the process of generating dozens of thumbnail files in parallel 
will cause a lockup (for me) in short order.

I'm new to this thread, just found it because I was curious if anybody 
else has reported this, or whether I needed to start a new thread.  Glad 
it's already being worked on.  Don't remember just when this started, 
maybe around 6.10.3 or 6.10.4?  Can bisect if need be.

Kris

PS I'm not on linux-cifs, so CC me if you want me to see it.

PPS Looking for UNIX Extensions in SMB/CIFS vers=2.0+ that are
     supported by Samba, but I'm starting to lose hope.


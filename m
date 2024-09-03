Received: from matoro.tk (matoro.tk [104.188.251.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4DE2A1CA
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 05:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.188.251.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725340395; cv=none; b=CEtiIRTMB1OCjpD4dtSF1/l7ozz+TPv8im3vcv9K2Z0o8UIai6S1GxqSh3CKWx6wME61pXoWXdDdNTqCoaduD/3gqjsnMJC32uPku6cODzzRzjfFZnQRJbLvPhHTsk0ZZypv+EPhHTOH1e70M8EAqineHWOqMxopPFc/oed6IZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725340395; c=relaxed/simple;
	bh=+PP4X9OFqcLxZdJhcXzursZUKXhp0CJVJwOK6jA+kMg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=gryyPhm5rcZcz6rku9oS0HWt5TSGPgNmV5kAA7vcbOlLsBXURLWfQC+Uu+xEvsTZDjJ2hbGgArIfuL2qhVdsu95en/ejg58xWsrIHs405kOxGtAw9RVtsWSkH+MSAYhARPQInTGL/70Z/nWbmZK5+eI4XD9qfgQN01TXEFv+WQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk; spf=pass smtp.mailfrom=matoro.tk; dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b=rhIbN+XN; arc=none smtp.client-ip=104.188.251.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=matoro.tk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b="rhIbN+XN"
DKIM-Signature: a=rsa-sha256; bh=8IueFS9i2S9AEiyLUh+kU6WuOJmFu2OQd1+tDHXFCho=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20240828; t=1725339328; v=1; x=1725771328;
 b=rhIbN+XND2h1IpPAoK/ySV5gQl1N2H1r+njpO7GbSKL/0t12vLwdUhBI8JcKCjZKOoP3A7A8
 wpTJ+1KyciLgoeCOaGy9jwTnYZx9Jf229+c3nEyLmwjLLWcR5OQ5NyHgpleZ677E/xaAuiYUrl3
 x9dMtll6OQhsqcrQZMTfM1Ql5mNQ/oh3bb84Z3Q4Het7HjyjqCqRWU3y4Z1DAhTKFeLIqEbRpM2
 z+CU9ZRYUV+3KDeMAcN3ZUDUF2sWccUlgVbJif+YO3c/rT5Si6IChLYpehR4tBGvA1P46EbAeWM
 vf4KQggGgLp3HQSZmQqudXEipWlsabb6oUrM6fWWLF//MBp59PdgoStbLHpM60/viGCqzsV5iED
 6wlOPq7POrkKXaWifG79UtkADdEy/GEi7YnUrUX5fapF2SWL3iZ7vj8wZKbL7E4ZBEc6JxIumC8
 TroyeBGD/0JIxojuT413lCu7caenTYi4CLyj+q0Gp/2F1sGe7p9F41hJCKd+DNH9RQmlF8zoFdu
 0yvSAWIODXf2KJ4hSIYr1JqYCKwUnTJPwLtQE/Rh8RXelpRYDieSg8g5B0c2b5qvhNL7HNHArrd
 uzIMLJSt8gSUI1iMPt+IdoOdGZZDQ/3esH5G2Q7TtzW6sE5FZn5lnTYMHzroPN5MgC8LMpHpoyp
 nEvD6JSwqnc=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 0c20a2e1; Tue, 03 Sep
 2024 00:55:28 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 03 Sep 2024 00:55:28 -0400
From: matoro <matoro_mailinglist_kernel@matoro.tk>
To: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Cc: Steve French <smfrench@gmail.com>, Linux Cifs
 <linux-cifs@vger.kernel.org>, Bruno Haible <bruno@clisp.org>
Subject: Re: CIFS lockup regression on SMB1 in 6.10
In-Reply-To: <90134f35-acb3-4124-b172-2de6d70dd0b4@moonlit-rail.com>
References: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
 <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
 <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
 <4c563891-973c-46a4-8964-0ef90b1c7e49@moonlit-rail.com>
 <CAH2r5mugVqy=jd_9x1xKYym6id1F2O-QuSX8C0HKbZPHybgCDQ@mail.gmail.com>
 <90134f35-acb3-4124-b172-2de6d70dd0b4@moonlit-rail.com>
Message-ID: <2925a37f946d1b96a7251f7be72ba341@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2024-08-23 16:51, Kris Karas (Bug Reporting) wrote:
> Steve French wrote:
>> On Aug 20 Kris Karas wrote:
>>> Don't remember just when this started, maybe around
>>> 6.10.3 or 6.10.4?  Can bisect if need be.
> 
> I neglected to ask if any of the devs on Linux-CIFS know the culprit and 
> thus what to fix, or whether somebody would like me to bisect?  Happy to do 
> so.  Let me know.
> 
>> Smb311 Linux extensions work to ksmbd but for those extensions to samba 
>> there is a server bug with qfsinfo but patch is available for that
> 
> Super!  I'm glad to hear it.  I've been stubbornly stuck using vers=1.0 
> because I know of no other alternative.  I have heard of unofficial patches 
> to Samba going back at least a couple years, and have been patiently 
> awaiting official blessing; I'm sadly ignorant of the reasons for rebuff.
> 
> Kris

Kris, a bisesct attempt would be immensely helpful.  My attempt failed as 
there were other unrelated problems in the commit range which caused my test 
reproducer (compiling python) to fail, but your reproducer seems much more 
reliable (reading images).  Could you please take a crack at it and see what 
turns up?  I think that's probably the only way to get upstream to take up 
our case.

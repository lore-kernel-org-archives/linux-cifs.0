Received: from cat-porwal-prod-mail11.catalyst.net.nz (cat-porwal-prod-mail11.catalyst.net.nz [202.49.243.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A156679C0
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 00:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.49.243.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750379458; cv=none; b=nXfiSNb3B/4WY9WsRVwqFS9wlMW2Vb3W+u8dEhTKj7AOpMIM2Gzwj6RnQeL0xe77L3mLEXRXSBwcYp0YGGu19MVQX4QOz1wZs0vquqqTHu9CoB+QQ9YcFsti/+g9EcFDwBzTgKqHw2XJ45QnMrmymd91dIL1a/eeVtUJfhFrjjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750379458; c=relaxed/simple;
	bh=DEIvpIAjVRdSagdlQAEplwqmxyNM6y8DVDqIIZbYk6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gaD7BeSuMiua4LGyJtllUntpTDuLubfPeFDCjtWhbodqNr450xyc+PXznhDzasfmzLbuECPHVRzllvUadVhzEHkfwUNlbGJZJXQgxb04M3jn71TBibfbOzcf5M/1zSItZeie1KhnYqo6sstX2O4xhN7+W8nE415X7wPDQ4H2RB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=catalyst.net.nz; spf=pass smtp.mailfrom=catalyst.net.nz; dkim=pass (2048-bit key) header.d=catalyst.net.nz header.i=@catalyst.net.nz header.b=sapr8kGM; arc=none smtp.client-ip=202.49.243.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=catalyst.net.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=catalyst.net.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=catalyst.net.nz header.i=@catalyst.net.nz header.b="sapr8kGM"
Received: from [192.168.1.219] (unknown [114.23.142.188])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: douglasb@catalyst.net.nz)
	by cat-porwal-prod-mail11.catalyst.net.nz (Postfix) with ESMTPSA id 03D78BA;
	Fri, 20 Jun 2025 12:21:27 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=catalyst.net.nz;
	s=default; t=1750378888;
	bh=DEIvpIAjVRdSagdlQAEplwqmxyNM6y8DVDqIIZbYk6k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sapr8kGMEL7Sb1m6QzeeroSAmKVVewsfiCTzS+/kFxoFtCc+fCVcsiG1IEWqHd9JH
	 w69s9dKr9rV/mjIFLeBp2KM9xBOmZprG3XqGQGRJfYnczsuuk6Ga29AZFld4pe/2o6
	 wRhcqrtJDojsai0beRjoiX5TBRQ7nNOhLCWPBZ5G5TUmNhMOJcP/wwbhASIbL6RmZT
	 GWROv/ZIg82auvEfUTu+cR+KR56Ni+1PgvPV4nomrnIyzB85RZU7cDsdXwjgyCqWCX
	 3Bx/VvUW1nZAzDlX8RSCUbfUp7rVj1uzsdZL4m2Npc4cOnpRa7ZtTu6wocHE8H+Ih2
	 nuQwZCLMFMrFQ==
Message-ID: <2532598d-9525-4ca9-b37f-fb3582ea60ac@catalyst.net.nz>
Date: Fri, 20 Jun 2025 12:21:25 +1200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Seeing lots of coredumps from samba when using upstream cifs
To: David Howells <dhowells@redhat.com>, Jeremy Allison <jra@samba.org>,
 Steve French <sfrench@samba.org>, samba-technical@lists.samba.org
Cc: linux-cifs@vger.kernel.org, paalcant@redhat.com
References: <869961.1750344431@warthog.procyon.org.uk>
 <882336.1750372293@warthog.procyon.org.uk>
From: Douglas Bagnall <douglas.bagnall@catalyst.net.nz>
Content-Language: en-NZ
In-Reply-To: <882336.1750372293@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/06/25 10:31 am, David Howells via samba-technical wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
>> Hi Jeremy, Steve,
>>
>> I've been trying to investigate all the reconnection issues cifs is seeing in
>> the currently upstream kernel from running the generic/013 xfstest against it,
>> and I've realised Samba is coredumping a lot (attached is one example, at
>> lease several others look similar).
>>
>> The version of the Fedora Samba RPM I'm using is: samba-4.21.4-1.fc41.x86_64
> 
> The problem seems to be fixed in samba-4.22.2-1.fc42.x86_64.
> 

It looks a bit like

https://bugzilla.samba.org/show_bug.cgi?id=15803

which was fixed in 4.22 by patches for

https://bugzilla.samba.org/show_bug.cgi?id=15608

Douglas

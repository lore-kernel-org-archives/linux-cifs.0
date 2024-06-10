Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA4C17545
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 20:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718052619; cv=none; b=JRmTiA+ZRXw6C+J6Hg5M1yAAuP/AmGoYKusKNYDUFN5SZzkdGtRwwilAAne9wCfyO8iHzH8eFF9UBREfltvRk5bdN4XxZu0CxyHNcsboWbIFTrKnlNMsXUraT1bJTZwpB/wyyvIDTKr5gEWJuXds2I7p+crH3RXkyyW/kTuS0u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718052619; c=relaxed/simple;
	bh=BPHmUU812z5hvP/Jue70bl5PHwQ06hM5ym/Met4Xnm0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WhLGbGaFCPtmRCKYHDjy/505E+KdjS96hBxR2D1LleExoevOWZKkFqgiWVI6caShPctKw0FDF6mJcxEieyhjcMRzEmFh3TOpHUTFdqFVnfOBNBq/SV2yuoxOj8QbrubUYoNH7Cl3vJxm/vCWPgSTz/IRareq0yjImxaTSGKBm7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qcex7TUn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qcex7TUn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Date:Cc:To:From:Message-ID;
	bh=aGOlZJ3sP/csZ7Df/EmbK5Qh+kvT1fQWBxD7RggzQus=; b=qcex7TUnihhdXOElvDOSmq1sxd
	8L3FNV5eVQ99+J6byU8ved13mgJcXVySdF0FKO2H555hEMxha+/4bjGJaXjbd4/vfl7V0qyu9ArBY
	tNCKdZyhEvydV7l52KVCpU3JTzdutpwjjrf/8RjQJymUaigii9gWCH9W05i8tnVTF7nKfq/4bjB/+
	No/nc9DVMkbRcrqqiOT1MihFIhdgqAkKbuxofi5uXMGFsVmDxybMx+q48jUwMlJkdjTnLivoWLSMG
	tW46eFUJKJB77pYVVGdeaKq06dNKrBD423EA5voMEdw7DVcqoLEeUD88GFdtKQw/r4iDWnf0BoxyM
	6Vylcq0XeV8n+3hcrApvMUGpzdXWnWnNbmHZbhoXDh0QOw81wwJM46VndUyH/GIWjwC+ljWaUmwh+
	WlZsSnhVW7BsUiYQIlL56t9ugedOJ771s5k2JQaut70ec9Our6kd1xzb5K6ropL7Qv9VdYXKlCYo/
	jPOj2noAMsnp/y7CTT9FqMf8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sGly2-00G1UT-1d;
	Mon, 10 Jun 2024 20:50:15 +0000
Message-ID: <cc83f0cbd1409492bdfa17fd2c2f6afb5fa5ee8c.camel@samba.org>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
From: Andrew Bartlett <abartlet@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org
Date: Tue, 11 Jun 2024 08:50:11 +1200
In-Reply-To: <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com>
References: <5659539.ZASKD2KPVS@wintermute>
	 <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
	 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
	 <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

(again, resend without HTML)

On Mon, 2024-06-10 at 15:05 -0500, Steve French wrote:
> Yes - the reproducer helps.  The bug is easy to reproduce.
> 
> I wanted to verify that the succeeding cases are the same that I see:
> - works with "cache=none"
> and
> - works with "nobrl"
> and
> - works with "vers=1.0"
> 
> All other combinations fail ...
> 
> Should be straightforward to fix in cifs.ko.  Will look at a fix for
> this later today.

Awesome, thanks. 

> Note that the problem with SMB3.1.1 POSIX extensions is a Samba bug -
> a serious regression in the server (but trivial fix).  We are waiting
> on someone to merge the oneline fix to the server (which we tested
> out
> ok) from David.

Is there an MR for this?  I couldn't find it.

Andrew Bartlett

-- 

Andrew Bartlett (he/him)       https://samba.org/~abartlet/
Samba Team Member (since 2001) https://samba.org
Samba Team Lead                https://catalyst.net.nz/services/samba
Catalyst.Net Ltd

Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
company

Samba Development and Support: https://catalyst.net.nz/services/samba

Catalyst IT - Expert Open Source Solutions

-- 
Andrew Bartlett (he/him)       https://samba.org/~abartlet/
Samba Team Member (since 2001) https://samba.org
Samba Team Lead                https://catalyst.net.nz/services/samba
Catalyst.Net Ltd

Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
company

Samba Development and Support: https://catalyst.net.nz/services/samba

Catalyst IT - Expert Open Source Solutions


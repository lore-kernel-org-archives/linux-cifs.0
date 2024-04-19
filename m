Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C36C10F9
	for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 01:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713491718; cv=none; b=TZYWU7FD8Mbppzim94hX5lgoZO+bAOi6xZaR9VeaSZH9mY1kmlFMztvcTlzAlj215+yL1+1EgdJPi1h+EbqIusrNOgAQF37xeivgbjcJ44YEasLSKEL0Fo2Lnrf4tYoMLKlXElYf+gwMBCpEe9FVyjgx6682V87n7Iz4eutwNec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713491718; c=relaxed/simple;
	bh=Xq/4nRDuwBlAeDjQro4r6jeYQK+zPK844pWzFum4B74=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=egEBmBFpF800MLVPnBDppy1K5W2RW/e1OZa9Y9HKFjg8TbTFNHFy7K1KB3HOLBdWV0gjs/N7A44uQImHVC9k9SX3iuc+SWTJo7NRmOnRSA7csLZT/Lt85WANO21YGDEY/9OssbnbITNT7E9uVY/w4MnpRDnE5oz1hL991zvrro0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YcBYI7LY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YcBYI7LY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Date:Cc:To:From:Message-ID;
	bh=5p142brCiFzAuZBxjaaY7qI9jriDNtx3PfAQuXC0SN8=; b=YcBYI7LYmehu1bOjyy6FInoIik
	TaYDdRaZN2a4JEaMK+sKcYan553SjUlKdYj/SD8lnuQVM7t9ZuCh8LMiI/92u6mKYsPWlp5RqPE3y
	bv358pQjv0IT3eZFqNlhFr3n6xhyFL+udzEiI/GqPzCOkWDsp3igZoDlpo9qKvO3R+TXsvxvTwnOU
	/vhwTP16knysKnu0wpmGFdF7JODAcHRQA1tdcIBBM9fpdXwtdjuF0dPERb8rNOAsD0Q61Y2fd1Qvu
	JzQ6xqRprXHDuCMeZwgrEEqY3KPNM0qYPy9u3ceiJjgHF4SJbDyE01lsFoZPjm3rbrpghwa70R5Rz
	5i8cp+sMIeFerlKQ4YyX9DE/zMzWW/0DguMz74HvbETdvd1fBFUH4Uq3G+bfNBqV0xSJXHliRBWoQ
	Efk8ab+HpGwv1se33+COwYprLeEQwx4wS9gYwQGQFVhOBPrprzrBP3GcGSBKxwlFINoIAcOK6XBdi
	WPwxGETLFkmasyfaG4WlzouE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rxdF1-0079qe-0p;
	Fri, 19 Apr 2024 01:40:39 +0000
Message-ID: <c7d80c1538db3a414636977314feba13871907ef.camel@samba.org>
Subject: Re: Missing protocol features that could help Linux
From: Andrew Bartlett <abartlet@samba.org>
To: Steve French <smfrench@gmail.com>, samba-technical
	 <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 19 Apr 2024 13:40:34 +1200
In-Reply-To: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
References: 
	<CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-04-18 at 15:21 -0500, Steve French via samba-technical
wrote:
> Was following up on a recent question about support for Linux features
> that are missing that could help us pass more xfstests
> 
> Looking at the standard fstests for Linux (xfstests that are skipped
> or fail for cifs.ko) to find 'features' that would help, perhaps
> extending the current POSIX Extensions or adding a couple of SMB3.1.1
> FSCTLs, I spotted a few obvious ones:
> 
>  1) renameat2 (RENAME_EXCHANGE) and renameat2(WHITEOUT)  2) FITRIM
> support 3) trusted namespace (perhaps xattr/EA extension) 4) attr
> namespace 5) deduplication 6) chattr -i 7) unshare (namespace command)
> 8) delayed allocation 9) dax 10) attr namespace security 11) fstrim
> 12) chattr +s 13) exchange range
> 
> Any thoughts on which of these which would be 'easy' for samba and/or
> ksmbd server to implement (e.g. as new fsctls)?

POSIX <-> POSIX locking over SMB is something I have a client trying to
get working with SMB3.

They have a use case where, as I understand it so far, the mapping of
POSIX fcntl() read and write locks to SMB locks isn't 1-1, because they
expect advisory locks, but SMB locks are mandatory as far as I read
it. 

They use cifs.ko and Samba, so it isn't about working with Windows, it
is about running Libreoffice on LInux against Samba. 

Andrew Bartlett



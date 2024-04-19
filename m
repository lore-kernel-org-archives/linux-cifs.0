Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D614E12FF9E
	for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 15:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713542123; cv=none; b=GNMkIdMjAg/IgfCnvuvhOy/dCTUhL8Fy1sa5y0u7Vc6YPoEu/4/+RJZtmIGnSBixSEWrBKY7/8yhqYRzA9Ln8/Exp6RoanSqaVBNM//SH3O5kGc3IWHMwhQf/UOBbGjvEzy+/wLiojli8207p6HodwJnLISEoGnkrB/ioZIiCV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713542123; c=relaxed/simple;
	bh=KqGQPaqehHcI2IeKAf2Liecz53eBG4Btw11mugwJjeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0aTJe4p8Mjcz4n44G4tfNCQdBFBwURaohmCUoRHVFNzUZe7SRWSc0KjCKEdB5zQBqPG1gmJPGnhtpww9p75eOBik73C0NnQik+9jsiIx65O898xZuRibcA5omOlDtrncthQptbpWlzg5hGEdpp1GLOaXv938T617ZLG3gl30bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pWg7KJEQ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pWg7KJEQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=KqGQPaqehHcI2IeKAf2Liecz53eBG4Btw11mugwJjeg=; b=pWg7KJEQDnbfZTi55LPPgfwu42
	EhAMr+G51dYVQt1HshKAS+NYuwg1xDWh2tT/OPTkBp2XtVn9/xLxcyD1Dzxfc7rF1UwP7D545w5hk
	QdXIVZQALABSGqVP7Vp3Tjmea3yhTvcea0SmPWDUhwY4Aylfn6wvMCOuzA+fT0b3S0slo5vbwrSur
	mlSrYwO9KGwAKue6Yj9W0r9/cV+RCLOvwdNiZBkTS6qrgitFoEkMy05I7D20uJLLEC5Ajyzrj0R4z
	tD3K5a7VTBggbgFqGz6r+IzMMGmV+P2BXXquf3Fy2wOG3vjojl/7aM8z3kwFJ+uoiZA/DOc4bu0dv
	FdqVJPxHBt4Jku76y1dW75SlMoSZ4fcVJR83CbuyLJTvT9EcgA2BkG9UnoLKvqsfeZwnJQnhfMH9s
	hmPOXudxWyCgfOtNi3nsQpoIRVTevBvEen0wT0DAKznUd1OowyHSkuMnjFG8YTiH/uZ+XLlFsn+Ps
	xSQuYlcNd95h/ZIxtIZy7SvI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rxqa3-007HKk-0k;
	Fri, 19 Apr 2024 15:55:16 +0000
Date: Fri, 19 Apr 2024 08:55:12 -0700
From: Jeremy Allison <jra@samba.org>
To: Andrew Bartlett <abartlet@samba.org>
Cc: Steve French <smfrench@gmail.com>,
	samba-technical <samba-technical@lists.samba.org>,
	CIFS <linux-cifs@vger.kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: Missing protocol features that could help Linux
Message-ID: <ZiKT4CursWvT2dhq@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
 <c7d80c1538db3a414636977314feba13871907ef.camel@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c7d80c1538db3a414636977314feba13871907ef.camel@samba.org>

On Fri, Apr 19, 2024 at 01:40:34PM +1200, Andrew Bartlett wrote:
>POSIX <-> POSIX locking over SMB is something I have a client trying to
>get working with SMB3.
>
>They have a use case where, as I understand it so far, the mapping of
>POSIX fcntl() read and write locks to SMB locks isn't 1-1, because they
>expect advisory locks, but SMB locks are mandatory as far as I read
>it.
>
>They use cifs.ko and Samba, so it isn't about working with Windows, it
>is about running Libreoffice on LInux against Samba.

That's not going to work the way LibreOffice on Linux expects,
until we fully expose POSIX locking semantics.

It's the range semantics that will probably break them.

POSIX locks can be split/merged/overlapped. Windows locks
must be distinct. Currently over SMB3 we only expose Windows
locks.

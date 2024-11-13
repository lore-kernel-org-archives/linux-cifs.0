Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681F62AE69
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 17:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731520406; cv=none; b=o7acuRnxlnwYKFlYN4MIu7vB3stmMjP7EtUCOCXG0plVRysmo2cHd0jjqMhEHdGD1MJJVQjS2eBBdsG544XBIsg8NyyjFh5KP3tqfG/i9F4LEJ2tx2091uiIJsP7W9Yabmua7lHzuCt2BWH7cNMMxLfVeYGREXBpHHp4Ej3mcbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731520406; c=relaxed/simple;
	bh=4q9B36gbLrb7ibUdajk2SdO8gG9bPO24Znpd6WGVCAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6VQPOtzUsGwGdP9Hiv1jv9Navti9nUuiazoimhVv37BABwEEvWvIb/sN8SKucM+Ie/HxHcUADRmgVAi3kmF1m09hZYqUSUql3z9ZA0QmxSoLeOrzlCYyqNj/Pn6ceRqD3EcyKpOdEAlcpynJiLE288prg9FDi0nF0pIDDD+bgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=z8eLuYKC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="z8eLuYKC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=4q9B36gbLrb7ibUdajk2SdO8gG9bPO24Znpd6WGVCAc=; b=z8eLuYKCIFxRC0kkfHxzK4KLkb
	KJEIOCz7KMFMcXTVUxnY0AiNBqA0wQPrr5ePjgsKbaL5RHHDLwOibCqEYmwoiSLmmsNKwtZUjQPXL
	byRulCjTMhMC7zVHYrHFB1dZyd0Xvu5z6Nz3UIcbmCSQz/A5sX5S7lYfnLG1yhBYH1GhtT07E3+8/
	4v2lgA5V6A6XhzhkawflIG3ybouWmoscFFDgSSrltZpU/0KsmRBPrxNcEsTB6+ag8qUSvXQU2UhRu
	SAim+80vSK8TBBPeF6vxz+0B7o42Ly3ZI3rjHhG2SiL6FhPHMAgTshESNirVdb/R/xRrRj2ed6+4E
	MyezKxeNr5DJk7lk2piFg59O6W94PiZXLH4psksVep3LKPlTQkvb+WLhRlARYBZ+eD3OFWbYEgJ6/
	LJwcqfTS+Q9kbA5UBnqMr9jA+1KWQ/axXLs5XBWWoqLP+gT8il9ayeo0fet5UwhbNdH+2rBxprrQd
	sAphD0EPUiIIn7juj69hfy93;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tBHYP-00AQFt-1g;
	Wed, 13 Nov 2024 17:53:21 +0000
Date: Wed, 13 Nov 2024 09:53:17 -0800
From: Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>, sfrench@samba.org,
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
	bharathsm.hsk@gmail.com, Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
Message-ID: <ZzTnjVY1XqcbTOpk@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <1f8a225b0d16fdfa05c417e0f6602489@manguebit.com>
 <CANT5p=rm90eHDeA669yRNdKvT=GL+NE1PVTJVS-htQ8pbfiwUA@mail.gmail.com>
 <CANT5p=pFCbi1H-JzRLx5XqL4Qwy-YbOWAX6XmoWXezSn2i__mQ@mail.gmail.com>
 <b8164b0a49ad6d4cd60142fa55ad3566@manguebit.com>
 <CAFTVevVGMfkgsr31nN35-p+2nQZEXhHK8hPPF1EhfLmdtKdw+A@mail.gmail.com>
 <CAFTVevVa81C3u5Wdc+egz8ZbSrNKF7uy6m=6Nd5YnKfeMfo1sA@mail.gmail.com>
 <CAH2r5mv-uMJmfZ-4cuOBd0O2v6=rntaMbfggyXqtF4hQXHtvBw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mv-uMJmfZ-4cuOBd0O2v6=rntaMbfggyXqtF4hQXHtvBw@mail.gmail.com>

On Wed, Nov 13, 2024 at 10:51:26AM -0600, Steve French wrote:
>My opinion is that since password rotation is important for various
>security scenarios, there is value in improving it for all dialects,
>especially as the missing piece in the SMB1 reconnect path shouldn't
>be too hard to fix.

*ALL* effort in SMB1 is wasted effort. Please put it in
maintenence mode and just keep it compiling if needed,
but no new features.

Please.

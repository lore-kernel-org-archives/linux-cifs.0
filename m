Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD98180A6A
	for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2024 12:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724849871; cv=none; b=DkngYz9CnMwGciIn3HPbPWqGymCw/2p31TYm+r+mQ/JDwLfr2DQ7Gk+b1qNMHgcb2dAGQ40K14Ad8xGgzH0dTABvYyYktjf+Xles2vt2JDcRh0yiWirjpqyULsSEnga0NJlJn+OWvaIK2zMYnLyGZ8I34C6RwU5hznLTzzmj8Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724849871; c=relaxed/simple;
	bh=6TtJR9VpAO+hyUPZLParCnrgy9tglchQu+wNaK5wQGw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQQouPBEUHWWv+2jI6hvjZ6n+ngK5aF46C/9wb0AFsVXS9ZYf2y8aa1is3Zd4IQprNpqF2XuIAc2TmMN1emi5c6dSl4Ti1aHFqH9lJYf8pUCw5bS3f2caoaPIcRMISdqVmtAW3c8NvB3iGUnPv9YuNDJmgTfhM/Ws584f+SmWD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Wy2zE7j5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Wy2zE7j5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=t362KoSVHN+14HfBOdRHpi5lglTk1PVsvtayPae34Lw=; b=Wy2zE7j512ySnYR+2daQQmrPZB
	xixEsA5ftefyixs6uXzK50quNxeWi5wix3fuCR6ED34jNY0iCAWY1V5RVXA1/lF3yx7DShXDsqFeu
	cOjqej0nowavcm1tPhFsc7vV5MQAWhv5vIYuX66gT2/vYHLLObAFkvyjkgv8XYOVjFCKiVdybr68A
	IfIYWO2LrhCe3zcLwF8RCJFGkVS/2YMChYseHvwCxSAIFF0OfQHzo3O7PTbbsYkC9dnuW58cYV1Z5
	r9uxh+hJd6tDi/J3N8u8p79NlE0RY8vwnINqY8D3OEIGSZgSk0k8ndAaeSHEb9T+m9+4TIDiigu2t
	w4NSFosRxhlqundHEPkR9+RKJ8sg3lzKa/41eg2GuNyZWRi3fKiHQu22l9OEgdLdgfKKCVCctJPUW
	s/mp8Nuz15dt6o5p4wSB9Icsq9dJjKQVTfs3na0clsODnQhDTlBSTmv6W5oLR60gWQy38LUvZwLgg
	oFIgqLcTydDIYI1oDHgMSOhn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sjIF7-008nbS-0z;
	Wed, 28 Aug 2024 12:57:45 +0000
Date: Wed, 28 Aug 2024 12:57:38 +0000
From: David Disseldorp <ddiss@samba.org>
To: David Howells via samba-technical <samba-technical@lists.samba.org>
Cc: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, Steve French
 <sfrench@samba.org>, Jeremy Allison <jra@samba.org>
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Message-ID: <20240828125738.0e409cff.ddiss@samba.org>
In-Reply-To: <965293.1724845945@warthog.procyon.org.uk>
References: <20240828105536.1e6226df.ddiss@samba.org>
	<20240823132052.3f591f2f.ddiss@samba.org>
	<Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation>
	<CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
	<20240522185305.69e04dab@echidna>
	<349671.1716335639@warthog.procyon.org.uk>
	<370800.1716374185@warthog.procyon.org.uk>
	<20240523145420.5bf49110@echidna>
	<CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
	<476489.1716445261@warthog.procyon.org.uk>
	<477167.1716446208@warthog.procyon.org.uk>
	<6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com>
	<af49124840aa5960107772673f807f88@manguebit.com>
	<319947.1724365560@warthog.procyon.org.uk>
	<951877.1724840740@warthog.procyon.org.uk>
	<965293.1724845945@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Aug 2024 12:52:25 +0100, David Howells via samba-technical wrote:

> Okay, that fixes the problem.
> 
> For reference, the file can be prepared thusly:
> 
> 	xfs_io -c "pwrite 0 16M" -c "fpunch 0 1M" -c "fpunch 2M 1M" -c "fpunch 4M 1M" -c "fpunch 6M 1M" -c "fpunch 8M 1M" /xfstest.test/foo
> 
> and then the test run:
> 
> 	xfs_io -c "seek -h 1" /xfstest.test/foo
> 
> Something like punch-hole is needed to set the sparse flag - otherwise QAR
> isn't used by llseek().
> 
> So:
> 
> 	Tested-by: David Howells <dhowells@redhat.com>
> 
> if you need it.

I appreciate the test feedback. The change has already been committed
(with you referenced in Reported-by).

> The Fedora samba version I applied this to was:
> 
> 	samba-4.19.7-1.fc39.x86_64
> 
> though I had to drop the testing bits as they didn't build.

Yes, as mentioned, samba >= 4.20 is needed for the test's
torture_assert_size_equal() calls.

Cheers, David

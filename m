Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BF433FE
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 04:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716440077; cv=none; b=sTz5RYipLgPZ5h6VUuNBuFal51PGWnADv+LWcvkLnyu2L4Sxj+rZf0gNRsw0LRfyId3oLKtgQPGyAsr5y6xObDyPO4x2EuAZeYWHNlqUJiz/uAZINCBSiyjrwFCapeLfJi0yN2InSiGfl/sspryfaPYLadBC67Ijmx7Am6Nlb7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716440077; c=relaxed/simple;
	bh=L609VwHM1skQarJAvuN7GjRkgSsFJwq0jtVjg/okWE0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OIl6qJmbYw5RHmL9N4S9IQ4V1to2Egs1HL3y52OueyoPSfWU4Bre8xVqOKdSEIQAN+XWNrrI8aHQwNtLZfNx9mqfbcYqV4Fjl/cVJzrt672saTEz+tyk/YePlygo3fZnGHRSJup3BLuYJp2ry8FNQ/+orYnO+tAbw+9y/ir2YPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Z5GYinCQ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Z5GYinCQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=+1qRNJ8Vdsf5fcOmSC9GtqL+iSnXJZKWMOFF9aL4XUI=; b=Z5GYinCQFOqtbf0c0K8oj5EuBR
	1Lk/MxMgH3hBKdhR5M/leH3vkBUWs0zPHRSCfGNs74RYsH5aCfL9xUYaSoEwUvxBSujT0+BGzu51Z
	sBTUxqSOWndZcTHDmG2FU2NpJx1GaT9rcl3nY5dy/KiRgMBxpKqhKhN87Nn2VkTSa9PqRoU5+AV02
	futh58sU85SBEPQoQXX/vcRWMAq90kdZ5jrKlxCDtCzYEeEV1NXc8uzo8azM9NuRnM22lbvoiZT3y
	vYJRy9rPwMLrmZbGHR9SyzvlzH5iWlnxqWEPgpDPQFh+7N/QpKpTh/tBC5RFDL6Tnb/zKZZFJXHuL
	6m+u3zN+pX2le/BKVgAkUFzTJ2XvSSszpyRRDXUaF1m1DCix+QjkeUk5UeD/Feqo4b2dBhSqbxDcL
	QvjD0uhpL+JGWyCQBCifsotPBU/uQAG02Ccet3Ah9dSeGdkWwuhuN6dxewuXK1pzXgldYhh4sL1cg
	+5RF1l8jBssKw2sh8OFHHTMD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sA0TG-00Ci61-1N;
	Thu, 23 May 2024 04:54:31 +0000
Date: Thu, 23 May 2024 14:54:20 +1000
From: David Disseldorp <ddiss@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: David Howells via samba-technical <samba-technical@lists.samba.org>,
 Steve French <sfrench@samba.org>, Jeremy Allison <jra@samba.org>,
 linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Message-ID: <20240523145420.5bf49110@echidna>
In-Reply-To: <370800.1716374185@warthog.procyon.org.uk>
References: <20240522185305.69e04dab@echidna>
	<349671.1716335639@warthog.procyon.org.uk>
	<370800.1716374185@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 11:36:25 +0100, David Howells wrote:

> David Disseldorp <ddiss@samba.org> wrote:
> > ...
> > I think the best way to proceed here would be to capture traffic for the
> > same workload against a Windows SMB server. This could be don't by using
> > your cifs.ko workload or extending test_ioctl_sparse_qar_malformed().  
> 
> I don't have a windows server I can try.  Steve may be able to try that.

I'll put it on my todo list for the next time I have a Windows VM
sitting around. I do recall testing Samba alongside Windows when doing
the initial implementation, but QAR is very FS block / allocation size
specific, so 1:1 behaviour isn't straightforward (nor is it required by
the FSCTL_QUERY_ALLOCATED_RANGES / FSCTL_SET_ZERO_DATA specs).

Cheers, David

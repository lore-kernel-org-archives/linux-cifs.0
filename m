Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443887;
	b=RyZmMTIujjTHpVC6RaTTN48wc1G5qc9Sq03dgY15nfQ0b2N8RGGGtN0EIuxx2jcYyPOS
	 3TXoMk4cPuqXEuEy8vFiWP//I7c3WxGdOvnme+lOaKnhrcyWzL88ONjigHTsBCB6b7FUl
	 g6RTDZl+e4YPfKOOq7E4XkyFDvhRmC0nHEzElbGvbhr7A89nkhuXoS6eGYPp97OtJw2xY
	 2fJltqg0Gwr5GrKRPtl7sAtUyQuLT9qg6xNgI8bTmFIGXLIRUn9IROrm0SUCLfWqwOPhE
	 vnBsweT6nNQGxqdtuanndo7tluhVz9AwkA1fnexPo02tL19Q4u5EA+wMcYBBZ4Pj9jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443887;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=r6t2v4TzVQocCpmBzwTi36nkN5g+t2EWGFnOEr39rRA=;
	b=gIqtJVNcnKJKC8n7w9RMCTugiGfAdpemTiSrdBsd1NIOHHn+ZqzyKp/PNJZRGNe7Xe4L
	 3XY09MWyiTU1FpIIHZw6r6xGjI1yAY40BFjBoK1JXTOv5NnOGxVzYpms/J4rgMhSsNO2w
	 zvoDMIoOuLuxNYM1h9xN8NCO+3LauFmdGYKHYnKeTGHTkGOGWzWcu7IpuMK6cUozb5EfT
	 TI3u+W8m+qpvMFLz0TznT4VJaFboelxv5j7AtA2CsFAs/yHWjSeahGJ1F2zqzx1lAQhhf
	 pXfXvXPHwK16LBAjRVNx0xWLZZzjqoZqdtjHRjwkcS0G+C8K7lJRS4PGvvB+1kO552w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=C+yNBmfA;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C6606A31A
	for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 14:24:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 184C6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=C+yNBmfA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r6t2v4TzVQocCpmBzwTi36nkN5g+t2EWGFnOEr39rRA=; b=C+yNBmfAeTpVeeYC10eqKQw0zl
	yIQsdrs6fnhWEJBNnwfaaQf07/Trp/GiVWmDxjAn2f4EEZQPJVvRwYKTWraVKouEjZ4lHeCSHNt9A
	KkZUC/D0Zs7cehjoInYsSQ6Kxa0KO3bz/3eFfX8aR3vKQcaU/4gg3gtcuaMpyFPdA/WTVyfgQy5/V
	xb9VyQD1a41xkn5B+vflMBn4aQF369HG1tnqEjfLk/2DywlspvDWxe8lNlpMoCw8vGBDa3UMNHtUH
	WZhETWMOBxwjPfZdLhCVEDRJKXW0aBEMsaKFFixfMW4/WhgMouJSvqbpV6NEA9cZ3Qvp5Xo2DgqQK
	PsMDZAQQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xVUyB-00000000iL4-08nW;
	Mon, 23 Nov 2026 11:24:35 -0300
Message-ID: <aff738720552b9a11dc4ad6d66e57de5@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Tanuj Sharma <ertanuj96@gmail.com>, security@kernel.org
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 linux-cifs@vger.kernel.org, Tanuj Sharma <ertanuj96@gmail.com>
Subject: Re: [SECURITY] smb: client: OOB read in parse_sid via unchecked
 num_subauth (18 years)
In-Reply-To: <20261123111922.84271-1-ertanuj96@gmail.com>
References: <20261123111922.84271-1-ertanuj96@gmail.com>
Date: Mon, 23 Nov 2026 11:24:34 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Tanuj Sharma <ertanuj96@gmail.com> writes:

> I am reporting an out-of-bounds read vulnerability in the SMB/CIFS client
> that is exploitable by a malicious SMB server (or MitM attacker). A rogue
> server can send a CIFS ACL response with a crafted SID containing a large
> num_subauth value, causing the client to read up to 56 bytes past the
> buffer allocation.

Have you tried with mainline?

This seems to be fixed already by commit

        29f1005b8b4d ("cifs: validate full SID length in security descriptors")

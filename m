Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F303371068;
	Fri, 21 Aug 2026 18:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787336252; cv=none; b=Z20z3r69bgcchcJYH7dj9WZr1mcpFkxkmC6z+rQ+Dq9/Iv7BruLRLHzyAVXZjDKcHDV/dqFIpyanTQzZr8P+U5RwKUwbbILCqKhTsJDLnGI4/tiHC3V+fuFqaTHhsBCl1ZKvb7tmJXz5qQnrOl9Q58c3mrMTZ4unM7wIujctJeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787336252; c=relaxed/simple;
	bh=0LRGlfknpGfx9M40YuP2VpoznZQSLyhvSkSmBIhe0cU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=VQHQviZAGs8Z19gB1lP6X0Cq1inNK3KCkWLxPBfY3U65uOmmN44eZ5hy2aLfN3hYXWx0j6VE7leslPADiVhOjbW9k7ivE/ZF0wcRjqy/0EXUn5bi1mGXfXVB643ykMz/o1vB0z58atq0BqZZt0BJWhHkr1zfH4AEHSsgmZyv9Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=LRLF9SMd; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="LRLF9SMd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eYL+HCcMJAbsyIKf88u7tjB4pIhnfAxZu6w+CoXAEL0=; b=LRLF9SMdQcNoKeQ2kstH7EZdWo
	Acf9YVWVu/kg/WZ3WhU6zbOhySFJlUXUR/BvUWU30s0Kfl70iOVjP0f09D5V/AcIZ0N0SRLnebYIK
	J1BvI8/xfG6IlkGaevz0ccaLUVcK2YA5GRiSjtpuDPEzCqHZA8/FZHTW2k6qa7JjMUnNzD1buBaYF
	TkJxx9v8YmTA4GaZ2TFEa76n5+zTJ2E6OcPOU0FTXSm6nDVzaf4HSrsEn1QqGmH1ZJoPewcFXCS7v
	gOIGi+1g+lBu5D4r5gZrblpUhAyb64T/ehv/V11mB7CNrq2jmKygb63GZ5sG+9UUhsTNhBKDx+1ly
	QjfCsGkQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxTny-00000000Pvh-319x;
	Fri, 21 Aug 2026 15:17:26 -0300
Message-ID: <6106bf0aa56b46d03696f37e30462f5b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: hexlabsecurity@proton.me, Steve French <sfrench@samba.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, Tom Talpey
 <tom@talpey.com>, Jeff Layton <jlayton@kernel.org>, Bharath SM
 <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Nathan Chancellor <nathan@kernel.org>,
 Shyam Prasad N <sprasad@microsoft.com>, Namjae Jeon
 <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v3] smb: client: reject a tree connect response whose
 byte count is too small
In-Reply-To: <20260821-b4-disp-5297959d-v3-1-2f92f9abccee@proton.me>
References: <20260821-b4-disp-5297959d-v3-1-2f92f9abccee@proton.me>
Date: Fri, 21 Aug 2026 15:17:26 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
writes:

> From: Bryam Vargas <hexlabsecurity@proton.me>
>
> CIFSTCon() bounds its strnlen() over the byte area with the server's
> ByteCount minus two, which for ByteCount 0 or 1 goes negative as an int
> and converts to a huge size_t.  The later subtraction wraps the __u16
> bytes_left, and that is what bounds cifs_strndup_from_utf16(): a bound of
> up to 65535 against a ~16 KB cifs_req_poolp object runs off the end of the
> slab object, and the bytes reach userspace through tcon->nativeFileSystem
> in /proc/fs/cifs/DebugData.
>
> Reject a byte area too small for what the parser consumes.  Two bytes is
> the least it can consume, and no conformant response carries fewer.  The
> new trace point is the 129th smb_eio_trace entry, which __mode(byte)
> cannot represent, so the attribute goes with it.
> ...

Applied.

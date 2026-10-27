Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793064714;
	b=IvHsTiqXhAqceRistSqahJ3a4QPozOWx+KvDBLA1Pl2kKbhMTCctePpc7iFGlPKxm5Gl
	 kggzqLRnyVv+0+T9GrXYvwD8R2t73s8Wt5fxZV951BTEu+JeyKH0qcolPSRwHmvTLZpYx
	 LwTBex5oSgxIcaufTxohJewEpYPvFgTnyVdmUVWdN3FcM46O3NBeHgFQncxL46sCDUrH+
	 sCWwx2RYWFg/K/YIGDiTXLLHMfRQ6K44vEsH1WViXuR3Ta3qYbG5LD98SzhUjEj1SD0QB
	 DtgmTzG78gJcO6XXJ6I280lblaUUlWVFJbdsx3cl3oFqNIp1mexHX7eluSWoJ6SWcyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793064714;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=jSk2medBx+PtR34EmkrUqHDqmChSl5sAB6MpgXZMPFQ=;
	b=fgGERwjbbT7WrJr5xwrvOA04knQZ8alfkdcRwq2OPHQw6PwO7lie+LVSEZxU9QgFLG8x
	 w6r3lcldKXw4oUkAiVYdzLI+VT9gWwJt/jai/uomAAKiMmC+Wv/8iiap0OeE9O8dkZ0UE
	 AKsf3DkeJea9UY7d8q+jGUTzlMtM5WBMkQc89W3nOhrs9DHX2YiHR0+dSKQR/1tE/kayn
	 fSR3gj2NNDQw5RKYUlF7CGf2yxsyza+o7C89iFNLCFQAvasuP0X9pqh5lBjH/WPA8AmIS
	 HImaxsNDrSrVJccZsqEeGePx3z4XbCTdq3TP7Qj8wyDhSizcwIx2FDtMszXTGXURDuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=cZBETMzh;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3DF606A31A;
	Tue, 27 Oct 2026 01:31:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A3DF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=cZBETMzh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jSk2medBx+PtR34EmkrUqHDqmChSl5sAB6MpgXZMPFQ=; b=cZBETMzhm2Do2XtXioksC+Pds4
	ovjKfJjsRadUQ9tRiVu5OJ5nQ+vUtFo+O4tV2NaESg7Qn7Q9Aubrf2bMYX0ItPg00lnINHjsme9B5
	8fiaycGzO5LfFG36Brm5Sr7FgvGgcZt/jB+Nyn5otBTJDgiHfOM3UESvw2t97OpTiBWrQjTBD3axd
	NHpdgSjhiFDyxQ2DX6niMh2A8/IyuIWZX0WWV4/eQK/YN0VOJ8pCCMXh2jVEPaNiNRDBuU+U78LRx
	nR9pnj9TwReRfYHbN5K0+daZHQLaZrdckrHK9bwl6ly8NCeR5RWkKOrg78R0NCqQFu6YsDfFxsmCG
	CuOAnYOA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xLW2O-000000006NJ-2Wyo;
	Mon, 26 Oct 2026 22:31:41 -0300
Message-ID: <7fefb04108efc48418cb2a8ff7287293@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Weiming Shi <bestswngs@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Steve French
 <stfrench@microsoft.com>, David Howells <dhowells@redhat.com>, Xiang Mei
 <xmei5@asu.edu>, stable@vger.kernel.org, co+24c7c12d69e63c6d@bugs.sh
Subject: Re: [PATCH] smb: client: stop processing a read response after a
 receive error
In-Reply-To: <20261025090730.2893106-1-bestswngs@gmail.com>
References: <20261025090730.2893106-1-bestswngs@gmail.com>
Date: Mon, 26 Oct 2026 22:31:41 -0300
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

Weiming Shi <bestswngs@gmail.com> writes:

> cifs_read_iter_from_socket() may call cifs_reconnect() before returning an
> error.  The reconnect path aborts pending mids and invokes their callbacks.
> The callback can then release the cifs_io_subrequest containing rdata.
>
> cifs_readv_receive() nevertheless continues after a negative return and may
> dereference rdata in cifs_readv_discard().  KASAN reports the resulting
> UAF:
>
>   BUG: KASAN: slab-use-after-free in cifs_readv_receive
>   Read of size 4 by task cifsd
>   cifs_readv_receive (fs/smb/client/transport.c:1284)
>   cifs_demultiplex_thread (fs/smb/client/connect.c:1355)
>   kthread (kernel/kthread.c:436)
>   ret_from_fork (arch/x86/kernel/process.c:158)
>
>   Freed by task 148:
>   netfs_put_subrequest (fs/netfs/objects.c:267)
>   netfs_read_collection (fs/netfs/read_collect.c:460)
>   netfs_wait_for_in_progress (fs/netfs/misc.c:462)
>
> Return the socket error immediately, as this path did before the iterator
> conversion.  This also avoids adding a negative length to total_read.
> ...

Applied.

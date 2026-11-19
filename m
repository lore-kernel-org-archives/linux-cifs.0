Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795096062;
	b=mx886Ow0iHVY0shtNKtd+7+R91pwqEP1IgqIneD3gD0sCuHc/OAw3KcEKToWT3quiL05
	 6tuANzrLPhKfqKLqex05zlpzR57zo4OMd36BBxEAdIERlwRKgGuYSIsh1gWer2lD9bINX
	 VNgUOG9FZ+caxw8t7MJkpr1sLaYpYFQqwpas+K2YI11bM9iZhApArKg+3Q3+Sda41Wni/
	 UbiOatU79q2nx8+ZNKKgI7LYGFG2eo/BfvUxsD/Z3a/bSImgQO8eDENqKdMY5Ia9/Toq8
	 FHE1JLXfnePpUKBRBZROTmabMwZzHgyUkMAD78FIBK+bGMvbWTrzqDn4viEQLI7Pylw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096062;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=PnTUDA9PL56XeQ1thHS6dj/A0MSuuraoCyWfWwLLP88=;
	b=tVaBnzQqjrQefXneACAd+rC7AddQUMB8mCFXASB9n6KeR/q4dGqy2xLx3UThgd+ma9bJ
	 VoxQFavw1EFiaN7wFxnfmqtiC8WTXCcPXyaVUnQuH34L0UMN9tTsk8Irwc1ecJQ4Gsl5m
	 ox5vAzRqfoyajX8kBFterhUZlJ7V0pzuPHDGZszzCw6eCHvzqJ7jh+wBF6Nbqz/vXuS+z
	 vBZsNP4tUYFdCRDRvZTLo30dZvY19hAzhkA8/HHTNJ0hAJQN+hT20DFTT8cKj69yb4MS+
	 ryfiF+wAfbYZhdU5SU0IQ6Ue2wv7ceWJZcBYLzTAG/hIQ7M5i/vHHv5E5w10s0wisXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="gU/QFNfS";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25900606A33D;
	Thu, 19 Nov 2026 13:47:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25900606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=gU/QFNfS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PnTUDA9PL56XeQ1thHS6dj/A0MSuuraoCyWfWwLLP88=; b=gU/QFNfS5tnM0IRCWHmLYFYhr1
	L6Vru0xmPZXOOwTG2QMv4H3QUY1lr1oC15XLsnzVhMcLKoLQ90w/ticZ7IjChNIDdfbES6F0jzDAb
	XfMO7TvQkuEybDANG+T7yeDv6/8fn91XM5BZZ+XtXEjcDfSiChloU4NTshPz2Ln1l9ofRXrceOcI4
	nAHVX8ntATjzAdm3r+4mQz/roJ9d/8WomPDAs9JlCBBn4ZFIUTsap52eEpRMY2aT5ZTfKBu4egYtD
	erheDOMB3CPPJ5i+QCXNhOMR4n7HgkTrUn5vBnsGtqCM3byx9d09uKbXJEatHpdVDJrcJdO5+Bd/8
	BVcgRWrg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xU2UG-00000000Og9-23Fb;
	Thu, 19 Nov 2026 10:47:40 -0300
Message-ID: <a74e3d9296fcebce8d4c803093d4c81b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ozgun kultekin <ozgunkultekin@gmail.com>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, David
 Howells <dhowells@redhat.com>, netfs@lists.linux.dev,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: do not let the server grow a write subrequest
In-Reply-To: <20261118002159.20576-1-ozgunkultekin@gmail.com>
References: <20261118002159.20576-1-ozgunkultekin@gmail.com>
Date: Thu, 19 Nov 2026 10:47:40 -0300
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

ozgun kultekin <ozgunkultekin@gmail.com> writes:

> smb2_writev_callback() takes the byte count from the SMB2 WRITE
> response, masks it with 0xFFFF if it is larger than the request (for
> old OS/2 servers), and then copies it into wdata->subreq.len.  A server
> can return a count that is still larger than the request after the
> mask, for example 0x8002 for a 5-byte write or 0xFFFF for a 4 KiB
> write, and the subrequest then covers data that was never sent.
>
> netfs uses the subrequest length to decide how far the write collector
> may advance.  With a grown subrequest the collector moves collected_to
> past the data that was issued: netfs_writeback_unlock_folios() walks
> folio_queue slots that were never filled, and
> rolling_buffer_delete_spent() frees folio_queue segments that later
> in-flight subrequests still use.  This is a use-after-free that a
> malicious or broken server triggers from an ordinary write:
>
>   BUG: KASAN: slab-use-after-free in netfs_limit_iter+0xed4/0x1040
>   Read of size 1 at addr ff11000010561511 by task kworker/u8:4/63
>   Workqueue: events_unbound netfs_write_collection_worker
>    netfs_limit_iter+0xed4/0x1040
>    netfs_retry_writes+0x1410/0x1e90
>    netfs_write_collection+0x2647/0x3880
>    netfs_write_collection_worker+0x1cd/0x3e0
>   Allocated by task 141:
>    netfs_folioq_alloc+0x39a/0x470
>    rolling_buffer_init+0x29/0xc0
>    netfs_create_write_req+0x12f/0x840
>   Freed by task 42:
>    rolling_buffer_delete_spent+0xb1/0x220
>    netfs_write_collection+0x1f62/0x3880
>
> Never change the subrequest length from the response.  If the count is
> still larger than the request after the mask, fail the write with -EIO
> and record it with a new write_overlarge trace point, like the read
> path does with read_overlarge.  A short count still returns -ENOSPC as
> before.
> ...

Applied.

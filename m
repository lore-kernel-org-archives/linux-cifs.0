Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039379;
	b=jIKEwf7jVVepOB3mFvpb7zl6gm9MN6NwPZkLQfuWOoJrcX7TSr815NPw4Le5NPfJSxpM
	 zQGca1fM1hodJKjhPhNwe2S1kKdIH4w5YAXu6ZPt4DWPp9wD2Hthcuy7nVgnd8yhpLLsn
	 46pUbYJp0efzUue283CbxJeL8q6AgJzCDzJ7Gi5n12BTAQ6UOie/yTXvCiB7ZPfKTEVQV
	 2oZVJTwfeLVY+g7xvlqyyArq0n17FB5+UE0NlELE25nWNEawQxj0x7utWh4LXr1Mz4a9b
	 RM+SV5BrbUc8rOr/ZwA5cDZlesig34tNFMJMevTfX4oOdSixZNvm/WOgxg0+TeqO7iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039379;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=08TOTiTUtxZoeQ6P+kvUrfN6YEoDJaYokr6wulDwfGQ=;
	b=MtsH/IMD9vAt97hNJKmH+IB/LxIMlSe1SEABqZjptOoxOGAMxaMLqmY9evW+oRGXDXj3
	 lByZMQh7pSTemRTEq9YsjTsCH6twpnoXicyy0z7ZMQSYkUw015VO0QZ4nWjwMHF2K0wfb
	 z122l4FW1mSDU+efFbJ+ZHGCZO8JHHg/7bBIRFMlswCC3+44huKbU4PcXUHoGDMo7J/R0
	 iMSVQDvj7BPomN/2tftElLH/DD8cqLGkrqPHcZTLDk0Hre10ctARL6QCmySHlGoulcOLg
	 RODjZKf6P6uPlAtqYklLjumPCJE3WWfdPf2V/irB1DVNUV3NW/7TKc9X8Scs5gCEOsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=ImlqKEtx;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C55606A325;
	Wed, 18 Nov 2026 22:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43C55606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=ImlqKEtx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=08TOTiTUtxZoeQ6P+kvUrfN6YEoDJaYokr6wulDwfGQ=; b=ImlqKEtxwjFFtvf6MKkhARt59o
	zjEnirFTB3vxpp+JvQZvX/ByQIUFNLQuCWndE1iehY7UcWjFF+tj8t521wG/6AXrJXo8nMCQxyms+
	Jng5NHJqM0dyX12aMkISKWwXfkBki5sR82o1Bfl0159G8P9Bk186mnVrCcP6HiRHh2yGB0FcfKHrY
	gZ5s4O5B2DLzcy2iI9DBstMr+d74RnTtP5YKv6SfGU5g6gr9qIq5MvHOW2uPwxPVLXmIdIgdveMqp
	KnzNWz8AaZz/SGyUTobs2YvzcnrdtmOj4XvIX8NnbhoLIr/4mw0FDtfPJb9BviccwNQEoGXO+3caj
	1B2Lz+qQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xTnk1-00000000KWj-2udr;
	Wed, 18 Nov 2026 19:02:57 -0300
Message-ID: <08a684fb935ae094d70dfc3111c03054@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: shyckless@gmail.com, linkinjeon@kernel.org
Cc: ematsumiya@suse.de, sprasad@microsoft.com, linux-cifs@vger.kernel.org,
 bharathsm@microsoft.com, ronniesahlberg@gmail.com,
 samba-technical@lists.samba.org, daniel.birtwhistle@gehealthcare.com,
 linux-kernel@vger.kernel.org, smfrench@gmail.com, dhowells@redhat.com,
 tom@talpey.com
Subject: Re: [PATCH v2 2/2] smb: client: don't use read data that failed
 signature verification
In-Reply-To: <20261116-smb2-sign-v2-2-a823a90d0db4@gmail.com>
References: <20261116-smb2-sign-v2-0-a823a90d0db4@gmail.com>
 <20261116-smb2-sign-v2-2-a823a90d0db4@gmail.com>
Date: Wed, 18 Nov 2026 19:02:57 -0300
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

Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
writes:

> From: Suyuan Wang <stevewong@hust.edu.cn>
>
> When smb2_readv_callback() finds a bad signature, it sets the error in
> rdata->result but leaves rdata->got_bytes alone. Further down, a short
> read that reaches the remote EOF clears the error again:
>
>     size_t trans = rdata->subreq.transferred + rdata->got_bytes;
>     if (trans < rdata->subreq.len &&
>         rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
>             rdata->result = 0;
>
> and got_bytes is then added to subreq.transferred. So the last part of a
> file, or all of a small one, is returned even though its signature is
> wrong.
>
> Clear got_bytes when the signature check fails, as the retry path in the
> same function already does.

Please check sashiko's review.

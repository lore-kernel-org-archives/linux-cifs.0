Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792634775;
	b=ki7UiSFGkAcepBdf2hOkSDnEPTbohwo9VhUz93w6GnZNgtJCRIA4Sagm9ZtyAJ6qdSSQ
	 grYwypRL2uUqBR2nLz/hYw4YKT1IuCNvxwVxfzPEd+SU/4ttUPkbvpmg8VrrERs03e/eb
	 zkwQOp2NGBXQdgPglHwp3VQHal35as4C2IAcQG0cnjZp+VXgK7bI3tt0h1mORnlQEkZxa
	 dDBQqagqoOUdB/HAkYKVbwNOLfnTUds9n4WHiLXhs7Ptqbg1Hshm6w4gTrIJm4D+OZe2y
	 LMmEBEBi9SLzkSkgz3knQ4zhb+19W/8krglCyUAPm7Cz781UU/1+PJSWED79wJoMGNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792634775;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=j2cAB1POgQzfElSWhdW/v+gkfu+KXUcCuKBkn2LfDys=;
	b=gKkXFd9KDZ8uYWreiflb18Q/jzHCOPO2KZegCx1L+u48gNbBNb81W4Ag7gzz0RsscMlZ
	 mDqPB6UFIVRoc9m4z/yExmLDsuyrFWxMdXuZ3I+8Pic7nxLqUqm7w0JMST+3YHitHdMEk
	 VJJeEEkFePWjBzTOWdF7wPlID1ovjSxjkZ1E5vX9SO+i2tgrnPVb5xhlXq+W+WgINyAqx
	 MNcRpYqCXFe1iMqWAAc4Qt2cEcgEYscXkGX5fVBMX8LB167MqccjVIzcX6I1RLDqcLa30
	 2qX0geYbFXpvvseUqPuf95Vir+zl78/sVbMGkbnTZtBJ6wd9Q8xITpMeGCHIVysYrdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=vdR8mo5p;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9391606A31F
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 02:06:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9391606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=vdR8mo5p
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j2cAB1POgQzfElSWhdW/v+gkfu+KXUcCuKBkn2LfDys=; b=vdR8mo5pdNadr4Ct8gnW3TEJw2
	qZX+TtUKTPj46KmL3gnIhPaEhRhTfFPlhimu8XnllhbddY7+8hUBtb8mD2ptJ59OuY4c+YvQwyXrG
	Pf9wP97+crTsCXPccZqm3RvbVDny2ZU8xwh2KisuJtjDvb4hyPrpO3bCrI1NWwbNfjzZnXJHrmVX6
	9PYwuH2nZj9Fusm2HlbnrESX2aG99whBAYNhnb9bLnXTl7rrdnoGAMMyIZBdqRdsD+zhKS66T28F3
	23doSsRT3478etsKN9EB2JeuJ80HjK9/oHAw2SWADFcsBAWrSHb13Acl7GjekdMqO+FOOJYeIpmyq
	6egXlVmA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xJiBq-00000004C3V-0BV4;
	Wed, 21 Oct 2026 23:05:58 -0300
Message-ID: <f12d3f8e42a657314db587266a991a05@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ren Wei <n05ec@lzu.edu.cn>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, smfrench@gmail.com,
 jlayton@kernel.org, bird@lzu.edu.cn, rakukuip@gmail.com, n05ec@lzu.edu.cn
Subject: Re: [PATCH v2 1/1] cifs: fix buffer overflow in SMB2_tcon
In-Reply-To: <20261016071101.1800770-2-n05ec@lzu.edu.cn>
References: <20261016071101.1800770-1-n05ec@lzu.edu.cn>
 <20261016071101.1800770-2-n05ec@lzu.edu.cn>
Date: Wed, 21 Oct 2026 23:05:57 -0300
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

Ren Wei <n05ec@lzu.edu.cn> writes:

> From: Luxiao Xu <rakukuip@gmail.com>
>
> In SMB2_tcon(), unc_path is allocated with a fixed buffer size of
> MAX_SHARENAME_LENGTH * 2 bytes (672 bytes). However, the user-controlled
> UNC path (tree) length is passed to cifs_strtoUTF16(), which assumes the
> destination buffer is large enough and writes strlen(tree) + 1 UTF-16 code
> units.
>
> Commit 62a1a439e0fd ("cifs: clean up handling of unc= option") removed the
> length check on UNC mount options, allowing mount paths to exceed
> MAX_SHARENAME_LENGTH while retaining the fixed-size buffer allocation in
> SMB2_tcon(). Consequently, an oversized UNC string causes cifs_strtoUTF16()
> to write past the end of the heap object, resulting in a slab-out-of-bounds
> write. Furthermore, if a tree exceeds MAX_TREE_SIZE characters, strscpy()
> truncates it in cifs_tcon::tree_name, causing subsequent reconnects or
> failovers to fail.
>
> Fix this by first verifying that the length of tree does not exceed
> MAX_TREE_SIZE, returning -EINVAL if it does. Then, dynamically allocate
> unc_path based on the length of tree so that it safely accommodates all
> UTF-16 code units for paths within MAX_TREE_SIZE.
> ...

Applied with MAX_SHARENAME_LENGTH removed as it isn't used anywhere
else.

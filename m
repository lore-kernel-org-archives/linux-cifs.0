Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E28A3B42FA;
	Tue, 15 Sep 2026 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482577; cv=none; b=eGiWbjd9LcOofRQbt62mbykGGFHpnq659Dt//ivXfGBLLLJtJZlTmvhgqe8/13bIkyK6E5QE/MsX8ZqimyKEPiUlz4vd8p8ZJLoXtaXe5kuc4x2dJHO2khR4i6w117oFzrgk2rqq5daFq9Zks3A1bvm9DJig+uz+BuhB4Wt6a1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482577; c=relaxed/simple;
	bh=o0EkbaQ0R6Oc8/2K3QdGepztTSMkY4VOV89YoJ7KG9E=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=h3bzmbqJck3Q1lc6GN53Nlg/RRpAzHdyoLB484WfG2jaMjBmCWBeUiy7ryBGf7+zq+weg3h9w4OkDe82/odvU5h7pgOyCqfp6hRHyo1syfr+QWiySjFSNVauONh2+mqaGDzdgjGO9BaeHOUM5Q/7WQMPiGHBDcENEpVhNapMZIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=3EFkFQkp; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="3EFkFQkp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kxh2bZs6HkmBPZJmhL6Ymfi8GudVVpkSBaeksCR9opY=; b=3EFkFQkpKF6B/ivIILv0s3BOWk
	UT1a58VQb31woTl2qpLm3QUgD/4DPfqaU3ZMPrRgiXRAPxIAOoTzVjhivdVl+QSrrbCaNdx03Umdm
	qTDj1myVS5l7WjwrKuc54MvMuurnrzgNZJbBnpmvUu7dqKmEjvwN60odM0yqjtJBGAI0XLWkYlIt+
	8utVx7k/n4ZJu4sfCu0rQu2x3xarGcrgMjV2CQ1ufqV90ACrXb80dyxtTlleD/H/bmRCQ1f2uMaXT
	19BontNac4P0YiTArWZu3XqSm3JL1m81g02ZpL8ioYmYaDblKhcmwC/McZS3ef9z0yyKVbyuEY1Pl
	o8Nq9SgQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x6UA3-00000001Uoq-2fbl;
	Tue, 15 Sep 2026 11:29:27 -0300
Message-ID: <9cf1d88750bcaa0fc0f7b792b0a22295@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Bharath SM <bharathsm@microsoft.com>, Namjae
 Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: fix unaligned access in WSL reparse
 point parser
In-Reply-To: <20260914011052.809774-1-pc@manguebit.org>
References: <20260914011052.809774-1-pc@manguebit.org>
Date: Tue, 15 Sep 2026 11:29:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> When wsl_to_fattr() parses WSL extended attributes, it computes a
> payload pointer from ea->ea_data + ea_name_length + 1.  Since the
> smb2_file_full_ea_info struct is __packed and all WSL xattr names are
> 6 bytes long, the value pointer always lands at an odd byte offset,
> never satisfying __le32 or __le64 alignment requirements.
>
> The code then casts this pointer to __le32 * or __le64 * and
> dereferences it directly, which may cause alignment faults on some
> architectures.
>
> Replace all such casts with get_unaligned_le32() and
> get_unaligned_le64() in reparse_mkdev(), wsl_make_kuid(),
> wsl_make_kgid() and wsl_to_fattr().
> ...

Applied.

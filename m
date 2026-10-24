Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792804233;
	b=33f/HR12CIuKLk65f1wAN7gzFs7lcSBAoAnzISkNHpj7/GJo8KhZNbnWlV1aKkQY6IrC
	 Xm3qiQ2nSC20U1vYgL4D1nz7rbcUhAbSlH36mz/rIachXDz3vYC6TQ94XAJUDK+3nqXtz
	 NU5nhDnshNl22XAaGbcoy4dMX9rwK+FBegpMC/LWDnc46kZzwMumQHP96GdfLEdzPhJxG
	 x5gKaHlx0rJYSELCmVYALHdQFuwBpOPn36WPUjGQA5/s0HDs765FPpMfoo9SzDJFDyicz
	 AHh6UET3r9EnbiWf5WKZbOg5Pwf8OhLgPPZwiy8klAy/JYIhdBsZZE7n7wLAYha8aYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792804233;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=lOR7XnVD9EiQIXXVZhyBKMhMpZ9htVRrZdY6ZGRy8tk=;
	b=jJYL9Wt6IJVl/ijnuffUCYhQA3SFqSP7pZ9WIaZEgqJXo1t9/0HLpXtkfy1qkIfiXJWB
	 ND26Cgw+XcM718tc2XghqrQPaq3Wp5Zw2htrHsVBNqb1IwEePr7zNco+uAVPsGTxGq0Z+
	 f+Z7oLj9yU8Epw72A8XfcdgN1r4npTCFvT1legV2JrXO/oHm0z9dmFZZJKkG8Z9nk5jJp
	 jvsS1on+V1hD9YGk9eFIQWqLpOENSUm0EVq/YjzhfWR1nnIL0adcLH7/WJZA7AjR6HdJ0
	 iSF65HeCoDnWnxn94CGFColKPAgQxY4fL2tj+r63ywHgXQZinP7k2QbCpt6nPI0yn2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="drb/iLhK";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C504C606A31A
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 01:10:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C504C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=drb/iLhK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lOR7XnVD9EiQIXXVZhyBKMhMpZ9htVRrZdY6ZGRy8tk=; b=drb/iLhKHcrW1i51pjr0P+ib5Z
	NkS40upfqtrB5oyJPMi+XYxH+ynxQpA2z7iVLplmo9DbQQbsBDrQ5rB6kLZ77fIr5VQtGgWnAWsni
	w1F+74LER9cD/4pw2Qi1CjkMfo1qX23E7VZt2H3glFzKkc+LrLLf/o7clv3nxEHj9loZ+zcKixtB8
	nfuqiANOyMnP5bFxR+j0/ksLDNwb6jPXYz3ZktG9SKupFSjIp2h1PkuaBcfu3S97uJWiw3yKXMrQv
	0SZI16QCiZJaADx4M6gfQd8lMUbNJYdbP2VgCQx6R6PcNH3zNUF4xV709k+vq9Y/26iySD0GBpEx9
	YXOh2umw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xKQHF-000000007dz-46NU;
	Fri, 23 Oct 2026 22:10:29 -0300
Message-ID: <b71198e85e4498dc27853062529daff3@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Dominik Maier <dmnk@google.com>, Steve French <sfrench@samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, dmnk+artist@google.com, Dominik Maier
 <dmnk@google.com>
Subject: Re: [PATCH] smb: client: fix slab-out-of-bounds write in
 id_mode_to_cifs_acl()
In-Reply-To: <20261022232116.2536320-1-dmnk@google.com>
References: <20261022232116.2536320-1-dmnk@google.com>
Date: Fri, 23 Oct 2026 22:10:29 -0300
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

Dominik Maier <dmnk@google.com> writes:

> In id_mode_to_cifs_acl(), while the chown branch reserves
> sizeof(struct smb_ntsd) + 2 * sizeof(struct smb_sid) (plus
> sizeof(struct smb_acl) and the worst-case ACE space after
> commit 0ee150794c75 ("smb: client: fix heap overflow in DACL owner/group
> rewrite")), the chmod branch only adds 2 * sizeof(struct smb_ace) or
> 5 * sizeof(struct smb_ace) to secdesclen (or 1 * sizeof(struct smb_ace)
> on posix).
>
> However, the chmod branch also invokes build_sec_desc() ->
> copy_sec_desc(), which unconditionally writes the Owner SID at
> pnntsd + sidsoffset and the Group SID at
> pnntsd + sidsoffset + sizeof(struct smb_sid) (2 * 68 = 136 bytes total),
> and set_chmod_dacl() always writes a struct smb_acl header (8 bytes)
> even when the source descriptor has dacloffset == 0. When a security
> descriptor has compact or overlapping Owner/Group SIDs (or
> dacloffset == 0), calling chmod() under-allocates pnntsd and writes past
> the end of the slab buffer.
>
> Reserve sizeof(struct smb_acl) + 2 * sizeof(struct smb_sid) (plus
> sizeof(struct smb_ntsd) on the posix path) in the chmod branch of
> id_mode_to_cifs_acl().
> ...

Applied.

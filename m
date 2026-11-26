Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695329;
	b=UIG8v9zFgm1yHlxHJwU4Anhkr+qYF74/nIMKYS5YFKa7LDHr4suxm2DCWdszSAKVSTC/
	 +ooRI7QypVTiLNaNP4Bamf9zdhT5g6BnZATnlibaM78Unf5/CQwwGiRANpsAMoSZiDaN+
	 5bvMitOoFXASIMksGw0oUHG1nt5G4eLz6UCdf3vuTPikhA30Nze3LAa4+AMOCGfsbxxCd
	 mAbPgJBSga4vnACMNm9jEOGPwC8mhDt7gczj94mnK0ASRhSK6cQscl85ZnSHwsLAaQbYf
	 BFoTuUZRz7P0/90m+KeajIfPlAU7/jDTItIRF7bw80jwAWrSljzGl3sx6eoxJymT32w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695329;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=4zF8x0lb7atkeJIVLSeUgeU27ZSUIQ5+mTd3YG2f5QI=;
	b=mJpd/qyw3deEkF/3WvucIe5n3FzmMjZRwd97Hp8Yllsb3o941U9/iHaX7G+MKUO7rX49
	 6RwwKFNHQMOCJlS/rMw55DZBJe7uwtcFQxn6QRz++TUvmHZyOSYGR5Wdsyy2hCzHlchGX
	 D6PpFJ2mGw/va87yoRXcohyGSWzyHJLAfyDqgZixdqMpfX9Tp53TIvFIQPg79n4LYOBAR
	 nspiEG9VXljxEVMs5xCdA6cowAEtlHfmttLW4FAO9bUSVYfXnNaaa15+GGzW8+1tHNZCT
	 dB26Bpki7i4hMWja+8aLtxABwET05ipjLH1vlBeToOnmDwZ+EUMht1UpW2JiVl41hOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=DvB2oKtd;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504AA606A323;
	Thu, 26 Nov 2026 12:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 504AA606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=DvB2oKtd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4zF8x0lb7atkeJIVLSeUgeU27ZSUIQ5+mTd3YG2f5QI=; b=DvB2oKtdxnzKvl6IahuVOnHB5J
	rkfez8LfGAI2Yt53oOfav0LO+qDAAj6/TiTVCOxNyHTr8Z7gGRgC9A/VmSKdC2EEW20Aaj0Fx+EMF
	snQFQIvxitYtTim60x85U8QNXqEKDmracNIIDsorZZ7OUfGxeO93JL3jO1q1UfU4AFIe316GdeBwF
	LUR7Gj4NZjq8C9bSiQ4kl64MGyoeWDnnUxx+VpxgTVLkuQaBv7UWAeNhIbh+ANtKt0qfoqBOUgAPw
	ydPS/SN/i+6jfkolCPTgGFNg/f/65x5FFEZgJZ87CSJb1aIIFMMYTE6X1Fpq3eMlYXillTYIXmagq
	vxJZlP5w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWYNr-00000000zpO-3QH4;
	Thu, 26 Nov 2026 09:15:27 -0300
Message-ID: <4be99f8a4f81c454f52165a0f5c793a2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: convert DFS target node name from cache
 charset on mount
In-Reply-To: <20261122045841.99012-1-fredric.cover.lkernel@gmail.com>
References: <20261122045841.99012-1-fredric.cover.lkernel@gmail.com>
Date: Thu, 26 Nov 2026 09:15:27 -0300
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

Fredric Cover <fredric.cover.lkernel@gmail.com> writes:

> parse_dfs_target() converts @path_consumed to the mount charset using
> dfs_consumed_to_local(), but @ref->node_name from the DFS referral cache
> is still encoded in UTF-8 (cache_cp).
>
> In dfs_parse_target_referral(), passing @ref->node_name directly to
> cifs_build_devname() and smb3_parse_devname() copies UTF-8 bytes into
> ctx->UNC and ctx->prepath (and mixes encodings when @prepath from
> @full_path is also non-empty). On mounts using a non-UTF-8 iocharset
> such as iso8859-1, subsequent path checks re-encode these strings to
> UTF-16LE using local_nls, corrupting non-ASCII characters on the wire
> and causing initial mount to fail with -ENOENT.
>
> Convert @ref->node_name from cache_cp to ctx->local_nls with
> dfs_cache_local_path() before building the device name so ctx->UNC and
> ctx->prepath stay in the mount charset.
> ...

Applied.

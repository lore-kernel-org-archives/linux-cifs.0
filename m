Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794953910;
	b=ZZvnfnPuFo3rhFr7wJrkYjRn50P6m3LCIl1W5zGok+TWaYwoyDGgGfsVxbDYDtt6F4Qq
	 veuXDMrrQBIFA24Q+LrKOZH6SRr1X8fwJbwrRBT4wt1uqe3QMCT6VJ+gSXng2vfp2bTOT
	 9yXP8DN5TT2oze7FSPsLSqpkm0yKnnV/DE46cSrWJiFTNcN86atKAyZkMArn1khDL+I1a
	 gDW9ZiF6T1CN+aXyOTg7PsmAIY0cyK4n4C/2W4uyOvzeKN6QkC6Ou+nc1i1n2Qgu4NhIe
	 Cub+u7wFSgTrGDKG0VxRrALyGe8eQEFSUUG7DlTRVcCcm+6WhmOtyIiyBDG2vnSEOIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953910;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=m86Ix7fgjexs/PdSW6dmRmPnfgYXk4cK/zNJb2I6OnU=;
	b=v1K+Nnt/v22RuXelzSilCx3hioPAwd4CuJ0IAFqShAh521610Zbk8QvOxsjRKtDRNE1D
	 V4XYHcDDTKWOymbb72f7TrlZm8rPlc72Vh33bMS/7DuMKlVb9jBLBbVU84aGpYzfv9bjB
	 qi0hcxDexJRjy1Z7TWfr2zVLQNQj0pBuGyw4Ogrk+ZA/RGTT8MGFrGgfUNo7zfPJ+x86O
	 vk1KDL4XVMbzPcaAlzVENlManmKIqHcXTgKirU7b2mMLwjzP4Vr1TKH4keBzHaec2wEMq
	 DCitCkthyaO4gArYG+7heGHi9V9clyGCqLYo4NG53z6XkKORftRbiXkwpfyDtW9xXAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=6+N78wTZ;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B33D606A31C;
	Tue, 17 Nov 2026 22:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B33D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=6+N78wTZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m86Ix7fgjexs/PdSW6dmRmPnfgYXk4cK/zNJb2I6OnU=; b=6+N78wTZdX6OMNIcEAIdXwgTf0
	nA8reX19+6HWrE+OlzFi14Gt+Ph3cV/Vtm2ueDzhJB1gO/wKFtuHHkogax5NH9KFKpJSiT+cU6tNu
	OytPnGKHuCprJ55NLPHgbdqOdkyh3S0NfLLbf1RxipGFXPas/xL0LmZiMxVMDLahqmfDC2W+OAcVQ
	j9mMBXfZqzPwkpAGCX1bhmMoUtvKMwqdcX6CVLwhGuB63QuRUqOIi9IaI7xDxSRCdi+XjTOGcgitx
	nyUQX1WUvBPXTy0djBMFIDNktGesYDXw7jUN7t+j0UaBkrJKXKI/DiMAXapM5bWI8sCAdP6jCJ16M
	eSoD5wVg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xTRVT-00000000EAN-1WPL;
	Tue, 17 Nov 2026 19:18:27 -0300
Message-ID: <f61c83e614c1afdcdb20c958474ac055@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: koraynilay <koray.fra@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, Aurelien Aptel <aaptel@suse.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, koraynilay
 <koray.fra@gmail.com>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] cifs: fix times assignments in cifs_posix_to_fattr()
In-Reply-To: <20261116154526.429315-1-koray.fra@gmail.com>
References: <20261116154526.429315-1-koray.fra@gmail.com>
Date: Tue, 17 Nov 2026 19:18:26 -0300
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

koraynilay <koray.fra@gmail.com> writes:

> Currently cifs_posix_to_fattr() wrongly sets SMB's CreationTime to
> fattr->cf_ctime.
>
> Fix this by setting fattr->cf_createtime to SMB's CreationTime and
> fattr->cf_ctime to SMB's ChangeTime, matching the behaviour of
> __dir_info_to_fattr().
> ...

Applied.

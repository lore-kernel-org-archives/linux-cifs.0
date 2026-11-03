Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717546;
	b=WoaJfEuKuXMAaOo2ygAgGYPYZkPwy4V/23dKQPuWGz1ykpo3jauqQTvKD5ghAkZXiOGm
	 G6ji07Hv4Oz0D2YoN3ClZlmrnZNjoLsjzZQWstTYkTuxI52JTM+B3DxK0wJHR8PeQwGGa
	 G8SSs2jjcc3yq5SCXmS9UAe8V6zuAhh/76CSmQmSBv9jI73RDoF0hyekTaup+2rMTVaSV
	 dVljJCkToyb2cv6xvnwig9emzh5SnG/a5gFN+CnO0Rn5ot5n/IVDms/cSWP2OeDxdJD/r
	 XBVyMXsK7nrrMvYlOWCmVwQ1KMi2WSkM6rfYHpH5CkizBOUQfwo9/3dXKemoluFt4oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LrjKfm75hVGdN5FWK5G1yhHfvG92/sfpaw9f0zcNrSw=;
	b=XJuippDQ/00hbMEc9Jwu6adE2w4ZT2oMCWlp+SC9cPHoTUJkTrtiRbU1zDxEdl3e/T5G
	 GI0Q6a7tjLnUKD23qCqR6bWK9wORJfWRCJnE9Sch8LCX0bUdD94JEOft9jmQbDJ/l14aH
	 pNuNM1v3CG5Btp3Kr+2/EzMnkDyQELRU1Glx8tc9mgwAkB8X7mpg5Njj+ZAtDKqQy+3vf
	 pPBKR1cj+alCxmw0F8wuNBwgjL+/j/tuxM83JlIPnDoVbV7dhdwi4zY2q3w2quDHljCLP
	 6c3QUonA2ogMp04hfc5inp3b8XTJCn0PrGY419k6w/J8DmEH+DtKr13Jpvpkgs2pGEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjjw7osZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDA4606BA06;
	Tue,  3 Nov 2026 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjjw7osZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C85A1F0093A;
	Tue,  3 Nov 2026 14:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717546;
	bh=LrjKfm75hVGdN5FWK5G1yhHfvG92/sfpaw9f0zcNrSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjjw7osZ5hwTWIr6a6AiRpO64DK8WGlBnyg87yI+66CWpyujlHVfNsRRtVIZ2Y2n2
	 LSDNR+qfUuI0Hoo9HgioE5F6Tn6Y7kl6M/cuyPtureD5QuVkeo0FQu0dCTibgvr4ah
	 rQltvLEY/hQYdejUhRvlcbemc3n+OR4JtfegQRFnKDIkP8ceqnWKgOoC8Tj5uYVv9t
	 YzRtClxaG63dwkZ+sdJ6SjGwiQ0Xa4a0QSC0Y3loa4dpRfToRZ02dbqa0Xw5KGS9pz
	 xJBFM7kBMku6TudzDnbm8XhYEzbbuQJYiOX+fEZhYiMwJw4ecOjLT+dyiBUgGinzAf
	 xxdltvcNv4HUg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	sfrench@samba.org,
	stfrench@microsoft.com,
	wozizhi@huawei.com,
	pc@manguebit.com,
	lsahlber@redhat.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	glaming@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	apais@microsoft.com,
	rlmenge@gmail.com,
	hargar@linux.microsoft.com,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Subject: Re: [PATCH 6.6.y] smb: client: fix busy dentry warning on unmount after DIO
Date: Tue,  3 Nov 2026 09:51:59 -0500
Message-ID: <2026-11-03-1-daily-reply-0011-re-smb-busy-dentry-dio@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102201410.55089-1-sidchintamaneni@gmail.com>
References: <20261102201410.55089-1-sidchintamaneni@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> commit 75f5c412fa867efa0bf9b646bffe0d912109e84a upstream.
>
> Kernel 6.6 predates the netfs I/O request conversion and instead splits
> I/O across three reference-counted structures that each hold a
> cifsFileInfo reference

This is a hand-written 6.6 adaptation of 75f5c412fa86 ("smb: client: fix busy
dentry warning on unmount after DIO") rather than a cherry-pick, so I need an
ack from a cifs maintainer (Steve French or Paulo Alcantara) on the list before
queueing it. 6.1 also has 340cea84f691 and the same bug; please send a 6.1
variant too.

-- 
Thanks,
Sasha

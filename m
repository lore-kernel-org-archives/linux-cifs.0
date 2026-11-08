Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794182066;
	b=YMOXtUAGebC0tZz8WWzcxtLyLdh2UB2da/7jA1JkpQKhRWAo82qNnwIZW23/CHOJ4mrw
	 ccE3rO/OdDoU7kKczfDp8UIepqVy1pwgZAir+/hO49qfHJuz3CgWPb724PqnlndeU6ypx
	 14wXT7ghdeSrm5BiDEzRtIromwO8rxSgGnhBgg1HyUdt6NPZqgFL+rsn6so9CKRKlDDFa
	 vyPOgw4KuURtVmWH7iXVDIcmA2QpgdIsPdGF5f+XPsEZulVF4ROw9NUysRQQRVxIAY2qT
	 dPmhPQsUAU6jCEeNw2Y42CyLZxjGX3HXT0+E2/ZNxjjKRGklCrbv+0pBFNZApBWowow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794182066;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=AK4oUkv0Gh66vc4SvN/H9zgEwQlvIyoNNPAFtPmNMZI=;
	b=ThiSqK+tYfVE9V8Rc7eqXzeXu/w42joIfhjlPVnMw3YybKT6Z6Etcf09fchNpal2Va+x
	 F28Tz7rTXezJtcF/KIhFXut+ipEeiTR9aHs1TzdPok2HUc96mcMhuRiq9PU/ZTLoDuIPt
	 NHSjbN2eLKkM7IwntfS1eiLsaEWJZpsnseEGPbVALq0JCTtJOyakZvYiaHluRdgC7mycX
	 Sx8pHRYs1OR1yqnVhtk/nf6K9bOQNnrBUitNmR97dsoC6/UJNIDodkawd2VOD+RndvPPh
	 YBGS3IK+coFt8qKqJYv8R5H30C59NtCQotfOZG/2MEsYG0r8KkgBSdJOvtH+7dPeU4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=Gz3ueRG3;
	arc=none smtp.remote-ip=109.224.244.116
Received: from mail-244116.protonmail.ch (mail-244116.protonmail.ch [109.224.244.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1124606A31C
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 23:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1124606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=Gz3ueRG3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1794182064; x=1794441264;
	bh=AK4oUkv0Gh66vc4SvN/H9zgEwQlvIyoNNPAFtPmNMZI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Gz3ueRG3WsJS++uB2IiHLqoK0scGqkWTBYK8FSqr3uSUu9KKw+FsrTK7I7E8KsQ2F
	 Uo0B9e+BA2Ztp9IokxjZC2UkB5qSV3F8aWVai2imTf4HTXzELeBwo1MLIXuBNcyD0L
	 fKU3rJgWiOFpZMxr0t4qGc4fCZw+DuX3AYJ767OphDyUL0JPSc5xOI7D7IHsIx37zS
	 Gg7xGyjHiaVJcQ6seVRHmfvGq2LjoZA0whmuj18hwgmQuGpk45HylORUzhctlyWR2b
	 bBTLpVJdZzDALfiUbU8tpcqIU/zAw0XnV9s4BzE+F0TtQBBT0a36M7y5DQEt9GrJrY
	 84COjVeGVfMgg==
Date: Sun, 08 Nov 2026 23:54:19 +0000
To: Ian Bridges <icb@fastmail.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: linkinjeon@kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksmbd: read request header for compounded CANCEL
Message-ID: <Wu9V4zPWbwJA62vw5GO0eLPkvQbBdN1rL2HpPNmsCywShlx9nYnQXmt2Ya98ZF6JF3G1dytQtcd_ZfR0qcmsr9F34IchL5FwPIeh7S7TByY=@proton.me>
In-Reply-To: <20261108234653.1918767-1-icb@fastmail.org>
References: <0cRgD2yOWbwKBhBZfP0O2ejMhJmcsRk-SQgKJhFyowKBsLZmKYKUb_iKGC1VTDPMUlJrnX1Qpa-CsfMFLwt8hxFqjGhvOLwzEGkO-0JgtvQ=@proton.me> <20261108234653.1918767-1-icb@fastmail.org>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: 49979387b24f3a9ad107fb4af754b07f4c583c43
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ian,

Thanks for testing this and catching the overstatement. The failure is narr=
ower than I described: using the response header loses SMB2_FLAGS_ASYNC_COM=
MAND and selects MessageId lookup, which can still succeed when the CANCEL =
reuses the pending request's MessageId. Your MessageId 0 case demonstrates =
the missed cancellation.

I don't have a supporting MS-SMB2 citation for the claim that CANCEL cannot=
 be compounded. Please disregard that statement and the resulting =E2=80=
=9Conly non-conforming clients=E2=80=9D qualification. Section 3.3.5.16 des=
cribes AsyncId lookup for async CANCEL, and Appendix A's note for 3.2.4.24 =
documents Windows clients setting MessageId to 0 in that case.

Thanks for confirming that reading the request header fixes both forms.

Noah

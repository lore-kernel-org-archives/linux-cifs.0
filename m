Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792712357;
	b=i/AAKW2ENGwMhm18XHFPkUYAHIjGKHCYK6oHy1i2xlDX8nyIBAVAslT8NMzq8aqY+jGv
	 miqZWnj43To12ekg4EVi26Of9ridrQ+TdcpOw6Q1e4rCv3CW12qzAXePoCo2zLcZSxyhS
	 XgTt2HmKzMImMogs9GW6eGbs/42JoijVFHnqKTej0ApKvaKfe8LtHqKzhO8f5dn3tt3c1
	 PWQdChQcabqhT5tbXki8sv7sy6aP1wYUGmW0dV/GuhVrCm6U3Xtbh1121hd+T8XPZxWq7
	 Bc7DbhAxKb2vXKOvofyVanOWlFCSxQ/6F+LApMYTrUMwcujQ/b/Cx9ggFA+0x/+H8vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792712357;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=qK8QBx17xRdgN35eVvNAhLJetwv1UtxZrBtDEZcZ3ks=;
	b=qUKciXoyBggPdTo6dYzVu0+FeSnplKYoTGlEUx31LqHhjBeHKNpi3boMAstVWCZ1FUKt
	 neBbAxvgPec9h+tY5kZmNiDEchl2Rt1rj9CYh+cwR9FJSZPtcKkb0Fs/kqYdsgPnGffvT
	 sbg8PaMw5ivjc7wQCupGpBgRSCynJDpCw0HsIT42gWUDFk9IcWy0AaUgb10JEm66bNPqO
	 uqaAjLxJWlUh1hKT8bljBUTqC659oqHBjqXRvwVT9+qRQTcxx4JAJcdNEmV7L83hJr2qP
	 8MmeQBfcQC1bA5Yuflz8L/G6HkRSlGkJFXentwmIqPO3aj9NHrU+KNEYNZH9RYOhsAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="UGL/sZ7O";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E06606A319;
	Thu, 22 Oct 2026 23:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75E06606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=UGL/sZ7O
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qK8QBx17xRdgN35eVvNAhLJetwv1UtxZrBtDEZcZ3ks=; b=UGL/sZ7OL9GMzOQD27t3m5kL13
	O80LJupv3shbAwmwlZK+/CapGYEB6XpCB4RmQTP35VWo1Uyq0dmvUdNluJWs+EAAbKPBNN5gvPWJP
	A64TNOuQLtqVRrlsa0g5qdUDVxXGRW1pWM23f65i2kg5id3kcYyQ7lCXLHjbCw9JsFYDywg9NgShj
	zM0bAs2/xNkgVTwCFRoHEsGCNKX3+v5aaxGM6nvn3J3bNivt5yi56E673JPVIqvWCJVPqWiCW9XhB
	uCUlhN5thXhsE1iMSWgkCwsd0lz+eQvhTbk0hfP7J58iVeQ55/GPuCuLMwXLvLiRq9Lti9zDtUEdw
	IJdLSivQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xK2NM-000000002li-27hd;
	Thu, 22 Oct 2026 20:39:12 -0300
Message-ID: <7db0730ee15b4a6d441d5177a9dcf3d0@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Abdifatah Suruur <suruurism@gmail.com>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: reject short SESSION_SETUP responses
In-Reply-To: <20261022035314.17801-1-suruurism@gmail.com>
References: <20261022035314.17801-1-suruurism@gmail.com>
Date: Thu, 22 Oct 2026 20:39:12 -0300
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

Abdifatah Suruur <suruurism@gmail.com> writes:

> smb2_check_message() accepts frames shorter than struct smb2_pdu when
> the SMB2 status is non-zero, before the minimum-PDU check added by
> b4694f269e66d. A 64-byte STATUS_MORE_PROCESSING_REQUIRED SESSION_SETUP
> response is therefore accepted even though it cannot contain the
> SecurityBufferOffset and SecurityBufferLength fields.
>
> The parser then reads those fields from stale bytes left in the reused
> receive buffer by an earlier frame. With a long stale
> SecurityBufferLength, decode_ntlmssp_challenge() copies up to about
> 64 KB from beyond the receive object and sends the data back to the
> server in the NTLMv2 AUTHENTICATE target info.
>
> Reject short MPR SESSION_SETUP responses before the short-error path,
> and validate SecurityBufferOffset + SecurityBufferLength against the
> received response length before decoding the challenge.
> ...

Applied.

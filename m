Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443357;
	b=wPt8XDTiBXm8Xh0Y4xc4eCi+dzDwy24RucZdDJJYIP+fpJ8jeGsydbwDkmCbLV/tAEcq
	 LAK4PF4MG+6agQXxaLd3nTJOOVWCKy7Fk/kVtlHVY/puywzEqKwRghV93Ny7tVdYCCOzu
	 C2exv9u2c0+gVk+dEjwQU+/RG5DHukGVva0DQbWbpm4kwiN0QeCj8dPBoTmRqCr7RmGBf
	 ZPcMSnVgZbiApwvbohZBE7AMiHIXVmXE+ZgfgHyDhmUOZ7dBaPIzaRfgVYh66U0kFrMCf
	 R1UsKqQJ7gSzq4MgYhbiuAAvLrGna6h4iyRqpjwWkQItZZMSoG/MZORTAK8TTx2tVpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7sDRE6SWlT0NO2lqp6RUgHMhDmJqqEafxJRXThBQL4g=;
	b=Qx0s7azCgroZidv81VhaI/DhgRF/SVXSLL4ZKEFYBZw7aYYnnWfTdYR7fPOe75CsqVdf
	 sw80IP1BYV7H4cfuILAH5DGfb198jl0LSawEu669OY0TAM7USBDtav04Wc3y1g9to6+Q6
	 0/j5PA2l/qkRqZMew2wCitAneasiYXCyxKMR02SPFajff4Q9eu2XyR2sVntsKYuOBFHt7
	 eWP+hbasYYb8qiBAcUf+1N/8SDS4er1OsKGfgV1ua0H/zlwgFqWd7VM60zj8LJYMXHDRp
	 sNeJustz0L7tcIDy6aay1bn0899bgj4RurjYfDfepZlic/9rk+ChqU6ZWcXO6GydMIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTpmlJAX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D975606A32A;
	Mon, 19 Oct 2026 20:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTpmlJAX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031971F000C5;
	Mon, 19 Oct 2026 20:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792443356;
	bh=7sDRE6SWlT0NO2lqp6RUgHMhDmJqqEafxJRXThBQL4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTpmlJAXeGkHizKyTQvMCcEF/gQYn+4UR7+LQa6gbC2Dp0QObxQfiBo4JgF9IGRvB
	 hcqBC7V77xtkKEPd7VgNt7ZudZZxJwNyCN9R84SUcF7rorkao2tyjWIqzYg7e5m86F
	 XqtRONCryvLzy7+LmMHRQDARuimiYJbqRRWL/10CcImMvORdlOAfLUJZ74fNKlm4se
	 tk+T3oqe37RzLduNrq0eZjotwaucqPGhfoh5i5bJtNXX4oRejr1r25+9Dspg2pn9qs
	 ovU402GJtf+xQe84PugHHo2Ws3pxJx97DvoT9lsbwlK/4iUZEMrq/a6e5WyF7T4syB
	 1bb1JbsOkIg6w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org,
	Jan Koester <jan.koester@gmx.net>
Subject: Re: [7.2.y] ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic file-id lookup
Date: Mon, 19 Oct 2026 16:55:33 -0400
Message-ID: <2026-10-19-1-daily-reply-0007-ksmbd-pipe-transceive-7-2@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1792343439.stable-7.2.ksmbd.jan.koester@gmx.net>
References: <1792343439.stable-7.2.ksmbd.jan.koester@gmx.net>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> please consider this mainline commit for 7.2.y:
>
>   a3bcea7c819a ("ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic file-id lookup")

Queued for 7.2, thanks.

-- 
Thanks,
Sasha

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804624;
	b=iRRvAB+uHzG2GdkpLDyvHvE0HpSrzyASX7kouQKdvo8sUQWiiFZxZLfPRG03ShWQAI8w
	 1MGKYfWYYqpEOH0GwvwBNC2P9smJ4w0hdBVt07IBlYZn7FQWOcUKEkUWJ8wMpFMtuvSpE
	 nKF2qvvUymJjsURtaHdNJQJYvgMGbOueQdV75P1JxfPhxNkDU+sT+Li9VANZAjVBxHiA7
	 cKlMK8lQJfZi7VjXzGpsUS+ABtWfDx30S8lyLYu3clNoU2OjrUjRlk/zNksFXA2PsXvO8
	 OqTNHtIksjJ8l8mjAUUaJSqJBwU/wHpPm3p4jN1uPpDu3ZmKSZc/Myc5h9Cs9xKQr3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=9/vazsC/JBTlTjTyU9GwdIXEd9JirapQYQw/W6WaX5E=;
	b=humGhqRS84nJaEYVgBW+4QG3yyl4k3uREvpbkq8d2VJeauwCfbkg+Hhf1Rz9jqxkq7dB
	 0dLo+IjwNUn3R1AmZhjyTmhMs2tfKZpMH3ic4xvwYmcRvRzBB96WTpQ0Ad5Fv94ccEDc2
	 wn/oyuLHC5+XaBwG4gpOOQnsEGUrd4SO7ujGTtL0yd540C9pYDByd3Nbgqglir0+0n24H
	 M02y5Lf+97TezdUleRQVtqjzUzDI/0BIAz1A4e0N8sRVkdVBftVUtCqia1Cp+msHpg/dP
	 6vzfMFk6U5YBISmnYSK9I2/RJ5HrOaQKTdU5GCtQIKAI/ccgjmyPeddaj/FWM8zDsUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d3iTZDQD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C89E606A33D;
	Wed,  4 Nov 2026 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d3iTZDQD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836731F00919;
	Wed,  4 Nov 2026 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804624;
	bh=9/vazsC/JBTlTjTyU9GwdIXEd9JirapQYQw/W6WaX5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3iTZDQDaoFx4WpdNSDcV12oWzOYvCTGR1XGz1eFXVsZIVA0UBZtIXJsPfRHr/5IZ
	 Vx8GPvb9RlRwmQOSHaq27R9qttzBjpHDEqpc0xDuXFN9vIqPhzsLVtsdKuFs/TaM4m
	 OuoXCchQQtZaHIUxLV09Ep9Tqgj6jWpNs8c9+0ZNIVMWWzzxNpTW22wkGe1fl/5zO1
	 QzjdI/bgKGui4tIBQZFoqZWCrqDF13BnmzLy/jKZ8ILtSP9oIuUDc5gkPrQOILm9BM
	 T1wNvED6MSBmcqE1EeCFHXXHQaYQa9QNnulz4topj0Kdd6V2e6E7ZooVewgiKJqW+i
	 qyvYBk63pS1oA==
From: Sasha Levin <sashal@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y] ksmbd: fix breaking_cnt leak on early return in oplock_break()
Date: Wed,  4 Nov 2026 10:03:24 -0500
Message-ID: <2026-11-04-1-daily-reply-0015-re-ksmbd-breaking-cnt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAKYAXd__FvF-bCzzq_JHFqCF===_qrVZC8RLjrp4nh1s8sXq_Q@mail.gmail.com>
References: <CAKYAXd__FvF-bCzzq_JHFqCF===_qrVZC8RLjrp4nh1s8sXq_Q@mail.gmail.com>
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

On 2026-11-04, Namjae Jeon <linkinjeon@kernel.org> wrote:
> I agree this

Thanks Namjae. Queued for 6.18, 6.12 and 6.6.

-- 
Thanks,
Sasha

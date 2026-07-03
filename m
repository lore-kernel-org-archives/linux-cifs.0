Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B5632938D;
	Fri,  3 Jul 2026 19:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783106801; cv=none; b=IffEWF5tDDi5dQnVFWW9imKpFJyn3376GHVG1P4HLwFLpIBd0mKtA64ezFHxNS5iaO9bEtu/xKg2UjN+PEMJlOTC4jUanDvIs2j2Xlz4Vm6YgTJX74r2s9MwFXavJhGBgqubXpyfj+9kRhvjhbbwe7cE6/ABgG0+pJvpwllwTFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783106801; c=relaxed/simple;
	bh=ydqalqyQh+mKDoFmmN1exhADpgn5t7Yf2pyIeu3wseA=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mll93wMCNqsnoCQrz8mGPqbjauJYyByV46y+Vw83IvZr0zCA82XoFGXO4I7AhFZTgg53sQs1r2SvODi70XRQc7J6Av03gPvPOH0ztx+oYNLr5RMR+OK9cwLDsCNxes7+BOgJ86mz1IDf9ZJAtncOHSmyRygJRddz5vZoLoSgURQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=L7xmfduJ; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="L7xmfduJ"
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 5DF318441E;
	Fri, 03 Jul 2026 21:26:36 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id Y6F9XYlPl9xX; Fri,  3 Jul 2026 21:26:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1783106795; bh=ydqalqyQh+mKDoFmmN1exhADpgn5t7Yf2pyIeu3wseA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=L7xmfduJCedJaCJRl4pnGrucoP/2NDrpklA11mGW7vWOcmm4Rxo5gXH3zAr06BCmB
	 j6n/3vSUx5VtmDShrBXTf0niOYXZwl/KWlSE3y3ecEHCKLEz3nuoN21oA1g/CyEXa6
	 ZxWVwJWHzqks/pNhCR2LgXV6jgrMqlhl9xAI8LV43kd4YFTflbel+qpfWnRuQndP2Y
	 GBnrWeeojfI1VpH7Blm780/VSF7vIqJfUnVl9w8CV9WS5d9dHMr0QYxyiNWpKz5uGD
	 TjgHTeCAltAITkSbZtmt2pv4dGxzxuQj4ao2D/KllmZglCOZ90xbv0bzRS1Pgd8oSv
	 G/X09S9i3fJfw==
Date: Fri, 03 Jul 2026 15:26:32 -0400
Message-ID: <66a2f0233be32a443d8c6ed2eb662f7e@disroot.org>
From: James Montgomery <james_montgomery@disroot.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksmbd: defer destroy_previous_session() until after NTLM authentication
In-Reply-To: <CAKYAXd-t2Oz4ZM8BWkJ7uKciaGo=akTMPUEFy2_Z3cx0abHptQ@mail.gmail.com>
References: <20260702155449.3639773-1-james_montgomery@disroot.org> <CAKYAXd-t2Oz4ZM8BWkJ7uKciaGo=akTMPUEFy2_Z3cx0abHptQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

On Fri, 3 Jul 2026, Namjae Jeon wrote:
> Is there any specific reason for not moving this line together?

No, there is no specific reason. You are right. I'll send a v2 with
both the assignment and the condition moved together after auth.

Thanks for the review.

James

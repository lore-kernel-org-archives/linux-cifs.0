Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE31E10E3;
	Fri, 26 Sep 2025 12:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758889727; cv=none; b=mdcStlNB5QERlHd+o6Pgtr1C7alqt0764djsa/yBWSCwdHLOdWeNS2L3JmtIGuV2r5q/mG/IP8AETxZvLZXIHl3orlWEYqZI2Ja35sARUbkSR4oef5+YNLsLi5SC95UYb/Uucrnp8dHRWJIbWiG4ucE7LjeIyULN/Ec+QaSAIFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758889727; c=relaxed/simple;
	bh=130lTYzVkWOf+yr91kO3uJNKLG7fQ735eKBcCo7c5Bo=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=IVMu/ExAjWREbEi6ZA7djbh4LAGxUCajHmdt3qxFDOnxL3y363btVhsptEAO2H4X6HytWKbjS5bz7iWFJZRbQHiFqcrFF4SgFqc4HIm0ASSjMMwaW0MIEHex5doGemGizkNVUPSSBRTA1wCvV7QWrgGKWPbzZS/7fzOWCVKXLpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=qdv6JSjy; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="qdv6JSjy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1758889694; x=1759494494; i=markus.elfring@web.de;
	bh=RkSM5jHQgytNDJhP80powPSD+JzLffRHHm7/yulvEh8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qdv6JSjynfBzC3H2lqB5pVLoLNQxrEvskVikLBYm9SCEhN/Wfyu7OIcH9j/D1AG4
	 ujrViFnd9/J4bxE9zgJHWxt/BZx6enaMjEnIgeo/ezmPSms/BE8MmCyGKLlhhULWw
	 DxeHrk8RsOKJP3oVx3130uK5nV5Jz5ap+MiOvhdyFeoGyEPShBeDLSV5EYOAOq+Tk
	 lwXQ8cfREAOzHoQPPRHInGjhUixjYk6KtpbmBb5HYupnRHQ+9pYpSDcRgUdg2qCJJ
	 vbNoWtqtFcC4nzRQep18yqQGguWb8LI0tBxi0mxvWqv0W0tj5LRSvDk/Rhj3tXI7a
	 ESwQIaQGKoOWaRFhLQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.192]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MOm0r-1uh2IL3OTH-00UFND; Fri, 26
 Sep 2025 14:28:14 +0200
Message-ID: <7ef2a9a1-c1c6-42be-bfa8-65ce6a0a33d6@web.de>
Date: Fri, 26 Sep 2025 14:28:04 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Matvey Kovalev <matvey.kovalev@ispras.ru>, linux-cifs@vger.kernel.org,
 lvc-project@linuxtesting.org, Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
References: <20250925121255.1407-1-matvey.kovalev@ispras.ru>
Subject: Re: [PATCH] fix error code overwriting in smb2_get_info_filesystem()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250925121255.1407-1-matvey.kovalev@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3NoP5qS2DoSSiEAGjBpIXa23AkPk5aHntax8EL2g8oLgs2dmBrZ
 TriNaORa8JFqvAUbAefnMZvW40ERUG+kHcZr/TLKnDFH3vBloMuCcB3q2kvrpeRsIRZH3sq
 +w+tBvAeQaU3FrAdvjn4ATmCeJn5ZOWkGvdrdMigUt/R7kxvtPuLOcEpEqRDfWLYvJPiRtz
 Qh4kmA6FZvjQKVLfFVJqw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:MPwE4kiH9JY=;+BwRmyOO+k3334db9VDqdiE8pyd
 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
 Wj+MLRjFXgcfFBVZAlpx8rS5RmT/Xkoq1Ek=

=E2=80=A6
> ++ b/fs/smb/server/smb2pdu.c
> @@ -5628,7 +5628,8 @@ static int smb2_get_info_filesystem(struct ksmbd_w=
ork *work,
> =20
>  		if (!work->tcon->posix_extensions) {
>  			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
> -			rc =3D -EOPNOTSUPP;
> +			path_put(&path);
> +			return -EOPNOTSUPP;
>  		} else {
>  			info =3D (struct filesystem_posix_info *)(rsp->Buffer);
>  			info->OptimalTransferSize =3D cpu_to_le32(stfs.f_bsize);
=E2=80=A6

How do you think about to avoid duplicate source code another bit?
https://elixir.bootlin.com/linux/v6.17-rc7/source/fs/smb/server/smb2pdu.c#=
L5437-L5653
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.17-rc7#n532

Would you like to choose a more appropriate subsystem specification?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.17-rc7#n646

Regards,
Markus

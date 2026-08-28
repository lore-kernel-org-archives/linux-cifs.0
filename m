Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B9527466A
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787933829; cv=none; b=hv1bdnwVF8Z6HIvgUwvLVcgerbqrrc1iTNrGhr8gcR6fBcf3yuSUxet1MYNibNUWAFtFMtPqUI4Yu4HnFT7WVH2zGJyV2DwAZm5mzYsGZPNVlHWiFwxgheSEPNHySq4T/Stb1CRs8fhyj6cLBoduqrRw7K5FQWV/OhlvUa3O6Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787933829; c=relaxed/simple;
	bh=Nh1zOZ4rMtBskj60/Ea57iYsw/WbxlC0Hdk4OcEXXRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YKazBsXNfWwndzqojjvtarnbxemPogvKMMp477wkIdgHGAJsxSKcJuHPxvPWuGOqlmuU89is+04OcKmjDQV6MlM0RYZb1XrqMdf4GyRMFPZSomNV8m3hu69txIXlYMBY/7RDSEOucP/hHd9pHKzJjwVqNGPnIsmirYczu8N8G1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXPiT2+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXPiT2+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ECF1F000E9
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 16:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787933828;
	bh=tHgdtXBbvJTF6KXsPTkqaN0c+COf6GNFi5TDtsEOH5o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZXPiT2+BnAw4OdNLUfNfr/rGhMH+lzrgmUUwZooSLr4uS5rqMmP2xAbBEMzIUw6WX
	 g8MdHMHynyRnYwYkSeP83m01tsXi138mJDaASlzzp0JCS6XorY21e/4OxEgpi05zun
	 n6ZRsXywBTPlr9FFkhn93AzlxwNr0HydY472N5gzjm7anx9S+9+gouvNuo/Cw3iKUq
	 aPuwqMbszvgtz8/25epqN2V0B2w8CeqAp7SdQcTivulEtaPtdwE1dvkTi224OVFEro
	 y8D+Jyv8nPHJQAqp/mwUCtWahP+7njQaL+rYl5PrzzFcw9Svu/WR3SZFWQNSoqOsvE
	 qmNJxycWdX7ng==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1712a04ddaso170204666b.2
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 09:17:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RojhT6EK6YO2Bv9w4DyXL2spztaabUUv/yJpvzmr1Ff1x8wvum7+g2jI+Gfr9ftLh2O7eBUfaXUKm6t@vger.kernel.org
X-Gm-Message-State: AFuF++k/gIYHGIjvxiLZzYnaH/PTPdUkhc1Wm1k9uxRb7KKXRVnetW59
	vv+w5IB6IjRnbmaw7O2jajXJZZf73SAmGcfiPuIyXdyTXZefEqLzb+WOVqzMnK8KQBlLrpoxfR0
	br9AIILwArwYYXoaWdaRiOsNkZT3asns=
X-Received: by 2002:a17:907:c78f:b0:c24:e0dc:8b66 with SMTP id
 a640c23a62f3a-c2556c7d3a5mr641933166b.6.1787933826843; Fri, 28 Aug 2026
 09:17:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825135108.716663-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260825135108.716663-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Aug 2026 01:16:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd--bjiEic5WCTy2T-C7A7Jo59quAf=KX=Zx3ra2GQJCWg@mail.gmail.com>
X-Gm-Features: AcwNN1VoK-MwmLV8v6Zk4RO25A5BIU_ePNsWIIX6pCtJoAtXpDXqWqy1xde5hk4
Message-ID: <CAKYAXd--bjiEic5WCTy2T-C7A7Jo59quAf=KX=Zx3ra2GQJCWg@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 10:51=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> v4->v5: Rebased on ksmbd-for-next branch.
>
> v4: https://lore.kernel.org/linux-cifs/20260809161916.1071530-1-chenxiaos=
ong@chenxiaosong.com/
>
> ChenXiaoSong (1):
>   smb/server: support compound fid in notify requests
>
> Gael Blivet (2):
>   ksmbd: temporarily remove interim-work change notify handling
>   ksmbd: refactor smb2_notify() to a blocking wait
The smbtorture failure was caused by 0002 patch removing the signing
path in  smb2_send_notify_cancelled(). I combined patches 0002, 0003
and the signing path into a single patch.
And I will apply them to #ksmbd-for-next.
Thanks!

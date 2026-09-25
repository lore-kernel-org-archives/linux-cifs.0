Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F06509F1C
	for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 23:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790379964; cv=none; b=WdYp2XS5rkGzNRIt4QgihkmtCNj3fL5vHM8wiQlvk0bTNKN4xwmMP1bFI4DipXoIAzU84nvtI1p7O4yLWZWfXzTP3aicXBTCPkqgpuGH1VWVs+xHHCnuPL3OHQpW4LPy1mMzrO//qzSiV7YYVI2RzJV55S6EoMkD1D+BPDG8EjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790379964; c=relaxed/simple;
	bh=69YNS8V9Ulu+XXzojonQuI5ph2CPTnIrShqG8ggwwCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h4m0o8Y4zF7pBZCy57axqUdtR6fcd/BEcj5dZw/K6gwKYJzOQqNnKsvWAxLAZjGttFbIFWqflgzl8MT/BqTllciyVtWLCocjL2JTP9mnl1BBDs/EgAMAlAFwi8QMSI5+O1oVs/3BMoS4+gwPVxFLnwe+gL6sDHapHTzZeKblr+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSnp5oHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSnp5oHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746E41F00899
	for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 23:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790379959;
	bh=69YNS8V9Ulu+XXzojonQuI5ph2CPTnIrShqG8ggwwCY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MSnp5oHGLiCncBzfTvoi+PrVa/H3fixOBHTV2NnYS+ZdhVO3/2K1yICXUpKTeilR6
	 jg+WK8uk947L0ZZWWV0iJw2dRxKIF2DAAoMlFAUefAh1I8G9KXsOJUmukv8Mq+5wj8
	 6nARt6PT48sMqEk/2QKWCWkNde/M2MylnelACWyVb4O6gMVqcZiiq0xci5GXs3PbKv
	 bFNReFkGG6u+jh1mOW/7vlY8NkSYZJXKa86fz1Mbn+fb/UVNGnW9mK6X8TspDe8Zg3
	 qZ1DqFUuMqTKDIdOKpClTjEEF+kD++ox9v2IyqeyJpAxyzneVUg2+MyUFDwq5B0mNC
	 bRFwk8WE+aPZw==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa663bfso226654566b.1
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 16:45:59 -0700 (PDT)
X-Gm-Message-State: AFuF++k0CunipfAj43W5KHE2U5L3wQmXpYcg80/qrNlPLveci+Q2eL5Y
	cr91FJuT4nCs1r9t3EGwexfst/6nkT/k4470GjlFmhFTAZT2fJPiqeqw04vOqPgVuduZbDN7Qxy
	+XYifuVNKdDoEZBqHcFg8UHIfXkSuINI=
X-Received: by 2002:a17:907:3e8c:b0:c2a:fcf5:c6bb with SMTP id
 a640c23a62f3a-c2afcf5f1e2mr157964766b.23.1790379958067; Fri, 25 Sep 2026
 16:45:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260925174623.1640482-1-zhangdairui@gmail.com>
In-Reply-To: <20260925174623.1640482-1-zhangdairui@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 26 Sep 2026 08:45:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-3Q3WboGm=s=t-BYf_t6HgiGLTm8CboLNUsEU1VvBzMA@mail.gmail.com>
X-Gm-Features: AclHuK8Mc9Hb1QgRf41NaBT9Tr28BE3HhBUteUgncKn8I01PWhQFNqNIQIFF43o
Message-ID: <CAKYAXd-3Q3WboGm=s=t-BYf_t6HgiGLTm8CboLNUsEU1VvBzMA@mail.gmail.com>
Subject: Re: [BUG] ksmbd: no check that transform SessionId matches inner one
 on encrypted requests
To: Dairui Zhang <zhangdairui@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"

> Suggested fix: compare the transform SessionId with the inner one
> after decryption and drop the connection on mismatch. Happy to send
> a patch if that approach sounds right.
Thanks for the detailed report. Please send the patch to the mailing
list and me.

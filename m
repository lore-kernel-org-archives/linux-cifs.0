Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BCC3D3CEE
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 05:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787030019; cv=none; b=jY6EjKh1oGV2LqMnW9VPChoPKGd5OI0xlZ5KGlTIJs+cmIrsj3fw+Q+vdyw5SxySibl6yzweP+s2p4OyEeF0prg7PUFu6mWS1UnYjcydODS6R5q7+pnG9mUOQGlgVmDrj7hsak2uC8KBDDCnatbkDAsB2pY0BVAZf8DUrEF52Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787030019; c=relaxed/simple;
	bh=m/PswvrX6yCFgTR3/ktQX2F2fJlVuzG666sVyTGB+Ks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dOMKk1bwnzu+8MkIpfeuJUtJ5wyZcs6yAmHpnB5Djx0R+LseocKSJ4eShXu7oeyyoA/abPbHTIyGXCNvi9PZrKqbAxWNOd+spRewe/JtXdzftd9KEbLqBoJXAoYpA3LjTuzTEIEiBiYGSSQeKqKttRzIry0rTCxZDfdJtNqwwiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aErdUPkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aErdUPkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F9B1F00A3F
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 05:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787030017;
	bh=dsp+QEvgPL2qcouhQ1HBN8PidMnZdY5qUdMPLSjE3lA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aErdUPkR9gej7nnaxYShlF/k0Rrom1nf586+Ak+cDuk/0qzSGY2TqIhdWymc0eLK2
	 vfO315UFuXu8BhqL5t0gYAebGdICQ6Rdv2vI2NKjk3aWemU8/SKTAY2hSUNq9du7gL
	 uj7Rtn73a4UefQR4r3RSrZtbczU8+e+3SqNNJ5vQARbjX0+MNR4YLihgEGxILzGzwK
	 LNhCIidTGJA+Krh2VHfv9xCG8dVKFkBiTHIE+KQQecU3W9j8S0g6IjcvCI1VQWtstY
	 B5sjgLhD0AsmSQh+l7f1yTu/razoxto2oUWLMdzi52DeUUGoTlUaaAboiIz88FMCLu
	 XfPdTAN6IwBcg==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c169ae1cb26so112448966b.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 22:13:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rodq6pMwDaBD9SlGPO10fPUXT0NODfDNrWJJNWeSJlUGNRbxGSThdpLjIlfCKURujscwblGUYuOoGlR@vger.kernel.org
X-Gm-Message-State: AOJu0Yz56/xGqmMsy4XoCXjURitK9K02U627FDVAdigJTj3dVL6BXTfL
	zInlgTS+Xw6VZNDSG0oVJsGDTV6nrYt6UrhMcPbrvVk4/m4Rhijny8RaHiXEecYR6bXdjCVbcvG
	iXED48okN/UPInenYdznH1ZY2k3wp7hU=
X-Received: by 2002:a17:907:94d3:b0:c21:7c98:d9ec with SMTP id
 a640c23a62f3a-c218b06cae2mr203493466b.5.1787030016434; Mon, 17 Aug 2026
 22:13:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1786427463.git.tanze@kylinos.cn>
In-Reply-To: <cover.1786427463.git.tanze@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 14:13:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_RoA55XJt1H8Ezzhaq8LE_P8YYL48SRfnRNGJUY_9ohw@mail.gmail.com>
X-Gm-Features: AcwNN1W6DHSCg6smmRuxElzz4qOP4AsYMpDH5jMyU_oBr_5O6zxXA1ydueugD28
Message-ID: <CAKYAXd_RoA55XJt1H8Ezzhaq8LE_P8YYL48SRfnRNGJUY_9ohw@mail.gmail.com>
Subject: Re: [PATCH 0/3] smb/client: Fix some issues
To: Ze Tan <tanze@kylinos.cn>
Cc: sfrench@samba.org, ronniesahlberg@gmail.com, pc@manguebit.org, 
	tom@talpey.comm, chenxiaosong@chenxiaosong.com, hehuiwen@kylinos.cn, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 3:01=E2=80=AFPM Ze Tan <tanze@kylinos.cn> wrote:
>
> Based on the analysis from Sashiko, fix some issues.
>
> Ze Tan (3):
>   smb/client: mark missing nlink values as unknown
>   smb/client: preserve open info type across compound queries
>   smb/client: decode reparse metadata using its payload type
Will apply this patch-set to #for-next.
Thanks!

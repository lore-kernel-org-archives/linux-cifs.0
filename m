Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ECE7464
	for <linux-cifs@vger.kernel.org>; Tue, 24 Dec 2024 00:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735001154; cv=none; b=u3m2ScbkKI+F6jTcyC5D4KlXATtBco/PozAgRj6wAnuIfSMqMzX5XZtsusG4BJLHaLE5LEr803gqbH/SNtyCj/ven7mTamBcavcX1zUXiuaSBiaIWAJ3Xlu2pumMXY+4kWiilpkVqLQyYePNbB9+5sawMCYXg7EyUcsfh3PvEN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735001154; c=relaxed/simple;
	bh=Z9kvEzUnUTosFbvJFpJ38OykebJS9/HolqEUeAfOuag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MIg64fy61jtzAE9otR8bMgyNXe71gUMbOVn786Bymo+LTHrXHJ75EJfAP/ZJmREY63AhqM/P2f5FrP1Q/u04CWfaXNYKK13F9HHkQGbnlHMjskuD2yvDbF6PrjaTan5DDd1+yYCz1eZaXOHy3kYX8Xq/2G7wMooCsCASMlELYdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVpLXkaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVpLXkaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946CDC4CED6
	for <linux-cifs@vger.kernel.org>; Tue, 24 Dec 2024 00:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735001153;
	bh=Z9kvEzUnUTosFbvJFpJ38OykebJS9/HolqEUeAfOuag=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZVpLXkaCn8qIwoL9F578lLKEX/QCY0fpNlrv2XCq+F5CFDW8iXf8Fot+RtI2FbunQ
	 6zr2Z2OrkVRDU8yFurVkMYXhU2mTWy7b5/pybf4shj+pQsKV11BWXb88K/SUK9ek7J
	 oxpqzCCdc/+IA7iJ0m1FL5N58K3QtxlgpjzjhFMnXRMXaWkZ0pyJ96BVPtxDNaMcTV
	 i4ZuDjU+hFSl3pzGicAlkcr8rYBXeNoRji1CafbQAEX/DE1gBZl2Uach6XQgIo72Xb
	 xwUNG0XQ3skaDoc2/40ZR+LrkbLNvtniwWv3hKb2NEIjrTl6qNImMdXzf1mNnm1nLg
	 Bd3bi3DhQzQJg==
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3eb8bdcac2eso866281b6e.0
        for <linux-cifs@vger.kernel.org>; Mon, 23 Dec 2024 16:45:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWuhl1SHuLrqv1C9xzcjFJ/gr8svHnVmVCmCJcTtkzgCPUIm+7K0gi4MSIULjikzC5uNtMU3I/Nxwy6@vger.kernel.org
X-Gm-Message-State: AOJu0YxP6xsUMNcPrBMEEO90b6k/XrFGzOwqUMByyhIbB5zT3z/f6xD2
	wC8XwiF4NSa77AjPMvZFOvJGzjmTIRPsaPQmx9enQc+ejpA2hRprIxB/48cKBHP4iPcH2GahiEw
	bPZOb3kpgiav7DT9IwYJKyz1Re8M=
X-Google-Smtp-Source: AGHT+IHPYyuCKt0VgwOB/Q1nmpULghs96mVcfx1HwoZcH/ITT4ro9WuuQvw+f9SBMZpClOOfNch3stFTbyzpc/pcWro=
X-Received: by 2002:a05:6808:2515:b0:3ea:6b4f:f545 with SMTP id
 5614622812f47-3ed89066f86mr9323765b6e.28.1735001152930; Mon, 23 Dec 2024
 16:45:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241223153050.332-1-liangwentao@iscas.ac.cn>
In-Reply-To: <20241223153050.332-1-liangwentao@iscas.ac.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 24 Dec 2024 09:45:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd96GcEVwrt-A-6ui-kbZo=K3owJTBPnBuVs_U_LgN2Dsg@mail.gmail.com>
Message-ID: <CAKYAXd96GcEVwrt-A-6ui-kbZo=K3owJTBPnBuVs_U_LgN2Dsg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix a missing return value check bug
To: Wentao Liang <liangwentao@iscas.ac.cn>
Cc: stfrench@microsoft.com, chenxiaosong@kylinos.cn, thorsten.blum@linux.dev, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 24, 2024 at 12:37=E2=80=AFAM Wentao Liang <liangwentao@iscas.ac=
.cn> wrote:
>
> In the smb2_send_interim_resp(), if ksmbd_alloc_work_struct()
> fails to allocate a node, it returns a NULL pointer to the
> in_work pointer. This can lead to an illegal memory write of
> in_work->response_buf when allocate_interim_rsp_buf() attempts
> to perform a kzalloc() on it.
>
> To address this issue, incorporating a check for the return
> value of ksmbd_alloc_work_struct() ensures that the function
> returns immediately upon allocation failure, thereby preventing
> the aforementioned illegal memory access.
>
> Fixes: 041bba4414cd ("ksmbd: fix wrong interim response on compound")
> Signed-off-by: Wentao Liang <liangwentao@iscas.ac.cn>
Applied it to #ksmbd-for-next-next.
Thanks!

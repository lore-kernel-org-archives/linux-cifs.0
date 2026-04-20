Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D42033F8BC
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 01:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776648489; cv=none; b=ckC2l8fE6gMnN2hgFm5U0TkC6VaRu7M5z4USZjEpR+QMs1GUiL1hqhPh2b4zXyotcq7g7ZR7wJ11sPXa8n3nlJYsLnu0zu4Ml7+PrOWuO3p4i5mBMDf+J2ou7Zm1vmyotBhmREQJDYqkwbNdxk2E56FM5F7b/efbRNaAj0w3NVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776648489; c=relaxed/simple;
	bh=EK3HjWXXUIRe45hghDYV/HoK8qEGXWdkXO3I98Ph0PQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uVI0z+xZRv+QcxSO9Z7KvkupqI+9jrLMv0zavAbfkE6O6a3zPEezTuBelHGY0d5nWMN1WWlW0TMFA5bi1WF2Eo/2aBbMdK1uhdYzrlcX76CVYYpWLsoM39VxCGXWkq1lGDsJ/ami/4dfEIyf/XspCDBsg/vhQnRMKpaGSJ0GnpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NqLfZYVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NqLfZYVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3483C2BCB7
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 01:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776648488;
	bh=EK3HjWXXUIRe45hghDYV/HoK8qEGXWdkXO3I98Ph0PQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NqLfZYVW9gtUfJ0D5LjHLL/+Net8VHuixnhSVd3xXVyBMArJItT25rLPo7AuMQk90
	 p6AywLuupjYTXLI9Az64MFDYxzeX08oIt7fgsWnmSKE7TaFr9T2Opli+8DDyrG5IoT
	 7iZ1YjVtbHCfuo79vjPCIkAcQy472v6CGaYzxzJjpV2IaQkFwwWOmHOXsawH4AR4zR
	 tKzoXM1prT1LGA0PViIt2h3HJSJx8NSmBaNydNxyuY+ro54vPDIdVBUAJUkYL7RSNk
	 ORSmeWpqoCMCxHDxfAMrph7v+zhSGdKOKSmMefmRB2bVfkhToIUI2aKRXhW+HHtt5P
	 E6ROQ3yEaI9mA==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67179ed133dso2666324a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 18:28:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+mY6Lao86lW9pwIniJ1NEFr2SSE1wV3ovgQ5C7cV1HnxfWK6SinQ4J39gnzVdXQmNgyp3I21c1YPnG@vger.kernel.org
X-Gm-Message-State: AOJu0Yzeb7WdbREPE6PIu9DbfN0YJHv2RBeWIsqd/RutEBZFQD3Rx8pY
	BfFzUHUTaYr9yaz/58mVo3dXxm0DmDXwDoqcQ8ShpipYHe/GoXxd2n8dsET8cJJj18Bawq9vwhF
	h5JV3/KhQm1UHK2O1+1oiKMa13ag1JyQ=
X-Received: by 2002:a05:6402:159a:b0:672:7298:31a2 with SMTP id
 4fb4d7f45d1cf-672bfd9cb4emr4353718a12.7.1776648487222; Sun, 19 Apr 2026
 18:28:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260419110255.2477785-1-charsyam@gmail.com> <20260419110255.2477785-2-charsyam@gmail.com>
In-Reply-To: <20260419110255.2477785-2-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Apr 2026 10:27:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_e4r-Hf+a3Q80irKNXdXX2dxpPdLt3bCxENs4ry08mYA@mail.gmail.com>
X-Gm-Features: AQROBzBjl6EpuMtpkElBIkA3kAQJnz4UrV19FzZYmsS5rPHld2tWmmcivqtJvBk
Message-ID: <CAKYAXd_e4r-Hf+a3Q80irKNXdXX2dxpPdLt3bCxENs4ry08mYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 8:03=E2=80=AFPM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> When per-session tree_conn_ida was converted from a dynamically
> allocated ksmbd_ida to an embedded struct ida, ksmbd_ida_free() was
> removed from ksmbd_session_destroy() but no matching ida_destroy()
> was added.  The session is therefore freed with the IDA's backing
> xarray still intact.
>
> The kernel IDA API expects ida_init() and ida_destroy() to be paired
> over an object's lifetime, so add the missing cleanup before the
> enclosing session is freed.
>
> Also move ida_init() to right after the session is allocated so that
> it is always paired with the destroy call even on the early error
> paths of __session_create() (ksmbd_init_file_table() or
> __init_smb2_session() failures), both of which jump to the error
> label and invoke ksmbd_session_destroy() on a partially initialised
> session.
>
> No leak has been observed in testing; this is a pairing fix to match
> the IDA lifetime rules, not a response to a reproduced regression.
>
> Fixes: d40012a83f87 ("cifsd: declare ida statically")
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!

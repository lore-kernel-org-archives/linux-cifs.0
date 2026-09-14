Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C88476041
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 13:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393759; cv=none; b=mEwtmISsj6GZLkP1PuEoy7DNfICY1jbomVsLQbJbHtyl+6j9m/ZAqYwpsxld0ONIJD32b8al/xBclt+PNkTBuyHFt2AX8MIG+OX42ZdcmUeP+OUv9DwsYVOp15PUth7dIX3eV91rWCYDPZyfYt6/I5Y39QOHCnGR598SqpMa348=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393759; c=relaxed/simple;
	bh=RCBibcaqUGZ8VWfRPHX+5XFI3ZbW1XMsDk6BGSQkSk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VM1cXXvCCaKlorsTPJHjTxJD5vUG86OToq2lTb08KA0KrJ/FzkJPoGSZW6MDxRSNB5uPwLVLyfWiLIOvkwcDOQ3vGbWXnKmYL2a4REo0jsi+TqK+fBWVIpaKjnXoERlGSOw6lhhBbpLBCsoL6oqLBtR/E2kquK1ZXRs/++lzGFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fT9+2EjP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fT9+2EjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07101F00898
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 13:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789393756;
	bh=RCBibcaqUGZ8VWfRPHX+5XFI3ZbW1XMsDk6BGSQkSk8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fT9+2EjPAOEUpZ01G4dpFl5Uv29lohUOzG82o6eEPgYbJnBOzr3lVeIP1K6gb8EHy
	 yrCmqAJM+iTTYnuZYA6dUDDHjn951yY4H4N/Ah77AdPCAHwg7Jf+0P1cqrlLCDwQy+
	 T1cYwC7WvZz8j1GltkKrabIIvO8W2rV84f/UqE0tcUy+3qNaUuG9fx3JSiIFJjp96A
	 gGPjxu+HBGMptfb1zfycjEWqi6Qjv9J2s9IJSvuOIVbjHcSP8VFkT3azOg7zv9kVR3
	 njKIFcFbFUmdDmPEjVHeTanuPkLCV+johrfACLdtV2BbW9RdcSLtPkaonvQdIHj/WS
	 8RriMbkYgZydw==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2953a01240so313788666b.0
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 06:49:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxngncxi+X0Zw0w2lX14KjXqfpJIVTcxw4OxLF2+jrVK8fLM1WLCDHjEP3RjXMgfO7DSeSdVRh+Rrsu@vger.kernel.org
X-Gm-Message-State: AFuF++l4HDYDSFNGcYo9V3Pkg+SP/C+L9Ai438VjKrUAmYyWYWbxpYrF
	4IohLD/A2ASy+72oLHiqByWCyGbX1k+J6BMi50gd7I0T0sq1dSVdK8LllhFvWzt0jIexswMbeuf
	R6QJgwivsaJhWwZcBdCmOwH6Kd0zh1YU=
X-Received: by 2002:a17:907:c18:b0:c26:19de:9ad5 with SMTP id
 a640c23a62f3a-c29b875519cmr151707466b.45.1789393755289; Mon, 14 Sep 2026
 06:49:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913113552.11486-1-linkinjeon@kernel.org> <ebb45fdd-76f0-4d92-9899-13ecdaea555c@chenxiaosong.com>
 <CAKYAXd-efarHzvWEXSc_0jx6KhK3KJOfmuwM+wsVCmcsFUBTWA@mail.gmail.com> <d8330501-0a1f-41e8-b408-2e720f550657@chenxiaosong.com>
In-Reply-To: <d8330501-0a1f-41e8-b408-2e720f550657@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 14 Sep 2026 22:49:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8M_9eacRD-L+v5T-t4XSDdg5pu8UaZVb0xrXzr2MceeA@mail.gmail.com>
X-Gm-Features: AcwNN1VAS79rqYKgzbCqcagSU5JRoT-W6QiAnpV8qHqV5kg58CEae-YW5_rphUM
Message-ID: <CAKYAXd8M_9eacRD-L+v5T-t4XSDdg5pu8UaZVb0xrXzr2MceeA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd: fix partial normalized name responses
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com, 
	Mobin Aydinfar <mobin@mobintestserver.ir>, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 1:26=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> It seems that ksmbd-for-next has not been updated yet. Have you not
> pushed it yet?
Done it now.
Thanks!

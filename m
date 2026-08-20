Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF0F1CDFCA
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 00:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787186762; cv=none; b=dZap8jtLMWWwhbmL6jOxWJ+e1/tCaDPsvlm5VOV4lndP3drUhaGOf3yJUOi797NcbmbscXEOpLId7cNyd0vsJCaGhLnDw35A+kF49gXMKTEmQgiVSw223Tuhv+nUPvhxWcBK0sH9Zx3Q0JfzTyvjFrhks0t5Lqnjl1FEIFv5U00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787186762; c=relaxed/simple;
	bh=nrt9o/BXu6TjoQ8727PujcfcycKMfZHvXUfUSK8ZmWE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e07nvTqVw68NrV4I0MbTtadKJm6ZIC75/P/wKT3ROJuapkdquFO5bpI2Ko88Qd/trXWI8ie8PwUQfBbcNY4ub1pmNfz6hB5+X+ToHG5J4sLcWP4e7iIRx6uaLcWalkQc+sQ5dSTtxS+NvPikm+oBiYjLohvl29aWJsM1s0Z0wUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHU3bp0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHU3bp0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4081F00A3E
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 00:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787186760;
	bh=mhTvFmpOgjXlNbmMTmItu40I5a2cbxrRiyP57MxZub0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GHU3bp0pbgHns/1o4A/OQD7zVg3lBRGVLP2tnRkHVfOv/PO96xj4bFvkMtRKdGW6J
	 1T8UtNmp1HxcrasqbDMauKl/1ZeWbHdIPENfz+sawrS2XaYvspkzlNtNTIxCcNEeSs
	 MZFDJQJtC7C0DvAreYD3H4SdY/Y0EdU/oX9AsBTSjtPod9uiRycAx37hckcDIb+4RW
	 f/V8o/PmDVkXo8e+HBZBfskaz/VJexTrc0E2+keXmkWTExvgCv10zaYcRDHyQI8Fqn
	 3WUZm6t1EYLxWp/17PRuK7A6fI2R46k3ys5jvE9O++L3uTrrvwtNwMt4S1jkeVJeJq
	 BvvwQa0VluvbQ==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a18e24ad25so2357055a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 17:46:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrnqj5siL6ByahJ91/bcv/yjGfQ2UkzzzcREVggadHhBI9h9M4h5Ufs/4pf2YSuqn55on0wMICE7BVE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8yMxBjPWtvU7TFqqmnVUJ44xEVhKhez4Q649r94f6pwip/sNG
	jeZqVqWM7j8ODZx2irgN+w6twtRgCR5LOUZAtCJPCbe/6xFwBSC0XTQxECnIswE0HRKJ1WhVDxL
	GVscDNhXmJO2uwuULWBjoAtGGVj3N1RU=
X-Received: by 2002:a17:907:f815:b0:c20:af9d:4533 with SMTP id
 a640c23a62f3a-c242e2494f3mr613599366b.19.1787186759362; Wed, 19 Aug 2026
 17:45:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260819033013.46824-1-nanx95726@gmail.com>
In-Reply-To: <20260819033013.46824-1-nanx95726@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 20 Aug 2026 09:45:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8i68x7pLWmjLFyQJMprJDD4Mip0w_SS80L5x1Gpik50Q@mail.gmail.com>
X-Gm-Features: AcwNN1V80lC3a87ETCqs63eSGiCilLTJJHHSWqJvWS2ZOipfmx5jRlYuAwevH3c
Message-ID: <CAKYAXd8i68x7pLWmjLFyQJMprJDD4Mip0w_SS80L5x1Gpik50Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] ksmbd: bound smb_check_perm_dacl() ACE walks by
 DACL size
To: nanx95726@gmail.com
Cc: smfrench@gmail.com, tom@talpey.com, senozhatsky@chromium.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 12:30=E2=80=AFPM <nanx95726@gmail.com> wrote:
>
> From: Hang Nan <nanx95726@gmail.com>
>
> Changes in v3:
>
> - Update SMB_SERVER_KUNIT_TESTS help text.
> - Moved kunit tests under fs/smb/server/tests/.
>
> The following patch from v2 have already been merged into #ksmbd-for-next=
-next:
> https://lore.kernel.org/linux-cifs/CAKYAXd9XHJSNfrFr+F8thNxFnXqGGcKpS1b1q=
R4DNuu82+j_VQ@mail.gmail.com/
>
> Hang Nan (3):
>   ksmbd: add KUnit test for the DACL walk boundary
>   ksmbd: test smb_check_perm_dacl() DACL walk boundary
>   ksmbd: test maximal-access DACL walk boundary
It=E2=80=99s a bit late to apply this to the 7.3 kernel. I will apply this
patchset to the 7.4 kernel.
Thanks!

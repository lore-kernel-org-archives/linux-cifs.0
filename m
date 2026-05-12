Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6978481A88
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 08:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778572815; cv=none; b=GLMIyBQpWf4YlOYLMzC9M0c6W6yB2iqRVEEeMCP7Zd9NH4ekPgse9yzNotQcOGWZpH82Rt8/+bTM9QidjrsXTzTEzuj1unG2T1KuUzk/iqLRGxvTa0cKOF+oVmkCDbL6xcUe1QGOMbxRN5WTJco4iuJ4FxzqXDZqXJ0Sajp2Mhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778572815; c=relaxed/simple;
	bh=nLJ22zTMaHsoNd9AnGO+sEGAewZRQYGWwEMXvIiQ5U8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uPJG9pQsYRfuXzsEWyDgEFMOMONzOrUkELkuuD5r7ZO/Lx28lnEWR/HFQWxuGss/pRnKBkV0DXvK2EFRYqLSkwyw6B7TySruoZnTiuUpr7Rfj1pT2NPLkpGpk5LdjQUmjr4ekDJgxkvruO/NI4R4wF4C+nP0CpUzLML/97hh1c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXASNexR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXASNexR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64475C2BCB0
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778572815;
	bh=nLJ22zTMaHsoNd9AnGO+sEGAewZRQYGWwEMXvIiQ5U8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OXASNexREbtY8dmaB8avXIQ8/zC2eibW2DGHrNzuRZbbIVNGCDILQ5AkO3O0lYKUa
	 Yy3Nmg4xQojHvPHFLy9OOwRsUawHjEPhN/NO+RWcclqrC2JlC1c3Jy/KoGKif9oc0h
	 hNre9AgoauQRkDdN0tmmGoCCx1EsM6dsEE/SzLmChxc4C37sqLWp6IjZzBNHNAOhCB
	 kovhn89B3W0l9aCN+taC6K0vPZ0j+98c7l8APVdvv/x233Rtf4cbdPOfw+VQv7CfDi
	 eF2sShoQaB8qRWrb0wySblOW3TfNbQSKLBpMc+k0ozMYe0BdC1WDe1R277yHQwxjAs
	 BNo5C0S+FBdqQ==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ba7a1cc0380so927540166b.2
        for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 01:00:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/NAJg2N3GvVup6EARkG/1toBMEhZkYI7IuQ9PBpyxCkrVTJEO9oJvkIKVwyLYlUGi16xGdNJSgOJxf@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1n8kCnhWaf+czssW+AdimEcBQVLySQJYFfEq/wZEqaKCUEtU8
	lHXXf2zPzTTt0UMbHF5fN6NG8qhXtwBpPnR9472dHFmq9xcSp1bW57iEOK1j+WHQbNl7s8p9kTh
	qF7uhko2SKRR2moM1R4YNVicvCV4wDng=
X-Received: by 2002:a17:907:a49:b0:bd1:d528:ac60 with SMTP id
 a640c23a62f3a-bd28e508155mr110689766b.16.1778572813999; Tue, 12 May 2026
 01:00:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvP9s_KMc2G-_AsP__G0S5JCmrigOT-7U_ZNu1pLf+Q2g@mail.gmail.com>
In-Reply-To: <CAH2r5mvP9s_KMc2G-_AsP__G0S5JCmrigOT-7U_ZNu1pLf+Q2g@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 12 May 2026 16:59:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-8VmgLNX=0TnsPL1LP2u-V-zOs+Z08dKHDZUbt+q2AAw@mail.gmail.com>
X-Gm-Features: AVHnY4IAHqU5sZqJscjCYyEmArdZHD10bEMimG_uGe1Nn2J-_EhBFeImPr7-InE
Message-ID: <CAKYAXd-8VmgLNX=0TnsPL1LP2u-V-zOs+Z08dKHDZUbt+q2AAw@mail.gmail.com>
Subject: Re: generic/004 server bug
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2026 at 6:36=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> I noticed generic/004 fails to ksmbd, likely server bug since it works
> to Samba and Windows and Azure.   Test generic/004 was recently
> enabled when O_TMPFILE support was added by Paulo.
>
> Ideas welcome on the ksmbd problem this found.
If there are no volunteers for a while, I'll take a look at it later.
I will add it to my to-do list.
Thanks.

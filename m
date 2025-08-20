Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40001D86DC
	for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 23:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755732931; cv=none; b=epOJ9tBv+Y//Tn66t1Lf/Ym10jPAoWKC3SIzBtpYktOvNHreiF0KFAgfxd0Bo6QmwV2IaXn/wtUwtihTQvp5BTmJ1j7wPJD9ptYGiw/zZp6ebmggXmdiHk3RcCObn2AC84R2OpX7brpta6Ig585uqNrJT5vy2tnG2vc5BKKo7p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755732931; c=relaxed/simple;
	bh=GM0w+XrcXE9FoT6McUaZM1wxs7WZtex0oSn3cvXFAQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZoIum2x73FW7RAl6aRUwvM6vJpaz3446dMa6luF+gngN0mJk0479gDSdFqL5Qa4UO5RHh1maFVgV82HfnrN8VOQBjhvKj/ebHNGLsvORLlMbtDXAtxy29mH3t7SUCpkfz3D+d+0Or/3PyvMKVY8YwTglwrrFOkg0LyO96BdiCYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kW8BmwF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kW8BmwF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D686C4CEE7
	for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 23:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755732931;
	bh=GM0w+XrcXE9FoT6McUaZM1wxs7WZtex0oSn3cvXFAQg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kW8BmwF/GF/7HDB7MV+3gpiiGMaYw+bTaeP5Uh9oj52AspmBcpbM/dkpO+a7uu02+
	 /6ODRnLolACq1mUWMIF4NZK6z5FzegP7/aJZJPVl7sgV2+GbinTMZDi7X4IRK1c3dp
	 so8zwVKwuyKDylgVmHaTmPCJkxlf8j7qzrhTIlOatw2paqEsHCk5h6/7gP/Z3/Gs1I
	 iUfV69HnHMwfJEfUiX39eTCK798NOR0TJnzjK+/uR8mzglrD6sBUVgm/JHnG11HlZC
	 pQvlg+oP077eii7y1jYeKgDbFjS2MNF3OQA2y+I53uUOmfEy6jhBTonD61Y+JewHqK
	 mEZfuTVMzFDMw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afcb7a2befdso61566966b.2
        for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 16:35:31 -0700 (PDT)
X-Gm-Message-State: AOJu0YwizNCgdSWKR+90qqHzSsxaXHHVp5Vw0GW7aAafrTLU5HEHeFFx
	cQZgET1Jm699NCjEK6WWzWtrn3BwlQEf446s7TZfNYUrcz9souVUAUgBSqtjqdwPzzzEbXDM8jO
	5q85XmBWuAIz7kru0KL9FEqkhm4Sj5BA=
X-Google-Smtp-Source: AGHT+IFWHZGp1fjwLdPn4hUD+Ul+MO8DUjsQBkQDxCUUbuqOdOR37CwpOIyIiUVv2TV7ISUWggpCN2ASjHyNu6ccNyQ=
X-Received: by 2002:a17:907:7ba3:b0:ae3:5368:be85 with SMTP id
 a640c23a62f3a-afe07bb499bmr43430566b.47.1755732929923; Wed, 20 Aug 2025
 16:35:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
In-Reply-To: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 21 Aug 2025 08:35:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-i2YFYOf6N9a-E-YQJ+An8JieZAnRbM80L81uLdn4j-Q@mail.gmail.com>
X-Gm-Features: Ac12FXxjLIu0T7kbryx9KQN0_tQLH7MYIUIzdstbSV93FehHieuudgz7c_5qyws
Message-ID: <CAKYAXd-i2YFYOf6N9a-E-YQJ+An8JieZAnRbM80L81uLdn4j-Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: allow a filename to contain colons on SMB3.1.1
 posix extensions
To: Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 11:24=E2=80=AFPM Philipp Kerling <pkerling@casix.or=
g> wrote:
>
> If the client sends SMB2_CREATE_POSIX_CONTEXT to ksmbd, allow the filenam=
e to contain
> a colon (':'). This requires disabling the support for Alternate Data Str=
eams (ADS),
> which are denoted by a colon-separated suffix to the filename on Windows.=
 This should
> not be an issue, since this concept is not known to POSIX anyway and the =
client has
> to explicitly request a POSIX context to get this behavior.
>
> Link: https://lore.kernel.org/all/f9401718e2be2ab22058b45a6817db912784ef6=
1.camel@rx2.rx-server.de/
> Signed-off-by: Philipp Kerling <pkerling@casix.org>
Applied it to #ksmbd-for-next-next.
Thanks!

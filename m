Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEE11714AA
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791249626; cv=none; b=FMQQj3t9FqIMFyO0yyl3WD6MBAOtqNaxUoTIUp+YNrIkvhh/C/mdPyDNojo/0OsZOUHTv6nFErVZ5UOJtrkwTMGJMi7ZjG87rF2Z4fhdV0xumUT4QEWTgXR/D+TIZX7HVx3SmyHzrngr5GWm1soQLAukIVt9b+bMav5P6nvby/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791249626; c=relaxed/simple;
	bh=MCuSM9/Tu+XwM5GnV/1hqbah34LwZLOndhfPrIk76jY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a6XlgXjOVmcpUw9hBC3mlb+JURHXCoABrTxWwswS56DfaFCt3pQnRBuKitmVDdTBb7rP1w/k0/vNpaMoc6foL9GD1pLuY8dxZSZL1nUIeiKgTn/0Fmxf8nkfBmbGBqkYAdhfVWM3ONEbvWbbvd/55zm6Sfxyk4LrOPJHOgcitG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKhbEI19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKhbEI19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992861F00893
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 01:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791249625;
	bh=/m8zwpcfiZZh1of5o+6+jsJN/qo7dq6OpiXod0akmPs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cKhbEI19PL/xLUiLZ/tPLmPF2Ayi7kT286r1096jdMYMPoSr3QkTcAq/9VCIfV2hQ
	 xGHgYGAC2mSm6KJSlGa7ffr7xCbKfBKFRc/5uNSG92BNSlVFBKylBQA85Pxx+sipey
	 eI7jJF/BUUKxK16DoFjmxLAFq7C5FE6N9FFGnEvNSB5TXs5QOoycBLz+QmHaKUNDng
	 7um5t/FEayIG3O3egDidencUDWqOLBqMpV8+yWH9rsxgpuPE2rgMY+rFIGpaUgqAG2
	 L5UufaGySHBHtdmG04tTi19XOBEN/1GEIcquV5Khe+aHQkbpo5HO9NumQ4C1pGtd7S
	 i6uojsCGkDtRQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6acb57c2b88so3278950a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2026 18:20:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwz8waHB8ima4uLFREaymACsFe69ZRNMfgFNc8KQtBOIFPkT8d33h6EX4uaTy1wDnH/VVN6nrGQA34x@vger.kernel.org
X-Gm-Message-State: AFq9FYLDz9+T1a8ueS4gfzfAW1r6Sni+LOiJ05X136rSx917V+tESQQ3
	yDcFTNd+7ArHcxo1pRObnFchCFtsZkRJNi086DttDgbPtNxvNrDmHQX26qZ8kK8OOL30RE/bMVV
	iKeC64AdduR4oJejYYDkJcsyfq0tpyRM=
X-Received: by 2002:a05:6402:304f:b0:6aa:f1d2:ddc4 with SMTP id
 4fb4d7f45d1cf-6afad90a8a0mr6010219a12.28.1791249624308; Mon, 05 Oct 2026
 18:20:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791229120.git.metze@samba.org> <CANTrAmwHqivuuH9UhPL=744OQTZ=qzahqHV6k5eLEPgap3uBdg@mail.gmail.com>
In-Reply-To: <CANTrAmwHqivuuH9UhPL=744OQTZ=qzahqHV6k5eLEPgap3uBdg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 6 Oct 2026 10:20:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-2uBhGZuSFdLM00D+Sty2+DdGbZLWiA1DG0jGvfJjUWA@mail.gmail.com>
X-Gm-Features: AclHuK-L7K8klR2JfUZbTxIrbry_OECFkA5orOsuIKl12RpYwWZCdJbjDN_51WM
Message-ID: <CAKYAXd-2uBhGZuSFdLM00D+Sty2+DdGbZLWiA1DG0jGvfJjUWA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and
 teardown races
To: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Paulo Alcantara <pc@manguebit.org>, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 6, 2026 at 9:19=E2=80=AFAM =EC=9D=B4=EC=84=B1=ED=98=84 <ihopenr=
e@gmail.com> wrote:
>
> [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and teardown rac=
es
>
> Hi Stefan,
>
> Thanks a lot for the fix and for crediting me.
>
> Could you please use my real name instead of the display name in the
> Reported-by: tags (patch 2/3) and in the cover letter, i.e.:
>
>   Reported-by: Lee Seong Hyeon <ihopenre@gmail.com>
>
> The address stays the same. If it is easier for you, I'm also fine with
> you fixing it up when applying, or with Namjae doing it.
Okay, I will directly update it when applying this patch-set.

Thanks.

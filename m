Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3505A20ED
	for <linux-cifs@vger.kernel.org>; Thu,  5 Jun 2025 00:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749081893; cv=none; b=KvGytYTTFv0u+bQ/Qt2b4oNwFLgEhwIJf8F8EGgqCxC1igW96fk3MSiLOpYTPCIoI52W3APvG6FMrbfknzqNP84ypguQKAf8RiKwT2LZMz/5bVoFM9IJCOG1wAkV9QXmksz0hzYbIog1lE1WV8m3AH050jGuqXrb5yGeonO7Qko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749081893; c=relaxed/simple;
	bh=pxGT/xYYvO436VXPvPhBP5z1/ofEu+uwq+L5R/bn/JE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gyzDBzPC9Zjk5RXx0R+kxlFUOkFHgoeDaj0oowByVF9FBaaKlqgmYWSxAxn0iBzaw/PtQkjut+A7EH6kjQfTFhHuNgSXldQegk2ObvuOUdRqgOAlyg1JYYPzHydw6sQLz3qEidxlI3vWoVogDI6zxfI4AXRF/bfPThMGf+Dj4nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCetNAAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCetNAAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DB6C4CEF1
	for <linux-cifs@vger.kernel.org>; Thu,  5 Jun 2025 00:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749081892;
	bh=pxGT/xYYvO436VXPvPhBP5z1/ofEu+uwq+L5R/bn/JE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QCetNAAB58C7z2uzrymut/M3zToknxmQNVNcFCgrK3AdrAyRXsO2OJYKWnnSeTnFE
	 utPDIH2x+M03UXyKCn7IoZ0ZT3+iDgCoCVWni4p3FoLTQ9TnTAh8bc+H62KxT/wFh1
	 eGr6k6iFj9G+iZtkaYNVwk4onVe7U15AvQo44wSnVjBTZStYv9XEkVV+uxp5sYs8S+
	 SD/Ks7nZ72faGFeja/yKoUnSUYbtAZpHX5mxc3+pAF2oJYo1tWYdiThr/hm64lr9iV
	 8K4gSaNwrdsvzE4+wI93wIMLm2bEy2803fdZ8sEmgE+87EFakgO5RtVsUgLZwtUnaz
	 R8LeL+I3LrzBg==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-606b58241c9so544426a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Jun 2025 17:04:52 -0700 (PDT)
X-Gm-Message-State: AOJu0YwUmtw6mBxTP9Gu6ueU1BcZHZ7W54ynPM173DkunsTpQZWOdQkH
	eZ7t2zu4bWRroDG19LtmDwwyzmL1LPyNEtMpUYHBLykxNNYw/jWQ7HMbeQe/EjT47YT+0nMjxFh
	bA8cXtZCOUvHACzV3q/fhRjx51qU6nls=
X-Google-Smtp-Source: AGHT+IEF9OhoI7zmfgkpsZePFtQamtBdMmTsaDvGv9iPFRN7RT/3ywIMb7j+DGD9qAZ8dNwMYzAzqbmxCDl8ID0sdoQ=
X-Received: by 2002:a17:906:4fca:b0:ad8:9b5d:2c38 with SMTP id
 a640c23a62f3a-addf8cffff1mr438594466b.26.1749081891295; Wed, 04 Jun 2025
 17:04:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFTVevUpjG0uQXs4Stj2OggqfGoc8X_6iLgzaVf2V6oTa8eqTA@mail.gmail.com>
 <20250604034355.15875-1-meetakshisetiyaoss@gmail.com>
In-Reply-To: <20250604034355.15875-1-meetakshisetiyaoss@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 5 Jun 2025 09:04:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-HTFQE00Vy79SGt6jdjMLR3XHj5bDnpMPVqG-fMH_hVw@mail.gmail.com>
X-Gm-Features: AX0GCFuZ7AMdfwObX69oUp6bg2Dk98wnse-diy0kJsquCY0VQ2Q7IcfUGTcRxGY
Message-ID: <CAKYAXd-HTFQE00Vy79SGt6jdjMLR3XHj5bDnpMPVqG-fMH_hVw@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: add documentation for smbdirect setup
To: meetakshisetiyaoss@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, nspmangalore@gmail.com, 
	bharathsm.hsk@gmail.com, pc@manguebit.com, lsahlber@redhat.com, 
	tom@talpey.com, sfrench@samba.org, metze@samba.org, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 4, 2025 at 12:44=E2=80=AFPM <meetakshisetiyaoss@gmail.com> wrot=
e:
>
> From: Meetakshi Setiya <msetiya@microsoft.com>
>
> Document steps to use SMB over RDMA using the linux SMB client and
> KSMBD server
>
> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!

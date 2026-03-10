Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C13C1FC0EF
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 01:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773105922; cv=none; b=kN6l6snogkbNnfaAEK5SEc32Mq4YFpjwqqq2QlRvLJ0xxPT3lMa+4AjSFqkRdGw8ExmwaAKaLFBWtBdFk/2aDBkpi1vxOcfBpYAeaeOQ0x9KmD3bg3UhQCkAqPAS0Sh+tsEodhcWFhyEDCaqHsHKKstrlEWkYnZ1l1NnkfUMq70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773105922; c=relaxed/simple;
	bh=0sAQmhaRLEQozIP/qCPN0/MrJd0he+x5tmnWGz/d+LE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j0q6bKMTSOLNHgjFC/uNfUan7U1JAL3QHgqoXYvKbqzVMgla8MkQ5X4+wCQTjgDlf4jsWUdyW/ke58jQwfDgizj5dxw5nHLRn/IpuwqiiUmOa6raGhNjEh3D00ZmkduJxQxxYehutFkJ9E7EmA6mVLSjf3Phk4Hbft5CuqhewE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlfjtWMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlfjtWMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C446C2BCAF
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 01:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773105922;
	bh=0sAQmhaRLEQozIP/qCPN0/MrJd0he+x5tmnWGz/d+LE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nlfjtWMQ7ygsRWPIXezPzcdfzpSbnt6GUBkO1wbUAnbe+VYwSKnjiayzaROgr0+yT
	 YtfURwS56xCfA3X03UhLJt4j9bCUEJkVce4QZQsv/+ZPHmua4ST4ZjUqdhhprDuVik
	 ui9EkpMnQ9Dw5FtyR1tbiQnw9kswo1Cfy6J/pqsgLyvBveff8DGUoJd8fwxQ2Y46B7
	 WjXjT8wODom9TDn3S7wGWUt0soOpo5lN7qZzA18+PtB+Gx64MDGHwEK2n1Ry5rczrK
	 v7gWsvwvn3q34Y8sj/m9L6zBgbmCynLoyZiV/jH8Lgx3pCF5GWLidUWC6rjDsCp4ER
	 Dyte0rI5n9Kcg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b936331786dso1351467066b.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 18:25:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUoYA63wL3aLBHObVF6p1eAUo+k+vaifbz0d7lAk0SmdMcxE1472tBKgtBKk2hPr2rGNW3x0heVbxD3@vger.kernel.org
X-Gm-Message-State: AOJu0YyHQ6b4B2xQLfPxiS1FsXvvHFPPiFGS5h3nu+id+wATh5ko7wV4
	ddR7sPeZlW4JTQt7YjacXPIvpdpbdNQdYxNrd0HaFooomXy/NlJLp2ubmEyWhzUXP8ZB07hiWoX
	rZezzfPLrBSvYETYg9DT5QUY5gg5HuYU=
X-Received: by 2002:a17:907:a0c8:b0:b93:80f3:b356 with SMTP id
 a640c23a62f3a-b942dbcd374mr731110766b.8.1773105920579; Mon, 09 Mar 2026
 18:25:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303151317.136332-1-zhang.guodong@linux.dev>
 <20260303151317.136332-8-zhang.guodong@linux.dev> <CAKYAXd-_OU+YMpUmUKR0m86L+OqHPoa1T1WSDgAfo7H70tv_Sw@mail.gmail.com>
 <0858a9d3-f26d-4bb3-98cb-3e73abfa1399@linux.dev>
In-Reply-To: <0858a9d3-f26d-4bb3-98cb-3e73abfa1399@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Mar 2026 10:25:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-EoFM=t8oG6xtv=kofuqQ2pT+7Pyt4Abk2zqMCpz+Gnw@mail.gmail.com>
X-Gm-Features: AaiRm518YDYxgqUvqVjFhFZ8P_98mtUUqsn9_R-qZFuzqF4TdIdBUDrPL_ZjT98
Message-ID: <CAKYAXd-EoFM=t8oG6xtv=kofuqQ2pT+7Pyt4Abk2zqMCpz+Gnw@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] smb: introduce struct file_posix_info
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: smfrench@gmail.com, chenxiaosong@kylinos.cn, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 10:18=E2=80=AFAM ZhangGuoDong <zhang.guodong@linux.=
dev> wrote:
>
> Hi Namjae,
>
> The client cannot use `SidBuffer[32]` because the size of `SidBuffer[]`
> on the client side is not necessarily 32.
I know, We need to change ksmbd to use flex arrays.

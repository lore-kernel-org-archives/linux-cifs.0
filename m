Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B422A372B5A
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 23:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788822079; cv=none; b=D0xesuJBIjFW0jPEF2wCYn4FePtQsOrNfnNKCpNpHBc5iW3le28bt74sb0q01oSs5XIb1ZlG9ys0tjnk8KEkv8L0e/llZd8de3VQgOJApqUTYvp5rFPQl33F/PG1U6CIZcLSPR0h5piCkSUBIbvtE6++AbtgRYIpV7TxaiVR/4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788822079; c=relaxed/simple;
	bh=octyGcAzRI1FTFrNG4m/rXphof1JrQJfSnM3RegK/og=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oo3/fkYPO5svjjiS3MnYlFjqs8uGg+sOfnx2+ACfRubBznGu/uDjpmhQzxq14FJy7LN57kqJBKtor4HsQ/B9b7YkNr2YycgYaTLPHAMN7bpKFIRlruiTfIU0rZBuaJFQzmGZc5zDNwF5e/7ZjWVzg2KKHbocrSCpn9T9LFcGub4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SmtTaxO2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmtTaxO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642291F00A3F
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 23:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788822078;
	bh=octyGcAzRI1FTFrNG4m/rXphof1JrQJfSnM3RegK/og=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SmtTaxO2V3gC7wQQp8oI4TAZhbINo6Lkgv4qUAZklqdZe6dPgugdal6n7dx0xfLg8
	 sbrVQm9BlIqImlGYeGe5t65RdLG7eC7xPxQjka6qf3A9wlHBMSCcpyvkukwsooCVX5
	 H5+KUAkLpgO6263pGpOIith8WyRgghwLVKYROkO41rCD71JNcHbD3UJINwoEGjq9cL
	 UM+wSEv0m88KSRgDqUn5/4txUDLbdA4FQehYQBqv0IJpjK4tL7e+FLWJA+AV+MNbm8
	 GdXuIPvHfl5Q5wV4BqF9T7Nr0D5PlQ73qpSw0IVz3p3jZKkkZuzwju5NenIbM2daPX
	 kA9BDy7bNJuag==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2544ff970dso547969166b.2
        for <linux-cifs@vger.kernel.org>; Mon, 07 Sep 2026 16:01:18 -0700 (PDT)
X-Gm-Message-State: AFuF++ne99sk4y5iCRz2Dyaw9X/q+66Qn/2HKAVoAxIlP/5x8YjsQzbL
	2kVYlUAWSPnXHUJnMZtC3PWuZVqBml5nHaccrUzxryhNrcz8zyhzLwZ5Fm22GOvyXiWQNIr7Jbq
	ozJjKM+SpYwKfcnOircFM5v482oB7by0=
X-Received: by 2002:a17:907:1c22:b0:c26:1649:47a8 with SMTP id
 a640c23a62f3a-c26164956d1mr848649066b.30.1788822077002; Mon, 07 Sep 2026
 16:01:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906200517.725015-1-pc@manguebit.org> <20260906200517.725015-7-pc@manguebit.org>
In-Reply-To: <20260906200517.725015-7-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Sep 2026 08:01:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-jqZW_7m1_jSjoSyfouOOBm=9ODAwrZ944AEuoSJX7-w@mail.gmail.com>
X-Gm-Features: AcwNN1XlFM_hQqCPDh-Hcc09yNUnmrBg9e1g0z5uqTAK63tgxnG8xFZW4wlhKqQ
Message-ID: <CAKYAXd-jqZW_7m1_jSjoSyfouOOBm=9ODAwrZ944AEuoSJX7-w@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 5:05=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Setting the file type in cf_mode without clearing the existing S_IFMT
> bits first is wrong as it corrupts the file type when cf_mode already
> has type bits set (e.g. S_IFREG | S_IFLNK =3D=3D S_IFDIR | S_IFREG).
>
> Clear S_IFMT before setting S_IFLNK for native and SMB1 symlinks.
>
> Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40mangu=
ebit.org
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D31E1A6839
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 00:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789431192; cv=none; b=RfD3f/1q99BEJQgO1TrAqS7zggniqpAL4s3EYypqGUMgHhSaamUMXRPTSRWA1FccWEpHnH1sf/tz49iPujmQLI7DiedK02tB2OkkHTxJ+Uu0ML+/7bo/u5nrNdqyuXg3aTuGyrD+i3+Z1mq3S9jXxVjLyPnj+whLCz0MLoCWHoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789431192; c=relaxed/simple;
	bh=Tj736iMY4CcZwMWh0sCcamZcY2IxURiXqQBmVL7Kt84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cSHx1Mf+ZZyCff5i4PlBzeo/ja/gc13GIPuFF86TGRGSF9tFYF2vMkRTdDIFe8Rz8HnjZske4eSY3cSuScdGoh2VukMndfIRSuS8wFz3FxDm9ixgWIV5kT9DqpqNYMVTjKcLJibYlPOqlMluQClTtvjNpWMSxEDP7XNn5BhLmrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9V+7MjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9V+7MjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C366E1F0089A
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 00:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789431190;
	bh=Egm2nd4Owu0a8lT0TcA+6+U36gP3IJAbfA941epwJAU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z9V+7MjQPmAjmUks6mqSQd+9DL6q5FDPetDsNCHCu8ELgNOM+ew69j57rsVSyxIV4
	 who37wtwqqVbWOhz+1QkuC5R74WT0ulUGlt4a0lvcy0kXXraWYApuKzdaiPXnpd6WG
	 F7FKccGn/LEACZzy6L3nWuaKrwd0wy6p1DGc+jB4TFy5oe739Qq3Q7vMYHZ/7mdLRG
	 Xohv1r2YUe2LSKUfB7X55XgKtjgOUz3JhtP5C8JzFylG7w3lxfJ0ZYSF2Sdrdlpwjo
	 zSHxZS5X2rRvNiX069mxVGVMYBnd9bHEZ0V2ve2oeixK81xWkk7qy0PuP+83B8DeVx
	 UAT6JRCRSc09Q==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2940d16190so560577666b.3
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 17:13:10 -0700 (PDT)
X-Gm-Message-State: AFuF++lKIN6XccuDDGuM5OiP4C3dfx2ADtRR39L3MsFoiycxp0rpRZH9
	A7tJaxN8qe+K/80DcjGFX6BQZfhtQqBJNIY4gBih4LjMfdGGVCUk4Nw0LUXsZBBSiHxIEAHC4MV
	sInVKEJoMC2EgR99BUUqCsRvyIFZlils=
X-Received: by 2002:a17:907:3f88:b0:c26:19e3:e98d with SMTP id
 a640c23a62f3a-c29b879db25mr308802066b.45.1789431189420; Mon, 14 Sep 2026
 17:13:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914011052.809774-1-pc@manguebit.org>
In-Reply-To: <20260914011052.809774-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 15 Sep 2026 09:12:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9WU4O7MkjFM_Qw3Ob8NtQzYgnNbCJX61sT3uSwoz2veQ@mail.gmail.com>
X-Gm-Features: AcwNN1WTe6N7Ddu8nzN-nqcFgQDQiD2jyI6_06BTGmvw_Lhyi_n5DmNFN-A46cE
Message-ID: <CAKYAXd9WU4O7MkjFM_Qw3Ob8NtQzYgnNbCJX61sT3uSwoz2veQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: fix unaligned access in WSL reparse
 point parser
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Tom Talpey <tom@talpey.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Bharath SM <bharathsm@microsoft.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 10:10=E2=80=AFAM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> When wsl_to_fattr() parses WSL extended attributes, it computes a
> payload pointer from ea->ea_data + ea_name_length + 1.  Since the
> smb2_file_full_ea_info struct is __packed and all WSL xattr names are
> 6 bytes long, the value pointer always lands at an odd byte offset,
> never satisfying __le32 or __le64 alignment requirements.
>
> The code then casts this pointer to __le32 * or __le64 * and
> dereferences it directly, which may cause alignment faults on some
> architectures.
>
> Replace all such casts with get_unaligned_le32() and
> get_unaligned_le64() in reparse_mkdev(), wsl_make_kuid(),
> wsl_make_kgid() and wsl_to_fattr().
>
> Closes: https://sashiko.dev/#/patchset/20260906200517.725015-1-pc%40mangu=
ebit.org
> Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL =
reparse points")
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

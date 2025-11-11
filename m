Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64D11C6FE1
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 05:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762839999; cv=none; b=iu201r6U3RhvUgktTz9kwaBH49y6KzIvbl+2rXtDGCJ8xcR3/5pAmL9nRk/Da+s6YMzcaHvFAAj5Q4AgRmgW57rE5iQKw6Sx6tLj65ILjk1vtNr8PC5xWrD1RiahKl3zyQEcW8LM6uEHx9uE7WNUijLJO/fqXdtVst6VxH2j54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762839999; c=relaxed/simple;
	bh=88MA7FFfqsE2m/H01Z3+We2u+DvOXcJRGWjb+ba/aq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qDZ1X6IXP6ahFPX+1uKUievPWn8lwfnYFSJuDpTV68aWoqurEUItRC105QAJasw0XHLNcx4e60BlniSyS9vbO1bBKtX06q6c00LGYCB0LyT+tj+0mEMgmwLVz6/oIU5u8Je3cyOQX8xCgSP2ofMryAkGTUwzxGYuIMKV78ihc2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZwufzs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZwufzs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFD9C116B1
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 05:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762839999;
	bh=88MA7FFfqsE2m/H01Z3+We2u+DvOXcJRGWjb+ba/aq0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FZwufzs1svcGhCfpLuQNqjnWtHM4V8hOrHKApdHZ0xX9tdOlR3jljP+OJufenNL6h
	 4OvKif3vLyl55Xnlk1LFXAnqWCILvNogQO8XFnESMWqvSFKY06fUHoPlHXMEVdCjQq
	 qpBmvU/hBFjPuBLhiBRl9n7dkbG0fh6Mo1RvtRVlt5tagaVvgj0huDOcxajCZNvEh+
	 PsT8XbB61VMrCnaL8DCvrk8nL4mEzQHz6h8dv9CzOuupzH0OWT0+j0SyTEyGWEJgDV
	 zJeBYtDT1uUVeokS384gnyYNxmMZ87s8iPTaqNQWOptZqHVnun2L+JSKIME9xoq3ML
	 XepzZOTL1wnxg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so2468554a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 21:46:39 -0800 (PST)
X-Gm-Message-State: AOJu0YybT2guHsAUxRB1EVAyhQNLZaMnN5B2GfG+tE87Wa4fWmDFcu0T
	bgzRQ2pIpqbNud2SZoHNxabcwKVRqfqA6v301VcoxL5xLfXztj3Y7ZXKTkrwi0UBw2ZhmnJFszk
	W4FEfOdXqLiNuFKp0BrXWiksV946LTkc=
X-Google-Smtp-Source: AGHT+IGwEPdaSDYQbTScYkkptse9ATIhZO7TWXe/XoISjgO/uLNwm7phNBo2mRF7mkqD+QDGLEsI3q8e93DG9aSId+w=
X-Received: by 2002:a17:907:7f0d:b0:b40:cfe9:ed2c with SMTP id
 a640c23a62f3a-b72e05c9530mr979626366b.64.1762839997984; Mon, 10 Nov 2025
 21:46:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110152420.2889233-1-metze@samba.org>
In-Reply-To: <20251110152420.2889233-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 11 Nov 2025 14:46:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9CMKMfMZGSL05fm9uE0FcdiSHRhMUcqVdxVfFv1mJFHg@mail.gmail.com>
X-Gm-Features: AWmQ_bnWpKDAr3OvJboQXFJlGFZRaQQTIGqXGsox1QeN4YJHzwrvkRn6R9YCfn8
Message-ID: <CAKYAXd9CMKMfMZGSL05fm9uE0FcdiSHRhMUcqVdxVfFv1mJFHg@mail.gmail.com>
Subject: Re: [PATCH] smb: server: let smb_direct_disconnect_rdma_connection()
 turn CREATED into DISCONNECTED
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 12:24=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> When smb_direct_disconnect_rdma_connection() turns SMBDIRECT_SOCKET_CREAT=
ED
> into SMBDIRECT_SOCKET_ERROR, we'll have the situation that
> smb_direct_disconnect_rdma_work() will set SMBDIRECT_SOCKET_DISCONNECTING
> and call rdma_disconnect(), which likely fails as we never reached
> the RDMA_CM_EVENT_ESTABLISHED. it means that
> wait_event(sc->status_wait, sc->status =3D=3D SMBDIRECT_SOCKET_DISCONNECT=
ED)
> in free_transport() will hang forever in SMBDIRECT_SOCKET_DISCONNECTING
> never reaching SMBDIRECT_SOCKET_DISCONNECTED.
>
> So we directly go from SMBDIRECT_SOCKET_CREATED to
> SMBDIRECT_SOCKET_DISCONNECTED.
>
> Fixes: b3fd52a0d85c ("smb: server: let smb_direct_disconnect_rdma_connect=
ion() set SMBDIRECT_SOCKET_ERROR...")
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Applied it to #ksmbd-for-next-next.
Thanks!

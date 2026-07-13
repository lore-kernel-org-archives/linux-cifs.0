Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5D239479C
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 08:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783931141; cv=none; b=F2De9tj+ZF9Vy33XwCGI4/kWxW5BrKceg1h0PevW6+pREx698uSWE1/ZCfYo38rC+eqox2MtQAe+8tHo/UgyIf8bDDuWIVbqMug0sMN5QwFQGgm8cpwwSGLt/fp6z8arYtKarTbv/snLbnwHy1gSOYIbniXs9A5/4Jt626s5tYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783931141; c=relaxed/simple;
	bh=eGW+xcqk4j9LF+Xz0TAfGywYhfNDH2x4x5tFncL/W78=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DelhsmJeW0icFYEeCdpDZADxTjTo5kEBTysi1JzJJiQM7rax5NNCsN6vEfiGdtCq1ukmZGj792+OHhc9LtJJsxhkUXi3/A2DXK1PO7JTfssemCxKqNe/T5nx2QWCWj22vJ33n+zcXfwqzCJtGMX+QHLnycfpfslEqeEbysH5jWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAMVbHh0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAMVbHh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41921F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 08:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783931140;
	bh=eGW+xcqk4j9LF+Xz0TAfGywYhfNDH2x4x5tFncL/W78=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aAMVbHh09j57KV5ObGTBMUHM3EYkw4XN7/JRSairGwVdFmJ2c5naGmH5GTnuOR4PG
	 BkFbzs6J6FqCIOhp8YBRG8089qRCy7og7731qcB4uGis7kJSeXTCGKWgOYEqFbwt/h
	 /TtVeSe0Xm1NMLcyr2Y/seLAcF6vuBqNCOOB34l+loHjXsMIvPhssqETTL8BSDlhGb
	 LbRJyHmiQIgVipoGT0f1HL4tkjxvh4OEhAabxcCFtuSSHy1zoANhRrWx3kId/4rHI1
	 1AceamZBYmubWi4/to5HYMXmHJO30h6nmPJaqYst/h4KdcF4/2EqVfqX/Iq3+RrHaY
	 /UJ0lLshUskig==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15f6de6cdfso364273866b.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 01:25:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoIx244zRmifT+DkuBnjFKO2csLsZv8BVFcTK1U3A8pmRVW6t4Mj8JwzYZurf2ZkqyaF6qLhj9PTqml@vger.kernel.org
X-Gm-Message-State: AOJu0YzFXq7A4Naw4rzPt5DnczNp/N5ttx5c5xpmXNqXWm656HMubIxp
	uAs8hSQzEd463LqrgoWfCAX4CZXQ3sXKuTkmwSRvmot76+ZWlihBIgL9KGclse0WwIZacS4pTOa
	oHp46ABYUhp5+O9B5fO0AatS4b5SZv1k=
X-Received: by 2002:a17:906:2a09:b0:c12:a5fb:ff22 with SMTP id
 a640c23a62f3a-c161f442fcdmr280430766b.50.1783931138626; Mon, 13 Jul 2026
 01:25:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712-ksmbd-channel-key-size-v1-1-84818ee5cdc6@outlook.com>
In-Reply-To: <20260712-ksmbd-channel-key-size-v1-1-84818ee5cdc6@outlook.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 13 Jul 2026 17:25:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-br3fg=9_E3bWqHv_yiR2w81F-vUP_8EzGz5Ajs1owow@mail.gmail.com>
X-Gm-Features: AUfX_my1APbUK11sD4KkIxrqss_DcTBKyrnBHpyVUX1ooSRKOm__Sj2yc_pULZY
Message-ID: <CAKYAXd-br3fg=9_E3bWqHv_yiR2w81F-vUP_8EzGz5Ajs1owow@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix channel_key buffer overflow in multichannel binding
To: jijunye1@outlook.com
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 5:21=E2=80=AFAM Junye Ji via B4 Relay
<devnull+jijunye1.outlook.com@kernel.org> wrote:
>
> From: Junye Ji <jijunye1@outlook.com>
>
> ksmbd_decode_ntlmssp_auth_blob() and ksmbd_krb5_authenticate() can write
> keys up to CIFS_KEY_SIZE. During SMB3 multichannel binding, their
> destination is the 16-byte channel_key stack buffer, so longer keys
> overwrite the stack.
>
> Size the temporary buffers for the accepted maximum.
> register_session_channel() still stores a 16-byte channel key.
>
> I reproduced the stack write with 17- and 40-byte NTLM keys and a
> 32-byte Kerberos subkey. On the fixed KASAN kernel, 16-, 17-, and 40-byte
> NTLM keys and 16- and 32-byte Kerberos subkeys completed 10 bindings each
> without a report. The existing length check still rejected a 41-byte
> NTLM key.
>
> Fixes: 4b706360ffb7 ("ksmbd: fix multichannel binding and enforce channel=
 limit")
> Assisted-by: Codex-Security:unspecified
> Signed-off-by: Junye Ji <jijunye1@outlook.com>
I have already applied the same patch that arrived before you.

https://github.com/smfrench/smb3-kernel/commit/578dc53f371ed19a8a9dc357af37=
6a515f4c8ddb

Thanks.

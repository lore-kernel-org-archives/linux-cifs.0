Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F801303C8A
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 02:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776218472; cv=none; b=fa6WamKu5pPiCSVym4I/xTuAFrGCVLmEjHBbVcaf3FztzvwpOZ5CJ4WLNmENgHdwWGxpbBsCsxNaLkgpWWO5JhORJuxNccXP0NAWcSrHxkuFnu7lpHynfN3zdh1+Pxjb6Qdks97xXywCH1cr8aTaDpxpP9Ee/Bro1RaC6vd91Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776218472; c=relaxed/simple;
	bh=8YVeNgNiRmAJqMrVc5F669ogu0IKs8pMHti83cSxKJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e0y9ZXialexz1alfLXFg1+s+I+9WWPsr2HaEK46QpV/hmdsrXTymoHFC99SNDgtY2rOB39nweYDqB1nc9DrP1bqRjj8/n0mXhdMjt8ZcbP32xfe8k6N9iocORtWljjMchjOmKuCSb6KQjlvubYYzjUXzex9fmbXi7DGTYxrb8ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHUuRHyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHUuRHyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFA7C2BCB5
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 02:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776218472;
	bh=8YVeNgNiRmAJqMrVc5F669ogu0IKs8pMHti83cSxKJE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iHUuRHyVek5CKaP2mf8cyKNQ5W/cP9kHJ5I6FyDpk7eSNdQPelQMKmBq+p3xKJM65
	 4rIBPehTP/wtGVtCRWR1pXLOKV6hAXf4TIpmATKqbHurUfGjPrwKpHWzsN/7BUXZSm
	 tuFUbuQNVX+yRZ4KjZFl1lCqeUbmYEyfUrGR9uG/ZvbB4SNP/Mgxd9v5VdnV5QZEK1
	 6jkb9xLFzhQ9iCTlyIClcOfOl+R3iu256kJgB4XBd/V4pmyylaLWgURd9L5JX7T+Rf
	 QDGGQj+aOpmlKXOZWiz3mW9JfUVACjHt5NdYBZJ6IxDB2lKjyygS3oVES+Anz/EJ1k
	 VfLEf8JOAeRFw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9c280322e0so757144066b.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 19:01:12 -0700 (PDT)
X-Gm-Message-State: AOJu0YxteWlU99N4KokVp1eEqYdRXwAi1tIYTiAcXPs0ug/TluzKwUM4
	Cj240+2AsghXWw2E5u6oEtRsGvZ2VV0KcnG4q7v2FbiwSS0bVLopZwzt9i0mg4fMcXmVC2o0tle
	mNRgmBgVdlwGrI0ana9By5zRRCaX3ks4=
X-Received: by 2002:a17:907:3e8a:b0:b9c:eedb:db4 with SMTP id
 a640c23a62f3a-b9d727a0607mr1017965666b.53.1776218470846; Tue, 14 Apr 2026
 19:01:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414191533.1467353-1-michael.bommarito@gmail.com> <20260414191533.1467353-2-michael.bommarito@gmail.com>
In-Reply-To: <20260414191533.1467353-2-michael.bommarito@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 15 Apr 2026 11:00:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-zwPuES8PdV+XQjuQUemVKejayqY_0aYS=88uZ=FG9+w@mail.gmail.com>
X-Gm-Features: AQROBzDiTpeN0_4j4Q3OmL-_lPLc4Vt6-gETxOY7I8KyeY9SyNLI3Hhpqk1YlDs
Message-ID: <CAKYAXd-zwPuES8PdV+XQjuQUemVKejayqY_0aYS=88uZ=FG9+w@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: cap response sizes in ipc_validate_msg()
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 4:15=E2=80=AFAM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> ipc_validate_msg() computes the expected message size for each
> response type by adding (or multiplying) attacker-controlled fields
> from the daemon response to a fixed struct size in unsigned int
> arithmetic.  Three cases can overflow:
>
>   KSMBD_EVENT_RPC_REQUEST:
>       msg_sz =3D sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
>   KSMBD_EVENT_SHARE_CONFIG_REQUEST:
>       msg_sz =3D sizeof(struct ksmbd_share_config_response) +
>                resp->payload_sz;
>   KSMBD_EVENT_LOGIN_REQUEST_EXT:
>       msg_sz =3D sizeof(struct ksmbd_login_response_ext) +
>                resp->ngroups * sizeof(gid_t);
>
> resp->payload_sz is __u32 and resp->ngroups is __s32.  Each addition
> can wrap in unsigned int; the multiplication by sizeof(gid_t) mixes
> signed and size_t, so a negative ngroups is converted to SIZE_MAX
> before the multiply.  A wrapped value of msg_sz that happens to
> equal entry->msg_sz bypasses the size check on the next line, and
> downstream consumers (smb2pdu.c:6742 memcpy using rpc_resp->payload_sz,
> kmemdup in ksmbd_alloc_user using resp_ext->ngroups) then trust the
> unverified length.
>
> This is the response-side analogue of aab98e2dbd64 ("ksmbd: fix
> integer overflows on 32 bit systems"), which hardened the request
> side by bounding attacker-controlled lengths against the existing
> KSMBD_IPC_MAX_PAYLOAD / NGROUPS_MAX caps.  Apply the same caps on
> the response side: reject resp->payload_sz > KSMBD_IPC_MAX_PAYLOAD
> for RPC_REQUEST and SHARE_CONFIG_REQUEST, and reject resp->ngroups
> outside the signed [0, NGROUPS_MAX] range for LOGIN_REQUEST_EXT.
> With those caps the subsequent additions and multiplication are
> bounded well below UINT_MAX.
>
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: Codex:gpt-5-4
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> ---
>  fs/smb/server/transport_ipc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.=
c
> --- a/fs/smb/server/transport_ipc.c
> +++ b/fs/smb/server/transport_ipc.c
> @@ -497,6 +497,8 @@ static int ipc_validate_msg(struct ipc_msg_table_entr=
y *entry)
>         {
>                 struct ksmbd_rpc_command *resp =3D entry->response;
>
> +               if (resp->payload_sz > KSMBD_IPC_MAX_PAYLOAD)
> +                       return -EINVAL;
However, on the userspace side (ksmbd-tools/mountd/rpc.c), the DCE/RPC
response builder (try_realloc_payload() and ndr_write_bytes())
dynamically grows the payload by 4096 bytes using g_try_realloc() when
preparing responses for calls such as NetShareEnumAll, etc..
This can cause share enumeration failures on servers with many shares.

>                 msg_sz =3D sizeof(struct ksmbd_rpc_command) + resp->paylo=
ad_sz;
>                 break;
>         }
> @@ -513,7 +515,8 @@ static int ipc_validate_msg(struct ipc_msg_table_entr=
y *entry)
>                 struct ksmbd_share_config_response *resp =3D entry->respo=
nse;
>
>                 if (resp->payload_sz) {
> -                       if (resp->payload_sz < resp->veto_list_sz)
> +                       if (resp->payload_sz < resp->veto_list_sz ||
> +                           resp->payload_sz > KSMBD_IPC_MAX_PAYLOAD)
>                                 return -EINVAL;
You don't add the check for KSMBD_EVENT_SPNEGO_AUTHEN_REQUEST case.
We don't need to check resp->session_key_len and resp->spnego_blob_len?

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BAC4C97
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 00:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298042; cv=none; b=An1Cj7+u9h1egnawWdf3l2X9bjYdjgJ2UdRw/i6CQk7kcMc8W/NSCfW3I4+OeZOsf9pKoFYiUoGhlFZoYavDa0axdwDI2Q7OGzrTIUdQxE0vR/nWrX5tTaUj/7c2eXm8vi+js27r/EYKTP2y6tojsRW9QmmfYiNV7FUT7M3E0Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298042; c=relaxed/simple;
	bh=YkxaWzvJMru1xnxMSm63UBq1tAGZwkpBtHh5sNsugcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DetoeGbQS7aJsPYmOCRR8go0Iihg0f9Khg5iBlvh7DMhozft+OBqdkWopBTUxQru2MrGBTPCxZa/qFYkqYjheLGl/M4lknAL7M1fJd4Nvpux1wZSN8Wt5FCHuVZ9BmaGmGzvdsqS1zRku7sz9A3KW+YkqB9EflQ2B3wQqaGxMd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMfkHeLj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMfkHeLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EC7C4AF09
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 00:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776298041;
	bh=YkxaWzvJMru1xnxMSm63UBq1tAGZwkpBtHh5sNsugcE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oMfkHeLjaKZStv7ocmCOc4jNLsah98slNzydNS7OKjD2w6MMmiydZFaSq2UMNQ97X
	 rnDE2gaM3XUUJLpHoxm/RmqL9i85bBq5gZCAMKZh5Q9e2fwyURv7KNTcd2n+aOeJcN
	 7Kkd7U4a4gHqKpSBHQGet/T3au7XLsGt5z3Jy9YkNAsmwQ77pTV3i9SwJB6K1wEfJs
	 IX6eDMsoUIWDAuLHbEDHvjpcndci3riTli/JTB5GaNV+Ar03VpHOY2aPaMzR2atsy+
	 u/imOr9+gzOfypUsG63CM2tvjfhsS2Pxek+r/hXdF5cfTzbdqXE+2EbGMz7p1RzlRK
	 hLbFw7BqfT/nQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b9c6f1d1282so995966066b.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 17:07:21 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw9dzUPZlUdwhooT7JDKS4j/Wv2TNqk+EX7QOKib7ymxl3GMBx9
	SnpBuu+TFvQmf4aj6w27khy6b8n5omU1JI32fvaWlxr3rd4vEYFhcxTbFS+Jz4hlfN7xyuwZRHS
	+5it0/oGTJq5Zd9H7O0YIwq3M4PwzddI=
X-Received: by 2002:a17:906:f59a:b0:b9b:7bf8:800b with SMTP id
 a640c23a62f3a-b9d729bd0cbmr1402936366b.40.1776298040451; Wed, 15 Apr 2026
 17:07:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKYAXd9EBFBcy9bJ3=sJiYVYHAYjKYqOqD53UCJ8zWKXF0sAeg@mail.gmail.com>
 <CAKYAXd8B78Gde_7+Ph0cSL998k4qqs_okB0jky0m5h8i25_AGQ@mail.gmail.com>
 <20260414191533.1467353-1-michael.bommarito@gmail.com> <20260415112501.116426-1-michael.bommarito@gmail.com>
In-Reply-To: <20260415112501.116426-1-michael.bommarito@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 16 Apr 2026 09:07:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9C5Ghw9NHcJomwrbvGaEjc-WGwzB+=6fPVCR2EYCweNg@mail.gmail.com>
X-Gm-Features: AQROBzAg4IonF_u2vmWKtAI_rhmQs1lEgdJWEvNMP8IfK0k0FzFdwBq3OkWm8c0
Message-ID: <CAKYAXd9C5Ghw9NHcJomwrbvGaEjc-WGwzB+=6fPVCR2EYCweNg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ksmbd: harden ipc_validate_msg() and smb_check_perm_dacl()
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 8:25=E2=80=AFPM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> Two ksmbd hardening patches, respun from v1 [PATCH 0/3] per Namjae's
> review.
>
> Patch 1 folds v1 1/3 and 2/3 into a single response-side validation
> change in ipc_validate_msg().
>
> Patch 2 is v1 3/3 unchanged (minimum ACE size in
> smb_check_perm_dacl()).  Please let me know if there's anything
> on this 2/2 you want to think through or change.
>
> Changes since v1
> ----------------
>
> v1 -> v2:
>
>   - 1/3 + 2/3 folded into a single patch (1/2) per Namjae.
>   - Dropped the hard KSMBD_IPC_MAX_PAYLOAD (4096) cap on
>     RPC_REQUEST and SHARE_CONFIG_REQUEST response paths.  A 4096
>     cap would regress NetShareEnumAll and other NDR enumerations
>     on servers with many shares -- userspace ksmbd-tools grows
>     the response buffer in 4096-byte chunks via g_try_realloc().
>     Use check_add_overflow() instead so functional payload size
>     is unconstrained but msg_sz cannot wrap unsigned int.
>     [Namjae]
>   - LOGIN_REQUEST_EXT keeps the [0, NGROUPS_MAX] bound (POSIX
>     semantic limit, not an IPC transport cap).  Moved the
>     pr_err() into ipc_validate_msg() so the error is reported
>     at the IPC boundary. [Namjae]
>   - Removed the now-redundant ngroups check and pr_err() from
>     ksmbd_alloc_user() in mgmt/user_config.c.  Both call sites
>     (ksmbd_login_user and the SPNEGO path in auth.c) reach
>     ksmbd_alloc_user() through ksmbd_ipc_login_request_ext(),
>     which now rejects negative ngroups at the IPC gate. [Namjae]
>   - SPNEGO_AUTHEN_REQUEST left untouched: session_key_len and
>     spnego_blob_len are both __u16 so their sum cannot wrap the
>     unsigned int msg_sz. [Namjae ack]
>   - 2/2 (smb_check_perm_dacl minimum ACE size) unchanged from
>     v1 3/3 -- no review yet.
>
> Threading
> ---------
>
> Sent --in-reply-to v1 [PATCH 0/3] cover
> (Message-ID 20260414191533.1467353-1-michael.bommarito@gmail.com)
> so v2 lives under the v1 thread.
>
> Michael Bommarito (2):
>   ksmbd: validate response sizes in ipc_validate_msg()
>   ksmbd: require minimum ACE size in smb_check_perm_dacl()
Applied them to #ksmbd-for-next-next.
Thanks!

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792546297;
	b=tFZWHklqAH926Q4BKOi+6y6ZP48D7qRWWGy0044EmOQBxyx1QRYH0XTv8KFVso+fC5TT
	 gBqQH7NGvrjDAj4HqOqCt93NphzG3Lv0eOo4wWkhcbYIHTI/Wfd7ywrZuw6847j7AViP+
	 x6jU2vHOrk2XU4PuYuxDWA28FW6Mubr8K1BFcxdSXP2XGc8HEIxtqyyy5LDHXPIgMSsLg
	 aIOc+xOaSdFDg0M8dCD776KQEVu89x8WLtFn/P7ZoyiAubUAjg6/BqxA6gnF0coHM+ASd
	 v+/Atqxq5W6NBwK0OYmeOT11E8x6pjkq1fzo06CLqkUt+GgPw3WYZffC4/qcWMc4OLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792546297;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=bTpr9NpTetHnln92kjh8Q6soXs5SB2dE5Ll01BYhvvE=;
	b=O7OsCDs/J7UHOP14qAKQjK/RmN4X2iM+oc7WXB7PZWcK7QqklQDEyuUHBhVh+bNeUl9R
	 5L5vE941YlKgJ+MLAigtWCisOk0DMbQnRQ2H+n/qb2779mz5DXELC9HfpFlEfRs/zVi1e
	 syDHajFYasYEbOKOjqSvchObwAhKflLnb8m3h1gz8fo88ij1KxIyPpqkRDXUrjZsD/7qR
	 Tl7RZ12R9nQwfm+tMYCKRQJx3vVw9O2L/I15soQkcXXVe0q1FxT9ilfPPAm6G0muCxGuy
	 RAF1FtF6ICR4f0p5OuaTjOr1k/WqUlMpCd+fqgU1ID9BLm7lc7BCXqgiFMKgvx+mVtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bbKICx/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FBC606A31F
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbKICx/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BE31F000CE
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792546297;
	bh=bTpr9NpTetHnln92kjh8Q6soXs5SB2dE5Ll01BYhvvE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bbKICx/KK3P3wZ0KKBlnK5u7NjkUvqFMJpXNBRYU+j72o5FS8tfeis4KXE8YyU5UX
	 +2SSTJuaU+zWA/I/DZcYJFu6Y/UDnnHwwO5v61OvXx+sdv2c3FEvGRbyT1/43euMP1
	 69KMubu0kd4VKs5+2HNvDgBfxKFeL5iU5h7ZI5fxn3oqN1YjEcC6FVKsmlxJgOG1lN
	 VGQpoDaaXKrvCHk7as1jMQUt7X+wPNT09KM06itolmhH02Vdubk2OSLMPYz4wDxaQQ
	 ji1Irg+sM99bJgTQksYe8jRBWUd+ptuakW3CEwWrVWAqX2JqeXjsUObNDW0UpVTnB+
	 H/E3Gfy/QdTsg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso214521a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 18:31:37 -0700 (PDT)
X-Gm-Message-State: AFq9FYIkK/5nfMljB/3fGEU72D0b0IJcMOThv0VXPMfJV6RvacgOdv2Y
	wJNrJwMNeB8zWOmUOqObtalJSgCI67c4b9oOvaQM1qQCri5mcVJdo/dwOf09kDA9CeE2XsbCswK
	TnnFhQHRbcmVfI5CxYRzVOzX8XPEirH8=
X-Received: by 2002:a17:907:3f98:b0:c46:75e7:25af with SMTP id
 a640c23a62f3a-c46796669c8mr53247766b.11.1792546295786; Tue, 20 Oct 2026
 18:31:35 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8xCgtA42XUkSsAeg@mail.gmail.com>
In-Reply-To: <CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8xCgtA42XUkSsAeg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 10:31:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Otv_doQutE+gzKJ+Pp9Wi5mjCZpFdfobGJER5=hM4JA@mail.gmail.com>
X-Gm-Features: AclHuK8fkB3qvtBt_Moreu2LAmL8ZAC9wrTcuR5XTcDmGloZjIbZ6yJjmLOhILo
Message-ID: <CAKYAXd9Otv_doQutE+gzKJ+Pp9Wi5mjCZpFdfobGJER5=hM4JA@mail.gmail.com>
Subject: Re: ksmbd: Kerberos login fails on 7.3 with released ksmbd-tools
To: mixalhs <mike.michalo@gmail.com>
Cc: linux-cifs@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 9:39=E2=80=AFAM mixalhs <mike.michalo@gmail.com> wr=
ote:
>
> Hi Namjae,
>
> Kerberos session setup fails on 7.3 with the latest released
> ksmbd-tools (3.5.7), and ksmbd-tools master fails the same way on 7.2.
>
> struct ksmbd_spnego_authen_response gained a __u64 session_expiry field
> before payload[] in 7.3 (commit a47634cd729b, not in 7.2), making it
> 168 bytes; in ksmbd-tools 3.5.7 it is still 156 bytes.  ksmbd-tools
> only gained the field on master on Oct 18 (4c0ca83), after 3.5.7, and
> always sends the new layout.  ipc_validate_msg() requires
> msg_sz =3D=3D sizeof(*resp) + session_key_len + spnego_blob_len, so any
> mismatch is dropped.
>
> Tested with a local MIT KDC and smbclient --use-kerberos=3Drequired, same
> realm and user throughout:
>
>                     ksmbd-tools 3.5.7    ksmbd-tools master
>   7.2 (mainline)    login OK             NT_STATUS_INVALID_PARAMETER
>   7.3 (ksmbd-next)  NT_STATUS_LOGON_FAILURE   login OK
>
> In both failing cases ksmbd.mountd logs "Authenticated user `testuser'"
> and the kernel logs "SPNEGO_AUTHEN_REQUEST failure".  NTLM logins are
> not affected.
>
> From the code, 6.6.y, 6.12.y and 6.18.y also require the old 156-byte
> size, so a ksmbd-tools release built from master would break Kerberos
> there as well (only 7.2 tested).
>
> Would you like the kernel to accept the old response size again, with
> ksmbd-tools sending the new layout only to kernels that support it?
> I'd be more tan happy to write and test the kernel side. :)
Thanks for the report and testing. The approach sounds good. Please
send the patch for this issue. Could you also update ksmbd-tools ?
Thanks!

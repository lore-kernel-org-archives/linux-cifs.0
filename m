Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F642D3225
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 01:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792374530; cv=none; b=DIKGwm1PlTwR7ik2Ly2tV11Knyjz3B0+MfTboYrqjs4rXqlOn1WCAFaKGIi5aIDdFGKgB3SSG4ovgF78labZJNlNXhEUdJtLQCLP7VBFys14kE5lyKGdk2kL9O1XXP+p/5LMNCpDnOIPrEQJktmTvtqK7OyxvvAQouVVtZDx41Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792374530; c=relaxed/simple;
	bh=JIM6zoTUlaJrdgn+54cDmYHwliPn4QEgAUyKadGUmJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kkg//uCbz9POHbwqgYGp04NWQRKdxgpFF6fVq1OXcgPUbsCehpYgC5l+2R1GZSIdQFRb7xcGTKg2LQ9bbg76kGP0QeBfvRd7UwuAkOwzWdquwJjgIZ+ooocjciezrSgXYv98l79wGLJrNYs6P97wgtn/7LDjUc1oONWAOyL78Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y95AeZtE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y95AeZtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2661F000CA
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 01:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792374528;
	bh=6tvwc8jhQ2o8DYNSOz5ej9BDGuB3McmrZeO+LyD/oX8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Y95AeZtEWvg7UYpZCnScvwJkbBp5+jg4C/k0vROFLQNFuwLeEzdAHaaEHkuuWfnwe
	 TVb3IHtLiawrTPq0g1LVU/eb2G3kqnTrSAu0ejUt4khF7lYuQ5hjj1c4yuxaM1Pe5R
	 5DCWoNpuSKpJzQ7dVoQQAWsmTDcV0t9nu2XARcNgRiYM1F5FT4dhVuoR2D55v5O6N7
	 9noaKhuMGGkkYGaw6eQB1JBr6+eN6gT+bJNd0VqBauQpeC4Wc02e5+eV7wRQaSUQQW
	 RUWmSJdL1wtfIfoi+ncXpbE7uRR+eNnEjGEIiXrIcLFEKaMAuHzqQWdqNdJoRTWRRp
	 ofSAPNoP2JBKw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2e8c710847so181290666b.0
        for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 18:48:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByvK+s2R/+dcQs2QFBIDWAfjM9++jWa1sJljVuic1vYYXXMiTDR+wYC6BnHEFPffbpAU6apNiviy0Hv@vger.kernel.org
X-Gm-Message-State: AFq9FYJG32EZVebwaagf2VE0E33lcuo7wNNWQOBTb21V1G21+OfRdt2Z
	7zcBgEOvCRoFx76goPjAGnYrfUQRZCpbJIgNkerdWOi8n/12o+4sRxLRfQt0blF1a8e8SvNUFak
	6mEV1Vs76cd0ErQ/AyZAB/IP89NqTLCE=
X-Received: by 2002:a17:907:c60f:10b0:c3f:8c92:3b5a with SMTP id
 a640c23a62f3a-c419df3eb40mr253882366b.12.1792374527539; Sun, 18 Oct 2026
 18:48:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792345559.git.jan.koester@gmx.net> <0ab0b83aa71945fc9f4e2711c3e815872954e71f.1792345559.git.jan.koester@gmx.net>
In-Reply-To: <0ab0b83aa71945fc9f4e2711c3e815872954e71f.1792345559.git.jan.koester@gmx.net>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 19 Oct 2026 10:48:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_iVsLRb2qjq-3Fxivaj7cxdstsOhUZgLX=M3j8c-ZSRg@mail.gmail.com>
X-Gm-Features: AclHuK9dCYMiqLetCYP2Zs_3P80CJNA1-2eEFyodNrbyJV0S0t0XgxED50hAQVw
Message-ID: <CAKYAXd_iVsLRb2qjq-3Fxivaj7cxdstsOhUZgLX=M3j8c-ZSRg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: pass through NTLM authentication to a domain controller
To: Jan Koester <jan.koester@gmx.net>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> @@ -225,6 +284,14 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authentica=
te_message *authblob,
>             nt_len < CIFS_ENCPWD_SIZE)
>                 return -EINVAL;
>
> +       if (test_user_flag(sess->user, KSMBD_USER_FLAG_PASSTHROUGH)) {
> +               ret =3D ksmbd_auth_ntlm_passthrough(conn, authblob, blob_=
len,
> +                                                 sess_key);
> +               if (ret)
> +                       return ret;
> +               goto key_exchange;
ksmbd_auth_ntlmv2() returns -EOPNOTSUPP when fips_enabled is set, but
this branch bypasses that check and proceeds with authentication.
Delegating response verification to userspace and the DC does not
change the fact that this is an NTLMv2 flow, and KEY_XCH can still
reach the kernel=E2=80=99s ARC4 key-exchange path. Could we keep pass-throu=
gh
authentication disabled when fips_enabled is set, before taking this
branch?

> +       }
> +
>         /* TODO : use domain name that imported from configuration file *=
/
>         domain_name =3D smb_strndup_from_utf16((const char *)authblob + d=
n_off,
>                                              dn_len, true, conn->local_nl=
s);

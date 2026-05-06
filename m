Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3557453497
	for <linux-cifs@vger.kernel.org>; Wed,  6 May 2026 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778086789; cv=pass; b=cQmcynkD9qAX0D25bEjszalzMpixFH5tarvH9sc5Fz7Jmvx4x+hFdLNW47bvT8TrxxKkjTyvTEpKb5yCpyxv1aQ7nMsxMt7zZw2wiuchL5mcrbtEXwL8HZeGwQVc8DzMekPCEqaSV1emULeuIwCS1sJnVp1abhwcY8ZH75VEKhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778086789; c=relaxed/simple;
	bh=LWygywvRRSiKpBTr0o9bgiuBWgNnc0I1IIfI5by07pE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ta4FVhmWemP1o4zj3zPdw/mJ4jORjCym3Yj0jVhcoKFtG3osiJP53uLHjugVDfUgJrpbBz5cqaghNGSuh/Q+gQVWnnqJBcupmxIwGfKGaAwuHz+CyZJOR8deaSSE62Mfjm3JZVqH00aEMHnQZ9Wfnts07t1C5PhunwxVvW0PfVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xu+hwfkL; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xu+hwfkL"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7bd87e5d8ffso13321017b3.1
        for <linux-cifs@vger.kernel.org>; Wed, 06 May 2026 09:59:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778086787; cv=none;
        d=google.com; s=arc-20240605;
        b=P1bDd9Sc8tZCS5l8KXcG16HT4f6LYmXVqn6f2iypXo93s1APB4B9O9Md/zf/uXmzlR
         bgowoBLfttxK/fGoh4pcufPVIN2Id54a4K2yMarQF75nw5nESCedW2oWC14Da+DmqIET
         s/Ki7BmayhMuUQiTzE4prKeEty6K1/ZJBpbKJdTOx8rvOtvQlI8ZuPrdUwgG2b8t8J3m
         sxojs84gQk7LvLWYj4O66pA8VtBOupq48Yyg0vgCwDXp14ITrwxv8ps74sncDjveejI7
         sGlF594qfLVEwznGW8rzzDhTC2lbTxqP03eC1y+fF9aH/Uq6X8Svj3KG9A0/UAhhptH+
         DD0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VpNHH3EUJPFUKRG6BWT746kb48QHVdE6WdUXwd1uc/s=;
        fh=Hr/UWcK7yckCBb8UA06ITsWOadoztgEfs+WYjLY9xRA=;
        b=SHiCN6VVcXadHp6mY1lm9dmK02VwcfPrUd+ClkZ9KV6tMQNL7ae6DhBmOItL6FQEoK
         ryKLmeduVtVLaZCTk73HPTBKZYTsyBOWE48f+UPz5my0EigZTYoNvmIlcVZn/f4FBXMB
         EdSWdEmL/x55YI/x6Yx0cVcQzoyh+WW7+a24Y92brJJxJJxoYzCh/SY+Ns4hMVmcCWKA
         MPHKH/1wf9x02vf+w/y21PncxVn3q6nEe0lTjlMrpt4LXdopIoTaUCO6PicRafyoOT6j
         yM7jOFIAkwDB9T3FMG5wcpHgSu/GzTJecgbEUR+4aKca2olWmNn4DVZM5n5ZHak212+Z
         iemw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778086787; x=1778691587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VpNHH3EUJPFUKRG6BWT746kb48QHVdE6WdUXwd1uc/s=;
        b=Xu+hwfkLy1HUPzj+Tqw+7JGmihukxPtgYN3ofm0A5u9J02Kbljbfv436X9cxfIZg7S
         H/MO9YBmCXAmbpUKnNd6jD8jy32NTNOLMW/RrjR/AKaiUwpdXPLTo79HkV1nYnsDU1VC
         2M/RdWujUTtslVsRcWXjwDeX/jqG5ocKBesGqG37nojA2nkQ2kJ/p4dQnhBYk5ehGC4Y
         So4P0+pVwXh1HmBYhJ92COYBW2+xLIy06kDUbzHM4EM6d7Ax+UphvS3mGtEPcup3XK5z
         T9sOkuK73LUtj4NI3KzMpS7XI5eCmgE8EqDS3USudqlLFwrm6G4eDDflO5xb9dGcHEUl
         FmrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778086787; x=1778691587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VpNHH3EUJPFUKRG6BWT746kb48QHVdE6WdUXwd1uc/s=;
        b=IrN6WrCbJuCqN33shpVA2sRvw1wGQVIuxwFkbNbeXpnd959CvVZVKSbmchjBaVrLEU
         72ktwwBIJGiRBItCe6Fm0rKCkBHkGqJoIQJNRDa7uq0DEzXOrOn7qt9YCFPISE30Ij0/
         S+ihMJvhkP6s3vBNI7TmmhWjZAiX1Wsc1WaHyRsVl+CojQ15h9Mqza1btednpH2WvElc
         +gCvQSC2klbCZ7ssygaYmRYOagSGOz9c3mmfL9tt+4vUSiRnys2PkIS9brRFMim46QPT
         EG7qK17QY0Q7MusQIjeiwFUChdkanHLRUAtcNndDEhYGKvg8kNGtiwtAIqxOhIFz8HSw
         6FnQ==
X-Forwarded-Encrypted: i=1; AFNElJ9kLeeOE4O9bu+TH94DfQEKoatJEHQxCCx3OfaX6wyoFJNqE9p9k2oyKSxC4UD0NBY/IFKvhYcGOkTY@vger.kernel.org
X-Gm-Message-State: AOJu0YxY2k9UWYY912nCH7Pesghbo7+fIYqjbkp45+Xdf04lnVG5SNPZ
	+tAdMjE598cmtMNX8kCG8uvbi8I0EyUqHoCrhT/egiPhLxbQj7PR0Me4vHZ2YaeQjCiRSP3drW5
	1aOl1QOP/+O4A/rvN4vA98QDui3z0jMvviLyBGh3Zwg==
X-Gm-Gg: AeBDies1JwEIHAAwPDzFUrt52a2JjjK/QjUVRbQ+nmx70xboSSK9QxTCHnrTnFQI5Jz
	28lxAMKIV1mASCuP7YS7WhZa8rl/AHHmG2S/SMSSRnpsnyPnRITs/LkBvrEUSqCNnwYTdaxPN6z
	3PIvlnnHCU8vLKRoLcTrlQYnEYWHYRho5nF0UxkafSFOxMAs24ZQA8CTWs+mKirqUTi6d2eJ0K2
	/Drj2oO/UOBUrT4r1khowVpvDFQefXoKXtzjZmc1R4e7a08Aha2op8MrqIVKrmMTQzxHzjW36/Z
	DDh0d3+F4Vp7D26ElQfO5U6fcS2/fYb8+xEDZJP9SG2bDriJQCId1q2s2BKf
X-Received: by 2002:a05:690c:289:b0:7bd:5c77:1aa5 with SMTP id
 00721157ae682-7bdf6452dafmr34764657b3.3.1778086786801; Wed, 06 May 2026
 09:59:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430-kerbmi-v2-0-0b98fe250425@microsoft.com> <20260430-kerbmi-v2-1-0b98fe250425@microsoft.com>
In-Reply-To: <20260430-kerbmi-v2-1-0b98fe250425@microsoft.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Wed, 6 May 2026 09:59:34 -0700
X-Gm-Features: AVHnY4JYBItmhumt6hqIJBpJsbwinxYx00_HxPYwCSCn7e07z0qrf2B-_VF9f0k
Message-ID: <CAGypqWyE6GF6WEj2i8LNLN2Nu=TWqO_UgUMub=OBg0x+5j6Xow@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: Use FullSessionKey for AES-256
 encryption key derivation
To: Piyush Sachdeva <s.piyush1024@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	vaibsharma@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 10:50=E2=80=AFAM Piyush Sachdeva <s.piyush1024@gmai=
l.com> wrote:
>
> When Kerberos authentication is used with AES-256 encryption (AES-256-CCM
> or AES-256-GCM), the SMB3 encryption and decryption keys must be derived
> using the full session key (Session.FullSessionKey) rather than just the
> first 16 bytes (Session.SessionKey).
>
> Per MS-SMB2 section 3.2.5.3.1, when Connection.Dialect is "3.1.1" and
> Connection.CipherId is AES-256-CCM or AES-256-GCM, Session.FullSessionKey
> must be set to the full cryptographic key from the GSS authentication
> context. The encryption and decryption key derivation (SMBC2SCipherKey,
> SMBS2CCipherKey) must use this FullSessionKey as the KDF input. The
> signing key derivation continues to use Session.SessionKey (first 16
> bytes) in all cases.
>
> Previously, generate_key() hardcoded SMB2_NTLMV2_SESSKEY_SIZE (16) as the
> HMAC-SHA256 key input length for all derivations. When Kerberos with
> AES-256 provides a 32-byte session key, the KDF for encryption/decryption
> was using only the first 16 bytes, producing keys that did not match the
> server's, causing mount failures with sec=3Dkrb5 and require_gcm_256=3D1.
>
> Add a full_key_size parameter to generate_key() and pass the appropriate
> size from generate_smb3signingkey():
>  - Signing: always SMB2_NTLMV2_SESSKEY_SIZE (16 bytes)
>  - Encryption/Decryption: ses->auth_key.len when AES-256, otherwise 16
>
> Also fix cifs_dump_full_key() to report the actual session key length for
> AES-256 instead of hardcoded CIFS_SESS_KEY_SIZE, so that userspace tools
> like Wireshark receive the correct key for decryption.
>
> Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
> Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
> ---
>  fs/smb/client/ioctl.c         |  2 +-
>  fs/smb/client/smb2transport.c | 35 ++++++++++++++++++++++++++---------
>  2 files changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
> index 9afab3237e54..17408bb8ab65 100644
> --- a/fs/smb/client/ioctl.c
> +++ b/fs/smb/client/ioctl.c
> @@ -296,7 +296,7 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon,=
 struct smb3_full_key_debug
>                 break;
>         case SMB2_ENCRYPTION_AES256_CCM:
>         case SMB2_ENCRYPTION_AES256_GCM:
> -               out.session_key_length =3D CIFS_SESS_KEY_SIZE;
> +               out.session_key_length =3D ses->auth_key.len;
>                 out.server_in_key_length =3D out.server_out_key_length =
=3D SMB3_GCM256_CRYPTKEY_SIZE;
>                 break;
>         default:
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 41009039b4cb..be421b852246 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -251,7 +251,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP=
_Server_Info *server)
>  }
>
>  static void generate_key(struct cifs_ses *ses, struct kvec label,
> -                        struct kvec context, __u8 *key, unsigned int key=
_size)
> +                        struct kvec context, __u8 *key, unsigned int key=
_size,
> +                        unsigned int full_key_size)
>  {
>         unsigned char zero =3D 0x0;
>         __u8 i[4] =3D {0, 0, 0, 1};
> @@ -265,7 +266,7 @@ static void generate_key(struct cifs_ses *ses, struct=
 kvec label,
>         memset(key, 0x0, key_size);
>
>         hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
> -                                    SMB2_NTLMV2_SESSKEY_SIZE);
> +                                    full_key_size);
>         hmac_sha256_update(&hmac_ctx, i, 4);
>         hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
>         hmac_sha256_update(&hmac_ctx, &zero, 1);
> @@ -298,6 +299,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
>                         struct TCP_Server_Info *server,
>                         const struct derivation_triplet *ptriplet)
>  {
> +       unsigned int full_key_size =3D SMB2_NTLMV2_SESSKEY_SIZE;
>         bool is_binding =3D false;
>         int chan_index =3D 0;
>
> @@ -330,12 +332,24 @@ generate_smb3signingkey(struct cifs_ses *ses,
>         if (is_binding) {
>                 generate_key(ses, ptriplet->signing.label,
>                              ptriplet->signing.context,
> -                            ses->chans[chan_index].signkey,
> -                            SMB3_SIGN_KEY_SIZE);
> +                            ses->chans[chan_index].signkey, SMB3_SIGN_KE=
Y_SIZE,
> +                            SMB2_NTLMV2_SESSKEY_SIZE);
>         } else {
>                 generate_key(ses, ptriplet->signing.label,
> -                            ptriplet->signing.context,
> -                            ses->smb3signingkey, SMB3_SIGN_KEY_SIZE);
> +                            ptriplet->signing.context, ses->smb3signingk=
ey,
> +                            SMB3_SIGN_KEY_SIZE, SMB2_NTLMV2_SESSKEY_SIZE=
);
> +
> +               /*
> +                * Per MS-SMB2 3.2.5.3.1, signing key always uses Session=
.SessionKey
> +                * (first 16 bytes). Encryption/decryption keys use
> +                * Session.FullSessionKey when dialect is 3.1.1 and ciphe=
r is
> +                * AES-256-CCM or AES-256-GCM, otherwise Session.SessionK=
ey.
> +                */
> +
> +               if (server->dialect =3D=3D SMB311_PROT_ID &&
> +                   (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CC=
M ||
> +                    server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GC=
M))
> +                       full_key_size =3D ses->auth_key.len;
>
>                 /* safe to access primary channel, since it will never go=
 away */
>                 spin_lock(&ses->chan_lock);
> @@ -345,10 +359,13 @@ generate_smb3signingkey(struct cifs_ses *ses,
>
>                 generate_key(ses, ptriplet->encryption.label,
>                              ptriplet->encryption.context,
> -                            ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZ=
E);
> +                            ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZ=
E,
> +                            full_key_size);
> +
>                 generate_key(ses, ptriplet->decryption.label,
>                              ptriplet->decryption.context,
> -                            ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZ=
E);
> +                            ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZ=
E,
> +                            full_key_size);
>         }
>
>  #ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
> @@ -361,7 +378,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
>                         &ses->Suid);
>         cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
>         cifs_dbg(VFS, "Session Key   %*ph\n",
> -                SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
> +                ses->auth_key.len, ses->auth_key.response);
>         cifs_dbg(VFS, "Signing Key   %*ph\n",
>                  SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
>         if ((server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM) ||
>
> --
Looks good to me. It should be cc: stable.
Reviewed-by: Bharath SM <bharathsm@microsoft.com>

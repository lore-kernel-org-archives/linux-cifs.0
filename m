Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792592046;
	b=VNvvNbq0URaWyQ9/jFSXJs0DGN1NmgQLt2xxZn7AEsneGXZzEKuttTQWyABGepEUTvS7
	 DWiMrN81ClAXa8QOmYC12Tjb0EoRongp0KNzGPzIoCcMLKMAm1MTOg6Jo07f9+qkgds8r
	 NEEDa+43OiNgzGZRAmLaS0M3eIViny2Sdi03r0AKh+AuKLavJ8cMaeLI8b2rdVTiqOraS
	 AnBbX+8uta6auEQfdsriisYnxgIcOkFPBQayHgZo68bEOQ8icvW742O+Jv/CuHeK/te/F
	 W+LhGgfh5AlSdLmofCWLtiZRAjrTkeGTu3GeaVge3FLu+++M0l4JF8Bd4f4nscNSKtQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592046;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UJ/A60pshTDV64EOc8/U0dsozGI6wHG2kt68wdBZvGk=;
	b=GyQehGFsJFV/pvJms40oBjfILBVJOvKsLjZyXB7QTG7yRZXZXWPlPFSdY4geatyvrenC
	 IwBYxxUppCOaxAKhcReFyhYeDvivLbMXKAJzzObmI9LBy9y88wldmPY3cYTYPE3+KNmb4
	 IzwtWrPFcrA2dB8pxix55GLqdxhU4NhtgULKmaYpllOrQ6t4PnPHR4LXCKVdwrt2Qf4n8
	 lCklDZuMEXQ5mV7CzzcKRMmHojix9U1HLtIhIOH3wcoc+aiEse+bvV81QzPU2aVIF0UHh
	 fqYLBNAQvaKNkUPxjkKXrtjEMyfneMJtgpyOeeL3SFSDcpelOFeiriuCkkZGsZP5o8g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="P5i/ZeyD";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.173
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E8C606A31F
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 14:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85E8C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P5i/ZeyD
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5ead5ff47caso487199e0c.0
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 07:14:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792592044; cv=none;
        d=google.com; s=arc-20260327;
        b=kpwFuhAAUtAYHVhpwhSPThP0VFft+U4PSbWdzG1zVa7xhYJlWGe4ch/XpbvSp0pVB2
         8Og4rhXRRr6ZNQDRwbjy9qij6wDKuSaOEAeuJKDtMjB5x9H/y6p2YFqJMX+O+2TNsuhA
         tvMw4M0+7xFo4jbhvvdNexIwr/Vfk6Dq5SfuxcG68tLSQzU4j15JDqsKxog+xkCuAHuA
         vtUeZG9mNX862rXgWAn3agwZHFtyQnuaYbkFSfdfdKF4V3ZAHuKfDQ8fiXjxd38yBbA1
         ITEHMG2iy7OAZA/l3Zfb9ttVLOlRNirVT2f/bqOlQMnd+IE0SA1fQ4jckL3nXZsvcgWa
         p5Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UJ/A60pshTDV64EOc8/U0dsozGI6wHG2kt68wdBZvGk=;
        fh=Ku8ZBpXJugBJLG4ydF9CxHtw1AQlDOUtGaEHpdFJnV4=;
        b=RrTOltUYlNHt+HpDeRIk5VMU+9hSvJORhR4yLJAibypP+807QUc67SfpcFr5d8smFK
         ox72BXEAyqDirVhUiPIYqUyMKmbCCoq42YBBGMpRPkEp1nDWzJvZEsjCfw78Rr+7kQaE
         qleEAmqmUStENRxdePXnmk19BNfgCWmvHuVpKGj1a08NtyG5lvirQhXA1KkOBNNw3/u3
         Q7UDnqynbEGHvMFSOUktyJoDfOu8lQIMTGo8djmQ99Ryj5W6mF/53Qx6m7CKkDDa4PD4
         2ysgSta1DryeyA0lpT5nsdDZg7UOrswckxzXQgUynT1GqsQ3EhqfCnfBmfbO9JpZDdvA
         wrBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792592044; x=1793196844; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UJ/A60pshTDV64EOc8/U0dsozGI6wHG2kt68wdBZvGk=;
        b=P5i/ZeyDVBkMIGuohnrHggiD4vso5z6e9mLwAvvqbmg+cZfeSijP9feo9Qf6rDuRXp
         yE7xHqSDNb0plAIhJWaSoLmsG9DZGbbb/JleA2EBPdBaDHp3wh1dG9pOwnkdcdRj9IN8
         XbO4rKntCjlm2Omf8PK8MgaxoHOrYKq9q9l9umfreEaTRiOK7FWi8O/KBGFQXg5jMVUU
         Ae9XbUO6K7OKbak/sOYq3aqvGuZ2rHWPfjtGFIyqlfFdhWZYF3SlTaatsDppaPHVBxc7
         gNQ6bF/72WNKa6B0C1ppZULgcMk88NNG5Af5kotLPdpjfSKAuXUC/8S/spHwWZC0jvqw
         8yCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792592044; x=1793196844;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UJ/A60pshTDV64EOc8/U0dsozGI6wHG2kt68wdBZvGk=;
        b=VqR6olRGfcP7byAMlUsDBBM0Tb91huAniLOn0RbLx7ovL5PL4Cs0rLFGdEEcwNSACY
         PYe/J+aDpx0J6QiLanoAZVx4eygwXu81GP4JSgnPCx47G840IovPirsCQnoD9boRoO5w
         jLWa3YJ+QA7gtK4I7OiBbYPhR2mgQJ9Sl7ytrEJcWxasNTWgfuKvP3j053xIu7adnTSM
         mcOcE0uaR6T4ow2yo4mhJwIWYVqy5mOuD/L6MhG3YsAkLGkoC8qfZu1iEn4BytlZgIZX
         H9+EPCh5g2QeeU0OQojkT/9cFp1hJpsHQBm+SlcOIhHdj0UW3Kq1M6oykAHZeRVnsm0S
         Fm5Q==
X-Forwarded-Encrypted: i=1; AKwUvBzzNMUUwV3sZ1aL8gD6cZkYPn5QzSD8FpTXPj0pyu+Q8TEUBLJpIpEqrxsGDBCn86rbQWHaHepywId2@vger.kernel.org
X-Gm-Message-State: AFq9FYJTBD7r1/U/q7jDHXg3LJOCya00uimMiOGKHYsSCa8BvbFapFmt
	VfMrgogA3HbWFQdcIvhmg5nirClUBKS4vmo3BsCWxUSKSb+0TPBlSxYe/DouxyKbsl47PqUEpwX
	+O/on76VPrjvCOplxzkjp4J6llLp3FUk=
X-Gm-Gg: AYBFou1Axm/c7FGUFQaRHqi5Mw+qR1ZimLeeIptTLo6NvpFoESBJ+BHJXyBZFAdOfIV
	6x8g2dguo0LnUh3HWEC6wTAv5PWsbpE0veuMgMPd/ZQw0q0lGsQzjZ+NgdKuBweuHyabIRjfaTz
	Xael2zualr793ZYio2rVJbSIqiFsuEF+SSjvGOWXesDk6pHA2tvOc9JGOPqPPhf1GGi2Q33Ii39
	L11I83yu+/4/1WskDI7H4HloIXnXXvvYx+3bjgo5j1AC8gSnK3x1qb25a4NG9C6cjRhPZk580qz
	4PXJ7TcfjSyqWwgKabE/UHdaVIpd8DBbKJXvBGgGYXp+vdJoqWj3Y2pqR8qTSFqKZ8Tj/wmTiVM
	928W75VwLoHFzM6ucCrrGBIHdt9m8pcqED/uCr6BeTPypjvkA4Di0Bg3hHjNZ6Wj76yELUA==
X-Received: by 2002:a05:6102:3588:b0:7a1:f980:e93b with SMTP id
 ada2fe7eead31-7cc926b0bc6mr656524137.23.1792592044313; Wed, 21 Oct 2026
 07:14:04 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021115400.30885-1-mike.michalo@gmail.com>
In-Reply-To: <20261021115400.30885-1-mike.michalo@gmail.com>
From: mixalhs <mike.michalo@gmail.com>
Date: Wed, 21 Oct 2026 16:13:49 +0200
X-Gm-Features: AclHuK-nUd4UmTxE9F3RBMXljFNNhLJJZePwWHLxIeXwrSoZlz9LU3TXba0QmGI
Message-ID: <CAO+rqLj5rF8MGMTRSav1n43NqLbazwyuPsPKgiQT2qtP+EDxeQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: restore Kerberos logins with released ksmbd-tools
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The ksmbd-tools side is up as
https://github.com/cifsd-team/ksmbd-tools/pull/347

Michalis

On Wed, Oct 21, 2026 at 1:54=E2=80=AFPM Michail Andreas Michalopoulos
<mike.michalo@gmail.com> wrote:
>
> Commit a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets
> expire") added a __u64 session_expiry field to struct
> ksmbd_spnego_authen_response, growing it from 156 to 168 bytes.
> ipc_validate_msg() requires the response to have exactly that size, so
> the 156-byte response of every released ksmbd-tools, up to 3.5.7, is
> dropped and Kerberos session setup fails with STATUS_LOGON_FAILURE.
> The other way round, kernels without that commit, including the stable
> trees, drop the 168-byte response of current ksmbd-tools master, and
> ksmbd-tools has no way to tell which layout a kernel expects.
>
> Pass the expiry in the reserved area of the embedded struct
> ksmbd_login_response instead. ksmbd-tools releases with that area
> (3.4.4 and later) allocate the response zeroed and never write to it,
> so they send an expiry of 0, which ksmbd already treats as no expiry.
> The response is 156 bytes again, so it works with those releases, and
> every kernel also accepts a response that sets the expiry. Use two
> __u32 halves, as the reserved area is only 4-byte aligned.
>
> Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets ex=
pire")
> Cc: stable@vger.kernel.org
> Closes: https://lore.kernel.org/all/CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8x=
CgtA42XUkSsAeg@mail.gmail.com/
> Assisted-by: LLM
> Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
> ---
> The matching ksmbd-tools change (struct layout and mountd/worker.c)
> will follow as a pull request.
>
> Tested with a local MIT KDC and smbclient --use-kerberos=3Drequired:
>
>                     3.5.7      master     master + tools change
>   7.2               login OK   fails      login OK
>   7.3               fails      login OK   fails
>   7.3 + this patch  login OK   fails      login OK
>
> With this patch and the tools change, smbtorture smb2.session over
> Kerberos (including expire1n/1s/1e, expire2s/2e and expire_disconnect)
> and the 190 smbtorture tests run by the ksmbd CI over NTLM give the same
> results as 7.3 with ksmbd-tools master, with no kernel warnings. NTLM
> logins also work with 3.5.7. A test-only mountd that overrides the
> expiry (including values above 2^32), the response size and the length
> fields found no wrong session expiry and no kernel warnings in 313
> logins.
>
> Current ksmbd-tools master needs the tools change to work with this
> patch. If you'd rather the kernel also kept accepting the 168-byte
> layout, I can add that in a v2. Only tested with smbclient and
> smbtorture on x86_64.
>
>  fs/smb/server/auth.c          | 3 ++-
>  fs/smb/server/ksmbd_netlink.h | 5 +++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
> index 1b24eb3f3998..8e5a1b10db6a 100644
> --- a/fs/smb/server/auth.c
> +++ b/fs/smb/server/auth.c
> @@ -464,7 +464,8 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *ses=
s, char *in_blob,
>         memcpy(out_blob, resp->payload + resp->session_key_len,
>                resp->spnego_blob_len);
>         *out_len =3D resp->spnego_blob_len;
> -       sess->kerberos_expiry =3D resp->session_expiry;
> +       sess->kerberos_expiry =3D (u64)resp->login_response.session_expir=
y_hi << 32 |
> +                               resp->login_response.session_expiry_lo;
>         retval =3D 0;
>  out:
>         kvfree_sensitive(resp, sizeof(*resp) + resp->session_key_len +
> diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.=
h
> index 2673522c76bc..fc6af757e45e 100644
> --- a/fs/smb/server/ksmbd_netlink.h
> +++ b/fs/smb/server/ksmbd_netlink.h
> @@ -148,7 +148,9 @@ struct ksmbd_login_response {
>         __u16   status;
>         __u16   hash_sz;                        /* hash size */
>         __s8    hash[KSMBD_REQ_MAX_HASH_SZ];    /* password hash */
> -       __u32   reserved[16];                   /* Reserved room */
> +       __u32   session_expiry_lo;      /* Kerberos ticket expiry, SPNEGO=
 only */
> +       __u32   session_expiry_hi;
> +       __u32   reserved[14];                   /* Reserved room */
>  };
>
>  /*
> @@ -286,7 +288,6 @@ struct ksmbd_spnego_authen_response {
>                                   * stored in SecurityBuffer of SMB2 SESS=
ION
>                                   * SETUP response
>                                   */
> -       __u64   session_expiry; /* Kerberos ticket expiry time */
>         __u8    payload[]; /* session key + AP_REP */
>  };
>
> --
> 2.56.0
>

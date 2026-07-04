Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB157224234
	for <linux-cifs@vger.kernel.org>; Sat,  4 Jul 2026 21:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783200342; cv=pass; b=DUf21exhb2RBh3yjuiO5Jy1+Q2/2IAJmF2RVmTXlvUmdixrdVgq73YyLGmKjciaRn1OtN20319VkMUJECxszazWSgrT40HuXD13KybV5mj9NMRirhwhx6Y95HBRfg4naV8RUyY8w7cWvCpDw0SCViX8ByuHb9QhAArYt2PQpdPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783200342; c=relaxed/simple;
	bh=GsN3MID5KBcezaTU6WtLxo3QeGyHR0wpnOVQq6Ika1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EYMle5jYtLjKSGjBdFpfhtWpyCUHGSzNIXhiSkCIM6eKD6AAJT1z/LlfqVCI7m5NoP78hFTdx6cpB6PX0jSs4ykdZk4z3bo4peL6ZXkDk8NcpuLxjsHkL8SafMZa4I1KyBgBZVc2s14WtNC+0IS89dZN7dAhAUHet5bg2P/mdlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qlx0qm5z; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qlx0qm5z"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8eff5ce3b95so12936456d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 04 Jul 2026 14:25:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783200339; cv=none;
        d=google.com; s=arc-20260327;
        b=MZSofGPQBBY4lB6oN//JOZ59G6ncTV6HIdCBFBdqv6ZiaYcSGiBqSdNYauA3ii70qf
         iO7O6Cmplvt8m71sjdE/yj6brx5eawy4WrutcDhnQKijquOdxRus1E5tfVS/w/iuSYAW
         uTRKhzCK5kWdysLRPmM7Sgk8ZOaL8vYAHn8PwrnUxSwlvRibxrcTFgNSHhOjZqVAEDq8
         VpELCfBnIZq5YnCQdElU1qdekL2IkUnrenOHnFOTSX6rVPllOd/fgWfqZCzH9wxZgJe3
         t+AmC43R+qJhpDoU6wOiM1+ceZyU4BwVJkjEFjTnKBK44h9UnSXjJ56wxAEKabM3h7sW
         1XlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r4qU5CBstytdGntCBNHjI1GY6BEpnjefbL+k8a2wbUM=;
        fh=588GhDGd7oiG3JpoZw/GJAVWGefyxRMOvMdaNO/uXT0=;
        b=DJg2aj4aIsFJVXmsVBF93y/yqys0s26JgkqleNgXn0vdBHSat9XsGd5Lig3MAbUzp6
         Pqst7pUrJknmHcUc7MgfyYPEf6+8SUk3W0AVx1EJjgQ97NpxypHDcNieQENMWZDxwp+k
         bOgzgS7PExhEKN3WzhJtm5/SzLbcyrMStPNlXSmUMFx0RvNd/fQTqoeWew/cpJlD/wQA
         y5dd6j/9ZNIBp4P9KQkpm7VzsFnAPVPHclX4g+kF8ZWdpYmBPrQVyhvt8LRfoACvruTY
         4reZPRuGBZQCwQxj4u0wc4z6SyQP1RA6Uv57asfAd1DGdbjjm4Uyy/FzGlO9lSdMqjYg
         pYbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783200339; x=1783805139; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r4qU5CBstytdGntCBNHjI1GY6BEpnjefbL+k8a2wbUM=;
        b=qlx0qm5zsCwaJAtdVPp9Ap7Z/0jBdp/585Jw/1c7xY9mwo8YLsccI+wm9sKs2zSBzd
         avY0pidAMMVtRz8qKM4WazxXjTaY2FOhiLdKcn6VQgTpdRl/ZmW8rskUw4dzFOm28Fwz
         VNom71TF0A1Y4DCd4ueb9mztiuUU/HN8wVDgg1s5210H0Ed09lhCUI1RalenkgKSL6Ji
         z9q+dMvrHIDxylH1NBc6ll4suC+im1WbWCY4KN39b6jXhvX0wpavZsuD1FwLsUNzF3Qj
         ujT1GBgoUo9v7s2CZepZaCvziEtosbzpGB8omI27JH4o7d6gQapfnU6Cey+vbW0TTh7l
         ds7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783200339; x=1783805139;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r4qU5CBstytdGntCBNHjI1GY6BEpnjefbL+k8a2wbUM=;
        b=B0KnoYh8iFCRW1wIgCPD1niI1ZieaWak0gn7whclTBjfa4nveLLOoVD3xUrmULVTh5
         s9Lc7PTzA1fH/TzN92MFpa9ZB1sE1dRJhqk6Si9ZQvA0aIsYoxHMR0B8eOLzHY1rV6SW
         xIxDV4c640bpf28EmIVR4JFbjOLWRIuqF/D/Xmv4cjhnZM0eGj/GpJA5k6byxgZ59q8G
         3WI0WHm77zvECqTha8ueVty3AfZ7G/vZq2aISzZJFfKBViw3NQj0FEL3gppF5cZqx+Lr
         nhhExX/hqNH6mVYI2xtBsgRxf8KktxBwzOOGe5JCG0an0CpaAvnu7B+g+kD1p6GY80zh
         UBIg==
X-Forwarded-Encrypted: i=1; AHgh+Ro8JmXjAwJPioamPJV9enq2wDF5TN7vaEtXiG+tfNIB0FNqUmMvnbDZOkQkyy+NwTfjqBheliVCS+iC@vger.kernel.org
X-Gm-Message-State: AOJu0Yy56CcPbRCPm5Eu2fnAUv8f6mhVV02cqWaLcGg2k8R/MxK94dVL
	0u7SYZWFyF26z39knMe2rQEIB6re9msZxKx9brnUu9mL1tpsALe1NgThFXVVG7g5sJoueIUHxpJ
	QN+cY7eHtVRKN3f0ZlHmrjJss8/ehaTg=
X-Gm-Gg: AfdE7cnpEChOejnZ9ljX8qRNyOddhfinnjTQtIqDxTdDbqXhRidnzV7b4XvLpBesfBB
	LYLDa+4Axfq3wWwNZ28Hj8wHGr1pr0cbXmC6hfi+/4xFLA00h7/Kw1p/fW9DQ/3Nn4C+uaXOzLP
	Kg5/pvZ4/A9grzbBJHTGISdlWpc4ht4WPaHIRdI61hahlHYux3zuG7qrBXKBZi6dRe91du0kBQh
	jN/+mW+PJ2f0erNLcwEyNSrlq7xfCEXQJ3mY7h7xO9GP49+Zhd3nr8tfDPFwwmMWf1OaOcQfw0o
	IoGFfDuacAqBynEqLmy8oFL+K/vMQQnvK+m/DUMbjTgrBPXNbWzaxxoOevAqXCY0x6Lodac3I3n
	Os5pDBAKfPQGSja1rIdcCeT5LMaVcczJclhC0OmXoYkAapi8S4dVl/zPGsiBLVJqxz6nswizkky
	5yyvQNrAbMMxk=
X-Received: by 2002:ad4:4ee5:0:b0:8ea:efae:ab26 with SMTP id
 6a1803df08f44-8f746249054mr82208386d6.0.1783200338901; Sat, 04 Jul 2026
 14:25:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260704023458.131044-1-mehdi.h.business@pm.me>
In-Reply-To: <20260704023458.131044-1-mehdi.h.business@pm.me>
From: Steve French <smfrench@gmail.com>
Date: Sat, 4 Jul 2026 16:25:27 -0500
X-Gm-Features: AVVi8Cd8aoUASHE_fjruiNaCbepftFE1hR4hLTC0ZEMfJ3VMtTufbmTVHVbSkDs
Message-ID: <CAH2r5mvzvKo1gANZZCVAajGOQiw-wRfkW9UV9PNp_sQoVQmduQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: refactor cifs_revalidate_mapping() to use clear_and_wake_up_bit()
To: Mehdi Hassan <mehdi.h.business@pm.me>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Agatha Isabelle Moreira <code@agatha.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Fri, Jul 3, 2026 at 9:35=E2=80=AFPM Mehdi Hassan <mehdi.h.business@pm.me=
> wrote:
>
> In the `skip_invalidate:` path under `cifs_revalidate_mapping()`, the
> sequence of calls:
>         clear_bit_unlock();
>         smp_mb__after_atomic();
>         wake_up_bit();
> can be replaced exactly by `clear_and_wake_up_bit()`.
>
> The `clear_and_wake_up_bit()` helper function was introduced in
> 'commit 8236b0ae31c83 ("bdi: wake up concurrent wb_shutdown()
> callers.")' to replace equivalent instances of this sequence of
> operations. This substitution has been applied in multiple subsystems.
>
> Compile-tested with CONFIG_CIFS=3Dy on x86_64, no new warnings present.
>
> Suggested-by: Agatha Isabelle Moreira <code@agatha.dev>
> Link: https://kernelnewbies.org/Beginner%20Cleanup%20and%20Refactor%20Tas=
ks%20by%20Agatha%20Isabelle%20Moreira#task_010
> Cc: Agatha Isabelle Moreira <code@agatha.dev>
> Signed-off-by: Mehdi Hassan <mehdi.h.business@pm.me>
> ---
>  fs/smb/client/inode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 1dbcfd163ff0..2ed1c79c1132 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2812,9 +2812,7 @@ cifs_revalidate_mapping(struct inode *inode)
>         }
>
>  skip_invalidate:
> -       clear_bit_unlock(CIFS_INO_LOCK, flags);
> -       smp_mb__after_atomic();
> -       wake_up_bit(flags, CIFS_INO_LOCK);
> +       clear_and_wake_up_bit(CIFS_INO_LOCK, flags);
>
>         return rc;
>  }
> --
> 2.54.0
>
>
>


--=20
Thanks,

Steve

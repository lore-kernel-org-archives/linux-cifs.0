Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC18149E18;
	Sat, 10 Feb 2024 05:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707543977; cv=none; b=JVaxQu4G3b+ETMRiZNpNYdOCZ35k7GByQsAAJvSJqWQR6CGPtPtJ1Z3ReWUf7/R4+gEhIjYIW+5zNwxleqEXnqFiCD3fgYwrztbKTn8UpbMT0h+ao+fJgM8HkDd3NZ6OAyYHff9R/WuHmyxqdrhJne8pbHiueBhBaJuam6Mc9hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707543977; c=relaxed/simple;
	bh=MBf5Zzij0GH4HLOFPObi1GK+7rUimCuiRJZFiQNYFaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kvz1au9EZQ96d1YldyoRx4cn5uUX0aPz+NrJhYpPPhuxakmq5z5hYq2YBLdSsHr31D1SlYZ6gCBQumG7CaauPqwEf9pbPOtVOjw8gMSlLvlu1RhmZFX5jQrRTc6y5wwpAM/O1SwWyrvvDSOz3WQbHugCkqsio5K9YFDvxdOWjcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j9+M5HFU; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j9+M5HFU"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d0b750518bso22721581fa.0;
        Fri, 09 Feb 2024 21:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707543974; x=1708148774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nr/YtxF3BFNZRWNv3aGcSVFM6dTYAIJfY7M0G8cUw9Y=;
        b=j9+M5HFU/7S4eYEH+AudB2+Ly2ZekQ3yZKqxsttKwUaUu4iWjkQhEU0XlhLbG7wv+g
         UwSS19FPKTkEYsW38sM4JZ3n83eMQbe8lvqd6al9EeIJvHSGH4R3R9cjLDFkjRq15YuS
         RMEEw8933iA+b8J4dku9MM9B6cuFgPvypGDw195EJnDtHLSn7kNTGA4plJmfX/QzYRlV
         iYVVsva7zt3viryHCGrmbaUu/cqbXjZ3xRu8koZyCRa9GLX9lqjZ0g7yARu+/zf5Pewq
         DsBCIx4ecgfHeDkGDZA4P1rBipgposniufjpg6xzw4amPuFu3h4O8Qsd4Shz1TajOLFX
         39Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707543974; x=1708148774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nr/YtxF3BFNZRWNv3aGcSVFM6dTYAIJfY7M0G8cUw9Y=;
        b=q1VKOqi1myS8WQIX/spsX4EiB+KsSU8i4cJ3nuNV/MYlL/AtjN7dJd/hNm90UHfTd3
         5eOXZAbkLFv1pkwJup4MU8vGogKLo8SiVagpQcu4rhmKxkppZb2FDSV8nGKQvAKRdtrf
         dJNDh9txJ3LLhRDQLKuS+JcC4QHHUWX+UgFUfY+xAOAUXMIyGydGELODd4N7Qadt4+dr
         jkBE9o5G4bpraWvO6w+MyZpijj9vxoTKWeGfz3W/1nc0pUaH0DjxbrtB8noxMc47s+hL
         prYsYYqR7KeWehTndJ6XPHJ5cnwiGGNZT7PlMFjL+Hi0VVT0Tq0r0aKhnrmDB2jyF17p
         suNQ==
X-Gm-Message-State: AOJu0YzgG6LoBcioe93TMicTKCkLh6HSiU+0jKfOsnGjhVJMAdE8L5KS
	J01CRXQyikr2rlSFuzZFyAGI3R/jxb0l2KSo5o9lGfOXw6P19IZTKmcRqo9kWMnySkkzHtTqZb8
	aRVNdY0xQIZ0U6Yn5K5tZbdQ5STE=
X-Google-Smtp-Source: AGHT+IERbHbSI2rDdP2RflyeCzz64n8ng6lhVYaUb7+Xq/lX3aXFdWdJpW24+zNjUi9SxE5r++8y5rHRrj8a3fGFDpU=
X-Received: by 2002:a2e:9ad3:0:b0:2d0:e2d3:37a2 with SMTP id
 p19-20020a2e9ad3000000b002d0e2d337a2mr570350ljj.2.1707543973804; Fri, 09 Feb
 2024 21:46:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <PH7PR20MB592590F74C734584DCF88D6CBF712@PH7PR20MB5925.namprd20.prod.outlook.com>
In-Reply-To: <PH7PR20MB592590F74C734584DCF88D6CBF712@PH7PR20MB5925.namprd20.prod.outlook.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 9 Feb 2024 23:46:00 -0600
Message-ID: <CAH2r5mue1Xgx+rotMta_Em03-E=wij-w_-i3eoj9rQsA-R9DPg@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: client: Reset password pointer to NULL
To: Fullway Wang <fullwaywang@outlook.com>
Cc: sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com, 
	sprasad@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, fullwaywang@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2024 at 1:44=E2=80=AFAM Fullway Wang <fullwaywang@outlook.c=
om> wrote:
>
> ctx->password was freed but not reset to NULL, which may lead to double
> free and secrets leak issues.

But no one else could use this pointer to double free this since it is
allocated in this function, and exits a few lines after it is freed
(and its parent is freed on the next line so the pointer could not be
accessed either)


> This is similar to CVE-2023-5345, which was fixed in commit e6e43b8.
>
> Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
> ---
>  fs/smb/client/connect.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 3052a208c6ca..fb96a234b9b1 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4028,6 +4028,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, k=
uid_t fsuid)
>  out:
>         kfree(ctx->username);
>         kfree_sensitive(ctx->password);
> +       ctx->password =3D NULL;
>         kfree(ctx);
>
>         return tcon;
> --
> 2.39.3 (Apple Git-145)
>
>


--=20
Thanks,

Steve

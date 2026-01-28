Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABA52DEA9D
	for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 11:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769599998; cv=pass; b=eLjcTcFivfFKXLOb09kHElM1kL/V1e2meO/iC6SMnwhx5maCHetG41GTpevnIg0XgETyHIWqfxTqfRUVSIalRxD51DDAJTcWbLUvAC3vQmOO8WBX0ttPHyA+etOeZPUmJlJ7tESUM0ELwZQ9yCVD1ccfplNC32mhj87f/B1eteQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769599998; c=relaxed/simple;
	bh=Jf9IV6TjsFbzC+hVKkIFHMb0l2+PLFOAjMrCEqOCULM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=poXw/ZHmQxTQWZN8eo2M22sNviHz6u0yawEErrIgvotwFSKkp7Y+aB75KwvAfI0qyiE0p/dFd+ZKYKyZHD0dW2p4thwS2wQzBzolsXThqH42Yczi3DiFdRbadGczV9JKu2FjQNgIl/0InC5ncDOMJEsG6S/PjX2kfo3L3fA4DDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bs8SPQ5B; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bs8SPQ5B"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so989918266b.2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 03:33:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769599995; cv=none;
        d=google.com; s=arc-20240605;
        b=D2XSgJ9nnTCUSBpuT0BZRNHwazo9aUDa/rIitcBI2RFbEK2jKAkRA7h6JqWuol6pUv
         lfwKx7grluNmTKFn6On+kGHUEsKfXPWenGNwNJI1OKE+gkpfAMHUkJS76D+jkERsqJlM
         Po61FJBGqYoOOz//0NbXzSCDhwZZhHUe7DqD8O7VQDfKK2NSFTmsQjyyYXDYYpyDmgwj
         xwjhw9mvg5Sd51Qbt0XVPIJIIUpoFCpdV7lVnJIP6/8HKjZgyo5TnUOO2qau2Slab1oC
         hqcJuqswbSW/g6BEraznssQ+zVc7q15ebpXqG5UAtUc2d6yjnR1qLrHug3Ap8zEmAv7V
         lYgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EmhMCmoAszEPdr+9RsUaeg+95/4OhviuV3/o+ZwYf4I=;
        fh=9p3h1f0GHYziLdR9xhnMGYoxiLPG45Y+x0CcCM4i0pA=;
        b=Qpq4Vr0njnqpl+I13G3u4uvZ0JNFpCdvV1+V+XIn2/0w6YfvOIZaioykM6zDxDeagT
         KVWoJFHNWkcLeECyc7FzEMbMb8QL853GzfGDxWxOUGl9FHQYqpfiiYh3gRx8MoFxK9u1
         LbuFGr++jsizpxADDUKQyjFAEKI/Iin9Kdf6qfeQHQ++EuQ7KQC43OKihGQFDEhMW2M3
         xP8awSVFXRRGpLSGbe96xrX1YnCJYMYsCshwD93t+IKHl8cM6zQd4xz/SRvIKCiG5ilj
         83Ik0tQe/ZMtZSCk8aaHQlNozI3Dbi2cxSXelXpVmjjsDe6TtG3Y6DnezBPeJLX6yJjd
         CT4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769599995; x=1770204795; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmhMCmoAszEPdr+9RsUaeg+95/4OhviuV3/o+ZwYf4I=;
        b=bs8SPQ5BV6MpUYg7rnUafPEcyNbupwakg1HhjOkqfbKtbwlAXaWW3JLsYmGNO/CkZS
         rXquAhE2M+CYdUWGxNR9KjhWvsIsJUFMP02NJQZgavyX8qwaOfpjQe13hoIVjus/rwRM
         0SbHKKLHFO94ENC3olrOQ6bKK99qe8stEcvYMUnL6+UOnpZ7NCady8GMrO91ELGxOd69
         EPRz0CdOE4TE/tKEDDztVVyAf1poFRQNdDXDz5pdto0co4vgb/p/1FWBPwHF+ZRUmPeN
         xFwU11lsNfXU9TU4ecK/fnRfr0CXZX/zA2gcU8E2CQlPqD+10Mo+gJC8s9LAFQOhXPsq
         hDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769599995; x=1770204795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EmhMCmoAszEPdr+9RsUaeg+95/4OhviuV3/o+ZwYf4I=;
        b=fR37pEAvEMCedo1BZNw3POIYg2M3oIzM1SORWiiMSUzGjtcEhnGCs5suJSBNGDcexg
         0UhgpEhgDXIAm7CNZA/8rE08RnLZ2zXKYQmGWVY3bOwO0dCzGhQkjv1xUsmIVZw9OZjT
         QnuYQSzohW6PJOiO1PcdiO5CFGpOM9iFZxwVT0DWnC/mI6L1VC3PRZ0u1KQPLI5xc/Fj
         uGMRKS6B5/6PYrYdoDzEiubqL3oyKPriWwoS8m677OGA4366i7Pbnksg9s4kq+YpT9yF
         DzGSOPXtL3/gPZzoOZRQVU4lNX8ZlXv3FsJhwiFfgK72cxWF7zSZcmHRlpscB4N50uF1
         aMKg==
X-Forwarded-Encrypted: i=1; AJvYcCXaet+8u+Na7ZQhUsQtEk2SE5nMQlZ/rESK5a3kHsqQg9QgBtjdq94US41VlU+IDkGrjOhN0bkBWNg+@vger.kernel.org
X-Gm-Message-State: AOJu0YyTi7UFTipHvdh+1k1zc/rGSSWEoQ2eZkizMhqoAXIVmec5pyOO
	HZ7FRMvVhBjpTmOo6Anl9bfh4jD10JxlI3n3QsFYmC6NHMvBSpcSbE1evaSe091XHBdfz4zIji0
	oFUNLRm5h+vimFFhkoyLHguXGANMBxfM=
X-Gm-Gg: AZuq6aKcxR2X53yeyBl3TwzgJl1bKPWsUqZd0Si+zhgmfEkexymqX2EruaIZWYSC8Qb
	4VC2jCDikXCvc0gg8vx49JphF1iGPSZdk+DDO+Wp6aRKq3R7yc9wLh656JDuvKfrJd8A8ZAyXrF
	gZZ2kP6ez/G97FcyfTCEYQw2WMg9RG2zB8Zalo71mWhx9EbqgiZV5tjb/GBfDNnDn0cC7AJ/KUa
	Pu+eNp5tEaJUj9ogwbRbhgGqh866IDNovxG3nASD0tfpLlZRF7SJPo2AIZSSJI/gZu+eQxlT17k
	+Y1i
X-Received: by 2002:a17:906:d542:b0:b4f:e12e:aa24 with SMTP id
 a640c23a62f3a-b8dab305bd6mr352887766b.22.1769599994921; Wed, 28 Jan 2026
 03:33:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260127160128.243441-1-henrique.carvalho@suse.com>
In-Reply-To: <20260127160128.243441-1-henrique.carvalho@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 28 Jan 2026 17:03:03 +0530
X-Gm-Features: AZwV_QgvuJK7L9ge-yU4KMaAK4rVyD9Lbxz2KZDznUMwa1RPPx8swzPg55Nxj4I
Message-ID: <CANT5p=q8trAvAMwVOczAuet2qFV_m0w9a9PJdJEtPhAsf5DGsQ@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: split cached_fid bitfields to avoid
 shared-byte RMW races
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org, stable@vger.kernel.org, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2026 at 9:39=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> is_open, has_lease and on_list are stored in the same bitfield byte in
> struct cached_fid but are updated in different code paths that may run
> concurrently. Bitfield assignments generate byte read=E2=80=93modify=E2=
=80=93write
> operations (e.g. `orb $mask, addr` on x86_64), so updating one flag can
> restore stale values of the others.
>
> A possible interleaving is:
>     CPU1: load old byte (has_lease=3D1, on_list=3D1)
>     CPU2: clear both flags (store 0)
>     CPU1: RMW store (old | IS_OPEN) -> reintroduces cleared bits
>
> To avoid this class of races, convert these flags to separate bool
> fields.
>
> Cc: stable@vger.kernel.org
> Fixes: ebe98f1447bbc ("cifs: enable caching of directories for which a le=
ase is held")
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
> v1 -> v2: Add Fixes: and Cc: stable tags
>
>  fs/smb/client/cached_dir.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index 1e383db7c3374..5091bf45345e8 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -36,10 +36,10 @@ struct cached_fid {
>         struct list_head entry;
>         struct cached_fids *cfids;
>         const char *path;
> -       bool has_lease:1;
> -       bool is_open:1;
> -       bool on_list:1;
> -       bool file_all_info_is_valid:1;
> +       bool has_lease;
> +       bool is_open;
> +       bool on_list;
> +       bool file_all_info_is_valid;
>         unsigned long time; /* jiffies of when lease was taken */
>         unsigned long last_access_time; /* jiffies of when last accessed =
*/
>         struct kref refcount;
> --
> 2.52.0
>
>

Does making them as separate bool fields ensure that compiler does not
optimize them into bitfields anyway?
Ideally, we want to protect these fields with a mutex / spinlock,
which doesn't leave us suspect to such issues.

--=20
Regards,
Shyam

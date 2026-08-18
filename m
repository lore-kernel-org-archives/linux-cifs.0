Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1933368D50
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 04:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787027848; cv=none; b=IHZGNZH1RgK4iA4g0L7fPh9MtMxs4x3UpGd9sEftATpfoFas9lZwO/oQ6NzegdkRUrvVCEiPen4LinCHMiTWga0mC4WyKLSx2s4/lUUNgHzPCBikFfnJYyOJOdTLK+/uU/1YB0rQ/VyiAtt/QqHbei4wZgjUqsqmC0RYEqNhQpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787027848; c=relaxed/simple;
	bh=XpCOb3jY/ok7ARQ9UbEJBrTEtcBhiKfga5GZhFprlAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XJG0goT92B70yE3jwdYiJZMXsfhLoFoe2h0WBVJauN12ef4qmd0PeRqU8CKdtsXdOvxDR7vEityDWeKYK61s12j/2T2DW2PupQuWF64Uk6EbqnUMiKOsn9Ai4v6Ae+YMKH5OPuGjVQsKfwT7GXHlFA+Yvg/0QGOzFCe6PilwI3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7BnNspe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7BnNspe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DF81F000E9
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 04:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787027846;
	bh=sczxPFZ8JWLEDYhAlmLJ+QU8o7JMaSpf+TkkozSYuew=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=J7BnNspehz8G9q8f+bXg4A01pScRoGEUaNjmOEnBMXPSsZpmGAoRBuFWGj6+TK7nu
	 0ZwAO7MGD/hfhlIkdR59RPRCEmWIsN+zU7pUy/ItNyl+SS12hHCDGETwLj2XaLesVq
	 MK3f2z6idQG3Hjh9S2A4ghBJ2KGiSQj2CEC+SSCyxM14gXHvdCZuWMCRDqNGJ9i9Kz
	 /feeUN380+fhQ1Dty7T7iYS39JxC3gb2S+ZOgac2kjKcMqC6UPThHfZTo9BoSR7jkW
	 h/knQym/TC1g3WKOVpimMyCQtYbVcwX8S/DvPNsfqAey4wMhjJzdYQE+lf+auv+jnz
	 mZIx828idq/MQ==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso5979290a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 21:37:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpe2S3K8XIucsOAqqD2mAM9XN3llfTSc27eCZx1NfcILDwcy9oZDs3sVGV9rl/xP4LZ2OEyK3393jzF@vger.kernel.org
X-Gm-Message-State: AOJu0YzR9Qv0psDzif1Y0SFv/Ic3/Y1oa9VhK4Znqwkx+XbE95pvGgbs
	AplEqhHmNS2tqOjAYp1shknsB6G+2tZ++ffAz4ZcTxadJgAq5OkgztyOk/YyG1aof4P+cqKzIYI
	nPB8eJD/iJ1AI3PtHNXtgAEXuX0R1Eck=
X-Received: by 2002:a05:6402:1907:b0:6a3:74c2:3cf3 with SMTP id
 4fb4d7f45d1cf-6a38a8f54f9mr14428857a12.6.1787027845175; Mon, 17 Aug 2026
 21:37:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
 <20260805051112.305078-4-chenxiaosong@chenxiaosong.com> <db018269-4591-4d37-8e6d-93a4942fde46@linux.dev>
In-Reply-To: <db018269-4591-4d37-8e6d-93a4942fde46@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 13:37:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Gf_BrtMAFx7Zx1MZhSRV_xby0KGaKfuj0v+uT_SPGOA@mail.gmail.com>
X-Gm-Features: AcwNN1X9IUFEerGvYKdzKObvEaF5Akq8rc7mqBfLb8hGJ6c5bC073mlnlMuF-fw
Message-ID: <CAKYAXd9Gf_BrtMAFx7Zx1MZhSRV_xby0KGaKfuj0v+uT_SPGOA@mail.gmail.com>
Subject: Re: [PATCH v3 resend 3/3] smb/client: fix nlink of an overwritten
 open file
To: hehuiwen <huiwen.he@linux.dev>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com, pc@manguebit.org, 
	tom@talpey.com, senozhatsky@chromium.org, slow@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2026 at 7:28=E2=80=AFPM hehuiwen <huiwen.he@linux.dev> wrote=
:
>
> The AI review of the overwrite rename patch raised two possible races.
>
> 1. A handle opened through a surviving hard link may be marked deleted:
>
>    target_fh -- target --+
>                          +--> inode X (nlink =3D 2)
>    alias_fh  -- alias  --+
>
>    CPU A                                   CPU B
>    -----                                   -----
>    rename(source, target)
>      server nlink: 2 -> 1
>
>                                            statx(alias,
>                                                  AT_STATX_FORCE_SYNC)
>                                              cached i_nlink: 2 -> 1
>
>    cifs_mark_open_handles_for_deleted_file()
>      sees i_nlink =3D=3D 1
>      marks every handle:
>        target_fh: deleted                   correct
>        alias_fh:  deleted                   wrong
>
> 2. A concurrently refreshed link count may be decremented again:
>
>    CPU A                                   CPU B
>    -----                                   -----
>    rename(source, target)
>      server nlink: 2 -> 1
>
>                                            statx(alias,
>                                                  AT_STATX_FORCE_SYNC)
>                                              cached i_nlink: 2 -> 1
>
>    cifs_drop_nlink()
>      actual:   cached i_nlink: 1 -> 0       wrong
>      expected: cached i_nlink remains 1
>
> I tried addressing these problems by taking an i_nlink snapshot before
> the unlink/rename request, using it to decide which handles to mark,
> and decrementing the cached link count only if it still matched the
> snapshot.
>
> Unfortunately, an nlink snapshot does not show whether revalidation
> happened before or after unlink/rename. Therefore, it cannot fully
> address these races or reject stale attribute responses that arrive late.
>
> NFS addresses these issues with per-dentry silly rename, attribute
> generation counters, and cache invalidation. A similar CIFS solution
> may be challenging, as it must coordinate namespace operations,
> open-handle state, and asynchronous attribute updates.
>
> Do you have any ideas?
This appears to be a possible issue, so the current patch needs
improvement. I will drop the applied patch and await a response
regarding this.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879896;
	b=Vu5F/V4/+SiM8M4E4xNlvwcbDxNIygItVpyKmk06iJa8ZTUdryS7DKxKIYyRZkaojP8U
	 jslhUQjv2mLeT9ZxBy3KyBuw1QYt73Q2cczZpm6B1wP3KmIWWRsr6KAbjmiDpNMVkpatZ
	 EWZ7ZBq2xGdMHHi0js/s9+vMqlb6v9G+/avDiiOejY3n1VwMtYptHQNt7h56lXhWAhK1r
	 MTPtEEcT9sf5w2605i379oajKOyqNvC7l7gTq+fmOTyOZLfI2AX7J6Dt+uD95LCvW55Gy
	 SK2xGAE21j5IcNlk3WK8OYyMh6QN5XSlf0y5ZZqxFHuNbfOToupEMLRaO/bIh6CQeSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879896;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=zBByXkNjVCE+LBHCR7ezhTaXQstt0LGC/bJIB+BFpQI=;
	b=zeVYu3kBcy0JetmWCf8EdE2kwBr/im87z7ct2dQLy7wmWkBjikpRCLXK7gVkpSy0Revz
	 o7cOUnH1jjN5Wtq+pipCWDRKqaL54x8QAlPOHwb/YmZzChwcNjxsEhMRNVglzy/1i5sux
	 jXiXc3hEHLwe2A9zphS22DNS6OenWvvyKChARgY8T+M1255iFrskWas0jVHVBprnuDA4Z
	 OMJE5J57uQ9GNSPHU8G+qbJaS2LbvB7qYow4yh0ibOSx5uq+m6cNiyL/IG9cYRcUAl1Li
	 BWz+TTwNjZFZ4aBU4FRDjf66duKRO73YtqLYTHdCmnAjuOXz3arhrbpTL3CMYzk0Kcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W1ljF0wo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFAE606A33F
	for <linux-cifs@vger.kernel.org>; Thu,  5 Nov 2026 11:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W1ljF0wo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2956F1F00A17
	for <linux-cifs@vger.kernel.org>; Thu,  5 Nov 2026 11:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879896;
	bh=zBByXkNjVCE+LBHCR7ezhTaXQstt0LGC/bJIB+BFpQI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=W1ljF0wosvH1izZK3HIyyKMPS5Nl7Fo7AEZF9nLeRoL/nKfwePwoGhcP3cO13i5tt
	 K+PUL4PFr4udMC83cGKKjMr95u5F6AzyCFfgXmQwohvdyHJOb8o0v0L31qd4X8Q3YS
	 D84D/iJ2MOzYNBOxKr0Ue6tJCGWdPu2P/UCDDOMTZV/DgaNvOJZwMu+TMhs6DWycs7
	 ywqAr7SoMLXbegyQGmA4NVfAa7Qez7SAqekGZVKKuCwHNmKGhZyAsiDoMRt/E3FF4i
	 HxNTj+/zd2QYAjKzHwfDFqMcaLp/u4WO32FNoTqPqpziosA/9rok+DLCoyDXqwC64K
	 0WBpB7ohqvFvA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b566cf56c1so1479216a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 05 Nov 2026 03:58:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwuR77wRNioL7kiXMXegNAKB58398B7FN/I1KAM8/zQDhhG2Ko5jXZch05cVz7Jolb40i+bvf6tVELp@vger.kernel.org
X-Gm-Message-State: APuU4Z9XgNgkMcKcuwzVwDpw2sr7CKAJtX8Li3fQ9ipuYJrqhPXxkld1
	y8JqszeXS0Z6I+MEEMyCuYYUdJrKJPVXA1qrtmCutxtDkao8NmDY6qjXFSXJ/7JHHYmnL9hObrf
	62iIEZA1WrfBTrSjE8Z8qeesBewYe8xo=
X-Received: by 2002:a17:907:c5ce:b0:c29:5d41:dfe8 with SMTP id
 a640c23a62f3a-c4ca7ae82f3mr1627888466b.43.1793879894694; Thu, 05 Nov 2026
 03:58:14 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104183702.192452-1-icb@fastmail.org> <20261104183702.192452-2-icb@fastmail.org>
In-Reply-To: <20261104183702.192452-2-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 5 Nov 2026 20:58:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-a+UH4q65J9K4e=EscH7tkHC+eEu_HC_oEeVzBdi0Kog@mail.gmail.com>
X-Gm-Features: AclHuK913ysvhcNOT2S1DOx1NkImFakA1bWuvLx5kL8RLaniHar89jBvPmRxZ78
Message-ID: <CAKYAXd-a+UH4q65J9K4e=EscH7tkHC+eEu_HC_oEeVzBdi0Kog@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: skip metadata-only opens in sharing checks
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
> index f9fb3741ada3..920e94017bf6 100644
> --- a/fs/smb/server/smb_common.c
> +++ b/fs/smb/server/smb_common.c
> @@ -719,6 +719,15 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
>                 if (prev_fp->attrib_only != curr_fp->attrib_only)
>                         continue;
>
> +               /*
> +                * Two opens conflict only if both hold a right in
> +                * FILE_SHARE_CHECKED_ACCESS_LE (MS-FSA 2.1.5.1.2.1 and
> +                * 2.1.5.1.2.2)
> +                */
> +               if (!(prev_fp->daccess & FILE_SHARE_CHECKED_ACCESS_LE) ||
> +                   !(curr_fp->daccess & FILE_SHARE_CHECKED_ACCESS_LE))
> +                       continue;
> +
Could we account for O_TRUNC in the access mask used for sharing
checks before adding this shortcut ?  CREATE requesting READ_CONTROL
can still specify FILE_OVERWRITE. smb2_create_open_flags() then sets
O_TRUNC, but fp->daccess remains READ_CONTROL, so this condition skips
the sharing checks even though the request can reach
smb2_create_truncate(). For example, with an existing FILE_READ_DATA
open and ShareAccess=0, second CREATE specifying READ_CONTROL,
FILE_OVERWRITE and ShareAccess=0 changes the sharing-check result from
-EPERM to success in the extracted-function harness. The open should
be checked using an effective access mask that includes
FILE_WRITE_DATA when O_TRUNC is requested. The client's requested
access can be kept separately for the returned handle. This would let
the shortcut exclude opens that only access metadata while still
checking opens that truncate file data.

Thanks.

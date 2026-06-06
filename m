Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A2E317174
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780743939; cv=none; b=XuBp2HtHYEspHjCDWG/ObAUWIBnkjH3/+VwXZ5Y2BiuZ7rEkkchWmLV0sTI7/IvNM4XCxbbEWoicnjr5yB2+JpoC90OoI7PglzcTBbJvA2Pop2z4pqwXvItgn6q4RsgCBZVhao+IP9DxVSNrP/kcGePcURG+C2CmGhYF6hfoCJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780743939; c=relaxed/simple;
	bh=zBgNPKFYb72WBAmcZ/eGCm0rwtXPx4lYMk6BqZ4so0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gj8dfpZ9ysWVf58mPgD4702bLpz9OwviBuIdplNnQlwCvLm9FJ6v+1twPABpkR1edwLQG80rhcWM1h1qLSjxWL1NF0yibq5aRAPPhZXVmr3ozA6YHvrfZnk3o8VtIwz54Pc0HQObAPAJvo61jiWEkoGDgSr405BhUbZrtt04RBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJX5Tey+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJX5Tey+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461D51F0089C
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780743938;
	bh=zBgNPKFYb72WBAmcZ/eGCm0rwtXPx4lYMk6BqZ4so0I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PJX5Tey+nzEwPYmz1WB/yYxguWwTIlwLCu241P4UDL3xO00sCXgbt4hesf2+CzuQF
	 72HYwTBz9NRtEQ1RxUYPbN3tYEuIAj+OJy7KhttE9ACBKuCKcOCI7iogTMLAZdkiAh
	 +/KGqccwY9hNaWQ0FGdHMF6JUSxQUDL2GxNzLqHUxftnXtjH0Z38GvH8i9zzmgPvb0
	 5lthCEptdBKvwLEcqbEg5+639cVHwXE9D7x4vMkBwd9Xsz5xA3wncAPRkgooOYk6Oz
	 uuTuJYEugIGlchvbRPPjo/oDuoCJufLDgb5Yzy/6Bmupp/3TTbeKUaG9YqOjaRJ+b0
	 z16j8Im1HTfyQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bec49f7e35eso374090166b.2
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jun 2026 04:05:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9lVGfOmweomTc0WQPa2g0eUORQuaUm07FWP4OZsY5FdhIPc4WfuKCDk65c9lZiXDDdne0/MjVnWwas@vger.kernel.org
X-Gm-Message-State: AOJu0YwTKWqCMOHCEXlJ0S5jJOU/nKB2VTL5Ds6D+PVfc7kqHoHEhR0R
	QfuRojulOy6+DGzz2BNr45jalo/hwmEg5k9hL8AzGEvAP73TlThocqo3FF3gI1jgdXa+SjsmId8
	zVPqx4dJ2nLigB39XLq2QN1Hc+oYAUp8=
X-Received: by 2002:a17:907:d7cb:b0:bd4:8b86:9026 with SMTP id
 a640c23a62f3a-bf37234aacfmr373434166b.25.1780743936834; Sat, 06 Jun 2026
 04:05:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605043016.1440866-1-lgs201920130244@gmail.com>
In-Reply-To: <20260605043016.1440866-1-lgs201920130244@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 6 Jun 2026 20:05:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9F3DeWfeoQfw-4PuLXcZCYxSXYwhmRM7yqECZcs4ML=g@mail.gmail.com>
X-Gm-Features: AVVi8CclOthL_THREkZCnreQHN0klQjyhXLBvnCW78QO4ksdVPHpjFKsjizMJWQ
Message-ID: <CAKYAXd9F3DeWfeoQfw-4PuLXcZCYxSXYwhmRM7yqECZcs4ML=g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free in same_client_has_lease()
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 1:30=E2=80=AFPM Guangshuo Li <lgs201920130244@gmail.=
com> wrote:
>
> same_client_has_lease() returns an opinfo pointer from ci->m_op_list
> after dropping ci->m_lock without taking a reference.
>
> smb_grant_oplock() then dereferences that pointer in copy_lease() and
> when checking breaking_cnt. A concurrent close can remove the old lease
> from ci->m_op_list and drop the last reference before the caller uses
> the returned pointer, leading to a use-after-free.
>
> Take a reference when same_client_has_lease() selects an existing lease,
> drop any previous match while scanning, and release the returned
> reference in smb_grant_oplock() after copying the lease state.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!

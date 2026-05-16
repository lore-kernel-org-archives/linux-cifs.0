Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6FE2FF15B
	for <linux-cifs@vger.kernel.org>; Sat, 16 May 2026 06:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778913822; cv=pass; b=C1D2f5/1a1rfHtX/iGXJ6iQg23ukxReqeyQpD8jC/JPezUb4c4TbNNQCuYB5EDYjqY6ze5wgzoqCO7jX6xeurA+sPP5+Uaq8NoHTbjoVLGIEY6csOorPYQXk/c7Em0IzVx6ha+I9bdxSuNe9Ck3YIUo4LPerrUrNFy0hLUE7au8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778913822; c=relaxed/simple;
	bh=BOu7AkGfzBlU/bzal5lpBXqw/o4zx+y8OCCvr0FI1sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OPSnCuWRE/WSkGoDZns8U/AZZmtiwfgVdEcXdgS2nGtuTRFNSaKpAavNNolclq3WclqFH72UEk4OG6+qzX9oELTvg4QFhj8Xrdy6xhrGr9sWSMN8PVnbrJG2mqn6a9VfKBs7aEpWbqh2tpXnnUGCaak7T+8N1r0L4u/F3WGaWoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lte6xRJp; arc=pass smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lte6xRJp"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-47c6f914617so307761b6e.1
        for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 23:43:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778913819; cv=none;
        d=google.com; s=arc-20240605;
        b=lV9lAW00ELaiHINqhCrbf/kZuYxARggYb3AHxLCist5ytUP/IDDdfwFN8p69Yg7EKB
         S0vNSTUvJl6lSm0MOj+UsW+9Gv6fEO5yEunaOREWh4qJ8mVyFXtCRIlIh8mAkRFcy8Qq
         7WcWHpV11tLtrx2aro/+3oiyX9vMqIT97Eo31dUJX0EsQCuhh9zkyL0VuKWeMaL08mfM
         rhIS8o0RTQIRXxfSphg3yXaAnYRhThl9/BJSmjmgF1H0uhBpy3wFmIHzXrGIj5IDhWab
         tlviv226lW85uBR3malBa3TvoYP5aQzxid+YtGj23pr0Kiqk0NGjBiF5XyLTVAF0kjHN
         e11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        fh=qRKljhmpdcLaLFwbLV4yFZCY7SxlEX65H/3VZ4Ziz6o=;
        b=PnU1VL1QeJtNB7Oa9kj6CcYAu0rStI73X8TfvQOYovVfiGt6e4f962dicLejfK1mFC
         E1XONId2jZTorkgtYHAc3xs8YynLvH3w1yekTMXgmXBbEHHPqbce1NGN+CYXpJd/vKRw
         unrlUb7n7UkTcoBioDXeU4u1QpmP9hUhQBulPElVqieyECPC3V+e76IavZ4JTj1MEr0d
         zetPGvDSiKlsLlSJvWMsNsKnrtYzCrfqWoyeB4xSgpROBark/4fKFiZjv6LbtpFhYXuN
         9KlyzGxBMtpqKgDQAR7ntzFccnlFTa6AxSOvTTQhBthxRKQFTUjCQcIF6r6y6Jq4TYYG
         kTZA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778913819; x=1779518619; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        b=lte6xRJplRGmp/PSskcPRMRcmRHxp/3AN6A1XynLI6uXZlluhAn8u2h7mZQg7APZLK
         oAbu6jVFzk3P9a62b4PsoqoTNSJkE7FzjLFpOPv5Z+lsxgwuhtlVTrcbfv9MbnmVX5Py
         k/kzYjGMlhm8+gRGJfuzaDpFjgrS5WI83cFpH15WHsjn/iy/5C/Ve0iDz9Octg/QEDrA
         DhdqK6z9WrgQK213b5HL2plz3FNcI+orhuzLw1gTevyVgHFRj7CbGxDhPlje1LF0RZp7
         KU79gd97VCPt1LjtMq72jZt/AsJhd9asWIZ2PtbrgPLo+/sBoYkMDD8j7+KHYkro1zzO
         kN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778913819; x=1779518619;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        b=tAkIze0Vj9cTt5iBKB8dPnag3fLP9zHpAceiqxohTKoE1miq0NfiwTict+wfCjREWv
         9FZ+QUgSDQ2ksLUDFlu+V6qEv433mzSHemor3OCwGYS3OCurYyLoczIDmd7UbLqZ4DR3
         SG29FZcWqspHvEOk0SvG73olgTRgMHNsiI0/m5Hqf20F47tKdEaCvhRjl3ga0PDOtLrH
         tX0U7veRogPgisN+thWpnZfojaO30oroCzzS7d2+fNN4AUzv7WHrquLtAom4KPnt/B8n
         gbXYJymOb6o54P4paBW2BGjw/rD0qm9ez3fJ6Q+R6pJvx/C4YKLbH17OuW5JAYkK/AI/
         ZaeQ==
X-Forwarded-Encrypted: i=1; AFNElJ8CZbDGAe+mgyFQZIC7ovsuE14jc0PVwhjrcN8kYtsdYrmKXxQVhsY6kc023Vkc+vpwVCcrMciPkLid@vger.kernel.org
X-Gm-Message-State: AOJu0YzfhnAcoQir7bQ8g4M0LdOhuNuGlP1aIb90fK6AVGn7dTSFwvlt
	7jmXrowFn+TpmaA5mu//J0sXVvSVar+pbLkvzn5wn1TwP3C2NRiheicBRIHgyndc6lNAlKFx7Di
	FfJpXfUjctQo7hpnoDlfodYIvoBf8i0o=
X-Gm-Gg: Acq92OGK6SOF43ZQgeQBXCj0QisQ1iIoPZIEgh6DiYrOzAxFGagQC0OjDFaHA/GnQ2G
	IbqrYM2cMW2CElPSkSv56n8Agn0YPC8JDtMZNWw9tHA+xGv8VcCIWHZoVg7+pcIXSOtpYb2raR6
	LU4Ky6i6ynvQ1kKW5R75/eTFFATTwGVLqHO5hzt0huMDfqvjUznhwWzI90qAxBu/3yY9TOnwwcV
	Wa1MD7jxVuro3eJFA8Z1M8K/WOTdWZw45pd5IjC1xZkKb+yjerXqjI/HLeGJX4eAIGuqWVntxkg
	Vfq47g4JlPIh1BZxFg==
X-Received: by 2002:a54:4e88:0:b0:46c:e542:cc3e with SMTP id
 5614622812f47-482e55e65a9mr3386045b6e.6.1778913818672; Fri, 15 May 2026
 23:43:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507-case-sensitivity-v14-0-e62cc8200435@oracle.com> <20260511-wertverlust-vorbringen-070f016f3bd4@brauner>
In-Reply-To: <20260511-wertverlust-vorbringen-070f016f3bd4@brauner>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Sat, 16 May 2026 08:43:00 +0200
X-Gm-Features: AVHnY4LulXSgBXmlt-XknhPT4FGQR5_lEWwUy9GN7jO6BYSv7kvOdT0vcpcWCyI
Message-ID: <CALXu0UdsurG-ayuYViqs0HXOfgyDw8gpNC+f=5y59cuuSPUbBA@mail.gmail.com>
Subject: Re: [PATCH v14 00/15] Exposing case folding behavior
To: Christian Brauner <brauner@kernel.org>, Chuck Lever <cel@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org, sj1557.seo@samsung.com, 
	yuezhang.mo@sony.com, almaz.alexandrovich@paragon-software.com, 
	slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
	hansg@kernel.org, senozhatsky@chromium.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Roland Mainz <roland.mainz@nrubsig.org>, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 May 2026 at 16:11, Christian Brauner <brauner@kernel.org> wrote:
>
> On Thu, 07 May 2026 04:52:53 -0400, Chuck Lever wrote:
> > Christian, let's lock this one in. I will post subsequent changes
> > as delta patches.
> >
> > Following on from:
> >
> > https://lore.kernel.org/linux-nfs/20251021-zypressen-bazillus-545a44af57fd@brauner/T/#m0ba197d75b7921d994cf284f3cef3a62abb11aaa
> >
> > [...]
>
> Applied to the vfs-7.2.exportfs branch of the vfs/vfs.git tree.
> Patches in the vfs-7.2.exportfs branch should appear in linux-next soon.

@Chuck Lever Thank you!

Does that mean the support for case-insensitive filesystems will work
with Linux 7.2?

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur

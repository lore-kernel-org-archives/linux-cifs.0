Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61C243E4B4
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 22:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777501498; cv=none; b=bMDD0C0K1iofIRj8cYXq0lEGWooQ/TshPJoSqGu+7OifQhkoZI9xm9hGHlmTfCvuBheU/AF5+GUkFovqdKqzNqDLJdGAap2SKNEdsFqLDdcD5Y+TL8kd0bbOfASN0NhZD9S5A6rFzAaPrJI0hYSR5u8sT7+Gkp8ZsU0PuBOVSvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777501498; c=relaxed/simple;
	bh=xIfHJBb48fVEuseQp97kVeiBOG1LD9sCELZCrDi/oJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Iwpkk7A7u8XQh2Yrxqu95GHUyF/kh6/5QBe7AIkqFpyP6BfuU+8bU8WwNyCtx9zIeUmVnIK6NNV1d5IKxRUMpMlicWKA0Mse16LQsepvxLNKc1twbAhHAvGaxn+qKz29ViA2Y5q4AlLvMrFX2p8r49y0u59Nw0oa7Jk147apRqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbPqrk4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbPqrk4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68313C2BCB3
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777501498;
	bh=xIfHJBb48fVEuseQp97kVeiBOG1LD9sCELZCrDi/oJY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KbPqrk4YxkNAuhoqECnCgYttcx+43RCMIUao4o59HTaj1cwe47bBdjmoQ932UrvZB
	 OuFbv1RdAAIF+78Ihp8zPZxR7qqj3w8Dw8JUeZOB+q9t+G5r2Xdxy6Es2d7r1ClSn2
	 6CMA8SW8Z6X1sP++6H2GjhYkQWm75z8/ZnWFo87hfpUtZ2Yf36Eso7Fbqci++r/6rb
	 f+k2jH41Pt/Ep8gMTJ2HB+S7Hb0s75sH40YnIotihsph0ljUc6x31WvGjqNeATlhXa
	 QEFvTjBLXhIckUTqOT2DkAAzjbNJrTz26b2yfGVR+wYTJGDILknr5T0D1lyl5pedD6
	 3fyaOM3hU7HMA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b93698bb57aso59156666b.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 15:24:58 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxw51r8NzxFFaq7o/SKo6ST0NGN85mZFe2PyEEmAKyYOgVilevY
	pkpDf+Jyjgefq2y3C2aZIhZiepPeVN1IQaKCdBT+5QLhXiGq6Nm+B40vuF1PgfNb0h+SmWwan92
	/rYmRQCwF34QWHUD96VxmvvMwrZnyvpk=
X-Received: by 2002:a17:907:6090:b0:ba6:4eea:c1e1 with SMTP id
 a640c23a62f3a-bbb3e64c6ecmr5787466b.17.1777501497033; Wed, 29 Apr 2026
 15:24:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428155759.226368-1-henrique.carvalho@suse.com> <20260428155759.226368-2-henrique.carvalho@suse.com>
In-Reply-To: <20260428155759.226368-2-henrique.carvalho@suse.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 30 Apr 2026 07:24:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8FOiVgmMDaAP+AcUb_Msjf476ennF_5CUR++Shpw7StQ@mail.gmail.com>
X-Gm-Features: AVHnY4LxvqEW85XE0mg3532yHZLNYSVMOdf2hw8w-QWtodP063BXSotiJBfbU-0
Message-ID: <CAKYAXd8FOiVgmMDaAP+AcUb_Msjf476ennF_5CUR++Shpw7StQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] smb: server: add shared transport helpers in
 preparation for QUIC
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, metze@samba.org, 
	senozhatsky@chromium.org, tom@talpey.com, ematsumiya@suse.de
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/transport.c b/fs/smb/server/transport.c
> new file mode 100644
> index 000000000000..0a99fb821e02
> --- /dev/null
> +++ b/fs/smb/server/transport.c
> @@ -0,0 +1,344 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
You have to also move the copyright here.

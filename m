Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99421AAE17
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 05:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774415033; cv=none; b=KAw2og8fuMgAt3rtAygNKl16rszLZW0mFZBHwRUMWU3wpZ9zdk6TO6PiG9NufhH33TSascxHK8UUEpZKibNxVTKBVbMXZkBvtN8oCHqOj7pk9Ptocj8FuZAk88m0sHmpgE/rNAr05nXxk8J+geKoHvU3xLPVRGQ5mmwBlEobwVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774415033; c=relaxed/simple;
	bh=TaKzSCaEcBOZWzn3diuAJguQa0NcA/HFsi2oFovUDVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZMvQQWz7JsjgpxX0sdYz8Telic//W63W/OXkvjmvKVjFJ1QtLgk2WNQy20ZrZmbkoQaoGDiFGgVYa0WpdjBzueKKsfoeT1OJ9U4t0ny0l44+m435KVyEb01E0QaKJBGnaiBAp71kKWTTR28gfaZ4LMLQBacpxtXr4Km0oIt6dXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDWuZ7GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDWuZ7GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D809C2BC9E
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 05:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774415033;
	bh=TaKzSCaEcBOZWzn3diuAJguQa0NcA/HFsi2oFovUDVA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EDWuZ7GHJAAyhTU1agkx+pLrEK0yT2YCFANwHP6bxozRKWk6WGok5ZAf6cRB31G7L
	 510vFNp9B1JKeKZ3S5mKNTlHFiTgXJbPq6YMw9LSQkUPR/x7atyfzfo0p2LB+1Jcw9
	 q2806oXoUxLK43knwMV0rBUtSoPWV3St+sPHQ9q/tsMOqRmJg2JIAELYzTCRboyuxw
	 W+3vs7cXspz4Ec2j05KPdMzCvot5Rsj48PqKa5OswPhko+99ZcBQPcdkVzYw3Bdld2
	 BTPVZQOpz/PkB3sfpWOpU5ytGmdFbjGBNy0ikFDSTJ+TykjwABMiH+zruxhm1TT3Pw
	 kXmvGqMJa76Lg==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-668d41905a4so7220750a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 24 Mar 2026 22:03:53 -0700 (PDT)
X-Gm-Message-State: AOJu0Yysiw2mr7fPlTaKh5pmevEuH+oL2lz1OxzzYAy466y1nlYuhMl8
	6fe3CEwSkvWqxLxSI6wP6efkIgcfVIltA2K0SZ/Lc96MFGKvaDBTzln80frL+kIvgnfX4xPszG1
	PTpY2wvbsXBniMg1EPUFbQ+qxQMSU/jM=
X-Received: by 2002:a05:6402:5059:b0:668:1479:3c72 with SMTP id
 4fb4d7f45d1cf-66a826887f5mr990181a12.15.1774415031963; Tue, 24 Mar 2026
 22:03:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306063522.439782-1-rosenp@gmail.com>
In-Reply-To: <20260306063522.439782-1-rosenp@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 25 Mar 2026 14:03:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9KdSNSYgAqAtuzYKRar9icNk3QU+1V+NTTFsaSJyp8ug@mail.gmail.com>
X-Gm-Features: AQROBzBmtgGQoPpktC-KU2DaFUNDJxC8HA_xgJdKWI7gFsdmh8L7GALjo7Pc2H0
Message-ID: <CAKYAXd9KdSNSYgAqAtuzYKRar9icNk3QU+1V+NTTFsaSJyp8ug@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: ipc: use kzalloc_flex and __counted_by
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be)?b" <linux-hardening@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 3:35=E2=80=AFPM Rosen Penev <rosenp@gmail.com> wrote=
:
>
> The former is just a nice macro and the latter allows runtime analysis
> of the allocation and its size.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!

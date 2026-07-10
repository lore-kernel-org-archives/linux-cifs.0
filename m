Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937661AA1D5
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 00:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783643057; cv=none; b=uHvTiATvMPPt50qtKakRCTb4fzTQw2YUXVsrfyxnoy1wXaLpBtO++5kZ9eZnC77RnExAgbyW7oiZuOpp+1zroCVmQgtwaJdUW9hs7oLC/qXj98KbEAH5IShj0YLxvNwGjThMEltgB/b5xHtmhLGRqTmCFrgZIrTARAMLaYoy5sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783643057; c=relaxed/simple;
	bh=O6k1qml9pWcmhW1KkYueYBLRzuMpvvQ3csMClNjdyAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMbpja6H9kh2Hz5r1C0rNV+Ap2GshwedHELNRsWoR+hKm5sjtYPjjiBvPMw3MqKaXziYx5ws+Zalq8qoUPr43o9w4tMvuNcCMDlgbcOyT9OXYnnw/MQnkFE9zsxkVhX5OdoTA8rRA8iRl6yV79uxPJoPM1pBSxIwoK/Jer3aPA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ti5KEzI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ti5KEzI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB1E1F000E9
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 00:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643056;
	bh=O6k1qml9pWcmhW1KkYueYBLRzuMpvvQ3csMClNjdyAs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ti5KEzI5lWnaj96KBcsld+7owpN8uc5KwW2F2a9cheCzwYBuoAE1NEcQpjEd9HnkM
	 dUx0eBnNASXVrt4a4byFphZ5oNRSYy3r/kGg+9EfYPKUIgyJN5eI7klfZaQw8gnhyP
	 iG7eyOITObuKL3dLTNNTgnnqLS2uYIBwcxilBmuuihDgwO9U4Z9DLFVsarfPBcB7ka
	 ektXETFFJzlfjXB/uNJ5Z/8ydO6Kvhr37MKNoaOClZRMWlowqeoXD3r34BPVl8rkzo
	 i3qkduaKfZexWbuR+4QvXnuTkYWk7H7Ikk7bmz2JR+/IVPSy/niP33am4MG3L4eleQ
	 FcEPjpTC5tf5w==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15f020a223so57402566b.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 17:24:16 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw1TR8OI22MsKia4/F2qteVvKDhnrxAm2XCeVYJB9SmQr3Gb9DB
	F0d7zPZbPY9JrW3xBWEqkUOPgsawBmdwqBh1Vi5iHKzDmUERlD26l+LwXKQk/T+GdpO457Qo2SI
	oBwhGCHo+M6edAZsuRSOFmGMqExzCXLc=
X-Received: by 2002:a17:907:a286:b0:c12:6f98:d6a1 with SMTP id
 a640c23a62f3a-c15ce133324mr447986666b.62.1783643055162; Thu, 09 Jul 2026
 17:24:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709165141.2111-1-g.blivet@me.com>
In-Reply-To: <20260709165141.2111-1-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 10 Jul 2026 09:24:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Sxe-+pCAd+BdT+mLHFVSn4jtGyydGYnAVsBdeTOhOKQ@mail.gmail.com>
X-Gm-Features: AUfX_mx6NqY2WX3L1Qys8ccwTe_JzkwBScW7H2aja8ZJxXu1CNlwEi9rf_6Wlt4
Message-ID: <CAKYAXd-Sxe-+pCAd+BdT+mLHFVSn4jtGyydGYnAVsBdeTOhOKQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: protect stream_del_pending with fp->f_lock
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2026 at 1:51=E2=80=AFAM Ga=C3=ABl Blivet-Bailly
<gael.blivet@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> Follow-up to commit 36442851a4d1 ("ksmbd: route stream
> FileDispositionInformation through stream delete flag"): fp's
> stream_del_pending is read and written from three call sites
> (ksmbd_inode_pending_delete(), ksmbd_fd_set_delete_pending()/
> ksmbd_fd_clear_delete_pending(), and __ksmbd_inode_close()) with no
> locking at all, unlike every other piece of shared per-handle mutable
> state in this file, which uses fp->f_lock.
>
> A FileDispositionInformation SET_INFO racing a concurrent close on the
> same handle can see a stale value and skip removing the stream's
> xattr even though the client asked for deletion.
>
> Protect all three touch points with fp->f_lock, matching the existing
> convention (e.g. notify_pendings).
>
> Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
This patch has been combined with the "ksmbd: route stream
FileDispositionInformation through stream delete flag" patch.

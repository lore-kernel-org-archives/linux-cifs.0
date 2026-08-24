Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3261394462
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 22:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787612369; cv=pass; b=TQq5HmMuSoop+zSa8LAa05lEeXRu1b4BBQdHAb/6t26r4z2gegY4Rji4j5E0KULJZP7VnjTAAA3l2BeBfrmcZvIv8hK/vHzieQwvhFtpwZ8cVL6YpEZJTzSKioZmZF9LIFUAGUi3YjSAB9LObF1HeOYL42Bo9rnuiua1IFGtyuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787612369; c=relaxed/simple;
	bh=H5WQPLM3TWuDH/w/cIHS0rP5Jp+p/a7IhOVTg2eSsiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egcBx5/lN8j/4LQhQIAJqpTsWFajWEQBjvUpjYxtMtPGuXe5DZKdCCqESoDAUYuMfLzADU4aFxw0h3Uc021kEKMv6aDZj0BNAjs1cOHPE3GgNChgCJNn4/Y3OuzKRRNaRmAXct6N9IPtWyDYV/jL9unSlFsbn9V74aroUqA0tiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P3vrQXpx; arc=pass smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3vrQXpx"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5c38565e774so1231758e0c.2
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 15:59:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787612366; cv=none;
        d=google.com; s=arc-20260327;
        b=hE5wEHJfOlrtnzy78d7CgUJno29hiCfj3yJUsUn+oFdOpisp0IhBoyF+0D34TXAHds
         Kf/dtf6NpuE1IXu0a+CBKgzaKOPFclwGr6ZcytS+0iYb8usTyyqdPPjHbL/1Z2p0lAZW
         kl7Knzonc+hBgVr9Y5slktkqrTwDG+7ggBScPN5r1bRv+VgbEC91et2SDxI7D/Xv/VuE
         1rmmPhDenXkjAVGxL2++hXaP65l6F2RDWxWoTLSkjNCXac4v+5Y98Av700wNKl87So4Z
         mk3DELVUhl8Q+kvBLJF78HOImO+T2SyM8dHuGXEpoK+4F90o6rKABtHzzzVz8GejcKVA
         swzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tPu9pxzASDKV43KWGJWVv/BzvjZAzn0qJo8d/JiRNus=;
        fh=2WbamjpN2xExOvwdgk/y3KqJUiDfusRyOTflvspaiZM=;
        b=qWl7YjI/BaMlaCjhbju5Tf+k8i73ZJYF0SpBaU5w6h7UD1ocDwm/rh+JOXinQuyK9L
         syfVhKf063p84OsZ1u+9ZEv4o+xiRWg5VaTZrn/0OpAhakJqb2Qn6Y2o/SrC9FakTK69
         1YHTNNx+iGu6PkTecUtr+uHepDn3nPjEk1qh+vCv4QUX6jR2lzer6mjewIESkq2mvDei
         MQKKNnKMoujTvrhXAgbRSCIZ4Uaq2esPPeu/RBpHRVFckb6Q0xb0/Bb4pszGJCyHn919
         mVOZPmdwGvvxHQyFkM+qjlhsY7PsJC6UQfaZ1SJzYbXNU4p0ou2ORR/KWXwgPpCaEdKB
         WRDw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787612366; x=1788217166; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tPu9pxzASDKV43KWGJWVv/BzvjZAzn0qJo8d/JiRNus=;
        b=P3vrQXpxEzaufdxweFIJD+snfFOabpM+K0J92mru5BS1XobgJpbfdXXcPVvaUylOFd
         nSpooHnw8KwCAohTqfJznrvnGfDW6P9Y0aCa9XERXQ9OfA3k2VItbKoooAp0AabpSmwR
         UvI0Mss2ctlZUPahGGLiIbJKVY4hwgdK+jZtAxMShB7miBaCWxvnqm+8iQzpsZlkewE3
         QjNvee7LJHIoIfwDx6NExD6xt7VMZHpszZyg0uAlS0opspyw86J27Q2RvwP76HtbeGsC
         aGMX58yhXxeGkOrws6+dkzd4vVP6UFMkVcBHEca8x+kkXXkCeCKJG/5ByqixT1KRkims
         Mb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787612366; x=1788217166;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tPu9pxzASDKV43KWGJWVv/BzvjZAzn0qJo8d/JiRNus=;
        b=e7LpKNkLFoq/vMPjntu18PzNxxggJOH1zmbO3ljJ7MvwSAEBEhR3OOBnSP/EA0Ic25
         kiZqQLKeDQgP9D+XPk8naQrhsik+1+MJrf0KHosgU1L/GQkNFOxqH6+WPraF5pGUH+D8
         RAliZ6IGLKQo7FUXBvvuwNpnTig12Yy2OzkTrlRFSelzLkPKtKXy+rEfum0r46ToCxQy
         gY/ub2OdYbfL6g8TOfNMOl+jSKE7hsxmeCknLJ3jDZ/P0elUBQMAS5LieF6pe4oVR+bW
         Hc79VjpXdAJfbo58nryS80YyKO7hvlRxmQKjdYqO+bvCR1+DUkePAdI/SqXgW+UrLEll
         L7kw==
X-Gm-Message-State: AFuF++nm0z+N+YrEdp1rSPfZCspRLOCo6eXPHI0ZoON5k2KnvsOo8Pdy
	xv7FV7jp/WYtogYid/b9T6NFJZAqjgGmpK1Hc16kVWAMYYv2uxskRE5tnQAjFl52ovrG+OP+AzY
	ezcXaD6M7TytqKwj/5HVlsQUVO7Dol1c=
X-Gm-Gg: AR+sD12lCNNfkwlVLvWKFfsBL2WhmRZu7CQcLoIGuN/+ZzW1Jwf3PQ/Rs+NQoaIjOKN
	XU/S30rmKthYyrZc2Rp6CQ3JW6s7Ox1BIoyNKya1UuZl3lvGjFMpwyazVfsQvbsK8kIKS8+zxSA
	t+lKlnsrVdVE9JuzdtfMcaQrVvF/syFw5zvMciYyJUc3xZIxB7F0Ck7gN4jAcMnPVNMIaa7kVD5
	iB65VIazRXp+JpDyxB9lO9WSeTIhNlCjAnZsYJCvuPcyphWmqVVCogSdNhCxcfs2heUL4rF9Ptt
	pR6Srt5lTpV4d8/Op8BkAnP+FzRsb3CWaQ8Oic2HBEd8LktBctK6
X-Received: by 2002:a05:6102:6890:b0:76f:1eb7:9944 with SMTP id
 ada2fe7eead31-77bd04b5b7bmr7042207137.3.1787612366494; Mon, 24 Aug 2026
 15:59:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com>
 <20260724214435.1850384-1-fredric.cover.lkernel@gmail.com> <CAKYAXd_uABp-cX+DgKKr4YvxUTM21X2KD=twffUpRt=harWCXQ@mail.gmail.com>
In-Reply-To: <CAKYAXd_uABp-cX+DgKKr4YvxUTM21X2KD=twffUpRt=harWCXQ@mail.gmail.com>
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
Date: Mon, 24 Aug 2026 15:59:32 -0700
X-Gm-Features: AcwNN1WobDYxxsEAS0V0bogRhjsoKwXl7YdiEUG_M76HrUO7IWMr9knn_2_YjuM
Message-ID: <CAAk_H6F47STWqOJbzCV-t0NqOMj__6AsLjQaw8OZT-+M7UVZFw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] smb: client: fix dangling pointer in DFS target hints
To: Namjae Jeon <linkinjeon@kernel.org>, pc@manguebit.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Namjae, Paulo, and list,

Checking on the status of this patch series. It appears to not yet be
merged into #linux-next, at least on kernel.org. I understand that the
branch/maintainer changes may interfere. Thanks for keeping me
posted.

Thanks,
Fredric

On Mon, Aug 17, 2026 at 6:16=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Sat, Jul 25, 2026 at 6:47=E2=80=AFAM Fredric Cover
> <fredric.cover.lkernel@gmail.com> wrote:
> >
> > This series addresses a Use-After-Free bug where ce->tgthint was left
> > pointing to freed memory after free_tgts() was called.
> >
> > To fix this, Patch 1 hardens the DFS cache readers against ce->tgthint
> > being NULL. Also, Patch 1 hardens callers of get_tgt_name(), which
> > returns an error pointer when ce->tgthint is NULL.
> >
> > Patch 2 clears ce->tgthint in free_tgts(), eliminating the dangling
> > pointer.
> >
> > v1 -> v2:
> >  - Addressed automated review by Sashiko:
> >    https://sashiko.dev/#/patchset/20260724023539.1596955-1-fredric.cove=
r.lkernel%40gmail.com
> >    Split into a 2-patch series to harden readers against NULL and
> >    ERR_PTR target hints so that clearing ce->tgthint does not cause
> >    NULL pointer dereferences.
> >
> > Fredric Cover (2):
> >   smb: client: harden DFS cache against invalid target hints
> >   smb: client: clear ce->tgthint in free_tgts()
> I will apply v3 patch-set to #for-next.
> Thanks!

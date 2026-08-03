Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6828E3783C1
	for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2026 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785765660; cv=pass; b=cXwJvU4eP5elgYQ8Iwm8WAi3VFk/+jy+LhzL2eXgASky+l06mo3XYKxQz0dEOC7sAC9AYQGMipn4cPyo+biJRkC6QemKFmtBXEBM5ROVhj14nwtE7sAQn+qTKQLt11ztzBjs8oLL1qCG5dllq2GsxpTyGOIJgCOz+jDa5GJDflw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785765660; c=relaxed/simple;
	bh=N5N3WAmNtbd4VuinPOvJo8nZPiagfpg+uBmlIT/wSmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DTnjSPqFl6wVFyEk5k5lFhXwNtqQdz9IapxU20F6/pcsNOeJHBiFIIYEhRXE1zvm1yp7FT8fI4gcm2lmOEtK0bEQqMN95B0fjQnUxK4BcQXGTlyumbJNOBEzQga34WlYBgShLBCwQRZMjMuC/6DEj7dOeBDf8q0t3B0WPQsbTq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ao3yuQjP; arc=pass smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ao3yuQjP"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-74aa416ebb1so795991137.1
        for <linux-cifs@vger.kernel.org>; Mon, 03 Aug 2026 07:00:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785765658; cv=none;
        d=google.com; s=arc-20260327;
        b=g/Ot6wQFOg6krUbWhBpAezXFYZkxsKE7a9MgosPtBsjQ0SV3Wm8FWFP5T43OXSjIaA
         kWInmvXlliSD7ZuuCja9wvJXcbhETEoRzbNomyB9coeFJ24Bv+a4ACAkcAHtQvR2kzRx
         IrD1GflXGURKrSOTCEPhKur8u3qjjSLo2UuFIeGgyMTQTYVekIi04ZBJbSgiHcIGAt2p
         ZQn2jOKots1ok4Ll0UKdja+p86hfIs4S0K6qv6awiPYyHSj+0shYxZjfg+OCe0g4R6U4
         +ioYiEp+v4gfIqUDh4LRSNOVPBuxNhBtbyivYUPSv0Yo5PLE9qo2wn6XuMB44jCp8xu6
         C/sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QQsBthBSGTwE3r+sapVtzjJmNt8L8c0GU5XX3tirWW0=;
        fh=X0aL/201qvzrQBJPFIo9wydy7Ytoo1hCzwRpjxO7syk=;
        b=QAizSUguQm4PeWDqDoqWcVr02VhJtiDTgTcpXcNiZ8t3E0XYJHsXgiLx1uymxV5+gn
         Qf41ROtG7JwdTP9HHdfv9TvM6RpxXOEt1nbekVhDDajOQBymiel8tuqasGJhnXw27MVr
         jJoK6pasHmvURcZ6CY1Xza1E08k8ztdf0dR5SrtYSwAG6u7A8SeLUGoWlI2Yp5mKcu6I
         N4Q1JaA+Qc37IMpB+diXQ3w7qfUCRR6YavN2yfVb5KiIUnBK1DIwccl/TyQ9mvJhIjF2
         3AwlFTcAZLaImv4zl/U0tVtacjwzxJGh5p9Kc5OJ2rZ7O4r7/IWi7k51q7f8gSEgkPT1
         M9Nw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785765658; x=1786370458; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QQsBthBSGTwE3r+sapVtzjJmNt8L8c0GU5XX3tirWW0=;
        b=ao3yuQjPCwAg1CPFWqygE0SG1KKOmEvbEIQeCXjd6pXL26zlgX642nTJ165FtP+rFa
         7et70y6sv3VgvGfsKQfuLjhKtShkKHOvpa73xBH1fOBhwlHpujVbjN/3kHgLfVB9qdfW
         ae7BF3WDaYQixjjGY98QnD89WBd1Qo0vbWedTymC7KLqutKd0V/0z9wk2OsrMMzxbzox
         gTXKBGSxK0k0p9+G2vXRj9DGtn55htCtI7OnnJ4ZOsRJANOwK9HEqyVR3TxnMlCjFGJe
         jhNHieJpFIQ7BqGhNn8z85SV+ixPvrK+9nXLvxNwhekjA9rYU9P/oBQwV8b4Am684eL5
         D0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785765658; x=1786370458;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QQsBthBSGTwE3r+sapVtzjJmNt8L8c0GU5XX3tirWW0=;
        b=H94l0I2frnHJURuca5Ks4wJb4qte/bSrAiFK7dVv6K+FfSrlcaPh0cpNaRZJ6P02ns
         fu2d095oJOdgCF7KvCUadTcBm+Iah1wYYUZ6ngg3Io9yec7Yxn4/xtA5lhsdXB8w0UIu
         iB+lUyMqi1oz1nLlZhkCzzw+FIBAVCxZIxRQFtioloyFXA94C3AeUWg4v9dPooKcn+GX
         ES/RBT/LIOhe8qetfbXOC9y6p1HOQe7udpdEGAm9KwhABK0Dl2HGTKa72DCovVUo/bL0
         8G0zKbXcBp0TDsj4UVTkl5oR5c6oC0MoVn+waGmzvH0p3CuZc47A6CzNN1PZTtf5FaP8
         vw0Q==
X-Forwarded-Encrypted: i=1; AHgh+RrnK07NYiA9lQiBm6iIv1dgzXR/nNbr9nzQNPBp1I9wisktAgGdXkzfRYWz6+NUux/JWSeZgIjAzkjg@vger.kernel.org
X-Gm-Message-State: AOJu0YxXTzuJmAYunA3o6tNl/kZXO72PLXC/0AWKl4mwGVlcn4+wb+K1
	2oymmnW9Z/LrPMSKfrFzJfAEu2VRfacI2tanL2Hs42vb4/vFfiNx8sUIPq7DXuS9+soNX86Iy2y
	qPiyQNWVWeFyzBh/uHSeRIsplOkU1025q/A==
X-Gm-Gg: AR+sD12bWeyIrwc+q6y//vPTJjX8f4LplPI7nsZ8TdGPkX7kZ0NFIiVosmRsWJsjRoZ
	O17Czdw1qgeYLe+Za1zQVYZiB8BWKHW5Rt4y/oIvB/p1Jg311EOrs06R/o6FYYrWiI6NQ4afAKn
	YTO7ATN5sL8m0Hh6qXLENz2JfN8M+fPy8IL+WQjDFOK0EX089IiCt1RhoUUFTrGH5+2yboYvZSx
	sik1IbHRvUthNNUlZlC3k8kY0aWhPupuvN3IuHgUvGVniw24uOKrsZTmctOc+/eMTuQLt4xyWuW
	AiD+uUsJ2ilgU5HVw0MT281/68O9CfTOO1WjFSE2kwhAhcz0lCA+QMxSIeCCW79k
X-Received: by 2002:a05:6102:6899:b0:726:cd42:d023 with SMTP id
 ada2fe7eead31-75b2375d6eemr6373832137.11.1785765656717; Mon, 03 Aug 2026
 07:00:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com> <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
In-Reply-To: <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
Date: Mon, 3 Aug 2026 07:00:44 -0700
X-Gm-Features: AUfX_mwkqNzbig3iqzk29tdBBkYuxavN39UQqSq45fn1HgLkmMkwHVcnFYNs5z8
Message-ID: <CAAk_H6EDgOmLKbqa9TD8R71AgkEySr0nR--QV9S_bFULWg2K9A@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] smb: client: fix dangling pointer in DFS target hints
To: sfrench@samba.org
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Steve,
A gentle ping on this patch series. Let me know if any updates or
revisions are needed.

Thanks,
Fredric Cover

On Fri, Jul 24, 2026 at 3:02=E2=80=AFPM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> This series addresses a Use-After-Free bug where ce->tgthint was left
> pointing to freed memory after free_tgts() was called.
>
> To fix this, Patch 1 hardens the DFS cache readers against ce->tgthint
> being NULL. Also, Patch 1 hardens callers of get_tgt_name(), which
> returns an error pointer when ce->tgthint is NULL.
>
> Patch 2 clears ce->tgthint in free_tgts(), eliminating the dangling
> pointer.
>
> v2 -> v3:
>  - Resent series with proper thread structure and subject headers.
>
> v1 -> v2:
>  - Addressed automated review by Sashiko:
>    https://sashiko.dev/#/patchset/20260724023539.1596955-1-fredric.cover.=
lkernel%40gmail.com
>  - Split into a 2-patch series to harden readers against NULL and
>    ERR_PTR target hints.
>
> Fredric Cover (2):
>   smb: client: harden DFS cache against invalid target hints
>   smb: client: clear ce->tgthint in free_tgts()
>
>  fs/smb/client/dfs_cache.c | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
>
> --
> 2.53.0
>

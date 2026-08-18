Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F56E1474CC
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 01:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787015799; cv=none; b=Dpv7HMS6bmBZ2Gx5Kks4xylRsl0i801IhT07ZGPvbWkzCuab3gmb0SDEfLBfBEQWswScU6gUmDAiSwMPh5rzrjL97jrl9bv5OD8zoKyK32DFwAhNrNYi4FwXSGpNoOg7nnuS5yqLyFEl1Sd0GjphJ8zHYW/4PtF1lgNNEtnHTxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787015799; c=relaxed/simple;
	bh=rFcQcpptybZVKphhP4Sxqy2ozY4NAxENj2ttVW4LL/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hgtOykeiL61H3HUEQwKsVCS57OH4YDsUrnTaN/FbLcQ7GiWx47yfOANAIXSWCPvpwJzNkkDuP0k9t8roaiBZdbzuhHoWCXu6osaCfZPlHAgW4+sI2ifWWkKJEGfZOpZ+4NoUzzIz5iIoIbCBFbZ8goMt48xnMJklefOmPmif834=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPM74Ufc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPM74Ufc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6971F00A3D
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 01:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787015798;
	bh=s++4m+hU8RC538/3gXWVoJGetCnZOPJ1k6ceCvUowpQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lPM74UfcAtc/zzXmGzr/fvOV7dpCZmE9kXkLvzlskVfcBi31Db6kILb25GFNwtKbl
	 rNh4NESgebOWGKgx33qPm6z1zZWHOIDN/Y4R8L8whe/73HGuVqK14kRGPwqULhyxyU
	 HselsCFVnM6TWEG/90v0Rx+N3CDbp/WBjO0ZtJVCObvxFhdYyBJTcemuePOXHfS3R0
	 K9F6waFOqhEGdKF1bBP9iq/1o34COLfbFoE2gkInYHR3nhVFxqD2nLkFy7UjMF74P/
	 farMsoC1kmggTVKRz+A3f9rHQp+CNTbM139syDgWsSe+Uo+whc89EDiP+evSda+ZAi
	 SyTVkfM7uIevA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c207cb16cf5so570917766b.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 18:16:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpiBJHFI1pi+S8Go27gXQ8OeuUM4dQ39+Tivefvm5p3VfCpv7ByAVInbidlbCmTsfRwt3HiNMejUWOg@vger.kernel.org
X-Gm-Message-State: AOJu0YxxLqaEaQW+cFhJCfGkOWnEe5FjOy2cUgMZYamiqPL+U06Q2c/g
	f0f7ivyl4biQbaVbW3+kMBzu+evT4Ss7WRHj52OXePA9JNsdJnjz9wyZTPduWJXT8D4+bMBMBz6
	C1vOEZo90/ijOkOWwOcLnNWtWQQKqiVQ=
X-Received: by 2002:a17:906:9fc6:b0:c12:5a0e:3e0 with SMTP id
 a640c23a62f3a-c2188a82275mr201539166b.19.1787015797056; Mon, 17 Aug 2026
 18:16:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com> <20260724214435.1850384-1-fredric.cover.lkernel@gmail.com>
In-Reply-To: <20260724214435.1850384-1-fredric.cover.lkernel@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 10:16:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_uABp-cX+DgKKr4YvxUTM21X2KD=twffUpRt=harWCXQ@mail.gmail.com>
X-Gm-Features: AcwNN1U0DgNdXW9K8pfeJ3clvgRqMVv9RUkVyPmYHzwNuei8_X4vlSywYPM3M8o
Message-ID: <CAKYAXd_uABp-cX+DgKKr4YvxUTM21X2KD=twffUpRt=harWCXQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] smb: client: fix dangling pointer in DFS target hints
To: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 25, 2026 at 6:47=E2=80=AFAM Fredric Cover
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
> v1 -> v2:
>  - Addressed automated review by Sashiko:
>    https://sashiko.dev/#/patchset/20260724023539.1596955-1-fredric.cover.=
lkernel%40gmail.com
>    Split into a 2-patch series to harden readers against NULL and
>    ERR_PTR target hints so that clearing ce->tgthint does not cause
>    NULL pointer dereferences.
>
> Fredric Cover (2):
>   smb: client: harden DFS cache against invalid target hints
>   smb: client: clear ce->tgthint in free_tgts()
I will apply v3 patch-set to #for-next.
Thanks!

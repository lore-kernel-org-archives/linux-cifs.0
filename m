Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8F8440A05
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 09:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836790; cv=pass; b=tPA7OyVE4L5K6GKmyGvZEfnZ4QxOym8HcwGYfZd93otQR0GR1BmKVnlN4fyrZHeYLfr3byGpMRIHAFkCbMydeZPXSNYarefLKhJEVg6S4P/dzv4xTIi+GHEOBHDPDmtt2mdb26L4WzwEP6POpTXT8jpCZHsI2W1VrPOHpgHAF0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836790; c=relaxed/simple;
	bh=PEN1V4gYMrIG8mQW1ocW3sHXBSWnpiMkEA1GVc+/iq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=copk4dBy1Q9JwakJ7h8/0yvOe7e8ajakfM3fglC9aBT0p843sXVxZBm8BQ2YSPpvcl616SEqk2p2v0PR7EcrBjo+GPtRZBuqdBVeQltgbCld1O5mVu5zsTZrJ/cvHKuson87OmX5+IdQYCDRuskEAztH2JGnqYJ/L5NKkOiEbLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZKZ1TTHg; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZKZ1TTHg"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso518794866b.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Aug 2026 02:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785836787; cv=none;
        d=google.com; s=arc-20260327;
        b=M3raoAqQVgvW1CKYp/LywnfA1EEsp7tgjSh99qSQ2PwrcCrJOJjnZ8bYZ/ro5wBCvi
         IkHa4dEre8whVc1TH+ti3PFHZRYQI6n+HETkO97o2YTSz8DYIDVs5VvH/xKBBHvscbDy
         7yZdP5shD0GlFG9NW0VtIkMkzys5F5dhzZ8Sbo9iAhJwDvUsdFxVI1crBgAxI1qGz4wL
         GdF0DR5ubPyKH151hIiIX7j9q2HX/53AsxJHPSCSibjRdlLVeZeR8OiIUDhyzAS3Ljdg
         gQzI+PJb3X3dBTk6C2AUoqpjKSN/pszOcC+QwVROTPHxl+qXf+5U2k/WlJLkW1QN/YBQ
         Kqeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IX4fVkIN5+nK1Hk81Rim9BcgOd9k0T6Q7nzuk0EdT+o=;
        fh=mLDvJWLv/46D+6zlB+/of/0ixRXj6GfDpOnSYmlsjm4=;
        b=LxfCblv1fZtcxV6JgP0xVcY5qOos2kx7ZR95/92Nk4JTxuzG1khMDS0sRNOVK7w/P+
         rfTBMBOYAHTJLgryEwGy3XJLIr25uRlKqvnhQ+3vcAYDj6ww7NaZdznX+6eO62eC2OsX
         rto8KBv8uXqoLhv8c5fb8Q1R7ZfwWewu5WfHTLtCpjfAFnLAR82tVu0evZWKwIRtproE
         GVPnR7ad7hWEd2e4qCDxS/NhmFP/Plih1ZgXUCkwTUXpgBZg/co/sIDrD/M3rhUs/zcR
         IG+1eWkCSePAf9dJj/tObFZz+nWE3vPcjSoadZXXCS4HPAJLoWndjLUJnDIVJC5Gv1Rw
         gERA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785836787; x=1786441587; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IX4fVkIN5+nK1Hk81Rim9BcgOd9k0T6Q7nzuk0EdT+o=;
        b=ZKZ1TTHgr9C364Vyf0BvDzJ1YaAlEPHdgkp8DYdjcXuAxgxo6/8+dVB7XV7XpfK6wp
         By+Te6KE9ltAxl/yP9ga6K76ekvrf9LZlGPdriry3pMsJeBEnrcU0rPk2jthIqD8h+1N
         mJf9x4Mrl70dJTqtqKMrA/+9Mr9NfTrCL5IhW7PWccP9CtNnJMDBfGZH6DNT1K0I4aJg
         exxjl1ySqeEUg12+NGZqBd4qVruq/bEA0cqZKVtBh5zDqEPHHWp+Lx+RjRlgXSaVrINm
         I/KLEU9pkZ6UZHeFTPtYrUShNCGMMQv0c3MmmKbnasdAFqPhUJV+HO5BhNjg8+8ck/YE
         fpUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785836787; x=1786441587;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IX4fVkIN5+nK1Hk81Rim9BcgOd9k0T6Q7nzuk0EdT+o=;
        b=lHzxADoa2Da+yYSilhmE6JlufuyfW4+LQghQwoVX6+00au01BkhY9ffPVhLB2RAmH2
         3szGpNRu8bgcHh1PGYhXnWH7OExkwt4eKkn8C/6yos804duD/Zue9L51A/UKR6cAcAjy
         nWb+4kPr/ICLhQyAjEgI8klVCH1BFCgLVV1Ez82IFCXzNvRVerS4BPDr+WQBdNWgza1Y
         nuHLRMOHkjxMaN18JXiWUXyn7fXfX0a3ptD/Hg+fbKEQmNCRnYDgtYJk+cYXlEhpkSgw
         XGMLxeXTOVgfRNTtY56ly9LfjbjgkvDR91w0A5Qzv9o2jInTeTbZFXnHrQaFSOgQb7jQ
         GqGg==
X-Forwarded-Encrypted: i=1; AHgh+RoiUf1LMwsTLa1bquXyEz26OdNe/64vAnmZuitHn8jobybQ2KnXU2ix6inntAvtxJ/HDUIvT7DVLyeV@vger.kernel.org
X-Gm-Message-State: AOJu0YxCZQV4Q+VTCGmhFyCbLdlMuI/WhCfn/0URNDYsvfj7MkYh44eT
	D2bbsosjx0O5wfe4ZnWUf78kV1XcDuhUzDy2xqHOVzp0LWPBHFIIzzM0dwIkGJT0svb6pOr5qdB
	I9vqerYXjag/v9G+8fG672tjHD3f7yg0=
X-Gm-Gg: AR+sD12MRjVof4LXdsRqiHi9tMVIntUwY7lftXF4OkgWSPTxTSj7EJTmR0j4nPYlzTS
	DFFq3J7KuWgaUxbd0nwZk6eg/KV0ychn7BTKIj9Uhslg7v26SxJKmw4i6wg4jOZo3WTHxji1U8+
	62KKkQnzt5u623iuHLOmn69KydqtaKhoqPL4s02sexe6sG4jOnX8GKlFO7n5SDJW0PwcEc5DZcP
	HmJ2znCjnU1qkm4lcIHOlpG4kLZBYRATdtu+xnmWDB+eSeNMJLWV5ilzRTvKb94C3wRw30F9Bmn
	3VVzu+5s2Qcw8Z778rdnncqw3/fS6IPpFLe+1lrMgSSwX/Y/pxp500b+1f0yRYaYZqHSY/cuA+V
	sag==
X-Received: by 2002:a17:906:c10a:b0:c12:5e3d:4023 with SMTP id
 a640c23a62f3a-c1fe7ecadb9mr1028413766b.10.1785836787058; Tue, 04 Aug 2026
 02:46:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723054622.3460249-1-hch@lst.de>
In-Reply-To: <20260723054622.3460249-1-hch@lst.de>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Aug 2026 17:45:50 +0800
X-Gm-Features: AUfX_mwVprYE5GeT6dtkefeYHJT07YC4B0Cgdou_icFsYRHG5cHdT3v1g46bWAg
Message-ID: <CAMgjq7AYZhTYR-U5DmxoabdKMuD3AeMrY4yqnkNiEdJ=NGwRKQ@mail.gmail.com>
Subject: Re: swap_ops updates v2
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, 
	linux-mm@kvack.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 1:46=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Hi all,
>
> this series is a follow on to the swap ops series now in mm-unstable.
>
> The first patch reintroduces direct folio writes for synchronous
> swap files, the other two remove the double indirect for file
> system based swap.
>
> Changes since v1:
>  - include swap_ops.h in zswap.c
>  - fix a commit message typo
>  - add a commit log blurb to mention there are not functional changes in
>    patch 2

This series looks good to me and we should have them, especially patch
1 to ensure existing workloads won't hit a regression, minor conflict
in patch 2 for unstable or new, due to
https://lore.kernel.org/all/20260723032434.2016749-2-ridong.chen@linux.dev/=
,
but should be easy to fix. And for the series:

Acked-by: Kairui Song <kasong@tencent.com>

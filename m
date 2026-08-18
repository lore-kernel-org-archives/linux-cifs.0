Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5A431578E
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 05:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787030451; cv=none; b=hfZvNNIP0cNXM91piBF7GEmW7xB9Wadw8ZJ4F6951wDCqsgNsdxRXsR04K+5L6otqxvM8ea7GcUpYITHY14zIlgqZG4uTNQ3muzrnTB8kgFVPM/uNkn/mY9gj7YZL4JYqAeRIruo/8t5C/ckO2N/W2VFgiXseit6waYtwX2ao5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787030451; c=relaxed/simple;
	bh=3A86XOImE7x0UgVba3TEOWKTabHS+5Fn0EXkSFXSuVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lxVSV5haZXAjwGUcOQJWsZd7+81oL+tmvAXYvguB+P96N32qjqKhpAascZKVgQUVce4aGT0GulQ1CowmdSoKYjaILH9C71SDsdfwU1/ZgP3q3RPGt2OxSRWntdlr7w75trWEOTkxN//UowGHefsWk1uxocQQl/fTxoPlnmqGS/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flSr36yp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flSr36yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19681F00A3A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 05:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787030450;
	bh=2PDpy7NuaUiNObBzTt6+NSq/9afGefUPI0e6QYBsx8A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=flSr36ypnjFl4pO6YWaWEKKEGWGsEJV61FLWfqsx4wThaf6EvbP/G5vHuKYX8ag+O
	 Dfe9Q5GvR7CrtLuxqy2BUAbGMChOiIMR/tPXmUmQFvX5sZu4hthDVwoI4c/cY/Er3C
	 UgBcxMNvgPUfbV8ZX4A8srn8AER/upL9VQ5znWsS/X78oZqrDiIT5ZuJaZtUJXkXtD
	 UvUz16/YWUOV29fcqfm3Za8RB7nIPxOlRiOrUu4f0wclT3XO6hTZaVEJhi1G5xRtRE
	 yjZ3B7w9B59i99BVh74pjMqH4vmK+M73VQqILJUHQE9KIjif1E+EtXptc7Ygotp9s3
	 /kOxZCKYGlJuA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a0c8283146so6007785a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 22:20:49 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx4O++F62tFkcDBaWD+tqzvUC66DmpAmx4OL3BeVbhTmhhETsKI
	oP4BHYHX6KElD6lkt8Or/xLRu/F6rJJt4M3DPKiAuPtpzIKXWufHXQf4fnnOvtjP5U8diT9+/U8
	1fPrfJ2vvPiGYApVDk0+AxRlks0Fr76A=
X-Received: by 2002:a17:906:6a0a:b0:c1f:97f3:7225 with SMTP id
 a640c23a62f3a-c218857e1f9mr281084866b.6.1787030448570; Mon, 17 Aug 2026
 22:20:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812024126.1368971-1-sorenson@redhat.com>
In-Reply-To: <20260812024126.1368971-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 14:20:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8NjLwerXCnR8X5RDuD15Rc+by2z8T1taXuHw5t_-cCZg@mail.gmail.com>
X-Gm-Features: AcwNN1WydZkwvDHmITNE28XwkILUWBjRDqOvLruejklYFbI4rFVtbhxZoUTxkR4
Message-ID: <CAKYAXd8NjLwerXCnR8X5RDuD15Rc+by2z8T1taXuHw5t_-cCZg@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix OOB read/write from unvalidated
 DataOffset in coalesce_t2()
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, stable@vger.kernel.org, smfrench@gmail.com, 
	Shen Yongchao <grayhat@foxmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 11:42=E2=80=AFAM Frank Sorenson <sorenson@redhat.co=
m> wrote:
>
> coalesce_t2() computes data pointers directly from server-supplied
> DataOffset fields with no validation against buffer bounds:
>
>   data_area_of_tgt =3D (char *)&pSMBt->hdr.Protocol +
>                      get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
>   data_area_of_src =3D (char *)&pSMBs->hdr.Protocol +
>                      get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
>   data_area_of_tgt +=3D total_in_tgt;
>   ...
>   memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
>
> A small DataOffset can push a pointer below the actual byte area,
> overwriting header fields; a large one can push it past the buffer
> end, causing out-of-bounds heap reads (source) or writes (target).
> The BCC overflow guard does not prevent this: BCC reflects how much
> data is present, while DataOffset controls where in the buffer it
> starts.
>
> The "validate target area" comment present since the function was
> first written in 2005 was a placeholder that was never implemented.
>
> Add lower- and upper-bound checks for both data pointers before the
> memcpy, and before any target header fields are modified.
>
> Fixes: e4eb295d38b5 ("[PATCH] cifs: Handle multiple response transact2 pa=
rt 1 of 2")
> Cc: stable@vger.kernel.org
> Reported-by: Shen Yongchao <grayhat@foxmail.com>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Will appy it to #for-next.
Thanks!

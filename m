Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478372D781B
	for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2026 01:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788053380; cv=none; b=ITfg0BAv1XIZLgfG2fmvrpJaJt++tOOKez3/FTb5WpGKzpzF07VQIiUwyVrLTvFyyo5GZqKh8S5ekFaIlXIqPPe4qz07gfO8HS8MBApsPTeORhSJ5Ho/Em8iZPmXYbbTx1RYA30eCL2X/nC2mR8iLdznbPGiFJOcG4OZpgi4i2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788053380; c=relaxed/simple;
	bh=TKFD1iexF6Ak1kg6isJNiQvYTDK63tdxlqk1tFPvyg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sffe7/MPzYRrWuK3B5YbFXtEhQnrLOfTTAJzy7W2WQ4tx/JjaFIOi2Y79zmyx+GrxXTABwnMNo+jOC75arXAinA7mawN1o59tbZ0WFC2Q9ZOFT78IwH63HAYIqpSTYX3Ul1ymonCwNwwJjd6qrIIiY6/z1puHfhjg/kM9+1VB24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hVxRKT64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hVxRKT64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2B21F00A3E
	for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2026 01:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788053379;
	bh=WS02TKvZKG2klMFRx8ifAxiyzQiiN++W3V5iaVaSLxE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hVxRKT64tgGKWoV0d8i5uiw1ypF/k6BzmrO/3dOctiQgd4FRkEMLHWhXwoBmCj3ZN
	 zwCGE9+Valilbx13NQeMNllYInnb/k3fi1iFmQ0T198kq0qs708WTqcKBBwz4zjCCK
	 biiXYqyvLVNrdGT7V5Ygq3rv1ekW/MvR4ymNLoPQRfpqRXDJwlIugOI8C+YTh0iviN
	 S+wAv+dTAfrIQUcwdIAxIUqFnDMZeLkk3HBniT3hCD9C4GPxEen+Mch5POqPZTjgmd
	 Shp204VPO/MTMptX8GKB7ylYnrXGEBcDGQrJycmglq22M18NlbE+xgapw52CiUFJ1y
	 2rW6lJR4q+ZqA==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a6165b4402so2693935a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 18:29:38 -0700 (PDT)
X-Gm-Message-State: AFuF++nbhr+t51q95RD6Q0K6+L/oTt1YqHyUjrXdHk0aZ9xnFqtBzq46
	nmemZmSR6rvgLOhPlFbX/61MoWx9JnqNWVpM+P1791BJTDeyfdyQWf7NiOC9uATeFdUiDoFuufW
	C6cY5Dj7vrnIaVjHeu0+/1fv+rxQarWs=
X-Received: by 2002:a05:6402:21d5:b0:6a6:4004:4ae6 with SMTP id
 4fb4d7f45d1cf-6a640044f0fmr722329a12.5.1788053377597; Sat, 29 Aug 2026
 18:29:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826153147.4112943-1-sorenson@redhat.com> <20260826153147.4112943-12-sorenson@redhat.com>
 <CAKYAXd8_jvTz6DX-1OjkCu1UAe7qKKHKOyW7-yOqrqVtxC6dPQ@mail.gmail.com>
 <666879b8-5117-4c41-ab1d-e50637e68a5d@redhat.com> <9b064466-4403-4ced-b6f9-7f92829f3414@redhat.com>
In-Reply-To: <9b064466-4403-4ced-b6f9-7f92829f3414@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 30 Aug 2026 10:29:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_kJnWVDO+nuc9jK94ORqSWtHiJatcmJJme+xYuXVUTnQ@mail.gmail.com>
X-Gm-Features: AcwNN1VxkZRmCo9H7q8-TAHmaqeiBPXlHIdJd-Gax_l39lh5g4zmJzA111zw9Ts
Message-ID: <CAKYAXd_kJnWVDO+nuc9jK94ORqSWtHiJatcmJJme+xYuXVUTnQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] smb: client: fix NameOffset and Next field
 validation in smb2_parse_contexts()
To: sorenson@redhat.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 30, 2026 at 1:52=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
>
> On 8/29/26 11:26 AM, Frank Sorenson wrote:
> >
> > On 8/29/26 9:01 AM, Namjae Jeon wrote:
> >>>                  case 16:
> >>> -                       if (posix && !memcmp(name,
> >>> smb3_create_tag_posix, 16))
> >>> +                       if (dlen && posix && !memcmp(name,
> >>> smb3_create_tag_posix, 16))
> >> Could we check that dlen is large enough for the fixed POSIX fields
> >> before calling parse_posix_ctxt()? It reads 12 bytes even when
> >> DataLength is smaller.
>
>
> make that 24 bytes for smb2 and 50 bytes for smb3
>
>
> so if we test inside the version-specific function, can we simply return
> 0 if the DataLength is not large enough:
>
>
> smb2_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key)
> {
>      struct create_lease *lc =3D (struct create_lease *)buf;
>
>      *epoch =3D 0;
>      if (le32_to_cpu(lc->ccontext.DataLength) < 24)
>          return 0;
Right. ksmbd has similar validation in smb2_find_context_vals() and
parse_lease_state(). please refer to those functions. And DataOffset
also needs to be validated, Please check how ksmbd handles it in
smb2_find_context_vals() and parse_lease_state().

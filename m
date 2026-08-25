Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8BB250BEC
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 04:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787631592; cv=none; b=bs8s5On0niqA4tsLwCELxzlswYjTRPFpS7P4L3ApYmnA1PjXYlNRa5BZwGmwHc3Sh62MtEIQ8Z1unOwZickkyTliYoCpQmjijMku1yDRCuVt2YFwKHfHvyfEgkr8r9oNKwzVEJ0SGttBKIyy2JzqW7VVZWXLGDgR6URFdm6KEwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787631592; c=relaxed/simple;
	bh=Bq9rSFmOdrUAuSPKcZhIVvkdZLlPHJbqHJxKpskCpww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZEYyuRBgB+1mTuXsu8REpSxH4U3c/I5MP4SN4BJWyBZwbkS+9N9evdK1uVElUmtZa7qhirTIscOBU4/sQxaO3guz/g2n6bHumPGGKaY7TymZ4Urk2R/2rYFJci09aByUsm9pnnKnEhse1LbgcoqnMSF6vBJ8ICOO9fNm8iRHIwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GDYrz/Ht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GDYrz/Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA9D1F000E9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 04:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787631591;
	bh=+JkS2BgK7LN4rpkb3p+0ArSMsLkWo8rZ0G64L1FRfO4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GDYrz/HtkykfpMB5hmoBDufDgVnklMnmwZGv454rWFRSbDzaCAXspB18aCLwYNFwo
	 JX6HWcQOutYYl0X1V3eWm2CmLNqPLnWqoY1oTCwbgITeVl7yrweO21kuwHCDaY9pgC
	 omq10rqv5s3JIibKQHrt7jGkqcy2JYnEeCernrU2KH18+Wwy/aiOSZFjQREP4tXyBR
	 xoFSFGe7ln9OhirTPSx0wGp9NcyVutXnQ4+tI1csYRu+FRPCAQwf+kdhOVQGw8kXSW
	 t/GBzQhTu4ypDaYYmpYZwm57M/cVEMusLRjYyxjss3u2GVtIq8Hj6nCAoJKGQTQX8q
	 u4K3L2K6hM9dA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so7743986a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 21:19:51 -0700 (PDT)
X-Gm-Message-State: AFuF++nYwjbtYAkjlPycq7rHL3z2eOQ1OkCIgKVTaV9J6epakgmvUS6t
	H+9xuX2XjehgubTmFI55QzPGgCVpQJv56T+KpmvzR2rDnrUz1u4TfROgon4OhYxrmBH/Gx1AR/m
	bdr2Yh6BZXuV5HkCwf1PzMtkga3ssegE=
X-Received: by 2002:a05:6402:3202:b0:6a1:b515:d2b9 with SMTP id
 4fb4d7f45d1cf-6a582ba2f09mr27753081a12.14.1787631589817; Mon, 24 Aug 2026
 21:19:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825022907.3567228-1-sorenson@redhat.com>
In-Reply-To: <20260825022907.3567228-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 25 Aug 2026 13:19:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-cc8NcOZi+JGHQBV9N2n7yax3FQNnuYMnYX9A8nB24Cg@mail.gmail.com>
X-Gm-Features: AcwNN1U131v3d21BkaY9oJlRPKLm6fJDJJ2Mvrh3eU9aQvXVGXa8tgZ2xWCCe6c
Message-ID: <CAKYAXd-cc8NcOZi+JGHQBV9N2n7yax3FQNnuYMnYX9A8nB24Cg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix OOB reads in cifs_to_posix_acl()
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, brauner@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 11:29=E2=80=AFAM Frank Sorenson <sorenson@redhat.co=
m> wrote:
>
> cifs_to_posix_acl() reads the 6-byte fixed header (version,
> access_entry_count, default_entry_count) before validating
> size_of_data_area, causing an OOB read from truncated responses.
>
> The ACL_TYPE_DEFAULT path then forms a pointer from access_entry_count
> before checking bounds:
>
>         pACE =3D &cifs_acl->ace_array[count];
>         count =3D le16_to_cpu(cifs_acl->default_entry_count);
>         size +=3D sizeof(struct cifs_posix_ace) * count;
>         if (size_of_data_area < size)
>                 return -EINVAL;
>
> Validate the header before any field access, validate access ACE count
> before pointer arithmetic in both branches, and validate default ACE
> count before use.
>
> Fixes: bd9684b042dc ("cifs: implement get acl method")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.

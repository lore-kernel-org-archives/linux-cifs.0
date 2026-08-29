Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1155A377541
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788012114; cv=none; b=oH9v9zloDXDUkdmLRBnymZsIUjpp2cNX5fk9ZGoTKvyj5EF4u2A+WhvjDb3LN/Rx4Ylbm+rubOHNvQ0q+tTQK8zyHnyh4GGO5qOp8vY69p5CzbO9zAKkOWqA/CSuHs96NoclCJtHiNOguCO42R6VqWd2mUDJNn2vjL95T9wOdYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788012114; c=relaxed/simple;
	bh=rgwxSLRKPg8LU1mV3Z3k4EuPfoilwuuDH6BpC5Kzie8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EnyV+uTvBiH3ORDv8rVNN5isJWERmUupQ4rFer0ZsxyVeAHD4t41g1tpIfK3sEqGZw7dcZ35hLr1N8mnxLTeSDKjuobw51gUUfaFnmW5UYErnrzxU7ECEq/bbhp92f32CkLw4TWFCDm1HLHH3swYMw5kK0QwH0mSsCUX2RVvkj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhYh5RWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhYh5RWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B905E1F00A3E
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 14:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788012112;
	bh=R4R2LTbYONToBgJxGruwOxVodtZZHOsCVEJJal1iAbE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EhYh5RWanjriBaeUihzvgD2eLz3Cj1MlKuYLppOZVPfliyZrZU2cz14HZ3BEUgynV
	 voew5d07nIYSucIYH9WB0lIAHVeVWlKhG6XOOmpDejQntf8raZynLUlwMZeA+IiPcD
	 eSvtbuZmk1I5QyJ0OStme6LpdJHZfkOreEBXwCLXQbMXy31hm8zuvEVU1G3jt4RNE/
	 sRbdRYz/JR0l2nHiL/xD+5i53SiGXayCX6v+eYHy6xZuU8fkIr/nBAx4F0foDVzOZE
	 QVgRGxWrpz6fsiwoR8WFGawBixRx+SFTx0HU6A+i2rnmjrWRWgo4jhIx+CF/Byj6zx
	 UQ/wCV3PldwvA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a60d406a5cso3008996a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 07:01:52 -0700 (PDT)
X-Gm-Message-State: AFuF++mv8720XHV/RdNCEVdlKMFQelUm0B76CUQbFN6HZBOUem3ZUU4y
	MED/YdTMiC8TE5nLMNfKco3t3aoUQ6oQ8xtui64jcPN7dRQmBLa8OsH0/VhdM1lVECJbWm3KLgY
	dAH0gwe6Jv11OJMJbmftPlK0x3STv2yk=
X-Received: by 2002:a05:6402:a518:10b0:6a6:15a1:6c26 with SMTP id
 4fb4d7f45d1cf-6a615a16dc8mr5367549a12.3.1788012105218; Sat, 29 Aug 2026
 07:01:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826153147.4112943-1-sorenson@redhat.com> <20260826153147.4112943-12-sorenson@redhat.com>
In-Reply-To: <20260826153147.4112943-12-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Aug 2026 23:01:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8_jvTz6DX-1OjkCu1UAe7qKKHKOyW7-yOqrqVtxC6dPQ@mail.gmail.com>
X-Gm-Features: AcwNN1Wll8IO9kQm7RRJZIwNASBytNkIinrlpImSvvZhHZsJ6SgdxgGCtjtIgZg
Message-ID: <CAKYAXd8_jvTz6DX-1OjkCu1UAe7qKKHKOyW7-yOqrqVtxC6dPQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] smb: client: fix NameOffset and Next field
 validation in smb2_parse_contexts()
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>                 case 16:
> -                       if (posix && !memcmp(name, smb3_create_tag_posix, 16))
> +                       if (dlen && posix && !memcmp(name, smb3_create_tag_posix, 16))
Could we check that dlen is large enough for the fixed POSIX fields
before calling parse_posix_ctxt()? It reads 12 bytes even when
DataLength is smaller.
>                                 parse_posix_ctxt(cc, buf, posix);
>                         break;
>                 default:

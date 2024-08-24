Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12251714CD;
	Sat, 24 Aug 2024 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724508700; cv=none; b=uA1qIUC+vUxTlSNGnJ9/bNzrsn70iklrxv9jn3nA6R+1ef1pa2/RElbC7ABXqHIiV5vMQ071/abYHq2ocBtdNa+rJMz1VZGi0IE4xW0FYBKSaOpWyBBavCmmPV3BLMMUYyllJaCxofWQhFNrJ93xK3N7FVW7HzD+/fL6gGPF1TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724508700; c=relaxed/simple;
	bh=W8M1Zi7aIkrnWh6ARqbPqJasZDK1TBAZj6azA4K8n94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O27XdEZR98/UIXGJHfJZNwMJEmpXJhPLotZHowBppDIFsTqCyqHUxNMxULa8QNQXOyIImLQ+MvS3q+XGCerYiIZfJ/qw9J0TYB8/LWGsUxw+kqeiheV7Sm14xZ8u5XLs9kbNwI0TC9I5lHv0QptaoCqYggPoeHkidX4M8JRlpvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMnOZsyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMnOZsyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0BDC4AF14;
	Sat, 24 Aug 2024 14:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724508700;
	bh=W8M1Zi7aIkrnWh6ARqbPqJasZDK1TBAZj6azA4K8n94=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fMnOZsyjIiSxIULNhEWT/Ul07nlCs8OYwZme5p9C7CQlZiZPz5cpX1tNBJWSGcHfw
	 j1cjZVi5d21gfqPPUqh0N1uX490iESrbFRaDDK0M/GinI65JezNsj+OekIU7C0Z1ej
	 qtqcfKDvbldzIOTOMslOhJ5HyRiq8ayb4DnAQAf9XvKYzKhIQHZudCEmchVvh53ORV
	 SUiBIbYmomaQA/vXcWPmSnTASrXOWNr5GQcdxDsM9H+jVnxH71GPKTHeaStlH5/u/m
	 AKX/uVWlVHGTzREhQaoUp3NgKkhW0VdQ6sDb74Z4poWEAZT/Yb5Umb401IUuN2+vIl
	 Vd4Qx/FhAY+vA==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2700d796019so2027195fac.2;
        Sat, 24 Aug 2024 07:11:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV7rpzaR8Z/l9wD/UIkNM/BKNIeVDrJhyifsht3uyPLxgEkfH4mj4aCjErDE2BJ5Jb++IG6zo/uTJ3NXc4b@vger.kernel.org, AJvYcCWX85Txa0uZnjFf74yiLVnTm+kRQOsPyM56dV1zEI5A5GronK0gHlWX5WVwxfAHyxMwIQLcnAXKopTt@vger.kernel.org, AJvYcCXrZb/ciIaukeaJHuOYpND1Qvs8LfY1FeEr6JFQnqAggszPyKimAuzghnBJ34WzodxjBQ99VuZJume8miBeryK3@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1UmMjC8i6p3GYzutYOU4JIblCMyMXg05U9k0ok6ZTzrFLcqS0
	t0BDgmOm91DbmD3KJl7gDQwXcwUEDSVvKYFTxELq0Xkc0umviXfYBuCLfEk/Z6T9tu5dX9H7H8c
	uDFd9s8TjpqpGCPtRyKrudxzGnac=
X-Google-Smtp-Source: AGHT+IHHjnn/NHqyorxcVuvXZ/XIEXAghoMCVWNt0SCheWsoSq/amxNqcMs9jWYY2l892xnrSusMBO+qGcwQZ044Tr4=
X-Received: by 2002:a05:6870:4713:b0:260:f75c:c28b with SMTP id
 586e51a60fabf-273e646d7a8mr5832277fac.8.1724508699291; Sat, 24 Aug 2024
 07:11:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240823114704.36967-2-thorsten.blum@toblux.com>
In-Reply-To: <20240823114704.36967-2-thorsten.blum@toblux.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 24 Aug 2024 23:11:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8x0Q1BPPUvL1FD-kYMyubj1pZuF-G6krfsttEKz-4Z6g@mail.gmail.com>
Message-ID: <CAKYAXd8x0Q1BPPUvL1FD-kYMyubj1pZuF-G6krfsttEKz-4Z6g@mail.gmail.com>
Subject: Re: [PATCH] smb: Annotate struct xattr_smb_acl with __counted_by()
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	kees@kernel.org, gustavoars@kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 8:48=E2=80=AFPM Thorsten Blum <thorsten.blum@toblux=
.com> wrote:
>
> Add the __counted_by compiler attribute to the flexible array member
> entries to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Applied it to #ksmbd-for-next-next.
Thanks!

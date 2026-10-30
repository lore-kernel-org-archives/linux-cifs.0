Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793370395;
	b=5tafKuubFn42yD25LSTc/c0qKjSIWf85Da+bCyYls/WovcKiYr5Kh4U4993E6UfvzZoP
	 EFcfnt74+mZ/1zBN2AFXC08w/X7KjBrYXnxT5d7/HfEta1jIU4MwVEaS31446UdtXEZ1s
	 4xognPH6rNNnQj4e2fILmOw3Sge9KwUAoQfBmmU3r7C9ttSQKwuFxiogK2suXb5GQDNWk
	 oMywUbscfuj+FtAtuDtEDpLtAzv45MDffydXvfPmGIqMvZBa5iDgn3UxjH70N9fOIl8+U
	 2JozogeWY9Cd0ttWaqVrtzembyLVcJ9lFukhwwuuPapKnosRvzkzS2QsI7NdIrfxHpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793370395;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zehQDhrFZbBz2CTr1uCMIHX25ssUcdA07pQdxbL1cWo=;
	b=KsIypTRHb7FG+XHO0eHT1uGMDsPL/pe5F1Ezmu4TxDeYlaRN5agZjViLZdz+VrVb+moz
	 DhNhRpOJ765io/aeA7W5GbfFcMNd+p40FEF/egGjD4U4HWYUO7xss+vCCjYzog5EuG9ut
	 TZxkMQU/nzVhkMZgOdlxW/e7YDK3dkyA477hH+OCWJJKpIHF9HOHnHjAReRJEoyIJcnsY
	 crbYU+wL7lyh+36hZtIObpo/xVNY+dMnu/6c1yZfC9fOJlTNEH4JBtS+gwwsIJ+rnGTXG
	 4y/whjPKHTlCCj7MJOZJNk7NjlQgX63M6p/TLW5ZhSuyrDqdrZd2gySnmq5AmFRkELw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fUfkR97t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B68A60A2602
	for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fUfkR97t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A34D1F00A21
	for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793370394;
	bh=zehQDhrFZbBz2CTr1uCMIHX25ssUcdA07pQdxbL1cWo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fUfkR97tvSVut6YSbjuHTct0sxkV/v64b0RRVmNk+aHcsUPOFYzHvdeX4VwBcTcrx
	 9r8hegwzEgEgNrqzhBDeASWHMdsWJUS8eolubDFTEncd+BWaaKpdWpzUIl5Vgbh3R1
	 ZlesmG5J5nponCccX9rFuehstWBOTQ++Nm1Zb5NRWs/O5OmxzbaprAvlbU9h3WNJHy
	 d37/FKAI1gGXoyKPB+VY++uixG0EATAV1Ao7dJNcBcGuIenAa4cmcOYeR7ih95e5k7
	 5V85hHQoV36EM/D5L+vy2zmTwz2u8TzCQnCFweeiQAYPchL/4brCEdM0imIrpME2mn
	 gnD/kk/7+c1FA==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-67a000ac7efso630374d50.0
        for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 07:26:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy7g3dESl2VZfDC9VlDSZfJC297BSYrpo5l+cKl17dW2FsoAJEXa8in7K/F3k8uOri2u4KPEFlGjQFG@vger.kernel.org
X-Gm-Message-State: AFq9FYJWwJMWEOKMJwjhkgt6YvU3qIsjLG8ZZl+AQcokMd3x3fCSiOiN
	APNidsr2XpTHPZDIUen0jybTesInO9Q+bioBz1MKHmgRhIvTPpevitTouZO2VwGsmL/CVQIAO+h
	28F/d6TUc0yY9+Ngr3KzhYnXXZjYQl8k=
X-Received: by 2002:a05:690e:4807:b0:679:b8df:28b with SMTP id
 956f58d0204a3-67ba4f8f081mr1033697d50.70.1793370393885; Fri, 30 Oct 2026
 07:26:33 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029140535.260498-1-icb@fastmail.org>
In-Reply-To: <20261029140535.260498-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 30 Oct 2026 23:26:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd94Fe0awVpprg+41Xc+S+nr79g1jU75oeH4Trd2WWwSqg@mail.gmail.com>
X-Gm-Features: AclHuK-Ho_4afsFO6-fJ1lKj2t6u439S-kMdb6aejFKGUXdj0GxDlskcqPziKvs
Message-ID: <CAKYAXd94Fe0awVpprg+41Xc+S+nr79g1jU75oeH4Trd2WWwSqg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: enforce the DACL permission check on
 delete-on-close opens
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 11:05=E2=80=AFPM Ian Bridges <icb@fastmail.org> wro=
te:
>
> smb2_open() skips the DACL check for delete-on-close opens of existing
> files. On an acl_xattr share, a caller who passes the POSIX checks can
> therefore delete a file even when its stored DACL grants no access. The
> handle can also get read or write access that the DACL denies.
>
> Add a dedicated DACL check for these opens. Evaluate the applicable ACEs
> in order (MS-DTYP 2.5.3.2). Allow the parent directory to grant DELETE
> and FILE_READ_ATTRIBUTES under MS-FSA 2.1.5.1.2.1. Use the DACL grants
> when resolving MAXIMUM_ALLOWED.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Can you check Sashiko's review comments ?

https://sashiko.dev/#/patchset/20261029140535.260498-1-icb%40fastmail.org

Thanks.

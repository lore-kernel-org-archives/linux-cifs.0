Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C001FF7C8
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 00:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787619588; cv=none; b=VGv9GQXkgfQR0L1+A/3r/Ax8DHvktJYhgvnwSTDqmuf4o4Zi5csG4vkUyVIPodOT5nJp4PF/RahlqFBLSWBr6tUpqAtyGenj07Rim02jC3b2+Ly6lks8reRnPDcOdBrVb+hLxxH+MOsqd6esKBQGlUXlI5pNF/h4RIBvEVjJmfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787619588; c=relaxed/simple;
	bh=shNeVnxgPhWMkYieAjhk/IVt3GNRZrYxtX3YDmzS3TA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mey3N3CRWOvqMpu+V0FjOuFuHMS8yX0s37OnFGRPQU6Rnb16lMQpE2PKH3fwM5tYrmSWiXNkuvaqTMsbBGfT+V9OPXAZkSpITNTqEYdISN8NJ00xhV283EnHtzwVwJukBjTTJjvzz52RNpWA/0Qf1Z3hmJeAOo9Nby+Pf80oj08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZ1CkjrE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZ1CkjrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35BB1F000E9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 00:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787619586;
	bh=fEeLpys/hVxa2Jf6DKcJxfPsS9WWpLFcb2O+9vN9MkM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jZ1CkjrE/WO7HgRj4ykZ3O1LSXBlCcpm8d81yRNJncKXkk5HCTFzVErjaS16Nkd4L
	 wJhH+u6JagbgW+u395lO8MU5VakLMeSyAX0hDNsxhyb/UgJwyYOgXw0oF+014/fFH3
	 BCA7Epoq7IQF9M3f0p4Wfx08zWE5m7N3xRQFCk6S0ulJyWhGnVe89ScJ8jJNPcjI/7
	 k25aTGI6rKzAz1k/NO3z3WtlPJx3mCpyD4sZ6gpj/dx3W2V5VaONcvyvaMTo7HVkSW
	 nwik5fkobaPh25vPRC5qgdaIoKD0/IfFrKxbov+jrVwEqxWSLqwpZXBonK2yWQmbDz
	 TY2+AscTNd8bA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15f020a223so614295666b.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 17:59:46 -0700 (PDT)
X-Gm-Message-State: AFuF++mUPqbW8UQoAebBAlf8/t+27RObj7zmOiHkYpHIxPZQEtfSVpcq
	tBUtsFqr5EQNj7mY6T2RUwf8g3wqPAwcagvibGe95p9psSiXz38nzR2FBxw92dYED9Z038rK7HF
	ffEGHqJT1PsbEKyqAXsOnjv394VKnTzc=
X-Received: by 2002:a17:906:5183:10b0:c16:84dc:9607 with SMTP id
 a640c23a62f3a-c246a704562mr2696668566b.19.1787619585652; Mon, 24 Aug 2026
 17:59:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824231030.3502884-1-sorenson@redhat.com>
In-Reply-To: <20260824231030.3502884-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 25 Aug 2026 09:59:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_E2ZGzXzRJWCu4knD50LjXrC+dn4JPr8jxNMi5daWLCg@mail.gmail.com>
X-Gm-Features: AcwNN1Xsc64SaR3a-QfPBo5enA5iYQb8CTtqMRRw6llvE8QowJrPmHoHeU0QLKM
Message-ID: <CAKYAXd_E2ZGzXzRJWCu4knD50LjXrC+dn4JPr8jxNMi5daWLCg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix OOB pointer arithmetic in cifs_to_posix_acl()
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, brauner@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 8:10=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> In the ACL_TYPE_DEFAULT branch, cifs_to_posix_acl() forms a pointer
> from the server-supplied access_entry_count before the size check that
> bounds it:
There seems to be still oob issue in this function although this patch
is applied.
Should we also validate acl header before accessing ->version ?

+        if (size_of_data_area < sizeof(*cifs_acl))
+              return -EINVAL;

        if (le16_to_cpu(cifs_acl->version) !=3D CIFS_ACL_VERSION)
                return -EOPNOTSUPP;
>
>         pACE =3D &cifs_acl->ace_array[count];     /* count =3D access_ent=
ry_count */
>         count =3D le16_to_cpu(cifs_acl->default_entry_count);
>         size +=3D sizeof(struct cifs_posix_ace) * count;
>         if (size_of_data_area < size)           /* too late */
>                 return -EINVAL;
>
> The pointer arithmetic is undefined behaviour before any bounds check.
>
> Add an access-ACE size check before the pointer computation, matching
> the existing guard in the ACL_TYPE_ACCESS path.

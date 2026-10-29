Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793234840;
	b=B0mMLkeOMQLVfyKKMHlg0vq+l8Hu6lekveWIto5LTHu1C2VIiwQQ2CHUVrCj7PBXKIQq
	 NrHmltPPE0GL+52lAxWb0mydj7ycs6yekenIU3dqj0soCC9o5zXgejpe0zUfXfL9/smUG
	 ZiAMKWoiwAj5+/BoLHHx8btNjMSHYv7FfmgFp7OweIONnO19r627Yy9c/81l+BZcam1c8
	 G29WGxEXFUcs+87Wcc4CvuvRrUETSLOKukVy/yKubhBifA0fWYa6mbXUwViDacR7gSFDq
	 6gE/3Tk+afYy5XcSaCbZckxm8x+AtARTApaX7xPZ52+26xK59JF8OT/Gniy7m8OqU4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793234840;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=DB7cgiiNFIMYg+TGa+Y0Nbaz13YDr1tH09PhZ+M5HVg=;
	b=qH621iMIwr7UqivJco5E37b9LYvzgMqcoXz1yRo4vLHjW+5hIlnfNXhPAlf4d3LlwRMs
	 BroY1zoD4sXya+1JYFrizNW5IMxXQv0HwDqFEzLsZ65ZkjmhQnCE37SvNfU7ZtNm4OXZm
	 M2zen5cP0ntkW9Cn4I0857QKyJs9Aj0ZzKE+TMiRogcG28HTI6ff7mT3pvcv06NklfNVF
	 VQVixvGI/T8aImBjOO5NQoabNxcy2yT6Car9yWSGv0opGFbvDVo9z7p3w4SG136xQ/fRL
	 scjDPUJAwZoXqCOtymGB/VfZL/I34sTSW8jHANQ/X40F6wejjPvVF4ta742LfDeJpMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPXeJ9NT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFFA606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 00:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPXeJ9NT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28E31F01828
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 00:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793234839;
	bh=DB7cgiiNFIMYg+TGa+Y0Nbaz13YDr1tH09PhZ+M5HVg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TPXeJ9NTr6Xpvoi2jpIZdpItLtVRaOzPJrCQoN+UbL8T3Eyd/EEIPADHpFB9WCewA
	 l3xHousJit/Lzd3hkT/EWiwB2J8tYw97IeUjMWt1/UFQWEMjoLmri4DDolgbrThVo3
	 3u0N4dpGUbMzDymeFIGPKkY/BjsU1rRnIna2V8PmlU8YxE1Okx0QoKK8cj2jfkhMG1
	 07efSr39y57kpskpUewlllkcMppoRLlXMBOwj82qUGnnToygZ8WdzqhxgTRjnHEgdR
	 ygPMmcYhfgNrw6u5E3bfQbG+bxWkj6Da/6huDhPPNFZyf8JHBVpNoJQuLwBA2E3jXa
	 HpJpRKPQEptzw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso2258489a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 17:47:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzUNgUlr10iBBBmwpcW4iKSp4rpebaiT53W3qLBTEsBf+yH3CjPpp6eWJI4kgL1TD/IZNulAcAmdsVq@vger.kernel.org
X-Gm-Message-State: AFq9FYLVpg07DPduLxHddwtCBXUr0HZxaXgL25XMjDjSW1RjnSlXziuP
	lMZyhxl+1CAC/FVQcF2w4j2HkPijfC9iSzXf1aEAxk960Ubq+OJwHlyAEbO4tDgDWV+AjTG7lO7
	MxXB8NrZzc+/DaQlVjyD2ZUG/z3DXzrs=
X-Received: by 2002:a17:906:6205:b0:c49:b9b6:4b5e with SMTP id
 a640c23a62f3a-c49bdf37622mr337435566b.20.1793234838384; Wed, 28 Oct 2026
 17:47:18 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026222600.17323-1-pali@kernel.org> <20261026222600.17323-9-pali@kernel.org>
 <CAKYAXd-hQXxBLxLQ_dr5omw-_xgL+96fNYfgW_poAihXYqDxmA@mail.gmail.com> <20261028234530.2bnbxbotnegss5ll@pali>
In-Reply-To: <20261028234530.2bnbxbotnegss5ll@pali>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 29 Oct 2026 09:47:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8KHVA0JwfiZBgnzsbw5rp+jNK7u=uP3Rmy4a-H_i9pBw@mail.gmail.com>
X-Gm-Features: AclHuK9a6qk7w1o90fukoKk0lkxf2uZ2LwiaWKQYkwxqUYS983ONXfKBL1_6qI4
Message-ID: <CAKYAXd8KHVA0JwfiZBgnzsbw5rp+jNK7u=uP3Rmy4a-H_i9pBw@mail.gmail.com>
Subject: Re: [PATCH v7.3 8/9] cifs: Add support for parsing WSL symlinks in
 version 1 format
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 8:45=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Tuesday 27 October 2026 10:37:45 Namjae Jeon wrote:
> ...
> > > +               oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path, FILE=
_READ_DATA,
> > > +                                    FILE_OPEN, CREATE_NOT_DIR | OPEN=
_REPARSE_POINT,
> > > +                                    ACL_NO_MODE);
> > > +               oparms.fid =3D &fid;
> > Should we pass initialized fid to ->open()? When SMB2/3 leasing is
> > enabled, the open path copies fid->lease_key into the outgoing CREATE
> > request, potentially disclosing 16 bytes of stale stack data to the
> > server ?
>
> I think that I have copied this pattern from somewhere. So maybe the
> same issue is in other parts of the code.
Right.
>
> > So, how about updating it like this ?
> >
> > struct cifs_fid fid =3D {};
> > ...
> > if (tcon->ses->server->ops->new_lease_key)
> >     tcon->ses->server->ops->new_lease_key(&fid);
>
> I will look at it.
Okay.
>
> Anyway this series contains various changes and these last two PATCH8
> and PATCH9 are not needed for rest of them. So if there is no issue with
> PATCH1-7 I would like if we can process at least first 7 without need to
> address issues in 8 and 9. I'm waiting for these changes for a longer
> time and mostly I'm just resending 1-7 without any modification, just
> rebasing them.
Agreed.
Thanks!

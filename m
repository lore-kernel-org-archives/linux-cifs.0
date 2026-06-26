Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D4C5CDF1
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 01:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782435838; cv=none; b=NJwcysytbCR3zcDJYFjq447yWlGih6BVR8+Cg7mnExYjIF9aFOD0T2pLQ9Tmr8c1qUX/a/7MXctI43OjHnLM9t6P4CV/EHhWBLh3B5OHIrcahPCFDbnd7t08iMr9cexyn3SrAWmoBVZaSfuz/cNO80u1gMxpptn+e1kvB64rIME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782435838; c=relaxed/simple;
	bh=SabxNG+FDCStIJ5y50go2VXK33OSsjAq3Agw5JUkBD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oYHgQ/1h3zDE1FK0TLY+UPdUZAwarOvUioFrR0bzVZNYg3YEpL4kMSc4ESW2FcujS2NVQAf24johXWhNKgCVya/GldXoOS7AmRKtU51je++Ny5XCkCfmpRtAtF88xW6kcVnq3mu2tEf1sQ79DokNbuZwueKQZ1e2Btb0yel1GD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n99tn0CN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n99tn0CN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F781F00AC4
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 01:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782435837;
	bh=hZ4vp4aOQyWamwVUP3pyhylXWh9pjQCtTrtkFC7x7uw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=n99tn0CN9JckOP6VN7nruktEs9OrujX2olmkzejRvTUpxV8UiR6yNU95ODlLUyVDv
	 rBGYTR5uH1GhIcPnWFKXXnWI73G5slSJixQ5HtTh7q65o3Zd8PsvR9k0knuongPdey
	 d0mx3eLwIbA3TvOONTNJ8LHkYi+4RW6LVwnGVHsct7kSSM4zrTVFXs21Hyq7HeoV9n
	 IT3TV8zjhrkTD6kaOLf2yq4NJb04EpiuHemWHkaGojZH1TV6QOZ7hrOr+021je3DeY
	 4kN0/uskeweXe8U28Ey5piEcFMb/qbboD6CIp7ekqscKdq+WC2NDPLPGzhdIItkDjl
	 3ZAPQY0iyYhHA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec423a5265so62033066b.1
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 18:03:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpIp8nLiUVjvTOQbEaXtsJjtcBRaOCSB/gNZPrN03Hhdup+Jesn33Afv3w/QffvgLd6LcndtnPHiyYT@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9cbsE99GWg8P8me/qxVQ9d60zne7b8U3Hi5pum2VyUa7DlK+3
	wzI3c8fXwR1xgpUIza97junTfECInj3uojtwJoCHUCBPYvJwRtK1n8Rncdg/N7GRRTKDWQlfh+b
	pG9VsMojDnLcuAVElkfoyAhxcCThXtek=
X-Received: by 2002:a17:907:d88:b0:c0e:883e:e4e1 with SMTP id
 a640c23a62f3a-c1205f0af7cmr321481966b.48.1782435836027; Thu, 25 Jun 2026
 18:03:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626005217.524940-1-lihaofeng@kylinos.cn> <20260626005217.524940-2-lihaofeng@kylinos.cn>
In-Reply-To: <20260626005217.524940-2-lihaofeng@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 26 Jun 2026 10:03:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8xj4J3CHnzsij76FRh32WvUb9mGP9pq2q72yDX-YYnJw@mail.gmail.com>
X-Gm-Features: AVVi8CfSZFM-2QvuEkY6waAy1E-CHf0K7iW5IZzgPJqxO8vQ9zXB9cCmBrf6AUo
Message-ID: <CAKYAXd8xj4J3CHnzsij76FRh32WvUb9mGP9pq2q72yDX-YYnJw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
To: Haofeng Li <lihaofeng@kylinos.cn>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 9:53=E2=80=AFAM Haofeng Li <lihaofeng@kylinos.cn> w=
rote:
>
> set_ntacl_dacl() copies each ACE from the attacker-controlled stored
> security descriptor verbatim into the response DACL without checking
> sid.num_subauth. The ACE bytes (including an unchecked num_subauth)
> originate from an authenticated SMB2_SET_INFO(SecInfo=3DDACL) that is
> stored raw via ksmbd_vfs_set_sd_xattr(); parse_dacl() rejects a bad ACE
> with `break` rather than an error, so parse_sec_desc() still returns
> success and the malformed SD reaches the xattr intact.
>
> On a subsequent SMB2_QUERY_INFO(SecInfo=3DDACL) for an inode carrying a
> POSIX access ACL, build_sec_desc() -> set_ntacl_dacl() ->
> set_posix_acl_entries_dacl() walks the copied ACEs and reads
>
>     ntace->sid.sub_auth[ntace->sid.num_subauth - 1]
>
> with num_subauth taken straight from the stored SD. Since sub_auth[]
> is fixed at SID_MAX_SUB_AUTHORITIES (15), a crafted num_subauth (e.g.
> 255) drives an out-of-bounds heap read of ~1 KB with an offset fully
> controlled by an authenticated client.
>
> The sibling functions already gate this field:
>   parse_dacl()    -- num_subauth =3D=3D 0 || > SID_MAX_SUB_AUTHORITIES
>   parse_sid()     -- num_subauth > SID_MAX_SUB_AUTHORITIES
>   smb_copy_sid()  -- min_t(u8, num_subauth, SID_MAX_SUB_AUTHORITIES)
> set_ntacl_dacl() is the lone inconsistent path that omits the check.
>
> Add the same num_subauth validation in set_ntacl_dacl() before copying
> the ACE, matching the gate already enforced by parse_dacl().
>
> Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks!

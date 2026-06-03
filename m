Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184AF3D3D07
	for <linux-cifs@vger.kernel.org>; Wed,  3 Jun 2026 02:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780453220; cv=none; b=FMwyUJ3RxOmKzSfkxjKa2f9WKHsl+1cjQIX9AiJdt7gBTWBDmMfiHegNZA1jOT06KyQCH6p5iXe2xsOqkgdoTx5AEg45ua9Rm9YKmfSz6vWaGelGbSXtgI0+NqTbeee2CX4i+iLikJUvr4EGNNjf22UEdP7VP7EjgmHvEl/GYz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780453220; c=relaxed/simple;
	bh=HgxEtv+A2qKraBVAuqP+/2iLx0+3LmLFpvkFLTooJAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b70C3xTyGQ9KOowYyaJpBA/TYcvV2fxHmJX0k7d7jxfqnF/O1RRQRUh5iIHUqR+F7ZMI1q2nBHOU9zT3RXzss+Kpi3mLoqJDL/nplHabYcNEHLV6pyWGC8UWTuxDXNUSbd9Iq6ukfCOZta0TizFivZcCzlbsBQNbe5qTbMuyrFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts02qBNu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts02qBNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDF51F0089A
	for <linux-cifs@vger.kernel.org>; Wed,  3 Jun 2026 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780453218;
	bh=HgxEtv+A2qKraBVAuqP+/2iLx0+3LmLFpvkFLTooJAE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ts02qBNu4eDgGECt4dv3TbrbDlX+7snlrk1F86/erHHSKzB92F2vJQ/sxD/OTxxcs
	 NJkkbugjxE8gjJKCH4jimG82H1PLHMoMYfhiAAqoWS8U7W314glaLmdEeQbooic9xz
	 2TXKxUbFUvx07n7ADjUUzcw8hr5zboC4vX9P0ikGav37JGny/IoyXM2ev9qalp+3/p
	 cdNHJf6piUNGs/us/11nBbNLMjTiMm+IXV+0R9wmZZ8SZD0xpgpPIdxmR4BYuzqVsO
	 xPnAI/qp4yImAfdJDdv/Bdvc7V7A3/axEF/kcQy/qBCdaX2/gJiKqt4rj7AdzpxfBD
	 /9qRAuqwL9bRw==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bebc80100efso391419366b.1
        for <linux-cifs@vger.kernel.org>; Tue, 02 Jun 2026 19:20:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+tICMNMNp3bbPukFXYN6SoVrCb6nfrqWQJK83pPP3pikxJPqIieCBuXXNZ/lbKxxkKnTj6yLiEgPPY@vger.kernel.org
X-Gm-Message-State: AOJu0YyYYJk+gnaLWLpGSi3JDEOBVA68hfxIVls1s81pQ2QCWLkA8N/g
	bgDIaabOB/LT4YpnkkaRztcMCDENNe9yrfI/Q4zvXXVzZklVrNXLlXYzA00hUbrrnXROa0Hyw4Z
	sGzqYk6H2rMmeO3ocLfDnczRWTTJzKO0=
X-Received: by 2002:a17:907:7290:b0:beb:7b50:3a7b with SMTP id
 a640c23a62f3a-bf0ac40aff4mr45067366b.6.1780453217454; Tue, 02 Jun 2026
 19:20:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260602235646.23581-1-hemparekh1596@gmail.com>
In-Reply-To: <20260602235646.23581-1-hemparekh1596@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 3 Jun 2026 11:20:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_hNhenv7_+HtyZ66zyw5bCyN16ki2RTRf5BEYyCkxGYg@mail.gmail.com>
X-Gm-Features: AVHnY4LPDH63fHGyXR5ToGAYaxEwE0MdRK87mQcFQ5V7YsmEbTyQVwyAVM-jwWY
Message-ID: <CAKYAXd_hNhenv7_+HtyZ66zyw5bCyN16ki2RTRf5BEYyCkxGYg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix out-of-bounds read in smb_check_perm_dacl()
To: Hem Parekh <hemparekh1596@gmail.com>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 8:56=E2=80=AFAM Hem Parekh <hemparekh1596@gmail.com>=
 wrote:
>
> The permission-check ACE walk in smb_check_perm_dacl() validates the ACE
> header size and caps sid.num_subauth at SID_MAX_SUB_AUTHORITIES, but it
> never checks that ace->size is actually large enough to contain
> num_subauth sub-authorities before compare_sids() dereferences them.
>
> CIFS_SID_BASE_SIZE covers the SID header up to but excluding the
> sub_auth[] array, and offsetof(struct smb_ace, sid) is the ACE header,
> so the existing guards only guarantee the 8-byte SID base, i.e. zero
> sub-authorities. compare_sids() then reads ace->sid.sub_auth[i] for
> i < min(local_sid->num_subauth, ace->sid.num_subauth). The local
> comparison SIDs (sid_everyone, sid_unix_NFS_mode, and the id_to_sid()
> result) always have at least one sub-authority, and an attacker controls
> the ACE revision and authority bytes (which lie within the in-bounds SID
> base), so they can match one of those SIDs and force the sub_auth read.
>
> A crafted ACE with size =3D=3D 16 and num_subauth >=3D 1 placed at the ta=
il of
> the security descriptor therefore causes a heap out-of-bounds read of up
> to SID_MAX_SUB_AUTHORITIES * sizeof(__le32) bytes past the pntsd
> allocation. The security descriptor is loaded by ksmbd_vfs_get_sd_xattr()
> into a buffer sized exactly to the on-disk data (kzalloc(sd_size) in
> ndr_decode_v4_ntacl()), so the read lands past the allocation. The
> malformed descriptor can be stored verbatim via SMB2_SET_INFO (the DACL
> is not normalised before being written to the security.NTACL xattr) and
> the read fires on a subsequent SMB2_CREATE access check, making this
> reachable by an authenticated client on a share that uses ACL xattrs.
>
> Add the missing num_subauth-versus-ace_size check, mirroring the
> identical guards already present in the sibling parsers parse_dacl() and
> smb_inherit_dacl().
>
> Fixes: d07b26f39246 ("ksmbd: require minimum ACE size in smb_check_perm_d=
acl()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hem Parekh <hemparekh1596@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!

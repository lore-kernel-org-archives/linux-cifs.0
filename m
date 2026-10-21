Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792545403;
	b=eUujZw/ydLh/cs4HicBCm1SwSThR4MI1GkTs37GdP73s2SPDK6A7xd/AHh+KkIHkNC7U
	 zZG3yvZh/kW2M7bu40epuNZWqfyWInvnNvBJX6RG/zFdXZoD+WPk+KLFrcIeyOyexJ3TM
	 bP6kDhtQcJMLy+WBE+cPdUHa404rV0upkeoqifKyMtEux1r2xlcJTFcNlDJ3jxYmsdRAD
	 GHlX82760V9LQz6ZQEs+4a80v98MsrnaBACezpCdu9hcRtC1SShig7gxU4T7R9gVRnyPw
	 VXcgwjBEzZkNbX4PwpoCdpETotdcH3z7dRcnySNkvGheCWwveEPHjdNaSKvSAzCHJHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792545403;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XQf033HRKJc+nAHb7sUQOAs1qCf2tDOM3C/wF7UdzeQ=;
	b=BeRSLNB+wyomz0jX/rLjugPgBCmJHAmU+F7iJ9y1wTzT+crcYRKKHaJtJg4qzk50nWAd
	 4E6cYRYQ6zlfGATyKEbuohSkfnjQTbFXt/tu4PtowH7phCyzkJXmbY9ytQ4fPJqkYORVc
	 UtKzhli4ULvFVa+cT/it9GiiKdjZ2OAr2pe71XIp1JEGpr7hzbcspZSva4gQ4NO9TKJ8G
	 koie1sgyFBQSqHHsVhigjzv7RGqnB0cCPLtm+/Kwau/3M81oHbNW2npvI6hgIIvhIha9J
	 rUFtAYSsMc1xc+VPTWc+4xbu3fadjCEqCEvbMTBMXDP99PNSgzsO3bp5MQxjofd1YSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X7zC1p+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE893606A31B
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X7zC1p+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F361F000CC
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792545402;
	bh=XQf033HRKJc+nAHb7sUQOAs1qCf2tDOM3C/wF7UdzeQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X7zC1p+5JIPTEJoGGdAVY+zGUtkmkg58eKLXH6nNl8jHPcQMp4fh6Mbh2A4MAlqNl
	 BFc4oYa+YQgLzFNxkNl6LGFRc+JVSr4V0Oux6w64/4ZTfyIXa9FJsNqXtT7ynSwMtw
	 ZvKDCJyi1ozcQPnnVu2P78xajxhpo5mM9cx1eueft11E0caJWmdA+EzgMApOZwXutu
	 gKRaYn/Me+WRRGeJ4qvR0ORq4Sj+UMoXZGSkIU5SxWQY4tcSo8XGD2lF3MjMtgZb2A
	 d2aLyHie8unFpXCeJ62nkw75+hQ9wRrpXRqZVQ40FJaK1e6lQL9bXybFP8m7diBEwY
	 GRaAv7/Ly2xqA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2055573c8cso11649766b.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 18:16:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxn0cVzYQwGcGZlVBIUkQW9tu5dkVfMQCFnUmpfSiX+khq+8Mk5f82BF62oAXaEwigbJqItN0yb3+K2@vger.kernel.org
X-Gm-Message-State: AFq9FYKYSualiUDdjWZye2I0oL8TR/wMV5S1Kj8TA8mWGTkVWKMAGZGE
	3LWqiZpkjZOAS/OjALDD/lHNvJX0YxCMdV5uYw4shZqMQ/b5keMzQ/w3szIwdNbdnlN3qXeIcHa
	uYh9i3/zL71oGLULnBZwnIEUdP7ackUM=
X-Received: by 2002:a17:907:2d92:b0:c46:645f:ced9 with SMTP id
 a640c23a62f3a-c46795e8002mr51901066b.10.1792545401324; Tue, 20 Oct 2026
 18:16:41 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <AS8P251MB000104EEF679ECC44D8791F2C8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
In-Reply-To: <AS8P251MB000104EEF679ECC44D8791F2C8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 10:16:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_cyS11k387nM-DfNORyZbTpexC9dQBtDjrhjy2FQKT2Q@mail.gmail.com>
X-Gm-Features: AclHuK-ZDQ3NXb3m5c0xNio5bQaHfkfxZPyPk1f2Yr4vlT42M-8V3UIjNVEiMaQ
Message-ID: <CAKYAXd_cyS11k387nM-DfNORyZbTpexC9dQBtDjrhjy2FQKT2Q@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: deny access for an empty DACL instead of
 granting the request
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Ronnie Sahlberg <lsahlber@redhat.com>, 
	Steve French <stfrench@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 16, 2026 at 7:49=E2=80=AFPM Aamir Ahmed <elb12345@hotmail.co.uk=
> wrote:
>
> smb_check_perm_dacl() returns the access mask it computes to the SMB2
> CREATE handler, which uses it as the granted access for the open. For a
> security descriptor whose DACL is present but contains no ACEs, the
> function is supposed to deny access: an empty (non-NULL) DACL grants no
> access to anyone except the object owner's implicit READ_CONTROL and
> WRITE_DAC (MS-DTYP 2.4.5).
>
> The empty-DACL branch only denies when both
>
>   - the DACL has no trailing bytes (pdacl_size =3D=3D sizeof(struct smb_a=
cl)),
>     and
>   - the request contains bits beyond READ_CONTROL / WRITE_DAC.
>
> In every other case it takes the shared "goto err_out" with rc still 0,
> which returns success without modifying *pdaccess, so the caller grants
> the full requested access. Three problems follow:
>
>   - The READ_CONTROL / WRITE_DAC carve-out models the owner's implicit
>     rights, but the check runs before is_owner is computed, so those
>     rights are handed to *every* caller, not just the owner. For
>     READ_CONTROL the SMB2 CREATE path does not fall back to
>     inode_permission(), so any user can read the security descriptor of
>     an object whose empty DACL is meant to deny them.
>
>   - A request of exactly READ_CONTROL and/or WRITE_DAC is granted to any
>     caller. WRITE_DAC lets the handle rewrite the DACL.
>
>   - A DACL that declares zero ACEs but carries trailing bytes
>     (pdacl_size > sizeof(struct smb_acl)) skips the deny entirely and is
>     granted whatever was requested.
>
> On shares where the NT ACL is the authoritative access control -- e.g.
> "force user" shares, where every client maps to one POSIX identity so
> POSIX cannot distinguish users -- this is an access-control bypass.
>
> Compute is_owner before the empty-DACL branch and deny access from an
> empty DACL unless the caller is the owner requesting no more than
> READ_CONTROL / WRITE_DAC.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Applied it to #ksmbd-for-next.
Thanks!

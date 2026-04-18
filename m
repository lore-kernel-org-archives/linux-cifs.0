Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD431B78F3
	for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 06:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776493700; cv=none; b=XFWqB0bJZnNFW6PGGZjuEEiEIr67wcW9ts2tJKlQXrzUaV5GVqzzk/1dw5ImYFxNHo1jUGbLpmgbFlsh0JsRBSxTHnYDIWTT47rG8Flj96RnLdMKrxnJEF4ZFUj257CubxmeqkUw3LhO2Nv5uPCyWkOSUVaRYOV6vQRLxHI6GUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776493700; c=relaxed/simple;
	bh=OKKixADUa7Qf6rDznlLGRF7ZfXVBuUqdH9SbW6P5uA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n7K6Kfxn2aYdMw93YtsrCAbkHhAks5Bml9w4qrirqSyCvCC3mp5JzO9jylz59CTIlmqXM/3DSkFerWBerM9FcndQeHYaUuSVuuPiuXGPOUpTQUjO9ESros9mQhDOmPvX1OrZpysIpcnDn+oqa3y8cfjrq95Ja23V/uK4IxHHwhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJhtncX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJhtncX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ABDC4AF0C
	for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 06:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776493700;
	bh=OKKixADUa7Qf6rDznlLGRF7ZfXVBuUqdH9SbW6P5uA8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kJhtncX6vJAa9PCdqesPeHRLM5VMsy61rrXYaj4M4Y5zbbDzNgDW8BooY8YDwdu56
	 Gqq/Vz7KwEMtJzmz0O276eTjtQBTomA0iEZyRS6LWt+Hg89TgM2LMT1GHdcA8QyMn6
	 Rr7kGWQZpzZSNYwDKzp/pqZl5VW8pOle3rZ5f7cIxcLVJn+W8YyuZI2gL2XkQp8Gep
	 gHaSD7+aDglEgK/7r7ufxIusnyTZeASAYfPBy7Epa5ONZLXj9/SaoLayTEFM+IxBwD
	 rAws1UK5+FwYZN9GnInmNQpor20ZkxRPMnF7PV58vyFiW4Gmz8CE8KoTJbrk4xOgTF
	 my9gW0DoLSiWQ==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6634bb959a2so1916487a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 23:28:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9xlUc7dJmraHNwoq+b0QAb546MHpm7Pq+Spb1nKc/MBFLbA8/uMBvNZpDdgfRTe9rxLZNpmpCm/m46@vger.kernel.org
X-Gm-Message-State: AOJu0YyfE48HqONFkLeFuy3oI2YhjZGNBlNE82CgzDFye2c0YIg8c9xC
	GLEhUZCfj+en3aRcQuHqnkmwlBoEcLc5cetJDCdCIZdKc9co+AOSavYe73HYNtKQftsw6/7slVA
	iWJ6wOi4WZMhS1v+FKz3TQwTP8sa1Oco=
X-Received: by 2002:a05:6402:90a:b0:66e:aade:e2e3 with SMTP id
 4fb4d7f45d1cf-672bfdde7b4mr2966711a12.27.1776493698960; Fri, 17 Apr 2026
 23:28:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416200439.2987930-1-michael.bommarito@gmail.com> <20260417184557.1138554-1-michael.bommarito@gmail.com>
In-Reply-To: <20260417184557.1138554-1-michael.bommarito@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 18 Apr 2026 15:28:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-C358TaLXHAMdfEn8FBNjjfN1ONq3tuDSAyguzc2qEjg@mail.gmail.com>
X-Gm-Features: AQROBzD3WcGqkyfD9s3HibPWpNoDBmgBkHVuGv04v9w7DgczlUEFgZ5QZ1DlAPQ
Message-ID: <CAKYAXd-C358TaLXHAMdfEn8FBNjjfN1ONq3tuDSAyguzc2qEjg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 3:46=E2=80=AFAM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> smb_inherit_dacl() trusts the on-disk num_aces value from the parent
> directory's DACL xattr and uses it to size a heap allocation:
>
>   aces_base =3D kmalloc(sizeof(struct smb_ace) * num_aces * 2, ...);
>
> num_aces is a u16 read from le16_to_cpu(parent_pdacl->num_aces)
> without checking that it is consistent with the declared pdacl_size.
> An authenticated client whose parent directory's security.NTACL is
> tampered (e.g. via offline xattr corruption or a concurrent path that
> bypasses parse_dacl()) can present num_aces =3D 65535 with minimal
> actual ACE data.  This causes a ~8 MB allocation (not kzalloc, so
> uninitialized) that the subsequent loop only partially populates, and
> may also overflow the three-way size_t multiply on 32-bit kernels.
>
> Additionally, the ACE walk loop uses the weaker
> offsetof(struct smb_ace, access_req) minimum size check rather than
> the minimum valid on-wire ACE size, and does not reject ACEs whose
> declared size is below the minimum.
>
> Reproduced on UML + KASAN + LOCKDEP against the real ksmbd code path.
> A legitimate mount.cifs client creates a parent directory over SMB
> (ksmbd writes a valid security.NTACL xattr), then the NTACL blob on
> the backing filesystem is rewritten to set num_aces =3D 0xFFFF while
> keeping the posix_acl_hash bytes intact so ksmbd_vfs_get_sd_xattr()'s
> hash check still passes.  A subsequent SMB2 CREATE of a child under
> that parent drives smb2_open() into smb_inherit_dacl() (share has
> "vfs objects =3D acl_xattr" set), which fails the page allocator:
>
>   WARNING: mm/page_alloc.c:5226 at __alloc_frozen_pages_noprof+0x46c/0x9c=
0
>   Workqueue: ksmbd-io handle_ksmbd_work
>    __alloc_frozen_pages_noprof+0x46c/0x9c0
>    ___kmalloc_large_node+0x68/0x130
>    __kmalloc_large_node_noprof+0x24/0x70
>    __kmalloc_noprof+0x4c9/0x690
>    smb_inherit_dacl+0x394/0x2430
>    smb2_open+0x595d/0xabe0
>    handle_ksmbd_work+0x3d3/0x1140
>
> With the patch applied the added guard rejects the tampered value
> with -EINVAL before any large allocation runs, smb2_open() falls back
> to smb2_create_sd_buffer(), and the child is created with a default
> SD.  No warning, no splat.
>
> Fix by:
>
>   1. Validating num_aces against pdacl_size using the same formula
>      applied in parse_dacl().
>
>   2. Replacing the raw kmalloc(sizeof * num_aces * 2) with
>      kmalloc_array(num_aces * 2, sizeof(...)) for overflow-safe
>      allocation.
>
>   3. Tightening the per-ACE loop guard to require the minimum valid
>      ACE size (offsetof(smb_ace, sid) + CIFS_SID_BASE_SIZE) and
>      rejecting under-sized ACEs, matching the hardening in
>      smb_check_perm_dacl() and parse_dacl().
>
> v1 -> v2:
>   - Replace the synthetic test-module splat in the changelog with a
>     real-path UML + KASAN reproduction driven through mount.cifs and
>     SMB2 CREATE; Namjae flagged the kcifs3_test_inherit_dacl_old name
>     in v1 since it does not exist in ksmbd.
>   - Drop the commit-hash citation from the code comment per Namjae's
>     review; keep the parse_dacl() pointer.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!

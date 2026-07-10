Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFF01A268
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 01:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783646730; cv=none; b=dwJI29lyOHeChaSPVYp0uF6ESwifiX9BIP/qp2irPyElhJ4Yye4gjTG9HfQfo0yWcprZUI1LxlUMIojob1lj5d8JaaDAE104+UZayw2oV7XA0nMk+OvOpeAr6BEsKeCIarNeTmaEGTUkzMo/h2kkrcqHd3haV2dke8VaChE/C+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783646730; c=relaxed/simple;
	bh=qMBivMREQjhPQ3B7sx+aiurFP+n7rpwyV2x0WkUvBU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JOTe+xhduyhF93owxmHForsORbhYf8ijaZ47qBz9jNcts457kY0QPzUpxJT9azWVNFuVSzFZOnWZI5vbeDpCW9LEfuJFfROS4uigfWCiqLcX7QaU2AjJCATp573/AwQiQdq7z0kv6SInO0fgmu7YOmTaKKP8nCxsWxdlERXqf2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ob0mqx8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ob0mqx8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F8B1F000E9
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 01:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783646729;
	bh=z2cNnAN4KbK7zBOfepREjqZR8cR+UmFF3nm/CmcThQc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ob0mqx8zoXTJylisNiY8V5ywpivV7nKtqnDUXH2dn6oc0xH3Ae0x5sv2al2f2dBeu
	 I7CmNGxKVjhWgsDUJnjDG+DN7k1TRlpXuh3QB9bldxEee7wY0dANy3ekZ99FSxuUxl
	 CfRfZfvNionAxHcrAc/L5V0efPDeB70MNGqK/0M8B4lj9GpDkDUWMcS5y1yw97Y3Ai
	 Ift3m1i40ziBUjpJNsEZh26MyhF3UU3ccKaGN0SEKhwWWe7RozWQq7CAjpw06kGlJu
	 NvaDGr6UzL3Mz1k7FtPXW29h18IOSM9yxhUR+IyxYN/+Tl9D8qrg4zzB2QsJMKg9gH
	 +rL9RTZidjFDQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-698b6c87884so628364a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 18:25:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rokwau8IcpbhZOp1pZPgZiH0CBZqtc7s4KXJniS0hMHevvBzHCuW94PsJienY78KwDN9nSim1odyHhi@vger.kernel.org
X-Gm-Message-State: AOJu0YykxvNiHbydt4Qumxaq8lS5+uGAok0ZscvgwX7qgwjoP4379Fl2
	bViXMG4LIWkN2ClK1Ub/k1EckByqIHB2N0/a6/hWirLIWZ4LoV7MzYqVBGwgC2E4VvRtQrF8h8c
	wadUm7rHwpSCKnNtLHqG0fPSI3eK+hJE=
X-Received: by 2002:a17:907:928b:b0:c12:7b3f:6c15 with SMTP id
 a640c23a62f3a-c15ce164235mr472749266b.62.1783646727764; Thu, 09 Jul 2026
 18:25:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709150530.44979-1-security@auditcode.ai>
In-Reply-To: <20260709150530.44979-1-security@auditcode.ai>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 10 Jul 2026 10:25:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9SuA0BcYd=m_FN4sN_ByE7knmkh7Qbsd4Y5Wt6hY0Dgg@mail.gmail.com>
X-Gm-Features: AUfX_mzQVfkdSQVVnX10DOM3kbVHxuUICZhLzLvRFLgZ9GB-pYfcXumn8RGmNdg
Message-ID: <CAKYAXd9SuA0BcYd=m_FN4sN_ByE7knmkh7Qbsd4Y5Wt6hY0Dgg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix integer overflow in set_file_allocation_info()
To: security@auditcode.ai
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2026 at 9:32=E2=80=AFAM Ibrahim Hashimov <security@auditcod=
e.ai> wrote:
>
> set_file_allocation_info() converts the client-supplied
> FILE_ALLOCATION_INFORMATION::AllocationSize into a 512-byte block
> count with:
>
>         alloc_blks =3D (le64_to_cpu(file_alloc_info->AllocationSize) + 51=
1) >> 9;
>
> AllocationSize is a fully client-controlled __le64 field; the only
> validation performed by the caller (smb2_set_info_file(), case
> FILE_ALLOCATION_INFORMATION) is that the fixed buffer is at least
> sizeof(struct smb2_file_alloc_info) =3D=3D 8 bytes. The value itself is
> never range-checked before this arithmetic.
>
> When AllocationSize is close to U64_MAX (e.g. 0xffffffffffffffff),
> "AllocationSize + 511" wraps around mod 2^64 to a small number
> (0xffffffffffffffff + 511 =3D 510), so alloc_blks becomes 0. Since any
> existing regular file has stat.blocks > 0, the function then takes
> the "shrink" branch and calls:
>
>         ksmbd_vfs_truncate(work, fp, alloc_blks * 512);   /* =3D=3D 0 */
>
> silently truncating the file to size 0, even though the client asked
> to grow the allocation to (what looks like) the maximum possible
> size. The trailing "if (size < alloc_blks * 512) i_size_write(inode,
> size);" restore is guarded by a comparison that is never true once
> alloc_blks =3D=3D 0, so the truncation is not undone. This lets an
> authenticated SMB client that already holds an open handle with
> FILE_WRITE_DATA on a file silently truncate that same file to size 0
> via a single crafted SET_INFO(FILE_ALLOCATION_INFORMATION) request
> advertising a near-U64_MAX AllocationSize, even though the request
> asks to grow the file's allocation rather than shrink it. This is a
> functional/data-loss bug, not a privilege-boundary
> violation: the same client could already truncate the file via
> FILE_END_OF_FILE_INFORMATION or a plain write.
>
> Fix it by validating AllocationSize against MAX_LFS_FILESIZE, the
> same upper bound the VFS itself uses to reject unrepresentable file
> sizes, before doing the "+511" rounding, and rejecting oversized
> values with -EINVAL. Bounding AllocationSize to
> MAX_LFS_FILESIZE - 511 guarantees the "+511" addition cannot wrap,
> and that the subsequent "alloc_blks * 512" values passed to
> vfs_fallocate() and ksmbd_vfs_truncate() stay within a representable
> loff_t as well.
>
> No legitimate SMB client asks for an allocation size anywhere near
> 2^64 bytes, so this only rejects a value that was previously
> silently misinterpreted as zero.
>
> Runtime-verified on a v6.19 KASAN test stand: sending SET_INFO
> (FILE_ALLOCATION_INFORMATION) with AllocationSize =3D 0xffffffffffffffff
> against ksmbd now returns -EINVAL and leaves the target file's size
> unchanged, where the unpatched kernel truncated it from 4096 to 0
> bytes.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> Assisted-by: AuditCode-AI:2026.07
Applied it to #ksmbd-for-next-next.
Thanks!

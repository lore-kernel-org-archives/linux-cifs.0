Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0C018800D
	for <linux-cifs@vger.kernel.org>; Wed, 16 Oct 2024 04:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729052836; cv=none; b=aDL8/LQK8BLzabsifBw62TjdIdiKVps8mIRw+hVakgiuCpYZuXWzxhqeeA/usEuDEQsM59tedGOvA/sN5xSJ27bTLmHSd34/uUcMFK9pGFXSkEICnQfET2su1jUb8k4Kykmf7xRpLIvr1pJVfzkwf3ZnH/XJBjDYjrKR7UknKkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729052836; c=relaxed/simple;
	bh=DpGl/W0UdihzD2eakHBf4MC8TgE/brzFWHiGTe5HJtk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 Cc:Content-Type; b=jVWtBPGUKifha5rOW9TrdocRZUnB82VQ6b68f/1V0yNpEnN8yKg3rSHFNru5WctWfvlyTGv8EpjIMuPjwTRGK6HLUJhaNAVswzmC/yxYW38JF6UHbDJ0ayfU4+yXemT3JBhWDMupLb3dgfnZ96BzK/fwbXRoz/0gxaNJR+zrjAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TQCUe1M6; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQCUe1M6"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539f72c8fc1so3077372e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 15 Oct 2024 21:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729052832; x=1729657632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NX2ox2unX/X4K/ImOYj4APWMNk0OjSh8u5EO31O+PgU=;
        b=TQCUe1M6Rh/AnZJflfVyM91AeFNz6ZSt376Kl0fqFUPOZlHH9+sxmMCuMwH3KdfxvG
         Z/CBpSLj7WX1DCDJiC1xneX7YgvttFCPArsZor83JKm5xidL9tXgFBJOtXB1n1uLng1N
         F4ks3/uabIaOLVM7PzHxrxo0dT73BZZIgKb9JeNqUs66Zw2qHxZC98YgirMSX9RPCdN1
         afWc87umHtG+qCPtBa/0Sv+FiY/bDl61ELEsETTyc19idXUigNzwDr2RoNKk+m12y790
         FFiORwbJ3cjEDyviXM0El+JyzF/csfE8713HwTLW+6qEtbJBeGK342eM0ZkcPB6wD7Je
         21yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729052832; x=1729657632;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NX2ox2unX/X4K/ImOYj4APWMNk0OjSh8u5EO31O+PgU=;
        b=ZmwhN0IgvuJvUzA6fr8ct17jOtgBop5IaPrxN+6m0o6Vr6fxxCZ2U8R4pOzkng8Krm
         v7G22KTMAxRFCgporNKZ6HWSE84TRpWYfWaclPC5W+DcXCqUQLdayayu+/tT/1cRctnf
         ZBjqZ6Mp0YBFYBQTur5f4X6pZdwFMFRAySNaQm1bGNFy/JVfBGrfOP3RAz0CHPqPzXTN
         apdpfC6q9R/QcGCbJUlmLu4Ie4fk42yE4mXUppQ7YQJbWb1YZUPBv3CbG+stzitTUpEx
         dEcJVhXEE5OQW5rui9s0CjtdyU/AXSPiOMINg/kGO9ROlBlCLg9zGieaEtBvO/uTIuHK
         hQtA==
X-Gm-Message-State: AOJu0YzwBRA+GSRYQAdE+xn9aX+/yX34Ka/OrPsGskdlUexfF7fx5qqe
	ZJKi+19xn0X/m9Hs/7wheGrujtoeMKYskpGnEnurzi4Ga2KjEytGFXCwNx5PV+TPE4u/PZaDFYt
	/aMBjqxZnakhjgc13cn2Er8JSrQEJ4D3u
X-Received: by 2002:a05:6512:2808:b0:539:f961:f485 with SMTP id
 2adb3069b0e04-539f961fae2mt4575272e87.29.1729052832150; Tue, 15 Oct 2024
 21:27:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241015220404.503324-1-pc@manguebit.com>
In-Reply-To: <20241015220404.503324-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 15 Oct 2024 23:27:00 -0500
Message-ID: <CAH2r5ms-NQ9Vs4NqaZOs2zOAjCRozbdYsv3WT09U6znYOEF1SQ@mail.gmail.com>
Subject: Re: [PATCH v3] smb: client: fix OOBs when building SMB2_IOCTL request
Cc: linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing and review

(running buildbot on it now)

On Tue, Oct 15, 2024 at 5:04=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> When using encryption, either enforced by the server or when using
> 'seal' mount option, the client will squash all compound request buffers
> down for encryption into a single iov in smb2_set_next_command().
>
> SMB2_ioctl_init() allocates a small buffer (448 bytes) to hold the
> SMB2_IOCTL request in the first iov, and if the user passes an input
> buffer that is greater than 328 bytes, smb2_set_next_command() will
> end up writing off the end of @rqst->iov[0].iov_base as shown below:
>
>   mount.cifs //srv/share /mnt -o ...,seal
>   ln -s $(perl -e "print('a')for 1..1024") /mnt/link
>
>   BUG: KASAN: slab-out-of-bounds in
>   smb2_set_next_command.cold+0x1d6/0x24c [cifs]
>   Write of size 4116 at addr ffff8881148fcab8 by task ln/859
>
>   CPU: 1 UID: 0 PID: 859 Comm: ln Not tainted 6.12.0-rc3 #1
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>   1.16.3-2.fc40 04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x5d/0x80
>    ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
>    print_report+0x156/0x4d9
>    ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
>    ? __virt_addr_valid+0x145/0x310
>    ? __phys_addr+0x46/0x90
>    ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
>    kasan_report+0xda/0x110
>    ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
>    kasan_check_range+0x10f/0x1f0
>    __asan_memcpy+0x3c/0x60
>    smb2_set_next_command.cold+0x1d6/0x24c [cifs]
>    smb2_compound_op+0x238c/0x3840 [cifs]
>    ? kasan_save_track+0x14/0x30
>    ? kasan_save_free_info+0x3b/0x70
>    ? vfs_symlink+0x1a1/0x2c0
>    ? do_symlinkat+0x108/0x1c0
>    ? __pfx_smb2_compound_op+0x10/0x10 [cifs]
>    ? kmem_cache_free+0x118/0x3e0
>    ? cifs_get_writable_path+0xeb/0x1a0 [cifs]
>    smb2_get_reparse_inode+0x423/0x540 [cifs]
>    ? __pfx_smb2_get_reparse_inode+0x10/0x10 [cifs]
>    ? rcu_is_watching+0x20/0x50
>    ? __kmalloc_noprof+0x37c/0x480
>    ? smb2_create_reparse_symlink+0x257/0x490 [cifs]
>    ? smb2_create_reparse_symlink+0x38f/0x490 [cifs]
>    smb2_create_reparse_symlink+0x38f/0x490 [cifs]
>    ? __pfx_smb2_create_reparse_symlink+0x10/0x10 [cifs]
>    ? find_held_lock+0x8a/0xa0
>    ? hlock_class+0x32/0xb0
>    ? __build_path_from_dentry_optional_prefix+0x19d/0x2e0 [cifs]
>    cifs_symlink+0x24f/0x960 [cifs]
>    ? __pfx_make_vfsuid+0x10/0x10
>    ? __pfx_cifs_symlink+0x10/0x10 [cifs]
>    ? make_vfsgid+0x6b/0xc0
>    ? generic_permission+0x96/0x2d0
>    vfs_symlink+0x1a1/0x2c0
>    do_symlinkat+0x108/0x1c0
>    ? __pfx_do_symlinkat+0x10/0x10
>    ? strncpy_from_user+0xaa/0x160
>    __x64_sys_symlinkat+0xb9/0xf0
>    do_syscall_64+0xbb/0x1d0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   RIP: 0033:0x7f08d75c13bb
>
> Reported-by: David Howells <dhowells@redhat.com>
> Fixes: e77fe73c7e38 ("cifs: we can not use small padding iovs together wi=
th encryption")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
> v1 -> v2: fix ALIGN() usage
> v2 -> v3: remove pr_err() used for debugging
>
>  fs/smb/client/smb2pdu.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index b2f16a7b696d..6584b5cddc28 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -3313,6 +3313,15 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP=
_Server_Info *server,
>                 return rc;
>
>         if (indatalen) {
> +               unsigned int len;
> +
> +               if (WARN_ON_ONCE(smb3_encryption_required(tcon) &&
> +                                (check_add_overflow(total_len - 1,
> +                                                    ALIGN(indatalen, 8),=
 &len) ||
> +                                 len > MAX_CIFS_SMALL_BUFFER_SIZE))) {
> +                       cifs_small_buf_release(req);
> +                       return -EIO;
> +               }
>                 /*
>                  * indatalen is usually small at a couple of bytes max, s=
o
>                  * just allocate through generic pool
> --
> 2.47.0
>


--=20
Thanks,

Steve

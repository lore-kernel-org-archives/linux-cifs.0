Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2B8502BE
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 15:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758815187; cv=none; b=JhVm111hb48+4wqWIqNfOhVmcXWYDFGyHod1bgRjamCelVZ8UNNXvWWYy1U2jO6Ori4cwujL2z+Y0H7WNFapsQihPotr+fwSNisyouzESdcay9npbAxMS5rIQNv13SKr7IdbASjoBGLe9ptgDUr0UiCdvUHb3Zi09OBK+X2ELFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758815187; c=relaxed/simple;
	bh=aHsHLeqcKlZTchhfwajts4bssNuIuuLUXlJHiIQv9fA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cEoqKOrU3tq+vHxBih6P175b+RXsknhOyA81fMVeZdx3o9Q71uYoz2D+kX4aH6kG5xykFY41H5I/WmZ3Q+x3f/vUOPfUdOg4evOv6g0AQ3GLuzWEnXyyhwFsz3gQdzNMUqYxxhVkiXjDEDiesfYw7TyZIwfnJaygbQ4sviksjUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QrWx0s5k; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QrWx0s5k"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-78ed682e9d3so8172636d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 08:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758815185; x=1759419985; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uohuZ6LgDXy0VO1rGoHBmOmlo8oXtVe7MXjW+mkEDCU=;
        b=QrWx0s5k1dYO/3HVwUmQjJFNu5lpVvdyxCJCUckgViOq0jchZefTZlK8FlTRkz9nPR
         P4dlNj38mCX6kX3/XxkHpKo/w9J/WhIgSZ05pslCrPKhFI0i1JcSir13RxNMsH2ikUB1
         QDQVLZdZIB/a9mucBOL1Dr2P5VeGwaLSZ/mJquVFoon3/ZLUaQO24eX4Gz71IgwFGXBc
         EYTUHrPpVZ1gYvSiiYjkgNnCFV5GGETc/uLAL9SOpIJq9hB/Zl8ex3kNAYXvV7CoTG01
         qt0RUI8k4wo4nEiTtNh763l75vPqgImZ0mJ73jqMTtAx2iv5cl7L25EgyWqYNPcNaVHe
         v/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758815185; x=1759419985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uohuZ6LgDXy0VO1rGoHBmOmlo8oXtVe7MXjW+mkEDCU=;
        b=LWoZY4+nk0L0rXeneYs/s+IwP9gxhUMhcoZOPSsecvXLHpAw/uKcVY21X9FQLGu0Sq
         m5EAG9WdTfQGrYOEVP38xYHscNFgK/yaI1Lec6KQCz8PqNTSTvkSifgbcsmsNTSjH690
         mBm8S898Xf7vvqrjQte9UOd4uzq8UjN6fsQ1qkKQbj/qvDJMV0AheBN5pDjTiX0G4MaX
         jA0QDE/4KjYu8hmGWVjntK6Vz+hlNd7oiTQAYVlX/M2FFzsBwF55/hmacnp1Km02uQq7
         cz4hSgsrke1D9+sW4f8Ab8fwp6kRv6ipAprIKKIG3BON38Q2rNj47PJM6zIaF4J1K4SQ
         t4AQ==
X-Gm-Message-State: AOJu0YxqBVDkYRDf0/Kvp03eFKDTpeCKeepNw3++SpN3eHdgGKbJ9c2q
	QOu7pS2cXr8euAJzAHjc2GHvhED3sSXbJNB6b+KEael0WAcRmJI0V2RqLg31HCGUXgiFC8NdxJ0
	hBZtegFRfyn2i/daRkHCyhbECJMH6O8k=
X-Gm-Gg: ASbGncsmJcE76B0VG30TuKnz6MQP9fIyTnyQZj7WRkY3k0kgrs1f+7h6BSQw9Dz/xiN
	W8mbnxdruVodDJvihkwRX4E7zWic8iHL1Kk8iH3L/ge83ExH0dQVofphpRkbDyTdA7bcCv1Oadb
	51QSIeMYKZ6g2+/vGfJphz0uHP2Y1gc4llq844To4KsPd75zS0LLVLOXCTUyygR/TFxqC9+KxaC
	DPJOwSGzaejrNM99+RgcIS9+eqAWcDOKiun/Ow5lSNA7SGSGcWjnEQ0gnqMVF1v2SALEiCuS5+M
	jx3BQG63IrvaaHdBrCwC4lgTZ75i+JfkG4ihbS825lyKkJP62i+2YYqG9UC3FYK0LXBLgIrzFsZ
	BKwSxof0QARu+dQd5bWlNzA==
X-Google-Smtp-Source: AGHT+IHvYlzieMZ9yjCZc/9wY9LOHOx8TTseC0pJwc8LSk7pBfQWRcx4KyC4FD34YMpuDVSP0l1+zCKO2tms2CbV8a4=
X-Received: by 2002:a05:6214:415:b0:7fb:ed4f:588 with SMTP id
 6a1803df08f44-7fc2d51ce69mr56308986d6.18.1758815182148; Thu, 25 Sep 2025
 08:46:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925151033.620865-1-ematsumiya@suse.de>
In-Reply-To: <20250925151033.620865-1-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 25 Sep 2025 10:46:10 -0500
X-Gm-Features: AS18NWAGF5RF_tvbt5HMbP12quflaTcu3gRgjiDoEi9xDCE2wZlWaKXts7s_ReM
Message-ID: <CAH2r5mtNDm9E-vrQjTe6KX=Mo3jLoMShiiTrpN1FwE3b=Nv8LA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix crypto buffers in non-linear memory
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing/review

thx

On Thu, Sep 25, 2025 at 10:10=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>
> The crypto API, through the scatterlist API, expects input buffers to be
> in linear memory.  We handle this with the cifs_sg_set_buf() helper
> that converts vmalloc'd memory to their corresponding pages.
>
> However, when we allocate our aead_request buffer (@creq in
> smb2ops.c::crypt_message()), we do so with kvzalloc(), which possibly
> puts aead_request->__ctx in vmalloc area.
>
> AEAD algorithm then uses ->__ctx for its private/internal data and
> operations, and uses sg_set_buf() for such data on a few places.
>
> This works fine as long as @creq falls into kmalloc zone (small
> requests) or vmalloc'd memory is still within linear range.
>
> Tasks' stacks are vmalloc'd by default (CONFIG_VMAP_STACK=3Dy), so too
> many tasks will increment the base stacks' addresses to a point where
> virt_addr_valid(buf) will fail (BUG() in sg_set_buf()) when that
> happens.
>
> In practice: too many parallel reads and writes on an encrypted mount
> will trigger this bug.
>
> To fix this, always alloc @creq with kmalloc() instead.
> Also drop the @sensitive_size variable/arguments since
> kfree_sensitive() doesn't need it.
>
> Backtrace:
>
> [  945.272081] ------------[ cut here ]------------
> [  945.272774] kernel BUG at include/linux/scatterlist.h:209!
> [  945.273520] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
> [  945.274412] CPU: 7 UID: 0 PID: 56 Comm: kworker/u33:0 Kdump: loaded No=
t tainted 6.15.0-lku-11779-g8e9d6efccdd7-dirty #1 PREEMPT(voluntary)
> [  945.275736] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS r=
el-1.16.3-2-gc13ff2cd-prebuilt.qemu.org 04/01/2014
> [  945.276877] Workqueue: writeback wb_workfn (flush-cifs-2)
> [  945.277457] RIP: 0010:crypto_gcm_init_common+0x1f9/0x220
> [  945.278018] Code: b0 00 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5=
f c3 cc cc cc cc 48 c7 c0 00 00 00 80 48 2b 05 5c 58 e5 00 e9 58 ff ff ff <=
0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 48 c7 04 24 01 00 00 00 48 8b
> [  945.279992] RSP: 0018:ffffc90000a27360 EFLAGS: 00010246
> [  945.280578] RAX: 0000000000000000 RBX: ffffc90001d85060 RCX: 000000000=
0000030
> [  945.281376] RDX: 0000000000080000 RSI: 0000000000000000 RDI: ffffc9008=
1d85070
> [  945.282145] RBP: ffffc90001d85010 R08: ffffc90001d85000 R09: 000000000=
0000000
> [  945.282898] R10: ffffc90001d85090 R11: 0000000000001000 R12: ffffc9000=
1d85070
> [  945.283656] R13: ffff888113522948 R14: ffffc90001d85060 R15: ffffc9000=
1d85010
> [  945.284407] FS:  0000000000000000(0000) GS:ffff8882e66cf000(0000) knlG=
S:0000000000000000
> [  945.285262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  945.285884] CR2: 00007fa7ffdd31f4 CR3: 000000010540d000 CR4: 000000000=
0350ef0
> [  945.286683] Call Trace:
> [  945.286952]  <TASK>
> [  945.287184]  ? crypt_message+0x33f/0xad0 [cifs]
> [  945.287719]  crypto_gcm_encrypt+0x36/0xe0
> [  945.288152]  crypt_message+0x54a/0xad0 [cifs]
> [  945.288724]  smb3_init_transform_rq+0x277/0x300 [cifs]
> [  945.289300]  smb_send_rqst+0xa3/0x160 [cifs]
> [  945.289944]  cifs_call_async+0x178/0x340 [cifs]
> [  945.290514]  ? __pfx_smb2_writev_callback+0x10/0x10 [cifs]
> [  945.291177]  smb2_async_writev+0x3e3/0x670 [cifs]
> [  945.291759]  ? find_held_lock+0x32/0x90
> [  945.292212]  ? netfs_advance_write+0xf2/0x310
> [  945.292723]  netfs_advance_write+0xf2/0x310
> [  945.293210]  netfs_write_folio+0x346/0xcc0
> [  945.293689]  ? __pfx__raw_spin_unlock_irq+0x10/0x10
> [  945.294250]  netfs_writepages+0x117/0x460
> [  945.294724]  do_writepages+0xbe/0x170
> [  945.295152]  ? find_held_lock+0x32/0x90
> [  945.295600]  ? kvm_sched_clock_read+0x11/0x20
> [  945.296103]  __writeback_single_inode+0x56/0x4b0
> [  945.296643]  writeback_sb_inodes+0x229/0x550
> [  945.297140]  __writeback_inodes_wb+0x4c/0xe0
> [  945.297642]  wb_writeback+0x2f1/0x3f0
> [  945.298069]  wb_workfn+0x300/0x490
> [  945.298472]  process_one_work+0x1fe/0x590
> [  945.298949]  worker_thread+0x1ce/0x3c0
> [  945.299397]  ? __pfx_worker_thread+0x10/0x10
> [  945.299900]  kthread+0x119/0x210
> [  945.300285]  ? __pfx_kthread+0x10/0x10
> [  945.300729]  ret_from_fork+0x119/0x1b0
> [  945.301163]  ? __pfx_kthread+0x10/0x10
> [  945.301601]  ret_from_fork_asm+0x1a/0x30
> [  945.302055]  </TASK>
>
> Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rathe=
r than a page list")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
> v2:
> - Change the fix to Paulo's suggestion.  Update commit message to reflect=
 it.
>
>  fs/smb/client/smb2ops.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index e586f3f4b5c9..68286673afc9 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4219,7 +4219,7 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hd=
r, unsigned int orig_len,
>  static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct s=
mb_rqst *rqst,
>                                  int num_rqst, const u8 *sig, u8 **iv,
>                                  struct aead_request **req, struct sg_tab=
le *sgt,
> -                                unsigned int *num_sgs, size_t *sensitive=
_size)
> +                                unsigned int *num_sgs)
>  {
>         unsigned int req_size =3D sizeof(**req) + crypto_aead_reqsize(tfm=
);
>         unsigned int iv_size =3D crypto_aead_ivsize(tfm);
> @@ -4236,9 +4236,8 @@ static void *smb2_aead_req_alloc(struct crypto_aead=
 *tfm, const struct smb_rqst
>         len +=3D req_size;
>         len =3D ALIGN(len, __alignof__(struct scatterlist));
>         len +=3D array_size(*num_sgs, sizeof(struct scatterlist));
> -       *sensitive_size =3D len;
>
> -       p =3D kvzalloc(len, GFP_NOFS);
> +       p =3D kzalloc(len, GFP_NOFS);
>         if (!p)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -4252,16 +4251,14 @@ static void *smb2_aead_req_alloc(struct crypto_ae=
ad *tfm, const struct smb_rqst
>
>  static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst =
*rqst,
>                                int num_rqst, const u8 *sig, u8 **iv,
> -                              struct aead_request **req, struct scatterl=
ist **sgl,
> -                              size_t *sensitive_size)
> +                              struct aead_request **req, struct scatterl=
ist **sgl)
>  {
>         struct sg_table sgtable =3D {};
>         unsigned int skip, num_sgs, i, j;
>         ssize_t rc;
>         void *p;
>
> -       p =3D smb2_aead_req_alloc(tfm, rqst, num_rqst, sig, iv, req, &sgt=
able,
> -                               &num_sgs, sensitive_size);
> +       p =3D smb2_aead_req_alloc(tfm, rqst, num_rqst, sig, iv, req, &sgt=
able, &num_sgs);
>         if (IS_ERR(p))
>                 return ERR_CAST(p);
>
> @@ -4350,7 +4347,6 @@ crypt_message(struct TCP_Server_Info *server, int n=
um_rqst,
>         DECLARE_CRYPTO_WAIT(wait);
>         unsigned int crypt_len =3D le32_to_cpu(tr_hdr->OriginalMessageSiz=
e);
>         void *creq;
> -       size_t sensitive_size;
>
>         rc =3D smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), e=
nc, key);
>         if (rc) {
> @@ -4376,8 +4372,7 @@ crypt_message(struct TCP_Server_Info *server, int n=
um_rqst,
>                 return rc;
>         }
>
> -       creq =3D smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, =
&sg,
> -                                &sensitive_size);
> +       creq =3D smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, =
&sg);
>         if (IS_ERR(creq))
>                 return PTR_ERR(creq);
>
> @@ -4407,7 +4402,7 @@ crypt_message(struct TCP_Server_Info *server, int n=
um_rqst,
>         if (!rc && enc)
>                 memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
>
> -       kvfree_sensitive(creq, sensitive_size);
> +       kfree_sensitive(creq);
>         return rc;
>  }
>
> --
> 2.49.0
>


--=20
Thanks,

Steve

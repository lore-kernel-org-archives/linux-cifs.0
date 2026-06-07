Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F206C2571C0
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 15:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780846418; cv=pass; b=NB/WmngXg/DXKGKdk7jmmzYgZuFVQKtP7UdBraahjHyintD+vbqcnofUMjqi6FA+1IaxbianWF8xwEg0+duOviA+2wdrw7FO/0jK+NO4FZfcdkMC4gBNcv6EMy23ojBcGWu6J7gp0oi2wBhSsOgePIKfE5MxzwAWoZtLIJLBINs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780846418; c=relaxed/simple;
	bh=4ZP0m5DCW4H/vJZTDUnDL39ccjigQliH4W286OcBo28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q5+mW1kh6lDVYWcD5ZVsiQyDnXXsN3j0LvOzlco9e9Gh8lCfWG2UqWRtjLVuMXEnGCofGHOHBS5SdY0Zj5AJz/fr11ELgKhDabfvAdyWs85BXfAm4cN5jMw1Jw/htgz24og2wuVpT/rxoiO922ycg594eFAOuxuN8mEtSZYKPEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EQaPDRjZ; arc=pass smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EQaPDRjZ"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9154ca1aa1dso618694485a.0
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jun 2026 08:33:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780846416; cv=none;
        d=google.com; s=arc-20240605;
        b=TVRRQrNhFZGNiP9LHsi71gZTY8Z2nZcy9LexqPVkGZPfQ+QSH/yROmqDpIDWJFoyld
         MAFV/Yi2NMYR4JL00fWAc0UVmuIiuVwJoMJRxRs6puszeopccMAC+18GXSmcM0kNmnt6
         +Rjeh0re5h0D2jvyQSl2Nt+Rf/+1y3+pm7kCH4Bd2lrkAQ3Q6PsJpDOdJxuB1YvzZdPc
         ehEAuLQSHx9GPPPACx1jR2hyNXExmpjVuWrb/mtAqviPhe5M1axvQiYxLeS8DHXYLCKz
         JEIXGMYsh+EtWntnCPRlwUqlQEyc/whfrz3PIyy1wESu6G8bBywHikPv8UW6X8GYLnQ9
         H5+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sz459/uU78CQrP/iGzk56Ui3JxP9skMhu9oEu2XdACU=;
        fh=Yz6FVGoZ8UNm05f7/aowpptF790dx1AUAoKqVhQBWcQ=;
        b=hDoSZh+r1MSFCmV99zAoEneM+yFAc6BTCkreyrl7HA1/Np1MPLDlGRLVwtJH10YXhm
         7OZyF4mpyWLyarXS+/aWfsG8O3zRXUkk1+rXXuWYwszmW27DJR+K8zQNvTgRfeyLynDc
         O/rv1DRD+Uktk2Rrj9uNslI77JnkYYNRONRAftlfO6NBmNhkOjFQrh7IuPjF5i7+VLJZ
         pc9In3jeVidZs2Vjpuxl2ekTiHGUOKAiXVwUdDvX9pBUzQOXNLZGFyLNGTYzUrwiavdE
         HCtAKUtvKPiGRsgtNFMLxM/NDWCtzWGG4wdZw2gjHm/an9e9wbQEZ1Rsx/9DHYBZuFrm
         k/CQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780846416; x=1781451216; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sz459/uU78CQrP/iGzk56Ui3JxP9skMhu9oEu2XdACU=;
        b=EQaPDRjZMBlGP6R7MCGCxq1i5ZPyqENQqQO7dFD1CfIfShQhg0GHyEdNi4kw+1/i7w
         fPwhwfhv8M3j3zx+WdvjP3uVsJG5v0chj6MFrTjvNKjCeIF1sN/51ND5iaxFFMtrTiLw
         +vQI5dS9R9ek3ZeIHpo0K+8ueeOz+yjpmXUdj8a8J0ohjKaD22/L1Tkj6SfC5W+mUbS0
         j0Bld9TocUNLOBpsW40OU/VK6GN/tdvh1/EEiyQwYbZZdgOGt/NSq6aMYoaEO2qIzyRM
         CbNA61wtbvARokVYOTM+4wOmNCVlSFF1wXIN3G8C/IcuqKPfnKY4PlIRjkMqKRO6FSn5
         0fgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780846416; x=1781451216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sz459/uU78CQrP/iGzk56Ui3JxP9skMhu9oEu2XdACU=;
        b=Yj8CHI4+jCTobSf3XKQpMWQwzgnJ/jq5n/onGmzAE1z4b1jjhlRw/gG5je8WYgYyyq
         yUqtGJBWKXzaXgKF+vxaNBrpjS2e5VbO+yhQYm72iM4j792SBQjzUsW4ME+kJs+l1Wdi
         ncHlAYbbAMvhi2pCxMbw2c5VH7RLoZm6AmiGLPT7HrXYUk5X7ZxbWA8ppncUls2b2hNN
         zHAt2W42PpwLpuCPzZ8z/thRAnwCskpRECigJQKRbTgGems/wLlLP3YsANFVo4q9Epe2
         6NDKYkQPYBnAJccB2MbamBpY+qBoXOZTyYJ0B4+2TM1pBeMRiF9pHjeNUpXcJxMOMky8
         WLbQ==
X-Forwarded-Encrypted: i=1; AFNElJ+eNUApweoEtWuvvFWh/dDEi3iHe+uqqZCAnFp04q2o8xei7S3CPtCBVipfoHQ2h25LcqQ5iWVXrt8c@vger.kernel.org
X-Gm-Message-State: AOJu0YwbWxwGSZ0+cA5wswEvNdAP8xPZPPIfVpy5rWz1fjFKL2qM7T8a
	7eJk2+kcZfuoZKTYqrbnM3/rciO0ZT4WsPM8cxCSopSeYodIijG0xHvECkqIVKwq4Cy8F7DUeQx
	I3H7BdiCAPJDneWIx0dqj+kpQUr4Xvkc=
X-Gm-Gg: Acq92OFOkEAIPdKnW5A5uZj9LQvfgKoKPUEoCmuXFkAOXAgaTwO2zr8jiZjZKaMRUoi
	h0hm+gO3CJ8a6jh9XC9sy+EiEI8BdsCbivOA64carRIa0n7jrOrSsueqvtR0KtkyWp6ajxTFFTj
	NaKT+J7NNLTd/PDWlO3oyQiNNW9j8FIvLmB6XpA8LbMzsHP+djQsNrKdXGs1Q+gjSy6BEqUCnUk
	IaeuXjr+gRnQS9GFVdzppIkhq2mR1rBsyNqsETq1MtOczWyiSSEnQWmHzvkZaZRGI5THblGJclS
	Cbu+k7l19gKkXkY+F8MHHaVeRsABFCbwqPEHIMqNRMiAb+IiViNdrhd02vf1nonwCPq2iIm8gDA
	KlYk/VUO+G57AHusiiZmYQah0/eAjcaqlmt3PcxD/xt0GiDj2LMrsDydOQbLMrLlKP2ikl523LS
	LqHcOe8edD+AVXQuSMmqdZooLZ9jH3bw==
X-Received: by 2002:a05:622a:4c13:b0:517:5bc6:b575 with SMTP id
 d75a77b69052e-51798673664mr114564061cf.4.1780846415890; Sun, 07 Jun 2026
 08:33:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605163519.169916-1-huiwen.he@linux.dev> <20260605163519.169916-3-huiwen.he@linux.dev>
In-Reply-To: <20260605163519.169916-3-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Jun 2026 10:33:23 -0500
X-Gm-Features: AVVi8Cd3dlraeDaxo_fZZ5E1HUyIeJWiVLMTmp_6738meMMksLBVnwKDoYQNk5g
Message-ID: <CAH2r5mv81BSAp0weQmJ=OjUE-s9wD14vUeDSC0jgy22eabHoXw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] smb/client: do not account EOF extension as allocation
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch regresses xfstests generic/568 and generic/701 can you
update it to address that regression?

generic/568  0s ... - output mismatch (see
/home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad)
    --- tests/generic/568.out 2025-08-22 09:54:32.333796989 -0500
    +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad
2026-06-07 10:20:34.002140048 -0500
    @@ -1,4 +1,4 @@
     QA output created by 568
     wrote 2/2 bytes at offset block_size - 1
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -OK: File did not grow.
    +ERROR: File grew from 0 B to 1536 B when writing to the fallocated ran=
ge.
    ...
    (Run 'diff -u /home/smfrench/xfstests-dev/tests/generic/568.out
/home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad'  to
see the entire diff)
generic/701  1s ... - output mismatch (see
/home/smfrench/xfstests-dev/results//sambamfs/generic/701.out.bad)
    --- tests/generic/701.out 2025-08-22 09:54:32.350807804 -0500
    +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/701.out.bad
2026-06-07 10:20:34.573010303 -0500
    @@ -1,2 +1,3 @@
     QA output created by 701
    -Number of allocated blocks after truncate is in range
    +Number of allocated blocks after truncate has value of 0
    +Number of allocated blocks after truncate is NOT in range
8304721.92 .. 8472494.08
    ...
    (Run 'diff -u /home/smfrench/xfstests-dev/tests/generic/701.out
/home/smfrench/xfstests-dev/results//sambamfs/generic/701.out.bad'  to
see the entire diff)



On Fri, Jun 5, 2026 at 11:36=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> cifs_setsize() updates the local inode size after SetEOF succeeds. It als=
o
> used the new EOF as a local i_blocks estimate, but extending EOF does not
> prove that the intervening range was allocated.
>
> For example, after writing 1 MiB and then extending EOF to 10 MiB, the
> client can report the file as fully allocated even though the server stil=
l
> reports a much smaller AllocationSize:
>
>         $ dd if=3D/dev/zero of=3Dtest bs=3D1M count=3D1
>         $ truncate -s 10M test && stat -c 'size=3D%s blocks=3D%b' test
>         $ stat --cached=3Dnever -c 'size=3D%s blocks=3D%b' test
>
>         client stat:            size=3D10485760 blocks=3D20480
>         server stat:            size=3D10485760 blocks=3D2056
>         client stat(nocache):   size=3D10485760 blocks=3D2056
>
> A later attribute revalidation may correct i_blocks, but callers such as
> xfstests generic/495 invoke swapon immediately after truncate. The swapfi=
le
> hole check can therefore observe the inflated local i_blocks value and
> accept a sparse file.
>
> Do not grow i_blocks from cifs_setsize() on EOF extension.  Only clamp it
> on shrink; allocation growth must come from write completion or from
> server-reported AllocationSize.
>
> With this change, EOF extension no longer makes a sparse file appear
> fully allocated before the next attribute revalidation, and xfstests
> generic/495 correctly rejects the sparse swapfile.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/inode.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 826d36ed13ec..e0aa71b87d27 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -3038,13 +3038,20 @@ int cifs_fiemap(struct inode *inode, struct fiema=
p_extent_info *fei, u64 start,
>
>  void cifs_setsize(struct inode *inode, loff_t offset)
>  {
> +       loff_t old_size;
> +       u64 blocks =3D CIFS_INO_BLOCKS(offset);
> +
>         spin_lock(&inode->i_lock);
> +       old_size =3D i_size_read(inode);
>         i_size_write(inode, offset);
> +
>         /*
> -        * Until we can query the server for actual allocation size,
> -        * this is best estimate we have for blocks allocated for a file.
> +        * Extending EOF does not allocate the intervening range. Only cl=
amp
> +        * i_blocks on shrink; allocation growth comes from writes or fro=
m the
> +        * server-reported AllocationSize.
>          */
> -       inode->i_blocks =3D CIFS_INO_BLOCKS(offset);
> +       if (offset < old_size && (u64)inode->i_blocks > blocks)
> +               inode->i_blocks =3D blocks;
>         spin_unlock(&inode->i_lock);
>         inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>         truncate_pagecache(inode, offset);
> --
> 2.43.0
>


--
Thanks,

Steve

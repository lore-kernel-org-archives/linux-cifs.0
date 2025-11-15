Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2CD288C96
	for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763226182; cv=none; b=frLcDlzbI/H51aSluZD1wUCeonyE5ru1Y1ZVg70a4Be+OIyGH5gj7FCXFiXtvqPv1jekV2bpeQ12ACfPGe8rxvfxsBv7nWKdMOGqWZlsY4Uy7aGYZudqrCuuDahGpbk8pcwacS6UO9K/9XhaW/hRTjtDblSyxoDYgjSXiocutuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763226182; c=relaxed/simple;
	bh=Ynsp4AGIiFvIUjzx33S0RcH+iZzWSG7GvDrxPYpl5y0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJR58VHIbgHE5FThXodxfItcXMRoZINSUCfVa6I0tThNbxsRmOmnMw7Pt9tG5LxQjtam2F+A+G48CfVYG7VoP0Bm6KbaSUAc3OApEO+LaruBJTe1DoAfDecJw1cqonTzCvjLrQ7d4zfl6qnnu8TFAvcoYshE8KaF07diLr7T//Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UxlJbrVM; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UxlJbrVM"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477549b3082so24951905e9.0
        for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 09:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763226178; x=1763830978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhZf0daDzyc4x+cTxD8gsx/UNr12/kXrHW7QrRdshYk=;
        b=UxlJbrVMoJ7bnxVGwt8oiDKH6qqyQjMInsErS/GhB4nPtiODa8tfUKPgiFhp71B8BO
         40g/sbzfpIfFe07FXzjIfp8EmjzjoBOZ4VkKbzM7lkTqVJwCiYI7+1OVFOfLJVQz6i4K
         UEiOh46zFz9Fcp6Y8kM5600faujRYJwiXYuNaVEBOnQhEFpzPtXOWJ4i0KonEm6dyK7n
         LpJ8HIMDhi3FA+NcC0lfypmSVGY5vONUs5RAiONHmTiHmZPEiUM1J9IjLojtLjnbuR0r
         0ZhME8ekeafa/azI4xQwhX58uxfHeW8wqJcHqiSwvX4VPGxNvj1qHX5Nu06xS+J1aw4I
         uesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763226178; x=1763830978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fhZf0daDzyc4x+cTxD8gsx/UNr12/kXrHW7QrRdshYk=;
        b=kFvjePBNgBOcR+Fem/BdvleF0/85hGm+fIbFYdw0qV8fFz2GScWTjppFgfovo7i5/q
         2cEHsn+04gLjqyQpLSSmf1A1xqwaElAl2OSf4hu/Oka8jx0D+lEpU1di67Fz4eAs+fGd
         6YBP+ud1vVESuBYQStUbuXOhLDCAXf9MKydO16NPAmpgpBl2V95ewQ0uMUs33fVB2BS1
         XX4E1nmB8//izsw/lXRpiiE+R3vStKCPc/1w/S7LosNUt8QfBsXXWOymXtMN+pUKGFVQ
         jxbbJFhrDitiEGoZCECa56Eps+Ts+qxE4WCLQbQ6tc/o56Vr31tAyEpLplYjAilzrUYO
         /keA==
X-Forwarded-Encrypted: i=1; AJvYcCUMUPpKhj0IETfQDxxLFAg7kWVuZ7nfBfba74z3X4S65IjTfbaWr0eI2DHZH29gAc6Zx+4Ev2y41am0@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwe6RSt1GKFrqzVcgqgy68/Cj7RVQlO1dCW3Os74SsODZXvvcd
	uX73udFEzTQCCO1TlzOacrmd3vp4BCFLLHGO9HrmpyzCG5DccymSNmeWdLSWVg==
X-Gm-Gg: ASbGnctSQoufTw5EtRHRfk21eXjok/C0T3c2YoolCYTKR+w4rtGM+NbyHiFEgnLXi7i
	rlvSxIGtsseYDnjUKowbaBpeNdM9W9Glg/7InaoUIYPf3nQdQd7yC5esCEv+12Cjjp5rYGv97Gs
	avi6wnfPVajcAPGcU/fEd3zoN/+dIAPHPxBtcuvH+vVREHOIkipQ0M/eWWzaMGX09U6UJ2cWzfs
	1ZRvcO2gs/Rt81ML9f7ACQnvcoBbb/roJ1YCLxS/JbqPZ3ZSdxvnmFc4fmFyWW/cva3qvtK7ZkP
	eoePRUz52k9DJJv0v6Hxa2+91oU1wDOCrsvAM5qAYflqhYSX0wVungFLvgJd8dDnyWxWVSNN0JN
	jRa+3R5/O+eKl+ZhbqbenBkLnsalZBCA2vOUU+Pn0PV99VmRxtwFCmCdXTmznn4ZAZy8JNYNvUQ
	A0Tf1Ks4Nj+AC05tWM9XDDWIxo10LU5ICjwuArfEqF+ADwJBOT4Oz7DgYfahqBBHA=
X-Google-Smtp-Source: AGHT+IGvA6Cf0hX6CHFmLOv2ERiNOSbof9VojTgyNbFZ08X3ubaL0BT4MHWHB1qRipjBox5egLNWRg==
X-Received: by 2002:a05:600c:4513:b0:477:5cc6:7e44 with SMTP id 5b1f17b1804b1-4778fe5de1amr68131925e9.11.1763226177303;
        Sat, 15 Nov 2025 09:02:57 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4778bb34cc1sm71532425e9.3.2025.11.15.09.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 09:02:57 -0800 (PST)
Date: Sat, 15 Nov 2025 17:02:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Qianchang Zhao <pioooooooooip@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 gregkh@linuxfoundation.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhitong Liu <liuzhitong1993@gmail.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] ksmbd: vfs_cache: avoid integer overflow in
 inode_hash()
Message-ID: <20251115170253.64ee8828@pumpkin>
In-Reply-To: <20251115144836.555128-1-pioooooooooip@gmail.com>
References: <CAKYAXd-_S184kK0NUyuCgOTvCvq382c3Fxt=ytes-ekydwGLuQ@mail.gmail.com>
	<20251115144836.555128-1-pioooooooooip@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 15 Nov 2025 23:48:36 +0900
Qianchang Zhao <pioooooooooip@gmail.com> wrote:

> inode_hash() currently mixes a hash value with the super_block pointer
> using an unbounded multiplication:
> 
>     tmp = (hashval * (unsigned long)sb) ^
>           (GOLDEN_RATIO_PRIME + hashval) / L1_CACHE_BYTES;
> 
> On 64-bit kernels this multiplication can overflow and wrap in unsigned
> long arithmetic.

The same happens on 32bits.

> While this is not a memory-safety issue, it is an
> unbounded integer operation and weakens the mixing properties of the
> hash.

Are you sure, I'd have thought all the 'carry' operations in the multiply
would make it better.

> Replace the pointer*hash multiply with hash_long() over a mixed value
> (hashval ^ (unsigned long)sb) and keep the existing shift/mask. This
> removes the overflow source and reuses the standard hash helper already
> used in other kernel code.
> 
> This is an integer wraparound / robustness issue (CWE-190/CWE-407),
> not a memory-safety bug.

It isn't really an integer wraparound bug either.
The fact that only the low bits of the product are used shouldn't matter
at all.

OTOH it might be worth sifting 'sb' right some bits - quite a few of
its low bits are zero and they end up as zeros in the product.

	David

> 
> Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
> Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
> ---
>  fs/smb/server/vfs_cache.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> index dfed6fce8..a62ea5aae 100644
> --- a/fs/smb/server/vfs_cache.c
> +++ b/fs/smb/server/vfs_cache.c
> @@ -10,6 +10,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> +#include <linux/hash.h>
>  
>  #include "glob.h"
>  #include "vfs_cache.h"
> @@ -65,12 +66,8 @@ static void fd_limit_close(void)
>  
>  static unsigned long inode_hash(struct super_block *sb, unsigned long hashval)
>  {
> -	unsigned long tmp;
> -
> -	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
> -		L1_CACHE_BYTES;
> -	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> inode_hash_shift);
> -	return tmp & inode_hash_mask;
> +	unsigned long mixed = hashval ^ (unsigned long)sb;
> +	return hash_long(mixed, inode_hash_shift) & inode_hash_mask;
>  }
>  
>  static struct ksmbd_inode *__ksmbd_inode_lookup(struct dentry *de)


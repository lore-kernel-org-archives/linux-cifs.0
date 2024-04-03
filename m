Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D897155738
	for <linux-cifs@vger.kernel.org>; Wed,  3 Apr 2024 19:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712174080; cv=none; b=rzU60VPjxWtkW3ivUY/63MBttOFakN4Ceqv/aEnGqGSpwAbRi28Jdn1LLPMZ82oVvsmmmRXbXo9PwHUa1XmUslDXgEdB4uAcdoLQ4NVZiZa9oQrKP53ack7szXGbBcq3BdJxEILOz2hKfVgY+CcXJRn73QjROx2p0rQLK/U0Kzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712174080; c=relaxed/simple;
	bh=1fPDJjm0hxJwrRLWXd094hP/qGjxMM9KZG0J6jYuplU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ahdPQnIooVBECjaTbHN1YMXjxL397xGkJiwDYwR1B37jVTfezMD1mqLh0sp9gVVFoUhKvPxEXvLRUJiJetDGZD5nB4hT2UPDBhD3gI5k/D6aR13g6CabdrLWHHAui7Y+V9fGTWSrrP1ZEDmb7O6UwHhg4wbz0okjv/DaHIChZWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V8MN2Hjt; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V8MN2Hjt"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d6a1af9c07so2662241fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 03 Apr 2024 12:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712174070; x=1712778870; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EwQ7LeguxXFHFb2AkESHWiYJEorjbtIag8chNFhMNrk=;
        b=V8MN2HjtUP8NV+63WRK8rGZLSUK1guG9VLuXtlt7PBtDk8INX37S/SdGuNKqi+3qdT
         uV9B8blyTa4HWLUl5aBexxzMJW+bkdqo0oAz6UsuQaZPNwI17I5EGHn+ZaOpKt+Zg5Jy
         uBLDDnE7gjiWbRZ+c2F0zhZXjpbkQh0OFrI8MXrc6LOn9KKhoAMfPxjGSPiaS9Cpu1GX
         QPyAicqxEazIdKZbIw4bhgd3XO/0aryKNacMNBPlCsInQ1I70Wylyv51R4ye6cjuZEN7
         kvZS1xs3jrgHrxCIb/5TlMmG+XHw7KMCLPC1owc9JuXavIUerfDeawE5WBwlBBxmefsP
         DQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712174070; x=1712778870;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EwQ7LeguxXFHFb2AkESHWiYJEorjbtIag8chNFhMNrk=;
        b=JF0RCmQasr5s84kPMcntAheO9nI/8oYIEzSMdCh1bjprACZVZ5nK+/aEHVmQF/wdJN
         Lbsb35tP4skkZZfa20lhJeCRRtsOSA3gdk0M1TgDvdys7i4emQTSVbY19wvsfpXoXvDd
         ViV0C0fOvhH9gzUEEOmQr3/R2Mhk6ucu4+OzAwGp9Ir9aAkV583LH+QzTxr6iq8V8W50
         uqkcR2NkHmbdUiNiTDcP2giVejVnofBecRYwUd/5tdeg0o9ZfcRA44Mc3MHZjRt0HT+0
         zlbZWwFELQlsvFw4naL2VOKrK72n8/ucPlhtANTYAwjAPSu0UtMWqUQwzaZZAAx/ngz/
         y8ZQ==
X-Gm-Message-State: AOJu0Yxo7JuP/ghkms9hc3YiIOQJC4HMPA/RTARXGTgHpAvUG9dITlN3
	cwoBiFdvgFChtiW7CZIyHiJnJ2psBv3rhN+Z8eksnKvKl1scPQQT6zMchLdfWNrqSaw2H3D1akn
	lGaNND1dOX94zC46DF7ogl4d1IrE=
X-Google-Smtp-Source: AGHT+IFuF6mBKEuCuisolA4PSBDveFGo5aWn7lYNDNzhx4tAnf0D+P9WeVO73DCbekTEkXWZTV6V501l/c1y9Hvb4xw=
X-Received: by 2002:a2e:7c0a:0:b0:2d6:ff04:200f with SMTP id
 x10-20020a2e7c0a000000b002d6ff04200fmr458440ljc.33.1712174070008; Wed, 03 Apr
 2024 12:54:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202404032326.KpdXGGKv-lkp@intel.com>
In-Reply-To: <202404032326.KpdXGGKv-lkp@intel.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 3 Apr 2024 14:54:17 -0500
Message-ID: <CAH2r5mvQh0vQi-RD7=yVOCsaKoqrCbb0waWr=MCQ_pepUKTbOg@mail.gmail.com>
Subject: Re: [linux-next:master] BUILD REGRESSION 727900b675b749c40ba1f6669c7ae5eb7eb8e837
To: kernel test robot <lkp@intel.com>, Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: multipart/mixed; boundary="0000000000003ca74306153697c3"

--0000000000003ca74306153697c3
Content-Type: multipart/alternative; boundary="0000000000003ca74106153697c1"

--0000000000003ca74106153697c1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixed (and updated in cifs-2.6.git for-next)
Updated patch attached



On Wed, Apr 3, 2024 at 10:57=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:

> tree/branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git maste=
r
> branch HEAD: 727900b675b749c40ba1f6669c7ae5eb7eb8e837  Add linux-next
> specific files for 20240403
>
> Error/Warning reports:
>
> https://lore.kernel.org/oe-kbuild-all/202404031246.aq5Yr5KO-lkp@intel.com
> https://lore.kernel.org/oe-kbuild-all/202404031346.wpIhNpyF-lkp@intel.com
> https://lore.kernel.org/oe-kbuild-all/202404032101.sKzRXCWH-lkp@intel.com
>
> Error/Warning: (recently discovered and may have been fixed)
>
> fs/smb/client/file.c:728:12: warning: variable 'rc' is used uninitialized
> whenever 'if' condition is false [-Wsometimes-uninitialized]
> mm/kasan/hw_tags.c:280:14: warning: assignment to 'struct vm_struct *'
> from 'int' makes pointer from integer without a cast [-Wint-conversion]
> mm/kasan/hw_tags.c:280:16: error: implicit declaration of function
> 'find_vm_area'; did you mean 'find_vma_prev'?
> [-Werror=3Dimplicit-function-declaration]
> mm/kasan/hw_tags.c:284:29: error: invalid use of undefined type 'struct
> vm_struct'
> riscv32-linux-ld: section .data LMA [001f9000,009465d7] overlaps section
> .text LMA [000a7e84,0177d68b]
>
> Unverified Error/Warning (likely false positive, please contact us if
> interested):
>
> fs/smb/client/file.c:619 serverclose_work() error: uninitialized symbol
> 'rc'.
> fs/smb/client/file.c:732 _cifsFileInfo_put() error: uninitialized symbol
> 'rc'.
>
> Error/Warning ids grouped by kconfigs:
>
> gcc_recent_errors
> |-- alpha-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- alpha-allyesconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- alpha-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-allmodconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-allyesconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-aspeed_g5_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-randconfig-004-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-randconfig-r061-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm64-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm64-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm64-randconfig-003-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm64-randconfig-r011-20220710
> |   |--
> mm-kasan-hw_tags.c:error:implicit-declaration-of-function-find_vm_area
> |   |--
> mm-kasan-hw_tags.c:error:invalid-use-of-undefined-type-struct-vm_struct
> |   `--
> mm-kasan-hw_tags.c:warning:assignment-to-struct-vm_struct-from-int-makes-=
pointer-from-integer-without-a-cast
> |-- arm64-randconfig-r064-20240403
> |   |--
> drivers-firmware-arm_scmi-raw_mode.c:WARNING:scmi_dbg_raw_mode_reset_fops=
:write()-has-stream-semantic-safe-to-change-nonseekable_open-stream_open.
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- csky-allmodconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- csky-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- csky-allyesconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- csky-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- csky-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- csky-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-allmodconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-allyesconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-buildonly-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-buildonly-randconfig-005-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-003-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-004-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-006-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-011-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-013-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-015-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-051-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-053-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-061-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-062-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-063-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- loongarch-allmodconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- loongarch-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- loongarch-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- loongarch-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- loongarch-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- m68k-allmodconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- m68k-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- m68k-allyesconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- m68k-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- m68k-m5307c3_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- m68k-randconfig-r053-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- microblaze-allmodconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- microblaze-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- microblaze-allyesconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- microblaze-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- microblaze-randconfig-r122-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- mips-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- mips-allyesconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- mips-loongson3_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- nios2-allmodconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- nios2-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- nios2-allyesconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- nios2-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- nios2-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- nios2-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- nios2-randconfig-r131-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- nios2-randconfig-r133-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- openrisc-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- openrisc-allyesconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- openrisc-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- openrisc-randconfig-r111-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-allmodconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-mpc837x_rdb_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-mvme5100_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-ppc64e_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-randconfig-r121-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc64-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc64-randconfig-003-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- riscv-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- riscv-randconfig-r032-20221115
> |   `--
> riscv32-linux-ld:section-.data-LMA-001f9465d7-overlaps-section-.text-LMA-=
000a7e7d68b
> |-- riscv-randconfig-r112-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-alldefconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-allyesconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-randconfig-r052-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-randconfig-r123-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc-allmodconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc-randconfig-r051-20240403
> |   |--
> (.head.text):relocation-truncated-to-fit:R_SPARC_WDISP22-against-init.tex=
t
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc64-allmodconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc64-allyesconfig
> |   |--
> drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-output-may-be-tr=
uncated-writing-bytes-into-a-region-of-size-between-and
> |   |--
> drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-directive-output-may-=
be-truncated-writing-between-and-bytes-into-a-region-of-size
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc64-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc64-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- sparc64-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- um-allyesconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- um-i386_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- um-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-buildonly-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-buildonly-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-buildonly-randconfig-004-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-buildonly-randconfig-006-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-003-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-004-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-005-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-011-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-012-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-013-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-014-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-015-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-016-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-072-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-074-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-075-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-076-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-101-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-102-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |   `--
> sound-soc-codecs-rk3308_codec.c:warning:rk3308_codec_of_match-defined-but=
-not-used
> |-- x86_64-randconfig-103-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-104-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-122-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-161-20240403
> |   |--
> drivers-pinctrl-pinctrl-aw9523.c-aw9523_gpio_get_multiple()-error:uniniti=
alized-symbol-ret-.
> |   |--
> drivers-pinctrl-pinctrl-aw9523.c-aw9523_pconf_set()-error:uninitialized-s=
ymbol-rc-.
> |   |--
> fs-smb-client-file.c-_cifsFileInfo_put()-error:uninitialized-symbol-rc-.
> |   |--
> fs-smb-client-file.c-serverclose_work()-error:uninitialized-symbol-rc-.
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- xtensa-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- xtensa-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- xtensa-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> `-- xtensa-randconfig-r062-20240403
>     |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
>     `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> clang_recent_errors
> |-- arm-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-imx_v6_v7_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-pxa168_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm-randconfig-003-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm64-allmodconfig
> |   |--
> drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:error:arithme=
tic-between-different-enumeration-types-(-enum-dc_irq_source-and-enum-irq_t=
ype-)-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dce110-irq_service_dce110.c:=
error:arithmetic-between-different-enumeration-types-(-enum-dc_irq_source-a=
nd-enum-irq_type-)-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-d=
ifferent-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-W=
error-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-differen=
t-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)=
-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-i915-display-intel_ddi.c:error:arithmetic-between-differe=
nt-enumeration-types-(-enum-hpd_pin-and-enum-port-)-Werror-Wenum-enum-conve=
rsion
> |   |--
> drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-dif=
ferent-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-=
Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-dif=
ferent-enumeration-types-(-enum-tc_port-and-enum-port-)-Werror-Wenum-enum-c=
onversion
> |   |--
> drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-integer-type-enum-l=
ima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variable-out-set-but-no=
t-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-panthor-panthor_sched.c:error:variable-csg_mod_mask-set-b=
ut-not-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-typ=
e-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-diffe=
rent-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-We=
rror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-renesas-rcar-du-rcar_cmm.c:error:unused-function-rcar_cmm=
_read-Werror-Wunused-function
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm64-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm64-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- arm64-randconfig-004-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- hexagon-allmodconfig
> |   |--
> include-asm-generic-io.h:error:performing-pointer-arithmetic-on-a-null-po=
inter-has-undefined-behavior-Werror-Wnull-pointer-arithmetic
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- hexagon-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- hexagon-allyesconfig
> |   |--
> include-asm-generic-io.h:error:performing-pointer-arithmetic-on-a-null-po=
inter-has-undefined-behavior-Werror-Wnull-pointer-arithmetic
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- hexagon-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- hexagon-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- hexagon-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- hexagon-randconfig-r063-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-buildonly-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-buildonly-randconfig-003-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-buildonly-randconfig-004-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-buildonly-randconfig-006-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-005-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-012-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-014-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-016-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-052-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-054-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-141-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- i386-randconfig-r132-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- mips-bcm63xx_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- mips-mtx1_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-allyesconfig
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-d=
ifferent-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-W=
error-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-differen=
t-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)=
-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-integer-type-enum-l=
ima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variable-out-set-but-no=
t-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-nouveau-nvkm-subdev-bios-shadowof.c:error:cast-from-void-=
(-)(const-void-)-to-void-(-)(void-)-converts-to-incompatible-function-type-=
Werror-Wcast-function-type-strict
> |   |--
> drivers-gpu-drm-panthor-panthor_sched.c:error:variable-csg_mod_mask-set-b=
ut-not-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-typ=
e-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-diffe=
rent-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-We=
rror-Wenum-enum-conversion
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-eiger_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-mpc512x_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-randconfig-003-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc-randconfig-r054-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- powerpc64-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- riscv-allmodconfig
> |   |--
> drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:error:arithme=
tic-between-different-enumeration-types-(-enum-dc_irq_source-and-enum-irq_t=
ype-)-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dce110-irq_service_dce110.c:=
error:arithmetic-between-different-enumeration-types-(-enum-dc_irq_source-a=
nd-enum-irq_type-)-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-d=
ifferent-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-W=
error-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-differen=
t-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)=
-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-i915-display-intel_ddi.c:error:arithmetic-between-differe=
nt-enumeration-types-(-enum-hpd_pin-and-enum-port-)-Werror-Wenum-enum-conve=
rsion
> |   |--
> drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-dif=
ferent-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-=
Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-dif=
ferent-enumeration-types-(-enum-tc_port-and-enum-port-)-Werror-Wenum-enum-c=
onversion
> |   |--
> drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-integer-type-enum-l=
ima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variable-out-set-but-no=
t-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-panthor-panthor_sched.c:error:variable-csg_mod_mask-set-b=
ut-not-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-typ=
e-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-diffe=
rent-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-We=
rror-Wenum-enum-conversion
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- riscv-allyesconfig
> |   |--
> drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:error:arithme=
tic-between-different-enumeration-types-(-enum-dc_irq_source-and-enum-irq_t=
ype-)-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dce110-irq_service_dce110.c:=
error:arithmetic-between-different-enumeration-types-(-enum-dc_irq_source-a=
nd-enum-irq_type-)-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-d=
ifferent-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-W=
error-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-differen=
t-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)=
-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-integer-type-enum-l=
ima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variable-out-set-but-no=
t-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-panthor-panthor_sched.c:error:variable-csg_mod_mask-set-b=
ut-not-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-typ=
e-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-diffe=
rent-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-We=
rror-Wenum-enum-conversion
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- riscv-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- riscv-randconfig-001-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- riscv-randconfig-002-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-allmodconfig
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-d=
ifferent-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-W=
error-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-differen=
t-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)=
-Werror-Wenum-enum-conversion
> |   |--
> drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-integer-type-enum-l=
ima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-panthor-panthor_sched.c:error:variable-csg_mod_mask-set-b=
ut-not-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-typ=
e-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-diffe=
rent-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-We=
rror-Wenum-enum-conversion
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> include-asm-generic-io.h:error:performing-pointer-arithmetic-on-a-null-po=
inter-has-undefined-behavior-Werror-Wnull-pointer-arithmetic
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-defconfig
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-randconfig-001-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- s390-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- um-allmodconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- um-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- um-defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- um-randconfig-002-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- um-x86_64_defconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-allmodconfig
> |   |--
> drivers-gpu-drm-kmb-kmb_dsi.c:error:unused-function-set_test_mode_src_osc=
_freq_target_hi_bits-Werror-Wunused-function
> |   |--
> drivers-gpu-drm-kmb-kmb_dsi.c:error:unused-function-set_test_mode_src_osc=
_freq_target_low_bits-Werror-Wunused-function
> |   |--
> drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-integer-type-enum-l=
ima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variable-out-set-but-no=
t-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-panthor-panthor_sched.c:error:variable-csg_mod_mask-set-b=
ut-not-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-typ=
e-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-allnoconfig
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-allyesconfig
> |   |--
> drivers-gpu-drm-kmb-kmb_dsi.c:error:unused-function-set_test_mode_src_osc=
_freq_target_hi_bits-Werror-Wunused-function
> |   |--
> drivers-gpu-drm-kmb-kmb_dsi.c:error:unused-function-set_test_mode_src_osc=
_freq_target_low_bits-Werror-Wunused-function
> |   |--
> drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-integer-type-enum-l=
ima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variable-out-set-but-no=
t-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-panthor-panthor_sched.c:error:variable-csg_mod_mask-set-b=
ut-not-used-Werror-Wunused-but-set-variable
> |   |--
> drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-typ=
e-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-buildonly-randconfig-003-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-buildonly-randconfig-005-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-002-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-006-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-071-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-073-20240403
> |   |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-121-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> |-- x86_64-randconfig-123-20240403
> |   |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
> |   `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
> `-- x86_64-rhel-8.3-rust
>     |--
> fs-smb-client-file.c:warning:variable-rc-is-used-uninitialized-whenever-i=
f-condition-is-false
>     |--
> mm-mempool.c:warning:Function-parameter-or-struct-member-gfp_mask-not-des=
cribed-in-mempool_create_node
>     `--
> mm-mempool.c:warning:Function-parameter-or-struct-member-node_id-not-desc=
ribed-in-mempool_create_node
>
> elapsed time: 726m
>
> configs tested: 179
> configs skipped: 3
>
> tested configs:
> alpha                             allnoconfig   gcc
> alpha                            allyesconfig   gcc
> alpha                               defconfig   gcc
> arc                              allmodconfig   gcc
> arc                               allnoconfig   gcc
> arc                              allyesconfig   gcc
> arc                                 defconfig   gcc
> arc                   randconfig-001-20240403   gcc
> arc                   randconfig-002-20240403   gcc
> arm                              allmodconfig   gcc
> arm                               allnoconfig   clang
> arm                              allyesconfig   gcc
> arm                       aspeed_g5_defconfig   gcc
> arm                                 defconfig   clang
> arm                       imx_v6_v7_defconfig   clang
> arm                          pxa168_defconfig   clang
> arm                   randconfig-001-20240403   gcc
> arm                   randconfig-002-20240403   gcc
> arm                   randconfig-003-20240403   clang
> arm                   randconfig-004-20240403   gcc
> arm64                            allmodconfig   clang
> arm64                             allnoconfig   gcc
> arm64                               defconfig   gcc
> arm64                 randconfig-001-20240403   clang
> arm64                 randconfig-002-20240403   clang
> arm64                 randconfig-003-20240403   gcc
> arm64                 randconfig-004-20240403   clang
> csky                             allmodconfig   gcc
> csky                              allnoconfig   gcc
> csky                             allyesconfig   gcc
> csky                                defconfig   gcc
> csky                  randconfig-001-20240403   gcc
> csky                  randconfig-002-20240403   gcc
> hexagon                          allmodconfig   clang
> hexagon                           allnoconfig   clang
> hexagon                          allyesconfig   clang
> hexagon                             defconfig   clang
> hexagon               randconfig-001-20240403   clang
> hexagon               randconfig-002-20240403   clang
> i386                             allmodconfig   gcc
> i386                              allnoconfig   gcc
> i386                             allyesconfig   gcc
> i386         buildonly-randconfig-001-20240403   gcc
> i386         buildonly-randconfig-002-20240403   clang
> i386         buildonly-randconfig-003-20240403   clang
> i386         buildonly-randconfig-004-20240403   clang
> i386         buildonly-randconfig-005-20240403   gcc
> i386         buildonly-randconfig-006-20240403   clang
> i386                                defconfig   clang
> i386                  randconfig-001-20240403   gcc
> i386                  randconfig-002-20240403   clang
> i386                  randconfig-003-20240403   gcc
> i386                  randconfig-004-20240403   gcc
> i386                  randconfig-005-20240403   clang
> i386                  randconfig-006-20240403   gcc
> i386                  randconfig-011-20240403   gcc
> i386                  randconfig-012-20240403   clang
> i386                  randconfig-013-20240403   gcc
> i386                  randconfig-014-20240403   clang
> i386                  randconfig-015-20240403   gcc
> i386                  randconfig-016-20240403   clang
> loongarch                        allmodconfig   gcc
> loongarch                         allnoconfig   gcc
> loongarch                           defconfig   gcc
> loongarch             randconfig-001-20240403   gcc
> loongarch             randconfig-002-20240403   gcc
> m68k                             allmodconfig   gcc
> m68k                              allnoconfig   gcc
> m68k                             allyesconfig   gcc
> m68k                                defconfig   gcc
> m68k                        m5307c3_defconfig   gcc
> microblaze                       allmodconfig   gcc
> microblaze                        allnoconfig   gcc
> microblaze                       allyesconfig   gcc
> microblaze                          defconfig   gcc
> mips                              allnoconfig   gcc
> mips                             allyesconfig   gcc
> mips                        bcm63xx_defconfig   clang
> mips                      loongson3_defconfig   gcc
> mips                           mtx1_defconfig   clang
> nios2                            allmodconfig   gcc
> nios2                             allnoconfig   gcc
> nios2                            allyesconfig   gcc
> nios2                               defconfig   gcc
> nios2                 randconfig-001-20240403   gcc
> nios2                 randconfig-002-20240403   gcc
> openrisc                          allnoconfig   gcc
> openrisc                         allyesconfig   gcc
> openrisc                            defconfig   gcc
> parisc                           allmodconfig   gcc
> parisc                            allnoconfig   gcc
> parisc                           allyesconfig   gcc
> parisc                              defconfig   gcc
> parisc                randconfig-001-20240403   gcc
> parisc                randconfig-002-20240403   gcc
> parisc64                            defconfig   gcc
> powerpc                          allmodconfig   gcc
> powerpc                           allnoconfig   gcc
> powerpc                          allyesconfig   clang
> powerpc                       eiger_defconfig   clang
> powerpc                     mpc512x_defconfig   clang
> powerpc                 mpc837x_rdb_defconfig   gcc
> powerpc                    mvme5100_defconfig   gcc
> powerpc                      ppc64e_defconfig   gcc
> powerpc               randconfig-001-20240403   gcc
> powerpc               randconfig-002-20240403   gcc
> powerpc               randconfig-003-20240403   clang
> powerpc                     stx_gp3_defconfig   clang
> powerpc64             randconfig-001-20240403   gcc
> powerpc64             randconfig-002-20240403   clang
> powerpc64             randconfig-003-20240403   gcc
> riscv                            allmodconfig   clang
> riscv                             allnoconfig   gcc
> riscv                            allyesconfig   clang
> riscv                               defconfig   clang
> riscv                 randconfig-001-20240403   clang
> riscv                 randconfig-002-20240403   clang
> s390                             alldefconfig   gcc
> s390                             allmodconfig   clang
> s390                              allnoconfig   clang
> s390                             allyesconfig   gcc
> s390                                defconfig   clang
> s390                  randconfig-001-20240403   clang
> s390                  randconfig-002-20240403   clang
> sh                               allmodconfig   gcc
> sh                                allnoconfig   gcc
> sh                               allyesconfig   gcc
> sh                                  defconfig   gcc
> sh                    randconfig-001-20240403   gcc
> sh                    randconfig-002-20240403   gcc
> sh                           se7721_defconfig   gcc
> sh                        sh7763rdp_defconfig   gcc
> sparc                            allmodconfig   gcc
> sparc                             allnoconfig   gcc
> sparc                               defconfig   gcc
> sparc64                          allmodconfig   gcc
> sparc64                          allyesconfig   gcc
> sparc64                             defconfig   gcc
> sparc64               randconfig-001-20240403   gcc
> sparc64               randconfig-002-20240403   gcc
> um                               allmodconfig   clang
> um                                allnoconfig   clang
> um                               allyesconfig   gcc
> um                                  defconfig   clang
> um                             i386_defconfig   gcc
> um                    randconfig-001-20240403   gcc
> um                    randconfig-002-20240403   clang
> um                           x86_64_defconfig   clang
> x86_64                            allnoconfig   clang
> x86_64                           allyesconfig   clang
> x86_64       buildonly-randconfig-001-20240403   gcc
> x86_64       buildonly-randconfig-002-20240403   gcc
> x86_64       buildonly-randconfig-003-20240403   clang
> x86_64       buildonly-randconfig-004-20240403   gcc
> x86_64       buildonly-randconfig-005-20240403   clang
> x86_64       buildonly-randconfig-006-20240403   gcc
> x86_64                              defconfig   gcc
> x86_64                randconfig-001-20240403   gcc
> x86_64                randconfig-002-20240403   clang
> x86_64                randconfig-003-20240403   gcc
> x86_64                randconfig-004-20240403   gcc
> x86_64                randconfig-005-20240403   gcc
> x86_64                randconfig-006-20240403   clang
> x86_64                randconfig-011-20240403   gcc
> x86_64                randconfig-012-20240403   gcc
> x86_64                randconfig-013-20240403   gcc
> x86_64                randconfig-014-20240403   gcc
> x86_64                randconfig-015-20240403   gcc
> x86_64                randconfig-016-20240403   gcc
> x86_64                randconfig-071-20240403   clang
> x86_64                randconfig-072-20240403   gcc
> x86_64                randconfig-073-20240403   clang
> x86_64                randconfig-074-20240403   gcc
> x86_64                randconfig-075-20240403   gcc
> x86_64                randconfig-076-20240403   gcc
> x86_64                          rhel-8.3-rust   clang
> xtensa                            allnoconfig   gcc
> xtensa                randconfig-001-20240403   gcc
> xtensa                randconfig-002-20240403   gcc
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
>

--=20
Thanks,

Steve

--0000000000003ca74106153697c1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Fixed (and updated in cifs-2.6.git for-next)=C2=A0<div>Upd=
ated patch attached</div><div><br></div><div><br></div></div><br><div class=
=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Apr 3, 2024 =
at 10:57=E2=80=AFAM kernel test robot &lt;<a href=3D"mailto:lkp@intel.com">=
lkp@intel.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddi=
ng-left:1ex">tree/branch: <a href=3D"https://git.kernel.org/pub/scm/linux/k=
ernel/git/next/linux-next.git" rel=3D"noreferrer" target=3D"_blank">https:/=
/git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git</a> master<br>
branch HEAD: 727900b675b749c40ba1f6669c7ae5eb7eb8e837=C2=A0 Add linux-next =
specific files for 20240403<br>
<br>
Error/Warning reports:<br>
<br>
<a href=3D"https://lore.kernel.org/oe-kbuild-all/202404031246.aq5Yr5KO-lkp@=
intel.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/oe-=
kbuild-all/202404031246.aq5Yr5KO-lkp@intel.com</a><br>
<a href=3D"https://lore.kernel.org/oe-kbuild-all/202404031346.wpIhNpyF-lkp@=
intel.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/oe-=
kbuild-all/202404031346.wpIhNpyF-lkp@intel.com</a><br>
<a href=3D"https://lore.kernel.org/oe-kbuild-all/202404032101.sKzRXCWH-lkp@=
intel.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/oe-=
kbuild-all/202404032101.sKzRXCWH-lkp@intel.com</a><br>
<br>
Error/Warning: (recently discovered and may have been fixed)<br>
<br>
fs/smb/client/file.c:728:12: warning: variable &#39;rc&#39; is used uniniti=
alized whenever &#39;if&#39; condition is false [-Wsometimes-uninitialized]=
<br>
mm/kasan/hw_tags.c:280:14: warning: assignment to &#39;struct vm_struct *&#=
39; from &#39;int&#39; makes pointer from integer without a cast [-Wint-con=
version]<br>
mm/kasan/hw_tags.c:280:16: error: implicit declaration of function &#39;fin=
d_vm_area&#39;; did you mean &#39;find_vma_prev&#39;? [-Werror=3Dimplicit-f=
unction-declaration]<br>
mm/kasan/hw_tags.c:284:29: error: invalid use of undefined type &#39;struct=
 vm_struct&#39;<br>
riscv32-linux-ld: section .data LMA [001f9000,009465d7] overlaps section .t=
ext LMA [000a7e84,0177d68b]<br>
<br>
Unverified Error/Warning (likely false positive, please contact us if inter=
ested):<br>
<br>
fs/smb/client/file.c:619 serverclose_work() error: uninitialized symbol &#3=
9;rc&#39;.<br>
fs/smb/client/file.c:732 _cifsFileInfo_put() error: uninitialized symbol &#=
39;rc&#39;.<br>
<br>
Error/Warning ids grouped by kconfigs:<br>
<br>
gcc_recent_errors<br>
|-- alpha-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- alpha-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- alpha-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-aspeed_g5_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-randconfig-004-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-randconfig-r061-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm64-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm64-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm64-randconfig-003-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm64-randconfig-r011-20220710<br>
|=C2=A0 =C2=A0|-- mm-kasan-hw_tags.c:error:implicit-declaration-of-function=
-find_vm_area<br>
|=C2=A0 =C2=A0|-- mm-kasan-hw_tags.c:error:invalid-use-of-undefined-type-st=
ruct-vm_struct<br>
|=C2=A0 =C2=A0`-- mm-kasan-hw_tags.c:warning:assignment-to-struct-vm_struct=
-from-int-makes-pointer-from-integer-without-a-cast<br>
|-- arm64-randconfig-r064-20240403<br>
|=C2=A0 =C2=A0|-- drivers-firmware-arm_scmi-raw_mode.c:WARNING:scmi_dbg_raw=
_mode_reset_fops:write()-has-stream-semantic-safe-to-change-nonseekable_ope=
n-stream_open.<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- csky-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- csky-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- csky-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- csky-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- csky-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- csky-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-allmodconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-allyesconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-buildonly-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-buildonly-randconfig-005-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-003-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-004-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-006-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-011-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-013-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-015-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-051-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-053-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-061-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-062-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-063-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- loongarch-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- loongarch-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- loongarch-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- loongarch-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- loongarch-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- m68k-allmodconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- m68k-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- m68k-allyesconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- m68k-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- m68k-m5307c3_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- m68k-randconfig-r053-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- microblaze-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- microblaze-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- microblaze-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- microblaze-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- microblaze-randconfig-r122-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- mips-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- mips-allyesconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- mips-loongson3_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- nios2-allmodconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- nios2-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- nios2-allyesconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- nios2-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- nios2-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- nios2-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- nios2-randconfig-r131-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- nios2-randconfig-r133-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- openrisc-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- openrisc-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- openrisc-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- openrisc-randconfig-r111-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-mpc837x_rdb_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-mvme5100_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-ppc64e_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-randconfig-r121-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc64-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc64-randconfig-003-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- riscv-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- riscv-randconfig-r032-20221115<br>
|=C2=A0 =C2=A0`-- riscv32-linux-ld:section-.data-LMA-001f9465d7-overlaps-se=
ction-.text-LMA-000a7e7d68b<br>
|-- riscv-randconfig-r112-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-alldefconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-randconfig-r052-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-randconfig-r123-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc-randconfig-r051-20240403<br>
|=C2=A0 =C2=A0|-- (.head.text):relocation-truncated-to-fit:R_SPARC_WDISP22-=
against-init.text<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc64-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc64-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-imx-ipuv3-imx-ldb.c:error:_sel-directive-=
output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nouveau_backlight.c:error:d-direc=
tive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-siz=
e<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc64-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc64-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- sparc64-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- um-allyesconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- um-i386_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- um-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-buildonly-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-buildonly-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-buildonly-randconfig-004-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-buildonly-randconfig-006-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-003-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-004-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-005-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-011-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-012-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-013-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-014-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-015-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-016-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-072-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-074-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-075-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-076-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-101-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-102-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- sound-soc-codecs-rk3308_codec.c:warning:rk3308_codec_of_m=
atch-defined-but-not-used<br>
|-- x86_64-randconfig-103-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-104-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-122-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-161-20240403<br>
|=C2=A0 =C2=A0|-- drivers-pinctrl-pinctrl-aw9523.c-aw9523_gpio_get_multiple=
()-error:uninitialized-symbol-ret-.<br>
|=C2=A0 =C2=A0|-- drivers-pinctrl-pinctrl-aw9523.c-aw9523_pconf_set()-error=
:uninitialized-symbol-rc-.<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c-_cifsFileInfo_put()-error:uninitiali=
zed-symbol-rc-.<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c-serverclose_work()-error:uninitializ=
ed-symbol-rc-.<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- xtensa-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- xtensa-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- xtensa-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
`-- xtensa-randconfig-r062-20240403<br>
=C2=A0 =C2=A0 |-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
=C2=A0 =C2=A0 `-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
clang_recent_errors<br>
|-- arm-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-imx_v6_v7_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-pxa168_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm-randconfig-003-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm64-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm=
.c:error:arithmetic-between-different-enumeration-types-(-enum-dc_irq_sourc=
e-and-enum-irq_type-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dce110-irq_s=
ervice_dce110.c:error:arithmetic-between-different-enumeration-types-(-enum=
-dc_irq_source-and-enum-irq_type-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-ope=
ration-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-am=
d_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-=
between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu=
_ras_mca_block-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-i915-display-intel_ddi.c:error:arithmetic=
-between-different-enumeration-types-(-enum-hpd_pin-and-enum-port-)-Werror-=
Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-i915-display-intel_display.c:error:arithm=
etic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display=
_power_domain-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-i915-display-intel_display.c:error:arithm=
etic-between-different-enumeration-types-(-enum-tc_port-and-enum-port-)-Wer=
ror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-int=
eger-type-enum-lima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cas=
t<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variabl=
e-out-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-panthor-panthor_sched.c:error:variable-cs=
g_mod_mask-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-sma=
ller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-=
to-enum-cast<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operati=
on-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon=
_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-renesas-rcar-du-rcar_cmm.c:error:unused-f=
unction-rcar_cmm_read-Werror-Wunused-function<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm64-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm64-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- arm64-randconfig-004-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- hexagon-allmodconfig<br>
|=C2=A0 =C2=A0|-- include-asm-generic-io.h:error:performing-pointer-arithme=
tic-on-a-null-pointer-has-undefined-behavior-Werror-Wnull-pointer-arithmeti=
c<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- hexagon-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- hexagon-allyesconfig<br>
|=C2=A0 =C2=A0|-- include-asm-generic-io.h:error:performing-pointer-arithme=
tic-on-a-null-pointer-has-undefined-behavior-Werror-Wnull-pointer-arithmeti=
c<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- hexagon-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- hexagon-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- hexagon-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- hexagon-randconfig-r063-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-buildonly-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-buildonly-randconfig-003-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-buildonly-randconfig-004-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-buildonly-randconfig-006-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-005-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-012-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-014-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-016-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-052-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-054-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-141-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- i386-randconfig-r132-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- mips-bcm63xx_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- mips-mtx1_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-ope=
ration-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-am=
d_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-=
between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu=
_ras_mca_block-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-int=
eger-type-enum-lima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cas=
t<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variabl=
e-out-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-nouveau-nvkm-subdev-bios-shadowof.c:error=
:cast-from-void-(-)(const-void-)-to-void-(-)(void-)-converts-to-incompatibl=
e-function-type-Werror-Wcast-function-type-strict<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-panthor-panthor_sched.c:error:variable-cs=
g_mod_mask-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-sma=
ller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-=
to-enum-cast<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operati=
on-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon=
_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-eiger_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-mpc512x_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-randconfig-003-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc-randconfig-r054-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- powerpc64-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- riscv-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm=
.c:error:arithmetic-between-different-enumeration-types-(-enum-dc_irq_sourc=
e-and-enum-irq_type-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dce110-irq_s=
ervice_dce110.c:error:arithmetic-between-different-enumeration-types-(-enum=
-dc_irq_source-and-enum-irq_type-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-ope=
ration-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-am=
d_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-=
between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu=
_ras_mca_block-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-i915-display-intel_ddi.c:error:arithmetic=
-between-different-enumeration-types-(-enum-hpd_pin-and-enum-port-)-Werror-=
Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-i915-display-intel_display.c:error:arithm=
etic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display=
_power_domain-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-i915-display-intel_display.c:error:arithm=
etic-between-different-enumeration-types-(-enum-tc_port-and-enum-port-)-Wer=
ror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-int=
eger-type-enum-lima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cas=
t<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variabl=
e-out-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-panthor-panthor_sched.c:error:variable-cs=
g_mod_mask-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-sma=
ller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-=
to-enum-cast<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operati=
on-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon=
_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- riscv-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm=
.c:error:arithmetic-between-different-enumeration-types-(-enum-dc_irq_sourc=
e-and-enum-irq_type-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dce110-irq_s=
ervice_dce110.c:error:arithmetic-between-different-enumeration-types-(-enum=
-dc_irq_source-and-enum-irq_type-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-ope=
ration-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-am=
d_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-=
between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu=
_ras_mca_block-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-int=
eger-type-enum-lima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cas=
t<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variabl=
e-out-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-panthor-panthor_sched.c:error:variable-cs=
g_mod_mask-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-sma=
ller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-=
to-enum-cast<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operati=
on-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon=
_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- riscv-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- riscv-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- riscv-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-ope=
ration-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-am=
d_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-=
between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu=
_ras_mca_block-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-int=
eger-type-enum-lima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cas=
t<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-panthor-panthor_sched.c:error:variable-cs=
g_mod_mask-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-sma=
ller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-=
to-enum-cast<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operati=
on-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon=
_chip_flags-)-Werror-Wenum-enum-conversion<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- include-asm-generic-io.h:error:performing-pointer-arithme=
tic-on-a-null-pointer-has-undefined-behavior-Werror-Wnull-pointer-arithmeti=
c<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-defconfig<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-randconfig-001-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- s390-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- um-allmodconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- um-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- um-defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- um-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- um-x86_64_defconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-allmodconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-kmb-kmb_dsi.c:error:unused-function-set_t=
est_mode_src_osc_freq_target_hi_bits-Werror-Wunused-function<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-kmb-kmb_dsi.c:error:unused-function-set_t=
est_mode_src_osc_freq_target_low_bits-Werror-Wunused-function<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-int=
eger-type-enum-lima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cas=
t<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variabl=
e-out-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-panthor-panthor_sched.c:error:variable-cs=
g_mod_mask-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-sma=
ller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-=
to-enum-cast<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-allnoconfig<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-allyesconfig<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-kmb-kmb_dsi.c:error:unused-function-set_t=
est_mode_src_osc_freq_target_hi_bits-Werror-Wunused-function<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-kmb-kmb_dsi.c:error:unused-function-set_t=
est_mode_src_osc_freq_target_low_bits-Werror-Wunused-function<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-lima-lima_drv.c:error:cast-to-smaller-int=
eger-type-enum-lima_gpu_id-from-const-void-Werror-Wvoid-pointer-to-enum-cas=
t<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-msm-adreno-a6xx_gpu_state.c:error:variabl=
e-out-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-panthor-panthor_sched.c:error:variable-cs=
g_mod_mask-set-but-not-used-Werror-Wunused-but-set-variable<br>
|=C2=A0 =C2=A0|-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-sma=
ller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-=
to-enum-cast<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-buildonly-randconfig-003-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-buildonly-randconfig-005-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-002-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-006-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-071-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-073-20240403<br>
|=C2=A0 =C2=A0|-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-121-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
|-- x86_64-randconfig-123-20240403<br>
|=C2=A0 =C2=A0|-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
|=C2=A0 =C2=A0`-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
`-- x86_64-rhel-8.3-rust<br>
=C2=A0 =C2=A0 |-- fs-smb-client-file.c:warning:variable-rc-is-used-uninitia=
lized-whenever-if-condition-is-false<br>
=C2=A0 =C2=A0 |-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
gfp_mask-not-described-in-mempool_create_node<br>
=C2=A0 =C2=A0 `-- mm-mempool.c:warning:Function-parameter-or-struct-member-=
node_id-not-described-in-mempool_create_node<br>
<br>
elapsed time: 726m<br>
<br>
configs tested: 179<br>
configs skipped: 3<br>
<br>
tested configs:<br>
alpha=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
alpha=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
alpha=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0gcc=C2=A0 <b=
r>
arc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
arc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0gcc=C2=A0 =
<br>
arc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
arc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0gcc=
=C2=A0 <br>
arc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ran=
dconfig-001-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
arc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ran=
dconfig-002-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0clang<br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0aspeed_g5_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0clang=
<br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0imx_v6_v7_defconfig=C2=A0 =C2=A0clang<br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 pxa168_defconfig=C2=A0 =C2=A0clang<br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ran=
dconfig-001-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ran=
dconfig-002-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ran=
dconfig-003-20240403=C2=A0 =C2=A0clang<br>
arm=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ran=
dconfig-004-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
arm64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0clang<br>
arm64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
arm64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0gcc=C2=A0 <b=
r>
arm64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconf=
ig-001-20240403=C2=A0 =C2=A0clang<br>
arm64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconf=
ig-002-20240403=C2=A0 =C2=A0clang<br>
arm64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconf=
ig-003-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
arm64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconf=
ig-004-20240403=C2=A0 =C2=A0clang<br>
csky=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
csky=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
csky=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
csky=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0gcc=C2=A0 <=
br>
csky=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-001-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
csky=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-002-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
hexagon=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0clang<br>
hexagon=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0clang<br>
hexagon=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 allyesconfig=C2=A0 =C2=A0clang<br>
hexagon=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0clang<br>
hexagon=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-00=
1-20240403=C2=A0 =C2=A0clang<br>
hexagon=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-00=
2-20240403=C2=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-001-20240403=C2=
=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-002-20240403=C2=
=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-003-20240403=C2=
=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-004-20240403=C2=
=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-005-20240403=C2=
=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-006-20240403=C2=
=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-001-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-002-20240403=C2=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-003-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-004-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-005-20240403=C2=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-006-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-011-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-012-20240403=C2=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-013-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-014-20240403=C2=A0 =C2=A0clang<br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-015-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
i386=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-016-20240403=C2=A0 =C2=A0clang<br>
loongarch=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
loongarch=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
loongarch=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
loongarch=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-001-202=
40403=C2=A0 =C2=A0gcc=C2=A0 <br>
loongarch=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-002-202=
40403=C2=A0 =C2=A0gcc=C2=A0 <br>
m68k=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
m68k=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
m68k=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
m68k=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0gcc=C2=A0 <=
br>
m68k=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 m5307c3_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
microblaze=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
microblaze=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
microblaze=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
microblaze=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
mips=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
mips=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
mips=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 bcm63xx_defconfig=C2=A0 =C2=A0clang<br>
mips=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 loongson3_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
mips=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0mtx1_defconfig=C2=A0 =C2=A0clang<br>
nios2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
nios2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
nios2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
nios2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0gcc=C2=A0 <b=
r>
nios2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconf=
ig-001-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
nios2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconf=
ig-002-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
openrisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
openrisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
openrisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
parisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
parisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
parisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
parisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
parisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
1-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
parisc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
2-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
parisc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 allyesconfig=C2=A0 =C2=A0clang<br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0eiger_defconfig=C2=A0 =C2=A0clang<br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mpc512x_defconfig=C2=A0 =C2=A0clang<br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpc837=
x_rdb_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 mvme5100_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ppc64e_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-00=
1-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-00=
2-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-00=
3-20240403=C2=A0 =C2=A0clang<br>
powerpc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0stx_gp3_defconfig=C2=A0 =C2=A0clang<br>
powerpc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-001-202=
40403=C2=A0 =C2=A0gcc=C2=A0 <br>
powerpc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-002-202=
40403=C2=A0 =C2=A0clang<br>
powerpc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-003-202=
40403=C2=A0 =C2=A0gcc=C2=A0 <br>
riscv=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0clang<br>
riscv=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
riscv=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 allyesconfig=C2=A0 =C2=A0clang<br>
riscv=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0clang<br>
riscv=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconf=
ig-001-20240403=C2=A0 =C2=A0clang<br>
riscv=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconf=
ig-002-20240403=C2=A0 =C2=A0clang<br>
s390=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0alldefconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
s390=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allmodconfig=C2=A0 =C2=A0clang<br>
s390=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0clang<br>
s390=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
s390=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0clang<br>
s390=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-001-20240403=C2=A0 =C2=A0clang<br>
s390=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconf=
ig-002-20240403=C2=A0 =C2=A0clang<br>
sh=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <b=
r>
sh=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <b=
r>
sh=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <b=
r>
sh=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0gcc=C2=
=A0 <br>
sh=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ran=
dconfig-001-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
sh=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ran=
dconfig-002-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
sh=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0se7721_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
sh=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sh7763rdp_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
sparc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
sparc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
sparc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0gcc=C2=A0 <b=
r>
sparc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 allmodconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
sparc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
sparc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
sparc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-00=
1-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
sparc64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0randconfig-00=
2-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
um=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allmodconfig=C2=A0 =C2=A0clang<br>
um=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0clang<br>
um=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0gcc=C2=A0 <b=
r>
um=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0clang<b=
r>
um=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i386_defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
um=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ran=
dconfig-001-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
um=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ran=
dconfig-002-20240403=C2=A0 =C2=A0clang<br>
um=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0x86_64_defconfig=C2=A0 =C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0allyesconfig=C2=A0 =C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-001-20240403=C2=A0 =
=C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-002-20240403=C2=A0 =
=C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-003-20240403=C2=A0 =
=C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-004-20240403=C2=A0 =
=C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-005-20240403=C2=A0 =
=C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0buildonly-randconfig-006-20240403=C2=A0 =
=C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
1-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
2-20240403=C2=A0 =C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
3-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
4-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
5-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
6-20240403=C2=A0 =C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-01=
1-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-01=
2-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-01=
3-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-01=
4-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-01=
5-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-01=
6-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-07=
1-20240403=C2=A0 =C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-07=
2-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-07=
3-20240403=C2=A0 =C2=A0clang<br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-07=
4-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-07=
5-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-07=
6-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 rhel-8.3-rust=C2=A0 =C2=A0clang<br>
xtensa=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 allnoconfig=C2=A0 =C2=A0gcc=C2=A0 <br>
xtensa=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
1-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
xtensa=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 randconfig-00=
2-20240403=C2=A0 =C2=A0gcc=C2=A0 <br>
<br>
-- <br>
0-DAY CI Kernel Test Service<br>
<a href=3D"https://github.com/intel/lkp-tests/wiki" rel=3D"noreferrer" targ=
et=3D"_blank">https://github.com/intel/lkp-tests/wiki</a><br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature">Th=
anks,<br><br>Steve</div>

--0000000000003ca74106153697c1--
--0000000000003ca74306153697c3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-retrying-on-failed-server-close.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-retrying-on-failed-server-close.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_luk87s160>
X-Attachment-Id: f_luk87s160

RnJvbSAxNzMyMTdiZDczMzY1ODY3Mzc4YjVlNzVhODZmMDA0OWUxMDY5ZWU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSaXR2aWsgQnVkaGlyYWphIDxyYnVkaGlyYWphQG1pY3Jvc29m
dC5jb20+CkRhdGU6IFR1ZSwgMiBBcHIgMjAyNCAxNDowMToyOCAtMDUwMApTdWJqZWN0OiBbUEFU
Q0hdIHNtYjM6IHJldHJ5aW5nIG9uIGZhaWxlZCBzZXJ2ZXIgY2xvc2UKCkluIHRoZSBjdXJyZW50
IGltcGxlbWVudGF0aW9uLCBDSUZTIGNsb3NlIHNlbmRzIGEgY2xvc2UgdG8gdGhlCnNlcnZlciBh
bmQgZG9lcyBub3QgY2hlY2sgZm9yIHRoZSBzdWNjZXNzIG9mIHRoZSBzZXJ2ZXIgY2xvc2UuClRo
aXMgcGF0Y2ggYWRkcyBmdW5jdGlvbmFsaXR5IHRvIGNoZWNrIGZvciBzZXJ2ZXIgY2xvc2UgcmV0
dXJuCnN0YXR1cyBhbmQgcmV0cmllcyBpbiBjYXNlIG9mIGFuIEVCVVNZIG9yIEVBR0FJTiBlcnJv
ci4KClRoaXMgY2FuIGhlbHAgYXZvaWQgaGFuZGxlIGxlYWtzCgpDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBSaXR2aWsgQnVkaGlyYWphIDxyYnVkaGlyYWphQG1pY3Jv
c29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYyB8ICA2ICsrLS0KIGZzL3NtYi9j
bGllbnQvY2lmc2ZzLmMgICAgIHwgMTEgKysrKysrKwogZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5o
ICAgfCAgNyArKystLQogZnMvc21iL2NsaWVudC9maWxlLmMgICAgICAgfCA2MyArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLQogZnMvc21iL2NsaWVudC9zbWIxb3BzLmMgICAg
fCAgNCArLS0KIGZzL3NtYi9jbGllbnQvc21iMm9wcy5jICAgIHwgIDkgKysrLS0tCiBmcy9zbWIv
Y2xpZW50L3NtYjJwZHUuYyAgICB8ICAyICstCiA3IGZpbGVzIGNoYW5nZWQsIDg1IGluc2VydGlv
bnMoKyksIDE3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2FjaGVk
X2Rpci5jIGIvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMKaW5kZXggYTAwMTc3MjRkNTIzLi4x
M2E5ZDdhY2Y4ZjggMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCisrKyBi
L2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCkBAIC00MTcsNiArNDE3LDcgQEAgc21iMl9jbG9z
ZV9jYWNoZWRfZmlkKHN0cnVjdCBrcmVmICpyZWYpCiB7CiAJc3RydWN0IGNhY2hlZF9maWQgKmNm
aWQgPSBjb250YWluZXJfb2YocmVmLCBzdHJ1Y3QgY2FjaGVkX2ZpZCwKIAkJCQkJICAgICAgIHJl
ZmNvdW50KTsKKwlpbnQgcmM7CiAKIAlzcGluX2xvY2soJmNmaWQtPmNmaWRzLT5jZmlkX2xpc3Rf
bG9jayk7CiAJaWYgKGNmaWQtPm9uX2xpc3QpIHsKQEAgLTQzMCw5ICs0MzEsMTAgQEAgc21iMl9j
bG9zZV9jYWNoZWRfZmlkKHN0cnVjdCBrcmVmICpyZWYpCiAJY2ZpZC0+ZGVudHJ5ID0gTlVMTDsK
IAogCWlmIChjZmlkLT5pc19vcGVuKSB7Ci0JCVNNQjJfY2xvc2UoMCwgY2ZpZC0+dGNvbiwgY2Zp
ZC0+ZmlkLnBlcnNpc3RlbnRfZmlkLAorCQlyYyA9IFNNQjJfY2xvc2UoMCwgY2ZpZC0+dGNvbiwg
Y2ZpZC0+ZmlkLnBlcnNpc3RlbnRfZmlkLAogCQkJICAgY2ZpZC0+ZmlkLnZvbGF0aWxlX2ZpZCk7
Ci0JCWF0b21pY19kZWMoJmNmaWQtPnRjb24tPm51bV9yZW1vdGVfb3BlbnMpOworCQlpZiAocmMg
IT0gLUVCVVNZICYmIHJjICE9IC1FQUdBSU4pCisJCQlhdG9taWNfZGVjKCZjZmlkLT50Y29uLT5u
dW1fcmVtb3RlX29wZW5zKTsKIAl9CiAKIAlmcmVlX2NhY2hlZF9kaXIoY2ZpZCk7CmRpZmYgLS1n
aXQgYS9mcy9zbWIvY2xpZW50L2NpZnNmcy5jIGIvZnMvc21iL2NsaWVudC9jaWZzZnMuYwppbmRl
eCBhYTZmMWVjYjdjMGUuLmQ0MWVlZGJmZjY3NCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9j
aWZzZnMuYworKysgYi9mcy9zbWIvY2xpZW50L2NpZnNmcy5jCkBAIC0xNTYsNiArMTU2LDcgQEAg
c3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJKmRlY3J5cHRfd3E7CiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0
cnVjdAkqZmlsZWluZm9fcHV0X3dxOwogc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJKmNpZnNvcGxv
Y2tkX3dxOwogc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJKmRlZmVycmVkY2xvc2Vfd3E7CitzdHJ1
Y3Qgd29ya3F1ZXVlX3N0cnVjdAkqc2VydmVyY2xvc2Vfd3E7CiBfX3UzMiBjaWZzX2xvY2tfc2Vj
cmV0OwogCiAvKgpAQCAtMTg4OCw2ICsxODg5LDEzIEBAIGluaXRfY2lmcyh2b2lkKQogCQlnb3Rv
IG91dF9kZXN0cm95X2NpZnNvcGxvY2tkX3dxOwogCX0KIAorCXNlcnZlcmNsb3NlX3dxID0gYWxs
b2Nfd29ya3F1ZXVlKCJzZXJ2ZXJjbG9zZSIsCisJCQkJCSAgIFdRX0ZSRUVaQUJMRXxXUV9NRU1f
UkVDTEFJTSwgMCk7CisJaWYgKCFzZXJ2ZXJjbG9zZV93cSkgeworCQlyYyA9IC1FTk9NRU07CisJ
CWdvdG8gb3V0X2Rlc3Ryb3lfc2VydmVyY2xvc2Vfd3E7CisJfQorCiAJcmMgPSBjaWZzX2luaXRf
aW5vZGVjYWNoZSgpOwogCWlmIChyYykKIAkJZ290byBvdXRfZGVzdHJveV9kZWZlcnJlZGNsb3Nl
X3dxOwpAQCAtMTk2Miw2ICsxOTcwLDggQEAgaW5pdF9jaWZzKHZvaWQpCiAJZGVzdHJveV93b3Jr
cXVldWUoZGVjcnlwdF93cSk7CiBvdXRfZGVzdHJveV9jaWZzaW9kX3dxOgogCWRlc3Ryb3lfd29y
a3F1ZXVlKGNpZnNpb2Rfd3EpOworb3V0X2Rlc3Ryb3lfc2VydmVyY2xvc2Vfd3E6CisJZGVzdHJv
eV93b3JrcXVldWUoc2VydmVyY2xvc2Vfd3EpOwogb3V0X2NsZWFuX3Byb2M6CiAJY2lmc19wcm9j
X2NsZWFuKCk7CiAJcmV0dXJuIHJjOwpAQCAtMTk5MSw2ICsyMDAxLDcgQEAgZXhpdF9jaWZzKHZv
aWQpCiAJZGVzdHJveV93b3JrcXVldWUoY2lmc29wbG9ja2Rfd3EpOwogCWRlc3Ryb3lfd29ya3F1
ZXVlKGRlY3J5cHRfd3EpOwogCWRlc3Ryb3lfd29ya3F1ZXVlKGZpbGVpbmZvX3B1dF93cSk7CisJ
ZGVzdHJveV93b3JrcXVldWUoc2VydmVyY2xvc2Vfd3EpOwogCWRlc3Ryb3lfd29ya3F1ZXVlKGNp
ZnNpb2Rfd3EpOwogCWNpZnNfcHJvY19jbGVhbigpOwogfQpkaWZmIC0tZ2l0IGEvZnMvc21iL2Ns
aWVudC9jaWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCmluZGV4IDI4NmFmYmUz
NDZiZS4uNzdjYTc4NjFhMmNjIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgK
KysrIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCkBAIC00NDIsMTAgKzQ0MiwxMCBAQCBzdHJ1
Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyB7CiAJLyogc2V0IGZpZCBwcm90b2NvbC1zcGVjaWZp
YyBpbmZvICovCiAJdm9pZCAoKnNldF9maWQpKHN0cnVjdCBjaWZzRmlsZUluZm8gKiwgc3RydWN0
IGNpZnNfZmlkICosIF9fdTMyKTsKIAkvKiBjbG9zZSBhIGZpbGUgKi8KLQl2b2lkICgqY2xvc2Up
KGNvbnN0IHVuc2lnbmVkIGludCwgc3RydWN0IGNpZnNfdGNvbiAqLAorCWludCAoKmNsb3NlKShj
b25zdCB1bnNpZ25lZCBpbnQsIHN0cnVjdCBjaWZzX3Rjb24gKiwKIAkJICAgICAgc3RydWN0IGNp
ZnNfZmlkICopOwogCS8qIGNsb3NlIGEgZmlsZSwgcmV0dXJuaW5nIGZpbGUgYXR0cmlidXRlcyBh
bmQgdGltZXN0YW1wcyAqLwotCXZvaWQgKCpjbG9zZV9nZXRhdHRyKShjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAorCWludCAoKmNsb3NlX2dldGF0dHIpKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCSAgICAgIHN0
cnVjdCBjaWZzRmlsZUluZm8gKnBmaWxlX2luZm8pOwogCS8qIHNlbmQgYSBmbHVzaCByZXF1ZXN0
IHRvIHRoZSBzZXJ2ZXIgKi8KIAlpbnQgKCpmbHVzaCkoY29uc3QgdW5zaWduZWQgaW50LCBzdHJ1
Y3QgY2lmc190Y29uICosIHN0cnVjdCBjaWZzX2ZpZCAqKTsKQEAgLTE0MzksNiArMTQzOSw3IEBA
IHN0cnVjdCBjaWZzRmlsZUluZm8gewogCWJvb2wgc3dhcGZpbGU6MTsKIAlib29sIG9wbG9ja19i
cmVha19jYW5jZWxsZWQ6MTsKIAlib29sIHN0YXR1c19maWxlX2RlbGV0ZWQ6MTsgLyogZmlsZSBo
YXMgYmVlbiBkZWxldGVkICovCisJYm9vbCBvZmZsb2FkOjE7IC8qIG9mZmxvYWQgZmluYWwgcGFy
dCBvZiBfcHV0IHRvIGEgd3EgKi8KIAl1bnNpZ25lZCBpbnQgb3Bsb2NrX2Vwb2NoOyAvKiBlcG9j
aCBmcm9tIHRoZSBsZWFzZSBicmVhayAqLwogCV9fdTMyIG9wbG9ja19sZXZlbDsgLyogb3Bsb2Nr
L2xlYXNlIGxldmVsIGZyb20gdGhlIGxlYXNlIGJyZWFrICovCiAJaW50IGNvdW50OwpAQCAtMTQ0
Nyw2ICsxNDQ4LDcgQEAgc3RydWN0IGNpZnNGaWxlSW5mbyB7CiAJc3RydWN0IGNpZnNfc2VhcmNo
X2luZm8gc3JjaF9pbmY7CiAJc3RydWN0IHdvcmtfc3RydWN0IG9wbG9ja19icmVhazsgLyogd29y
ayBmb3Igb3Bsb2NrIGJyZWFrcyAqLwogCXN0cnVjdCB3b3JrX3N0cnVjdCBwdXQ7IC8qIHdvcmsg
Zm9yIHRoZSBmaW5hbCBwYXJ0IG9mIF9wdXQgKi8KKwlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgc2VydmVy
Y2xvc2U7IC8qIHdvcmsgZm9yIHNlcnZlcmNsb3NlICovCiAJc3RydWN0IGRlbGF5ZWRfd29yayBk
ZWZlcnJlZDsKIAlib29sIGRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZDsgLyogRmxhZyB0byBpbmRp
Y2F0ZSBjbG9zZSBpcyBzY2hlZHVsZWQgKi8KIAljaGFyICpzeW1saW5rX3RhcmdldDsKQEAgLTIx
MDMsNiArMjEwNSw3IEBAIGV4dGVybiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqZGVjcnlwdF93
cTsKIGV4dGVybiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqZmlsZWluZm9fcHV0X3dxOwogZXh0
ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpjaWZzb3Bsb2NrZF93cTsKIGV4dGVybiBzdHJ1
Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqZGVmZXJyZWRjbG9zZV93cTsKK2V4dGVybiBzdHJ1Y3Qgd29y
a3F1ZXVlX3N0cnVjdCAqc2VydmVyY2xvc2Vfd3E7CiBleHRlcm4gX191MzIgY2lmc19sb2NrX3Nl
Y3JldDsKIAogZXh0ZXJuIG1lbXBvb2xfdCAqY2lmc19zbV9yZXFfcG9vbHA7CmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L2ZpbGUuYyBiL2ZzL3NtYi9jbGllbnQvZmlsZS5jCmluZGV4IGFiNTM2
Y2U4YTA0YS4uOWJlMzdkMGZlNzI0IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2ZpbGUuYwor
KysgYi9mcy9zbWIvY2xpZW50L2ZpbGUuYwpAQCAtNDU5LDYgKzQ1OSw3IEBAIGNpZnNfZG93bl93
cml0ZShzdHJ1Y3Qgcndfc2VtYXBob3JlICpzZW0pCiB9CiAKIHN0YXRpYyB2b2lkIGNpZnNGaWxl
SW5mb19wdXRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwordm9pZCBzZXJ2ZXJjbG9z
ZV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayk7CiAKIHN0cnVjdCBjaWZzRmlsZUluZm8g
KmNpZnNfbmV3X2ZpbGVpbmZvKHN0cnVjdCBjaWZzX2ZpZCAqZmlkLCBzdHJ1Y3QgZmlsZSAqZmls
ZSwKIAkJCQkgICAgICAgc3RydWN0IHRjb25fbGluayAqdGxpbmssIF9fdTMyIG9wbG9jaywKQEAg
LTUwNSw2ICs1MDYsNyBAQCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjaWZzX25ld19maWxlaW5mbyhz
dHJ1Y3QgY2lmc19maWQgKmZpZCwgc3RydWN0IGZpbGUgKmZpbGUsCiAJY2ZpbGUtPnRsaW5rID0g
Y2lmc19nZXRfdGxpbmsodGxpbmspOwogCUlOSVRfV09SSygmY2ZpbGUtPm9wbG9ja19icmVhaywg
Y2lmc19vcGxvY2tfYnJlYWspOwogCUlOSVRfV09SSygmY2ZpbGUtPnB1dCwgY2lmc0ZpbGVJbmZv
X3B1dF93b3JrKTsKKwlJTklUX1dPUksoJmNmaWxlLT5zZXJ2ZXJjbG9zZSwgc2VydmVyY2xvc2Vf
d29yayk7CiAJSU5JVF9ERUxBWUVEX1dPUksoJmNmaWxlLT5kZWZlcnJlZCwgc21iMl9kZWZlcnJl
ZF93b3JrX2Nsb3NlKTsKIAltdXRleF9pbml0KCZjZmlsZS0+ZmhfbXV0ZXgpOwogCXNwaW5fbG9j
a19pbml0KCZjZmlsZS0+ZmlsZV9pbmZvX2xvY2spOwpAQCAtNTk2LDYgKzU5OCw0MCBAQCBzdGF0
aWMgdm9pZCBjaWZzRmlsZUluZm9fcHV0X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQog
CWNpZnNGaWxlSW5mb19wdXRfZmluYWwoY2lmc19maWxlKTsKIH0KIAordm9pZCBzZXJ2ZXJjbG9z
ZV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKK3sKKwlzdHJ1Y3QgY2lmc0ZpbGVJbmZv
ICpjaWZzX2ZpbGUgPSBjb250YWluZXJfb2Yod29yaywKKwkJCXN0cnVjdCBjaWZzRmlsZUluZm8s
IHNlcnZlcmNsb3NlKTsKKworCXN0cnVjdCBjaWZzX3Rjb24gKnRjb24gPSB0bGlua190Y29uKGNp
ZnNfZmlsZS0+dGxpbmspOworCisJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyID0gdGNv
bi0+c2VzLT5zZXJ2ZXI7CisJaW50IHJjID0gMDsKKwlpbnQgcmV0cmllcyA9IDA7CisJaW50IE1B
WF9SRVRSSUVTID0gNDsKKworCWRvIHsKKwkJaWYgKHNlcnZlci0+b3BzLT5jbG9zZV9nZXRhdHRy
KQorCQkJcmMgPSBzZXJ2ZXItPm9wcy0+Y2xvc2VfZ2V0YXR0cigwLCB0Y29uLCBjaWZzX2ZpbGUp
OworCQllbHNlIGlmIChzZXJ2ZXItPm9wcy0+Y2xvc2UpCisJCQlyYyA9IHNlcnZlci0+b3BzLT5j
bG9zZSgwLCB0Y29uLCAmY2lmc19maWxlLT5maWQpOworCisJCWlmIChyYyA9PSAtRUJVU1kgfHwg
cmMgPT0gLUVBR0FJTikgeworCQkJcmV0cmllcysrOworCQkJbXNsZWVwKDI1MCk7CisJCX0KKwl9
IHdoaWxlICgocmMgPT0gLUVCVVNZIHx8IHJjID09IC1FQUdBSU4pICYmIChyZXRyaWVzIDwgTUFY
X1JFVFJJRVMpCisJKTsKKworCWlmIChyZXRyaWVzID09IE1BWF9SRVRSSUVTKQorCQlwcl93YXJu
KCJTZXJ2ZXJjbG9zZSBmYWlsZWQgJWQgdGltZXMsIGdpdmluZyB1cFxuIiwgTUFYX1JFVFJJRVMp
OworCisJaWYgKGNpZnNfZmlsZS0+b2ZmbG9hZCkKKwkJcXVldWVfd29yayhmaWxlaW5mb19wdXRf
d3EsICZjaWZzX2ZpbGUtPnB1dCk7CisJZWxzZQorCQljaWZzRmlsZUluZm9fcHV0X2ZpbmFsKGNp
ZnNfZmlsZSk7Cit9CisKIC8qKgogICogY2lmc0ZpbGVJbmZvX3B1dCAtIHJlbGVhc2UgYSByZWZl
cmVuY2Ugb2YgZmlsZSBwcml2IGRhdGEKICAqCkBAIC02MzYsMTAgKzY3MiwxMyBAQCB2b2lkIF9j
aWZzRmlsZUluZm9fcHV0KHN0cnVjdCBjaWZzRmlsZUluZm8gKmNpZnNfZmlsZSwKIAlzdHJ1Y3Qg
Y2lmc19maWQgZmlkID0ge307CiAJc3RydWN0IGNpZnNfcGVuZGluZ19vcGVuIG9wZW47CiAJYm9v
bCBvcGxvY2tfYnJlYWtfY2FuY2VsbGVkOworCWJvb2wgc2VydmVyY2xvc2Vfb2ZmbG9hZGVkID0g
ZmFsc2U7CiAKIAlzcGluX2xvY2soJnRjb24tPm9wZW5fZmlsZV9sb2NrKTsKIAlzcGluX2xvY2so
JmNpZnNpLT5vcGVuX2ZpbGVfbG9jayk7CiAJc3Bpbl9sb2NrKCZjaWZzX2ZpbGUtPmZpbGVfaW5m
b19sb2NrKTsKKworCWNpZnNfZmlsZS0+b2ZmbG9hZCA9IG9mZmxvYWQ7CiAJaWYgKC0tY2lmc19m
aWxlLT5jb3VudCA+IDApIHsKIAkJc3Bpbl91bmxvY2soJmNpZnNfZmlsZS0+ZmlsZV9pbmZvX2xv
Y2spOwogCQlzcGluX3VubG9jaygmY2lmc2ktPm9wZW5fZmlsZV9sb2NrKTsKQEAgLTY4MSwxMyAr
NzIwLDIwIEBAIHZvaWQgX2NpZnNGaWxlSW5mb19wdXQoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2lm
c19maWxlLAogCWlmICghdGNvbi0+bmVlZF9yZWNvbm5lY3QgJiYgIWNpZnNfZmlsZS0+aW52YWxp
ZEhhbmRsZSkgewogCQlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSB0Y29uLT5zZXMt
PnNlcnZlcjsKIAkJdW5zaWduZWQgaW50IHhpZDsKKwkJaW50IHJjID0gMDsKIAogCQl4aWQgPSBn
ZXRfeGlkKCk7CiAJCWlmIChzZXJ2ZXItPm9wcy0+Y2xvc2VfZ2V0YXR0cikKLQkJCXNlcnZlci0+
b3BzLT5jbG9zZV9nZXRhdHRyKHhpZCwgdGNvbiwgY2lmc19maWxlKTsKKwkJCXJjID0gc2VydmVy
LT5vcHMtPmNsb3NlX2dldGF0dHIoeGlkLCB0Y29uLCBjaWZzX2ZpbGUpOwogCQllbHNlIGlmIChz
ZXJ2ZXItPm9wcy0+Y2xvc2UpCi0JCQlzZXJ2ZXItPm9wcy0+Y2xvc2UoeGlkLCB0Y29uLCAmY2lm
c19maWxlLT5maWQpOworCQkJcmMgPSBzZXJ2ZXItPm9wcy0+Y2xvc2UoeGlkLCB0Y29uLCAmY2lm
c19maWxlLT5maWQpOwogCQlfZnJlZV94aWQoeGlkKTsKKworCQlpZiAocmMgPT0gLUVCVVNZIHx8
IHJjID09IC1FQUdBSU4pIHsKKwkJCS8vIFNlcnZlciBjbG9zZSBmYWlsZWQsIGhlbmNlIG9mZmxv
YWRpbmcgaXQgYXMgYW4gYXN5bmMgb3AKKwkJCXF1ZXVlX3dvcmsoc2VydmVyY2xvc2Vfd3EsICZj
aWZzX2ZpbGUtPnNlcnZlcmNsb3NlKTsKKwkJCXNlcnZlcmNsb3NlX29mZmxvYWRlZCA9IHRydWU7
CisJCX0KIAl9CiAKIAlpZiAob3Bsb2NrX2JyZWFrX2NhbmNlbGxlZCkKQEAgLTY5NSwxMCArNzQx
LDE1IEBAIHZvaWQgX2NpZnNGaWxlSW5mb19wdXQoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2lmc19m
aWxlLAogCiAJY2lmc19kZWxfcGVuZGluZ19vcGVuKCZvcGVuKTsKIAotCWlmIChvZmZsb2FkKQot
CQlxdWV1ZV93b3JrKGZpbGVpbmZvX3B1dF93cSwgJmNpZnNfZmlsZS0+cHV0KTsKLQllbHNlCi0J
CWNpZnNGaWxlSW5mb19wdXRfZmluYWwoY2lmc19maWxlKTsKKwkvLyBpZiBzZXJ2ZXJjbG9zZSBo
YXMgYmVlbiBvZmZsb2FkZWQgdG8gd3EgKG9uIGZhaWx1cmUpLCBpdCB3aWxsCisJLy8gaGFuZGxl
IG9mZmxvYWRpbmcgcHV0IGFzIHdlbGwuIElmIHNlcnZlcmNsb3NlIG5vdCBvZmZsb2FkZWQsCisJ
Ly8gd2UgbmVlZCB0byBoYW5kbGUgb2ZmbG9hZGluZyBwdXQgaGVyZS4KKwlpZiAoIXNlcnZlcmNs
b3NlX29mZmxvYWRlZCkgeworCQlpZiAob2ZmbG9hZCkKKwkJCXF1ZXVlX3dvcmsoZmlsZWluZm9f
cHV0X3dxLCAmY2lmc19maWxlLT5wdXQpOworCQllbHNlCisJCQljaWZzRmlsZUluZm9fcHV0X2Zp
bmFsKGNpZnNfZmlsZSk7CisJfQogfQogCiBpbnQgY2lmc19vcGVuKHN0cnVjdCBpbm9kZSAqaW5v
ZGUsIHN0cnVjdCBmaWxlICpmaWxlKQpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIxb3Bz
LmMgYi9mcy9zbWIvY2xpZW50L3NtYjFvcHMuYwppbmRleCBhOWVhYmE4MDgzYjAuLjIxMmVjNmY2
NmVjNiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIxb3BzLmMKKysrIGIvZnMvc21iL2Ns
aWVudC9zbWIxb3BzLmMKQEAgLTc1MywxMSArNzUzLDExIEBAIGNpZnNfc2V0X2ZpZChzdHJ1Y3Qg
Y2lmc0ZpbGVJbmZvICpjZmlsZSwgc3RydWN0IGNpZnNfZmlkICpmaWQsIF9fdTMyIG9wbG9jaykK
IAljaW5vZGUtPmNhbl9jYWNoZV9icmxja3MgPSBDSUZTX0NBQ0hFX1dSSVRFKGNpbm9kZSk7CiB9
CiAKLXN0YXRpYyB2b2lkCitzdGF0aWMgaW50CiBjaWZzX2Nsb3NlX2ZpbGUoY29uc3QgdW5zaWdu
ZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJc3RydWN0IGNpZnNfZmlkICpm
aWQpCiB7Ci0JQ0lGU1NNQkNsb3NlKHhpZCwgdGNvbiwgZmlkLT5uZXRmaWQpOworCXJldHVybiBD
SUZTU01CQ2xvc2UoeGlkLCB0Y29uLCBmaWQtPm5ldGZpZCk7CiB9CiAKIHN0YXRpYyBpbnQKZGlm
ZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jIGIvZnMvc21iL2NsaWVudC9zbWIyb3Bz
LmMKaW5kZXggMzViZjdlYjMxNWNkLi44N2I2M2Y2YWQyZTIgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9j
bGllbnQvc21iMm9wcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCkBAIC0xNDEyLDE0
ICsxNDEyLDE0IEBAIHNtYjJfc2V0X2ZpZChzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgc3Ry
dWN0IGNpZnNfZmlkICpmaWQsIF9fdTMyIG9wbG9jaykKIAltZW1jcHkoY2ZpbGUtPmZpZC5jcmVh
dGVfZ3VpZCwgZmlkLT5jcmVhdGVfZ3VpZCwgMTYpOwogfQogCi1zdGF0aWMgdm9pZAorc3RhdGlj
IGludAogc21iMl9jbG9zZV9maWxlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZz
X3Rjb24gKnRjb24sCiAJCXN0cnVjdCBjaWZzX2ZpZCAqZmlkKQogewotCVNNQjJfY2xvc2UoeGlk
LCB0Y29uLCBmaWQtPnBlcnNpc3RlbnRfZmlkLCBmaWQtPnZvbGF0aWxlX2ZpZCk7CisJcmV0dXJu
IFNNQjJfY2xvc2UoeGlkLCB0Y29uLCBmaWQtPnBlcnNpc3RlbnRfZmlkLCBmaWQtPnZvbGF0aWxl
X2ZpZCk7CiB9CiAKLXN0YXRpYyB2b2lkCitzdGF0aWMgaW50CiBzbWIyX2Nsb3NlX2dldGF0dHIo
Y29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJICAgc3Ry
dWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUpCiB7CkBAIC0xNDMwLDcgKzE0MzAsNyBAQCBzbWIyX2Ns
b3NlX2dldGF0dHIoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNv
biwKIAlyYyA9IF9fU01CMl9jbG9zZSh4aWQsIHRjb24sIGNmaWxlLT5maWQucGVyc2lzdGVudF9m
aWQsCiAJCSAgIGNmaWxlLT5maWQudm9sYXRpbGVfZmlkLCAmZmlsZV9pbmYpOwogCWlmIChyYykK
LQkJcmV0dXJuOworCQlyZXR1cm4gcmM7CiAKIAlpbm9kZSA9IGRfaW5vZGUoY2ZpbGUtPmRlbnRy
eSk7CiAKQEAgLTE0NTksNiArMTQ1OSw3IEBAIHNtYjJfY2xvc2VfZ2V0YXR0cihjb25zdCB1bnNp
Z25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCiAJLyogRW5kIG9mIGZpbGUg
YW5kIEF0dHJpYnV0ZXMgc2hvdWxkIG5vdCBoYXZlIHRvIGJlIHVwZGF0ZWQgb24gY2xvc2UgKi8K
IAlzcGluX3VubG9jaygmaW5vZGUtPmlfbG9jayk7CisJcmV0dXJuIHJjOwogfQogCiBzdGF0aWMg
aW50CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQv
c21iMnBkdS5jCmluZGV4IDNlYTY4ODU1OGU2Yy4uYzBjNDkzM2FmNWZjIDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L3NtYjJwZHUuYworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAt
MzYyOCw5ICszNjI4LDkgQEAgX19TTUIyX2Nsb3NlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQltZW1jcHkoJnBidWYtPm5ldHdvcmtfb3Blbl9pbmZv
LAogCQkJICAgICAgICZyc3AtPm5ldHdvcmtfb3Blbl9pbmZvLAogCQkJICAgICAgIHNpemVvZihw
YnVmLT5uZXR3b3JrX29wZW5faW5mbykpOworCQlhdG9taWNfZGVjKCZ0Y29uLT5udW1fcmVtb3Rl
X29wZW5zKTsKIAl9CiAKLQlhdG9taWNfZGVjKCZ0Y29uLT5udW1fcmVtb3RlX29wZW5zKTsKIGNs
b3NlX2V4aXQ6CiAJU01CMl9jbG9zZV9mcmVlKCZycXN0KTsKIAlmcmVlX3JzcF9idWYocmVzcF9i
dWZ0eXBlLCByc3ApOwotLSAKMi40MC4xCgo=
--0000000000003ca74306153697c3--

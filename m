Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795364662;
	b=XXNWX2GKH62ozNU3O7B4uw079E+LfyvcqAsDEoJdOdv71Nv7OIVfFPxIrrZsLG7/Ypru
	 nELTPo3CHQ6KLkjnwoOQeSn3lps0R8ZB8+NDCBNSTPTOx84j81ZjtQNRfbcK1IS3bFFbD
	 BfF2pHz/XWwJUKbc2eoAM0On80k1uFNAFhNdKAh3zrmDJ51ZJcxQrIM4EZplBJEeH6CZp
	 IumenfTXstI3QIPGDBiA2sqUvb2pXR66JdrXDY2gqn2CA/Eais5R8cqkw2+q6P34JjRLC
	 O+ma0EGtgWtaZHwz54r4qd4f0x/tZdRowBDlOKDzNI3PZRzobGVeBjc/7+XaZdhspTA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795364662;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=n2HnkONyAz5OvBrfYtDwxSrIOzDjXMJX31dQPz9Vcto=;
	b=W/Gkwp3t30GYyHhxTZRKhiwR6wAdyuKthceKbmvplMwvkJF/iJvzLJA/AXaMor4ZIVkV
	 z6K/Ad969V1+yrpnu+rdWaD4YYRM/BOLSdpCi3yE15W+g5x/Rm8UQioTJetPqi4Z8+EMH
	 nGihTp3dO+VuPEZvuTN4HU+fQMZ1oBdwGE0EPt5bGh9QvxxJz0tDasBYBLN2gajhyvTvS
	 +N3huLuU5EfmCh4JxvXyalsvf7jjfV3BQXT5vSeQRLg3LcLO2+Dns9AHyvdSGkf53Iwml
	 x4uohWZmV8E9215Cqy/D1ssYQPLOZf+zRqxBRNxLo5xe9p+hf95sj0Rim4ujstjbPsg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=afX3YfcW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.177
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6877F606A32C
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 16:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6877F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=afX3YfcW
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5ece6c1d1cbso790386e0c.1
        for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 08:24:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795364660; cv=none;
        d=google.com; s=arc-20260327;
        b=shI1g/nJ4CDVAvgKr1xRJj/eneUCXk4yayrjCVn7P3DxoONMzFHOVnUykrFyN6hXXD
         63c5Hhjh2DVsAbETImSvuhnCQudJQ7Morg2N0048sJ4LJA/3090eWCQTduPSYWK7GOve
         HXUuBCOUOUJzdS6S8pCstG6+UEJ70AU4V2afctIEXwPjysy5/oEhg9caZrhnvTEyjyWY
         U7/CN6Y770u8aLSycbLPE98mj42PiZ2UXZowz69efj9Lx2fknjs8ex/4jGefnadi2wIs
         y0IrSCDn6DUOnan+AiOoV2hKUh7BKlmuty23aEl6+5E0YlAjQCvPm+0PiPwaZLu19cYU
         gpVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n2HnkONyAz5OvBrfYtDwxSrIOzDjXMJX31dQPz9Vcto=;
        fh=srC0au1bnbi74eCcvwjYRxLloG/yyMej8FUYOe5Kv+M=;
        b=JuJZX1Ua1EAC+E5v5J50eIIQRNxZoGAwChdDlvWRHGMFcNy9TWelGOhkyJlCuuD5CT
         ZUIN1ZHlstFmzGPMEVoTZ7Bph9iN11nF3otiybjCa5OV0F9ATtqOsxh5h/f1PVg7/ACq
         lRTtPVlkLCNH8wUyFgx+Ym0V9RPwFYUkRusTz/HcBX+jlgmGjM3jjOtN/sftL8xM0VHU
         Rzhgr/hsL8BGV4zbrXtM2tsUHSwmhn2yULQMLtvcE2QE132GVn80vikLVLkz04B6ieD6
         3K5ykTzOidM5uLhwNq3bgSSgBlkueO1akHiDmkFrrJDzCO4R2gDGbQtxJHcZ6UmexX58
         ah9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795364660; x=1795969460; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n2HnkONyAz5OvBrfYtDwxSrIOzDjXMJX31dQPz9Vcto=;
        b=afX3YfcW9NAzIVyC17QRC5kSiBGMdB/4Q4CF6WclhBWSrQ7USro/hLjvmTBwqJ8X9A
         wBnkU23S0DP0LEmfDyXe/p2K8oc+v/dL7oH63JVMm2TD5mGHkyuMQ+9CBG4HSsvQcCD6
         t9cd+KtsJD3zpbmFE+MLhXIFqkHOGYVCuKKNBjOl6mhG8BBdY0r7UyU9elfO+a6zskxW
         IAUrJliC/Nxh05CJ2iettyCY0+urMoxTIThz8fpDGCcc/RpVyYYuy3tj6prE4lcyhrtC
         fXm9VNtpGBxIxxTerTC7onuMSQgqid7onNV6aDvNSocDYIZIwlNfA7L1UhZpW8U6Bt4m
         nQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795364660; x=1795969460;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n2HnkONyAz5OvBrfYtDwxSrIOzDjXMJX31dQPz9Vcto=;
        b=t5Viw7f0WWjoEYZZT2yNbt6i051cnXOmvR4NPelTWYa4BIH1pUePFUmi0mjm8GLGkl
         2ZUchePep8cYVPmDqzvSycu9PVs9QLyzadFIOkTXTPkx2kUrrPYlAnwY2J+af7hOOAGd
         2/R3nvPLmrvdvpNlyEtM5rJ/u+OC8lkBbW8IM6Ne9Wgthbp13mEDSI/Kra2QI3xgfqBT
         VKtgupxIvWM4ksuXzGvPnqDOhb4/DRjGLhlsdwdN7ctJ2hmVunz2IzQ4DyeEUOG4HmNR
         ibegS07adNpusPutsAVHV88dBrQs2m0qe5lJ/bjYkhZ702rOB+K0B4F9Zs/iXrjSmNJ4
         IHnw==
X-Forwarded-Encrypted: i=1; AL+hErEujzwvnjOVcZQJA8YxxSuSRMuo8A73mjlDI5Hjz3QETMWdj/PVOJ8XxqD/T2ShcR9WzQws3FqMUQTP@vger.kernel.org
X-Gm-Message-State: APuU4Z/8vAMIn4BBF2k04qRUEakndBRv08ZGqtgndzxBuJnbV0dhs/sB
	hd1ry+8+pb8zxGt+vJXb+G+Est/WwoAfs1dN8dPIraEFmAJRaehojhN7CIi/+hTDQixi7yE/CQk
	8u7CfbxIcnHWWtC24Br6+ZG88J4HHjlA=
X-Gm-Gg: AZFdTZd9NhZWREOZMyrts9D81wZ7ZpT3aYWjpJzf41YMlQ1yAzKaIbJOyTJsF2m66lu
	lvJnXPri+6kPKD86rst9khn1sRMRyPRuVp5Hm1PRrXwCAYRQ4OtwqxmQ1ABWhk578zFAzrr7yex
	aqbgOyJoXs/yrRebJV5Q8X8ZxJbGHVaJWw0jXczeXnOutvIIjwIlSpt+ylyvPG0jS10xg/Tve4d
	1db5qjtX5O1vLTGCLzO3WEjqa64luyxM31odnIRdz2LE2K5oMfOGwBY7Bl5FwfpT8+eFB+FIO78
	5Lf4bvbhTBqxkpCfUSIRheHf1GUCGHeZ+iV+gHDH73HB+V+4BL6Yx+COE8+JuSN231FLTWQfW1E
	geCWXjyS28CokRDkxUEaBK0KKue0Eh5bCWdX1f+SDnpTM7GwhPW/xNFscw1eKeTYL
X-Received: by 2002:a05:6122:29cd:b0:5ec:d751:a18e with SMTP id
 71dfb90a1353d-5ee8af5d5c6mr4139590e0c.19.1795364660204; Sun, 22 Nov 2026
 08:24:20 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122045841.99012-1-fredric.cover.lkernel@gmail.com> <202611221905.fQpuvetd-lkp@intel.com>
In-Reply-To: <202611221905.fQpuvetd-lkp@intel.com>
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
Date: Sun, 22 Nov 2026 08:24:49 -0800
X-Gm-Features: Aa3M54pLCK7XgGyFOtsNWn7B-0IlzQDmNjwu1YO12B2eu424c3ONrYetGFn3o_M
Message-ID: <CAAk_H6H8SZaa6xsKmyViYMwCe+-Z2xaftVjT0zrW_B-PJjvumw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: convert DFS target node name from cache
 charset on mount
To: kernel test robot <lkp@intel.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	oe-kbuild-all@lists.linux.dev, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Paulo and list,
Please ignore these build errors. They are due to the dependency on my othe=
r
patch. If you would like, I can put them both in a series to avoid
errors like this.

Thanks,
Fredric

On Sun, Nov 22, 2026 at 3:51=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Fredric,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on manguebit/cifs-next]
> [also build test ERROR on manguebit/cifs-fixes linus/master v7.4-rc3 next=
-20261120]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Fredric-Cover/smb-=
client-convert-DFS-target-node-name-from-cache-charset-on-mount/20261122-04=
5840
> base:   https://git.manguebit.org/linux.git cifs-next
> patch link:    https://lore.kernel.org/r/20261122045841.99012-1-fredric.c=
over.lkernel%40gmail.com
> patch subject: [PATCH] smb: client: convert DFS target node name from cac=
he charset on mount
> config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261122=
/202611221905.fQpuvetd-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20261122/202611221905.fQpuvetd-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611221905.fQpuvetd-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    fs/smb/client/dfs.c: In function 'dfs_parse_target_referral':
> >> fs/smb/client/dfs.c:44:21: error: implicit declaration of function 'df=
s_cache_local_path'; did you mean 'dfs_cache_canonical_path'? [-Wimplicit-f=
unction-declaration]
>       44 |         node_name =3D dfs_cache_local_path(ref->node_name, ctx=
->local_nls);
>          |                     ^~~~~~~~~~~~~~~~~~~~
>          |                     dfs_cache_canonical_path
> >> fs/smb/client/dfs.c:44:19: error: assignment to 'char *' from 'int' ma=
kes pointer from integer without a cast [-Wint-conversion]
>       44 |         node_name =3D dfs_cache_local_path(ref->node_name, ctx=
->local_nls);
>          |                   ^
>
>
> vim +44 fs/smb/client/dfs.c
>
>     13
>     14  /**
>     15   * dfs_parse_target_referral - set fs context for dfs target refe=
rral
>     16   *
>     17   * @full_path: full path in UNC format.
>     18   * @ref: dfs referral pointer.
>     19   * @ctx: smb3 fs context pointer.
>     20   *
>     21   * Return zero if dfs referral was parsed correctly, otherwise no=
n-zero.
>     22   */
>     23  int dfs_parse_target_referral(const char *full_path, const struct=
 dfs_info3_param *ref,
>     24                                struct smb3_fs_context *ctx)
>     25  {
>     26          int rc;
>     27          const char *prepath =3D NULL;
>     28          char *node_name =3D NULL;
>     29          char *path;
>     30
>     31          if (!full_path || !*full_path || !ref || !ctx)
>     32                  return -EINVAL;
>     33
>     34          if (WARN_ON_ONCE(!ref->node_name || ref->path_consumed < =
0))
>     35                  return -EINVAL;
>     36
>     37          if ((size_t)ref->path_consumed < strlen(full_path)) {
>     38                  prepath =3D full_path + ref->path_consumed;
>     39                  /* skip initial delimiter */
>     40                  if (*prepath =3D=3D '/' || *prepath =3D=3D '\\')
>     41                          prepath++;
>     42          }
>     43
>   > 44          node_name =3D dfs_cache_local_path(ref->node_name, ctx->l=
ocal_nls);
>     45          if (IS_ERR(node_name))
>     46                  return PTR_ERR(node_name);
>     47
>     48          path =3D cifs_build_devname(node_name, prepath);
>     49          kfree(node_name);
>     50          if (IS_ERR(path))
>     51                  return PTR_ERR(path);
>     52
>     53          rc =3D smb3_parse_devname(path, ctx);
>     54          if (rc)
>     55                  goto out;
>     56
>     57          rc =3D dns_resolve_unc(DFS_DOM(ctx), path,
>     58                               (struct sockaddr *)&ctx->dstaddr);
>     59  out:
>     60          kfree(path);
>     61          return rc;
>     62  }
>     63
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879CC43165;
	Thu, 22 Aug 2024 20:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724360377; cv=none; b=nxPwK3v6bI4F7Z0DBROIGMWKPCEGj9DDIbAdChriP3kP28mm6dPI+PM3O5Q2Mm3MhiMJ/lRu2WuR8OHBWf907OBTUU2z1gTppWHfjiDxyjBac5EhgG/lwpYjrKGCh1cxeTu+IsjrtESCSDMzdLM7oxUpmP/UFErGBtF5udiRKog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724360377; c=relaxed/simple;
	bh=/TMQOgJzgOwAEuf4NnsR5mrR5yKGAmwhM21BkIyu22g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T4sJVj67zbVvz0LASffMIUzb69I9Fszg178AVXa3gA1N2vIW6MFhzGiokucF0MuTVODYn7NvyzDD1xYWrHBilZb7AcRsYrDKg1VqbeohKsiCCUbrXk/FMs0QOROBLAVOpwPRBGxsS28gUy1pFe+5BGzZdFhq8+ctB7Z6ddxeohQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzsMvEOC; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzsMvEOC"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-533462b9428so2231823e87.3;
        Thu, 22 Aug 2024 13:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724360374; x=1724965174; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGAp8foyvHTtTWFWYgIOEcqlciGnJx25SOMfcF7kFy8=;
        b=YzsMvEOCD+1ESBzh6bHWqt5YZBhTOt5lb1y9eTh/G5Fg331YddPyL04mPQPSOU2y+7
         2Q+awmQzKNtbcLd2tQPupKE7M94jzjSK/78q5pk/Xn0eI9yQgvkx104NzKJgsbceVkRS
         A+PqVcU0sgpg8fzKNEc+6S8ChOO/x79qM/ggRsua8iySEt6wBpg3p1U8NlDE57yisc2Z
         uwY66o46PpCzVlFKzLbItCIeuwvz2fjNLBy92qG0Qntu44aAS0qWeDELntL/S/n9y7Zl
         xXQo9H33N9u4VdKWqtz22ceuDUq6+f/moV7qn3W/GrufL6VeKc/tjNz59LmZqEUaEMyS
         lQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724360374; x=1724965174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BGAp8foyvHTtTWFWYgIOEcqlciGnJx25SOMfcF7kFy8=;
        b=uFX5DUc7NXFTf4iDbAIV7N5r4rk4iqyzaNFHUtqPYihmHVbsezo8CGwsBF5ubu1RnI
         XyCBfTVWb/IwhZoFv4cnMSVmv0n00/wNBD9ixIdl0awiZBwexxQrK2MMSduc2ePPhn/f
         6GbyH3z3BO4f0NQ3QJLv/uQuQuCimP01Vco0I1k/9ed45cz1xmR7MUqcKqL6aAAnmJ7t
         f4x9irtW0p07mSTQgquMoRigoxaqPIozll48TAJwC1DQ/YnAJWpbFlJcPeMJ8A00AcNd
         CGogco4/lH63XyuXizevSIkIgYlCr1d6jVuPn3FTiowNGZHLjzweopDlgSNeDpGphq5u
         0kvA==
X-Forwarded-Encrypted: i=1; AJvYcCVDRwttzjhrQQAajj7EhkCIGYaZ/FA/tQw5mO2FXgfdNkOCdEUmikvDxL4SYboI6MnFVwhk1trMNf1G@vger.kernel.org, AJvYcCVL/xFflY7Xu7XQ2upwfqXfJ0TB+lWg3mbJd+oDYlswmaAk392q/+31PvGunlU7fbuvHOoU7VIgTKA0MpA7@vger.kernel.org
X-Gm-Message-State: AOJu0YxcsJS4hdfA1wyt116bMeIBWOD/Azs2YVUwCEzdaON5PbBf0pAK
	o1IktDk/15vrMFuiOOBg6ZipUjSthkSAXQRmkbYOJVxEq1uOpbymENeD1+x/6uVfH5IiRVxXKWG
	1cOISSFlbymZRU7SdIh++w/ytQDY=
X-Google-Smtp-Source: AGHT+IEq4CPGNLjFQcDT8p6xFKWFpEAtr57tnzK713kUp1qfE7S8uZTwzxpxWWuPS5aHem7wyUFlczds9WWsGZ1GXG0=
X-Received: by 2002:a05:6512:2342:b0:533:324a:9df6 with SMTP id
 2adb3069b0e04-53438850ff3mr177792e87.29.1724360373196; Thu, 22 Aug 2024
 13:59:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 22 Aug 2024 15:59:22 -0500
Message-ID: <CAH2r5mtfgfdr64BjgCnuZ+P+9eXr1q3RZnS7HmszC15y5UZs+A@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] smb: fix some bugs, move duplicate definitions
 to common header file, and some small cleanups
To: chenxiaosong@chenxiaosong.com
Cc: linkinjeon@kernel.org, senozhatsky@chromium.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged patches 6, 7, 8, 9, 10, 11, 12 (the ones affecting the client
e.g.) into cifs-2.6.git for-next-next branch (for 6.12-rc) and added
Namjae's Reviewed-by for those that didn't already have it in the
commit description.

dc470593e459 (HEAD -> for-next-next) smb: add comment to STATUS_MCA_OCCURED
cda1ece3de80 smb: move SMB2 Status code to common header file
093aa95b1f89 smb: move some duplicate definitions to common/smbacl.h
ef90cd1c8858 smb/client: rename cifs_ace to smb_ace
0628feffddec smb/client: rename cifs_acl to smb_acl
d58459043a94 smb/client: rename cifs_sid to smb_sid
d8fa64617131 smb/client: rename cifs_ntsd to smb_ntsd
5e51224d2afb (origin/for-next, for-next) smb/client: fix typo:
GlobalMid_Sem -> GlobalMid_Lock

On Thu, Aug 22, 2024 at 3:25=E2=80=AFAM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Fix some bugs in smb2_open() of smb server.
>
> In order to maintain the code more easily, move some duplicate
> definitions to common header file.
>
> Additionally, add some small cleanups to the patchset.
>
> v1->v2:
>   - update patch #2 according to Namjae's suggestions.
>   - add patch #6~9 to rename 'cifs_ntsd' 'cifs_sid' 'cifs_acl' 'cifs_ace'=
 according to Namjae's suggestions.
>   - add patch #12 to explained why the typo 'STATUS_MCA_OCCURED' was not =
corrected.
>
> v1: https://lore.kernel.org/all/20240820143319.274033-1-chenxiaosong@chen=
xiaosong.com/
>
> ChenXiaoSong (12):
>   smb/server: fix return value of smb2_open()
>   smb/server: fix potential null-ptr-deref of lease_ctx_info in
>     smb2_open()
>   smb/server: remove useless assignment of 'file_present' in smb2_open()
>   smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock
>   smb/server: update misguided comment of smb2_allocate_rsp_buf()
>   smb/client: rename cifs_ntsd to smb_ntsd
>   smb/client: rename cifs_sid to smb_sid
>   smb/client: rename cifs_acl to smb_acl
>   smb/client: rename cifs_ace to smb_ace
>   smb: move some duplicate definitions to common/smbacl.h
>   smb: move SMB2 Status code to common header file
>   smb: add comment to STATUS_MCA_OCCURED
>
>  fs/smb/client/cifsacl.c                |  224 +--
>  fs/smb/client/cifsacl.h                |   99 +-
>  fs/smb/client/cifsfs.c                 |    6 +-
>  fs/smb/client/cifsglob.h               |   22 +-
>  fs/smb/client/cifsproto.h              |   18 +-
>  fs/smb/client/cifssmb.c                |    6 +-
>  fs/smb/client/smb2file.c               |    2 +-
>  fs/smb/client/smb2inode.c              |    6 +-
>  fs/smb/client/smb2maperror.c           |    2 +-
>  fs/smb/client/smb2misc.c               |    2 +-
>  fs/smb/client/smb2ops.c                |   16 +-
>  fs/smb/client/smb2pdu.c                |   14 +-
>  fs/smb/client/smb2pdu.h                |    8 +-
>  fs/smb/client/smb2proto.h              |    2 +-
>  fs/smb/client/smb2transport.c          |    2 +-
>  fs/smb/client/xattr.c                  |    4 +-
>  fs/smb/{client =3D> common}/smb2status.h |    6 +
>  fs/smb/common/smbacl.h                 |  121 ++
>  fs/smb/server/oplock.c                 |    4 +-
>  fs/smb/server/server.c                 |    2 +-
>  fs/smb/server/smb2misc.c               |    2 +-
>  fs/smb/server/smb2pdu.c                |   17 +-
>  fs/smb/server/smb_common.c             |    2 +-
>  fs/smb/server/smbacl.h                 |  111 +-
>  fs/smb/server/smbstatus.h              | 1822 ------------------------
>  fs/smb/server/transport_rdma.c         |    2 +-
>  26 files changed, 314 insertions(+), 2208 deletions(-)
>  rename fs/smb/{client =3D> common}/smb2status.h (99%)
>  create mode 100644 fs/smb/common/smbacl.h
>  delete mode 100644 fs/smb/server/smbstatus.h
>
> --
> 2.34.1
>
>


--=20
Thanks,

Steve

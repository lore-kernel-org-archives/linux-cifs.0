Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D381CD1F;
	Tue, 10 Sep 2024 06:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725950229; cv=none; b=qIgobF8o/y/FtrBgwuE/jDT22PdN/rJ0xNOzgpKzhUAsswBM34URTGUOXDEczd2WdYjxNi6zkVQkYniFTFhdwCG/BGzgZyDbiaaACLnTOsW2rNwOQUtsJzqaz1n+L43zuLZunwy64DgaG/hq/qncqTomNP+XvYl8qLQgsCdKVrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725950229; c=relaxed/simple;
	bh=kINXuvi1wypT2o8VzSOaOSKacPP9/oktyF0CBpZUseQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E3ZfL6v424UMyu+jIUFUO03LgT/D84mhsVqJ7boMqBCFzL+46agPjjf6jOqF6QkASCezw+MZRBf6jvhXWLvvPp+R6R3OLyh7GGLIA2EEdXS8d/howLN5j9tjY8uEp5fxu6rVo5fkwDbNincHf8wr2w8xUVwgfzGzSm1pVusA3xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1rezO7k; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1rezO7k"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5366fd6fdf1so305251e87.0;
        Mon, 09 Sep 2024 23:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725950225; x=1726555025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2nLBV36l1E+nJwy+AajRSSrY5cr4kLPDW591ReZ6/c=;
        b=K1rezO7k74ZWQmwfhiQJvvP+k4vtn8CCsIf4FB0qCGErkypJYs2o+FI0NnKsiRgLJe
         J3iVY5AI088udLGjyujdDOJsmxiOjxEO3csakU+W8VhSx7tZqJdeBgfWtYHSCcQ+JNwj
         uUe3SJRdOcXwwOeroaG112ol/1l/GLqbLK305C3NXW5JVRiP/4bScpJ4fxCcV1nVMLs3
         u9WLMGX4LM66s89MgVfBlbF4NDEhrVniaev6QIOyE1NHPs/zO2newM/26Jka2tmfUD59
         dO2QnfKbvFukfytThQoePN3+9d2Ddef0EPFYBuZW03rkOwXxdt06f07Jb5qzldoAWyjy
         i/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725950225; x=1726555025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D2nLBV36l1E+nJwy+AajRSSrY5cr4kLPDW591ReZ6/c=;
        b=SY4xdNDJpHg4tqXPDJGanWQmm5dhdPZcFqtvaQRli1qAGrLFBPbzWFr72w9PNssMPX
         zrHDaG0cDxQlrWFFSyz6yiQbWa/hx/Mo5NOW5F5wjDvadnLuxP2XxnIOZvfpIzghO8Uv
         sjnHYEEF7BdXPmBoZ1/3hfQQwJlUJlysRyQkMenosjkyBaI2vRTMwnoh7XrVFoasl14W
         KevO4y+qNYEd9THthqMJm1n6hqgwtIgUctmy9Y/vfEQG8JSniLLdySdFcTD0S6TyHKg2
         d8kR188hJrv3RVYZHTJ97UA5Ys+w29m476J7FavS+sJ3pWH+olD4yAQQFgwBQFfE2wyo
         x8Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVtihNyecrlDcf0uKGJx8yOgR7mT1/PANrvv9e66uZGhYxJyHTo6PxgoJZMhKc7FgzlYCybbvicFSNl@vger.kernel.org, AJvYcCX42UKoX0UlDW8b3x5tCHnxI3sy0EnHNJxhivJaqtZKAJqnfYOMWqwVyRnYw1wRJV4si2ZA3AUDRxEj2i0e@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8MLGihUv2Cl3OdHyiADdxa0Sxc7nlqqrgmMStgFc7cspovt1K
	87jUCycQTUjyojga3W10Sk08tBerofvAljs3TGn00d8L2JB1tmDGTesbOmkfhm+It8MwRTycQgZ
	0YlPaBOtlXLLPc1P7oRpX6pTOA6M=
X-Google-Smtp-Source: AGHT+IFPZAx9kPYY95dxfLshFcr9d9jwdnZZtlIhHuaooIrQJWH1Yex4S0wumOZrsLKbcz0QWDgtTbo8e48TS3d8y00=
X-Received: by 2002:a05:6512:6cf:b0:52c:850b:cfc6 with SMTP id
 2adb3069b0e04-536587f5c84mr9047301e87.38.1725950225214; Mon, 09 Sep 2024
 23:37:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 10 Sep 2024 01:36:53 -0500
Message-ID: <CAH2r5muWoAobVc53LLkifZL_hE7bfxU6ZgPH2CAfAWoe-9jJrA@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] smb: fix some bugs, move duplicate definitions
 to common header file, and some small cleanups
To: chenxiaosong@chenxiaosong.com
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	bharathsm@microsoft.com, chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, 
	huhai@kylinos.cn, liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following patches from the series have been added to cifs-2.6.git
for-next (the other patches in the series were either for fs/smb/server
rather than the client, or have already been merged).  Let me know
if any objections or problems seen.

d837dec2296c smb: add comment to STATUS_MCA_OCCURED
15dd39d9da2b smb: move SMB2 Status code to common header file
5ce486228d95 smb: move some duplicate definitions to common/smbacl.h
1e4b28faf320 smb/client: rename cifs_ace to smb_ace
664987e5e550 smb/client: rename cifs_acl to smb_acl
624d2ce94277 smb/client: rename cifs_sid to smb_sid
8335848d54c1 smb/client: rename cifs_ntsd to smb_ntsd

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

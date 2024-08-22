Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172B91C93C9;
	Thu, 22 Aug 2024 11:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327831; cv=none; b=Af/KR+Des7mCC70a2IX/Cq/vXaZHLZddFItawj6/xMd2lW3dWCnG3zaKwDcza3pUw2QCC83zDcAwQNEGGISYDr+vZU0bBHK85WNTAI6I+3Igf8IKlqMQbNaTF4iTH3NKM6l1w/Ibu107ELYf/wYFYVM51Fr7cjkQz1Rrvxxis4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327831; c=relaxed/simple;
	bh=eIvJwYWNWLdxSUlyhPRI8/XCAOzbPZ1AflvgFAZEnzY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oOnaQL5WHe4PVXmJ3cyWRzDrv6Djj8nqB9mxpHg7p2qf0TdfsAfXO9BhVIhGVTsapp7nsHkhIsBj8rQMQoF9JXzas5hTAbcl5M15z3+mdu6MVKZSLQRdfg1rLhKSBQINBvOEx5tMMYBmGCmlIf4fAewUMhT0Flsy8zwJPqieBqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxaxJ5AR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxaxJ5AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB43C4AF10;
	Thu, 22 Aug 2024 11:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327830;
	bh=eIvJwYWNWLdxSUlyhPRI8/XCAOzbPZ1AflvgFAZEnzY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hxaxJ5ARQhBkkKkvxpsMsFMKRyV0Th6TAIDgb+VpZ2zqz2Tmtu5lAKPDOyoPerhbW
	 YWf2pU+SUOES1tIa/nbXWAMPbHvc9Y2OnHsfbSue2jecPyWE7yp3mJX+FdOLdGuUj5
	 4Msd0uwxA8x+Qv/Y9kfT/ZYjeb5VQYMtFkO05F5MsPVpYBR9dE7h5W2yrzL5VpZEyt
	 BPxQztXFGAa2xvj4itAsM1kHZFItCnkf/iO8JwPRiZ0KwuoSCGv+ey118stzNz+3Nz
	 0P/MDvLE2Qcf4iSUP+dYBVDvMZhGePD7gLDVKgPDCehA19YPmws/NQKtnXkAkFM3B+
	 jpvRgw1tYdPrQ==
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2702a00aad4so399853fac.1;
        Thu, 22 Aug 2024 04:57:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUyP0D5XvYGIzD94BpcqEHaw6nz8nCtEhD6TD3wl40mflhf5wkJel5jkbRgmVWndn6jgVinfvbChNNv@vger.kernel.org, AJvYcCVd0ESqoiT2pkSQHhaaXnVVDJQe/nZTOyCitb5BTAdYyEafJHZJWyBRmF70rpPcv7+TngrHIhDPplGSVjtN@vger.kernel.org
X-Gm-Message-State: AOJu0YwMCj0WemlyixNAJPl/wO1YI+d8KmQiwW0gqFNg/qGMKtRz8Rsz
	nnFOe61m9Y5U6UrcK9rM+KcF4waViWkif7icsrp0IcpCOGpMPZkshAMPNusxfKNI1b/eGSicuNn
	XRU83UCPiOyODDyMfnkwnEtL1O5M=
X-Google-Smtp-Source: AGHT+IGyf3NGdl2vPrw3MYVNPwFiGVpI83bsESwsu7qk95GyHE6/BKjmHu/B4y6C4/OQzAjYvsDApd38bvTF4K3+lWM=
X-Received: by 2002:a05:6870:2116:b0:261:1342:26b1 with SMTP id
 586e51a60fabf-2738be908e3mr5173419fac.48.1724327829985; Thu, 22 Aug 2024
 04:57:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-7-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-7-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:56:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-4UwpcqfA0=7bfkDu+0yHcXsPH3or=BNWnfsVDxfPYaA@mail.gmail.com>
Message-ID: <CAKYAXd-4UwpcqfA0=7bfkDu+0yHcXsPH3or=BNWnfsVDxfPYaA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] smb/client: rename cifs_ntsd to smb_ntsd
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 5:23=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Preparation for moving acl definitions to new common header file.
>
> Use the following shell command to rename:
>
>   find fs/smb/client -type f -exec sed -i \
>     's/struct cifs_ntsd/struct smb_ntsd/g' {} +
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Looks good to me.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.

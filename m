Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EA32D2385
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 00:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104279; cv=none; b=A1DF9udY4ktP+VEorxFBhQ9ForsYF9OwxBmP9+28D0k5BEtfN90Ep3qS/5sJ5vZ4r+faj8sWsIbZ/yQgkTaQ8+HG3B+K16KmsoGmoJoyPUStWz8eRo3G0dGGbAjTU2C+pQULH3YmcjQwbM9F2CeDBjhuTd3tQKkg/RkIaccC5qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104279; c=relaxed/simple;
	bh=cmzBVHCGdgl8gqloT/2BzPLkE1zhltI/TEHDx7p3/GI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RfUh5ttIEdr8Ua0yFSMeCSNQWSlq+05r5K+QTNPm3l5OPZjC5qwshZ/SL1/cVP2uczZM6PWt9066kkh5LTa1xIjO+UEWHMeWP+yeGFDNNX2BTXJa/O4NnayBruruQpwtmd+xHn7FipXaMjn5XzgZ4cGJIj8+jBBrWy2V3BnbunM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRkp305A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRkp305A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82BBC2BCB3
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 00:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104278;
	bh=cmzBVHCGdgl8gqloT/2BzPLkE1zhltI/TEHDx7p3/GI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TRkp305AylIhn+zmMESDXuEUUwEhwGsTS+c/VQyUODD89a39NbKCrPMeOXJ5O0jcE
	 SqxFVf5WSEDJrPD42aMOBJeQ+NuPXTNneRqMZH1lkoDEZYIuO3OLbYt4qsGwUeBv2D
	 Vh8xaz4LYQlY5hKnxgNXd5fRb0ky8dLc3vsFW28pp9YlAgRm7P6hdNG/vSAk8Bt9Nl
	 RYf4ig37YspPTdWl6Z3cHhliYOzqrLaAqedQnV0VQG5TfRRS0UEZv1WhS30VbddMDA
	 SUpLVN5RwDGWi83+jPRGNGEYR01+bOoiYv3E9d4StFqRve4rGs3OStb7X1vIxwllfk
	 Vg9T/F9vjyt9A==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b95c0fc928bso456793866b.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 17:57:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVslsQMWbMuAENuCnoo3CIhpUZqWdYVFvZP7AivsCP/jnKVBxP8zS2XEhtyLZCk2KvPfzs5Q3+6C2at@vger.kernel.org
X-Gm-Message-State: AOJu0YzxddwObNL+EQeCvdZjvFLt9iBukINrupwBJ7Jo00aJngNX1erg
	AgI2QprQ3YYUnLd3H9nKLpELHD74/d9SV/w7v1EucowFFLHEcTCQwiNMThRYNnzK5u3eC4mFi+M
	ieifyMzA8sm4DdbxenIKUjZZZT88CctY=
X-Received: by 2002:a17:907:1ca7:b0:b97:5dc:3bdc with SMTP id
 a640c23a62f3a-b9705dc568cmr199351166b.30.1773104277294; Mon, 09 Mar 2026
 17:57:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303151317.136332-1-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-1-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Mar 2026 09:57:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Q6BT3KZvVdPJ4Ce49Aa_8x5fUKp=Vo-zZwheW5MAOHA@mail.gmail.com>
X-Gm-Features: AaiRm52RUW1_hBCTah8XKAQ5uOnERuJG1kbpYxRhETUxPso_1uJUnK4Iv2iQgPs
Message-ID: <CAKYAXd9Q6BT3KZvVdPJ4Ce49Aa_8x5fUKp=Vo-zZwheW5MAOHA@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] smb: fix some bugs, move duplicate definitions
 into common header file, part 2
To: zhang.guodong@linux.dev
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 4, 2026 at 12:14=E2=80=AFAM <zhang.guodong@linux.dev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> v4->v5:
>   - Add patch #01 #02 #03
>   - Patch #06: keep vol_serial_number as u32 in smb_mnt_fs_info and cifs_=
tcon
>   - Patch #07:
>     - Add new flexible array member `sids_and_name[]` to file_posix_info
>     - smb311_posix_qinfo -> file_posix_info
>
> v4: https://lore.kernel.org/linux-cifs/20260225041100.707468-1-zhang.guod=
ong@linux.dev/
>
> v1: https://lore.kernel.org/all/20251209011020.3270989-1-chenxiaosong.che=
nxiaosong@linux.dev/
> v2: https://lore.kernel.org/linux-cifs/20251211143228.172470-1-chenxiaoso=
ng.chenxiaosong@linux.dev/
>
> The following patches from v1 and v2 have already been merged into mainli=
ne:
>   - 94d5b8dbc5d9 smb: move some SMB1 definitions into common/smb1pdu.h
>   - 2b6abb893e71 smb: move File Attributes definitions into common/fscc.h
>   - c97503321ed3 smb: update struct duplicate_extents_to_file_ex
>   - 2e0d224d8988 smb/server: add comment to FileSystemName of FileFsAttri=
buteInformation
>   - ab0347e67dac smb/client: remove DeviceType Flags and Device Character=
istics definitions
>   - 08c2a7d2bae9 smb: move file_notify_information to common/fscc.h
>   - 6539e18517b6 smb: move SMB2 Notify Action Flags into common/smb2pdu.h
>   - 9ec7629b430a smb: move notify completion filter flags into common/smb=
2pdu.h
>   - bcdd6cfaf2ec smb: add documentation references for smb2 change notify=
 definitions
>
> The following patches from v4 have already been merged into cifs-2.6.git =
for-next:
>   - smb: update some doc references
>
> This is a continuous effort to move duplicated definitions in both client
> and server into common header files, which makes the code easier to maint=
ain.
>
> The previous work is here:
>   - part 1: https://lore.kernel.org/linux-cifs/20251117112838.473051-1-ch=
enxiaosong.chenxiaosong@linux.dev/
>
> ZhangGuoDong (7):
>   smb/client: fix buffer size for smb311_posix_qinfo in
>     smb2_compound_op()
>   smb/client: fix buffer size for smb311_posix_qinfo in
>     SMB311_posix_query_info()
>   smb/client: remove unused SMB311_posix_query_info()
>   smb: move some definitions from common/smb2pdu.h into common/fscc.h
>   smb: move file_basic_info into common/fscc.h
>   smb: move filesystem_vol_info into common/fscc.h
>   smb: introduce struct file_posix_info
Applied 0004~0006 patches to #ksmbd-for-next-next.
Thanks!

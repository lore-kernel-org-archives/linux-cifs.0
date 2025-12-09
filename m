Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071322FB96A
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 23:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765323679; cv=none; b=pFULcziVTuqDz7/4oaN/bVnz9hVqdl8Hh0iLVbfQncIBCbh56YCsbLpCZCzQEK2xU6969sKzYM44wut/MKleeFuJkxzaVZqyekSa2RTVJ2lhsfvaCXTm2iiBDAuDyPRgsq4udLafdVRNdoc+AxgQm1E0uMvtFypNaKarGM/O+Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765323679; c=relaxed/simple;
	bh=E9xQLrondd4HWPHPAKzjV5hcg7qt89PPS1zscwvzS+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lbI2q0qZn1Y9sacVCh+lN65fELeozmuJi1UxTEBk4nY8rSR8bbATY7eF8BsLnZDBmnNHKcRmS25K2vNAZz7lzuaTmUf4fco/uqO1Xh6q7rlUtTkQ9qYZ5L+gmtGyPcsNRSqZcim4MOJMPC3qyTwgGdVgcD+scAnfPhcsrDpl1TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q0x11RHg; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0x11RHg"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-880576ebe38so68520136d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 09 Dec 2025 15:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765323677; x=1765928477; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eol7a1otwHvjyBvBv9DBEFIYPmlvmYWzkxkdqs2RWmE=;
        b=Q0x11RHg97q+x+uByOHeDFP/lin0VrSKCHO0KrdpDea8yjVuc7aJwhEb1OCe6tesPx
         zI2Qvngu/iMR8KMZXsB7sK1KCUtpCwpRMG7h767la3/iY5ijaMX9eF8+9Zsco8l4mIEb
         SG80eNfwKguSq6f9iIhl24i+Q5KUWXf4606AmPd2hfMIM8iJB8DqFkRINirP3UOesOTa
         CAaSGv+9LV5L4YL7ZpbTqw902p1rda45/kwc15aycy8fAhWr2vVdUXbvBn+kZ7JLIF/d
         lrAzjWWtE0s1lS7WtxI0GvpLQmfUzA2KfGGZRG+d6qt8RXe01RZtx7m00e2H0FPJjSjN
         dpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765323677; x=1765928477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eol7a1otwHvjyBvBv9DBEFIYPmlvmYWzkxkdqs2RWmE=;
        b=ZYOGPW2fs9FUW831Cs6AmAhaNcGIVVGXOmkWhAlbNcdp+q/rz9bAQHc3Dnhg7m1FWQ
         ctl/1UxRxZ/yF+DBevGTz9SX+meISmpJMtQ9j2rogLw9iCs3Mip0oB/wvBrplSCjGt+W
         2nA89gO9FMop12TBbczYTp32E0AKz8/4HahBKWADVsnkbiuY7pSFVcT/o9VHkJT7uPoR
         TO7LN8Bzejnkj7gGY1r8Xsd4HElnYNta1Hzskb5G9rWd2tlvemodLwh2Gr8EGr6rGvL8
         iRytbwRGjnuKVD4PEbgztSpCrN3jrj9yTBCDQbQDUU3UhKpI0O+/yeRGrqmuZApwsfjj
         h0JQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeYUDUv7YSD0D4fEluVjhOcJinZZPQuAm5+L9/Ok/vPWmFEzh5TohrUWo1igCpvaf/VbXWk2OoKg+G@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2CktmiEqjCMdL1iHR23IfM/2/ObwKd8cRl1M/TIz63GSi9XN+
	LYrfbnf4Pd6jVrziDb7EpPZf0mOgu2fiOAc+0/vGuLLDlaoChSop5gE0yJMrJkqCqK8x0bA+b2T
	Xis7z3QxX6xGjwF9+EOA24i1MfC+PZMg=
X-Gm-Gg: AY/fxX78DAese2Y33BqQGrbfl/V25BLY7JTRrUWlDjjHOFCJXdjW7Dg5yEyZrIJyPUf
	0Z/4YEgbXuzFPHwykTagHv2osn6cX8zz8kqFwF3CFGLF+LQR//EBo7zC9R618FOm9Sbrc552mW3
	H9sZ5Hoy7ZcYAvdDuBqtl0f1p+4tVU3N65moqwVoSD8g7Da065CcxuxbgR8UqmAwuSPEW0uDMxT
	0qAVqLL5YGMXmehWDHY9ox+FdE3zv1ylCociTTvrhD+DB6JTWwZ3MG8BW8ueXYbtf/akCsFWjGh
	03gjm3x75599V+h0U8Efx04L849W8PxZwKZoOBoXexF0arqg4kWT0FetoiTw5RGV6T8N24a6ME6
	l61LAAalya2pczfhbyCCJtt2mKwnxueRPBkOHaPeKqnvAiTWe88GwNHAgdATOs7MYBHra/TfDcA
	/+gU6LZLU=
X-Google-Smtp-Source: AGHT+IH42Y9jMF9Ybm6PN2AjrAz3LmpBej4NKEjOFolTxZUH6/Ywh7BxkXaqCBXy+lipcuJ9VY003XRl/1ZPyupV1Q0=
X-Received: by 2002:a05:6214:2a81:b0:882:437d:282d with SMTP id
 6a1803df08f44-88863a86b5cmr8841026d6.30.1765323676845; Tue, 09 Dec 2025
 15:41:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Tue, 9 Dec 2025 17:41:05 -0600
X-Gm-Features: AQt7F2oXHR39caH7I73uR_kA-pVetWgyUVVWKj4yM8h7hQjnWT6try-qF04sxWU
Message-ID: <CAH2r5mvy6zoD3UKto6uOknFFMKCncJOPiDYqEUwKB_Zcpuj2pw@mail.gmail.com>
Subject: Re: [PATCH 00/30] smb: improve search speed of SMB1 maperror
To: chenxiaosong.chenxiaosong@linux.dev
Cc: linkinjeon@kernel.org, linkinjeon@samba.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged nine of the client patches from this series into cifs-2.6.git
for-next.  They looked safe.  Good catch on fixing some of these
incorrect error definitions.

a691ac0cdd97 (HEAD -> for-next, origin/for-next) smb: move
file_notify_information to common/fscc.h
c0fd2fbe4f73 smb: move SMB2 Notify Action Flags into common/smb2pdu.h
787a2b803211 smb: move notify completion filter flags into common/smb2pdu.h
14a6f0e19fc7 smb/client: add parentheses to NT error code definitions
containing bitwise OR operator
1e4c7c9ab176 smb: add documentation references for smb2 change notify
definitions
833f0f46368f smb/client: add 4 NT error code definitions
3a0a34572269 smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
954cbce76316 smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
b9695d00b605 smb/client: fix NT_STATUS_NO_DATA_DETECTED value
3d99347a2e1a (linus/master, linus/HEAD) Merge tag
'v6.19-rc-part1-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6

On Mon, Dec 8, 2025 at 12:22=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Before applying this patchset, the patchset ("smb: improve search speed o=
f SMB2 maperror") must
> be applied first, which introduces `CONFIG_SMB_KUNIT_TESTS` and avoids so=
me conflicts in `fs/smb/client/cifsfs.c`:
> https://chenxiaosong.com/lkml-improve-search-speed-of-smb2-maperror.html =
(Redirect to the LKML link)
>
> When searching for the last element, the comparison counts are shown in t=
he table below:
>
> +--------------------+--------+--------+
> |                    |Before  |After   |
> |                    |Patchset|Patchset|
> +--------------------+--------+--------+
> | ntstatus_to_dos_map|   525  |    9   |
> +--------------------+--------+--------+
> |             nt_errs|   516  |    9   |
> +--------------------+--------+--------+
> |mapping_table_ERRDOS|    39  |    5   |
> +--------------------+--------+--------+
> |mapping_table_ERRSRV|    37  |    5   |
> +--------------------+--------+--------+
>
> ChenXiaoSong (30):
>   smb/client: fix NT_STATUS_NO_DATA_DETECTED value
>   smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
>   smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
>   smb/server: remove unused nterr.h
>   smb/client: add 4 NT error code definitions
>   smb/client: add parentheses to NT error code definitions containing
>     bitwise OR operator
>   smb/client: introduce DEFINE_CMP_FUNC()
>   smb/client: sort ntstatus_to_dos_map array
>   smb/client: create netmisc_test.c and introduce
>     DEFINE_CHECK_SORT_FUNC()
>   smb/client: introduce KUnit test to check sort result of
>     ntstatus_to_dos_map array
>   smb/client: introduce DEFINE_SEARCH_FUNC()
>   smb/client: use bsearch() to find target in ntstatus_to_dos_map array
>   smb/client: remove useless elements from ntstatus_to_dos_map array
>   smb/client: introduce DEFINE_CHECK_SEARCH_FUNC()
>   smb/client: introduce KUnit test to check search result of
>     ntstatus_to_dos_map array
>   smb/client: sort nt_errs array
>   smb/client: introduce KUnit test to check sort result of nt_errs array
>   smb/client: use bsearch() to find target in nt_errs array
>   smb/client: remove useless elements from nt_errs array
>   smb/client: introduce KUnit test to check search result of nt_errs
>     array
>   smb/client: sort mapping_table_ERRDOS array
>   smb/client: introduce KUnit test to check sort result of
>     mapping_table_ERRDOS array
>   smb/client: use bsearch() to find target in mapping_table_ERRDOS array
>   smb/client: remove useless elements from mapping_table_ERRDOS array
>   smb/client: introduce KUnit test to check search result of
>     mapping_table_ERRDOS array
>   smb/client: sort mapping_table_ERRSRV array
>   smb/client: introduce KUnit test to check sort result of
>     mapping_table_ERRSRV array
>   smb/client: use bsearch() to find target in mapping_table_ERRSRV array
>   smb/client: remove useless elements from mapping_table_ERRSRV array
>   smb/client: introduce KUnit test to check search result of
>     mapping_table_ERRSRV array
>
>  fs/smb/client/cifsfs.c       |    2 +
>  fs/smb/client/cifsproto.h    |    1 +
>  fs/smb/client/netmisc.c      |  155 ++++--
>  fs/smb/client/netmisc_test.c |  114 ++++
>  fs/smb/client/nterr.c        |   12 +-
>  fs/smb/client/nterr.h        | 1017 +++++++++++++++++-----------------
>  fs/smb/server/nterr.h        |  543 ------------------
>  fs/smb/server/smb2misc.c     |    1 -
>  fs/smb/server/smb_common.h   |    1 -
>  9 files changed, 739 insertions(+), 1107 deletions(-)
>  create mode 100644 fs/smb/client/netmisc_test.c
>  delete mode 100644 fs/smb/server/nterr.h
>
> --
> 2.43.0
>


--=20
Thanks,

Steve

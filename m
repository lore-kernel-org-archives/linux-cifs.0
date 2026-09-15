Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CDF45D91A
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 23:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514111; cv=none; b=ud8mRK92VxsueyEfehREb/lF1h1QjTF/eafkIf/xCGbaYLi7IcdxWat+FcoMrPLeC7b06WnXq1pPITZ9egBfF/HKxxy9rV13wmLRUabBFZkVg97067+nCuIJxFzpUdJpmWyuRz2RZENsOrRun0475bxXg06RLAsW3jtwF3sW8og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514111; c=relaxed/simple;
	bh=XZL/Off+pweANoDfNEqSiUVKi5hKUNef+VbhzyE6HjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AEng/vSc7noN522/6KWIigDJcv5DvCN6ptmt+jYuqUlE0rj33OjypkQoMBU4tJMh/f1jUq8Ur/Q652x+cEdEDHblLhJDSEONuZFW7Dm4ZT+hJJH6fw4lzZzTAwhyTCbC2TMhUQ3Ba5BhSxLjTv03JRhIVSv54zuQDiWaU0cGmEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F4ajia63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F4ajia63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A408D1F000FF
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 23:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789514110;
	bh=fsr5fX4nda/DPF+yvh8aVx3jEf5AubYQ8Jb27qIHR2M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=F4ajia63FnwQyiKK8Ot6SfqFiPpNTtgtkT33SdIKjbXnEaSvhZKL0FB+RE/8ZG8m7
	 MPEPn5pRvQsFFUm55bYC57c0xX3YkEdsIYEjPxSdjArVYtikm7Q6uTpUEBES7uKtqv
	 5XdR06OcYdTlwy9bdHL5guSIr8Uu4AIhU1LNqNwPn8L1r5b6/lok/DzyLaeCtlhDHF
	 jTQR+5YZYfj6R0W0MENKOZXxPjc9UGjG3+3LUzmQ8nn7bE7ZwFz6yIZdg4QVJY6PO3
	 Z7us7e8jQxpi99QtW5b/i0ghwLxHxxKYcFyckS1MpimA/icXAjYWxkhE1xkeQChlyB
	 H+r1L80vmPUwA==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2953a01240so68082766b.0
        for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 16:15:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxCQmRqzLmcGjll87Rsc2GbQ/tY5YisesZhHhTPOsYgNKkXKkEeO3IouY+D3fVH8kj5FMQI/NjmirzR@vger.kernel.org
X-Gm-Message-State: AFuF++mPAQUJnHqY6jn4WHGV3uHRmIdLm1PmIICf/NlxXZ4p9FsJ4J9Z
	WVd549rRwAa5oJTZUx2eATvL5VxYg/Zc6m3Wr+yK0uVWHfR7nArgZi8QsvaucoO+pmOy3xDmbpa
	6Gb2QNiEDdW0SjhJAHtx9qcO0knxwewc=
X-Received: by 2002:a05:6402:3609:b0:6a9:b50c:7680 with SMTP id
 4fb4d7f45d1cf-6aa22376549mr256497a12.16.1789514109293; Tue, 15 Sep 2026
 16:15:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com> <20260915064657.110687-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260915064657.110687-3-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 16 Sep 2026 08:14:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-t_Guuqiis4i1bC=CBACk8dp463vBH929KF_8ijyvsfg@mail.gmail.com>
X-Gm-Features: AcwNN1WdLmAUgQvmIBM2sJWpMRtW-VnYytu5a7daC_bChVd-yiJ9rpUNPZr14x8
Message-ID: <CAKYAXd-t_Guuqiis4i1bC=CBACk8dp463vBH929KF_8ijyvsfg@mail.gmail.com>
Subject: Re: [PATCH 2/3] smb/server: align partial normalized name responses
 to UTF-16
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> @@ -7335,14 +7337,13 @@ static int smb2_get_info_file(struct ksmbd_work *=
work,
>                         break;
>                 case FILE_NORMALIZED_NAME_INFORMATION:
>                         fixed_len =3D FILE_NORMALIZED_NAME_INFORMATION_SI=
ZE;
> +                       req_output_len =3D round_down(req_output_len, 2);
>                         break;
Shouldn=E2=80=99t we apply the same alignment to
FILE_ALTERNATE_NAME_INFORMATION as well?

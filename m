Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77355382397
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 01:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784685340; cv=none; b=pNsvteyrxXGMi33N4DnOONnSzgr2yNgqQps1qy9AWORPskRmGaiYRjQHl7rllCTnJqn6EQXefq93K32mj6ubEw9VTt/qmLyHYaYnZ9qUOLUl11Ptime6A5lyvVHzcuzP8Njxxom8Y2NkKMXnKQorCIhWwNAG/rvE1PRP2BVm/Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784685340; c=relaxed/simple;
	bh=JEXnpSjC5wLsueghdw/UOnvv/34z3UOMm9WLPFZBos8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e8dpCVl1ES55xv/Y6Ri46Dap4EQubaNWAC9XwBlQ6XwbcabIcwfCv1yseZNq3tZ7Kwm+Fpd9rQg6GUuFv41yuqPBfs5C+iHOmM0WhMXRnbaC8SduQhGH8it6QrVx/WuIsCuXl/UMf1CFvOalCtWC1YjXcGkKe6/u2Kr0yImN320=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZe+wATg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZe+wATg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35821F00ADE
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 01:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784685338;
	bh=+z8ZX0qlLa+1HUnqFk+4a4/rzRTMvO3ZT/009alTWS4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CZe+wATgPFiiNXwjGr31sCGczp24YhxD0kycssHTEDu1bJi9hG1YqcZVW22DH2/vK
	 S7GSa6lzjYJh4ZnQuATBD4gnafkhN/zpZkRPNUVwnCJfzGg/Z2h8NwscQOxnU19SwP
	 2snpyKiSwwb6xkid5073aT9TD9RjlraFFbt2bTPrtbj4qg9X2fMv5/YeI4cd8UYi/B
	 pwbJuxdBh7jMkSOxXb0TW9tRjjDIgw9byT33nnZEjoqjkmjKGLOIjR/pg8713pnxl4
	 NNjKHUVHwWLIUaxPFMvf56hSBHTvqCtM9Dqd/rccuaQrQPLgCxsbbHXQC/zZXiO44r
	 +UrBWw5bfsuBA==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69c600f76ccso13083613a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 18:55:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqlqtDmVc7Rjj9k/LFiBTytIXQgQwzn0CrTQ3bmRtnNJsK2yioPSVjj+TIldSmZzFTlU9aJDN5Cbnhq@vger.kernel.org
X-Gm-Message-State: AOJu0YzGBi2/C4RM5tuWV9hbSadOZZ8sttCDrVlsJbefKlhKlKosZtH1
	L5rwVzs74bMH5JyUALPw+u9cnoSrSHZ6ujHOvI4iBNWIAiaBkJGjONVZcSpJfZ51bgrw9cSqVps
	I5IyCqfwb0rCO0PDL8nTBEm9dizyMqDI=
X-Received: by 2002:a17:906:fd82:b0:c15:ff19:15ee with SMTP id
 a640c23a62f3a-c16b47c88d1mr915283966b.45.1784685337449; Tue, 21 Jul 2026
 18:55:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1de1e19c-bd57-403c-b91f-70b2d3b51fe7@chenxiaosong.com>
In-Reply-To: <1de1e19c-bd57-403c-b91f-70b2d3b51fe7@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 22 Jul 2026 10:55:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-p=8p6c4HTfH9Su1bRAUwZsxpU=PXtRm0Y+ycge81Zaw@mail.gmail.com>
X-Gm-Features: AUfX_mwn3pGp2A_xThXBFm_Y7oSue6ajZNpM5iDlIedEUjOVzm7qnQvlWE4DI3w
Message-ID: <CAKYAXd-p=8p6c4HTfH9Su1bRAUwZsxpU=PXtRm0Y+ycge81Zaw@mail.gmail.com>
Subject: Re: [BUG] null-ptr-deref on ksmbd-for-next-next branch
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi ChenXiaoSong,

First, Thanks for the report and check!
> --- a/fs/smb/server/server.c
> +++ b/fs/smb/server/server.c
> @@ -140,7 +140,8 @@ static int __process_request(struct ksmbd_work
> *work, struct ksmbd_conn *conn,
>                  return SERVER_HANDLER_ABORT;
>          }
>
> -       signed_req = conn->ops->is_sign_req(work, command);
> +       signed_req = work->sess &&
> +                    conn->ops->is_sign_req(work, command);
I don't understand why work->sess needs to be checked here. IIUC, the
crash occurs because conn->ops->is_sign_req is NULL when Windows
client sends an initial SMB1 negotiate request. If so, wouldn't
checking the callback directly make the intent clearer?
+       signed_req = conn->ops->is_sign_req &&
                               conn->ops->is_sign_req(work, command);

>          if (work->sess && work->sess->sign && !work->encrypted &&
>              !signed_req) {
>                  conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
> ```
>
> If you want, you can add:
>
> Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Sure, I will add them if you confirm it.

Thanks again!
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>

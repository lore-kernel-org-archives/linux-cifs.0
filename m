Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA5A286D5E
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 08:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022232; cv=pass; b=k866xkfgwCVtPZ97VlPl/YMz6ubEmtymaHCy/Rukm7g3Hjc1fraDpqBew/UKpX8rj9EERN4bNGqLbv0C9gmkPnaFA0I+PCaejqZHhpx/QLjfeg/48617bPfV8FhvNs+9AUs99C86dZldkU32fjmKkkIOJ/VBlWkz53RLjvXfSfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022232; c=relaxed/simple;
	bh=EfP5QpBZAMr6Y92K70IDq46nGmpLEsvY8wgdsX6vLZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tYMTSf0iapjgPpQnGZI42FngF1CyzfUottynZRiRHNUyr74T565WwWD8SLviHbZ+wEp4INArDYldnLya3LqD0JyuQ0csqx/c+/iY9Ntu5PLK94jNHq+ntOjt07RLEIC7boj5p4gDjgptYhC9PliOkZDZNOGckODtoP6OX4Jo9zE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XdbILRMJ; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XdbILRMJ"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88a2fe9e200so40128086d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 02 Feb 2026 00:50:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770022230; cv=none;
        d=google.com; s=arc-20240605;
        b=XPYomo0bgwGhzhq1TJCXXZbcJNk1Lp6lH9ThNMHLT51Eg7SRxNB7UF6iICQB64YwW+
         QIplSYH8VC2G9hzoRMJ7d22WIAXfuRl3OI+u9y7h76MOZAKVYfnN+pVpbmLCrRetpe1h
         IzTT4LMO+D/Usa0GEQvLf+5CgXuD5VwWos9v2rZDNZIELQ7yaG9HxJ6nNj9jiiW2aCVM
         QyVmJSFys6qBPNkn8haHXaX+J3WYX/uT4zIb1rC5PAOm/vtNAjVbGjcjH5saKAIaH5mX
         d2LFe9HpRkMlmwrq9KwMOLmfyglSeMDm1+gz2d+PIdSVapwLnqM0S16aQCDy+3/h8prC
         nUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cyzRxDbeoroHtKO4CQgbsqGOfcHIZ97UkDPgKQL3aYc=;
        fh=cGzclKKcHsTMIjNGAVHoGHryIv/eyIGEejcov49l/xg=;
        b=KC9mP4et0k43q37DQnNcXjor5671rL+ZMqzynj8TtfQZs6XuVNF5es8e67vgi/zYiR
         Iz2U5G3XG08TZUmWdF57a/ZxaQYMu6nfsXIICBsZXAfcNAknfGdmQ/iyol/BxXZtfSfY
         hyHxJng+cqvViUNa7fGe2oz/xGd0W/78GShrYSUQHoj4LPq1p8j2xfwveRnb05qrEl6g
         MrpDF7siLVIrPQtYt60SOsliRrjDyg4/7Gw7Q9x4teHcSvxEkvV/rcWjxEpWHiQAxSfc
         a5ZmY481fQxIE85wsRqznNCZRv9Vd8uAv68WF5184+kfehdRVItvUa0RNAyt4/EJcQK0
         gZPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770022230; x=1770627030; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyzRxDbeoroHtKO4CQgbsqGOfcHIZ97UkDPgKQL3aYc=;
        b=XdbILRMJs+DMBuY1EHef09L4V1BMpQ2HmLp/esBodADtvnF3SmsSQV5iqsyCCkAmNh
         jSnGzRVSAd74EcfLDJ1wDo6tXPe9fGAs3BB8UPb30bIPnqSrtIwMTgInwDMtycmIWzr0
         NlF3ULBRrk8QLo0BfFwO6mIg1XzZvMmkjetciXbUNiS4jn/AKhCIcGZ1yrD2z39HpGTZ
         LgeLMw9vGPJYH+CQ5uNekBtejiCdQzTS6V9nu2IwJa+bLMR7h4Uj9dqpXr+qwBN1492k
         cbapOQ1NuDQavG68fWwCfV/w3YfSplCgXmu1uvzFLY+rAvu4FPPjhNzr6ebAiBUHjtmX
         X+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022230; x=1770627030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyzRxDbeoroHtKO4CQgbsqGOfcHIZ97UkDPgKQL3aYc=;
        b=So/yF7IVaRGFBG8b4rApDpqV9dJIuoiNVXWVn2p5V5TAeDN4hiudtIkfp+qzoRcczA
         KPFo1nm29hIU3wvi0GindZaBjo84YcriSxETTu4Dtu3qsTFzd2huDcDh/EhxrHKMLgGe
         Xz02LUOsnntYYRpAarp+qzo9YzQWuTqXvhVgg2LUr6ILNFakjUMPuw2jgJQG7yD1ZTyD
         fsNbQVbbaXfCN8d7hq6sPFlsqSUo3J8Ho0W45ret2ioW7tZqgH3xHePc16geJPUnbp3s
         UvB//kw8TL6+rWBRuSrYjcn+p7udYn+4ziihxP/jYCYyRR+jE0lBJeLCh8LLYrQPMPJn
         XAMA==
X-Forwarded-Encrypted: i=1; AJvYcCWe7ulS9NnlcAVWL6/RVWKV864pGv7JLW2UP8TbKHx3Afx9/hb2ml+w6MDJ4SZP+nMIr4ZPdZvm5Cjh@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj+VxMJeuQRj+y/rS4WNuXxqR6cLXtG/+dWP60wtV0AHNQAb4f
	jAWCujxVCf+Fm8zCSUysKY+ahLOkTn9LJd1M1oNiSghXyT2wmPyj/dOFYqHjmYiV3Y3XsuZl/+u
	iDSbUQzAYjMn0fZ0RN7Sj6M7HpumXFFE=
X-Gm-Gg: AZuq6aIt1SNh+NerU30naYSy06Cn73+re9MCDEf/+MajJMUSsS3Wg3M5tlb0uUimnfk
	fe9sEbk1rV7S93BeU8D3Hzp4FAGjL0JBq3bFBhwY5fcETHDga1PkDWr8mm23wdoG4ydPkP8RTTW
	M8Ejk7euLHkFtJOWTKZqFSO7+u9EaeMSrWBn8ikMGa/ZFVS2qwpDCp2tlOSaDmhc1gt2MLg6dmH
	HTef9+eWaGS5+phCDMt6HioRdSquxXyYekzxPLUQv1AQ4FRm0bw1d+Tf0kRWvJ/QQCWUKexCf3q
	80mHN4LWgebIPsRvmNom1LliPykt/BXIox/mN1rjwTtYnO3dyRPy9EaMXwPmobBkfZVAYEtNd/B
	D9IL8UC/2h4+eruO3BcT9Jktf7wi+lZrRsZNOGoSLSrpONEP4c0XG19e73FSZb+InaMU4EkVklZ
	HzS588rub9kA==
X-Received: by 2002:a05:6214:1047:b0:895:479:b3bf with SMTP id
 6a1803df08f44-8950479c367mr45964206d6.55.1770022229575; Mon, 02 Feb 2026
 00:50:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202082407.1881618-1-chenxiaosong.chenxiaosong@linux.dev> <20260202082407.1881618-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260202082407.1881618-2-chenxiaosong.chenxiaosong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Mon, 2 Feb 2026 02:50:18 -0600
X-Gm-Features: AZwV_QgUigCJQpFiijYeFsQ0flENJGlmn7C4IV-zqnxaWTn22b6GnYWxwR09l14
Message-ID: <CAH2r5mt3nUrW_qvWCCHkiBPCoXg0XdwV07_wS+7Ls3p7AQ81HA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb/client: fix memory leak in SendReceive()
To: chenxiaosong.chenxiaosong@linux.dev
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, nspmangalore@gmail.com, 
	henrique.carvalho@suse.com, meetakshisetiyaoss@gmail.com, ematsumiya@suse.de, 
	pali@kernel.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged both into cifs-2.6.git for-next but this smb1 patch has
dependencies on other patches for next merge window so might have been
better to rebase on mainline so we could send sooner (although that
would also require changing at least one other patch in for-next).

On Mon, Feb 2, 2026 at 2:25=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.dev=
> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. server: supports SMB1, directories are exported read-only
>   2. client: mount -t cifs -o vers=3D1.0 //${server_ip}/export /mnt
>   3. client: dd if=3D/dev/zero of=3D/mnt/file bs=3D512 count=3D1000 oflag=
=3Ddirect
>   4. client: umount /mnt
>   5. client: sleep 1
>   6. client: modprobe -r cifs
>
> The error message is as follows:
>
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>   BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_shut=
down()
>   -----------------------------------------------------------------------=
------
>
>   Object 0x00000000d34491e6 @offset=3D896
>   Object 0x00000000bde9fab3 @offset=3D4480
>   Object 0x00000000104a1f70 @offset=3D6272
>   Object 0x0000000092a51bb5 @offset=3D7616
>   Object 0x000000006714a7db @offset=3D13440
>   ...
>   WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x379/0x3f0, CPU#7: mo=
dprobe/712
>   ...
>   Call Trace:
>    <TASK>
>    kmem_cache_destroy+0x69/0x160
>    cifs_destroy_request_bufs+0x39/0x40 [cifs]
>    cleanup_module+0x43/0xfc0 [cifs]
>    __se_sys_delete_module+0x1d5/0x300
>    __x64_sys_delete_module+0x1a/0x30
>    x64_sys_call+0x2299/0x2ff0
>    do_syscall_64+0x6e/0x270
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   ...
>   kmem_cache_destroy cifs_small_rq: Slab cache still has objects when cal=
led from cifs_destroy_request_bufs+0x39/0x40 [cifs]
>   WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x142/0x160, CPU#7:=
 modprobe/712
>
> Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761b2=
1834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
> Fixes: 6be09580df5c ("cifs: Make smb1's SendReceive() wrap cifs_send_recv=
()")
> Reported-by: Paulo Alcantara <pc@manguebit.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb1transport.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.=
c
> index 0528c1919961..0b8b852cfc0d 100644
> --- a/fs/smb/client/smb1transport.c
> +++ b/fs/smb/client/smb1transport.c
> @@ -252,13 +252,15 @@ SendReceive(const unsigned int xid, struct cifs_ses=
 *ses,
>         rc =3D cifs_send_recv(xid, ses, ses->server,
>                             &rqst, &resp_buf_type, flags, &resp_iov);
>         if (rc < 0)
> -               return rc;
> +               goto out;
>
>         if (out_buf) {
>                 *pbytes_returned =3D resp_iov.iov_len;
>                 if (resp_iov.iov_len)
>                         memcpy(out_buf, resp_iov.iov_base, resp_iov.iov_l=
en);
>         }
> +
> +out:
>         free_rsp_buf(resp_buf_type, resp_iov.iov_base);
>         return rc;
>  }
> --
> 2.52.0
>


--=20
Thanks,

Steve

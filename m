Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776A8405C4B
	for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 19:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779131797; cv=pass; b=UwRZTOwsvvQZbJGWZDG5IkNm9BV5+SrRJMaYkjV7ae8Vm5iZ9TAsWf1xZL8hDuONFecDAC3+cHJTO7OMnCMawe3E7dWi/PtAAVUn78J8NbuByRa/W1ABd46EV3RIufBTABC7vvdvDelBYrvK6oTwXuUKpc5/78cdgwWpgr1Moq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779131797; c=relaxed/simple;
	bh=qF5nW5PU4UaS14T7K44c4qAdqbdkIFaX/p8vFjDLYkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aPIdUxmO0gbmLYP0K6iD/CMewWA0DEQFkbOSi0RajnoQEABe+R87g3s2wu2flqDoKAa/GtICmH1HwjJZWud9YnqTg5xkEdCH/JUyKDHlFYpc9RIb1vCyI7R9UMNnCj4jTPnWVXMQRrbGqTqz5CKp6YpwCMvoY+XQthqYCs0E/Kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qL2ogje+; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qL2ogje+"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8acb09ddbf6so54209206d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 12:16:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779131794; cv=none;
        d=google.com; s=arc-20240605;
        b=a2B/2WIGjn10KAkx7tmHbBkc25m719BSdULT4HKAhTdfl4fGZ5TR45ipIIHUkGVAYY
         Imi+e5Fxm3+mH2wwyefCMxHjlYihIsb9qKC/zQnJHfaOA1pWECZQ1GammnQM9TrQeNBO
         3IVhTgkZnirwmSRKgY3fezkKGew5ZPMamDPqoOALz4dC1E/wXksqTy6qXRsedhSnBBZt
         /wUlUSKjbnUFdegEbNsgPQ8d4u7HcuAZB9hIdb5w+6Y+PMaWcLFMW6sEyyuwJb6IYWJe
         R9MZOj2iqfkVrpiNMPYcXaauGFrV5dCfHDmiA6t02RmJAXP9r6oSC39FtXqlgqRfrM6Q
         A8DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qwQ2fIQWMf1xdrhE3ChYBNj0Caa+rc+Zme3mprvZvaA=;
        fh=Vs7IGTueKGahyi0tmCgfaNGueYaZPogZ8Ndwb64t2sI=;
        b=TuF/5Vd2GAZ1swpIdCWjAvfXR2IWCvQ2xb6edvQXR9CPYjFHcTlbEevwbgsA1X6xuL
         vIkrn2ELq1+6bewNoZDQFY78ZcIL4piH8KmgAEW41wD5gh2f+uMQaucCMMs/E7RRcF1H
         e0eB2TsXV8WbASb5a6pchDIETWwWDolghP2/UVpty3dLJMMpGd+YRxFPQe49EVQGtrwO
         q1lFE9z+byhqvLa95h5vSW4ghvbKR/LxhfdGpzvGBGz24OchMMmkCH66hy8XSFne2fpe
         fEBkfnFAJd9z4eoR+AI57HnD4Pwi1x1YGFTBUtK+6lNNx/a4VY35ZoAXqb+eUbTGjDU2
         VCEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779131794; x=1779736594; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwQ2fIQWMf1xdrhE3ChYBNj0Caa+rc+Zme3mprvZvaA=;
        b=qL2ogje+FWtgtSRfMKHNoHwV31AOeke8GJjAlu2ijFUS7KXhRjz/o4WqDBA3LCk/bf
         tGhak/5GABihK+7AxiQfMdlD3JmOonRkLpRlm5yI6B1iDZrYvO77eJF8JbZrGmb0aoKL
         yqIek85LiVJxn4YI96wjmnPYguk4fBC+MUK3CyOwgBwcv67tnlUkj8oK91nbYOMt8MTD
         3Q0kGNLbNud/bmBqWB+Pd3f+NbB0dXS6IAyv1GXzUDO+mqEJbTpGiYpbp69qNBECjUz4
         Vo6ct69Mxanb8ETwBg9JSDuEMFxNptbHokKsmIr/tIruEr5FvYjJXX5ZZvoyhPqwQ2nb
         jv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779131794; x=1779736594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qwQ2fIQWMf1xdrhE3ChYBNj0Caa+rc+Zme3mprvZvaA=;
        b=py015iJRwaN62idVwKEoPFT5Nzg2B9mF4/2LgfHzCEZDjqXxsZSA8ZJLfDmuKt89jr
         kUDa97a+Is7VcbSgi2dpK+cdiGNUDIteJwGtJQ4UaYw6tbgLSWTZ+1DXRnnwDF2avID0
         OraPH3oZO7N/R9RweCOpq3E6PPgd5hTgASVqWrNsJxu0XzBQC0EwNwno8zlvr6GU07Xj
         NTo6semsZcIeE+3glsZk4xumUNXRA+pZw5eF5kO5T/kOyqgmc6NBS1x5oZFy2AXrTmA8
         UCA5z/0st4HC631Q1bCswUE9QcD0m4tfqwBVe8NHXd/m23/ge2keNEH+FdO+jg095gf1
         yGVQ==
X-Forwarded-Encrypted: i=1; AFNElJ+hL1rXVuje2FUGnQ7HKJt27ZwfEMGG8+pL5jTlkkwbzhvjJGqUtd/R8iU58qk4k7Dz4qpQEhy03p1X@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ7VR/1NxB1iHFm6dylAckM+nV68zuBO4sbqnMJVFrbRwSqwH1
	ouQiHzQTMBNi41y2YBUoK2jCvZf1S6H+xwHofXTNUG8sHX8OxdiBnTLj6vGM+KpAvDuUk7ycTMo
	Ne42/T8AF8U4FVaW9w3Y2hc9O6LjeQGg=
X-Gm-Gg: Acq92OHOj6JnAl30+3zQJ5O0ps3ZW9i8gLi+/ee860fR+rDJHMfngFS62FC16dfs8Rp
	YfmEy4Nf+sYkmHHV8TNzEEt0U3jIsym/xMFYkI3ebsF8wQpyxp+voxqs45XREhwpW4AOq7UrCfD
	IHs8GZLmYtDvPArADA9B+/ybLftoizENmDFhNjJ9uiIT6p+4r0pjnsSN7rgOgY/gOCYb0bY4+E3
	fC09H5raMVa136r9fw8dKSzrzzkc1DxbJKZgR2olF2gBAtDosaDPUVjEdgDxhL3mwYpisIH+4nG
	FxE42lbhPzh4J/QXBDaVWdGs0NGzrbGeW26JJGO4eLZNWIAWUROoIyy1n6MGI0S2dr2RWCCh2tf
	ehYRlmtMF0xkmLZHVePfGrk6pKGjl82tYucuXktb6G2vny0nA6Px68bhEz24s/ZIssWywUGnmS+
	PnFlRebBedrdbjAqQnA4Bk2Q==
X-Received: by 2002:a05:6214:4291:b0:899:fd80:f79f with SMTP id
 6a1803df08f44-8ca0f69dfe3mr274514286d6.23.1779131794392; Mon, 18 May 2026
 12:16:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260518152322.265844-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260518152322.265844-1-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 May 2026 14:16:22 -0500
X-Gm-Features: AVHnY4I7CAsOoZZBAUAC5n77SxPduZ3tFw8nBs4g9FwvFUPpd16C0Fn3dGNXxYQ
Message-ID: <CAH2r5muSc5Gu+rTD0ptY=Gjx6yr7A4VbJ_dq25jR5We2gRBzYw@mail.gmail.com>
Subject: Re: [PATCH] smb/server: promote S_DEL_ON_CLS to S_DEL_PENDING when close
To: chenxiaosong@chenxiaosong.com
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, Huiwen He <hehuiwen@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good job, your fix worked when I tried it

You can add tested-by if you want

Tested-by: Steve French <stfrench@microsoft.com>

On Mon, May 18, 2026 at 10:24=E2=80=AFAM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. server: systemctl start ksmbd
>   2. client: mount -t cifs //${server_ip}/export /mnt
>   3. client: C program: openat(AT_FDCWD, "/mnt", O_RDWR | O_TMPFILE, 0600=
)
>
> Do not treat `FILE_DELETE_ON_CLOSE_LE` as delete pending while files
> remain open.
>
> This patch fixes xfstests generic/004.
>
> Link: https://chenxiaosong.com/en/smb-xfstests-generic-004.html
> Co-developed-by: Huiwen He <hehuiwen@kylinos.cn>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/server/vfs_cache.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> index 913164c958b1..5a232d94f567 100644
> --- a/fs/smb/server/vfs_cache.c
> +++ b/fs/smb/server/vfs_cache.c
> @@ -211,7 +211,7 @@ int ksmbd_query_inode_status(struct dentry *dentry)
>                 return ret;
>
>         down_read(&ci->m_lock);
> -       if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
> +       if (ci->m_flags & S_DEL_PENDING)
>                 ret =3D KSMBD_INODE_STATUS_PENDING_DELETE;
>         else
>                 ret =3D KSMBD_INODE_STATUS_OK;
> @@ -227,7 +227,7 @@ bool ksmbd_inode_pending_delete(struct ksmbd_file *fp=
)
>         int ret;
>
>         down_read(&ci->m_lock);
> -       ret =3D (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
> +       ret =3D (ci->m_flags & S_DEL_PENDING);
>         up_read(&ci->m_lock);
>
>         return ret;
> @@ -395,12 +395,20 @@ static void __ksmbd_inode_close(struct ksmbd_file *=
fp)
>                 }
>         }
>
> +       down_write(&ci->m_lock);
> +       /* Promote S_DEL_ON_CLS to S_DEL_PENDING when close */
> +       if (ci->m_flags & S_DEL_ON_CLS) {
> +               ci->m_flags &=3D ~S_DEL_ON_CLS;
> +               ci->m_flags |=3D S_DEL_PENDING;
> +       }
> +       up_write(&ci->m_lock);
> +
>         if (atomic_dec_and_test(&ci->m_count)) {
>                 bool do_unlink =3D false;
>
>                 down_write(&ci->m_lock);
> -               if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
> -                       ci->m_flags &=3D ~(S_DEL_ON_CLS | S_DEL_PENDING);
> +               if (ci->m_flags & S_DEL_PENDING) {
> +                       ci->m_flags &=3D ~S_DEL_PENDING;
>                         do_unlink =3D true;
>                 }
>                 up_write(&ci->m_lock);
> --
> 2.54.0
>


--=20
Thanks,

Steve

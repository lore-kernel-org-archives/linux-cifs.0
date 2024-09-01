Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8661217C;
	Sun,  1 Sep 2024 04:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725165815; cv=none; b=McmcYKs2ybJz0XZffQ5vnJUvbCZhZ+hkYL2VrWYgUauEedYAHJ49fsb29NEKaF9tryLa7bPhh/YO/7yOBuzAaSgFL0oLijyQZLlt74mQoTARp8/Ggls9UxDYRk4u088UP7cIhTtYpwKJ2e7jQLSM4opG+GesYrLtV6v+g1Ij9qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725165815; c=relaxed/simple;
	bh=atsUDr9o2inhmu95KvltgWkD/7UEVP9+5J7Pq74TN/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rXL4+PQzAkwjSTEtPvGuP87VwbiVwU6ISUZqmA2PCyrvVtYkJRd/dryBq3Oxqsv5D+5bQma9oLzIjNkTYRGrzsBM3BsKKaKgChlO3iz9yNmsQBEG0KFRA9SZxgIOFtaAS2XjK2v2kqcjdaYBHv/O02VZ6XQHv5JnGDfjPH4HtDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tg4yHvL4; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tg4yHvL4"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-533488ffaebso3809987e87.0;
        Sat, 31 Aug 2024 21:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725165812; x=1725770612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XB13jX7pqzNo9GSIstR/wq8ueYkysOGTG6QjGevDfZY=;
        b=Tg4yHvL4h7tESEWuFaSjb1Kn8jhDaqw6EICxeBFClypNEBp23+AjX5F71j1+kxgNJi
         88HkquhjsVzokKhYr3PVAGUqypaCkLsigtMWpBYix8afI/STHDX5IdnmbYv+4K5N1Ze5
         dPltfiT9WiN9hWSxmLI16slaQJtfRdq/36e0FFTynVTqXaysvgBmftVtFbK2KYJdlOa2
         XCY5OcEPyOlszHK+wO/gglHN8XcJXXLkZuaCkXOvaIH0VYcEFFkVcEMnpuJyYaETjSFd
         c+jE/tCaiym3UfmYoXL2wWGec3vQLsTm0TSQ+uTxVBZxsL4KG7Bkj/WM2KwZ6XSjQhx9
         MqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725165812; x=1725770612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XB13jX7pqzNo9GSIstR/wq8ueYkysOGTG6QjGevDfZY=;
        b=Vt0RR1IZPbxMcZOCsvJa4IJqO3f+KmHcJnWqVmlyJp3nnoNvQXu6QeMBHvtDEpzceP
         VhF0EgFpUmW50Z3JgXjtLULUFC3GPqNP3eFeklg4VKOfKyGCzD+cHXE1XjtrKUfLK+O/
         xEX/Tk8Fdvnrf5ybRMpG+TvS1Bn0Gy4hX370TYI2q63Lr5/MdLUxCmsGUIl83r08Gjlw
         FauHf/IMtvJfa9dfKqD0O8hT5TSbkI7K4LXC96IrHyngSTg027rVxKB1MvXkPsvHr5fj
         NWYnHX27lP+AeJ4KoYb1wNuH23hjEbjkElmZVPUOvTIIx/ZSEL6Ed3DB4sITtdqFk59E
         ApmA==
X-Forwarded-Encrypted: i=1; AJvYcCU1hofzrd7rqOJPzHfOtyq5skj3o0t2lNYLgX7R9Bfwh33GXBOuc3boVZUA1xNfLkiM44XRAiDOO2YmM3k8@vger.kernel.org, AJvYcCWJhqPwJ3uINesClDtMNqB6D5ThKIL6w+xU9/Mw4bUPBHKwgDgXyJfq54/toNR2qnHZoK8wim6be4IP@vger.kernel.org
X-Gm-Message-State: AOJu0YxGUCA+eosoivbNINp+RNPEeclNzNZdcebeP8nJWfVXonb7dZrV
	FVKDMxDxLkmEdymO6Bgei4w2ziRcx2Zu5Aq0vL+JWsed9s0zsQF16MUaz3ic6dW0rsPvbW/J0ed
	jHwS2fVokdbtwOwxHAR3bCvjBsHI=
X-Google-Smtp-Source: AGHT+IHu4y+uRiMhDn0qrmVune+00KaG6AT8nPwiLjbra3+fFieFK0+pk+mIHvbGu5xjBuCn1mALeBcQLNE4j/WlkzY=
X-Received: by 2002:a05:6512:3c99:b0:52e:9f17:841a with SMTP id
 2adb3069b0e04-53546af3048mr5220331e87.6.1725165811310; Sat, 31 Aug 2024
 21:43:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827085420.76655-1-shenlichuan@vivo.com>
In-Reply-To: <20240827085420.76655-1-shenlichuan@vivo.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Aug 2024 23:43:20 -0500
Message-ID: <CAH2r5mtEvkw-v6dr7KdxoA6kzhraEx06kosrYoD-p1kmkX7cgw@mail.gmail.com>
Subject: Re: [PATCH v1] smb: client: Use min() macro
To: Shen Lichuan <shenlichuan@vivo.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged to cifs-2.6.git for-next-next (target for 6.12-rc)
pending additional review and testing

On Tue, Aug 27, 2024 at 3:54=E2=80=AFAM Shen Lichuan <shenlichuan@vivo.com>=
 wrote:
>
> Use the min() macro to simplify the function and improve
> its readability.
>
> Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
> ---
>  fs/smb/client/cifsacl.c   | 2 +-
>  fs/smb/client/smbdirect.c | 8 +++-----
>  2 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index f5b6df82e857..2f9a1bb6e21c 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -187,7 +187,7 @@ compare_sids(const struct cifs_sid *ctsid, const stru=
ct cifs_sid *cwsid)
>         /* compare all of the subauth values if any */
>         num_sat =3D ctsid->num_subauth;
>         num_saw =3D cwsid->num_subauth;
> -       num_subauth =3D num_sat < num_saw ? num_sat : num_saw;
> +       num_subauth =3D min(num_sat, num_saw);
>         if (num_subauth) {
>                 for (i =3D 0; i < num_subauth; ++i) {
>                         if (ctsid->sub_auth[i] !=3D cwsid->sub_auth[i]) {
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 7bcc379014ca..f307122b59fe 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -1584,11 +1584,9 @@ static struct smbd_connection *_smbd_get_connectio=
n(
>         memset(&conn_param, 0, sizeof(conn_param));
>         conn_param.initiator_depth =3D 0;
>
> -       conn_param.responder_resources =3D
> -               info->id->device->attrs.max_qp_rd_atom
> -                       < SMBD_CM_RESPONDER_RESOURCES ?
> -               info->id->device->attrs.max_qp_rd_atom :
> -               SMBD_CM_RESPONDER_RESOURCES;
> +       conn_param.responder_resources =3D
> +               min(info->id->device->attrs.max_qp_rd_atom,
> +                   SMBD_CM_RESPONDER_RESOURCES);
>         info->responder_resources =3D conn_param.responder_resources;
>         log_rdma_mr(INFO, "responder_resources=3D%d\n",
>                 info->responder_resources);
> --
> 2.17.1
>
>


--=20
Thanks,

Steve

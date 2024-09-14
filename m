Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F088BE5;
	Sat, 14 Sep 2024 06:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726293695; cv=none; b=NtOTVWwo7tlYXQsgKnaGXXTJayc4m4bIClXkuTq5q1bf5x1+zkm/FOaYsLmyRmYB+vl99dPmpe29xLRZOMU/xtskoFk7wsU2KF8mQnJOcrFKVFWpbwpq1z6bzRNf4FlhGRaJnnXQ6QJH4DWxm6/N0/t5vqLbtcgz+aEzSRPxVRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726293695; c=relaxed/simple;
	bh=RkSSgfAuKRdysLiIrkmcZussub2Fp+poWPfy2LCsOMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nY2mbUIYIO2NbL6IEkt19idOFzidlfXNZvRDWnQfXY4t8u9GBNRZFUlP9VntLyExTBAVpw3VQiH2RKHXSZ7Ec2AjBkQxCOCq3k7ZcNIhtR2CINgOR34p72EH/M/yAKhr4c75Vkze/ZpRZXvKITtaJIW3kt8deAVsM+Jj5QwZIOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YfltoV3J; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfltoV3J"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a8a897bd4f1so192672166b.3;
        Fri, 13 Sep 2024 23:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726293692; x=1726898492; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lf/YMIfb+2Zu/yKChK72uKrs+v0SF/ljvcIM9ywqVpg=;
        b=YfltoV3Jgg7qp3uWs9eYBzpuxwEk+T1HynZ4PJdMyrx4RGIj+EvQEfkAC+Api1lN/7
         VwM3u9Qd/6qlB2EF6iSh7gmSLSqoj/DvMO4WJDwsoXuDVk6LcQ6jfCo2CsMsYwbA0tyB
         xNGuNZapB8yJmsLJ0QUThBVBnmBhNSwhjHyffo5OwdhjX3ASRKtFxqycPqSY6EqBTn+t
         hSDDCFlVrvzmowNl6QRQMi4+4c8fXDo5EvS9T/A4/CCtI/K9Q6iFnzgyLQzwdeRsbTpP
         2xgm73lXireaCqL4p/lXFy41ymHSIrqw6K+fbjXY+O6A7JxvMICCsq/M/e4mAd19B4Ss
         HZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726293692; x=1726898492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lf/YMIfb+2Zu/yKChK72uKrs+v0SF/ljvcIM9ywqVpg=;
        b=TTZ/GzxV36CXHsmhd7LJOb3nSm7DOFieR0ao3A9nHa0obAmV9qRxDA3tgudIDB9GW2
         j3pXKQgLpDxRSj9BmaINNFlbSOJ2n3vY3NGfiPK45DGMu7MRfx3q37RD2RDPPz0e2TNT
         ddAof+WWdI2CT400K0CevIi1arH9JTPxJJQA9gj+dToWpbqJ/n/5Tc7Hlz0nSvBv652m
         r3h1Y07V3+mL2OdnNqwGDnGJh47k/7uk+hg+kpCjtosm10cQrEFiDKe7OwOFypV9SThh
         hD/S/vd0TjskqcwjRzMiIdFXGFDQsJE1QtAjFyqRnHiMBJzy2QW2O/qnW1/ePLQrFXkG
         7RpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsgF+6xfEPqyYnsYX0ol045KAOotSV2drGUCDFI626jJIUO+y7BduiJpYstGk8FQSDKsCyGdQmOPicSuIo@vger.kernel.org, AJvYcCXXlZ/G6mol2P7z/vI2BFbbkwv1rlKNs/YCYoukJ+63+7mwhQD3J58TIohwEr+kYhuP3YBQrEkFjmvH@vger.kernel.org
X-Gm-Message-State: AOJu0YwBMdmqvmbqr5gDnSPN/RNQ/1BXXHCDwt0ElHVI6AB1Go2DrVDT
	aWqJOVDSLQHPICBk3AE2CEJO3i/0PjCgSkHfmHXlIpT/3VZzgPvWM5IOoOJl7MlKXbG0CzU8zvi
	0ZIukR+nzLeDuEfaveRtYCanDn/M=
X-Google-Smtp-Source: AGHT+IGc2jE7I4KNR724zpEtd52VLgY4GffBQHicvuMutrirxiXRQn27NUACjEy+Zrk+aHKGdg7OSDQoK3qLOx2sX2A=
X-Received: by 2002:a17:907:7da1:b0:a86:96ca:7f54 with SMTP id
 a640c23a62f3a-a9047ca3bebmr416539066b.21.1726293691180; Fri, 13 Sep 2024
 23:01:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913032750.175840-1-qianqiang.liu@163.com> <63aacc6d-8e3c-476d-938f-cce25d74a6b5@stanley.mountain>
In-Reply-To: <63aacc6d-8e3c-476d-938f-cce25d74a6b5@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Sat, 14 Sep 2024 01:01:19 -0500
Message-ID: <CAH2r5mtswGSeNWb9GyGy0r6aaiQAF0x1q2uYmWONGVNq_Q0Udg@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: compress: fix an "illegal accesses" issue
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Qianqiang Liu <qianqiang.liu@163.com>, ematsumiya@suse.de, sfrench@samba.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next (after correcting minor typo in Fixes:
tag spotted by checkpatch) and added RB

Will let Enzo address your other suggestions but they seemed reasonable.


On Fri, Sep 13, 2024 at 8:26=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On Fri, Sep 13, 2024 at 11:27:51AM +0800, Qianqiang Liu wrote:
> > Using uninitialized value "bkt" when calling "kfree"
> >
> > Fixes: 13b68d44990d9 ("smb: client: compress: LZ77 code improvements cl=
eanup")
> > Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
>
> Thanks.
>
> Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
>
> I was reviewing this static checker warning.  I also have an unpublished =
warning
> which complains about collect_sample().
>
> fs/smb/client/compress.c:207 collect_sample() warn: should we be adding '=
len' of the min_t value?
>
> It's a bit weird to sample data from each page.  Could we add some commen=
ts at
> the top of the function explaining what the function does.
>
> /*
>  * This reads a 2k sample from the start of each page to see the data is =
already
>  * compressed or whether we can compress it further.
>  */
>
> regards,
> dan carpenter
>
>


--=20
Thanks,

Steve

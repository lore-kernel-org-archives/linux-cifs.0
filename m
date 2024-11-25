Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B143B2500CC
	for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 20:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732565224; cv=none; b=p63mUOy6S04u23wRekgfzch7p/HXx3+X0/ugSU9RBDJSC/bHRUTl/kOnaCOEziM3Q/yCyLU+qPPKQwqmBv7GYb/4JPbRahhQSHbOXkCdUAK4WuZnVZcyj2Cur0HIZ0ASKIGTrWKN/ytZxKxih4uXCvqWxtrRcxyrhARniNNs5rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732565224; c=relaxed/simple;
	bh=2e2tnDG6vCpSUBbw0RSUHfSowPBONf63T0DmUPF+rJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KBysvkaFf/DEKccimhzqNEqA8hH6jYEVzD5GWp65WF/zzKMDKQ6gGkkRJ1/TO4sZHZbLYwCpjj/pnNm1gyzInqkza4Jseg2GqD0UY4VdaMpdFoi+ylQFhKy4TPJqczlUqEkuuuVsYkxkOcG7GBLfkjVze7KeKfmwVvuTiYU9pOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DzfltClH; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DzfltClH"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53dded7be84so2433953e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 12:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732565221; x=1733170021; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6W7U/3kNQ1Q21gQ2G25xQVR3qZVJP3a1CLybJY2EFA=;
        b=DzfltClH6SEUL5GMmPUeHefklmo6NH2XIJm3A0cLj7TfSj+zHuTEccDBZbII0gwEWM
         AlkH5Tx5sXrTx4uX6bYABV+EZ5kEDJxRGJv86sAfL4LEntBQy0IQR8Fw4/Tg+WLoDPvf
         9leSFJ+RBFUKMo14GOKOjerblBJTvr0ZO5D1K3NudlSYullwhRAGSD++9q7fPk9T5hqg
         SxubrsDWqNdkPj4C8L9lSQC9ZAwaWFV6d2w/1FFvUg1lEtE3e8Xno4NYXurPd7fdcren
         S+H+khmSDTdduy8TDs5RNhrEDoXItqKZv+OdWddMt/ZRXDdoMxb95UpOlmfSBt/CMA+/
         Wyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732565221; x=1733170021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6W7U/3kNQ1Q21gQ2G25xQVR3qZVJP3a1CLybJY2EFA=;
        b=FW9uKnSELdjo+denFHZoFJwqy/KRVtjd9SagrMVM8GTIGgl7ZGOwktJ/Pl4Cem87Qt
         8RXeJacyIrUHRKCZrD7hPpllwcWMqDcCld9P6sizU+XBg0dHmcsoYLEpTCoNvTkDk4FQ
         2HBd4Sm48sTh3VunAwSYvihHMrRaVvoTRi6zT3bbAdVZfT9IW0VwOUh3YuStXAQSVYZ/
         /XtAR08dRqy49wRyJ+iH33n9tKsIq8ruMXfvWm4/XG+mVg73OAejsVUyJTFmHyPFFbnW
         nb4ZHwCtXUf2J0qxyWkRy+nNxG8cPc+xoyDhTYV3hj5oIpx5RQpjmj57N0m62zT2H0SU
         DPpw==
X-Forwarded-Encrypted: i=1; AJvYcCWN6Bfd5D+OaSClGVdZc9e5uRAPINTvoO39EAjLISsn93e41e407bl4nGmBcSnaFPhnQ1DlK7GXJDa0@vger.kernel.org
X-Gm-Message-State: AOJu0YzLYmOWacgR0jRAOhqk6aztqXeNR1+I3O7W7zV1Y4pQAo0AkSmk
	qRYAk6b8i5ZyRxamvVUQ7kB8dw67n0e6xpuLhOF3EX1/+1Rw5QZ8yCSEaGpG5fEhHwFOXLb2xxY
	sDfu/Dr4gRvOF6e6oueNURTF4vtHHZQ==
X-Gm-Gg: ASbGncv8NIJFhUl3iKnkmPtZzclXQhtuKw9idrib7yo3VbJ+usXDhUVSwk3j7pfZqUC
	n+wkG20zVVaOb4BoZ2Suq9v0/ptrQs4DHILGGMbVC+4+hQpGeXWafP2H8SCVMl659
X-Google-Smtp-Source: AGHT+IHlmfmORdVLbFYWqK2oYXR8My3YrjE+k8loufRbFremEYsS8VJrWjZs3JQ/qeFRkd/bTv3IYdvAoCCLlRM5EEk=
X-Received: by 2002:a05:6512:159e:b0:53d:def2:27d8 with SMTP id
 2adb3069b0e04-53ddef22934mr3024536e87.23.1732565220551; Mon, 25 Nov 2024
 12:07:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107164029.322205-1-marco.crivellari@suse.com> <ubfww55cebjyaur47o2s34qkpcqdmck4zvdx7q47e2tk4bvkwe@xvefnpedopnf>
In-Reply-To: <ubfww55cebjyaur47o2s34qkpcqdmck4zvdx7q47e2tk4bvkwe@xvefnpedopnf>
From: Steve French <smfrench@gmail.com>
Date: Mon, 25 Nov 2024 14:06:49 -0600
Message-ID: <CAH2r5mvkxTUbYYRtqVD9_byuXfiST+Gg1HOXpuz-rgVK8eY=Eg@mail.gmail.com>
Subject: Re: [PATCH] Update misleading comment in cifs_chan_update_iface
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Marco Crivellari <marco.crivellari@suse.com>, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com, ematsumiya@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next (and added the RB to the other three a well)

On Mon, Nov 25, 2024 at 9:58=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 11/07, Marco Crivellari wrote:
> >Since commit 8da33fd11c05 ("cifs: avoid deadlocks while updating iface")
> >cifs_chan_update_iface now takes the chan_lock itself, so update the
> >comment accordingly.
> >
> >Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
> >---
> > fs/smb/client/sess.c | 5 +----
> > 1 file changed, 1 insertion(+), 4 deletions(-)
> >
> >diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> >index 3216f786908f..51614a36a100 100644
> >--- a/fs/smb/client/sess.c
> >+++ b/fs/smb/client/sess.c
> >@@ -359,10 +359,7 @@ cifs_disable_secondary_channels(struct cifs_ses *se=
s)
> >       spin_unlock(&ses->chan_lock);
> > }
> >
> >-/*
> >- * update the iface for the channel if necessary.
> >- * Must be called with chan_lock held.
> >- */
> >+/* update the iface for the channel if necessary. */
> > void
> > cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *se=
rver)
> > {
> >--
>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>
>
> Cheers



--=20
Thanks,

Steve

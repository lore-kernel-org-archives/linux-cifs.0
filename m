Received: from mail-lr2-f35.google.com (mail-lr2-f35.google.com [74.125.230.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB6E34751B
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 04:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790482969; cv=pass; b=bUAimnGCzOVa53yd2JlBnCKvWTffV212JT8L1+ICxQuqbz3LSK+qzcEmgiP20gdycWEUf53PWC0Z7X5AJhRYIL/VWEUJUXBghsh2yjctxwi5bk9SLw9QePjA1zWpDj9et1CcyYTkHYFle14rzY0Ngv/aRzmDs1ixa5n3VTnLB6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790482969; c=relaxed/simple;
	bh=KLSkK6Qg4UAryK/QypN2nQ63MLecaVYHzJbXbDtiYZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fd6aIaZCdHpBmERLgn14lmuBim0WbjHXCuSzL63EAmaU12BT3zbujLxVn5G59ycBmN702HenbRRKnrpxEKWxNYlZ7zJH/lIYw9JlwtI4P51C+uG59bEGrx5xLS/xkdMYzBNLsKbjg5hVE0joXF5V3ivModvdtxx9aej3x0zAqyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=BaiBVVMR; arc=pass smtp.client-ip=74.125.230.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="BaiBVVMR"
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a64dff7acfso18014121fa.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 21:22:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790482966; cv=none;
        d=google.com; s=arc-20260327;
        b=lMS9+11RgWNmMXwtfBdlxjXYzNLoXEE0LpAsFWj8Clndr0vRxIEeNTVwwxXQv9kn2K
         8I2bRNumNwuyGG78bU9elDfTGUY6/KoUhXbwnoVFcImSmKUnRpUla621udOhuT5IJlXo
         65AztddeshU2IRM4ZgEBuXSm4CYoljgAxOS1DaA30J2GJP3MZi/7IRh/8dmfv+o5LmsU
         S4qaCGhTC74lhNysy4p4scs4MtWSNAZmyUI14ZjxMPW2pHeeV8tcBLKNyRA25zo8uIST
         ZMSHqSrpEbQgunMfVRVtP/MTj5s9GUP23i84aoQYaBZwJIREaKUQTQLubPeoI3ebqlb8
         fdaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4hVd4e7MMTnrKqam9M+BnFhXIR0nvvUtPIpD0gRr9bg=;
        fh=EaP78eZVwTiKLqvhJFyaFjKxoEnjTzHdPtTxrG1J1P4=;
        b=DgVUqixc9AeT4rDxXUemN5Wl3cdBsCITHxPKAqYpjWVBpyWENVLn3jxmcfBRyXPJ/r
         A7s1w/80QGKCf7UkJyFCNKenRQAGME/M+Xp2SAw4KTC8QtKWbp5JCXLFyBg5kQJecYlp
         fXN6aCr/c5H659ivi44X4Iu4m2VZBN6tVotYjdO76swuxp7/iDlwWtt5zrAN5SAi9c5A
         pw5L6imPjjOAVv1bgLujDnqhi7NqVMA6KlFwks6eQA0ktvTfapDuD26ED4/Z5Vsb6EJ4
         bOkSGvbaBlKSeqSgvIoSZTSTA3mbz/IH3IVV3xsNMcvOIyPsUV1v6zzZPAASRNnyON2d
         w+9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790482966; x=1791087766; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4hVd4e7MMTnrKqam9M+BnFhXIR0nvvUtPIpD0gRr9bg=;
        b=BaiBVVMRU3n3QH0XSnvuQqc+2NaGSaZzWKIF2+GNz8QLZ7WLj/uNulbnOzyeK/VYat
         gPUcS6hnZhPE29I33DiswgMmUJ29JNfSsJX/YBsMJgjkWbYoN4UhQP4GWPu7ZFZzGLOL
         8Mo3UavDmR8iuf4tWpvGLAB+5LzLrdj1AyVobWe7B91BfZYbWaBqUvhrspkZ0ZW9f2Dc
         ND9Xo6UWG4LQZz1hle2+0r3dl7DQdd3cMx63hFH1FSiobltTgT7dn8zG9FDb/u3qWJpH
         cMsZUw28c3JmpkTjB0gp/2qmXdcVU+yUltIRcNBoO4v90UwJMdGJVCBPFV1BoSh0p/RB
         DcIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790482966; x=1791087766;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4hVd4e7MMTnrKqam9M+BnFhXIR0nvvUtPIpD0gRr9bg=;
        b=IwceJYBS0xNYvfQ3kccpKyLipp8GJdhvtWyMy9pPb+r1VEpdcVhj2ofG1Uzmi1hTL8
         0Jrnr+Mup775wh9X0pB7Eqbkl79WdPSB/Z6ZZOFcXFRx12YI/B1pLWIaYOIZZLxF0Liw
         35gXxr6oc4PyQprAJk2qRPN4FRJEDZcTxng6PwvrrmY1W7v0wN9LytXjOWrZVfWZzT7n
         HVlVN1Bgl6cn9I73U5oYCzBfexqFcTm0XY50ApXyRbiE5GGd2VtaaFSf3ohw8GQuPjt4
         lhmX9d0oHF1gGYlQG+26t+q2Z9G2levpY7TMewBhNBHSTM2PeCKIUv0E71tUBC+NylKx
         XYig==
X-Forwarded-Encrypted: i=1; AKwUvByN8EGsJ3Ax88WpikWWcJOaR6yUCtDQT75SC3gCYqYvKwWrrWIdJlmz1w2UxcjyRjOWNasf+JHKnVl5@vger.kernel.org
X-Gm-Message-State: AFq9FYKtPKRr9wgpmPbD2jz+S7Gg5g3okIborVt8XeXiJuufe3X1HzGg
	GeL69kDL7o7tL8Bgl1s6MqjYs7+PmWIJkqvh9yALnFruCsi0JB3GHF/pw63Cd7+QKvB47Cin8pY
	5NLjS3Pjkff65Ad8fUwugDk1y6MmXRHidzj19ETnGCN0=
X-Gm-Gg: AYBFou1bkF9jdyFFWBqZJaZDreYRPc3zwjyiOC4ikRL7YtBHeko6FCUzMDbTMqnIRiu
	/ssgv+pKn4VmkIt9kHk/aXV0a8/t2EbxmQUAWzOSM8DRDXoeyC8LrZWvHCIR0OvGEN/gGIQEwEm
	B6k5k/jk4KM2MmLrw8b/qc74XnU/9x3wNsaleWw2JcatP+tR6drADA2z5/iEIdf6sSDlROuGQ0x
	5IQlNsEHol3l1m2spgfet8b9iqo0nmRzMvs8sAgX2aH/iWPJEImh6flHtWVrDg+nOM/xpwL1cbr
	1vdUeOyS8uggENhBzuCnRZvl+eMF9Nx2Hdrdcv4OF2oiz4jnHKUtrKWu7ld0w0bdG7ZKATZryOj
	+xYu/huT+Mw==
X-Received: by 2002:a2e:bea2:0:b0:3a4:9e40:d7fb with SMTP id
 38308e7fff4ca-3a63c0cc6b9mr23491471fa.7.1790482966403; Sat, 26 Sep 2026
 21:22:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926132208.23360-1-zihanx@nebusec.ai> <CAKYAXd_T=r4doyNdeykejj4SsJHiK7Fv8aujt-fXACFybUr9xg@mail.gmail.com>
In-Reply-To: <CAKYAXd_T=r4doyNdeykejj4SsJHiK7Fv8aujt-fXACFybUr9xg@mail.gmail.com>
From: zihan xi <zihanx@nebusec.ai>
Date: Sun, 27 Sep 2026 12:22:34 +0800
X-Gm-Features: AclHuK-uSdiQSGbLHm-IaWFaZ_ga-DC4dbueRI0jyMRqGje92KnB5CWXDHu3OE4
Message-ID: <CAANe3eREUFdD8QaviwXTTmpGSF5cu_FJ3C9iHKsE1gpFMmjqeA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: avoid NULL resp_iov dereference
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, dhowells@redhat.com, 
	stfrench@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel test robot <lkp@intel.com>, Dan Carpenter <error27@gmail.com>, 
	Luxing Yin <root@tr0jan.top>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 27, 2026 at 10:23=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org=
> wrote:
>
> > @@ -1111,7 +1111,7 @@ compound_send_recv(const unsigned int xid, struct=
 cifs_ses *ses,
> >         /*
> >          * Compounding is never used during session establish.
> >          */
> > -       if (num_processed =3D=3D num_rqst) {
> > +       if (num_processed =3D=3D num_rqst && resp_iov) {
> Could you please explain how this code path can be reached? Earlier in
> the function, if ses->ses_status =3D=3D SES_NEW or optype contains
> CIFS_NEG_OP or CIFS_SESS_OP, the code checks !resp_iov and returns
> -EINVAL.

Hi Namjae,

Thanks for checking.

You are right. I could not find a reachable path to the
resp_iov[0] dereference with resp_iov =3D=3D NULL.

Before waiting for responses, the session-establishment branch
returns -EINVAL when resp_iov is NULL. For ordinary requests that
may use a NULL resp_iov, optype is fixed and does not contain
CIFS_NEG_OP or CIFS_SESS_OP. In addition, SES_NEW is only the
initial session state and is not re-entered during this operation.

Therefore, the condition surrounding the resp_iov[0] dereference
cannot become true with resp_iov =3D=3D NULL. The smatch warning does not
account for this control-flow and state invariant.

The added guard is redundant, so I will withdraw this follow-up
patch.

Thanks,
Zihan

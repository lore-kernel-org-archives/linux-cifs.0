Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890DF2E2286
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758814790; cv=none; b=B2ziST3yIveXKM7hoTG8EEu8tBC7EtHCDK2nUMHA6ATpKLZxny24ggD2UBgnjOn7cS8APcF/LSeCac4F6p91q9ZAqsXhi/v2Pv4VdTlFVhD+jQDAyXmkWygJ1aerHHi7J4vI3zpIaO5jNhdUCF6UwELmkzJLxYJ8ItgBZ6jzd6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758814790; c=relaxed/simple;
	bh=fcx1xsQ2HV2BsgfD6Y/SkjMcXQLAmOVXzQfm7XG4V+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QrDsAwAjryrmmhjGVIniI/pK2FosLSFIUbO/v0z7QjHXbK4B2Q4oseGanADpB8CHH4TWxwGx7J6ZIGS7o62ZmswTfpUqaNfbbAgcapZDc1Vn2qdEcwmCpCT60Or7Y/rKF1OobPNoqmkEsntJXOCxXo0KWHHj3+l4G0QzWf14x60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hzcdXdGv; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hzcdXdGv"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-859b2ec0556so119620885a.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 08:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758814787; x=1759419587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/gxM2GZ//p3vsM9/c44+z51oZMOCRO2uPq/3cokxHU=;
        b=hzcdXdGvYf5Ug4nt1N55Jr1Qb7mPoptzIRJ6OI+N/LvgcvYajNsmi3CwqOwNNWCg/n
         FoWKOLGr0oB7eWfFTvD34sw5wRmQoHWTaPNMlBXDjJEAVQycGprQpthGEIyQMt7Wfqon
         QAgEQA6sj4fLmEqXhFRlncWk3ElYvgD7BJINo41Q9JbByNUwF28bse/aXWbPvslXSccK
         OMhILsv3k+8ykjUzvIQGFSCo5VJ5ECz3Rd5JOzX9xLYOIIGPROeF/J0+K5zQEDMYPwoZ
         L4dnKWuKLH2cvtJIGSZWLh7K4QX/tx8WH+R/llhvWmSuulYfpGlriXUjAszHS5rKtLzZ
         laxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758814787; x=1759419587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l/gxM2GZ//p3vsM9/c44+z51oZMOCRO2uPq/3cokxHU=;
        b=sjBg6k3jomKs9srAsk9WTv1MOcgz6ZDb5235UyvL71IsMhKmhLdW43wHzhg5ctjFH7
         hdHdYDcq/BPRwj3+O7ZsnDEE7Hr9L7xs2M3LqcOoupjhTyayVet0aQJilaATiPHk2c4c
         PUel8WWBZy2ltH1anF2T22V8SbOMJkVuQesqeixbQE6C4tfV4AIlG0IEIkCWPFuCnnIl
         nyS+9WQmhRHalbYnMNdw9KbS+Bf/zyqwYDyfHCc9lpRoDmxAo64uOyemuBw9cHGoLyR0
         UeSwjfKe51p3+weYip9qc6hIzor6vLqxTJDttrRlcQ+9YVGRGB41DfrX74TyMCGsdVN/
         8PbA==
X-Forwarded-Encrypted: i=1; AJvYcCWY5Tc/dEI8RwaJbOtQuwCit+2v7ORdpQSalBI4FETDeatfi+OCtZl5QbGO1iEI5nnCqsS2iIEnDe9L@vger.kernel.org
X-Gm-Message-State: AOJu0YyZG+Gwz55YEvcR3/ZBPO8V8s+WSK5SApxwUw3+FrRSYWqEkV5w
	9hkfdZvQyOpojAW3Mz5HQNhH6Og4xtRNrdkHKO9wmihXu3rbSMrCaF7KaIcG2sVp0M6Ak5vNbMm
	1bHstTg1qRNAj4Z378/eh9qczXWtQ2CI=
X-Gm-Gg: ASbGncu8bpqFltF9VEkaWQKESregUYqaFgUTs/gWhmnyoGH23vXcfTMIck+rTbMItrK
	dY+TfaP2IAW3W+fT/l6FAK2pPQmuG1/6vVYns9JHBIwk3JpTQyx5+j7tMUi+tGAkMNsjuxYZfCK
	4KrYcylo1FrzC/pm1YazMELXChXrCyofHaDy1StjiBruDI2+TluijYxmgOyR4CXyW/huQ7duzux
	6TN78IJafTU1eXXeYEaf5y/6UVmUqDCuXCZO6+rXvR4McpBXiANm2UGbnXluCQ7bjwJMaS3ZLP5
	unKy2c1sJmqsN04Zn4PZDdDOkNGW6YOcO/DoY6DbAtD1y2NQRfYSAB+wLNk4WNgKtKFgurPexuT
	SPmCmtxHPsrk72LMJPBWqjIb0nMsh8zXG
X-Google-Smtp-Source: AGHT+IES8OpxO46lya6Ja3cpgdYv4JUSL0YgHDVfezBAbW3XrWI16+5dA+Asr6InsRlLJadadFe3Lz5rMdcADr3IL+E=
X-Received: by 2002:a05:6214:3017:b0:7fa:dc54:5e60 with SMTP id
 6a1803df08f44-7fc32001335mr55979626d6.24.1758814787364; Thu, 25 Sep 2025
 08:39:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aNU0D_3x5WC9qBzQ@sirena.org.uk>
In-Reply-To: <aNU0D_3x5WC9qBzQ@sirena.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Thu, 25 Sep 2025 10:39:36 -0500
X-Gm-Features: AS18NWAFD_qjJ50kmUkTB6KYbooErErcY7xLI1bEOzK65no55USKLs4S-XcQjgI
Message-ID: <CAH2r5mt_TXXsrik3HPFBfSOcVm9Azu4Qprj5ps51S5VXGet3tA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the ksmbd tree with the cifs tree
To: Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>, Stefan Metzmacher <metze@samba.org>, 
	Steve French <stfrench@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have updated cifs-2.6.git for-next to remove the duplicate patch
(that was already in ksmbd-for-next), and have updated ksmbd-for-next
(somewhat fewer patches, and he has reordered them to be less
confusing, and fixed the missing Signed-off-by).   Should be ok now

On Thu, Sep 25, 2025 at 7:22=E2=80=AFAM Mark Brown <broonie@kernel.org> wro=
te:
>
> Hi all,
>
> Today's linux-next merge of the ksmbd tree got conflicts in:
>
>   fs/smb/client/smbdirect.h
>   fs/smb/client/smbdirect.c
>
> between commit:
>
>   8c78e78d99355 ("smb: client: fix sending the iwrap custom IRD/ORD negot=
iation messages")
>
> from the cifs tree and commits:
>
>   4e152f2732650 ("smb: client: make use of smbdirect_connection_negotiate=
_rdma_resources()")
>   c0a6d2d41a3b6 ("smb: client: initialize recv_io->cqe.done =3D recv_done=
 just once")
>   d5b264e469201 ("smb: client: fix sending the iwrap custom IRD/ORD negot=
iation messages")
>   8435735745f65 ("smb: client: make use of smbdirect_socket_parameters.{i=
nitiator_depth,responder_resources}")
>
> from the ksmbd tree.
>
> I don't feel equipped to sensibly resolve this today and there's also a
> missing signoff in the ksmbd tree, I've used the version of the ksmbd tre=
e
> from yesterday and will hopefully have the time to look at this
> tomorrow.



--=20
Thanks,

Steve

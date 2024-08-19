Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45C24594D
	for <linux-cifs@vger.kernel.org>; Mon, 19 Aug 2024 05:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724044517; cv=none; b=YGqNxFgEX07z9NhgcyqWqFDXNk17R/++Mh2PwukrlB6XGHEtvG3Z4Oe8iQ2nQJMzYN9IpLTitZ/Oa+wOMGrKi3aMRZWj8aYt7MdOXmB87cVrXpweWGUG+7lZdDJFIjB8oxOaDioRK34S3KxowrW+cOYNT9Mj/BJN2D7quvAeWZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724044517; c=relaxed/simple;
	bh=x2EquB0u6g807jqmTw8hCii+JlO/O8VTNNJo2CtX6rs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=sPqqx+11XPSnSXO2CYpabNhgEhLbKtmOADh/zjYtustHcWRmTRdOvZ2kS2vSM2+5VI0Col4nG79Z1DHChY8KXISfzgaWPjETzzc6P89GzYdWOLW/2X46PmT852Zv9fjljLIHqWuU8aphQWe2CRXZps5RvhdmswfmZfUX56zGyvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3Biozu4; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3Biozu4"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5333b2fbedaso363493e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 18 Aug 2024 22:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724044514; x=1724649314; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJh/1jfR0pIWFiCUDW3vRLyscbs4oylxfWPu0qCf46w=;
        b=Z3Biozu4zxDpE0LPoEiZDnfjnruk7UqHNWMWomcIqbkLLFYv4NfqjOdC8csLv6SuYu
         SCYMiJxandIjE5U7pfLpheixxIawtYx7m3y3qq4Zw2wOJszPrhbkjKayvD8lBEblZPXS
         IkZhv4qTEQzOHW1LMVnQJ2/dpSzq8Ch/TKR4GyIfM3Ft36Cv4UG6tShqYVSHf3aJPqEE
         rchGRFGHWoLlZTijML5ChAzAs8Jg5xCOnpRV6Wf5tClA6BnH/wM/sz1JanA+k3Q5nRTJ
         YrKlgQmYDvfwvbqTlbwT3N5tstoOc6+oPDXrSQsKn/C2HAw3nXFyS50nz7+/AMJDEo/G
         33dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724044514; x=1724649314;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJh/1jfR0pIWFiCUDW3vRLyscbs4oylxfWPu0qCf46w=;
        b=pqgrPkAUpoUo6F0bn5/mN+D9RCIvzRx1BBVXaxbDfFwThktofOO9DxOS9A9F4Dx0Rq
         qKtPcUa++OV60nVjVNtXs2LzJ5qYp9XJrn6+X9Ml8ERcNbq8d/VrQgHU3KYemKeFkrtN
         pqci6XvdqKAyibxvSJtmSswzL8C7F0gcG5UnWo8oFED+t0jJSXm0OuTTIBYmdu8OFHwd
         2dg609RNvMX/7BHcw9ucRGY1aY3hWo2zFMZVvxrYp2W5kkBCgll6VQGUhJJCxUr/Q+nG
         cQ2xK0kGLLBcX4gjOAQEgZPg+cUhBbpdtji9BmlzuBDvqu8ymyPjY1SHh3Gf8TbYKVO2
         STEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWTtvimq33ZaUyT+hoXAEywqSXOeiQKMfcCpJcj3fcJMLOwq7NDRWKz07bz9mtESCRVNh4kWec718q@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+KPcrR1HpVErXt4WuLW2dP796ozKRHII0z4kH6kukzCU1kocR
	3a3MMjOJnj1IeWD3h2uAHWILOhmYT1RunBp0xNpbt0cTT3wJC+Ahu0h/y7BCKZW4i/35Tu6RXRg
	+KkCedhJkgn+Cu9gMCCbAQkwsGaQ=
X-Google-Smtp-Source: AGHT+IGx09COwwfjzM0HCWsLoj2XXUkeKD+cqA0140MEaFpZj3ujGUcohq1MGy7OD6Ne6hnqlrhxeWNEIcXaHRFlgXQ=
X-Received: by 2002:a05:6512:3b13:b0:52c:d834:4f2d with SMTP id
 2adb3069b0e04-5331c69794amr6261025e87.18.1724044513231; Sun, 18 Aug 2024
 22:15:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv3VKSorLBNZUvUrbiOmTFDFw0YDWkL3iRLjaaRmYVTeA@mail.gmail.com>
In-Reply-To: <CAH2r5mv3VKSorLBNZUvUrbiOmTFDFw0YDWkL3iRLjaaRmYVTeA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 19 Aug 2024 00:15:02 -0500
Message-ID: <CAH2r5ms_RiykdukHNefZO2GciuDcLvW6wFhPS37jnrpMtpqYJQ@mail.gmail.com>
Subject: Re: Netfs failure
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Probably regression in rc4 affecting xfstest generic/125

it also happened with multichannel with current mainline, but doesn't
look like it happened with rc3

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/=
builds/207/steps/57/logs/stdio

Is it possible it is related to this patch which is in the failing
(rc4) branch but not in rc3 (where the test passes)?

commit e3786b29c54cdae3490b07180a54e2461f42144c
Author: Dominique Martinet <asmadeus@codewreck.org>
Date:   Thu Aug 8 14:29:38 2024 +0100

    9p: Fix DIO read through netfs

    If a program is watching a file on a 9p mount, it won't see any change =
in
    size if the file being exported by the server is changed directly in th=
e
    source filesystem, presumably because 9p doesn't have change notificati=
ons,
    and because netfs skips the reads if the file is empty.

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b2405dd4d4d4..3f3842e7b44a 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -217,7 +217,8 @@ static void cifs_req_issue_read(struct
netfs_io_subrequest *subreq)
                        goto out;
        }

-       __set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
+       if (subreq->rreq->origin !=3D NETFS_DIO_READ)
+               __set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);

        rc =3D rdata->server->ops->async_readv(rdata);
 out:
(END)

On Sun, Aug 18, 2024 at 7:24=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Do you recognize this netfs failure (generic/125) that I just saw with
> current mainline
>
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
9/builds/106/steps/54/logs/stdio
>
> [Sun Aug 18 18:40:43 2024] <TASK>
> [Sun Aug 18 18:40:43 2024] ? __warn+0xa4/0x220
> [Sun Aug 18 18:40:43 2024] ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
> [Sun Aug 18 18:40:43 2024] ? report_bug+0x1d4/0x1e0
> [Sun Aug 18 18:40:43 2024] ? handle_bug+0x42/0x80
> [Sun Aug 18 18:40:43 2024] ? exc_invalid_op+0x18/0x50
> [Sun Aug 18 18:40:43 2024] ? asm_exc_invalid_op+0x1a/0x20
> [Sun Aug 18 18:40:43 2024] ? irq_work_claim+0x1e/0x40
> [Sun Aug 18 18:40:43 2024] ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
>
> $ git log --oneline -3
> b5e99e6c6dcd (HEAD -> for-next, origin/for-next) smb3: fix problem
> unloading module due to leaked refcount on shutdown
> e4be320eeca8 smb3: fix broken cached reads when posix locks
> 47ac09b91bef (tag: v6.11-rc4, origin/master, origin/HEAD,
> linus/master, master) Linux 6.11-rc4
>
>
> Ideas?
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

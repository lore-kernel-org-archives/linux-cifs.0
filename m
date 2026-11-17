Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794912171;
	b=SX2hxLpRUEoYuZ7zdVeABIkqBIlBQmh/b+sTvW4p3/eYet44mTj/baEs1OvW7q8eYzVi
	 LEyGomP9XaLhL7f6uUJfwCVOXk99VTxLHMlM1uiizdTFdFl59WK9zck0mkap/prD+UoFH
	 LsVgZUXsAZKL5/R+NwdGi+VWSMzJ1Jb2+UbEzaVx0dwI7eOmndHzxJ7IdNIQK4IdtbeQU
	 9sBA9IdQDO3Ap1XSNzTYPUF8J4x5DhNznsialknBcQT6Aj8RXAoio7s5kewpTZQjVtR2F
	 rZ45hqJBr+2vejPCYvzl7nWIfv8HTA2Y7grP5/qqaQrWGPH12blfYcVhTik4lqsrouQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794912171;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2K4xTG4xWSYcGUU6Ck/HjLgjeLHgRelJwDhlANxGeH0=;
	b=kYSkuxlSdu83c5qJDB19lL2CV0sdyJ/2qpwaeOmAbk1NkZ7RmIIaHunPRlG4oYD4XA74
	 nOdqzfRaBws8cpscm0Xpqvd6yZ53t6aQkGwM/9k0so/4trBIGvhkouu1Izrpnqna7LVNt
	 W4++biI/084qvJndaDvlJ6BP/YLMrkUMJfM2tOofwB5eRfGyI3x7EsMs1m8qYfeG9k2rE
	 yvTntw6LZ+gI4qOCWTCyQ5Hv+AxCXQq8/F/deNpHVjpue7NxfLzPdRhcNHhT3RxfNf6yH
	 3AdyrMdlckma1drQy1Cr+UzfeT7QM5TM52LSGs77zNHtl/9KSUc2GF+OOnie/VK2PsQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F9XX7sbB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75034606A339
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 10:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75034606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F9XX7sbB
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-380b40312e2so3326223eec.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 02:42:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794912171; cv=none;
        d=google.com; s=arc-20260327;
        b=TjTJHX+Det4viqOj7+u37yf8OCPEpyx7o6tpBXSKltZuqdy9ADmZz2bmoyaW969kTW
         +IQ5iSUjaWOdoMR4tdkO8um9b9oNUV4c7mdEWlSMwebaPlRUdEANr3TEKTNv+nUJ5c74
         sUZaPIk3bUIhiNUWDuo/13BvENk9GILEDRkbI1jLGryljGjRxaPDHOlveQ+n8D9X1lk6
         FMVjb3t+76aVXw9pVFfg1Mjd094r8pzo8MBeJT+kOdEEm9jri+OvxNTjCYAaBy14CwhZ
         M5hMmC1q4bKAc9H3wDl/1LZBji/+AaShz2Pnu5pCNIgybkCW9l+ga3GtYTQ32XwBTwki
         hSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2K4xTG4xWSYcGUU6Ck/HjLgjeLHgRelJwDhlANxGeH0=;
        fh=wFJHsbsqHEwpFWsr8ou7FvFmF5RG7ne2J0aPNM/Gghs=;
        b=KyLALtXKTpfnNCpNcVqSZlhnY6uKrGHmHsEA2hn9uMimgAliGXmRi+0Tr+sFPJ/GF1
         rQV3wiM/3F4Rj4Iktlra1pI2Rr7OBPhREWLJZ17ycGciR+3aRVYmYQ5jVq2fl1icnzSN
         hRtM/0SHirOMMBQPMBHQhlavmx1ncAtnOzvneHpdaYWwOU7Sy78wRT1WCoUOH25c6dNS
         pW4TiDN60CFjLELVmqBBi9kIRu5W9aLB6J89abd9VqRKxK5sMnA59R/hpzB3fBVZsouI
         tYuYThum4NCqz7/EGX+h0rwaXdJoaZQM4djQ6tvFkDMKrjXTmQyr/ReT0SdVvUZY4/BB
         aFdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794912170; x=1795516970; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2K4xTG4xWSYcGUU6Ck/HjLgjeLHgRelJwDhlANxGeH0=;
        b=F9XX7sbBGR7GouHuWGezLAmbKtVKQHZ8Oeu2iL4zpWJKnROQcZ2s5Cspj+RKbTEvrC
         XQNC2UKsm9V05bFoE1pMpCMiflQ79UjbYv8sA0F3fkR3DQ/GFnWfZi9Necslubvm0Fmd
         WVycYxZk+x+5t3XLyRLFsHdGWIrnC2gMZ9EL03M1K9MFSo9s+tX/kFdBHa8yZLrl+bnR
         KajXAYQY/D68O9Dmj6nGEG7Af61W4spiH2GRp2EQIkQ8QJP924vRlZr+p2HiwQKzqICh
         0solGFlFeLuwRC1mnOv5IECODksGUc2ywzVDucETnhuJuAxM1y7KSRt0D5NBYT9jRN1y
         +s3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794912171; x=1795516971;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2K4xTG4xWSYcGUU6Ck/HjLgjeLHgRelJwDhlANxGeH0=;
        b=PSLU57Vj0TpY91nUU2GBD21/O+DDA5YMa5GC2WdMOdKuHzuTL1rNNSzRYKRNZv+Qdg
         ORJx2FCiSobnjPSKznKqon4V3tows/PHepPoYWmhQfhCjGViKccm5/+lE53VL6hQuXRW
         oj1jBlf4l6jG4jGaoD0S6ZbrQZUo8ZBCvXWzUQ0yrc0Gg7+5RTovIfq+Izg6B9vx/8P5
         hCGILWQS7uz0w8Jv2uTKkE5HEkw4Qm3AVGD68eCWnTMwpdeVl6yPUZ5EuES5xfEcLx/m
         IbGCyABagqI4oWbCcyvWMMajs5ZK4LC+nSzcNtMq3UxyojomQZXccPO/rEkFGnegoUMN
         u94g==
X-Forwarded-Encrypted: i=1; AL+hErFm6fgOf61WhNtJnHhV+wYqc3GruMxpl08nPzBYXCWOo3FewUqGOVG7lariIC9v/xUYTiyIXgkpYTcV@vger.kernel.org
X-Gm-Message-State: APuU4Z+AXhgr0PTI8cFNA4HHWGGVEtvIwG3+/1Ywj7zlfYElmCzs29sk
	7CEGgsAPRL7R3o+RmbbgOaSw8TkPm0fqkvc2z7r0Em9tzEPATNNVv13rrcB6U/b5ucy8pNukMhM
	5ZNmUeG/qeoW1K6d56a8wNl77mUBRMU4=
X-Gm-Gg: AZFdTZezse1piG33aL4z6jrNZXdCAy5Ac9c7bWJieC16X5qyZvilka4T9m5aUl8oxxc
	xTkGt+oDvl+sWB/m82hQ7roazI6cwYA1b8vXSTISWc974fkyqjIuWa3WItqucU7t9YTnCa1Py2G
	P3OPGlHzRehF7fzb5EQdiUbUIHXBwAABMRUaOpgwS9wC26cQYh4cyMStIcgpENaz0luRrDpsoqe
	GsacaLAqjnugw3fVViWSorlEkoA3JPS/IzrKb3irExWzVCX0dThtKcUYIeS8A97SvAmlXLgUrY7
	cgJwitLzeTG8I0ayEVB5HFlU+168kZIMrEcSh3sOdvAV6scc1/WrVrHgAGImkdubPkI3Ki/yyX9
	+w/bUzWd5AYQu2Qrz9Awht5ea9Tb5UyyhtfkDUGgqzja2WVFB3FmY8ZADniwEeES7/pAt
X-Received: by 2002:a05:7301:658a:b0:381:1eb7:938e with SMTP id
 5a478bee46e88-3811eb7b15bmr3003773eec.4.1794912170526; Tue, 17 Nov 2026
 02:42:50 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117042341.4023597-1-hj351016@gmail.com> <CAKYAXd96-RaGbakDedW5eOgmV8JUhAF0_25qXLk2YimiT4wngw@mail.gmail.com>
In-Reply-To: <CAKYAXd96-RaGbakDedW5eOgmV8JUhAF0_25qXLk2YimiT4wngw@mail.gmail.com>
From: khj <hj351016@gmail.com>
Date: Tue, 17 Nov 2026 19:42:38 +0900
X-Gm-Features: Aa3M54qrUz1WablDAXNbu3oc9qupG3hDYlxl8MWwGpKOViJgsXLZVPrlk47_ZSc
Message-ID: <CAGr5VtNX_Fy3PqcxFBVgAxtz2aDbSD_n_HgZK2vOBpj2Bd6UJA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: reject SMB2 read on a file opened without read access
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, I missed that one. Please ignore this patch.

2026=EB=85=84 11=EC=9B=94 17=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 7:35, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Tue, Nov 17, 2026 at 1:23=E2=80=AFPM Hyunjung Ko <hj351016@gmail.com> =
wrote:
> >
> > smb2_create_open_flags() maps a DesiredAccess that has FILE_EXECUTE but=
 no
> > FILE_READ_DATA (e.g. FILE_EXECUTE | FILE_WRITE_DATA) to O_WRONLY, since
> > FILE_READ_DESIRED_ACCESS_LE does not include FILE_EXECUTE_LE. The resul=
ting
> > file is opened without FMODE_READ, yet fp->daccess still carries
> > FILE_EXECUTE_LE.
> >
> > ksmbd_vfs_read() only checks fp->daccess & (FILE_READ_DATA_LE |
> > FILE_EXECUTE_LE), so such a handle passes the access check and reaches
> > kernel_read(), which hits WARN_ON_ONCE(!(file->f_mode & FMODE_READ)) in
> > __kernel_read(). A remote client can therefore trigger a kernel warning=
 (and
> > a crash under panic_on_warn) by opening a file for execute+write and is=
suing
> > a read.
> >
> > Reject the read when the underlying file was not opened for reading.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hyunjung Ko <hj351016@gmail.com>
> Thanks for the patch. The same change has already been applied as
> commit 2fd145f8865b ("ksmbd: refuse to read a handle that is not open
> for reading").
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/fs/smb/server?id=3D2fd145f8865bb1a6c38a3dc68fa44290008789d8

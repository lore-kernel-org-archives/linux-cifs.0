Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6282E3E5
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 22:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714431214; cv=none; b=GJfnz4zXPRGZT9iI5nAIRTu/kzw4346Qmhnxivejw2Zya2x5gbErLxFyGMbfEDGLQV0/U06+eS5jQNDPr/oAVpOMrdtIyr45oDbv0Vp0eHunKlLvCaxQ3ZD9qDyS8sXwvvjRlS+oTQtfqbmE6UfmVxuMtcXNEIwnsAejQnKtRyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714431214; c=relaxed/simple;
	bh=B+nn7rejfSMOi9pnyXQlF9+lad0HzqS+xk6hNvaRABg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qpNRerNbWWylLIWHZn2YJSSHHGweKM1MopmcftgoLKptULLMbkBhUCPbPM8eXgcldu1B2PpKrqwsxA5MKEw0bEQJ9Tq5/XxoWJ6gcvVKwwvJ4fVbU9FGG2mtSncv9NvD77KaS/hO+F5NLelqT7dMnqdJGk15CSKOp8dmkYEL2qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HRzZ4s3V; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HRzZ4s3V"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2def8e5ae60so57705401fa.2
        for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 15:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714431211; x=1715036011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+nn7rejfSMOi9pnyXQlF9+lad0HzqS+xk6hNvaRABg=;
        b=HRzZ4s3V8U6vs8AT/myQNJxLpCugUeT+iohK0SuBR7u25e1t4M0E7/ibyjUmKp57Kz
         sMUXyN/MW+R6GZgStxxVY3fQaIKX+wayeeuPoEVNHlyWsX2YdbvyriZj4Bu+UWibpRgu
         zY9yq3z6kj3uHVeC8BOOWHQGYdbYKaYgitGqGrEkm/OJx/3p8wjB14oLV1YX0SRRetKB
         6I2cQdAo7kf6t4/kzW8hT8LcrzfZczS2MEvwFcuF8d736qj+ltX+ELDqa8+4paRQp/f4
         lgJdkQ4cmb+YgeacAx9Di61DgBi7xkz88mBf1QuUyzpwAJzyDfyQhTERyAJs5Dz0HnP6
         cM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714431211; x=1715036011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B+nn7rejfSMOi9pnyXQlF9+lad0HzqS+xk6hNvaRABg=;
        b=mv3BM8dDpYP9394C2mYgC2C3MQwgW2IFylX6IbrJ/Ban1zKSZf0iY1tL5cECXASvq4
         /jGiotDmRV33VMvIOe0CdK5bzfHhDkceBVn6UVeTMTuiT0pRTnwmwMq95yx95OMGWzIN
         riuyh9IL0gLxeJWfJ6EiYT7oNd+CJkH2jSo/1EgwXPK2AKjm6tCxm7eXfqKCusipLE/9
         /ur9tAB31tEc9mh1PTiFe2RLUySXILUr9S2rmtiNnWWO/2Xkzxwa+jiFH++Ty2wsz8CC
         3Zi5hW0C4Wmv6bGHkRTvvI1BQopzAneVSxG1RWpPngf5NJupVZS7aPY7SViyF3KYmGDE
         GCLw==
X-Forwarded-Encrypted: i=1; AJvYcCWD8W5fB2z/zx2FZvGFKEWmWubrNisOZq545WIYI3BWkRVhG16cPBQK+LqCkt/RtCFwOO60vLd+ugtLh4wRfe37POLaNfABjDvMLw==
X-Gm-Message-State: AOJu0YxZnDF/L0p9VhU25fpE+zjV7e6GWgrf0hS2yCbnHyRycz9Wd6AQ
	icA7CZUMO9P/r18VCcAp7dA62S38/PjXy4/qogfXsDGXw5FJoslcx6x29/9NgiUynz/PC/t044o
	zyJfsIECkHXQTQ8cWJDVdy5F/NiE=
X-Google-Smtp-Source: AGHT+IHSd1VtqaF5oo9Pz/bv3BQCuJdf2vBdIoB4MdeNqaZOYgV4E1kXKdlyXgvDNKRk+U1IF1mJqd669LG4Ne7VBX4=
X-Received: by 2002:a2e:82c6:0:b0:2da:49f2:d059 with SMTP id
 n6-20020a2e82c6000000b002da49f2d059mr6435532ljh.27.1714431211136; Mon, 29 Apr
 2024 15:53:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muXqpZN1mu=WAhaxXe0yRB7Rib_CaoGo3h15wwcSPZFuw@mail.gmail.com>
 <b40a9f3b-6d2d-4ddc-9ca3-9d8bb21ee0b9@samba.org> <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
 <d9f60326-9ddf-485f-81c8-2012b7598484@samba.org> <Zi/8DEo+ZiF24LLw@jeremy-HP-Z840-Workstation>
 <CAH2r5mu2Qr5W1eUOz-JFyf4X6Wk9X2Jr4XFza4tJmH+mVVZqLw@mail.gmail.com> <ZjAHFSxjaYaybUSb@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZjAHFSxjaYaybUSb@jeremy-HP-Z840-Workstation>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Apr 2024 17:53:19 -0500
Message-ID: <CAH2r5mtacbysWjnuDUoTghxPqccp=GzQug1ZE+eRSK=UoqR_gQ@mail.gmail.com>
Subject: Re: Samba ctime still reported incorrectly
To: Jeremy Allison <jra@samba.org>
Cc: Ralph Boehme <slow@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tried experiment with Windows and yes WIndows updates the change
time (but not write time) as expected:
e.g. on adding a hardlink, or adding an extended attribute so not just
Linux that benefits by the proper behavior.

On Mon, Apr 29, 2024 at 3:46=E2=80=AFPM Jeremy Allison <jra@samba.org> wrot=
e:
>
> On Mon, Apr 29, 2024 at 03:16:02PM -0500, Steve French wrote:
> >
> >Another test to try is xfstest generic/728 (which checks that ctime is
> >updated on setxattr)
> >and xfstest generic/236 (checking that ctime is updated when hardlink up=
dated,
> >where I originally found this bug)
>
> Well remember the time tests are meant only to pass vs a Windows SMB3

I checked a few things - but

--
Thanks,

Steve

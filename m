Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6E324B41
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jan 2024 09:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="auhKO1YC"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50e741123acso1549608e87.0
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jan 2024 01:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704446313; x=1705051113; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OA5DUFV9t7B2x2NrgJ53HmKFAwYKOyX/QWR0fQ8p+r8=;
        b=auhKO1YCadtQGftBg/Penz/0cbRuf7WABUi+EFsu3Ugqh1s2VzyLJC2uI+N99L+IAs
         ce1jKE0VCPlyPappX0wGH2jlXg/b8G4kAAgFN0nWL5KmCg7Vj9T5jSPc9zJRf4HePWJX
         +7UbDKBFlqUXcXT/PGl8s9/1CfVe/AJAzi/AKaQtMXN2oqln1CL0PHgk4O5KExA762/7
         J4XrVMdh5DHdcNkaE9GxdqHz6bTamiF15z4S0cbIqWd3MSi3nPjAlQhFhdeYNUucXtSm
         5u9ufwAi/JYJBM4pvm7EFbtlcB86avo7wAXMQZgAtcNjDDaBvWOgoNr+ghXfa4w/mnKA
         opxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704446313; x=1705051113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OA5DUFV9t7B2x2NrgJ53HmKFAwYKOyX/QWR0fQ8p+r8=;
        b=onpZa6Y4s6r03RBn+BVz8v6OM1tmTIa7XbEPSOAiAHFNYW7CJEjwlliJXXBEDjunjp
         rdoaY3j2Z4A2oQltDL0oYL1OJ6Ov+RD0LQhmuBXBvyAK9hYSrhzwwMtfWy9q88BON5ea
         whlgg24YHhnzJmFE3zM5LSRNi5mSsjfMVM981JLkz9l2IzrrAIcl1cc9uuliQWmZfXG6
         P8k7lqnp9Viu6xQv2JW+hjwF1fjPSEV9JYMaE98lDLNWYiV0j1iKIoqZ76MvOrRCbdOB
         xYxPLRKAS0zxBNDiabY0s1xARRmS97m5FMJp/PQc7J3OzNdxzpgzfvdb6qsG9Wpew+0v
         UHyA==
X-Gm-Message-State: AOJu0Yzf1rHc7JJBb+NdEQp8N5LTECEdXvj/lQkYgs72v06fl3StSuqx
	8zq6SghY2Up1jkJybDdT/xRoPtvSBNFoSShb+6E=
X-Google-Smtp-Source: AGHT+IHtLLh+4pplDwoDlvnuVhCQhMlSDk+6FKHoTRYqz/yJHrp8h9Rbbc6AeOjOrp1YDIdDuGoYqZ8M683C4KeZ/Pg=
X-Received: by 2002:a05:6512:3043:b0:50e:aa04:b2ee with SMTP id
 b3-20020a056512304300b0050eaa04b2eemr1124022lfb.95.1704446312978; Fri, 05 Jan
 2024 01:18:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com> <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com> <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
 <095d8821cbafdf3f13872f7e9d7125a0@manguebit.com>
In-Reply-To: <095d8821cbafdf3f13872f7e9d7125a0@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 5 Jan 2024 14:48:21 +0530
Message-ID: <CANT5p=ocORg70HjR0Ek0HdGtafTs=e=8eB-x9vjEgzNvcjkDwA@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing lease
To: Paulo Alcantara <pc@manguebit.com>
Cc: Tom Talpey <tom@talpey.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, sfrench@samba.org, 
	sprasad@microsoft.com, linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	samba-technical@lists.samba.org, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 4:39=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Tom Talpey <tom@talpey.com> writes:
>
> > On 1/3/2024 9:37 AM, Paulo Alcantara wrote:
> >> A possible way to handle such case would be keeping a list of
> >> pathname:lease_key pairs inside the inode, so in smb2_compound_op() yo=
u
> >> could look up the lease key by using @dentry.  I'm not sure if there's=
 a
> >> better way to handle it as I haven't looked into it further.
> >
> > A list would also allow for better handling of lease revocation.
>
> It's also worth mentioning that we could also map the dentry directly to
> lease key, so no need to store pathnames inside the inode.

We were discussing just this yesterday. That we don't really need path
names as the key. It could be the dentry.

>
> > It seems to me this approach basically discards the original lease,
> > putting the client's cached data at risk, no? And what happens if
> > EINVAL comes back again, or the connection breaks? Is this a
> > recoverable situation?
>
> These are really good points and would need to be investigated before
> coming up with an implementation.



--=20
Regards,
Shyam

Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B5E20E01E;
	Tue, 18 Mar 2025 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742309400; cv=none; b=mdpmpYDQda+x/MQwJffSbbMHoxfyM/P/EoiIAf2CBblSpQJDM+dNgtpjHwr4SDyU3QkUPWIbn24KB8msh94jmYY7Cq3rt8Rsp+0CaM7OxWYENcNRfAC+MCuRBPlzfsewzL7XuY2o0D2nWgIpmuTrzlu4M+4PIhTjUOVntmv9iBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742309400; c=relaxed/simple;
	bh=ojwe79lXDc549NuRjE4GGY8lgkydSAa35Rb3ZzF1h5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rZPixamOgCkLYwW0j5DX7R5S4joEt2FyfPeWUoQLJVAp452ATmbi9OnbnoxLgRa03MrpR/qJBrhugy7UY7S2dHOt7WyIddqlnwjyoksrMDb1RVKop8KlgfNg0aWCbKIlfBLkzTCLouUq66dYyW6teLmBh0wQRigpn4xZ1qgV5lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=efeQBD1l; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efeQBD1l"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-30bfca745c7so58882571fa.0;
        Tue, 18 Mar 2025 07:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742309396; x=1742914196; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4eHXb1JJwKi8XY92UdpcdgsAgcnXJDjXq8FHMGreXxE=;
        b=efeQBD1lfvMQl7qkepDv/wvck3LqAbPVlP6H+IkmCas3JTHSmTfBCOfkGgB0+eJUqV
         sq3oPMOCE0v+j5iIUSVKptOK9kMpdxae+91kVD0lhloKvn7QuidlcoHxKlt6VrTnUVhp
         7AUpk5EZPh/kde4kSBcNxdwvktqDdpwZU8HbFCLHU3Ybw13bWQ+hfPemJrOG9FIcF++s
         ak/4kvqJZgkLZJEzFtB7mNV8KDfX/oSJFdCcHxhZv9FINt5CnquXU5JdklYIwgYoCUSc
         Fjdt/BBgojrhwwpNoAFdZ3N8ovIh4AFPN5uApMobusxThKB59zGUh9Cq7LBCrZZjhVXP
         +P3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742309396; x=1742914196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4eHXb1JJwKi8XY92UdpcdgsAgcnXJDjXq8FHMGreXxE=;
        b=uvhKA92xYWEy3oDXuXLsxgtm08ZyeaBI8PZPuYgfeC70iLlBxT5fz8rdzaWw4klDNU
         pdS9ZvYr6EwfsBoI1edsxOX5+XjiiftltxXz+sEySK8AM1dhRYShy1CYIAeCdB7EBFWc
         aLpprwhAPweHrjb3uyjAxVlk9RaS/cYHc3k/H85r9goi/rsY1gG0G9Yau2W8tDpq2W1L
         Q1np7xn0fQZplfZPKjickLL3hl3cX9Ebm0UJLnvBObWOoD9Qqd6UPWK6KNenCrRp0jHq
         KwwKswEtSGIU+ETxn9NO6v5UxtiRZihiYRcynSbxKdT8Hnk8PD/MjA5Qxn5F5mErMVB1
         5xgw==
X-Forwarded-Encrypted: i=1; AJvYcCVVpH7RQfn6LtTUQrrL2qull1UfB1Cz2nf1sTikgAuIxKFq8z5sIv9cfwbuYwB4ou1652jiBp8qiESw@vger.kernel.org, AJvYcCWLt3aMTn0Ys94GlZn+0e8gKxGYZeTOPyeBTyulvCebhUc++Awx4XnbcpG3xyf727YIGGsMXCJQjKvGmTPs@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0x9U4OyU0SqRRO2/QzvB34gons7PaDbG1rdHdEpMby17bqv3t
	gJ3LESzxbfg/oXTaKj14FE2+zbwaXmj8ZhUcrAipRJuZ34OD5XcSEm5PLfrSrZedZgiaB8zaMbY
	/Xs5gCRvHOXZDH4JklXi/8acTIp8=
X-Gm-Gg: ASbGncv92mrbR7vvBoWUrjyi/+toX5pbnQo09uE5+GdztR/yn1ZlwxFk5Os62j509ds
	zzUnGigYr2KJNxcVJtMh/+yeKWx3ZU6vYpcdnqE4IlBS0EXtnDjULecN3Fa8QfPMj2iI1pU/eke
	zUyvLromFPxjO4fqPxVwYEjj/w5q6r5A0Jpc8=
X-Google-Smtp-Source: AGHT+IH09hK0CrkfFyl72Ymld0x3NZIGZ9dWZ5oVaXZJT27nn59ki999I3o9tnuOR/rBdx5gTNoLwLJHRyHSud7cD6c=
X-Received: by 2002:a2e:a36d:0:b0:30b:c5e7:6e61 with SMTP id
 38308e7fff4ca-30c97559f05mr30289621fa.20.1742309396361; Tue, 18 Mar 2025
 07:49:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218143005.1318886-1-wangzhaolong1@huawei.com>
 <CAH2r5mstBkj5-aHcXLpb8YzrDHS+nWhW+i_Kf8eJK15sFmJx8A@mail.gmail.com>
 <c056ce12-2b02-fe11-5f61-ce913b6de5d9@huawei.com> <6ae36cf1-a1a8-065e-d884-fe0810e607cf@huawei.com>
In-Reply-To: <6ae36cf1-a1a8-065e-d884-fe0810e607cf@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 18 Mar 2025 09:49:45 -0500
X-Gm-Features: AQ5f1JoGXRKdUtVIs4RvMg5cTVqczq2w70ZRM9pm-3pDJhklYUNzk_zlQ1qVruA
Message-ID: <CAH2r5msH0-PrzW7rR07cbm99FWTSR4QXyycHLpUaAv9GiDELVg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix netns refcount imbalance causing leaks
 and use-after-free
To: Wang Zhaolong <wangzhaolong1@huawei.com>
Cc: tom@talpey.com, kuniyu@amazon.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This was excellent work, and the test to reproduce the problem looks
excellent but didn't run on the systems I have tried so far - but main
thing I am waiting on is someone who is able to  1) run the tests you
provided and show the patch fixed it for them  and/or 2) additional
review feedback (the namespace refcounting is more confusing than I
expected) and if there is a good way to debug the namespace refcounts
that would be even more helpful

I would like to include the patch - but badly need others who are able
to reproduce the same problem and verify the fix

On Tue, Mar 18, 2025 at 8:48=E2=80=AFAM Wang Zhaolong <wangzhaolong1@huawei=
.com> wrote:
>
> Friendly piug.
>
> Best regards,
> Wang Zhaolong



--=20
Thanks,

Steve

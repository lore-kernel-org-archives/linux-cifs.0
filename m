Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25E72DF68
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 01:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764899460; cv=none; b=ZMsW6XnqHZvGGHvht74isz8KRiwgMkG63OfMoWweKWpe33r3U1mH0+ma8mlsfJZyUDzVVRBMiZPEfktxorQLI2Dd3mJ/ubzuwrtUhnOUxU6+AI84wBrPqV471GefEj79VluFZXBqhrJnwx83DBiGvvVBr/JOeG2qrVh/bcdg+nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764899460; c=relaxed/simple;
	bh=GKZ85sjVo6fkZJThBd2ksRswrgkyI8o9pk/4JuzHZs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LP36RmdTXQ2eQSxTRAwI9tW1ocqvYB0dEBgSnCK5VE9nSjDY1IB7Q23qA5rooYOaPZf7Bdx3FHS15gINaYQVWSA8dD+h1FwY/NjUNn+V2bx5iYoA2gFiYq3rrX11mkakS9fJ7QCU12kyZOWHfUNiPwBk7SShoyQT+QfTDaR4Mm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hVRh1Ora; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hVRh1Ora"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed66b5abf7so27210451cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 04 Dec 2025 17:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764899458; x=1765504258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xCK1oLvsfAV9rMKaWVlDu8TDyOcKrOwM53XWvodg9E=;
        b=hVRh1OraF6W9fKuDQQ7Y98wPON6wR9VxVJJ7lAv6Hzv33jay/lwbwEf9HxrfdJ6+6E
         eXjFHPxm6K2ooj25Y7kAMTerOqDiC+s1ze0Mb2MR2cnr2h7SmSZPmcaeImwkcBwM0T0k
         k16GxBaunMKhyWpeC84Hh3ecIj6B6o1DVIet7mOt3+MJ9Tbh9/+/IBLIiZu6wOl6mjD+
         Ao/485igJjvUPM9tFHmmRofHpPo4mrz2mCXFIjVxT0z0XksDrzWJfjwldyReMCVhgJc1
         ADnGZ11xuvN1Dee3+ZF1ZOzL4zTlxjfg/6DSyWdjCywmKkIl3hfdREWgAHmPMJ53yWL+
         PZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764899458; x=1765504258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+xCK1oLvsfAV9rMKaWVlDu8TDyOcKrOwM53XWvodg9E=;
        b=phxVJRJH2ZUHxD4TSiIhrtDQ3oeV87F5pdJw6VbONQlmw/FSz0bE2+93SRPAuK42QG
         9j9VP0GPWlhqjBf7EbZTpcRXzE4HmgB85DhHBYxl8lwhlMuDv1t5pTLYi37xwwuoFpWg
         0LA2pQfKlkzZbjfL+ZqgVTiUByHykfV4y0CbtLMqRKln43DGGbZf0NV/xToUytlW8sYz
         R5ntTFSRxZDCm/UGW5s8Dmf8rtHD0Z38ZPNhTuT3YEhJN4rSUt0dsUfV4jFHnNaECkGO
         MqAegSgB+mxKGqcxpDLxFVvSC4/0h+YHgIYwMtbQ/3irNojNsFqGGUUgDTCdyHkphga1
         fIsw==
X-Forwarded-Encrypted: i=1; AJvYcCW+fIDka6zZUzYNDIIy+WNNuCxbe7gejmzor9arCVXeT0l9Dskn6vgb/6kvZ60sJy3+a1lMN0iP0gDm@vger.kernel.org
X-Gm-Message-State: AOJu0YzxnrFD/8pmBLoFdxoL7EzvsEwxUjlLZbbi+ACTEBpm4k/NEa6T
	AYrVwCHvK9ezrwC3L7EusKY61r2JQIL6aq1Xd03MfSDl/tRzbFsp6k78sF75tqaWBGlt2TldGat
	xyMuFGxBBN2NTpjQCETtAw0A8QsIGH7w=
X-Gm-Gg: ASbGncuHdRy0tDQRFh8qPWgYaQba55vTYSmpbi9mTmmqrAdIvX6d8wscuMteLjxVByP
	AMyGJBPacXPoiBSZY0YKbg4hi5+sN2pvdcD9+vz5GzQru7hyN/2TvMvqH4ABjeyuDHpI/zE/hVj
	fDQSnCbsE7/hxpo0mNv421Fla8PRHB4x6G2KvagxFrjYYHrCvNVjeoQGuKtUwdOGOVr1aSt7oGu
	ywqvU9OLYwIDK/blW68uCQM4aFARBaRlUQlf2M02ihit9WwSxj0p4ksANj5x2BR+5OBGgFH1CiG
	XsFwZ1caLjIQd4qAzj/DqWyhOvoOEaGrxnb5ACdJvNUQhoLt2TWmfBUHm9oYw6FlcWDlGt+XRxr
	ShB8sgmsNUX2XWEtXXte1z5YR6PSIxJelTB98IwoAxKCrVQc6Kh7GPjpwx52KNI6p7C5vxLUPxX
	b+EJjkNlyKJBn+CwF6vIKk
X-Google-Smtp-Source: AGHT+IFcGGS6XvGFa38qge5rNFESpt5F7GFPExvKmm9WC5v8VE+IMAoc0AmJZuT42gVsBeKSAKvcL82nE+baCELHpoc=
X-Received: by 2002:a05:622a:1902:b0:4ee:58b:72f2 with SMTP id
 d75a77b69052e-4f023086ed6mr92962151cf.12.1764899457631; Thu, 04 Dec 2025
 17:50:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251204045818.2590727-10-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_-ctfkz1E_Sqh0bJMarUE8rDrd2o7yKKa_cOFGPaYELg@mail.gmail.com>
 <5f7758db-cf88-4335-9a03-72be1f7d6b65@linux.dev> <CAH2r5mv74OszZ610pTn+vZq3ubRdx=+au=SHRNFpyt2rigKkYQ@mail.gmail.com>
 <7eac3a36-d2a2-400f-a4a2-7cec245a2709@linux.dev>
In-Reply-To: <7eac3a36-d2a2-400f-a4a2-7cec245a2709@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Thu, 4 Dec 2025 19:50:46 -0600
X-Gm-Features: AQt7F2qwFWpuClgs0CDkuRtU7g9nAss1uRQ53Mte2iewzUS3bh74QKcvZrvcVi0
Message-ID: <CAH2r5mtEmJdCuG_U3fhk66Luf+XN4xPK5T3ozpOuuDOrTDHncA@mail.gmail.com>
Subject: Re: [PATCH 09/10] smb: create common/common.h and common/common.c
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linkinjeon@samba.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, "Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 7:44=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Now, where should common/smb2maperror.c go? Should it be built into both
> cifs.ko and ksmbd.ko?
>
> Thanks,
> ChenXiaoSong.

I am open to other opinions - especially from Metze and Namjae who are
dealing with similar issues in splitting out the RDMA/smbdirect code,
but I lean toward (at least for now) just including it in both cifs.ko
or ksmbd.ko, or not moving the C code yet (just move to common headers
for #defines, inlined functions that are put in headers etc.).  I
consider moving the common C functions into a common C file used by
cifs.ko and ksmbd.ko is lower priority than other cleanup.

Do you have a list of all of the (general types of) functions that
smb3common.ko could contain?  IIRC you mentioned for mapping errors
but what other routines could easily make it into this proposed common
module with low risk?

>
> On 12/5/25 09:36, Steve French wrote:
> > i lean against an 'smbcommon.ko'   - it can be helpful to move common
> > code (headers, #defines etc) into fs/smb/common but other than
> > smbdirect code (where smbdirect.ko makes sense for cifs.ko, ksmbd.ko,
> > Samba and user space AI apps e.g. to use), I lean against creating new
> > modules for the client and server.
> >
> > ksmbd.ko for server code
> > cifs.ko (or maybe someday renamed to smb3.ko) for client code
> > smbdirect.ko for the RDMA/smbdirect code shared by ksmbd/cifs.ko/usersp=
ace tools
> >
> > maybe (as they did for the md4 code creating an cifs_md4.ko so that
> > less secure code doesn't have to be linked in if unneeded) someday we
> > could split an "smb1.ko" out for the SMB1 related code (since we want
> > to discourage use of old insecure dialects, and could shrink cifs.ko,
> > and slightly simplify it)
> >
> > Finding common code is good - but let's not complicate things by
> > creating lots of new modules - in the short term the focus is on
> > sanely splitting the common RDMA/smbdirect code out (because 1) it is
> > large enough 2) it will have use cases outside of cifs.ko and
> > ksmbd.ko).  But I lean against creating multiple new modules in the
> > short term.
> >
> > On Thu, Dec 4, 2025 at 6:59=E2=80=AFPM ChenXiaoSong
> > <chenxiaosong.chenxiaosong@linux.dev> wrote:
> >>
> >> OK, I will create new smb2maperror.ko and will send v2 soon.
> >>
> >> Thanks for your review and suggestions.
> >>
> >> Thanks,
> >> ChenXiaoSong.
> >>
> >> On 12/5/25 08:35, Namjae Jeon wrote:
> >>> On Thu, Dec 4, 2025 at 2:00=E2=80=AFPM <chenxiaosong.chenxiaosong@lin=
ux.dev> wrote:
> >>>>
> >>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>>>
> >>>> Preparation for moving client/smb2maperror.c to common/.
> >>>>
> >>>> We can put cifs_md4 and smb2maperror into a single smb_common.ko,
> >>>> instead of creating two separate .ko (cifs_md4.ko and smb2maperror.k=
o).
> >>> Sorry, I prefer not to create new *.ko for only smb2maperror.
> >>>>
> >>>>     - rename md4.h -> common.h, and update include guard
> >>>>     - create common.c, and move module info from cifs_md4.c into com=
mon.c
> >>> ksmbd does not use md4 in smb/common, I don't prefer this either.
> >>> I would appreciate it if you could send me the patch set again except=
 these.
> >>>>
> >>>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>
> >
> >
>


--=20
Thanks,

Steve

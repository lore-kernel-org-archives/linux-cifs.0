Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF6D1BC43
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720191453; cv=none; b=MHXiEAlUwkJFhzk+tbBpcYh4kr+m7+mwLptr9/xDKzz6tU4+f6eJAHko28HRGj9QPyTiIBHSKBCD4lmhZAk5Pve+GV4nYipLgLa8CRbhUtDjdkE+KQChEUjtywHUVnWkMeCtVdA8ABdyiJ4xcNNxyyntyfno0DrwnlzOWvBfBfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720191453; c=relaxed/simple;
	bh=ZEakZd++EKV50AqEAuKKYNmsd1fs14rzIwCqZWc7xAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ITJ2MdngDSSOJVMOo+qDwOtMlJ6swg7NY196kmcPcjeH7LuWPiW9HulzYPwAynVWAnfuGLF7yptbL0YX7zHwgNeSjXu6fWuwx4hneVQPwiAYPwkRE5RrL1sSHokx0CaALCtuMNZBnxczf3b/JQJR/G5b2TDfK8mS0enB/WXpHKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fHGRzJ5l; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fHGRzJ5l"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ebe40673e8so23224971fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2024 07:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720191450; x=1720796250; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0zs5gW2hExtGyxByTcE1FM0rVEyX+6jWJwhNISP9LLk=;
        b=fHGRzJ5l7G6QnfH8rNPStWQjJRrGkOq2kHKkbiYYP6XlzrexvNTJY1L8tO7IZdMmA+
         HzoZMksKATh9KpmLSlE0fXNIx/T6ahi9Y9lZqPsdcThBcfvmeEniM2UNwT+hG1XYjLu+
         TcjHYNxbu6XOKx4cJCQrKdODWdw8+hnaKB+RGCFDJAMgw+ZPcaH2CTUnBD25e7YqA16F
         x6JaRX/HMDZsf8OW8FphzO0apU1HMfLzLWR5QfBdIVH4b+JiuwL+Two0KpEzbjfLeUQW
         8fOW/Tr9alZbpzHl+xSaYK4Lng249XiqqOvYSgz9zuPlm7ko5UMDp7867Y/TiFxiJCGy
         0mLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720191450; x=1720796250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0zs5gW2hExtGyxByTcE1FM0rVEyX+6jWJwhNISP9LLk=;
        b=cpVGzsXzhqpDbhIRiqyLug496MYXd9QU9JcUHeacP1LOpfuRpDECpuynoF4TNwWwxf
         gSBIF+IFdSXoI2o1Uw3gu/ECGJmERuNRhVenmE13722JJdfYhZt5F2rSyCyVzrrqSwmQ
         H/QKLbMdByomdCsy7+Ts216J9jPb3laRQ6z9lGkojae9ETgxHUvWYtxXx/86u83/bh01
         fIU/ASxNWbOpSajaqqWAse7NRt51YiIPoFSvvSD2sTikc52IANMIFKd3wURPgVkTNOdZ
         BdJNnlsfa+DoWHYxMV//5siSYZ8ZM6CRBWbxiOTGgz2M7Gb5B6Fq95zSj50RFnXFLATm
         uTnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX90PMx+/5ZpbLXlgQbLvV6nI5aoDzvH8JxTjg2FpQyXvN1cUIca0wBCK59Kc30VpkaS7CTwpDzMvG1d19UsHclleVZkfDHJuzTaQ==
X-Gm-Message-State: AOJu0YyJ0xf29jVS9mSq+oo/1GDhHfiL8RhVQbdLaJuSVfSl9xnMh58s
	nbDfWAZ6HXtro3tlFQeV9KPkiN+yOy4cHaDaJdBdVi4egiDhpeBc/32kRkAmsNv94yz2y/dP2cC
	6dzYA2z3CYDPIA5u9wIlN8t2EHDg=
X-Google-Smtp-Source: AGHT+IGW2hz5FZmHBE9LdnJS5QUP/jSd+BhnkSCfduX8rHa55NracpL08nHSukiv3tg6JYbkUKAETHlUMcmLbiUngyc=
X-Received: by 2002:a05:6512:3e19:b0:52c:e3ad:3fbf with SMTP id
 2adb3069b0e04-52ea06bb61amr4854057e87.42.1720191449335; Fri, 05 Jul 2024
 07:57:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
 <20240705032725.39761-1-hobin.woo@samsung.com> <CAKYAXd8=im=ONNCMQB=AQa9VzVGzfq1Qc5Zjn8ks_342JS60bw@mail.gmail.com>
In-Reply-To: <CAKYAXd8=im=ONNCMQB=AQa9VzVGzfq1Qc5Zjn8ks_342JS60bw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 5 Jul 2024 09:57:16 -0500
Message-ID: <CAH2r5mshVSNd3xYvmuhMruHEtBy3aU3bd41oVv=O6Rsf4RnRTA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmb: discard write access to the directory open
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hobin Woo <hobin.woo@samsung.com>, linux-cifs@vger.kernel.org, sfrench@samba.org, 
	senozhatsky@chromium.org, tom@talpey.com, sj1557.seo@samsung.com, 
	yoonho.shin@samsung.com, kiras.lee@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

fixed typo in commit title and applied to ksmbd-for-next as well

On Fri, Jul 5, 2024 at 6:40=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org> =
wrote:
>
> 2024=EB=85=84 7=EC=9B=94 5=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:27,=
 Hobin Woo <hobin.woo@samsung.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >
> > may_open() does not allow a directory to be opened with the write acces=
s.
> > However, some writing flags set by client result in adding write access
> > on server, making ksmbd incompatible with FUSE file system. Simply, let=
's
> > discard the write access when opening a directory.
> >
> > list_add corruption. next is NULL.
> > ------------[ cut here ]------------
> > kernel BUG at lib/list_debug.c:26!
> > pc : __list_add_valid+0x88/0xbc
> > lr : __list_add_valid+0x88/0xbc
> > Call trace:
> > __list_add_valid+0x88/0xbc
> > fuse_finish_open+0x11c/0x170
> > fuse_open_common+0x284/0x5e8
> > fuse_dir_open+0x14/0x24
> > do_dentry_open+0x2a4/0x4e0
> > dentry_open+0x50/0x80
> > smb2_open+0xbe4/0x15a4
> > handle_ksmbd_work+0x478/0x5ec
> > process_one_work+0x1b4/0x448
> > worker_thread+0x25c/0x430
> > kthread+0x104/0x1d4
> > ret_from_fork+0x10/0x20
> >
> > Signed-off-by: Yoonho Shin <yoonho.shin@samsung.com>
> > Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
> > ---
> > v2:
> >  - Describe 'is_dir' in function parameters of 'smb2_create_open_flags'
> Applied it to #ksmbd-for-next-next.
> Thanks for your patch!
>


--=20
Thanks,

Steve

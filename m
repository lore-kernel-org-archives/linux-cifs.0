Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7610031A567
	for <linux-cifs@vger.kernel.org>; Sun,  1 Mar 2026 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772378402; cv=pass; b=hfmEqiS3dfJXXCFdlpUtb0e1OYqo+t8Zd0TtBVgdVk8HOYlswRbQVuUDf0qEmPw5v8yB3b9zqEFEUDqj+/E2UNNWMs64tTaGY4etUUHROLGNAnIWrApA1bdsENaXF4dvdBpRcMVn07PKXZFzxX8E4p/E35zujyQ5IdBnv8/03c8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772378402; c=relaxed/simple;
	bh=Fiwwjp3q58poFbwEi1UnSoyKncjAv5ZQQsyqXdz0VPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rBSiB7M8JPYf7rX7RieXqaWJaMl/XwvC4J0bbTOMBbzMTB3FIpD/C0Ye/YUsNJDxIMCVVPXjfy3QNhXczN/4ZEzlGOnyyfKteEKN5/sfxgTDKdt9KucoB2CjTicJ6zi98ybO+kK5Aq5GrKtrDPJQhuLjaqg9gnvl6+t/uDG7fMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H4sAIl9E; arc=pass smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4sAIl9E"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-56a8d7bb872so3664618e0c.1
        for <linux-cifs@vger.kernel.org>; Sun, 01 Mar 2026 07:20:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772378400; cv=none;
        d=google.com; s=arc-20240605;
        b=J6zpIpuiY/0klAqabkSQVNo18N4BNNrElo8kPZXUZWsWrDf60Pc42FtqaUtK7ek2iU
         mElYyXjGJQZ7/GqhBVkYgxxhgFUtnjeQwiZK/QLlGxsJXzoy+qTX21Jd5pJF1Zc+8INF
         /sq8+JwG82mfidU1qGLD4TVbAAmx4Jg20mp9W9aKvIAfqKo5I7MR64U3lQldmhMUOi2F
         DWS1mgMQy85bcvqBm68zI6Ueh8bHBehs7N7iYsPAiVWAe3AsHZzhSVAj1CSoRMyYkg/5
         MBRgfMSK49kJKuXclKJdIt7xw3lj83MMGwtNFoDVzy4MNyOmvAU1VFTXM4jpQl7/Bp+q
         ve/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fiwwjp3q58poFbwEi1UnSoyKncjAv5ZQQsyqXdz0VPE=;
        fh=zQTIe8TPP5NZKyiz6L5nNjsmWOBw6ksntyUPkUI+ohg=;
        b=dpXPzmkzD0nwwSYamMYcd2EpZ0hgVGcYOR0hMUJrzaGHhwPI38sOn0ygwZCX3fqelY
         EkQNtQ8rllgd3agMUoyR/oBhQL14aY0oRME8LDLoB10iCm4hi8SngPVQCNTqdAdVn4z1
         efHDrY/aSwC843+IbykJeVUTt4O+kufi+WSEWFsej7H70+0+DgQ9sknGpTzpfdjKYXon
         WngZ2X0qafoMPOJQ3bIq59PR4Kq4j+Tnl/XiPtt9lXBXFHmjxAQ3sKeXRXG3zQBAJqgJ
         12BN2UCaARWs61TTX2Ww6dmmskWZ1C7moiE64msRgYc8VDY5xQdaTRinSoP13o+9/008
         K/7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772378400; x=1772983200; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fiwwjp3q58poFbwEi1UnSoyKncjAv5ZQQsyqXdz0VPE=;
        b=H4sAIl9El3DNOjSs6WpoPmMrg64nxdhM2ZU5p6QYdJgq0rtcVMiLtOknYAp3Sg1HnR
         zuEPbTmKD1ahGkEt3CE7W/3H5T9dhJifaqxhoa4FnJIn1ZHEkCrP0KrT0cHSvWzxETnb
         MbQOhGyR7CPg5xgLKg7YKeEJVtdUNLNdy+utBZZbL/Jp+UK/UYfxbYJC/r09iyrQkrq8
         mxKbP0RTNPaULQk5XcC0nqNjCJTCy9r4hOpSX+4eaoRxRsX2lGltWHfOVKOZiO6+5udc
         ZHmxplPmgnjfFEzR/g0/DYxbZ9xUIHWOxlu9NKNyarI58YO2J4A566bqfoxSDFengttt
         GXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772378400; x=1772983200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fiwwjp3q58poFbwEi1UnSoyKncjAv5ZQQsyqXdz0VPE=;
        b=t+CamXofo7i77PgJFHGdAkuVxg0DHH+Yp+jbJWRKSR8rH7Wg0GDvCklXnrf9JQYGcT
         XWtUulNQS08ucY5Eq+x5TCLLNbMH/Q0qY8vFrH0RpspekXyTTxnhBN7k9PrbIi8J9hEL
         JPLugPCisfaNdmdPg5VXF2dBCSUp5OWustVNR+SzLcK3nf1B4BktwoOpH96MrIh8iRPJ
         5uz7ydAmzSHzaQUx5RtM5h/ajZ9TrQ/FiyIC8iBz8Rs5y/cxeb6jtHBoSRxVMlPq3nqc
         Req8aH2AXeP9siPNnnXWhHxNeOt/sujCzXU7v5nnufhHpU1xqmzAr/S/EIB2slyBprDN
         5ZZA==
X-Forwarded-Encrypted: i=1; AJvYcCU0in8nG3Fd3mz4VJiGiKYys48WuKW9NZoWJJckdhyxSjjWu4pBnfuBydkvdAfgK4GufLtThtAM1+HC@vger.kernel.org
X-Gm-Message-State: AOJu0YwQd6QMaxnjhrDOuyTcSfMGnEP03Xm9dzUZA98JAbFP/nybd3Iu
	k1JO0pXBnGdqVZn9f3WGPoNceoUPreEAqmvnGPz2P8X6hzeaXqJUU6X0UDucKAJIebC+ekaUFBy
	RL2R5xXdDWynOAoTCtyXM6eKCyzuYp1s=
X-Gm-Gg: ATEYQzze2GOaA3G5eengk1P1ANQCnRRAUihe/JspMmBVtjG6eG+jxB88prmxeWR+Shf
	oovCNGgmXUitZrQFl4k8KFl/8W6eD/N80YqNU2zmgcbPQ9K1PqsHbpJPXvnL0F6rKTamaa0RDry
	YLsaQtNcbsZiyaaz4KKFi1A+pIzMfTuKRFsx/ySB7vVtNpDSVNT4PgzuuSzOZlchbWFsy2tu0SP
	bJwjNBa+7o9DToC8KOeEKhtgUvwlNTAWNJFHDKeXk/ptR4txtZ1KQJ2ORAHBcQfenSMrEWKv6BO
	fQkrbW8tF8z/XECA6WC/eDHwTvt++etrn9Y6wkfNmA==
X-Received: by 2002:a05:6102:160c:b0:5ff:1981:aba6 with SMTP id
 ada2fe7eead31-5ff31fab9ffmr5005001137.0.1772378400433; Sun, 01 Mar 2026
 07:20:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260221145915.81749-1-dorjoychy111@gmail.com>
 <20260221145915.81749-2-dorjoychy111@gmail.com> <2f430eb613d4f6f6564f83d06f802ff47adea230.camel@kernel.org>
 <CAFfO_h7i86qdKZObdFpWd8Mh+8VXVMFYoGgYBgzomzhGJJFnEQ@mail.gmail.com>
 <ed5aeaa81ad9b87926fa7ebee0308aeb8df9f0ac.camel@kernel.org>
 <CAFfO_h5za6gV99TQS3pwHnf7zyCeVySn3CdRyV+_jFqjovGBqA@mail.gmail.com>
 <beead8bbff344ddfc279e0fc86db0dd5dd98562b.camel@kernel.org>
 <CAFfO_h4brg90tMNp6VAzs5Lo8Lbu=DK2csjDqr2zspOygKEFCg@mail.gmail.com> <73c8ea54bcda0b64093d84fe047914c0632c2d0c.camel@kernel.org>
In-Reply-To: <73c8ea54bcda0b64093d84fe047914c0632c2d0c.camel@kernel.org>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Sun, 1 Mar 2026 21:19:49 +0600
X-Gm-Features: AaiRm51DyMEBRNPI1HVDhCyC4qT7r77uNpEMtKgft97OSaudIMk11BvPwkDJ_3M
Message-ID: <CAFfO_h59LQSjncu_4YE5YB+mt-FL2c1GN-jF_WtoKj1u43DcuA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] openat2: new OPENAT2_REGULAR flag support
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
	adilger@dilger.ca, mjguzik@gmail.com, smfrench@gmail.com, 
	richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com, 
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, davem@davemloft.net, andreas@gaisler.com, idryomov@gmail.com, 
	amarkuze@redhat.com, slava@dubeyko.com, agruenba@redhat.com, 
	trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, shuah@kernel.org, miklos@szeredi.hu, 
	hansg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 1, 2026 at 9:17=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> On Sun, 2026-03-01 at 21:15 +0600, Dorjoy Chowdhury wrote:
> > > >
> > > > I only added a kselftest for the new flag in
> > > > tools/testing/selftests/openat2/openat2_test.c in my second commit =
in
> > > > this patch series. Where are the fstests that I should add tests? I
> > > > think you added the wrong URL above, probably a typo.
> > > >
> > > >
> > >
> > > I did indeed, sorry. They're here:
> > >
> > > https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> > >
> >
> > Thanks! This is a separate git repository, so I guess for both
> > manpages and fstests I need to submit separate patch series for
> > O_REGULAR. Do I need to wait first for this patch series to be merged?
> > How does it work?
> >
> >
>
> No, you can submit them in parallel, but they probably won't get merged
> until the kernel patches go in.
>

Alright. I can look into submitting patches in parallel. Thanks for
all the info!

Regards,
Dorjoy

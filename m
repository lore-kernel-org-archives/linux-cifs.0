Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F4B3D3016
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773075034; cv=pass; b=hpkV3jbE1xUgBiK/F0pS0Ajfu4YYAJko0FphqapJYq3TD1ww3/Ec8QRsu3TVaTdu6qblCT8qJdv8G+R0A/B2kymrcFxlHQxPGwx3LtlyCI7Uy8xLyq6rugz9ncXCOKwUleubD7Nb60JPTWT8ZPvMOPmoSE7Fuin6BJvqnF0nLqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773075034; c=relaxed/simple;
	bh=dElGlCWfTDUCaV3zjXVrwEshlrdMTwzM4Mn069fiLm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Peu//1p6xu3KctojSddy9Iu7xTmegeglWqHR/aF6PYWD1ndUhLSBnYvvcx7cGSizgG5X6o0VXL4/UXX8xK65vtyxmG4AcbaGNCWzCazZP+LpnD82baIR332Be2s+hEsPkgcvJItslGHAgUYnof10VmxewvlgvWpI/zJDWidQ8Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=J+Xuet5h; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="J+Xuet5h"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59dcdf60427so6723181e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 09:50:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773075031; cv=none;
        d=google.com; s=arc-20240605;
        b=HqhSvH5B7iDlrU0UOXc4dDBKMI88laT42WSlSsyzLntr9mIJ+c8H8YoDGjNI6yzOSu
         FY84ncdrD4QP9uakJaA66AI50NUZ9pmY/z2XJ5R9GCdNLUcMlSQ0ZJQ9E29/SwGfoMnp
         XaxY2L2VoFq1VjsmJh1xZT7Jq/v3va7qmgequzhugdlH23JwXGdRUMiXF0oPkMzaXjun
         howBhOTQDkTTf3gPnsc5xBtCgDxoLBkwxn79+o2ktrQYnkg+8t5p+/2pRERDUgKOZbin
         yqvQJ2Lj89AdXJXdlT07v+WOKRwxwccuqVcJKUeF+LNsp1kb0oRHMUCVEPPxKC1jMHs9
         HRfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1qXi97N/dEOi9sir8d8Z87lcT7PElOkZiITQbx2fwCc=;
        fh=Ewq6SN53oHW8wYW1Q+0eeQTttVg6iZzjXlnEx3ArJzw=;
        b=GX3bjxNB1nOLDezFeThkqDrr7bzVqe79O4TwY+xnWBS+bNIwEskN5+5ztZoeV0hkFz
         60oUcVUpNRN2EX2alpMER5gJc/v/NAru16Y2bd2SsahzAjh6niJ18WzEzMjWaKai8AHk
         EQrtGKty92G97d5BuL3M4ph3trn5SgIWfmhbkXqvlhfDDK3kY+H5JPWKOyxp7q0wd3OH
         TzDk96defO76JT5GtcikdoZTdtX7GQzKHk+GXyvoaWywPhJ50wc0Z46LZglwz3/mAY3C
         h3cpxUTHnd16MccbdUeTIJgizC0IkCo2q5FOpZ4AFovxPEjsTbdq7HzMyK5DaBSrDTuR
         52gw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1773075031; x=1773679831; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qXi97N/dEOi9sir8d8Z87lcT7PElOkZiITQbx2fwCc=;
        b=J+Xuet5hbFlie89tCjUFjzDwucKsd4NfrnrH1IlxidGOt/z+KgeLuYLA/G1tJg9YeP
         C1CoxioVNedpRpnH3i2g1e9rvaDLyL/wWFxrMS/dadrG87skwpJ9ll0VXP5/mb7t/tVB
         3nTver45s6YBmiBWLR4SANFDP+bIXXTcsmJ6clYmeEH7meYralZNdoAd1IxF7O6aIkco
         lCWgnoV4P4ikTR0XyXY+GmybQCrbR7LB3OkC8+7VNevH+4CSTtWk0BvwVojn5VB4UwmR
         IhgPtrXLc4SezqZQwBlfIP/+nK2z8AMiJCr0cknaXTC3MvGuBMz8TIpTguJCHWhMt/xS
         SObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773075031; x=1773679831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1qXi97N/dEOi9sir8d8Z87lcT7PElOkZiITQbx2fwCc=;
        b=bZTrZrBUtj1qmCDZoj5DK3L9hh92WPBGW05/KckJYKS+i27V22xYnekcaASHf4pvyu
         abtditB7ZTATu/EUb10F+4l0iNjQ3UedYNQCw1wJFfzWueN3qh1GBA42FB18LHXfob6S
         uyePM7XJDrM/1VvWzkVZiU1WVvFYqpEPOKbAeXDWee327AgDcLD85uqSKqDe2pN8RroS
         txFb9lu9TTTuElt9WHOyuudggJM4Rmeux+8/ILR1ADLg/spbbJPj1+OYhT9ADkVCbWGk
         foRqsP+YQvAUy4DXNeIdDB1J6k7jYCx8X3ctN+LKSbjVQNBVw6WOXyIWCARQbeN34IgJ
         9M3g==
X-Forwarded-Encrypted: i=1; AJvYcCUlnBW9Ukv6T6qIugAGOndoAvVc21PW7HwcSaZBf2if6rFcFZdkt/3WWMI7bgK5jLG8CNDsuSHEhOai@vger.kernel.org
X-Gm-Message-State: AOJu0YySXObgQZYbXKO5QvPzfGVDp9/nfEl86E9b3q6E/7qR951dtv3O
	6ohaybYWVS3HCI2RVQj7xgOJGkQRv5y0Z8oxZt8GRZMdBvY8RWCMY0AR5LA9w7XPt5tCqrsdQso
	XOKTfiAA/iL7ZMKPCKJYdeks+7gSBHdaFC2I55dVk
X-Gm-Gg: ATEYQzyzdUUT6L1KpfbLbIxTjheOPlOUp3Ryt3ONETwrRWubUQ9ZAhiQ8vxHDlTS4Mw
	oSBgM7cFNhHe3FGZZd3QRO+uttOvBHRVwLDjvxgU0aYE9GJnrYBj6ef+HFNozaUmHd8qMrdOzUv
	OGdsa/LP5+l172efqAHiwOe37MBhB9q5oYthQb2ALpL3/cAUiJixPHgzyG8dOwgzVq3DzEybxid
	wX4w+t8UwHcJlpi9NwpVxl46/tgfQmOI6+2JB518Qti+kXm1kmOoNn5/DkuoyIAOmNVGEkXpEdQ
	7WaXwKDnw8TkgEA=
X-Received: by 2002:a05:6512:33c9:b0:5a1:3d7f:8fbb with SMTP id
 2adb3069b0e04-5a13d7f930amr3518616e87.2.1773075030208; Mon, 09 Mar 2026
 09:50:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260307140726.70219-1-dorjoychy111@gmail.com>
 <20260307140726.70219-2-dorjoychy111@gmail.com> <CALCETrXVBA9uGEUdQPEZ2MVdxjLwwcWi5kzhOr1NdOWSSRaROw@mail.gmail.com>
 <801cf2c42b80d486726ea0a3774e52abcb158100.camel@kernel.org>
 <CALCETrVt7o+7JCMfTX3Vu9PANJJgR8hB5Z2THcXzam61kG9Gig@mail.gmail.com> <20260309-umsturz-herfallen-067eb2df7ec2@brauner>
In-Reply-To: <20260309-umsturz-herfallen-067eb2df7ec2@brauner>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 9 Mar 2026 09:50:18 -0700
X-Gm-Features: AaiRm50Rb5608a_d1ziKt7e3a5xZPZu4oB7F4zw8iu_Gm1KsPQukeeL-PdrpHz4
Message-ID: <CALCETrWjb+V-zrMT412MtmgDCx9y8simJBQ7+45C9MtdiSMnuw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] openat2: new OPENAT2_REGULAR flag support
To: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Dorjoy Chowdhury <dorjoychy111@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
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

On Mon, Mar 9, 2026 at 1:58=E2=80=AFAM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Sun, Mar 08, 2026 at 10:10:05AM -0700, Andy Lutomirski wrote:
> > On Sun, Mar 8, 2026 at 4:40=E2=80=AFAM Jeff Layton <jlayton@kernel.org>=
 wrote:
> > >
> > > On Sat, 2026-03-07 at 10:56 -0800, Andy Lutomirski wrote:
> > > > On Sat, Mar 7, 2026 at 6:09=E2=80=AFAM Dorjoy Chowdhury <dorjoychy1=
11@gmail.com> wrote:
> > > > >
> > > > > This flag indicates the path should be opened if it's a regular f=
ile.
> > > > > This is useful to write secure programs that want to avoid being
> > > > > tricked into opening device nodes with special semantics while th=
inking
> > > > > they operate on regular files. This is a requested feature from t=
he
> > > > > uapi-group[1].
> > > > >
> > > >
> > > > I think this needs a lot more clarification as to what "regular"
> > > > means.  If it's literally
> > > >
> > > > > A corresponding error code EFTYPE has been introduced. For exampl=
e, if
> > > > > openat2 is called on path /dev/null with OPENAT2_REGULAR in the f=
lag
> > > > > param, it will return -EFTYPE. EFTYPE is already used in BSD syst=
ems
> > > > > like FreeBSD, macOS.
> > > >
> > > > I think this needs more clarification as to what "regular" means,
> > > > since S_IFREG may not be sufficient.  The UAPI group page says:
> > > >
> > > > Use-Case: this would be very useful to write secure programs that w=
ant
> > > > to avoid being tricked into opening device nodes with special
> > > > semantics while thinking they operate on regular files. This is
> > > > particularly relevant as many device nodes (or even FIFOs) come wit=
h
> > > > blocking I/O (or even blocking open()!) by default, which is not
> > > > expected from regular files backed by =E2=80=9Cfast=E2=80=9D disk I=
/O. Consider
> > > > implementation of a naive web browser which is pointed to
> > > > file://dev/zero, not expecting an endless amount of data to read.
> > > >
> > > > What about procfs?  What about sysfs?  What about /proc/self/fd/17
> > > > where that fd is a memfd?  What about files backed by non-"fast" di=
sk
> > > > I/O like something on a flaky USB stick or a network mount or FUSE?
> > > >
> > > > Are we concerned about blocking open?  (open blocks as a matter of
> > > > course.)  Are we concerned about open having strange side effects?
> > > > Are we concerned about write having strange side effects?  Are we
> > > > concerned about cases where opening the file as root results in
> > > > elevated privilege beyond merely gaining the ability to write to th=
at
> > > > specific path on an ordinary filesystem?
>
> I think this is opening up a barrage of question that I'm not sure are
> all that useful. The ability to only open regular file isn't intended to
> defend against hung FUSE or NFS servers or other random Linux
> special-sauce murder-suicide file descriptor traps. For a lot of those
> we have O_PATH which can easily function with the new extension. A lot
> of the other special-sauce files (most anonymous inode fds) cannot even
> be reopened via e.g., /proc.

On the flip side, /proc itself can certainly be opened.  Should
O_REGULAR be able to open the more magical /proc and /sys files?  Are
there any that are problematic?

--Andy

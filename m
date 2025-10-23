Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9986926FDB2
	for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 18:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761244227; cv=none; b=DfYA02AN7pGvApNnZu/VtqctGYPvCvB3Lwv6CWYQmAKlvMATbOUc62MLB44sNX1CqRs9Zw15wLKYnVooeUX8WIScRFPOlmxBbUXFZ2eh9vKyg2pd+yyRfqB8zVHMsSxtZrJaKMd/zYCGaw/gUSHXkAFVO1t9s4N3B4ISKBa1Kvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761244227; c=relaxed/simple;
	bh=ZhMJ5wUthaGV0soNI1et2e4q0m3TRX9gku6Brym7RUI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uEwmEv9jP0OpUeaWIXECSlozRu8Vt7pt7HqDn/oEPQNGGOAeN9mMaInvlx1kqVM5iNAKvNvKb1/RKAAvFmEbPHM5Ul7Kt+6o6+wbvF2BKb379dcxLt8T4XgbTmBjyISyQrQl6ngFyLLH8ybQNt3A5XYKix39wbHoFhkYCSbdAF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=poochiereds.net; spf=pass smtp.mailfrom=poochiereds.net; dkim=pass (2048-bit key) header.d=poochiereds-net.20230601.gappssmtp.com header.i=@poochiereds-net.20230601.gappssmtp.com header.b=ZPdvYW1E; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=poochiereds.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poochiereds.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=poochiereds-net.20230601.gappssmtp.com header.i=@poochiereds-net.20230601.gappssmtp.com header.b="ZPdvYW1E"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-785bf425f96so29080697b3.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 11:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poochiereds-net.20230601.gappssmtp.com; s=20230601; t=1761244223; x=1761849023; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:to:from:subject:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YY9QpXRP3fXk3qzJOM3vvsk190hNIv6rH8fZQZ1Pmv0=;
        b=ZPdvYW1EsAJcUxWQNiC2CREtajBaVuJHeOz5Z6p2DD6zJDAG93mEF71ZU71/3iPUKD
         g7amP1WFqiCtn/0JiLfd9NSyTKD4L2zfknKJH7aYk0r9h20awdK+5Wp+ohfgCRPrkJ7v
         a+4EMcugkGxlw9ywyalBU0RfXs6NI5uhfnD72qOhggJBLFBGqKqGR+rtdaGD8B8GGZBD
         Z1LNL6b/5rYxX3kqNaxghQNz876uj4mCjcw12UOytfecJt8BgKsY0xX9BmI8Gv5omYwj
         2At6/I5v68vaSrW2pVT0t/hyc4bfsjR76gMjCfyVCVt2WIiDUjrOYgsczeh2o7pLtxlC
         gRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761244223; x=1761849023;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YY9QpXRP3fXk3qzJOM3vvsk190hNIv6rH8fZQZ1Pmv0=;
        b=JDxiyISpzetdIPNL5i7sQZT2eRquy/711l5IyUq65C45fSjbhvm86ceasKnEfILOHg
         PGwmefDNzzXca5+LneDjJMyPoWAzM+XLby+oRFUe32jabWn4LzOiGKENR5UHNqc15xAI
         ZDLWJVrhWRkjccaAe72HjO8xRbcyYFO6jtNbgX1BgnCSyL1H/rT8nuL5O+KqXZC07Ev+
         E1C6S83D/wrvxZ27kZ7f/g10zMl7T/IF0k+c63lVrsLNOxbhPggp8XDSXvenA4doCC1B
         MJWpcttWefi52/Ogq2yb9+bLt4X56kzwB99rOXmZ8QXSH+AqA6W+FPNvIPtPaMbE8JvD
         fr4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUtty/jJZ/rVWohNaqWN8Hh7wcd8T1UoFteqn9Ne7EUg06JuNM3tvCrE2q+D+6FuFi477/iG7eF2t7u@vger.kernel.org
X-Gm-Message-State: AOJu0YyhWshYLK7EZONPq8PMA6Xfxy2/3R1v7vI/gpEUR4vTQXrseo5J
	fCnbHMk0cRaQZSvebjD0JCMsqsBidsKIRTDWMm7/0M4MzB15zOy+MxIvh0XRy7ICtsg=
X-Gm-Gg: ASbGncuEHakiJECb/hgv14vA+UjEjRu3L7Dodpujf4Fgn7rPjKDsX0MZUuooKXX70Fj
	imVuBUrUF3zb3LerDPHXxxgd6LjDvr/dsEJrqf8o4YKPMs5esIlF9fqZyHlCY1mjdm+75j9tsVA
	AFUT3XiaJxWV5bGQOFXUxDIUJD89r4OAekbt67gKe5UA18lxnGhozjUxwT9HYrXEr/GlCBbhEga
	vgVwCtimYC8xmNav+l2CiEy/POPTJgyEiGAWfLzrWT98Iu4dfpL83Bsa3M1qlAet9iighxWw42h
	7xutVz9lEY3ZGvctmPymSyulOdzOqdKBUekMf90dwC1ahEaQ+mQoeDQylZgUqz2n3q4JM8Ul3ud
	EpuUVybWdG3bH60sblWMc6n2YC8iKzxYLZ1RnVnegyeeE6ClyPY07wJMP1+mZw9L6f3hlPQtu2e
	RL0S8SCRL1PDG8PD7ovQOO02WgfSUNpGXaWHfpuzeGLanIf5BvQVwTpoU7d5VNuXViotMnmA==
X-Google-Smtp-Source: AGHT+IEvPp0qQqZxqoRvzzDOvNL15MvprexUMYWG352IrI3st/sSoHJL4oWhGS9akFzU7Tbrpt4mLA==
X-Received: by 2002:a05:690e:400f:b0:63c:f5a6:f308 with SMTP id 956f58d0204a3-63f2f69c168mr4521838d50.31.1761244223404;
        Thu, 23 Oct 2025 11:30:23 -0700 (PDT)
Received: from [192.168.1.177] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63f378ef44dsm852272d50.7.2025.10.23.11.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:30:22 -0700 (PDT)
Message-ID: <b4ca017bb466fb11dc60c44d5f45cee4974750d9.camel@poochiereds.net>
Subject: Re: Use of cifs_sb_active and cifs_sb_deactive
From: Jeff Layton <jlayton@poochiereds.net>
To: Shyam Prasad N <nspmangalore@gmail.com>, CIFS
 <linux-cifs@vger.kernel.org>,  Steve French <smfrench@gmail.com>, Paulo
 Alcantara <pc@manguebit.com>, ronnie sahlberg	 <ronniesahlberg@gmail.com>
Date: Thu, 23 Oct 2025 14:30:21 -0400
In-Reply-To: <CANT5p=oZ54hSkVL7-_oRQgN0FHxPKPoivgBD24sjNExT_HdETA@mail.gmail.com>
References: 
	<CANT5p=oZ54hSkVL7-_oRQgN0FHxPKPoivgBD24sjNExT_HdETA@mail.gmail.com>
Autocrypt: addr=jlayton@poochiereds.net; prefer-encrypt=mutual;
 keydata=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
 q/2QWqNFB6xOBr5rQ5xwl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-10-23 at 22:23 +0530, Shyam Prasad N wrote:
> Hi all,
>=20
> Does anyone remember why we decided to refcount superblock using
> cifs_sb_active and cifs_sb_deactive whenever we actually need to
> refcount the inode?
>=20
> For example, cifs_new_fileinfo calls cifs_sb_active and
> cifsFileInfo_put_final calls cifs_sb_deactive. Similarly
> cifs_oplock_break does the same.
>=20
> A side-effect of this is that when file closes are deferred, cifs.ko
> does not get the kill_sb callback from VFS during umount. I think
> umount simply dereferences the superblock and returns success. It's
> only on deferred close timeout that the last handle close drops
> reference on superblock to 0 and that causes kill_sb to be called.
>=20
> Based on my analysis, most of the xfstest failures that we see today
> with ENOENT or ENOTEMPTY are caused by this issue.

A little bit of git archaeology yields this. There may have been some
mailing list discussion around that time, but I don't remember exactly
what the original problem was:

------------8<-------------

commit d7c86ff8cd00abc730fe5d031f43dc9138b6324e
Author: Jeff Layton <jlayton@kernel.org>
Date:   Mon Oct 11 15:07:19 2010 -0400

    cifs: don't use vfsmount to pin superblock for oplock breaks
   =20
    Filesystems aren't really supposed to do anything with a vfsmount. It's
    considered a layering violation since vfsmounts are entirely managed at
    the VFS layer.
   =20
    CIFS currently keeps an active reference to a vfsmount in order to
    prevent the superblock vanishing before an oplock break has completed.
    What we really want to do instead is to keep sb->s_active high until th=
e
    oplock break has completed. This patch borrows the scheme that NFS uses
    for handling sillyrenames.
   =20
    An atomic_t is added to the cifs_sb_info. When it transitions from 0 to
    1, an extra reference to the superblock is taken (by bumping the
    s_active value). When it transitions from 1 to 0, that reference is
    dropped and a the superblock teardown may proceed if there are no more
    references to it.
   =20
    Also, the vfsmount pointer is removed from cifsFileInfo and from
    cifs_new_fileinfo, and some bogus forward declarations are removed from
    cifsfs.h.
   =20
    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Reviewed-by: Suresh Jayaraman <sjayaraman@suse.de>
    Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

--=20
Jeff Layton <jlayton@poochiereds.net>

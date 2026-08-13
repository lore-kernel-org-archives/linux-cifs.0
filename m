Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F304582F9
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 11:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786619047; cv=pass; b=XrUqtA/t3nrXWnTCoJB55sbiBqJeP84pZ/a1Y8JCX4q+V0M7G/u70dqOb8oxL5qyE4MJq8oN+8nAOuTFsngwVNnumwnSwRGOdmjgQMNzF45h6sKYJm/u5+b6ax3lmBAKNE4P6HgCVUnf7WV1mInSl8qXD2unAB559ufmGAcJCu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786619047; c=relaxed/simple;
	bh=7Uwv7tb2m6XBlcVnMyX5oVZ/e0v1RgQ6b1inrP4xFhA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sfR6O9TGigf2YnHd/+U0ZYSMt7VQTcM7L6EqUqXteEvjZjwMC3Gasix3O8TgEtuHsrk1nWCVQMoVg1WCJ9oeelcfZN0av1UNJwj0xqF0pw0P3IWBqy+a2IQWWFkaflRT6WX+pjqD8BJDJLRifBFhO7RDML/Maa9Aevj1BAeoEjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=biBr94OV; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biBr94OV"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-529a1ee0e62so11652851cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 04:04:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786619041; cv=none;
        d=google.com; s=arc-20260327;
        b=aOw7lWLZW+MRZEaZoGlZCouhQgDO6YhnM+vQWmjPHh0d/wPxywaME8BtIvzmqZHmnC
         sW9wfF3c9bKrhAB3vrTeC8m5XtTPLp4u1YazfeUHs7bBhlGziGL01+A8FnHWnHEkF8u1
         uxlr8iP3RCZ4HHx2oWmWb+Bvz02GstPb5Wxd8zoOE1hte+H6nG09PcK1QRxHWM1giOYI
         Q/5tgaxWQFZc+4QQfcQFN+QQ3mp+oIj/KUoKria5ZewgS6afxEA1Y86Z8dI86qZ4idJi
         rOPrqaWU0m+nAnupyUBedVMGfFaNP3aZoiwwgQmCwXLXQg3aDV9M2jVAu/yO/7fxPClc
         haCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zS9Fokv9z/PRsW19bVpka1f5kJN7Z3+rhOrsdyV5+lM=;
        fh=5m10eaGjQa0JShq+g957OIaigkoV6eEifR9p2X1PjzU=;
        b=KjzMuFfHWysfRuPZg94PC3Bg7Y7UW0NqyV1ExfknCvaSTKLcNKNC39ZJqOmwSfxX+H
         EJwRhS8MlwaStVGopYmtCZWHB6pWvaLMCHFfffG9E2u1LD4z1v8C/oetc+KOJxRFR8Dc
         nUuk4DuHlF5BfzTeKx6YN3MNGWncpjZTTE6qe209MTmSJhT4tHrZNmz4HcIdROj+YAyq
         K/jFDbzsc780E1gkykpFr2YU1jhoEdygMP8aZ7JyYgzeDP8E8QnFx4TXd57tRSDRSmK2
         4o0NN7kIJSww7+84mVVWoFEeAwdeocGQlZrYEVic6i5PGVACxu/WT8bfWDPgV+lxksE6
         de2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786619041; x=1787223841; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zS9Fokv9z/PRsW19bVpka1f5kJN7Z3+rhOrsdyV5+lM=;
        b=biBr94OVd984mBmbtPct5lLNCKETVY+hkykhtESNL3XdWd7RpibSDp54ep81NNHLqG
         xedpy4h8C4Mpcq1AdcCB5CYYpTqRRSQsbUkX4PTEYMkYVkQj4LMJZxhAPFlInra75woi
         zGFMGBqdQVOOK0dN/naDi92gHHGIuGp5dHywP8WulyaYBMj8AXIrlXIw0pQ2V/WI7U92
         8L9T9dqaTHHveSBFoEynXtpOHxX+hRYUJLSkxzWURA65XZKRDkDch+sWRdS6PP1r0vWM
         Ac7IhS69ta+ucsE2n1NHRMIkNdXFDs79RH498ldnMHfVeoWAft1ms8P2ypFN17D7cyR3
         F6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786619041; x=1787223841;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zS9Fokv9z/PRsW19bVpka1f5kJN7Z3+rhOrsdyV5+lM=;
        b=rugA5zA6yJmYPkbHLMRwIOaDIExWEEkp87Mh60ar+S3tj+b6ZUAEAqnhTSc8lTiEga
         Voqlmu14ICH+n/rXWfCzzpMkhWfiYQ00kD472SMDoB9WxLBk/Mn7b/DrwGtCQQjcSXw4
         KUnur7leZ0hUh1+HCOcAO2oxQPgr11YiBJQgz/ZD+3BG+u31rQyYbZ2RrBay66wiRb/p
         9yobnlHBeDydU7j+8XHR0ExnMvxeT8FvHz0X+uYNCQh+46oYZIm2OMVafXTsaMBmxbkE
         9g7ZEPFHkJtunRG6MMGs4Ob/QluEJNSZXFfW3dmpre5jgpPjyqKT08d5axKcN8eSerwv
         jpwg==
X-Forwarded-Encrypted: i=1; AHgh+Roum2Z7OvvFhNswyzOJfHEY/vha154sPUkGCNKCogU8jNPcGkMJ9N784+kTIJuNHwppBAeW4FXcM+Tq@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdh5D3QoNZTwMNH5zRXDICiHwlYvoBjdBSRdaJCEEnOrPsRzCZ
	wcUSdzEZohU8CLZ+qP7CjuZcmQ0+/k1MPEwpfFyYKO3yJ45ooweNedBgE06kV7cXHdvpW3w1kwc
	Srj/nUDgILqfGujAWdvGiCVi53DazTVo=
X-Gm-Gg: AR+sD10r7p9i3wrqdaryKRQ9PgBqFyL3lHgwYZ9GdutmrEQVu7lGrnIHc6oweZ7whdg
	FcOqtpZEER8zx6GCDlhC9JpiRUz5jwBfk1DcvHgZdFLZjh2kAWyJM1m6Otu0Juvn7Tb2Df1eABA
	iiYVxWe7i9wHyY+rQJeB0SwDTYbH+S+eZ/iiVRJOea0DqLIfQ9JmtFBRDLBaGUlKYU2mxc8SNqW
	5we+/u974XyBRXzEmQufVb5N24z1JMo+y6bagvWb7UTml8ksX72QTGxFuuZLceRaOTElkmZEl23
	ifIMc9ZMTbwwyc9G23K7rCuVFPEBCwuVjsEUaIS4J2Zowyj90IVe6MuVuctG1LZO9G/dj/PLL00
	fhs65aKMcyI8XqReSj6wwcutFXJby/BsDyJ1dfXE=
X-Received: by 2002:ac8:5a04:0:b0:52d:41d0:89e8 with SMTP id
 d75a77b69052e-52d73d3911fmr48311251cf.33.1786619041056; Thu, 13 Aug 2026
 04:04:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com> <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
 <9ad355b5-5ae9-4dc3-98d9-cf46795d877b@chenxiaosong.com> <CALT=-87Ziq01X+GLYXpOMThBMC6gcFLV3uaP1qy+k_vM6G+-AQ@mail.gmail.com>
 <76c86e67-23f4-457b-ba9b-240ac424beee@chenxiaosong.com>
In-Reply-To: <76c86e67-23f4-457b-ba9b-240ac424beee@chenxiaosong.com>
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 20:03:49 +0900
X-Gm-Features: AUfX_myUaU_YYAZBz_JF8r4sId7DF5mZq6shgmBcpdpwgoafvmirqnC7ZLASsco
Message-ID: <CALT=-86u8tvAZpiLbVQWc=Cadic1p7Dg+a_AnO0tShYWQS2UoA@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> The UAF issue is reproducible every time, and I have already submitted a
> patch to fix it:
> https://lore.kernel.org/linux-cifs/20260813104042.170080-1-chenxiaosong@c=
henxiaosong.com/

Thanks for the patch and for the credit -- but I think that is a different =
bug
from the one I reported, and the fs/locks.c:312 BUG_ON is still open.

Your patch fixes a proc_dir_entry use-after-free in
ksmbd_conn_transport_destroy() on module unload. Mine is a BUG_ON in
__ksmbd_close_fd() on connection teardown, from a byte-range lock whose
file_lock still has blocked requests chained onto it. Different file, diffe=
rent
path, and the reproducer for yours is mount/umount/modprobe -r rather than =
lock
traffic.


Your "cannot reproduce on ksmbd-for-next-next" run sent no lock requests
-----------------------------------------------------------------------

From your earlier mail:

>  LF_SECONDS=3D10 python3 -u lockfuzz2.py
>  t=3D5s locks_sent=3D0 faults=3D0
>  t=3D10s locks_sent=3D0 faults=3D0

locks_sent=3D0 means the harness never got a single LOCK onto the wire, so =
that
run cannot tell us anything about whether the bug is fixed. It is the failu=
re
mode I described in my previous mail -- sorry, our mails crossed.

Two things on ksmbd-for-next-next stop the harness silently:

1. smb2_check_sequence_number(), added by 9d597c4a23 ("ksmbd: recognize
   replayed SMB2 lock sequences"). The harness authenticates with impacket =
and
   then emits raw SMB2 PDUs, and it used to start MessageId at an arbitrary
   value. That is now outside the connection's sequence window, so every ra=
w
   request is rejected with STATUS_INVALID_PARAMETER -- including the CREAT=
E,
   so no file is opened and no lock is ever sent.

   One-line fix in kfuzz2.py, in Sess.__init__, right after connectTree():

     self.tid =3D self.c.connectTree(SHARE)
   - self.mid =3D 4096
   + self.mid =3D int(s3._Connection['SequenceWindow'])

2. "max ip connections". The harness churns connections from one address an=
d
   hits

     ksmbd: Maximum IP connections exceeded (32/32)

   after which it cannot establish sessions. Add to ksmbd.conf:

     [global]
             max ip connections =3D 0

With those two changes the harness reports a non-zero locks_sent, which is =
the
thing to check before trusting a negative result.


With that, it still reproduces on ksmbd-for-next-next
-----------------------------------------------------

Branch smb3/ksmbd-for-next-next at e7317f3e41 ("smb: server: Clear
Preauth_HashValue in smb2pdu.c with kfree_sensitive()"), re-fetched just no=
w to
be sure it had not moved. fs/smb/ built from that branch against the same
7.2.0-rc7 it is based on; I verified the loaded module was the branch build=
.
Freshly booted guest, kernel otherwise clean:

  test started at uptime 120 s
  fault at uptime 121.6 s -- about 1.6 s in, after 142 lock requests

  kernel BUG at fs/locks.c:312!
  CPU: 2 UID: 0 PID: 1575 Comm: ksmbd:::ffff:12 Tainted: G           O
  Tainted: [O]=3DOOT_MODULE
  pc : locks_release_private+0x214/0x2c8
  Call trace:
   locks_release_private+0x214/0x2c8 (P)
   locks_free_lock+0x20/0x40
   __ksmbd_close_fd+0x4d8/0xd28          [ksmbd]
   ksmbd_destroy_file_table+0x5c/0xf4    [ksmbd]
   ksmbd_session_destroy+0xbc/0x38c      [ksmbd]
   ksmbd_sessions_deregister+0x450/0x540 [ksmbd]
   ksmbd_server_terminate_conn+0x20/0x40 [ksmbd]

The taint word is OOT_MODULE only, so this is the first fault on the boot, =
not
fallout from something else. I have seen it three times on that branch now
(142, 208 and ~200 lock requests), always as the first fault.

I also re-ran the mixed load that produced the KASAN use-after-free on main=
line
for 500 s on this branch: zero smb2_lock use-after-frees, consistent with
c120970353 having fixed that one. So on ksmbd-for-next-next the lock UAF is
gone, but the fs/locks.c:312 BUG_ON is not.

Happy to test any patch for it.

2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 7:44, C=
henXiaoSong <chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> The UAF issue is reproducible every time, and I have already submitted a
> patch to fix it:
> https://lore.kernel.org/linux-cifs/20260813104042.170080-1-chenxiaosong@c=
henxiaosong.com/
>
> =E5=9C=A8 2026/8/13 18:17, Blue bird =E5=86=99=E9=81=93:
> > Yes for the BUG_ON, no for the use-after-free. Details below, and I am =
inlining
> > kfuzz2.py at the end since it never made it to the list.
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>

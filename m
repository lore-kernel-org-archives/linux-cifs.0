Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EBD415F2E
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 11:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786620020; cv=pass; b=kVA3HqmLTh8XQ8jbD1BFaJGD0K9iJxd1Qz7EbPxdecGE79zLfPW4wtw5odEW6fDB5xyRE0d788qu1iTehv59dzFOjCAreoi7pi27Lc8Ufltg1J4M9ZfMDYxQQAWUxzwlAjVmgwrHcwBoREfnDBgIH53ZLKFjs1DgxuDnNjD4W0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786620020; c=relaxed/simple;
	bh=qLcTugXfqWxIos+/9YOQucar0dbKXKnMb/wp3wpUxyw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rU5myRT6Bj2gF9/+ZFhJ0xsrt5EEGfLl8Q4R7r4fsAu1vyQWtPQ6FltJT4z3T7BB2c4cO5gZF+9+jNzx16XuiUiti+jRVB7Ld4fX3r/v9lFTsJ+F54wNRW4pr9CD7uQ1B9w+PaoHR3J8I8i3RcLO9Xa1N/NDCmVKtYEb2ulJx1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZzi/pq0; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZzi/pq0"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so17057186d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 04:20:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786620015; cv=none;
        d=google.com; s=arc-20260327;
        b=ng+l4GzAsct1lMIm/PuGOORFv/JlMzATYVz5ClQwXlBXxlTlyUMTh6F/4uAuIwzKnT
         NFRpiY/GJ4iv+AIa2ksmT1OslgMBeIr9X9I1hqloDM0lfZaf9eMExsF+JZxwRoOLfpfC
         +QmwUW4NV1SkZXvwcT9STDNAwd2pZXbY3YwgpZG0wXekIsvLE2ecdU9zLLSuBRMvxndb
         xdGTsxYydcgIhPbF4itd+eIiyhsMHohsXZ//I4ed9+jjYbLNlnBX7HgNUb4h9i/hrpK/
         fYpBe7k0jrz18RdoZFnBAmG9RKAGLlXvADYM7ElIBC73vqNoXfTwDblXvMjMZB+GdYAI
         GyIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yy7HHYBatJmuj3PQd6ReRYaocwsQJQ2GHcjVAPkfTlo=;
        fh=atvlPOsq7+ZDVoxN5cQ1JponTmVUnICcNaFl3/EP7TU=;
        b=n5Y3X8kD5vN4emLC/aEjTLDPk3X7UGog+PJixGqKYpdjKO0ZpR42vORC1vVAJ6KuiS
         +pyMY8s/g7vjPdJD9vahSmUQXOPY1u110XtyKyjvMQ304yWSIzKR4wLiBl1aYiu7C/hO
         I7Vx1J2HmGFF7eDtiFtsTJN8i/y+4eHd49cnEJB9S9zUyZV/nql1y8YQeZM+VBsoruaC
         ePTUYdlQbhgmzIa+qU1IBllOwYgvLh2YnKstNl1Hl039GVCRXAMSsNFimmBmPWXln8ut
         7sQRIGD+hyA/II6/saQ6FPYhtDMfQpXBENaXL40gr3X8Sp5PO8Zl0Vq7nDnrP7NgDVPU
         pwWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786620015; x=1787224815; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yy7HHYBatJmuj3PQd6ReRYaocwsQJQ2GHcjVAPkfTlo=;
        b=lZzi/pq02FNxMliLaXIrQSqbO4RKzHdBhU7H+V2RFKvbDdzY3MEyR+zzZItT6KZIIJ
         anw4MntqD7VJyd+sR8x/9YSvSuLnwGfqD5eCUm5KQvwsFVYlfnGyEtylWfcavPG0SanH
         QGZS+ZtUbcMAD9FOOq1raKcxNA95mbSSquc8mhwtlF9iliIY4hnvDaDQ8dnOkrB+C8wT
         MNQJwpSeiityk7EJGLSPwcrbbTd0z2lxHjoI+Y9mTNJxoq1b/RBUAr4+jiW8ieS4hUKi
         6PHBJcI6JFHEvKuxem5tyNGU9HzOcrcSWjnR6c6hIjPt+h5y4q0jDpqhtk1gIc4FkF9P
         0fFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786620015; x=1787224815;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yy7HHYBatJmuj3PQd6ReRYaocwsQJQ2GHcjVAPkfTlo=;
        b=kVxkqZ7MnIYDIOE7YMwixOD3GMV81vvmIETrmG6+1eNDt4+rMnwF0OPz8OBXvUZ47g
         043tgRAuZxLW0VyM9FC8qqc/XnfzkFndit/sxOsExbkZJJ4iS3WnL7YgVSTbvTuJNuCS
         x/AR0uJ1aTSCVi/WIDjASLFh/guQEkh2lhVJmu+/yjPJub9rfnIunRlJp7zfbBv28YK9
         UBcLcZJ+4VTg+EX1Mz2nsbgL0dzV7So+jZ3x75orkQVW6Etn/O8dNlUkhpbPW1APC17V
         O82mfqmV4zC+FU8zYKXlwE0dCfupoJ429H+dRk05lpN9ooUL3zSF3mZEmcS2Q+Ugglry
         yLpg==
X-Forwarded-Encrypted: i=1; AHgh+RrYEQLTgeysV743RvWXsjnwPXUCqMwGiY9Kf2xmCtUQhgK4VNtvLOpBwWNLiFSFJTCKE/+39Vagsrrc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8jMHlYAjFtBAtpvgciXNuiQXZYUKi0bU7pS1JOq6DzOG8xPLb
	pjMk49U5ICkshK9pfnzCLdYfa+/L1ebQ9hy7MzwGtEtqJZg0Iwb1BzjrMRdpeLniQUEoqU77rYH
	0T5RGYRlbdqWFdqLpAdxIT1VnH2DmVOM=
X-Gm-Gg: AR+sD12mXAImpNbuYEQVNj16y97zic6U0sEVUsKHl7JDbMJ/OacsFp+OOEFHrb9gdyc
	SlcIqLS0MUoMKUrMYCf1k8uFsMHjW2nojR4sFvp0DJVEotLMFcGG8lenDQr1dGAR3ScQlKMhoaG
	3f2xf9HmTDYI7ghjynhOOYoG7iBTVBvuWM1xC/M2XAU25JGLr5zt4LV8VWq/XGs4vAlzb26wH0D
	wVtiDoWAEKcK+ykyRH6XO/S8OJ8AL2ZkucUCBrma1n6VqeDWBdHBS+ZmhJyqZLIb7K697oy9vtc
	xQJLn4dK2UIfFBbp0nKFOzMxyhy7v2D6koy2AqSvFV08GIsBfaISdTkNz+3AEc7siVI6Z6Y88L+
	1HiBbbru/9BgV4lUfVsyB313Y0rYx
X-Received: by 2002:a05:6214:27e3:b0:8f2:9be8:f444 with SMTP id
 6a1803df08f44-90a80b726a0mr37463276d6.8.1786620015024; Thu, 13 Aug 2026
 04:20:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com> <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
 <9ad355b5-5ae9-4dc3-98d9-cf46795d877b@chenxiaosong.com> <CALT=-87Ziq01X+GLYXpOMThBMC6gcFLV3uaP1qy+k_vM6G+-AQ@mail.gmail.com>
 <76c86e67-23f4-457b-ba9b-240ac424beee@chenxiaosong.com> <CALT=-86u8tvAZpiLbVQWc=Cadic1p7Dg+a_AnO0tShYWQS2UoA@mail.gmail.com>
In-Reply-To: <CALT=-86u8tvAZpiLbVQWc=Cadic1p7Dg+a_AnO0tShYWQS2UoA@mail.gmail.com>
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 20:20:03 +0900
X-Gm-Features: AUfX_mzu-7UYruQLhfAYeELA8Cmea9au-w6-O3_52cCYu1l281owNPqfpoPtHpI
Message-ID: <CALT=-87oB2-OJLYa=DjPANetiOfQx6CwCJWw-NPuFyeeUrXzCQ@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Should this carry a Fixes: tag so it gets picked up for stable?

2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 8:03, B=
lue bird <obnred@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> > The UAF issue is reproducible every time, and I have already submitted =
a
> > patch to fix it:
> > https://lore.kernel.org/linux-cifs/20260813104042.170080-1-chenxiaosong=
@chenxiaosong.com/
>
> Thanks for the patch and for the credit -- but I think that is a differen=
t bug
> from the one I reported, and the fs/locks.c:312 BUG_ON is still open.
>
> Your patch fixes a proc_dir_entry use-after-free in
> ksmbd_conn_transport_destroy() on module unload. Mine is a BUG_ON in
> __ksmbd_close_fd() on connection teardown, from a byte-range lock whose
> file_lock still has blocked requests chained onto it. Different file, dif=
ferent
> path, and the reproducer for yours is mount/umount/modprobe -r rather tha=
n lock
> traffic.
>
>
> Your "cannot reproduce on ksmbd-for-next-next" run sent no lock requests
> -----------------------------------------------------------------------
>
> From your earlier mail:
>
> >  LF_SECONDS=3D10 python3 -u lockfuzz2.py
> >  t=3D5s locks_sent=3D0 faults=3D0
> >  t=3D10s locks_sent=3D0 faults=3D0
>
> locks_sent=3D0 means the harness never got a single LOCK onto the wire, s=
o that
> run cannot tell us anything about whether the bug is fixed. It is the fai=
lure
> mode I described in my previous mail -- sorry, our mails crossed.
>
> Two things on ksmbd-for-next-next stop the harness silently:
>
> 1. smb2_check_sequence_number(), added by 9d597c4a23 ("ksmbd: recognize
>    replayed SMB2 lock sequences"). The harness authenticates with impacke=
t and
>    then emits raw SMB2 PDUs, and it used to start MessageId at an arbitra=
ry
>    value. That is now outside the connection's sequence window, so every =
raw
>    request is rejected with STATUS_INVALID_PARAMETER -- including the CRE=
ATE,
>    so no file is opened and no lock is ever sent.
>
>    One-line fix in kfuzz2.py, in Sess.__init__, right after connectTree()=
:
>
>      self.tid =3D self.c.connectTree(SHARE)
>    - self.mid =3D 4096
>    + self.mid =3D int(s3._Connection['SequenceWindow'])
>
> 2. "max ip connections". The harness churns connections from one address =
and
>    hits
>
>      ksmbd: Maximum IP connections exceeded (32/32)
>
>    after which it cannot establish sessions. Add to ksmbd.conf:
>
>      [global]
>              max ip connections =3D 0
>
> With those two changes the harness reports a non-zero locks_sent, which i=
s the
> thing to check before trusting a negative result.
>
>
> With that, it still reproduces on ksmbd-for-next-next
> -----------------------------------------------------
>
> Branch smb3/ksmbd-for-next-next at e7317f3e41 ("smb: server: Clear
> Preauth_HashValue in smb2pdu.c with kfree_sensitive()"), re-fetched just =
now to
> be sure it had not moved. fs/smb/ built from that branch against the same
> 7.2.0-rc7 it is based on; I verified the loaded module was the branch bui=
ld.
> Freshly booted guest, kernel otherwise clean:
>
>   test started at uptime 120 s
>   fault at uptime 121.6 s -- about 1.6 s in, after 142 lock requests
>
>   kernel BUG at fs/locks.c:312!
>   CPU: 2 UID: 0 PID: 1575 Comm: ksmbd:::ffff:12 Tainted: G           O
>   Tainted: [O]=3DOOT_MODULE
>   pc : locks_release_private+0x214/0x2c8
>   Call trace:
>    locks_release_private+0x214/0x2c8 (P)
>    locks_free_lock+0x20/0x40
>    __ksmbd_close_fd+0x4d8/0xd28          [ksmbd]
>    ksmbd_destroy_file_table+0x5c/0xf4    [ksmbd]
>    ksmbd_session_destroy+0xbc/0x38c      [ksmbd]
>    ksmbd_sessions_deregister+0x450/0x540 [ksmbd]
>    ksmbd_server_terminate_conn+0x20/0x40 [ksmbd]
>
> The taint word is OOT_MODULE only, so this is the first fault on the boot=
, not
> fallout from something else. I have seen it three times on that branch no=
w
> (142, 208 and ~200 lock requests), always as the first fault.
>
> I also re-ran the mixed load that produced the KASAN use-after-free on ma=
inline
> for 500 s on this branch: zero smb2_lock use-after-frees, consistent with
> c120970353 having fixed that one. So on ksmbd-for-next-next the lock UAF =
is
> gone, but the fs/locks.c:312 BUG_ON is not.
>
> Happy to test any patch for it.
>
> 2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 7:44,=
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=
=EC=84=B1:
> >
> > The UAF issue is reproducible every time, and I have already submitted =
a
> > patch to fix it:
> > https://lore.kernel.org/linux-cifs/20260813104042.170080-1-chenxiaosong=
@chenxiaosong.com/
> >
> > =E5=9C=A8 2026/8/13 18:17, Blue bird =E5=86=99=E9=81=93:
> > > Yes for the BUG_ON, no for the use-after-free. Details below, and I a=
m inlining
> > > kfuzz2.py at the end since it never made it to the list.
> >
> > --
> > ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> > Chinese Homepage: https://chenxiaosong.com
> > English Homepage: https://chenxiaosong.com/en
> >

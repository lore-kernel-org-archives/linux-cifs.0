Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66F228CF4A
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 16:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780851144; cv=pass; b=jvWzpdLtBYKFhHGDVSmb/SAlIz2tLvybP/6hbuav12hdk9qlBFDN5HIAV0MRgPevP+KpWxaQM5gNO4z1yO4JVqKSZ6oc9v/Gkv0FXwrkvWPUwe4P9xgCp8R3z8jdixI2qH8KBODmbXixdcPrymZgn1QQDNz34lwfObmLsd+YorM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780851144; c=relaxed/simple;
	bh=nvQqw3yMJbS1zZleTidW06afhaSwH5aDS+e+qPRMqR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vEFRxKqXbHAP8YldYX9T6Dy0ZHrVMZYFIPtlwxBpS997yrb7v+7CsriUz0mu6sQvTh/o4IwsA8uZvb0qJCAKSoZXrBkETYC0G5jQB66l81ikfRyR6C0NDwArAig+62qSKUfSNRie3M1PN3vahZFQgUVonp5W6Z5eVmLZa2t93OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q5wRGbRk; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q5wRGbRk"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8cceaa6f75bso56245366d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jun 2026 09:52:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780851142; cv=none;
        d=google.com; s=arc-20240605;
        b=DOsQDZby0qp2rKuapSXSXaI9BDuL+ELHE4mCS7w83ioQ+Y49fpqD+oCWnCWrXvbJK+
         6tEtiiAmiA4Z+H8Sehz02KzYkOZYYr4lwyr/cmHZf32ulXYVpjdqS2tsOb7RQPJKu7XA
         r9SfLureXh8tz5XG+VJWzxBBOpz6LEItM9F3ha4ilVLeseFwn5SlBykxqZlV9OeUjKg7
         IFpQY9Vnm4Ic9OBhSOdbAb85dKih4U7NhuGUPxl6s7KzkIe190m/CSWgABarEkBPW97K
         OZNxeOK0eFv7tt+oABGbDwJzCHdMMW6X7CpDZvVXE/jbWFz6+7J8X2GhnDz/S+UF+UUt
         s0mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wdT0PYuYliGmkc8X/daaU1577Dhy7rR83jIFguNSknA=;
        fh=d9cTNCqIoMOIJaYBQ+mznDfQQqHJPNIIQn96dprlPJg=;
        b=BbgasA9N35/BdPET9F6aA2nH7NBTeIOvIHmby6PEF2NnfGFe4668/XhU5ZABwxhlgn
         20ckO4RraPaLs/fRcrFSLEknmjWnWNSxYHDdOaH6nODdNZxYa05ty9+yf7J9Ax1X4emT
         8d1Uoub8Wka41SZsD8Usmr80nlxJgYBlYm/bOk55gZL3XBMzNs7ZMBP0pfD8PuENwg+8
         zF7oDN/za1wPGOju/ejQ0p9kEFBOrGlRDH007DnefLCtL7qb1YXxNMfGBEHBZKm1W7SF
         N8ip6vT/QXX3VXMIdrlCEMu2mddDzRZYG2VejgUx7IFtB17URYdht/D3I2QCqRn6grUJ
         teoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780851142; x=1781455942; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdT0PYuYliGmkc8X/daaU1577Dhy7rR83jIFguNSknA=;
        b=q5wRGbRkeki5TsmaixIFxd+vVTLceNuImSUOGQLNAGezmtFlaDVgyz09aVbUbRg2iR
         hQVGVSuSmWrUh3XOXBI3s1m1GeRfNftP0hZlaHICimOhgn51VJw/R9yTArczS2NNshLv
         mP38oquXSpGZYhUXAArfKiI2HYheZs+rgq+/xrbyzNb4QHpVoyFdXEsxLdbn8D2rkl3V
         LJXId32NMeDvlia2IKouxNZoJw6LRzsEhO/xWFnHnQvZJKiMX2Rucgb2cDpvyCtLVjxi
         TQe4+2G7IXYUUqPXlYGtMgRxQ7axGcsfTClrw7j3RzErgLTuXp4M1pXfSquRyqWg3dt9
         JePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780851142; x=1781455942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wdT0PYuYliGmkc8X/daaU1577Dhy7rR83jIFguNSknA=;
        b=dEHWkfCieQpe7xxmrAyPNf2oHx8Ga51nBmA0V5cP+Gdws5MYavZELmW8InSDRIYRqI
         R80OQfa0Jt2YEYhotPZvVBsd504ZfFqyGn+4nceUIbwxGwNHSVWCu5CLYwmGQFkkYI40
         dKIEj58qHi8Iht5+i3o54m/3sMixe9025smeisn5mi0MkIkCByRcQFYu16W3HDYa69BP
         hNl2XTqyZT1TaEgcUKJNfUNn0bkdXsND6UjINwZVR+qanWRYt89NKzjr35ZTG1AU78KM
         SpDBfHt0/IkX5HUrs91UOEwViYSfJLR+s8qttP1wZh2KOawh0KB2TJkOnoe9RWPCTeyT
         Ehog==
X-Forwarded-Encrypted: i=1; AFNElJ9EFvMyoMkoUGISqOWkLJrjVkHjhTyC9M8jvUyCNOGskgLCaXhp3EC7xjX0JwdYz20IYQIU6qGLkw1z@vger.kernel.org
X-Gm-Message-State: AOJu0YyChJmeNfVbkG/Kb2f3d6JMiEAxWG6QdR0t5rSEMHzqeruiVJCe
	3hTPuUKlm4mqGRbY3jKz+F7O63wkwKN9Rn0nyDtnhJF49waIKBZrqMSY8EWn+hel9wXlhyMeYa0
	Ti1h0RPLBONliX+8/32n4pT7XgPDiUVilnXSmMoI=
X-Gm-Gg: Acq92OFWpapbOFd0nsp6Jplb0faBPIBGFP8yBlOa148Fe3jnbDTCIwmvURiZTVNfqXb
	TBF8k7WrxZwbfXuJI1E8BMgLUCHdVPkmjhpCDmyg87x3+F6rb8BrCWT4W9zlc35FiluSz5J2nUm
	f053b2yLtJBPZml2wOcNIZVgTl6BYtq3bOpn9rfD642JQJxlmZJRTxZNRqAAJrIOQ/Eu12/9EOi
	6F7rFUUbLpMTcXAZ88C04AgcaQ9UHoCqrDbcjR4XASxjnUN5pihSaC+SMaYDc2dgpPrRzm8Zr8o
	u6lLPOnr1dn0zIX9JzUU/EYjyoyP8d/5H/FGzRYEOBpbfOixtQFf5HZ/xvBYzl7koGRs6DUxS0f
	cYjuAsgX6spSvfquG6ooQNxmXZfSwmKPB6BrPJDdZwfRncXaXsypm7QTA/qdkKT+sivgSvRWYcR
	5is81iRndsbb8HCwUOoaRHzqD7QyRu
X-Received: by 2002:a0c:d602:0:b0:8ce:9ecf:e92c with SMTP id
 6a1803df08f44-8cee5fc99fdmr153959766d6.15.1780851141723; Sun, 07 Jun 2026
 09:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org> <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
In-Reply-To: <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Jun 2026 11:52:10 -0500
X-Gm-Features: AVVi8CdGglgZz5dVvWXTIv0AiYfJKVIQdkiAnJdE1FAw1jXWSDQJzakYk8p4wTw
Message-ID: <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX Extensions
To: Ralph Boehme <slow@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Jeremy Allison <jrasamba@gmail.com>, Huiwen He <hehuiwen@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

the chmod bug (when mounting to samba with modefromsid) causes a few
xfstests to fail (I noticed this when testing the swapon fixes from
Huiwen.  See below:

generic/494        - output mismatch (see
/home/smfrench/xfstests-dev/results//sambamfs/generic/494.out.bad)
    --- tests/generic/494.out 2025-08-22 09:54:32.322789992 -0500
    +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/494.out.bad
2026-06-07 11:48:55.528175150 -0500
    @@ -1,6 +1,7 @@
     QA output created by 494
     Format and mount
     Initialize file
    +swapon: /mnt/scratch/test-494/file1: insecure permissions 1766,
0600 suggested.
     Try to truncate
     ftruncate: Text file busy
     Try to punch hole
    ...
    (Run 'diff -u /home/smfrench/xfstests-dev/tests/generic/494.out
/home/smfrench/xfstests-dev/results//sambamfs/generic/494.out.bad'  to
see the entire diff)
generic/569        - output mismatch (see
/home/smfrench/xfstests-dev/results//sambamfs/generic/569.out.bad)
    --- tests/generic/569.out 2025-08-22 09:54:32.334797626 -0500
    +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/569.out.bad
2026-06-07 11:48:57.292054389 -0500
    @@ -6,6 +6,7 @@
     verb 3
     Caught signal 7, terminating...
     verb 4
    +swapon: SCRATCH_MNT/569.swap: insecure permissions 1766, 0600 suggeste=
d.
     pwrite: Text file busy
     pwrite: Text file busy
     mmap: Text file busy

On Sun, Jun 7, 2026 at 11:38=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> > For chmod() SMB3-POSIX *does* tell you to use S-1-5-88-3-<mode>, so
> *if* we want some SID encoding of uids/gids, we should use S-1-5-88
>
> We definitely have use cases where the client (similar to what you see
> with people using nfs on Linux) wants to be able to save and view
> uids/gids that the client understands without worrying about whether
> server has RFC2307 setup to map uids.  The server may not have those
> same users defined locally but the server still saves the uids and
> gids (similar to nfs).
>
> One advantage of having two uid mapping choices (S-1-5-88-x vs
> S-1-22-x) is that it would allow you to have two different server
> behaviors (one where the client changing the uid also changes the
> server uid for the file, and the other where changing the client uid
> is stored by the server but doesn't update the uid on the local file).
>
> Do you have a change to Samba server fixing the chmod bug with
> modefromsid?  I see that creating a file the mode is set incorrectly,
> and that chmod doesn't work either (it briefly works while the lease
> is on the file, but when the lease expires, requerying from the server
> you can see the mode hasn't changed).
>
> root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# touch file
> root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l file
> -rwxrw-rwT 1 root root 0 Jun  7 11:34 file
> root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l /home/scratch/file
> -rwxrw-rw-+ 1 root root 0 Jun  7 11:34 /home/scratch/file
> root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# chmod 0760 file
> root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l /home/scratch/file
> -rwxrw-rw-+ 1 root root 0 Jun  7 11:34 /home/scratch/file
> root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l file
> -rwxrw---- 1 root root 0 Jun  7 11:34 file
> root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l file
> -rwxrw-rwT 1 root root 0 Jun  7 11:34 file
>
> On Sun, Jun 7, 2026 at 9:40=E2=80=AFAM Ralph Boehme <slow@samba.org> wrot=
e:
> >
> > Hi Steve,
> >
> > I spend some more time looking into this. Some findings:
> >
> > * We don't have any kind of design if and how uids/gids could be encode=
d
> > as S-1-22-x (Samba style) or S-1-5-88-x (MS NFS style) in SMB3 POSIX.
> >
> > * For chmod() SMB3-POSIX *does* tell you to use S-1-5-88-3-<mode>, so
> > *if* we want some SID encoding of uids/gids, we should use S-1-5-88.
> >
> > * cifs.ko supports both S-1-22 and S-1-5-88 when querying metadata and
> > mapping to uid/gid. I tested both versions with a modified Samba server
> > that allowed me to configure which SIDs to return (S-1-5-domain, S-1-22
> > or S-1-5-88)
> >
> > * To fix chown() for SMB3 POSIX, all we need is the second hunk from
> > your patch, cf attached patchset, first commit. By default this will
> > only work with cifs.idmap setup and use "normal" "domain-SIDs".
> >
> > * If the user is working with a setup where idsfromsid is being used (s=
o
> > identities are mapped to and from S-1-5-88-x), the user mounts with
> > "posix,idsfromsid" and the existing chown() code will correctly encode
> > the mode as an S-1-5-88-3-<mode> ACE.
> >
> > * @namjae: ksmbd wrongly switched from S-1-5-88-x to S-1-22-x in
> > 5609bdd9ffdccd83f9003511b1801584b703baa5.
> >
> > * @namjae: ksmbd returns the wrong SID for the owner in the
> > SMB2_POSIX_CREATE_CONTEXT:
> >
> > Chain Element: SMB2_POSIX_CREATE_CONTEXT
> > "5025ad93-b49c-e711-b423-83de968bcd7c"
> >      Data: POSIX Create Context response
> >          Number of Links: 1
> >          Reparse Tag: Unknown (0x00000007)
> >          POSIX perms: 0604
> >          Owner SID: S-1-5-21-2305724116-1275954598-2605249026-1000
> >          Group SID: S-1-22-2-1000
> >
> > It maps the gid to the S-1-22 domain but returns the uid mapped to the
> > local domain from /etc/ksmbd/ksmbd.subauth.
> >
> > * What's still missing imo is a protocol spec to negotiate use of
> > S-1-5-88-x identity mapping. We could define a new create context that
> > allows the client to request it. If the server supports it, it returns
> > the context. The client then only uses the mapping if the server
> > signalled support. For Samba this might be quite some work particularil=
y
> > in the ACL code, not so much for owner and group.
> >
> > -slow
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

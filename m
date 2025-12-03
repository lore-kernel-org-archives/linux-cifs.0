Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560052C0F84
	for <linux-cifs@vger.kernel.org>; Wed,  3 Dec 2025 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764801485; cv=none; b=pe+cwn2yi/CUCB0ovb7/YFeNTnuSUFgX6cdgv+2BLLZAotsLcvqZzYC0ff73y9c9St1IA5jtDSlK06plRSCNz3SwJ0J32r2LKmAykWJqkMJnyULEBKG711tTEaqoHW7mjeeufdvsooVbUdMb+sH/dfd/Cdy+x0roegspP6fRP3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764801485; c=relaxed/simple;
	bh=TMPU0xrGWiZwINZkiG/dk9MKBkGkBQOX2ye2cUmVIjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c8jFqAnxmRz7Pd/5Ze63pVrg5Ao2ag0/p7L6cNQEamsitBJD+7IoRnuqDDZfNgPq6XN+4inpmpEkDHyP2wVeoa0RepbgaAqBj2o+rSfeuYkR8KvwtLNqin1oaBUwuzB50jksukvdzKlHt3i5AfW8BzRfqw6tAqLsoNYOuFfciqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U5ufsYc3; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5ufsYc3"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b2ec756de0so23167885a.3
        for <linux-cifs@vger.kernel.org>; Wed, 03 Dec 2025 14:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764801482; x=1765406282; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Andm1ZX43Hu18AjXpwZtY2kfGZSXKYycpsTeFL8sOYs=;
        b=U5ufsYc3fSRFZYYyo7PZaniSiq8qwizeAnnojW1DLQb3b+jEJookSt6+q8uTVIhmad
         xlTDnkh+tz0QJDYRinBIwkqeKj2lYddXdlVJOD9Pr50utq1GsYF/P4VoiPXAyY8cHO4v
         uc+kccjTai6Xa9eBzYlfj6JhSXI5vmdXBvNb1w5FVjsKbGnZTErjqGNFbd+HSIhCaQHF
         nqn1HMexqAZ8E7SMtGIIBVzQgLNgOhDsYfZpilYN42mtzfppSmyGTyOOBrwBWOqFbE+4
         D0zG/QdYJMwz3J7IpJA+aNFHBjnfboKgpBi19ITdDmF8HcMmGnufLHcaRDgwrhZzMs61
         J4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764801482; x=1765406282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Andm1ZX43Hu18AjXpwZtY2kfGZSXKYycpsTeFL8sOYs=;
        b=K3+XMULX/KYPMJrwLmyDz7X+fAfgDNpQOxiedLvkMgFAj4BhrTXTXGGMIEVLwcJBbR
         j41XYUFBvYbkihgzHcY9STEq6G48OAcMWDtTEm/djrzIqJGA/Ev5wehUrm/5UPVCMRy1
         fpU2maLZ76T6mDRbNkK3KlgoumN5biKYDHmgsMp4FhAKhRgDy5XsO2vW1QGtLqoIlZmd
         DlaHfzmtAYDUKprwYwKkWIrRlvm/da2kPoGHUxXEk6flAZS2avUV1S07y6zHxpO37YyR
         eBEMkFdFLcATzDYE4Z7M3w0QW4RdJt8CDv2BH152D179RsCilPceAB8TmajM8AdOA74h
         9GRg==
X-Forwarded-Encrypted: i=1; AJvYcCX80qrH0v7VZmxAyQ5w/8rAtCCuOogAZEE9/CpNIHbwjhL/4iSfrtaC7GSNHWZlW7awFKy4RzPQ1XCs@vger.kernel.org
X-Gm-Message-State: AOJu0YwGIgyuffJedu0W5YSlZRiym9b3TL+geJUqy7nWvNy8tSYskacQ
	NOv8MmQ5CGBuVzoCzkVP+7iXWasM1QT7jRcr8FckIliNkJWUh6la/WKINJJ6CsEnuNJB1/BsRQ2
	/NX1SPCq9VGssaiXahQ1iUKXoGqAKnzY=
X-Gm-Gg: ASbGncvJPy5K85hZgNnx4T74H+FNt3Gjb1XGORPRxYajdOBWksWaGTsuaeCiOL7Jq5c
	Uobs4QHMMMfY5Qi80w7x5VqBuE3NZcM/xhIB6RBKcQB+3ePzko9Wj+m9RENpONMOq42fU/YzqNJ
	UEpWM1tCavOv6CNl6VxEo7xG5qFgiEyJ5tnH/G+ELdwFdeb0Q+XWMtsoOCH2kePc6n/PlsVwMjb
	LUAnfn25cLL4AxaNcbdwCdQnAjYcHqinug2m435wgkgZ2IxshwWv0/5A4hUyQCjIGmaXScsDkoF
	ylvsG5aKPurQehwvzf5iiC7XkYu576/wIoXzrxhiaaFFxBgTXH2YrWdtfImzCDP4uhsJN8k5V9W
	OiZn3wM4LGNhV3pHRfuAvl6UXC8S8N6iB4/VcNw7tfg==
X-Google-Smtp-Source: AGHT+IFytlRyeXS1uo6MPquKUsZiOY2RJ5VrFZffuPwZSJBbbxqOfStW/5ly+RkBCfgIJEDGSlsmPnv0qNRl59F2Dh0=
X-Received: by 2002:a05:620a:28c2:b0:7e8:46ff:baac with SMTP id
 af79cd13be357-8b61812b33emr126161185a.1.1764801481992; Wed, 03 Dec 2025
 14:38:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1597479.1764697506@warthog.procyon.org.uk> <0cf36b63a8f7c807a785f3cbee41beb2@manguebit.org>
In-Reply-To: <0cf36b63a8f7c807a785f3cbee41beb2@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 3 Dec 2025 16:37:49 -0600
X-Gm-Features: AWmQ_blWPzWa-cXgJhnkMvErK2UGojdZhtDpX5kWgWoq-BIPUg0a3Kl05PfYHXs
Message-ID: <CAH2r5mvYVZRayo_dJGbSKYuL73kpBM+PwSiNm39Pr0mt37vx9g@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix handling of a beyond-EOF DIO/unbuffered read
 over SMB1
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Paulo,
Added your reviewed by to David's patches but wanted to doublecheck
that I didn't apply it to too many of them since I couldn't find one
of your notes

Does this look ok for your RB on all 14 of these - or just the SMB1 one one=
?

a6fd899da60f (HEAD -> for-next, origin/for-next, origin/HEAD) cifs:
Remove dead function prototypes
1b7270c879f5 smb: server: defer the initial recv completion logic to
smb_direct_negotiate_recv_work()
9d095775a0cb smb: server: initialize recv_io->cqe.done =3D recv_done just o=
nce
667246dbce2d smb: smbdirect: introduce smbdirect_socket.connect.{lock,work}
2b4e375e4006 cifs: Do some preparation prior to organising the
function declarations
c3bdaf3afd87 cifs: Add a tracepoint to log EIO errors
cb416ff96b83 cifs: Don't need state locking in smb2_get_mid_entry()
a64fa1835237 cifs: Remove the server pointer from smb_message
960cd2e1e28a cifs: Fix specification of function pointers
2fdd780130d1 cifs: Replace SendReceiveBlockingLock() with
SendReceive() plus flags
bb8172e800b3 cifs: Clean up some places where an extra kvec[] was
required for rfc1002
41daa3d4a238 cifs: Make smb1's SendReceive() wrap cifs_send_recv()
3ed72b50d276 cifs: Remove the RFC1002 header from smb_hdr
271b1138e8b4 cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SM=
B1

On Wed, Dec 3, 2025 at 12:03=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> David Howells <dhowells@redhat.com> writes:
>
> >
> > If a DIO read or an unbuffered read request extends beyond the EOF, the
> > server will return a short read and a status code indicating that EOF w=
as
> > hit, which gets translated to -ENODATA.  Note that the client does not =
cap
> > the request at i_size, but asks for the amount requested in case there'=
s a
> > race on the server with a third party.
> >
> > Now, on the client side, the request will get split into multiple
> > subrequests if rsize is smaller than the full request size.  A subreque=
st
> > that starts before or at the EOF and returns short data up to the EOF w=
ill
> > be correctly handled, with the NETFS_SREQ_HIT_EOF flag being set,
> > indicating to netfslib that we can't read more.
> >
> > If a subrequest, however, starts after the EOF and not at it, HIT_EOF w=
ill
> > not be flagged, its error will be set to -ENODATA and it will be abando=
ned.
> > This will cause the request as a whole to fail with -ENODATA.
> >
> > Fix this by setting NETFS_SREQ_HIT_EOF on any subrequest that lies beyo=
nd
> > the EOF marker.
> >
> > This can be reproduced by mounting with "cache=3Dnone,sign,vers=3D1.0" =
and
> > doing a read of a file that's significantly bigger than the size of the
> > file (e.g. attempting to read 64KiB from a 16KiB file).
> >
> > Fixes: a68c74865f51 ("cifs: Fix SMB1 readv/writev callback in the same =
way as SMB2/3")
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: Steve French <sfrench@samba.org>
> > cc: Paulo Alcantara <pc@manguebit.org>
> > cc: Shyam Prasad N <sprasad@microsoft.com>
> > cc: linux-cifs@vger.kernel.org
> > cc: netfs@lists.linux.dev
> > cc: linux-fsdevel@vger.kernel.org
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>
> Dave, looks like we're missing a similar fix for smb2_readv_callback()
> as well.
>
> Can you handle it?
>
> Thanks.
>


--
Thanks,

Steve

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBD1201278
	for <linux-cifs@vger.kernel.org>; Sun,  4 Oct 2026 00:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791074345; cv=none; b=Mh+5rVCHI7BE3Rtw82akQhszPRacgO6MP5xHN7+iOuf1kGoTBmaLdx0dDtRUn8vazen1vEJR2t8e+zJhBk/KIZuToESf4Tzl4hRKzDQ149bDCsQ9zIi5wkhu3V7MOzB0wkBTvnSoPMXdsqxqYdGUPDUurHjcG+qs5aJFUThBQ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791074345; c=relaxed/simple;
	bh=qxnaO7g4SnBJQyCtu/VQG9paooRdT4faONGryGDLWwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qQfuzT/5S9VCldZTbZU/Gc2717CaZKNv7SuCAAKZrhQeFSmulUQBQKCCBXe7oDNWP6NeaR4IwfWiq9xVM2XxNl2SC3jImA7hqGMUb1/xcWZa+LpGaePoSrc0UCzpwa75BIqj7LxktGjwfx8F/6Nn44mGdzn2+M0/oxCDIQQD0vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJy1TdiF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJy1TdiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8771F0089D
	for <linux-cifs@vger.kernel.org>; Sun,  4 Oct 2026 00:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791074341;
	bh=2pIi4pLEWAgY14Pmrc5kV5Sn+608CZmHv9kvZ28ohuI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dJy1TdiFdFZvn+DS5ebTVlqxIuZFa6q0KDw23bTDkKe5gaGlZhocOtV6ALPqrxvEP
	 8OjkjQY3VzO/mieXfAFZIBVtz1lu/O6Y1+lIOrHJX7/8E+CwoP4qNN8eYTYhQ04Aps
	 mEyG3ZQOU3EfWp0LAKY6iAYlE+L2y0NvFG1/wMfFlLp/UdziDmaEX/05eop1lbxcxj
	 /8Uq9nYIkPz/zjaszt1wi99oYztEPp1jXc6EF4N2fBtNOja5rVB69Ei0Tfj5Elb3cD
	 5DsMnA739++iUh5LpmMSLSg7gs70UHe547Fvmsr5TxrMHSVdQeGhrqxuChu1IxsKPB
	 zGtl4YpUIJ16g==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6ab006eb282so919833a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 03 Oct 2026 17:39:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByDPkIfA7d4gxm1xjxNs1rQyp0bvRVOT3BNbEKb4GXFLES0i/N79hd/9x6zA1YL69BkMjcfQtJZJ0zo@vger.kernel.org
X-Gm-Message-State: AFuF++mKDaX155wIb+3hjMMkVmWkXTkW6gEO+VCsbfUwGaTAFlaqzlkM
	5RaOPsA2EbBo2h9rzBJtjAIg/60Dx82vT/MSoM0k1F2Y9fTUNL1A86KvypsETUeYhEB2GF4oq1q
	geHZXACtODYSIMMRsZJae9B3dT0ymOf0=
X-Received: by 2002:a17:907:c011:b0:c29:d33e:9ba3 with SMTP id
 a640c23a62f3a-c2e6e9ca0e8mr273892766b.6.1791074339835; Sat, 03 Oct 2026
 17:38:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+i7WArBKHotAcKVS8iYZp0qBK2rRvuuCw=YHEoyM0TUfvbONw@mail.gmail.com>
In-Reply-To: <CA+i7WArBKHotAcKVS8iYZp0qBK2rRvuuCw=YHEoyM0TUfvbONw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 4 Oct 2026 09:38:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8a-SpSgvEr39LSpu7XqmOBejjFAUEGm=0nXvbVHWTjSw@mail.gmail.com>
X-Gm-Features: AclHuK8Yr3jJu0JerbO8Gci3PIzOodj6H87kY0MYH9Llbpcb0P3kBzeDxYujSo8
Message-ID: <CAKYAXd8a-SpSgvEr39LSpu7XqmOBejjFAUEGm=0nXvbVHWTjSw@mail.gmail.com>
Subject: Re: ksmbd: second session setup on same connection fails
To: Tea La Forgia <tealaforgia+alias@gmail.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 3, 2026 at 8:37=E2=80=AFPM Tea La Forgia
<tealaforgia+alias@gmail.com> wrote:
>
> Hello,
>
> I would like to report a problem with ksmbd that I did not have with
> Samba's smbd.
>
> Summary
> -------
> Two related symptoms, both involving repeated SMB2 SESSION_SETUP
> requests on an already established TCP connection that ksmbd rejects
> with -28 (-ENOSPC):
>
> 1. A Windows client can access my share normally from non-elevated
> programs, but any program started as Administrator fails to access the
> same server. The elevated process uses a different logon session and
> tries to set up a new SMB session on the already established TCP
> connection. ksmbd rejects it with -28; the client sees
> STATUS_INSUFFICIENT_RESOURCES.
>
> 2. With "oplocks =3D yes" on the share, Windows Explorer hangs for more
> than one minute when browsing a folder. The log shows the same pattern
> (see below). With "oplocks =3D no" the hang does not occur.
>
> Environment
> -----------
> Server: Arch Linux, kernel 7.2.8-1-cachyos-server, ksmbd-tools 3.5.6,
> IP 10.1.2.1
> Client: Windows 11 Enterprise 26H2, IP 10.1.3.1
>
> Steps (problem 1)
> -----------------
> 1. From a non-elevated process, connect with explicit credentials (net
> use Z: \\10.1.2.1\SSD /user:tea /persistent:yes). Works: session
> setup, tree connect to IPC$ and "SSD" succeed, directory listing
> works.
> 2. From an elevated process (like CrystalDiskMark), access the same
> server. Fails.

Can you try to reproduce after applying the following change ?

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 1b24eb3f3998..88953315b160 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -336,8 +336,7 @@ ksmbd_build_ntlmssp_challenge_blob(struct
challenge_message *chgblob,
        if (cflags & NTLMSSP_REQUEST_TARGET)
                flags |=3D NTLMSSP_REQUEST_TARGET;

-       if (conn->use_spnego &&
-           (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+       if (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC)
                flags |=3D NTLMSSP_NEGOTIATE_EXTENDED_SEC;

        if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)

>
> If the elevated process connects first it works, and the non-elevated
> one then fails (and vice versa); it only depends on which session is
> established first on the connection.
>
> Details (problem 2, oplocks =3D yes)
> ----------------------------------
> Timeline from the ksmbd debug log while browsing a folder in Explorer:
> - Normal traffic first: create / query info / close, plus two SMB2
> change-notify requests answered with an interim async response.
> - About 8 seconds later the client sends hundreds of SESSION_SETUP
> requests (NTLMSSP negotiate, SecurityBufferLength 178) on the same
> connection. Each one fails with "Failed to process 1 [-28]", and the
> credits requested grow to 65 per request.
> - Then the log is silent for about 56 seconds. This is the freeze seen
> in Explorer.
> - After that ksmbd logs "Cancel pending async requests on releasing
> connection" (the client gave up and closed the connection). On the new
> connection everything works immediately, including a directory lease
> being granted ("lease granted on() lease state 0x3").
>
> I do not know whether the oplock/lease is the direct cause or whether
> it only changes how Windows behaves (for example by triggering the
> extra session setups). I cannot tell from my side whether another
> process on the client (elevated or not) was involved in the extra
> session setups.
Can you try to reproduce after applying the following two patches ?

1. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi=
t/fs/smb/server?id=3D906a62216339d7eccc336bfb4531ce3d7850b8ac

2. https://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git/commi=
t/?id=3Dadecff0c5ba981640216ac5ba382c4a0b9d907fe

If you can still reproduce this problem 2, Please send pcap(packet
capture) with oplocks=3Dno.

Thanks.

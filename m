Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906078834
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014144; cv=none; b=O0yFCm61uVLKVoCSEcFOcXXJOZgIVsPxbbTwibVWpWYzp8Lq4d3uXTMpqn6qBLFHE7TJpAyO3USNHU/RYYMkjF3Te4jj0elkbWLptLjBYKqT6rCGPWsnsS0fJ3rpDRe06MoIDD1glTMyPE8/1ykOO9I2gMsLTOT8y+ziIhXr2qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014144; c=relaxed/simple;
	bh=SasMhfzwsxwjzD+6IIfn3u2enkJxhVF34aB+hIwprFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nn47TrqaAa7+BgA1dH+crAdERzwVVZ/MUocq/IE0sT87yZsBJiptPxV1I/OT2Pp7V37g6DNr9d35+zbYAtX1sfpW8heLa6dcylY/IH35naYHt031uKsO/lLjYJLDbrN7asPiPxWclW7Z5P5np52xCSu7xA7Nx0TlhA90iU6MFo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mIwU40qk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mIwU40qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331641F00A3E
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787014143;
	bh=vYR4eDIKGdygMV/CaA5QXqzipLBrq7FUa6fTRodUpdg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mIwU40qkXJmJF0Vkge0IuTIkLFgYhLeuErRi4wfYjAuuN04RQZmxYb3L+OVIZ1Xq9
	 8PImwLQGQkXjHXf1IxbNN1vXtifq1EqIk7i4x8zArBt4Z8u/M4nlGCKvNfQMnQPJ7P
	 V0OoiSTYoo6J/ZCt/wgIcv8dQRJep4lL713A4E62XHuZM+xl7Ef3UQKaObGreGAE3/
	 MBDweMo1PK9mk2rvklJdSGaT3K3a/OAX7V+LiDK2ukxX3ThdiGgGX1UNCaC5R93zUS
	 ARZjk8B88L7R3gZIljFzsKzmwjUA1byPlRXDz3TWPOMz7lum3TN+6kTaFtzYQnvy/F
	 d1RBfkONuupLw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a20319d030so5512638a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 17:49:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr8rMEnLiCFHXi9jAvAyG8B1t8O7c9hJKgXp/GWgU0FZkPdyXHlvTKYsiaqQdwzEmtsACZZoh25CZbp@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzy8d21KInhXLHWzpuT5eFHRKKtRUD636LKnMdwSTxbAdVXp3T
	W6CiMCQFo8+cSoZ7HSdpJkA4rEkB/z7V0BQfR0TRlJw1vdC+rT+lKB3yuTBQLusG3mNryGT9LML
	N95lBEsbGMm8QfII2k4veKr2cglArqdo=
X-Received: by 2002:a17:907:9413:b0:c16:592b:ec4c with SMTP id
 a640c23a62f3a-c212a090a10mr1249314166b.1.1787014141783; Mon, 17 Aug 2026
 17:49:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716022214.2727070-1-yijiangshan@kylinos.cn> <CAH2r5mv962Lp+mLi2JCjvWhtJLbzLqwmjxYSCjSUyy_KLjAzuw@mail.gmail.com>
In-Reply-To: <CAH2r5mv962Lp+mLi2JCjvWhtJLbzLqwmjxYSCjSUyy_KLjAzuw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 09:48:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9+Rap0OO5odjSSaZpdn1Vn8cj1=KyjYQVU-yRfD4i2wQ@mail.gmail.com>
X-Gm-Features: AcwNN1WsonR2nRGwekbpuMYE5lOjPLe1GZD7mElDOEEo6c8KL0xYctHfF_Zz4OE
Message-ID: <CAKYAXd9+Rap0OO5odjSSaZpdn1Vn8cj1=KyjYQVU-yRfD4i2wQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: clear setuid/setgid bit on write with
 cifsacl/modefromsid/posix extensions
To: Steve French <smfrench@gmail.com>
Cc: Jiangshan Yi <yijiangshan@kylinos.cn>, linux-cifs@vger.kernel.org, 
	sprasad@microsoft.com, pc@manguebit.org, samba-technical@lists.samba.org, 
	13667453960@163.com, jlayton@kernel.org, linux-kernel@vger.kernel.org, 
	tom@talpey.com, bharathsm@microsoft.com, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Wed, Jul 15, 2026 at 9:23=E2=80=AFPM Jiangshan Yi <yijiangshan@kylinos=
.cn> wrote:
> >
> > When a file has the setuid or setgid bit set and is written to, the VFS
> > strips those bits and issues a setattr with ATTR_KILL_SUID/ATTR_KILL_SG=
ID
> > together with an ATTR_MODE carrying the already-cleared mode.
> >
> > Both cifs_setattr_unix() and cifs_setattr_nounix() unconditionally drop=
ped
> > ATTR_MODE in that case:
> >
> >         /* skip mode change if it's just for clearing setuid/setgid */
> >         if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
> >                 attrs->ia_valid &=3D ~ATTR_MODE;
> >
> > This is fine for the default mount, where the mode is only emulated via
> > the DOS read-only attribute and cannot represent the setuid/setgid bits
> > anyway.  However, with the "cifsacl" or "modefromsid" mount options the
> > mode is stored on the server through an ACL (id_mode_to_cifs_acl()), wi=
th
> > the SMB3.1.1 POSIX extensions the mode is sent to the server directly,
> > and with the SMB1 Unix extensions (cifs_setattr_unix) the mode is sent
> > via CIFSSMBUnixSetPathInfo().  In all those cases dropping ATTR_MODE me=
ans
> > the cleared mode is never pushed to the server, so the setuid/setgid bi=
t
> > survives the write.
> >
> > This is a security issue: on local filesystems the setuid bit is stripp=
ed
> > when a file is written, but over these cifs.ko mounts the bit persists =
on
> > the server, potentially allowing an unexpected privilege escalation on
> > subsequent execution.
> >
> > Fix this in two places:
> >
> >   1. cifs_setattr_nounix(): only take the "skip mode change" shortcut
> >      when the mode is emulated via the DOS read-only attribute (i.e.
> >      neither cifsacl/modefromsid nor the SMB3.1.1 POSIX extensions are
> >      in effect), so that the cleared mode is propagated to the server
> >      in the ACL / POSIX cases.
> >
> >   2. cifs_setattr_unix(): this function is only called when Unix
> >      extensions are in effect, so the mode is always stored on the
> >      server.  Remove the shortcut entirely so that the cleared mode is
> >      always pushed.
> >
> > Fixes: d32c4f2626ac ("CIFS: ignore mode change if it's just for clearin=
g setuid/setgid bits")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
I will apply it to #for-next.
Thanks!

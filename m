Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D740334A797
	for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 14:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770734246; cv=none; b=NQpyi6UeuVw3L4Npyels8fuht+7ldX2tVGEUbI+h+f+7vXrO+rWMNuYaXauWYufT6C8iKBqS/0tAT7Z+3w01QzBO6Bw2qaO/TOsW0tx4LPHX1rnzCkoSulhczcHyHxbItDoV2wqCyAHbdYfNZfbb/et3BEQW+7gTkoEHNKIjKNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770734246; c=relaxed/simple;
	bh=YV590Pe1v4EJDAhoUB8bULTb+l8/REFI+8yDfNPGrJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=adg87SpI9ECm6E+XVrP5EK2ry4vJ5tc7pzg7qSVqmho+em+pBshycODbZTcqtbxHfQn3dJmjwbokpBHrE+NxoZyI1vLsHRHkdkxSs7SGGokS4n2be4nBlkgx5lhvVLJhmzLK8GGuVG2jK/F8XwjaPUYQRvgicZC64kVj7Ns3YWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lW5qsELe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lW5qsELe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B7EC116C6
	for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 14:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770734246;
	bh=YV590Pe1v4EJDAhoUB8bULTb+l8/REFI+8yDfNPGrJk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lW5qsELevl56yYpm9ptRpHkqfLfM22A0p5Q1AexDWN6BWBI/X9NcrKJC7MRiNCdBr
	 baaM/N3SiZ3AeSk9f4/zHyTvRpe98oIcLM1VUSypmwDNWIQo8hmKbZxLiEWYT796xu
	 GJ0cBKAegKnwF5kewYGb2azC39beNlBUaPzhsR/NLgulbPRNk87aJ5aGlH6B3nJ5Q0
	 P4oQPtLTPUfsSAnYjCqZSp0C3hdeLnbpupXetRvTk3rHH1T4FYWUtxjr2uFrwM6EOy
	 7P4dfdDhUeGXDYPwhx8NqwEy7EarEcMWZJJQLmanbOuh9sABbIVAhGfVyrSzenZUtN
	 N88Fp7vWra5WQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8876d1a39bso598363866b.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 06:37:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUiwoVnu3RthmpKXO+jPjB7W1weN6F9Y4sr6UuhCKHD7cWZlc/5mbp3n2AeWfbQt7HPgRM/gbiwQlS3@vger.kernel.org
X-Gm-Message-State: AOJu0YwdqJ7w7eXrpFK6xZSNM3Yg+MyaRnB+/bmzMSzC4XLLQz5tsXGN
	lLCkh5SbgJlb3FY6rYSkxUXQILLt8HeoQZZ0lLM2UsRymrpH9GpcZPmbehVeo12mmJ18cbZ8h/7
	dboNiRXDUxnUcHBwUSVDmWw8cIKWdx+s=
X-Received: by 2002:a17:907:9486:b0:b88:6327:d0eb with SMTP id
 a640c23a62f3a-b8edf456038mr876954566b.65.1770734245118; Tue, 10 Feb 2026
 06:37:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770311507.git.metze@samba.org> <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
 <7140153c-7858-474b-abe5-aee69bd196a2@samba.org> <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
In-Reply-To: <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Feb 2026 23:37:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
X-Gm-Features: AZwV_QiNQiJHbm-KEQR705dX08IoY0RyBS_tAAWsEtGJEIufQXGzc_wqMZ8SDw0
Message-ID: <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2026 at 4:11=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 09.02.26 um 14:22 schrieb Stefan Metzmacher via samba-technical:
> > Am 09.02.26 um 08:29 schrieb Namjae Jeon:
> >>>
> >>> I tested with with mlx5_ib, irdma (roce) and rxe.
> >>> There's still a known problem with iwarp.
> >> Let me know what the known problem is.
> >
> > It's the rw credit deadlock, as use rw credits
> > for the wrong thing, which means we easily deadlock
> > if the client uses an array smbdirect_buffer_descriptor_v1,
> > where the could larger than the possible rw credits
> > be calculated. While the max possible rw credits we calculate
> > is the value that is needed in order to
> > transfer the maximal rw size into a single
> > smbdirect_buffer_descriptor_v1.
> >
> > This commit adds a WARN_ONCE detection for the
> > problem:
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3De6260=
d7a518972ae1ca627e411cc16095c044d59
> >
> > See the diff and commit messages of the top ~15 commits
> > in my for-6.18/ksmbd-smbdirect-regression-v4, which try to
> > fix the problem.
> >
> > I try to fix it once I have the needed pcie adapters in
> > order to out my Chelsio T520-BT cards into the free x4 slot
> > of my testservers.
> >
> > As there are some strange page fault problems with the irdma
> > driver, see
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3Da6b51=
5cda103c1ac1537c92a4e9dbd75a31d92ef
> > And also
> > https://git.samba.org/?p=3Dmetze/samba/wip.git;a=3Dcommitdiff;h=3De784b=
53167dc2cf4316b66a7599dab5b9e6c7208
> >
> > For the client problem with irdma, see
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3Dfb5cc=
2a59b4719015979a1f1355f66f27002b4cf
> > irdma_map_mr_sg may merge sg elements any may not return
> > the same value as the given sg_nents on success.
> >
> >>>
> >>> So far I can't see any regression compared the
> >>> state before these 144 patches.
> >>>
> >>> Namjae, can you please test in your setup?
> >>
> >> Is there any reason to print the log below by default?
> >> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
> >> called from smbdirect_socket_shutdown in line=3D650 status=3DLISTENING
> >> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
> >> called from smbdirect_socket_shutdown in line=3D650 status=3DLISTENING
> >> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
> >> called from smbdirect_socket_shutdown in line=3D650 status=3DCONNECTED
> >> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
> >> called from smbdirect_socket_shutdown in line=3D650 status=3DCONNECTED
> >
> > I can move the above message to level INFO.
> >
> >> ksmbd: smb_direct: status=3DERROR first_error=3D-ESHUTDOWN =3D> -ENOTC=
ONN
> >
> > This is basically the same messages as the one we
> > had in smb_direct_read() before:
> >
> >          if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
> >                  pr_err("disconnected\n");
> >                  return -ENOTCONN;
> >          }
> >
> > If I remember correctly it appeared just as:
> >
> > 'ksmbd: disconnected'
> >
> > I can just move the new message to level INFO too, ok?
>
> My master-fs-smb branch has 3 commits which should disable the
> messages by default, let me know if your happy with the logic
> and I'll squash them to the correct commit.
>
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3D8b2f53aec=
19ebc180c11504600b5e5372d2220cb
Looks good to me.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
for this series.
>
> metze
>

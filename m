Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696501;
	b=pHZhaRnTqvvw3LnP6tBlcqK1bekGH34sVtKp9UoGqwJOTE+e8NIbiVTVXZglYrDI8yFQ
	 qJCmDAGrFaertbC+YwFbNOcUmHxQm5HFDzsGoqVVNb5UL0Bw+3pOw0fTdJKTGF2sxOg+9
	 Pxfl1YDB7M1ff9iv0wos7mbr2fd4s+o9pIErNctXA1ntAbX597XPug4IE/Rc/hAguAqgD
	 v6bX89zKUb8swWxKZ5mHme1BOV+caewcYVkEIEK2z5Ev27BFyNfs+Bl53rTEGclBnWNIT
	 /BVNehuq9kfccIvcABy9LH18K7mC5v8qKnc7JgtbPqGYm0Jkaw2yAxc40LdvgEAL5Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696501;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VALflxZ7hqWpOU/Z5TDJPSQ00+BwIDKViXL2t24ctfA=;
	b=jRqrP8M56D2slxTdDZ5I+aBFeeoHGwLWANdyWuEJ1r1m36fIYx5u0vR3T6tlKFgDcEEs
	 E4wtGama5CulBqyVkJVLAgPianEoJEDJkWcc3WSXqsFwqK0KSpu8PHiHEZY7iiofinwhL
	 OAxNJBgjAmSG38MTcSH+VALJe9hxGG0xhhyTMObDCx7EyBtnwK9tfTbNJvNqD5w1vVht/
	 5EF7fVzPG+btYSEJ5ps614AGttlrqHXN+yXvGJnLAteniE+oIp0FJI0g5J3n4ixuqB5co
	 Xo6vdHZ8v2L6xIeiltWYBApCr3I8eW6WpOYDuWvSlB7EzhEw9OYdGfhoIQLm3omaQxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwAn1W3d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D849606A32E
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 12:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwAn1W3d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FFB1F000CF
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 12:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795696500;
	bh=VALflxZ7hqWpOU/Z5TDJPSQ00+BwIDKViXL2t24ctfA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WwAn1W3dV+TGwkIzfLv0lthCgW79mO/apWeqhWJDRaYrwBYA5inEQ8M5d+yZABYO3
	 ReqjLymAQC5/vCzgJ09KMZyWADE35Jcc6B5wU4VPg89984mMnAlvv48BrBrX2gDPX/
	 Aob351m4nYkOj0VofP5k6OcIpA5zyQWMazlA2xTkESloQNUHnzWx8cQDl+65Lk2y+0
	 OX9M57exB1KpHviV4WDaH1Ym/kNMRkGbBSjDYtoyvi2lEkE91SgufIZFlQHy21Scbl
	 ThnPtJOWS20bxqB2Exoh0linXR8MyfZhKFi2ivW2cNX7vc5Et5fnb+zDzZSU/UnsSw
	 jlcomWNNABbSw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c51a14bd405so285774466b.2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 04:35:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG4gMHG4CaYvLESs6Q5O0lnhiMFuM3zN4A9x7GCaLohzeEmTHHwq8vrsf+N6Xyur/mBHkfK65Rh0cds@vger.kernel.org
X-Gm-Message-State: APuU4Z+HY7KIqp+s9A4hqkUrr9wrBsb51nVGglf1kTnyEbdG8tWq9aDC
	g9COp0Nvnn6bcArWDOzKrDhntgZQaOiw8r+z4O2lkhOkDSE8qhWmq7J1Vpt/5sCE8w7ktZUM1gt
	5HlM/3javGLxzbCW9933M6+op/szXAfM=
X-Received: by 2002:a17:907:6091:b0:c51:51f7:c9e3 with SMTP id
 a640c23a62f3a-c5151f7fd77mr1338805766b.34.1795696499535; Thu, 26 Nov 2026
 04:34:59 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126000500.1375459-1-icb@fastmail.org>
In-Reply-To: <20261126000500.1375459-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 26 Nov 2026 21:34:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd91uEkLWPtM=7s3y1wLmy6pqQiJOSrOC1GoV7X8QdAMhA@mail.gmail.com>
X-Gm-Features: Aa3M54pmCI-9Njn8nA9I6ylrmwepvf5JIU4UdG8UfDorl6nayvBJGkKRir2Lpg0
Message-ID: <CAKYAXd91uEkLWPtM=7s3y1wLmy6pqQiJOSrOC1GoV7X8QdAMhA@mail.gmail.com>
Subject: Re: [PATCH 0/4] ksmbd: follow-ups to the security descriptor codec
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 9:05=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> The codec series [1] added a decoder and an encoder for security
> descriptors (SDs) and replaced ksmbd's walks of raw SD bytes with them.
> It changed as few of the callers' decisions as it could.
>
> The issues in this series were found during the work on the codec.
> They were held out of that series to reduce its changes in behavior.
> Now that the codec is merged, they are submitted here as four hardening
> changes. Each patch touches only smbacl.c, and its message describes
> the change.
>
> Tests
> =3D=3D=3D=3D=3D
>
> Tested on ksmbd-for-next f9208b7a4919, on x86_64 only.
>
> - Each patch builds with W=3D1 and no warnings (GCC 14, with KASAN), and
>   sparse reports nothing in fs/smb/server.
> - KUnit under UML passes at each patch with GCC 14, and on the base
>   and at the last patch with clang 22. The series adds no KUnit case.
> - checkpatch --strict reports nothing.
> - A script with a test for each patch was run over SMB under five
>   modules, the base and each patch, on a KASAN kernel booted with
>   kasan_multi_shot. Each test changed its result at its own patch and
>   at no other. The test of patch 3 writes the stored SD into the xattr,
>   since SET_INFO refuses the ACE that it needs.
> - smbtorture smb2.acls, smb2.setinfo, smb2.getinfo, smb2.create,
>   smb2.sdread, smb2.maximum_allowed, smb2.winattr,
>   smb2.delete-on-close-perms, smb2.dosmode, and smb2.rename give the
>   same results on the base and with the series. There is no KASAN
>   report or warning, the kernel stays untainted, and kmemleak reports
>   nothing.
> - Out of tree, the functions that patches 1 and 2 change were run in
>   userspace under ASan and UBSan against upstream's functions from
>   before the codec series, compiled verbatim. That was about 1.2
>   million comparisons over generated and hand-written SDs for the
>   QUERY_INFO reply, SET_INFO, and inheritance. Every difference is one
>   that this series or the codec series lists. The comparison does not
>   run the access check, and its store never fails, so patches 3 and 4
>   rest on the tests over SMB.
>
> This series was developed with LLM assistance.
>
> [1] https://lore.kernel.org/linux-cifs/20261125133430.1177754-1-icb@fastm=
ail.org/
>
> Ian Bridges (4):
>   ksmbd: match SIDs exactly when a DACL is mapped to POSIX
>   ksmbd: replace only the CREATOR SIDs in inheritance
>   ksmbd: skip SIDs with no sub-authority in the access check
>   ksmbd: build the SD from the inode if an inherited SD is not stored
Applied them to #ksmbd-for-next.
Thanks!

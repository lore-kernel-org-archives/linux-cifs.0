Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022645;
	b=r93rDi6fWN1SxumAQgGfk/JOZZGc6zRUPM7Ae6irkRhDLuTpMnww5r1gq84T4wiFMcHM
	 11pDTCYxcXmoh9+XTWIqUDzeL5qP4JN9QW8wwdvMPNejj+JdOlP6ACjo9hk4JE7mcjQeQ
	 KyTS/Yu99Rt/jmKnB6uTwHwZBmiYAxzP+LbUR+W1OYUlL2FPire/0PMqWhfdoryRCFFbH
	 ztSyL0gAux8QjEqXWile3i3FQtbDPwmCQj0ebazKArag1RpuRCbtpCOssWIxZMuGh0hXN
	 HCHxzIC/nLLSqRKiPmfDN7EcxSja5E/vSDi+aKuYmDDYwiLBbqBiiukj7+VUZGH3/CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022645;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=8VmZcMVpc16J1nBk01fE3vMPgjnZWh0+ezLB75Qyp4E=;
	b=PyT2kVbTTgyV3/HaAN5Jv5b84fUmgsZIMBcp6PT7KjkewaqFP8vnX0x8jMFOEMKMq5yc
	 RPL16wPupNN4Mdww7uVjqt++DmhpJPalosl+Qs/dRVN94FXjXXEJt1NmfWWmQWmI3T2sW
	 FkpEFHQTY6XY7GEulEVnZYwQVYR6Dx4dChZ6if76juu62pehEEk6NKd5tu32iku2egx3Q
	 WcTNv7F7AoijgHfCZypn7rtsM2OyLfTboiettMB/eezsbSUEpaU4dLncuLmmwqB8/P7wC
	 9cu0g6ICwwI4Y6bpsaeo7z/f/2LjQzP3fGeqcEbQ4vvodMPCgqVRXLOqML7ENg76r8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=frxjgyoP;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7C7606A31C
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 17:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B7C7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=frxjgyoP
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4a5506f09f5so825288f8f.0
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 09:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022644; x=1795627444; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8VmZcMVpc16J1nBk01fE3vMPgjnZWh0+ezLB75Qyp4E=;
        b=frxjgyoPID206coABVjIrRRPPTBt+tQ+/VNebzaUry3GUDaWPMUIraO24xHbSZ6w43
         FSVLkzLzJfmcTixBsJcCgynHtXCBuzfs8xMatGIDHzkK2swn0oWBSGVkpd8Bd1T8hess
         b1xU0fKcwNeWwfuAqjpsgSkH0Ehjgf+eM7sfSVRmmmm3AkeixIOXG/CA/4COjw6UHtc4
         SfH4Fy94bsSScMothl0uZsKS3Fvm9J37a0B6A1iU53P8qT8ov7P2yZRZaMIYUGChU/jj
         H3WdzjBnbqI+Db2OXLHmhvNX8yA2ivtf7AimDe0uQFfHZEk1MQuJ5uS4YUc4UncZZog8
         wr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022644; x=1795627444;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8VmZcMVpc16J1nBk01fE3vMPgjnZWh0+ezLB75Qyp4E=;
        b=fBVSK2vkz20l1nBaRckyyXlEkfZQIIbWjNz++2jAUAZme2SQAXG+ansFFRnt0dVONR
         PpYKXyxZn/WRiFUWT0zUhZ/UMBA3CzVjLScl/5E1Iki3vCQd3oV931Dk8nJ7riF9Yh04
         Pn0jU5vIBnsEd+6kOqyO0jQwEaLP5AKev7YVTLIkYpcm/ikdN1UZhM8syhJZqhKUKY6m
         q5tYq0cVV9kfwctaic9y6za+alqfh46mBOQYM0Me/6U9XAwKoPyuL1fIXNjJv5FHSxUB
         9P9umQdV8cY6WhsxDgB29dWT7SWgjY1CgPzWUxyFkcc9DLylT2Pap5nfyBmBqN5ihqfQ
         8hEQ==
X-Forwarded-Encrypted: i=1; AL+hErEbyyNeF/CMhrzZGety1runzNRFiLyn+o6D2sLY0AdIX0G8tqzpuB4sTSlOiP+Eh9ASa3M/C8S1oqQg@vger.kernel.org
X-Gm-Message-State: APuU4Z9IMJNXC7dXVOaTBEp3Fqi6MIYg77hPDyaO528DPAo09gLbDjm+
	Oy5POFX4+Hep8weZcKlmNUCrcVhsB8zXwHTm0QuJgQ11DPevSKsRTRUd
X-Gm-Gg: AZFdTZcipISkUunAd01oHyyqqg4oLfskT4sBqt8Kz9PY06VdvKJd5w2XnG/LiWI0rRt
	84MnGjyWW053+bIUr6r94hNi2hKvm+ltJQ9L5vnuLo73SM1O1I3hmPbvyKCYjWydbV5Kd0ahpfA
	lxJCemIR+RVmHHodWbt5Z3vUYQ6hIDsninyU6Th0eiYkgzaV4d/QfTxoxwkP2pcZMq4Q3qmCrVl
	fYYyXXI/Rie0lzgUTuciOgZPDtf2Hwiie7pxNZrMBLdfIqm6ci6EcldqXcnalQ2EQqxqErZWoPU
	8lapi/N2f+9Vg68oFds2xVCVllMf5SBlw6Hngy0a6hLVxVtdJayegSvLVtHbGe7UOU0uLK1Jjlu
	ja7Va2KqV00eENH3OR7cOuTC/a/iv3bZhMfv1SKiLRIEUpGgkMWJI/xWQMPQ6BJgYOd1bW+J9xh
	/AyVA7LyT+zbPJWom/T/mk4hbG1pndu9KJopshDmrd4dgyp0CD/zjBGHsBMl8P2gXm3hBPWfq/H
	FtbbsCrlNIcoobHYG9mAkIe3EUw0JY9sMbXl57AGNatjYkx9GwUC7MvaXRojX001e4S5TCtt8RC
	1VAC6E9kjQJcL8fjneSwxwIS+Q0Z
X-Received: by 2002:a5d:5888:0:b0:48f:f26d:c5c with SMTP id ffacd0b85a97d-4a638058303mr6313854f8f.9.1795022643534;
        Wed, 18 Nov 2026 09:24:03 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:de3b:51f3:e461:c0df])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65560b2a1sm5678801f8f.32.2026.11.18.09.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 09:24:02 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=bbdccfc2c1d2aebcf158821f40e232b6fbc6627f296287ed966c4171fde4;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 18 Nov 2026 18:23:48 +0100
Message-Id: <DMYIEZKEQXY6.EARVA8D4G55W@gmail.com>
Cc: "koraynilay" <koray.fra@gmail.com>, "David Sterba" <dsterba@suse.com>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Trond Myklebust"
 <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J. Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via
 FATTR4_TIME_CREATE
From: "koraynilay" <koray.fra@gmail.com>
To: "Chuck Lever" <cel@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com>
 <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
 <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com>
 <CAOQ4uxjme9sJ5LGNDnP6rEKZLTJzX_ZdcMohgu2iLULK96GPOA@mail.gmail.com>
 <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>
In-Reply-To: <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>

--bbdccfc2c1d2aebcf158821f40e232b6fbc6627f296287ed966c4171fde4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed Nov 18, 2026 at 6:14 PM CET, Chuck Lever wrote:
>
>
> On Wed, Nov 18, 2026, at 11:36 AM, Amir Goldstein wrote:
>> Can't an NFS client be connected to another NFS server
>> implementation which does allow this?
>>
>> I can't wrap my head around the problem.
>
> You already named the problem in a previous email: What happens
> when the NFS server's kernel is upgraded from an NFSD that exposes
> only btime to one that picks either ptime or btime?
>
> Clients will see a file's btime before the server restart, and
> afterwards, they will see a changed TIME_CREATE but the file's
> NFSv4 change attribute will be unchanged.

Not really though, newly created files will have btime =3D=3D ptime, and fo=
r
older files ptime won't be set until someone sets it.
If the underlying filesystem changes it, then it's the same situation as
if someone on the server manually changed a/c/mtime on the underlying
filesystem without informing the NFS server.

Although, I'm not sure if my current code in this patch updates iversion
on ptime change, if that's the case I'll fix it for v5 since it'd be a
bug.

Thanks,
koraynilay

--bbdccfc2c1d2aebcf158821f40e232b6fbc6627f296287ed966c4171fde4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCav3fJAAKCRA0bnTtJTDo
OGpSAP9c3bOzD+a1N5jl1ZhnFHHQAamxFgzhMndzKRwdMl1YGAEA6Y2M7vsijmj3
bnNJpnj8gPwfPO+5AFboA6admpWVWwY=
=xhrE
-----END PGP SIGNATURE-----

--bbdccfc2c1d2aebcf158821f40e232b6fbc6627f296287ed966c4171fde4--

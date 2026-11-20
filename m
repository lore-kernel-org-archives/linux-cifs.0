Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173500;
	b=EOQjhVrbcJDfSr/hxvbW6OPzm26wrWcfe1yCcxm88YV0SxQ4gGgqauH1U4pjy+Vk9AN3
	 E0H16g1g5Mr8gz9Rdo5QMIN6h5KQ5PDcMEnBaIc/vKGdtClBDyRkf+TlE11wQW5QPFLSl
	 OnDnzV9QDV6xm7mm0Fcna/rUdhy2jlB9wzk13/wAe+4VTaZVAxR2w5o8ulxMfIcNhZ5VU
	 osnpBiBHb9ioWpBV9XhXUjHN3ZWHdkpLyXaAF2JA7XZKNdk9pF2m+z5wxTs4WO0kyeav6
	 8bDkfW13vd3cpwCYyhqZXobC2jsw0TvX6+3FDZ0axd2yF6qX7Bi2ViZAvHbNweRRDMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173500;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QpwrwuyYefJeguNX3eB2vqlNgBeQx08UOZ2jn4SFsrk=;
	b=hcojDaE4nQmZpS8yb3RAHE3qoFW7YQlgQFK2YGUppIrf+D8rvcf+u9mSatYv/zwayYPm
	 XCSpybAo8QpFOO/SEL2Z0D62n+1SDpIStwvrhGbk0P5z9WT5PdV+M0iJ2TF5A8A3H4CK6
	 1qDfT48f9gpH7x667fiFqEsWW9RGaYWVa9fSGl+iHYjlI0bKBtlXqBlqGmF6w85/KbzxP
	 zk+E6Qa6Fb2/WcG/lDPi51G7syvOh0Rz84sH3haQvxzWcPYfed1uLagYnKpkyIowiiGY8
	 xom4ldos4AmTbh6BY3BvRAqJTfKO2Q1KzII166w97OnpZrjd71KK3oqmXfLlT5znXgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEFuWw0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E413E606A331
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 11:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEFuWw0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5131F000D4
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 11:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173499;
	bh=QpwrwuyYefJeguNX3eB2vqlNgBeQx08UOZ2jn4SFsrk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JEFuWw0ZqnxSsd9gApfHEoIfvpYKYnbgOZpVdQDg+iQtmNizS8ej3v/qi55B+uett
	 5XnjAzMHq6DOAVvWkeJ/hj8tk6mrD7ZHOH350tQ22xX3BNBy64/OsCGIwwgccOc9a/
	 jRgsxZ5WZtfuf6/d9MZpc20dqSNNi/vfbGfNRNZ0LyGl476sJSxHU9Ta13OfmuZSI8
	 OIlFNsDyZOEpkeICMLkR1XS/BWd1eiz2/Uufuo70ObXUh4BQOnWq28+2zdT719/0Tt
	 Hm8YvayZWybkMEVuA73pqvHRwehAYlGIgmp7ehiYxZ2vbiXSNVP/49unfHCUVnj1ea
	 OsgCm3exmW74A==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c5127c7abd5so130853466b.3
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 03:18:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH274xCVBKHcsIxOdoZjGUDp9p/YUe3NDC9KuAyjvlUvPvpWwI/a9BOQiEia0Uf5Aj7XwCy5cOEV7Jc@vger.kernel.org
X-Gm-Message-State: APuU4Z9s9CquOF1AqpT6SIFQFVzZoSSrRavc3Rj7JwhOWNS8RuiCmcUQ
	SC6nT/LUU/hFyulCmDsnL+N2Kg/N+Fw1ewBnX/WfMUhJzEFDo4dSL8V+p8GIm7QGRIC+xwSgG2T
	TzTvykGlhngN2M/m/o8Fm2xEsNlH+GKg=
X-Received: by 2002:a17:907:a890:b0:c50:9432:b7e3 with SMTP id
 a640c23a62f3a-c513aace654mr313122766b.42.1795173498034; Fri, 20 Nov 2026
 03:18:18 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120071553.28739-1-dennylin0707@gmail.com>
In-Reply-To: <20261120071553.28739-1-dennylin0707@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 20 Nov 2026 20:18:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9GV3R=m5pcebAiRb7vcLRe4tw-Vk8XWgVLR0-OJ+_Wjg@mail.gmail.com>
X-Gm-Features: Aa3M54ow1AAmnViuCcRhuE3VvWsArW1G6zfjgnzqBu6nqSF7-19scc4JFqMlbdk
Message-ID: <CAKYAXd9GV3R=m5pcebAiRb7vcLRe4tw-Vk8XWgVLR0-OJ+_Wjg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: refuse to open an append-only file for writing
 without O_APPEND
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: stfrench@microsoft.com, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, hyc.lee@gmail.com, lsahlber@redhat.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 4:16=E2=80=AFPM Hungyu Lin <dennylin0707@gmail.com>=
 wrote:
>
> smb2_open() opens the file with dentry_open(), which does not go through
> may_open(). inode_permission() refuses write access to an immutable
> inode, but nothing looks at S_APPEND. A client that has write permission
> on an append-only file can open it for writing and overwrite the data
> that is already there, which open(2) on the server and nfsd do not
> allow.
>
> Refuse an open that asks for FILE_WRITE_DATA or FILE_APPEND_DATA on an
> append-only file like may_open() does, unless the file is opened with
> O_APPEND. Leave these two rights out of the maximal access of such a
> file as well, so that an open with MAXIMUM_ALLOWED still gets a handle
> for reading.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Can you check Sashiko's review comments ?

https://sashiko.dev/#/patchset/20261120071553.28739-1-dennylin0707%40gmail.=
com

Thanks.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828648;
	b=CbbYv3rGtLLqeeVSWK1JSUO+NN8hYRCuf3oDEpgHYxusyvtiTM2OXVvPSZURSKGdF9aW
	 Ija/F5FbRz5wngrdd5o8cS7btNul1BHg6Y5xdQR+sU+G/hRTxLXfBOLV11j9q3t6tJdUq
	 Uql6JEY6ZSrSiwUbJ1JP+u19jr9XgbuxUgEAxtFcwBQ6vqGDYPZd8eR/KT5rkSqMv09xf
	 rO8atCNjZcoSjkrm4qO329aofQ6EHD/DRxJJ+W29LebozREhC30VS8ppSGHx2vVCyjwvz
	 5uFid5hhMNtfnpJ3Ycj9Bahe04zV4aJsAJ3SfH5fwoda65mcOJO+Ts8mP2/NHdVN1DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828648;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6SPUkkDnbGx0di3Iciwy/aQpzoJCxAXF+HCwj4dQ2nQ=;
	b=PBVSJN1wKsSsfNhIsV2nWKbeDZVxsbwTAKfLNtUUy/Lh4gWOP6XSuBTJAuY6opVQH6mb
	 qT9LSTf6lWuw948Idjp8I8JZ4Kn2gS6g2lv2WE9BUFT8bXksuli+rC3a4kfRJ1DDhU1FR
	 kqKkxdtYM52vy4oVU33y39QTdrOmULKfR8aYMUyQN34aVCAPNNG09wJOGKOPxVXPTHFcm
	 eRwLog8y6qt0cMuGU0U5Zv4FEF4mpdzcnKIbMz3cj2ev8feuaM/04gE2h1BFCnUejv1vU
	 8Gp5bdGOXabbve+Z2ZaeCHYYfzXEmRPRgDQ29uzj/zJE1setbMKNM4g6RC9THDFdPpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QevbtlhX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E387606A31C
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QevbtlhX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C751F00898
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795828647;
	bh=6SPUkkDnbGx0di3Iciwy/aQpzoJCxAXF+HCwj4dQ2nQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QevbtlhXPaFPCy2DKvXJNaYEq4+oZ7q0DYAAKtT9oQa6N06FdNKJxNZPy7R83xqpx
	 y6Z87xtaAObr/la2oCKt6gXlusAdmrOsyqejsFN3jVp9xoxS61amcSg3/ueLSBnc+X
	 aU+CnA+AKQGhjNd4xaF/P5amd4ezP0U9D8tKNRdCC7oWQMPlKLoXJ6/+nJLjYC/cN2
	 Xo2cxu8V6aVRfWeHEtB54J3LO5MGXh09GKYgtqOgKvYRsc8kH0te+psOZ91PIDwntS
	 lrqAC3sQjgROKpyfGgJzrZsZi7RRE8EgVZ36RsJmOaSGo2e+cj7KcTB7imIw1gb3CW
	 nlW8BdzgrCSzw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c5126505cb3so1135781566b.0
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 17:17:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEvcFf4SnJ9enMNeK7WD7cgb4ChC2BjKbTroYHcCF7YsBKT9N1n7KmcGqm8gQD5XVQtFAX+t3E82rRf@vger.kernel.org
X-Gm-Message-State: APuU4Z+jWFPDDhdcMUCmLLmgTMyltikBSVck7iE3rvJNSZviezEQbcee
	24Z3g3XKDIRLhYu8EIlwAHS4+vviGP/srjBvKVOL+ZmeOC30Zgqv1fPvehrBiKhwEFHIDEs56yV
	M+IX1Wr/N32rCf6v/0yhKNGWtXsfSsDI=
X-Received: by 2002:a17:907:934c:b0:c51:282b:5489 with SMTP id
 a640c23a62f3a-c513a4aea3bmr2092619266b.3.1795828646455; Fri, 27 Nov 2026
 17:17:26 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261128000906.1677969-1-icb@fastmail.org>
In-Reply-To: <20261128000906.1677969-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 10:17:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8_QgT5sM0Uwg7DkKPoyKqBVaFmbCb8Ay13sUp3cBYY1Q@mail.gmail.com>
X-Gm-Features: Aa3M54r2iLdu7Vku85h51LckhMl8uk9uQ3dQlA_gkNCPmaojH9-_QYon5N12iqM
Message-ID: <CAKYAXd8_QgT5sM0Uwg7DkKPoyKqBVaFmbCb8Ay13sUp3cBYY1Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: don't take an existing file's attributes from an
 open request
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 28, 2026 at 9:09=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> When smb2_open() opens an existing file that has no other open handle,
> it sets the cached attributes of the file from the FileAttributes field
> of the request. MS-FSA uses that field only when a file is created or
> overwritten. Any other open of an existing file ignores it.
>
> The cached attributes are shared by all handles to the file. So the
> client that first opens an existing file decides the attributes that
> the other clients see while its handle is open. Stored DOS attributes
> replace them only on a share that stores DOS attributes and only if
> the file has them. If the DOS attributes are written while the handle
> is open, the attributes from the request are stored and stay after the
> last close. ksmbd also bases its own checks on the cached attributes.
>
> Take the attributes from the request only for a new file. An open of an
> existing file starts from the attributes that the inode implies, and
> the stored DOS attributes are read as before. An overwrite still takes
> the attributes from the request.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!

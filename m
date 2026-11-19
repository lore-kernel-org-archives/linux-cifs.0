Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795109669;
	b=45OK3gul9LaapCc6L26P6TH82Tn2SoH8K0Cgn+iRSs+XbImmbW3P9zLrFHOw0YRm6Gfh
	 +k7KpxpQ8BtsB2hU2iK9cPyCoSsZGQ80hGimThu5ccsUN3FNa8mfKFWA952HUcTBjW2AL
	 nZSHASZrtNNElw87PcT0FaTs1yMf+gZS7/EWRxff8PlOGPIbLn409h2HEoDbw5qGQMvkT
	 +zFmgUk5mGrJblO2NxZV2XuQqh3epHeFabUqVFlpfnQK+smrcUMphl/fAetVBmPi9mYzf
	 WwYyQCN6I9Yl/nvAvFpQQI3fJ27JeN74CttByJ2T+tVgHYYeXHlYfDQEWYvhbeQCtVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109669;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
	b=zW5EMl+uMEiZDTDwDEk9Y/2Sh8tOe1AdhO6tZEbIcGkJQh1CmpJVHgUCi2S/sQAARuIc
	 lqxiiI4qzYK2wQy9xbG/zpptvDiUTqN64LysoqvfQp4PBvtdbTiludZs5FXFz4jZvpcD/
	 i0Nyo2mCXgw2iWGCsdXBSsQyoLgSL9WU7pPoNw3pWqYMz5hBw1Mh81zVk48AIQ6gRzneG
	 uv6xK10WM3I9Lme+ek3NlFUtZpTPlsGUF9GTprQqTPcVsgknQ3olOmsrgxfOM9I6bpf2j
	 +ZKy8EkrNYjhaPXp7h2foBm2V9kHVJOSUe7/kYZjMwRWS8J4njIfyjOKxkYeEsmEIzA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nGC6aRIF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE78606A337
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 17:34:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEE78606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nGC6aRIF
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so4220504a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 09:34:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795109667; cv=none;
        d=google.com; s=arc-20260327;
        b=dHC4zGb7mmWkS1rH3J7fYDThHgS+eSUTuxRTVEijW+vZR7U81iT26QpT0bz3IID7z1
         wHG0MCux4Ucn3lBchoFwP0lgOQwQi1F4rDG8GyN9nb4UpsKE/ddP+QEOCiaY/7gMrWVF
         AgeAVvkVhRwsGmy0ODejbZl3dMYe9l/HdKvTUfnWiXPQf2A8drD7F2PjengbGtPhXNZ9
         zj8CG47iVm0Os2E7tKK3m+j7O/fj0L4vYcBRvZi9uV5uldtNGQpaL5hS8BGyup7VRcwd
         vpV/NtCAaUH/2TCDSZmA3u+Bex/iMgaiTatMUv7zlM0KO3+YtBao+pMB8X+TbN7qtXoP
         LijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        fh=Le88dDlgF6jg0HarXpHbQJneE95eTKf2p9W/4eU2KaA=;
        b=R857h36B8sCItnRM7vud3fr0iEX+gDLKh72+Zg3qkcMgcd7H5FBhIT0ZXMuj9CnCug
         cc/3p1z3TXorHLXO/HIBrktvaGKOuqebSNCraUT21EAhROkl42nqda7u0BUj4vt2GXmY
         U9rFrLuIfMXW/oYE/SYeZs1REnCO+pSXrvFStHA1XQwUz1zEsnvF8q2HdPI5HYbIdeI5
         EcyoT/ngxr/K6zJUtecFzk7bnUrN6DI544IpoWX4rGgMIy5DjZZXTEvOVRZNGfB6vlST
         8qz/bWobwli430xnOH65FBwPgEEphzPX1st/5LJetU71yU7ROScGOXON8BNzFyYsbuGG
         juxg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795109667; x=1795714467; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        b=nGC6aRIFchP5t8lwJ/zVTOI/bLa8AV4FvgJg6w8MF9wmm1yRU1tUTokZFa/paaDJ8e
         5PUOtHahetL7iiRPD9uRZGlho38PnlwqF01pD+GRX36RYtqopRY+6tUdIUx/3qzL/D90
         5amQJu0ziL+hdep3ub8xpqOFUa0Nq+K1582CqDJ7KCIXsfa6geIe36gqovNyjbgAUMjf
         2HpGIgyOw12DPpv97GDYb45yfSyQVjodaas6oDy6hcvHkFleTSnYO0ogudCUxCFaFMOW
         LleZntAPokivShBafvD/8UUAi5Gk0sYRA3rFd7SRoFsU1qI4IwU8icU0s6XL5OAjoNTc
         ilJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795109667; x=1795714467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        b=OScWU5JXykxqFvWqPYjiDt795SXNuchTBTdDMO4jQNRTQMShT91DVIvKm1PlrgJM76
         qTmbRMEUTDdXJKzvmXGs54D9Utgr+o+KCgjUt8jsKzM2aRuIkrfiCYqy2XXKbLHsmIgs
         VOeIEPn42h50BBS0oSZmiejosxbuiVtDpHSJczeYlzxwr6LFDqUY8G4hPjOX+WHO42ea
         UvVojEhg5Q1RXsRxsVdCVexgB5CJL/+vyn4jlSgois3YJjJ+t8zqwdQ52ZSgApx610Ka
         4rW8nj5JGvsmd3IOj0jodBnt7sEN6FLrBTHgbtgYmXe6zDv/gB2jICDMT5lmnI4vMnUS
         ESWA==
X-Forwarded-Encrypted: i=1; AL+hErEoPu8UAtD99EylSg9O55V8EPJM+CS1EnuCWqrJ93QET4XAIVgaTTy2zr77sY7+4EjHWRX3JlQJ2M/i@vger.kernel.org
X-Gm-Message-State: APuU4Z8eU/9g2YntQ3HH4eWTezyj5f4WYv5x0Bw+TsqsIl/Iguav1AcK
	gVQXOwQwGeJuOT1py1uODgbolAfKwOxVxbz7Byq8vC+WI4yRJbA5FrbAF+eUP3EDn6FjYLs4ERq
	CYHhSy7ucKU8zlNlh/vvN+3mGphCpCOI=
X-Gm-Gg: AYBFou3tETX/od5BIiFyCcI9lmfF4p4ZsqHWvb+hZAlSVOppJkAJQH4cqM1pMsjU3yH
	eVuMk0K7P+0fZBdPd3wjfRYqE7lhJUV85GKySG40bArlipejv7SW32AzMUdkDGKSp7c5ByUckvH
	IouA1yLVbxo/BqnRIb5qRykkVKYqIU6IndGTfsQY2Scr6cM1lTyc/zFzqXuK3/UZRDb9Ks8qKUj
	E/M27AjmuzPa9g6WmQzT24MGb5palkLNlEPaSQvyljYzJ4gsHyLzJxOhxqbbpvOnAUaObvfHO39
	aiFEYboIfK6Seq++Uw1GZjUN+whbw9rgqlYvgSrknivet+psigQKNcZ2XBXfQIntRiWRl6Wrl/c
	I9h20y1QOv4Qz00tpsyu4gJGfUjr4/PmdufNdmU8Wotnx0OVwIYdAHt0hg+mip9n4DnueJQ==
X-Received: by 2002:a05:6402:70c:b0:6b8:7d98:4826 with SMTP id
 4fb4d7f45d1cf-6ba37d5bf0amr50117a12.11.1795109666761; Thu, 19 Nov 2026
 09:34:26 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-10-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-10-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 18:34:14 +0100
X-Gm-Features: Aa3M54rix9St5Car4447U2IPLFR0HdY95bNJiBlGTi0-FAZstJdvxSGCP5IQDxw
Message-ID: <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 09/10] ksmbd: add provenance time (ptime) and map
 it to CreationTime
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Implement provenance time (ptime) in ksmbd, as introduced in a
> previous commit ("vfs: add provenance time (ptime)").
>
> Map it to SMB's CreationTime, making it settable by SMB clients. When
> reporting CreationTime to clients, prioritize ptime over da.create_time
> memorized in the user.DOSATTRIB xattr.

That doesn't sound like the right thing to do.

If the server stored a CreationTime that client had set, you cannot
override this.

When the client sets CreationTime, the server can decide if it can and want=
s
(may be a policy decision) to store CreationTime in PTIME and not store
it in user.DOSATTRIB.

Fun fact: the user.DOSATTRIB format also has a mask so storing the
creation time inside it is also optional.

Thanks,
Amir.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B48256D;
	Thu, 17 Apr 2025 00:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744851499; cv=none; b=dAwuJD7z5vNdiayZZHxvREp5TT0sQDimRvuMoXOHAsr6QVpz4jVkoPJ/W3Uj4AtHLZZGAXoZOFSUqRAxJJkYMv/MeabgjwBbysqffNwMvuxOwjxBntG1rzv6n0iVTdtJq0PfDo37RPrRt4Bvw4uEulkvGS3OHMAMMtVthU0pLYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744851499; c=relaxed/simple;
	bh=mdwBWJFnWt+yos4kCuaEtJ7BaPz/4gkZesgIEnShi0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p75SOmDHZi39Yith+GpF271LSRk+uiXE9dykQbDWn18Fytn3VTYWhInEqSOimjvXZuh5jFCFA3KQD9pmLwphgoHZLg2PcDHC3Yo9QGnjelBSR/nX6Lj0w+q1o4jwP4kVIBZJe27tHTEOsnX+IG8xWRmoJwzhXR9BgsGPc/3Jvzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N8kzntf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N8kzntf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6E6C4CEED;
	Thu, 17 Apr 2025 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744851497;
	bh=mdwBWJFnWt+yos4kCuaEtJ7BaPz/4gkZesgIEnShi0A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=N8kzntf4t6pE+EZImG5+TA5Tlro1cK+BECpae4bojYT6uZcoQOKi/Y4bx5A+ZMbv1
	 SELZuZnmosbRlrwHOYqolKBAAqg++R4C1ixRUtNgbaouR4Ze6TsdHjxFr1ne5TeQTd
	 +SZz1Of7DG15KQzrHRPhnbxJzf03GV4XUPig844x2kQZga6xVTA1xZLzTpMASTa2c7
	 QJLVVJJk0j2odqITQ3u2a2ZoVid37dSZ5aApbZWt8HwIyZCm+Gt3d/JlnMfiJzIgwb
	 9Sj8PKDdNMu/bhhhM4rhRJyYxhUFAoClDqP1OfHPOkyNEjGJk/gJZxuHxQzpDoSyYf
	 WkLatXEZG2Ekg==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-603f54a6cb5so112981eaf.0;
        Wed, 16 Apr 2025 17:58:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVdGV/tbshg5eCcM6kjYvm/Vu+sjRVKDByUHJrslOl6XFJ1IHmeTLvG3+UpmVdKvvll1taINyuiGkna@vger.kernel.org, AJvYcCXgZweSEHyx/NPdReQ33UocLaDY9H/3I8d+7DmhPFX/6s/Ur5C0o1p3T02bK1Q2NFPUKqRbGxyphBSM4gcf@vger.kernel.org
X-Gm-Message-State: AOJu0YxiiyJRT/mbgRWYLWWDnY6bk0HinMAD3/rHdV99Kb1KGOh4AapM
	h/b3KDBWfbkhrhU6Otm7GpFnh1MULZwVFRKz0ZglXEKyKJL21CHWB7aT72xVUvgxFCL0/A1NgvN
	IlhUnprpR3a9gmHCwlGVSpxIUlWA=
X-Google-Smtp-Source: AGHT+IEy1dWiY2l5vX1BBMRM60bEhU8l++DRF2965mxk3GF+QcMTzfMHuDvOwh1jl2izsUQBksyYCyO9TK0nnP1dEOY=
X-Received: by 2002:a05:6870:9c8e:b0:2cc:3603:f05f with SMTP id
 586e51a60fabf-2d4d2d7ddbcmr2770411fac.35.1744851496735; Wed, 16 Apr 2025
 17:58:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aAAEYYktAh0SOKzb@pc>
In-Reply-To: <aAAEYYktAh0SOKzb@pc>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 17 Apr 2025 09:58:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8jAtCvUiMf1oVqsvxum3S638DwMg3FyzXTE=dEJOChKA@mail.gmail.com>
X-Gm-Features: ATxdqUH9qP13dtYLpAP8jck1RnbVoP_UElKXul1kO3TXGYK7fP-Do4VzINDcK5I
Message-ID: <CAKYAXd8jAtCvUiMf1oVqsvxum3S638DwMg3FyzXTE=dEJOChKA@mail.gmail.com>
Subject: Re: [PATCH v3] smb: server: smb2pdu: check return value of xa_store()
To: Salah Triki <salah.triki@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2025 at 4:26=E2=80=AFAM Salah Triki <salah.triki@gmail.com>=
 wrote:
>
> xa_store() may fail so check its return value and return error code if
> error occurred.
>
> Signed-off-by: Salah Triki <salah.triki@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!

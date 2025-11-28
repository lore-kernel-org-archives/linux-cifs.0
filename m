Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352A32C030E
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764352143; cv=none; b=m6u6dSF9pQCa7OxZYGXDEhjC6vcE/NsDHdZn/go+ZbwJzw+GjZPgDUQrVsVfmCZZClS5LROfiNWNqeWhQ7NxJAzbsTlpp2Q55veigxzyhcQePBI4GJdga2pk+fAkIvodHFqbS2tNfuTKVJ9xB0wr/Zqt4lKOsSMiOQrUgvw/5TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764352143; c=relaxed/simple;
	bh=eMLVlDObxV3AjoXUpKAGfoGdWhF+cUqYZZTo4j+zorU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eCCwAe6N6105qG23rJ5EhzYg/Rpp+p2AXLJizbQ3JhhQ/0wthlzhViP/Uth7kRY0gQ5HbI2nMGeZssi1uVrWBnECU3PSHtFwSLgGg4wRZ8mBrpwhsy7Nr9nni3TizPDUGHLfdBFysXqxDzA56se1+/88ZEA3H6qz6d9Y0EfCpnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbB4jotg; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbB4jotg"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88246676008so22395586d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 09:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764352141; x=1764956941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1j+Znd9SocCfUqvoBrfqtGnxCgC6ec4iwLsr5isAxlk=;
        b=GbB4jotgeUPEeDFwAcQAAklBLI+yue2T6fUMIhZqF3+0sCVXSc5clKE3ygXvUflszz
         NmLf0u+//R/VCEccnlwJ3PBVBM+srUujnw9Np4SrlUJsl4/2aNZEQUeIISH5yi2rLtnK
         /8vILIXI5IoQOOgp3G/VoYOIJNV5F+a7xyUSy7vAOY6a5FQawx1A4M+YmmDm5lwSLRtb
         vJNJYoZ8LbQzpi5GlofBAt0fPXfsxUh2IslItyG+XAutavNHWSMkFwDpoHKIRt5EZoE3
         GMNELSn7uhH2aUWyQmkK7v4EgJSodxHqdBVNmwF/T06X57GIRQ+fikVVA5h6xsjsWwKb
         4IDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764352141; x=1764956941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1j+Znd9SocCfUqvoBrfqtGnxCgC6ec4iwLsr5isAxlk=;
        b=Wsi2kHoj7mbKGTijTTElEf24oMgeF73iZmB/VqkhNG9oiiqkZbE6LTcLeS9pK9cpCA
         svnEINeo10g79VW/M0tGM+7RKkY6IFeECL/gfzqAElY+ELbvJ3CyfM84agyZPXGDJM8I
         gGDjW9cro+kRq2RFGoldgm7gevsBycY0Oqa4OZQgA7zlyA6wZZxoky++vKVRYhk1ZMTR
         05CVdQ0/ZkumzSjynD6aZ+LmuPYNuDJX+7BCQ58ssrxJAEg4uq08TfhQzddAnvcGoF7m
         CNTnBFsENTrrtfCFj5dtM2G3LVX4b4Oz6ieNLbdWHhX97KhXhjGNXXghLWwEF4AShP2c
         AFnQ==
X-Gm-Message-State: AOJu0Ywt7R9SYTvfiNRXXVbRLcnxZ2XyEAg5tWJa4TuZMbrfFehcxOSW
	RucMIr2n9fVJ05EikjUQtStU/mKrqyhvhHRt7qUuFTlJrzArwikUEBG/KMqgJc5Y9JMQKQNm3BK
	AuUyAs8GCdgs6AhIQpuAR+Lyqm+rH/fNX7THk
X-Gm-Gg: ASbGncvxx+DpZ+5ekB06Y3nV6O8O2M5xsQnFRnSy/kNJJ6B31l+v1y45Fn8shJRkPBv
	hkRftep6Zdw27Wvfmbq5eVqIVKiHN/9eA3P3kf0eLINEddWaC75LTHozgkFPwb+9/PJxEC1isiX
	kodFj3fLsS68O4H80EwGukPr5pppDSWDivkMwTAQ6iRMnL5pzm+NYb9CgCvu2mGUaVEYZh0aKe5
	u6lwfiEVif9PoTpBNVLGrfcLOhxWYWQJvxRMnl4CLG7iNLaEcedx6VphE2XsgrENBvUlWDnoXpf
	wChIxLaPGSKEa+I9UJcrC8pDcpI1RBAIZLIFPiJtEMv/IfZQEuo1enonO72QiMwWbK7gFSx5bmW
	WbAVIu5S5kuIOM7U8sgTmwq2YmYeYlVVAtm7RPal45Ujz25oxBq3065iQKDSovlvHB5cAPZ2mYj
	qRj2G4z3ZU7g==
X-Google-Smtp-Source: AGHT+IGOt1OZisRoBQVo5Br6M5w5h7ScU+QFY7p8Y+qTXg2UH2aI4E1LQ4aQXw/ZMZKsrfDcfRAfJ996vJlszgzMxUQ=
X-Received: by 2002:ad4:5c8e:0:b0:880:535d:d157 with SMTP id
 6a1803df08f44-8847c544e8dmr458060866d6.31.1764352140820; Fri, 28 Nov 2025
 09:49:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128134951.2331836-1-metze@samba.org>
In-Reply-To: <20251128134951.2331836-1-metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 28 Nov 2025 11:48:49 -0600
X-Gm-Features: AWmQ_bmsnc-u3HX1k2Dmt7K5Pu8RM2fChqHU8lb56kDILHmFmHZBQwiO24VcJbU
Message-ID: <CAH2r5msBaRVPNkaMy0iQKPq9COR+p5+UUNf-B-Fh6=v7zKNRnQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: change git.samba.org to https
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 7:49=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> This is the preferred way to access the server.

Are you sure that is the preferred way?  75% of the entries in
MAINTAINERS use "git git://" not "git http://" but ... I did notice
that for all github and gitlab ones they use "git http://"
But maybe for samba.org there is an advantage to https?!


> Cc: Steve French <smfrench@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 047d242faf68..d55c1c263e71 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6179,7 +6179,7 @@ L:        linux-cifs@vger.kernel.org
>  L:     samba-technical@lists.samba.org (moderated for non-subscribers)
>  S:     Supported
>  W:     https://wiki.samba.org/index.php/LinuxCIFS
> -T:     git git://git.samba.org/sfrench/cifs-2.6.git
> +T:     git https://git.samba.org/sfrench/cifs-2.6.git
>  F:     Documentation/admin-guide/cifs/
>  F:     fs/smb/client/
>  F:     fs/smb/common/
> @@ -13611,7 +13611,7 @@ R:      Sergey Senozhatsky <senozhatsky@chromium.=
org>
>  R:     Tom Talpey <tom@talpey.com>
>  L:     linux-cifs@vger.kernel.org
>  S:     Maintained
> -T:     git git://git.samba.org/ksmbd.git
> +T:     git https://git.samba.org/ksmbd.git
>  F:     Documentation/filesystems/smb/ksmbd.rst
>  F:     fs/smb/common/
>  F:     fs/smb/server/
> --
> 2.43.0
>


--=20
Thanks,

Steve

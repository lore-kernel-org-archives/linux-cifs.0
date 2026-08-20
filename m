Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4EE261B8A
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 23:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787269999; cv=none; b=RvVIWLr4LnnFczQ6x01Fv83GRsLYQIB3CTmZI/HBnTOMhcqDG78IJfXgKX39YZYXOF5bMyOBLftorZiOP2XNqEHXWEpaKhG+lHAfOfmeeaIdfOsMg2z8Vh4S7G82tVokVb7sbQTCSAr26B/C3IgUWefKXUVpg2WGmZlHlCauvK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787269999; c=relaxed/simple;
	bh=xM6r3AhSMBzvr0yPEMj2z3NZo3h7skMDAXZ8rfJsd4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YvL2P4ShE+iwuJEijOCuGaxl4R8uc6e/Gw4w2MJGrkR8yypp9WvESUMmxv3NoY8bB39q39SeEmFurgCvrC1r+d7ksscP4S6q1LsSvyMDj3gd+3w+vRjnElGpXjgMSw8LGo09ZNoZJxyswqpAkxoNzKoYEcOUfQSr4c4b/1/a6Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2igLnz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2igLnz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459181F000E9
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 23:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787269998;
	bh=xM6r3AhSMBzvr0yPEMj2z3NZo3h7skMDAXZ8rfJsd4M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=j2igLnz+lbz5IqAJeBmMlPgs49w9QclKkVSrLiG9Myd+m/KWIFxiTTQJAh6cckPpE
	 9wghjxPzUCEkrhd6hxzOW7L/UJKAXixjdte9YkCmwRKXUn9p6krxmZJEFtRHPgE0lo
	 x2+JWfyPv8cKhZcNRDMWtO9V5lFeruH2T145xZj8Lo01OG7pahZzn3A5g/yBKos7tL
	 ouH3QvRENGbO5XE/NR03saxE1OBGFYZgM8BTaz6ETgDg/nidOktiuFGurv/Wp+V010
	 0D9FagNbQCR4JnCbRJxg9NKEZdOIhEom9HcpWdGUyIwLudQk10GF0ZqDQqnEgVDSkF
	 NaY4IjCJ1l+wA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1670dad7a8so71891766b.3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 16:53:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YwZiS4Hqnt0Gk2zmoDurh3Kt7pFU8gIoabzm3mdU322/u646AZt
	bVDH8mJcfiM/Bj+L9i1+14cTJFosU2+Fi3r/B2HFhmKOv2yHHTdUnRdbXsm6LS5ZkXpAPzNcUSX
	8OCYYvaF2RWCTnBZAdIueL4q1mJxQOME=
X-Received: by 2002:a17:906:4787:b0:c24:6f60:3f7e with SMTP id
 a640c23a62f3a-c246f60404cmr140093166b.2.1787269996927; Thu, 20 Aug 2026
 16:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820212210.1475817-1-sorenson@redhat.com>
In-Reply-To: <20260820212210.1475817-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 21 Aug 2026 08:53:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-a3phtwshP_x-q7ppK7tkQP2ohGvGicDXyLp25xo6sTQ@mail.gmail.com>
X-Gm-Features: AcwNN1XSAjHTO3R7PTZA26cvzfMVbadR_GcjRszqLSYC5QKgGinY425FE8P4PFU
Message-ID: <CAKYAXd-a3phtwshP_x-q7ppK7tkQP2ohGvGicDXyLp25xo6sTQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix copy-paste error in WSL EA length
 accounting for $LXDEV
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 6:22=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> The LXDEV block in cifs_query_path_info() uses SMB2_WSL_XATTR_MODE_SIZE
> (4) instead of SMB2_WSL_XATTR_DEV_SIZE (8), undercounting eas_len by 4
> bytes per $LXDEV EA.
>
> eas_len is used only as a zero/non-zero presence flag so there is no
> current functional impact, but the value is incorrect and misleading.
>
> Fixes: 97db41604555 ("smb: client: parse uid, gid, mode and dev from WSL =
reparse points")
> Cc: stable@vger.kernel.org
> Cc: Paulo Alcantara <pc@manguebit.org>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAAC28751B
	for <linux-cifs@vger.kernel.org>; Sun, 26 Jul 2026 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785081960; cv=none; b=PXycJwe6iHCX3gEyn4OBDicpbG6SVdt4HWSwU2wn3spAqzKBmyPiP0zsJUIincRtBvglaejus2DQo+AZIDRUwsavMqxUzG4fLJPo1RMgh0gf3hIhgKjeS0sJaLcxRTp2PAKr2JV+Y3DhYdAsfujfsLRk5nthxtfdVDDu7hnnHTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785081960; c=relaxed/simple;
	bh=A9TlZbCCHJr/Xb29DtVGW4JZQdWMnn6sIVMAxmt22Bg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=KQGUdrPiMk7Nu+r6uZv2iFNRRXPatytYsO2Po4dzBxANGBcoABzPdPDU3cjQwCPaediHc9xIGVKYHhozSYNyLaqFPWkYRv2yqSw+qxcxeWO/DmZ2xJ5+kEEj3SBB8gF7CT2KQKIDSxdtR+PjaLfeBpeYxxdNp13vnmkR2YnnEjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8hWtpJ5; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8hWtpJ5"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so13217565e9.0
        for <linux-cifs@vger.kernel.org>; Sun, 26 Jul 2026 09:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785081957; x=1785686757; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=A9TlZbCCHJr/Xb29DtVGW4JZQdWMnn6sIVMAxmt22Bg=;
        b=g8hWtpJ5I+YBkqBXc87iDlCBv7wYhoqzKdainnauCtDD+/jMCsQJCZp0SKutwQIxJp
         C+DqRHAk8g4OFoGV//aef4rXgVpiWC1UmgojF4B3bBYVdcMvWnJR1yQMbdk1oPbfc3eG
         Yn7jtBB7YZsh5KOGqlC1DCaGlShgUIVP9b8UUYw2if07EPVrfK5KWZR76R1dn5PzpNue
         H1YQHcGRpMotkviH4zrow+xlG1TynnH7PQ1wXmgIU8M1x7tJdMvTsytfb+nZWomnBBRw
         e/15Nir2NYsCMeMId+btj2VU/AIg+WuLTeXT+3/bM2VXxDg6gmaOEkvb+drY5H8YK765
         6c3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785081957; x=1785686757;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A9TlZbCCHJr/Xb29DtVGW4JZQdWMnn6sIVMAxmt22Bg=;
        b=NddcuwLD1Z/I7+gI2H1FPuzPbeLfMImq1picnz0A5/xEqnm0U0ch7XnD+bkropcHmh
         LulCbb5H6Qn5pvJlpE95kaRrU2fJyyQD2xMoKRJfSBdrlH3CQHJHvU6YxNJlEhNqOdeZ
         ZfFkHaJgrr1NqOMw/+i30WIytTHSzE7YBNJuST81MgPfzCfM8vX2n1PnPJbnps4zxZM1
         ePxbdbqvd36MiDcv/54IFt/uvIQ77jHH0G0XTRlkcUsJ54762+mMVI+3atjgJuiAd2w9
         ic5uqDB3sxilC75tOOnslj7wKpxWunT+Xg+SQzCuXyDNgAHdzk5lPDZONAKnOihe1sRz
         0rDw==
X-Forwarded-Encrypted: i=1; AHgh+RovhCa7iM4PgCc4FkcY6n9/dkEvurEcaKK6IrhhVguC4u0+dIeouAVxrQVx3PYF4oeUBHTmNb0zttxx@vger.kernel.org
X-Gm-Message-State: AOJu0YwsUQfo3Ts05WYH1wnq+CbYrEjU7uaGD7EL/g3axOEu8k6uEhtf
	f1sCWRFYwPBPDOTxquefEwVfUhKC1zz7kDnrFPXRvmB5GgNhKi6vrA3HVPidoYsp
X-Gm-Gg: AR+sD10F7VjmEyBery2OfF8C2pHqLa/XPTWQHlN1vGMND2DEND6juRSfnCSMa3xhGr6
	59icFmfSwmU9hHn7/kB/HhmxsG6kMvpeDW20F/VzC0jnM3DzOF7J141IebF3pU9m7aMOgC18c0F
	X0lzl8u7DDiGaQBQ31ZKXVKvhKYth23qvMGDBfJx9jOq1IC2oD3p8SWtC/DIx5n8aqBybukuvl0
	LCdlE933ghlhkamwy69ItpANWujfieAF4COgftR2iteWaNPagckkEN4wG3alObppExV8a3oloYl
	15ax9/YGjecgLyXQo6xRt6rGMV7ILMrujUYC/1EQhhhzGbCBwtEu9yTH9FYzU2exZ2lewG8OgW/
	zrcl/MStf3Qupw5fuqfZ47mj+xAfzEaLrIoZ60aSVcdD296MQec51vxAYwGjueyRzRE3eAoGXrO
	thM4xzJLS1BVKo0pg4Z8TCCkVvQ4nIXDT5WWm5mJepLMU=
X-Received: by 2002:a05:600c:8485:b0:495:5943:b76c with SMTP id 5b1f17b1804b1-496b57281a2mr71746415e9.34.1785081956497;
        Sun, 26 Jul 2026 09:05:56 -0700 (PDT)
Received: from smtpclient.apple ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b49a8547sm149055715e9.14.2026.07.26.09.05.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 09:05:55 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2] ksmbd: refactor smb2_notify() to a blocking wait,
 matching smb2_lock()
From: =?utf-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>
In-Reply-To: <627eb275-ca13-468c-87fa-f40c4e887145@chenxiaosong.com>
Date: Sun, 26 Jul 2026 18:05:44 +0200
Cc: linkinjeon@kernel.org,
 linux-cifs@vger.kernel.org,
 chenxiaosong@kylinos.cn,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Tom Talpey <tom@talpey.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C65108ED-0865-418A-B2DE-F8079369A142@gmail.com>
References: <20260725102737.33616-1-g.blivet@me.com>
 <6813f121-5fe0-4542-85fa-7f06e093c24a@chenxiaosong.com>
 <627eb275-ca13-468c-87fa-f40c4e887145@chenxiaosong.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

Hello ChenXiaoSong,

Good catch. I also confirmed after testing that it is not needed. The =
initial analysis was based on packet capture and I mistook it as a macOS =
requirement. My apologies for the noise. Could you remove it in your new =
version of the patch, or do you want me to update it?

> Le 26 juil. 2026 =C3=A0 10:24, ChenXiaoSong =
<chenxiaosong@chenxiaosong.com> a =C3=A9crit :
>=20
> Hi Ga=C3=ABl,
>=20
> I tested the macOS client, and it seems that this check is not needed =
either. What issue did you add this check to fix?



Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D5B2517B9
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770917468; cv=pass; b=XkmIiGMfxWdiW7O5OhAasjoRpjRWh98BROu8SiKaH/z3itTASoIlbXogDtQYsMUIcGdnx6wYSfPz0Ydp5YXSH+0zaH5o6jXyWAjXHywqDgoaTHCAYG4g3dJY29eUILvL0ELVw/rSRYjvig+bWuoaxAq3HL85+vuTYawIbEqPV8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770917468; c=relaxed/simple;
	bh=aFl4xdCrft2FUF1SrrU0QE2t3vBgZH6/bu7kzxI+dAA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=USoNPHi4m92E21VLbW1t28yshvnbmnchZBartCWR0yG2aWCrqsg3ebDWk0yFoaqFMCqMKWNkOpYj/19PT6YrjL4DYAgefaaxtGFrVCV7SxfMYhGDrvWmFdhQQNCoghlGUatanNznIZm4k6V+s6rczvt3TjFodFqOnPU0INlyXX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VCfvveS/; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VCfvveS/"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89505dd3e24so1175656d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 09:31:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770917466; cv=none;
        d=google.com; s=arc-20240605;
        b=hlH/4qjqwhAJDctGaOfnUu9c92nC2kTNzXrC92OQp+3K9hksuyBcj4XsT6x7lRPBji
         4egvYrOwa2lTLqu8kvlLQwe7lq9asnaFKS5xqJyTnar7m4PFq8Q8gD50stSiY6rhgjKE
         daiUzn6wr6MjnpZYTOLU8Dc/EcVAUFomT4F5AEhB7spqVWI5Jv1RAQDGZ0IXnWTkDe7o
         6RTNiMvaX8D54r/ZU4MZs1bk1DztSpFX0aBUiCR57jen0et/9MS+G2lL2KZOknHcJmUw
         myp8EigxNRYhYpWdj9tmXWkcJkab8ra0GErUdMeNsakSR8IhyFV7/SQMEJXg6nIVv6mZ
         E5Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/mAR8VOIfBEh+iailIWno5gtDvS1HAnjpQo/NT7Z+Wk=;
        fh=QFYXq9h47A3uinAupQFVzq6GL8r53k4yEpjY9+4i5IA=;
        b=GUfvkCl3V40YaE4lPDDjqmv+bzw3DYjDakNg86JMHVIbtn2owp9U4pvMkllpMXgd1D
         y5edNNSB3LuGcwtC7kRop/MQ/LS04ZJQJE0TMjhFNLUfqh6AWXBvCOOwAUw66tNRTSLw
         enqsVyynwGc0m3RUvQVTK9XjVPhQJGejNkpOcwlyEdi7S0PRmBeC6QT1plfP/Bz9ZStF
         XfAPWsIKlhekpNl9Ae933+faUYI+5yT35FsMRTG+U32EOxg6+N4IhriTqjZgSvYrDj2Z
         dUpyTQmc0UO6FBUG2xq8SXud8WLJPTxy53EXlOs5Xp8BYglCuLSPU4NK/n/LIXl93kQI
         9B7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770917466; x=1771522266; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/mAR8VOIfBEh+iailIWno5gtDvS1HAnjpQo/NT7Z+Wk=;
        b=VCfvveS/gsEb1iJfHZjnrk8qy2Nt9zo8DGwjqLIEdFuwFDVRo8Gzeb+A3evcBod5Wo
         6mrwJ2mbHaQ5ugGRKCYTfT4wenb9qaOl94vMVDBwqv3obnzukahxbLsbNzQctaEIAIRe
         otuBILd5GOFO8vnYrlXsgSs07S4oBrE30xpSpqVWzBmCQ90+VQPH0Wd4hltdZi3WFZ0N
         DY93KOEcNUNeV5IlNPdI2+4VwF5WPV23oMIHUypwaghKBPeBKXN7rnsV4ebshquefNXS
         wEFAZ2i6mGmcLm8d528dmHqfE1wW78RpbpR/0FR3/6niv2ljpKJ58QI7cnXciZ1S17v2
         r0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770917466; x=1771522266;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/mAR8VOIfBEh+iailIWno5gtDvS1HAnjpQo/NT7Z+Wk=;
        b=KDGMPYQfF/CnfkYBGynYdclj3ygrzxRkt4oCdfCBvqewHcn7K3Qk0TfIHD/X/pVOm8
         npbozS2ROL3sOcneZm4webLpmEirlF7+smH4wEVSeppf2iPDN7t4MFdiQvSY22QGzKBr
         L3qOFB/UN8vumLixeETTwIy3yllXPxTkd6RkcEytM+TRSIGytiDbLi68nPgyBXRE5CRi
         vQv+2SFHwwXa/CrzVnzmyvdNQo98/AGSPgHVtQnR3Eo9oNXefi2UNDJsdBGYqbLdLXg1
         96T2Q8GSmzml9p8kQhCLrXqYagbwTQOq8iOl/KC0skL8YULxDbMESAahgA1aPPZ1Jx8V
         MZ9A==
X-Forwarded-Encrypted: i=1; AJvYcCUzoJzyVmMKNmO3X2A7zRKmGnUxew+qd0DyPi025K4QFQ/zuarnd6VQmTSnWuM6oSorXq2pgnzNtqG1@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1wLHzT711qrCfjYqSavCVi4kkzWYXGUwpKG7qeKFz0+c6vH8D
	ZrrAabB59RSiZlKZv0dSIJye7XVaynSvdA/E6nhi4aU8M7XSZgwsyPkx+IyWFrntCvki1lHuzS2
	3y2tAM3wvRXQblliImyjQzufx88ILCxE51A==
X-Gm-Gg: AZuq6aLByYAL9HuUTnWQ+0eAwXD+ZjHIW1jSzjjuJ8KFtOvoB5ytvC8iyy3NnEXWoec
	yMkPhBHyz/FdnNEDxlZR8bKMHFHHs0e4jGshW8VUsHQHQtcDG66ys4fAFygXerJRCnraQK6Yb5/
	RADA4/ThkPZEtk9R5/sen18D311bkMRLn6a7hrw4UNm5J8Xv1LhPyNhP6hfTtLHUn3RYUKM7g00
	enaey0fli4rotocq74vv0ZdwNxXkR8gVrVdmB5pySl8k40y9RDv7XLoNnXY57/Ch8crLI078WCc
	mkZFmOr5cQgjfHDWLlNTnvsd2L9+YsIk2pQ0GUIZDRpljIjmOvmQ8g0/hfkpMpjUblGLbemyDeB
	WJ3uAoOmuklDqYingHy3ycXpmWursfMpjN4PVY0Pp7nzaWTrNccboA7i/8Re/wsmUQkKRxVF53P
	2TXVFtMt9lJVW2W+fTcfDBa0m+QH0L
X-Received: by 2002:ad4:5aee:0:b0:896:fe42:e8a0 with SMTP id
 6a1803df08f44-89729cfa12dmr42652196d6.63.1770917465858; Thu, 12 Feb 2026
 09:31:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Feb 2026 11:30:54 -0600
X-Gm-Features: AZwV_Qgs4dgK8nUkM5H_TGDejnetFukOvXAckcllPN1xY1BPwmmqdnulEbQs7gE
Message-ID: <CAH2r5mv_qRcti+bqsWBj-JsDHTmuotrn4G0qBb+bnzWh762vkQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] smb: move some definitions from common/smb2pdu.h
 into common/fscc.h
To: ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

This patch needs to be rebased in order to merge.  Let me know if
updated version of it, otherwise looks fine.

-- 
Thanks,

Steve

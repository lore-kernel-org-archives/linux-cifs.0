Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9663D1FDE02
	for <linux-cifs@vger.kernel.org>; Sun, 13 Jul 2025 22:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752447531; cv=none; b=at2Nl4xYJPdQKrKXkTlGs88N/7WI9kgDcM6Cu/vlsnLXTP+50duWAbtrWWNgF8DWG3G+bvvi98qZYqK/C/UfpQjzX7JGYn//2/l2R8f7GqRmfXITsPlRQP+1J1QJF1eRn3nL5opIBhUJRJWG2jCpiMjCmwlkqzP3uylmi0HSs3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752447531; c=relaxed/simple;
	bh=rMDMR2MjkdzP9jy2JA8WsYWiGCHu+UiD1yTwZI0+NPg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=lPqM4u4zPAG0BywJMiqXY50jjVrZkDu/Ahn4oKTwI4eaWch+bukD06oLNO05rcNvq0v6q/Ndlw2hCwenhiLCjEGnJeUHEjgZyesSEEayLyjGCuqv3Dk64u4BdxIeq1PdMHftB2NLdLsJwyFQsguUTQtpGCI9tmbhdPkp1R3U1SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lq2ztnJ+; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lq2ztnJ+"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-701046cfeefso58159006d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 13 Jul 2025 15:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752447528; x=1753052328; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JvLWzpHBGFzQ5EWWs1pWlh/lpVeF9I6Yr6OiXDw0Dks=;
        b=Lq2ztnJ+gBENC6OMtRvfYbSzBXxRwlhJ0ILoNT13yZQg+J2nBHeusdCDA+c2xbq3iY
         xMlHo9qk74Vw3+ASBOBB2oODEUCt3kAC6+W5puuop0hIUn1mY9k8yQqhl5eHFBPB+La+
         9Fnj6R887AgOjbASGfAr60IE+OlMEJCpbgEBc7wuNKnIAwrPo9PdcjUR4ape787p5Lde
         80572w+F3t62igXZXMhj70j0gyXr5H85yBrBY7NWf96rvjcGXK5Oelzt3586U09qJF86
         ZwkyNRb5WQtz2TKuW5xwibFcsVSoARhb0feTQElGu8ehaARg0S2FM16PxV9afUwz6Mhk
         KwMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752447528; x=1753052328;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JvLWzpHBGFzQ5EWWs1pWlh/lpVeF9I6Yr6OiXDw0Dks=;
        b=Ax4YBNXkydgqCuU1CWIQm4eYelmT675sr5Iq4KLXjNLCI5qu128/53m0m/+/C3L4Kt
         tkN692FNTa/p/6X3hPh+OCVz4uhGMQK62NCubwsCLja+ldARqZn/NnLrVirNWff7VR2m
         rMgvpzs8Nbf0lEUE462cNTvmAUa1zPGqs3l7aBdrddKT+E8nPfjpjFgSAaYNt+jeSZsV
         QoWgK4aUIMDMPwWHPifg4yvKlib/cA0BO9nRhEN/xlUcNZG1kFWcf6e1ZsIRWqAwVEYk
         DfMMbvyr9wd438rbptrZ+p01vo+LUfvJkK/aYjVAIF6ppJ5nuXa5+8UZiPQnk7LidgwE
         /+7w==
X-Forwarded-Encrypted: i=1; AJvYcCWSpHXDV91g5Sa1pJtPckmqRVaqQAs5+5EKYoY91hLpNlXj3dVeAYhZOP7o318F2nT/l45jHs+HeJDk@vger.kernel.org
X-Gm-Message-State: AOJu0YyZvDSiLfyc9/m1M4ntpcUf1e4nHbfXoloywHcweGaLXf/RWu6s
	RVDYtWhK1wm/D9dNVSaCu6PeY5/5xlk8cd0qrZP0wiK7trCY+v5GletFXgjiNwFs3xJnmT2cYyB
	Yw6qC8RIjszr7NbWRIQV0UmgTuiR7xoc=
X-Gm-Gg: ASbGncufTgKdt39fCDko9Xcd/7zaOMnvAjdbgMchh1406u3MPSQK5nILekJzJ7e6AQm
	Jrk1G+pfXbmyYWpCcZH/KZOMHgbBRsO9LM1UZ6QOYAwfxlv4hsUsJwZvZJMSvH5zGU60qU9DTtw
	Ty/KVafklNMXeuA93U6Vu2RJ3JEjHijL7tdmo0aqntOyREXdJVVCE9/qBpzSJnwv8Zrv2YqsKoy
	Q7+X46K8qSMiV4bNf1NG5uTdXUDuDHZariIO+XfAw==
X-Google-Smtp-Source: AGHT+IEgzEdGYPN8Dss7qVm5oGqkUZ2L/OVlPwZ599Oa99opzklSNjznYDdXtf4fmpV5VyWjgqLCFYuKXk53vZgFhVk=
X-Received: by 2002:a05:6214:598b:b0:702:d30f:80dc with SMTP id
 6a1803df08f44-704a338aadbmr200041406d6.11.1752447528398; Sun, 13 Jul 2025
 15:58:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 13 Jul 2025 17:58:37 -0500
X-Gm-Features: Ac12FXxXU9V5Km2u8NvpOgDisezgfAsw5O6A8G_ecHdP4Xmx5bK8ctuh7bfaM3Q
Message-ID: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
Subject: Samba support for creating special files (via reparse points)
To: samba-technical <samba-technical@lists.samba.org>
Cc: =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>, 
	=?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I was trying to test out creating special files to Samba (with and
without the SMB3.1.1 POSIX Extensions) and noticed that although Samba
reports special files properly (as reparse points) it does not allow
creating them (it does not set the filesystem capability
FILE_SUPPORTS_REPARSE_POINTS except in a very narrow case for offline
files, so clients won't attempt to send create requests for special
files to Samba).

Is this intentional that Samba server does not allow creating special
files via reparse points?

-- 
Thanks,

Steve

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795095925;
	b=JSTMMD5Xgdosf5wEh3dK2UcxfT0LxskRauS9NncsQrvFFZC5ta7JhqvJF1zAoBLUa/RO
	 quPpnfbX68XQFLPDr/HsRGiVHpWAmQfl5NYIaE84t3SWp3LZ6pp5Qn1igC36k8o5SS/3L
	 kR2qvo1Qcmq4l54H3P0B4z2ysE0jg90OWm6C7dMjiqAsQxdkmEKUU1Jb6ma+KnqSk6cp5
	 e5W9vWZIAnQ7zSe1lWYWM62JO8aIyOxIxBn/VBJZH1kxk0WGCC9Sl7qYmUQdR8xG+29or
	 7+gvGlRG/ECFS2qh2N+TDuffo4ZCWMD1BSjpK2Gpb8vOTcluIUKU5jaFZtERFVTrZYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795095925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GMPPvMPV4djJgOTMQIv2mzxjyhQi92inn0ecu3B3U7k=;
	b=al4W67Fz8opPO1Lz6D/RFNorA7iiuAkn4dG211c+WhcqppUYWHm9fTF4+qRvZCw3tpSV
	 NKDKOzJe5Ai4SJK/vlKEFKkPW6T3pl0KKEciUwmoOqXAKvNAi2gNkQbIuZ/IUhSfdmSZZ
	 +3wwo1Vn2bPQ7ethLlri1uKZtx95qog00hmtr9peToVgRmsiacIpyWzlmJEMUVWV7eDfh
	 CODSIyWjWohrpv8fe5aPoysU7iw3Ohk+0Xm5ajqff3jyEfO0mwt1APcSqE7QJm0/v4lMk
	 sOkjI4SQK+ZLEbsgreXq6iwYhBNgmsSLjhKZBE4BAYs3BcJVgtN1ww+P2E+LrmDynAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=MWoALPSI;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E72B606A32F
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 13:45:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E72B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=MWoALPSI
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso17319075e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 05:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795095923; x=1795700723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GMPPvMPV4djJgOTMQIv2mzxjyhQi92inn0ecu3B3U7k=;
        b=MWoALPSIoDCILUgGtghHEx7Pwo1CKcQYKpOoIHmBDuq/mjiu1FztkCu+DO0Bu8N9kA
         G8dSl6JORdqqwdfQ5RyCr4/Z223xo+KpuHpOP2ke/wl94KGPi8FyMIJS+MwQyc5/d4vW
         43cGu0HrfuPeHxP9f0SF2orsCtIaHX3eNA0Nh12UTNr4UYduIE5tp6NSzq6mCv1I7n+X
         DzfznHXn8TaFacMeCA3xvNmVeuqCxdk50daTlAEPG+4eF3K55+t3kuSbN06iwV75qY1B
         HyN+61KAm+Kfdxzordk+Y1ut+jsiYdmZv7QH4QMw8V3qnKcdjDEUGzvm/QXo5ZiYfc3g
         5veQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795095923; x=1795700723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GMPPvMPV4djJgOTMQIv2mzxjyhQi92inn0ecu3B3U7k=;
        b=Yi0dqT+Pnx88qoRNt5dV3B7ocpasVhQWMZyqAIssvOXWo/UttU2xNRMYHk5nNjHKWA
         l/G0s6/CD7kXFBTFmHW8UW8dWDpSanR8dcN6pTllS0dLgxPlh0hQgO7V2Lp3Mk99Nkxx
         TrUmNAecYFO8kHOSvbUduHnYMvE9IEFLS+yELbZGIytJ4oYl4znTLyPbinf4U8BoLVzj
         q4vp+0gAUTC3eonIc0tNy3sJLt9zhW+/mubzchk8g39PFegAPeifgWqEUfP8ZHNNaBKJ
         io2Pg8pRMuGnuBAj+Y+3R8lvGuMODpxSgYqOgcv4hAgLx3D9SKMK8AnDf88LqtjkO6Xc
         ubqQ==
X-Forwarded-Encrypted: i=1; AL+hErHlqcL2lR3gC7Dltu1cKoLyFUnSPgW8d9IeLA0B71oWDgJaEpEu/IP/st/Uu0XkvQ/uXUeqUUjtB1nH@vger.kernel.org
X-Gm-Message-State: APuU4Z9T7LR0v4Oeo4vG06F6YM+q8moUqdCO7Yf2gpF7nU1yUbc8PUms
	2AvdaSks0Q08wu8kGRxSCn2sgdSbrXSGKg8RkcNEp7pEa0dVvhampvIvRCXZV9arYTVr7zKq8eL
	spPiyJ/Py
X-Gm-Gg: AYBFou1DCd3h9pFyp1B+mZiSB58DbQjQhnEyyGoOl8LBfjP2/gy87A5YZBaYv9mGTCU
	CIDAGGxkDS7qEJGCeGkwsWu61baG2smGBg3A0LS2vhIHlFD042UqQ786rqMkOHQxgbzRib1zjAI
	eQXwdNU4HcXSP9lqMgKBQzYa+5b1EuFTqy/extE2HyXi+Ckx5njBVrdztKVP9yM/Vhbm021LAio
	Vz6EDjefIEYvthXcgWAett+tmOuOd6czmujGmUyU83pNnaDISzpy08ApQ+4aGfC6X8sMcSFSksM
	Mgz3RLKK+SQSYlTPJBquPqZhtWF0AS4NPZLKfiPdEL2Aivt0SZuDSg2EW9L8iFun3d+vYYUX2Lv
	bfQinfU0rl86dO1z0fo5WlrOXYd7hIARA5PHts7lHztSyv+MRa+pmDjFDbN49EUf+D+D/L3S+I2
	M3sU06ciRGObru2bwQtWoG8kN47PFjAGORi5CsAIl51kUiTFJQXwpZ54B3J/fHf8IHw5sGSfhNy
	JjhvKJZ4buJ/j6X7uhbFVF9BlyRKl6XCESS0nxyK7KtDV9/jO1mKxR49RyUtWEVV50ND+Gs/x/t
	J/TEiKCkGLvMAewhkqTd4+CNx0ycuOdf8ICjBnc0J0eROtImYhZ8+0kvBx2y8fasfTVS
X-Received: by 2002:a05:600c:b99:b0:4ba:6d8:dfad with SMTP id 5b1f17b1804b1-4bb7da1aa22mr116301365e9.14.1795095922709;
        Thu, 19 Nov 2026 05:45:22 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb84e06c73sm65941015e9.2.2026.11.19.05.45.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 05:45:22 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
X-Google-Original-From: RootSys GmbH Research <research@rootsys.at>
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 0/4] ksmbd: enforce mandatory signing and encryption on requests
Date: Thu, 19 Nov 2026 14:44:56 +0100
Message-ID: <20261119134511.17967-1-research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <D3CC3C6A-0F15-4533-9687-F776DD1BED94@gmail.com>
References: <20261119103805.29514-1-research@rootsys.at> <D3CC3C6A-0F15-4533-9687-F776DD1BED94@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Michail,

thanks a lot for testing this and for the detailed review.

> - Signed-off-by: submitting-patches.rst asks for "a known identity
>   (sorry, no anonymous contributions)", and I'm not sure a team name
>   counts, so it may be worth checking. Separately, From: is
>   team@rootsys.at but Signed-off-by is research@rootsys.at, which
>   checkpatch warns about.

RootSys GmbH Research is the security research team of RootSys GmbH
in Innsbruck, Austria, and research@rootsys.at is the team's address.
If that does not work for the tree, please let us know.

The From: mismatch is our mail setup: research@rootsys.at is our alias
for research, pointing to the team@rootsys.at mailbox on Google
Workspace, and Gmail rewrote the header when the series went out
through that mailbox. Both addresses reach the same people. v2 will
carry an in-body From: so the author matches the Signed-off-by.

> - Patch 1 depends on sess->sign_required, which no stable tree has yet,
>   so the Cc: stable tags need a dependency note; patch 4 does not depend
>   on anything and could go first.

Agreed, v2 moves the capability patch to the front and adds the
dependency note to the stable tag of the signing patch.

> - Patch 3: MS-SMB2 3.3.5.5 fails the SESSION_SETUP itself with
>   STATUS_ACCESS_DENIED when encryption is required and the dialect is
>   2.x, or 3.x without SMB2_GLOBAL_CAP_ENCRYPTION, so a relayed login
>   would be stopped before authentication completes. On SMB 3.0 and
>   3.0.2 the tree connect check never triggers under mandatory
>   encryption, since init_smb3_0_server() and init_smb3_02_server() set
>   the capability unconditionally; patch 2 covers those instead.

Good point, failing the SESSION_SETUP is better than catching it at tree
connect. v2 does the check there as 3.3.5.5 describes and says in the
changelog that 3.0/3.0.2 are covered by the plaintext request check.

> - Patch 4: in the default "auto" mode the leaked capability gives a
>   later 3.0 client that offered no encryption sess->enc and clears
>   sess->sign, which is the hole patch 1 closes; that may be worth
>   saying in the commit message.

Will add that.

> - A signed but plaintext SESSION_SETUP reauthentication is still
>   accepted on a session that was told to encrypt. Should it be refused?
>   MS-SMB2 3.3.5.2.9 fails an unencrypted request on such a session, but
>   I could not find text saying whether that applies to SESSION_SETUP.
>   Only the session's owner can sign it, so it is minor either way.

We didn't find anything explicit either. Since it has to be signed by
the session owner, we'd leave it as it is in this series, unless Namjae
prefers to have it refused as well.

v2 follows in a day or two, once it has been through the same tests
again.

Thanks,
RootSys GmbH Research

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092702;
	b=sTasOM5bJdkW/ez0dCzu0sYPLXucU1ohTIUYIrrckwNVKTwDP15hS3FGgcOgiGqo+Esh
	 HJo3VuyAlCZjHp+V1s0/wUskVW+5KUStNFWw6gtMa4EL2v64eUDSjvnNhzHm3RkChS95e
	 lr8kag4r+yBvmo80gt9EcLCWeaLluSNkIdZeJMk0+g045mj/oScYaTvkOGXLj2PFu4Vo5
	 ECSWN2RbhTLopxqZBT0aWmnTAHHMmLldngEpf69LgGZd9UQBK5k0M77oSEGSLHE2Kx57o
	 /oZsAiixFfXwbIc3l+v8f2RGZTR2azZauLza8z86b40KKb1jg+X/o6Y85tbn0TUgFQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092702;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Content-Type:Mime-Version:Subject:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=f9CWKRySaY+gGPTkMts1lgr3xOnoMTU8fBqxubqcpi8=;
	b=whyxhelI1+GBMPrZEGsnUAIT9E5xkE3x3n6UyX7e/XrHaxTwxzsos6yuNBfAZB4Eqj2u
	 aMkbp7OiNJlEGbLI5Ml2yoVZLi8MeGM4vVCSB0kByP6m0xpJ59jY2dJz0KRI04pLeMKSr
	 t4bNRYXJX5uQk/wVgV4hzUUpWmG2WuDlQgGu1lT5GlxgzpsnCVRGQoWACSLlqLW5UN3EI
	 jrnauyvkMjSeWsv6T7Rkzx1MHbBLW853qY3wijrWsJkd5w7JosGKl3Ny59OSLd/QayGvz
	 k9WAl7bOfMJ8dlGoqpbQS3dKlUvSMV1SrVQ89PXzE6RA64JoEoIVJTw1DWkmHQvnERA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wzLPeDSy;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC72606A320
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 12:51:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CC72606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wzLPeDSy
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4395d31228so342428766b.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 04:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795092701; x=1795697501; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=f9CWKRySaY+gGPTkMts1lgr3xOnoMTU8fBqxubqcpi8=;
        b=wzLPeDSy6hTbygJ/Q/2SrRkTCMNidhSd0+2WweE4zBAU+rlsQWYC1OvMCLf59UIO+G
         iXWb5FjW8kfcazHDWbrzZctgnxRZYP4CD7hDicL2JqTdNmRnHWcddeXXKQIWdCfap4io
         0Rqq885co5Hq7sPvZCXBXHqXVjqOhY+OEnI2xASidBjRMyY8Ya/Ija6Vru6nNrQqEjTE
         0W0R7dk5dZwD66H+TcFh8MTiZ3BGaL7V2aC6WOyADmSgXYJNi1tZS800XqxboERCDSmt
         0JKEfQ77DybF5qtnb91v1i5vGWEfI5RBxKh6zeSZ09HPnvSPjNx6GwNz1o5Q27CxfPWC
         etuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795092701; x=1795697501;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f9CWKRySaY+gGPTkMts1lgr3xOnoMTU8fBqxubqcpi8=;
        b=xFH6LsMGGV47GW15VYY/ucUOzunMb2TC69EM9v87AuFTNI8CDQwvDyL1+tTie68ofu
         jOg8+TCW8DgFuCsBJndL/aj0sEC7kN42oqbekM1yOZrsnOa6cX5nD4h58mV2+vICevzM
         nycNW/j+VOYfCFgwozBwg5sKJG/NlM/Qdc+iMqW1V5O/7HS0ecVLjEwbbx/e2FT9pZ9O
         /DWzIF9GPhdC07T1ik53sW71+giD29eIiAbw2zhkU3jnZ1BoPbI4//LTEA3n5QckA5y/
         QvvZAIV33VjutoE6TjNtDWguO1bHRvyi12oN+4jXpcJPl+8roKvdjX6nAWevzqxK/uel
         k0Xw==
X-Forwarded-Encrypted: i=1; AL+hErE566RDAicPLDlvFoeWtPuJGj3wOogo4wAkycv3bvJU48Sp4sgFq9Tnl106IlMz/NxB9pH2nDl6+M2z@vger.kernel.org
X-Gm-Message-State: APuU4Z9jHwGBHPjSFqQzpOZpLBQWr5mpdbKMnPO0VqPAPxNSoWaUrPQ7
	kG3ckmOm67BbF0lnid0rPbbCoD8aFYzg4yGHCBfYW2RNgqc8sW9t/172
X-Gm-Gg: AYBFou1d+YUAtB/IQZnRoCE4O9Fc+SElJq8B/X71iHF1PtGGGwuOg4uY9XC0K1sSph5
	vkNruoLlcTeIo5rZpHot1S6C5lXzmYUjBi1PphIK9wwivb99j0HT7PSrrrf24c/b27yahp/Ux18
	EW0Bo2HibG6rZ0CGszsapC0KaIQME8+nOXSRlrho3aJ8+SYeoch/ZBdiqnf+b7JrRazeY/NPlBr
	WzFA3P04b9giqmBL7sDiRuVy1KEiFX4NxQetRmZ5TJ2NIKmE0pBJo8mnajscSNIsdSuD0Zp6LOs
	mZ6tHZqz5xTgi1KI2za9wLmwQdWCEPNlHpJgBHGFKozAPM4voXCW59Cj9oQxk3rxUwe3tJFgipu
	jCPYNEOQUpB3JXBfwkRfPEKuTHifXR+jjYBa79gxx/cXSEi32Q+7BqZtdSzFNw+A3NSRrdGYK42
	8Ps54FoP2GFQCPLGV48e8Ju7GKo3hA9LFp4rSjZzbO0RUWvz2C9JH7PYSWnUj6G/Lt0R7h+lSR8
	p/d5arupe8VjHK4dprNgX4ShfszBbJjj8AVySxsTzODNR8o6XQpO9ilOLqIkg0/Cwqn9gJPj8gB
	9+tjKQBv+grpOoZbkyc1h6MBKiFTCr59Zd62xLDitNSJOBno7g5dRWWfKIyubwUVSWLwtiF6t9X
	UkLEN7cCffb26FTo72xfEOQk4e2V3rihQtg==
X-Received: by 2002:a17:907:eb03:b0:c51:22b1:e797 with SMTP id a640c23a62f3a-c5122b1f2cbmr313585366b.10.1795092700591;
        Thu, 19 Nov 2026 04:51:40 -0800 (PST)
Received: from smtpclient.apple (wlan-197239.nbw.tue.nl. [131.155.197.239])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c51233c2fb4sm103765866b.27.2026.11.19.04.51.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2026 04:51:40 -0800 (PST)
From: mixalhs <mike.michalo@gmail.com>
X-Google-Original-From: mixalhs <Mike.michalo@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 0/4] ksmbd: enforce mandatory signing and encryption on
 requests
In-Reply-To: <20261119103805.29514-1-research@rootsys.at>
Date: Thu, 19 Nov 2026 13:51:29 +0100
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <stfrench@microsoft.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Tom Talpey <tom@talpey.com>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D3CC3C6A-0F15-4533-9687-F776DD1BED94@gmail.com>
References: <20261119103805.29514-1-research@rootsys.at>
To: RootSys GmbH Research <team@rootsys.at>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hi,

I tested the series on top of ksmbd-for-next with the session setup
signing series: with "server signing = mandatory" an unsigned plaintext
request on a session that offered a cipher is now refused, with "smb3
encryption = mandatory" a plaintext request on a session told to
encrypt is refused, and a client that offers no cipher can no longer
tree connect. My binding, expired-session, compound, encryption, guest
and anonymous tests give the same results as without the series, the
Linux cifs client works, and there were no KASAN reports.

A few comments:

- Signed-off-by: submitting-patches.rst asks for "a known identity
  (sorry, no anonymous contributions)", and I'm not sure a team name
  counts, so it may be worth checking. Separately, From: is
  team@rootsys.at but Signed-off-by is research@rootsys.at, which
  checkpatch warns about.

- Patch 1 depends on sess->sign_required, which no stable tree has yet,
  so the Cc: stable tags need a dependency note; patch 4 does not depend
  on anything and could go first.

- Patch 3: MS-SMB2 3.3.5.5 fails the SESSION_SETUP itself with
  STATUS_ACCESS_DENIED when encryption is required and the dialect is
  2.x, or 3.x without SMB2_GLOBAL_CAP_ENCRYPTION, so a relayed login
  would be stopped before authentication completes. On SMB 3.0 and
  3.0.2 the tree connect check never triggers under mandatory
  encryption, since init_smb3_0_server() and init_smb3_02_server() set
  the capability unconditionally; patch 2 covers those instead.

- Patch 4: in the default "auto" mode the leaked capability gives a
  later 3.0 client that offered no encryption sess->enc and clears
  sess->sign, which is the hole patch 1 closes; that may be worth
  saying in the commit message.

- A signed but plaintext SESSION_SETUP reauthentication is still
  accepted on a session that was told to encrypt. Should it be refused?
  MS-SMB2 3.3.5.2.9 fails an unencrypted request on such a session, but
  I could not find text saying whether that applies to SESSION_SETUP.
  Only the session's owner can sign it, so it is minor either way.

Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

Thanks,
Michail


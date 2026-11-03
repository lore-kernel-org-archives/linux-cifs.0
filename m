Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728675;
	b=p//5TT53xcWu9xGz+aN4TJuxBnobruKi2sgX6GZ4QgnBeQIQ/jdE+DYlN3UOfXR4sEmz
	 QndXEmB9AVUZodT3ykxsx4AJKrek7lyzKz2BVDv3kxfbPaP1GzbVDCDpwF7tHsEFQxkJl
	 qasUz6F7/2E2hNL1s3bE5bqRlXEGPxEOEmffaMl+eoW3m0bwT4JrkpJpNPFSIcUisHunB
	 MLlRErKbMk1PqPv1KlLobMUyY+GqAzmRhkepwXGPtwrQLXgh0P1QtFfB9G+Q5orP114dA
	 nE+QaFM33pZg0niE8a/Rzyh2KnenKs405lJj4MtbsllDjNcw+i6OUhYbUJQE3UPO48A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728675;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Content-Type:Mime-Version:Subject:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=UfwhB7d+jFnDzhdQ9SOzdeKuF6qBwoZCWzda5GUg2nE=;
	b=cWuvOQvfIZxbeZRFli/ITfStHXSyw6TWCnb4vXOa2BmpRUk1EkSCFrH3euWZr8nmYaCy
	 Tr6HTbbC5fb7Kv5m0L5xGbuc8NZohLQ629G78Si4UaOWx+ZeoATLsY0st/Bz0Jp6c/JJO
	 51xhQSue2qi6dqDCDu0kT+hPPePgEZsQ3qqMSfxRmVPLmogBjIj2viOTAfTyP2SkgALMb
	 jT5dW39PGZwfhy6bp1wG11d656uHtLUvDY7MTM+KIZLyoBiCf7xA35+TVDMOWpX9GcFue
	 pS3cbM1aVzaV+ICVgJgXqNcOrfjJE3EBwJBvo/HpL40z2nHA4tVO3eMWDQuRSpP7LzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cjtWqbY6;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55329606A32C
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 17:57:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55329606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cjtWqbY6
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso6121800a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 09:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793728674; x=1794333474; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UfwhB7d+jFnDzhdQ9SOzdeKuF6qBwoZCWzda5GUg2nE=;
        b=cjtWqbY65Y+iH0vqgkNLVug1GFzj3TX0gT7jH0epqHI9kDWRFlLHgr6kPgPQPmZru7
         QJQbLzcYLwYhQmz9a7Hg+QQtQXq3fdoOvmdePefUk5PxZs3Dg0GuzvKmpFWUTgSsde9m
         pbEjN+yejVAQz9/tRmJH67kU7Bx1Gd91QHYqTXCOge5KW/cBIEpSEhcJNWX7ndLSMTHF
         7/Nk+4SwtYAy29HKcAii25DzO7aduSeFGfsy+2XxUh6JdKwSSbqLqyzm4amhR6IQ3pze
         7Jj9uGJ7KM2m9sd5irxZvhNh7RgoLUzjjlCvyPRxJOhgYIBRLcVb7wCpxuulFlhq8Tug
         cwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793728674; x=1794333474;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UfwhB7d+jFnDzhdQ9SOzdeKuF6qBwoZCWzda5GUg2nE=;
        b=NBxdpsQyari8wNZa4OLwbrJsl/nakRZKZDOoEWA52zmVUkWh9SVJ9HrTkExPL44gjb
         eq6CNyP/dH7FTX+MrhYEedNekdIZzJ3B2hRh0GtXp5EnK/muHJron+2DlTDSw5DLzOwZ
         izSb//RKFlllEda1rfZwdjYSNKdmGdBjHQeFvVGoRKLC9Fu43GAvQwX3JDbfrmGbgWs2
         4qXvMDLXuleCvOSajjXnudBBGMyBTvp1VK2eV41MvDU6RrPwSqLr117qN+ibneomBk/9
         rFVDL1fvd+zFyhcOWmLBAUCN7wR0NiGeZ/Gqdl7u09W1TJXrFMY95J0Eb8bVdgwhVoK+
         HTxQ==
X-Forwarded-Encrypted: i=1; AKwUvByvhcLiH3a23dxhE2+S1KP5DMohYPi6o1MukRkyF7Syge7t055vIe5RhVfKKf2AQK29Gz+tpyTQH1yo@vger.kernel.org
X-Gm-Message-State: APuU4Z88x/+wFh9jRepNukYBym4TnSz0tdRY51FamIKH9vHNSDImACE1
	EORLHgjUEG6NOAYUYycoIajQyrpU3J29VaCkyluH/aq2ROikmw2mmlu3
X-Gm-Gg: AYBFou1AjTF5Q7uiLMBcnxz3Hz7JjjSsWuRcZJdlM+RpwN7e9bCeHryijOrJVmqgaHn
	KSUh8Ic6XFa+cQkPW50+FWMHyN7i2SIv0Tf0roKm/mi2GJvZi3fA0UAvfI9hkppmryu2QUgAZzQ
	GnCN6XfGb09ZzXovQfckXRT/uajhgQOYJGCtyOPx0BjXZDpIMSNYmCj9UvPLGtgywUn32rZGIN/
	vbs8KY3uVs7rnSP+nPrWdSsV6fihPwUWbfgsrF+UPfg1KNfoMtnXQa3nexQzHmpSpDbpGK3v8FG
	z01/GrLDOdKtnRsSUJjV8f4ri0WdA1wM0kFKMlA52AgOzzLXTWLtddjmCnUTLsCIGSqK99c5tbg
	NuRoT6Uzn4KHk/BhBLjpCoH7mlIWhGAz3xxsRgB0m3usO78oh85yVkf4MxhcdWoW+GQFVy1M8We
	ZfqcUJE7fTMSdmkLCu8imN/z1Lut3/19ne+kIft1KWE28m19i9Gvj7lpvGn+EzQUBGAI/CRKqlZ
	2az/X7Z6sYPlG2LxDmlfaqRBqHCwzhZ7226K3qnAx3JY2B3/5IanLeb4I25mjW6eVvHDltWJvsT
	CNQPtbPEJvkVQnETQ+vapp0Sp6yjqJv3d1XHB9wY+yZQt17d1kQm+OflwOUS94g0/a4oAoIEsst
	DlKFP4AfglTpbBAucKSLAtUya+XmqXWI0OGziIU70rrLxhOyi
X-Received: by 2002:aa7:d888:0:b0:6b4:201f:17e3 with SMTP id 4fb4d7f45d1cf-6b4d46766ccmr6791930a12.16.1793728673607;
        Tue, 03 Nov 2026 09:57:53 -0800 (PST)
Received: from smtpclient.apple (ip-80-113-116-3.ip.prioritytelecom.net. [80.113.116.3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4ec9eeb26sm4301629a12.9.2026.11.03.09.57.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 09:57:52 -0800 (PST)
From: mixalhs <mike.michalo@gmail.com>
X-Google-Original-From: mixalhs <Mike.michalo@gmail.com>
Content-Type: text/plain;
	charset=utf-8
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] ksmbd: add AES-GMAC signing support
In-Reply-To: <20261103171742.18816-1-icb@fastmail.org>
Date: Tue, 3 Nov 2026 18:57:41 +0100
Cc: linkinjeon@kernel.org,
 senozhatsky@chromium.org,
 tom@talpey.com,
 chenxiaosong@chenxiaosong.com,
 ematsumiya@suse.de,
 linux-cifs@vger.kernel.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A37137ED-872A-4969-A1BD-C23E9B523EDD@gmail.com>
References: <20261103111453.84804-1-mike.michalo@gmail.com>
 <20261103111453.84804-3-mike.michalo@gmail.com>
 <20261103171742.18816-1-icb@fastmail.org>
To: Ian Bridges <icb@fastmail.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hi Ian,
Thank you for the careful analysis and the reproducer.=20

You=E2=80=99re right: in the multichannel branch of smb2_sess_setup() =
the binding=20
request is never verified with Session.SigningKey, and with AES-GMAC t
hat turns the existing signing oracle into nonce reuse.
Namjae, please don=E2=80=99t apply this version. I was unaware of this.
I=E2=80=99ll send a v2 that first verifies binding requests with the =
session signing=20
key before they are processed or any response is signed with it, and=20
check whether legitimate binding can also reuse a nonce under=20
the session key.
Thanks,

Michalis


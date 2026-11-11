Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394269;
	b=zWXqyi1IXdq3Oa4kRfQL7N9Qt1TSKwImrgS7VsryaErwAMMBEAyUbmoWuNg8IpxYGdP+
	 M4G+6kuIjADwtfbMVP4QpNjsrYjP/Kb0JH9ETW7XorGHKlXprgp3OpTmu4ifJ9RTbu0Gu
	 Fa8oo3jbbJ9lC1sV9BUeBotd/A2+ERdlsbBMEpVIAnp90TQjxwTwu8vmGnbsBCdof+pvZ
	 KI6E57icJ6wT433eoLJwsJjsF1kHpgsSpxfxrBWMZW/JJVr4Z2nDSASbNbpX7vLn0hEVn
	 qPXtiPQS2/u3ujI/M8rY7uzGe22wVCZWZt0Pcxjrn4oQ0s/vFByS5lFZxhAFkuqBQ3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394269;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=MX3Hkp1wUfwxWDno7iqBipE9mHVHuE55LijrPmevq/I=;
	b=0DdAF1Ma5qKvDguGsgnRFcmW0FSxSNwBpBZbJ8kSMFKrDalPGIx42H6CaHmIV/aQgulf
	 GKL79bmejOnZr3ARftaWj4kNpcn9c6uffTPZ45rWjsyd2PwliKu3X3irT2/MpWQk1Dzwv
	 2x9/AMxzz28S3b2rOmrnnb473r2RPP5Rc7xQJs13hvjJvw1ZmsfbQiYZ5L0qf8NIimMoq
	 mb7QBO7/sizNjZFYGJX4KAzpBGRkrzlb+LNZEKyJxskhB97bbJTy3iQ3kSkgsuQPkcKR0
	 WQYmrPUgAch2LSgi2vFqcgBcw2yvaIje+0NsyIHfbkAFpWp6ozO/X7xFvnB2bpPz9PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gEHL7/3j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E791606A31C
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 10:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gEHL7/3j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1B21F00A08
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 10:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794394268;
	bh=MX3Hkp1wUfwxWDno7iqBipE9mHVHuE55LijrPmevq/I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gEHL7/3jsJHrIr/kuiOi8nM4klaiM1gPqBvszlPoD9yW/7ukyQ9ofkhbjAi9pE1Vo
	 iTEKB1je1ZdJuaImyUz6Nq6MWPQu7/NE5JsWpooJgKsB+X8I1Dh4Q/CU1Mu60COBf1
	 GiVMqLhr+F0ClX7/jtqvYaf/SzTjRQK47SFd5tCT4CBwTJUl53OttrpgbWVSqVpw1n
	 58IJByKQjlgH8MkP6CfzLzXip/uB3z0fb/d8kcuQ0/+DmREt/gF8ycrT+raip1dEkQ
	 LmBL1zoohc4DLkKD4eU/NDczRcqCWSI9qAaCKYCKGTRI7iCEUtjtvlD4iKraP8l5vu
	 giFqyAgiNFXgw==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b315dd057bso23152377b3.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 02:51:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF1ZnkPL7KxqpbkwnNpaVg3TQd5H47XbPRLpHp5d7GxweP/xnsjXKEBO2BAHUXNsIrZprIfHy12F8Te@vger.kernel.org
X-Gm-Message-State: APuU4Z8vOCdL+Oo69952dYNB9BJhr4KcNaB6BiLJwdc+ANtV2291HGXW
	/QeL+MWwNqowiIvTJXjYfHOokQgSUc3B6rB8rxeHn4DPzUEBOi+zdtPB4MASO7bbe0zXC7Zw7nq
	Zfj99gs4SX7jL2SuAyObI8tV+kZYyq+0=
X-Received: by 2002:a05:690e:128b:b0:67c:2350:fa6 with SMTP id
 956f58d0204a3-67c67efa815mr1683833d50.47.1794394268020; Wed, 11 Nov 2026
 02:51:08 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110165834.28162-1-mike.michalo@gmail.com> <C5746055-5C40-4335-9A30-5522244EBA55@gmail.com>
In-Reply-To: <C5746055-5C40-4335-9A30-5522244EBA55@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 11 Nov 2026 19:50:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_YaR4yb41mcDPGFeJ1WrNgg_qo1FvRmxdKhFWkKruP7A@mail.gmail.com>
X-Gm-Features: AclHuK_s15BoL_VEpW6nuKVks3HpOM-HKSslMABijrChTqLmnhySRjzGxEr_HWw
Message-ID: <CAKYAXd_YaR4yb41mcDPGFeJ1WrNgg_qo1FvRmxdKhFWkKruP7A@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] ksmbd: verify session setup requests before
 signing with their key
To: mixalhs <mike.michalo@gmail.com>
Cc: stfrench@microsoft.com, icb@fastmail.org, senozhatsky@chromium.org, 
	tom@talpey.com, chenxiaosong@chenxiaosong.com, ematsumiya@suse.de, 
	lsahlber@redhat.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 3:17=E2=80=AFAM mixalhs <mike.michalo@gmail.com> wr=
ote:
>
> Sashiko=E2=80=99s review has already pointed out some real bugs that will=
 require a V5
>
> I will fix them and send it, will spend extra time verifying everything b=
ut if there
> Is any feedback for this version I would appreciate it.
Okay:) Thanks!

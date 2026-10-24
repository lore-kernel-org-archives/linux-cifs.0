Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792858496;
	b=gCGucUCZH4i1M7Ug32iONBJxfjFMHffAYd/VR/+bhmhreL03iRLoeqFAQ1vcxiVljo8m
	 kI43HeKdhBL3svvvYrX/RLmPSvLuC9ExJcSUu9z5goUSqEiwyH70/i/NBFeGjuYMrCK0F
	 1FHICw3DoxRFfnxfvjQ4/Bp/sLmgCBQbbcDEtSyqvBEAlZOirBo2bFAu1yo1CO7U3tvBb
	 nR3ELzDGFGFea/S54IyBxjjTJyQuP0WMOzOg+qkHMs3/on7/0mOkabutqpAst9k3wsCqd
	 2bz7dSCTrZzX3yzXIBQ1hJA0X4P5/gmzg1Hf/IZn+uu8HljrgWK+FTFypITc67rki8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792858496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Content-Type:Mime-Version:Subject:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=FZEks44/Enad38G510H2E4A6Z3K+IDPntFZmi+/QQ2A=;
	b=l2T2je/L8t7HkfgHEzV2rBkqMZIs+iTj8NJMqW8BKLTT9JVVPFEj3ly9UTDUOaWXpJmk
	 dd7bCsfYLt1kopmJiwmyJgfb9RyyE1ce61d9KSipt9ZtkYwk/ojn+0blZf92LU4fRQkpq
	 kCCX9xzK/rjNqok2VpuGO2bRmDUl2qlYgnbeTN0wGV0N6Gi3nUZRL2NJDGAx2Yav2+k7h
	 +wcieDQgggE6RRUsNBcPBXGraE0xxBYtKZfXJ42Lk8zO+dJzb8s8mX7GMP+PxTADxXIJy
	 zbDg/l8n3iGT4jt0N3UBTBcFyz+xsps1oDMbIxUa48U04uoSQA2CIGD4vFNoXx0yymA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VLOUfyGW;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E95606A31B
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 16:14:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22E95606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VLOUfyGW
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c45551fa84eso264875966b.3
        for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 09:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792858494; x=1793463294; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FZEks44/Enad38G510H2E4A6Z3K+IDPntFZmi+/QQ2A=;
        b=VLOUfyGWFjQWf63LxZAj2ndIuj+Q10moYTYo5zYZN3fGsDT2Dr7EnVRtu5HMseSyEH
         BgQx/dRvMYbYzmcIP7F83CJzUeH+qn84CtHO4tQr6lP1Jpwz5opUPyoV0YEg8F7KOde9
         ZFQtgOwz8+goTPsUuTAm/egWZIOZ6Nn40XxvI0SPRGEaJfsZg2pYFwd+igDUA/Q2W4Rt
         m6EcQRmCJ4I+VBX2fzevMa3mpmI7KGGRKx1IGMlaqeMk+N/U5fHBXy4Hab+mYfORj0+B
         kSmPe1QLfLZ8MB4gFh6JoNDa00QdzAO3R4tTJszkYZGO5QM7o42L9GU2Ygv7Z/aTRkJG
         pK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792858494; x=1793463294;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FZEks44/Enad38G510H2E4A6Z3K+IDPntFZmi+/QQ2A=;
        b=MB8fB/7F76ne0iIplX0rYNZimkWGJLQ9fht36OdZqKB/1i+QxefEk5/M0NnfQfO1CH
         TLutExxla0h86DevB5l2FRx5gCUeC1M5IG6hhIxFNIu0Oq9Grxwn34npJ0/SXttbhLPx
         rtxIsqhT3cd5EPfsksIxmsrR9GnfXiSQ4vTHuIHtcDTXCHjLvI7jMVJM4DayfGnP/VFk
         z6pWnUSuDl48ECMbRLcVpTcJmlggpmPaLmljc645hU+9mJkXKlo0rb19OBxF+kXIwp0k
         2iW7SxpH0o9GacEccMS9Cy4mSMB86mukY7JaMXUUsr25Yta6V8msZF/gPAu+gwoy6SVi
         omFQ==
X-Forwarded-Encrypted: i=1; AKwUvBx7Z10VQFea7Mn1v66pAqrACmgkdnw5T/tEnV5E7zb3O38gxWWOuInqMzBfcn1Vu3c4abCF21fWI+5u@vger.kernel.org
X-Gm-Message-State: AFq9FYKJFc7SUVEwGp3JMfJK0MYhK8aM7TC3AAIZxDYr2oWwak3w/ct+
	r1wi/6TCbs83Vz7zECbJfi+opRkKx/0sh4Hhh/eyjJDFE+vMJmIZrn9C
X-Gm-Gg: AYBFou0SyfHNC7upS2nWRK/7G2HB6fTxD/t8LMhI6jw+aWPKF7nfBPjxCdtFSdaPSof
	C3yEz49ZtwWt7HCAQDynP/7lc5Ulb1xFJZIpzJfW0RGCg84i/iEo7ek0KcLA5ZZsZa90IQZSCnY
	/biv1JmCvoDVz6sXF4s4FJL19AGv75UgsdZege/mVMqsDJDegMeD34QEfcP4W6kWNI1E4ZD3g2M
	Spdsg2lV1rIsSlDuUD+rsI7NFt43xDA/Aj+w+cUAv9grNXIA0w1pUdpBFfkkfuGVmTugUQK1sns
	I8jGZ50ZLTULNkGHQYhPHin4deDC8jqyS2MD7xAQ0sk1iAKh3UinKFxXfVrP/zv3P3mmXA2+Ptr
	b11pNXjp9xdbMHUenhyXeM/UWy6CIqgsD6HtkGVMJ8D+ks3v71hQfIc4/GH/o7iN2qcO2qI9C1a
	k9nLJuA/wvBptU9tCFGaBCYqDuhvbxMjILsjImfQhPs38kQvAECMoliIOzMpT/eHTnJXlsRIkMk
	JYZ8hkm/97tUSqCLnEdtjvVHda+/aB8qkdUl9O7AOLPz6oe/IVPmJPDlNNsOk3oa4XmOgInLfPB
	+YRAoFXcJUeV8DmtuJrcqAoIo896ZHeJs++LvIUquNHaVDurigjEzqY6HfisHrtVpGX5a03N+hF
	WjIbg
X-Received: by 2002:a17:907:1c84:b0:c41:8e21:4d58 with SMTP id a640c23a62f3a-c46bda5675cmr264157566b.5.1792858494291;
        Sat, 24 Oct 2026 09:14:54 -0700 (PDT)
Received: from smtpclient.apple (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd77e1e9sm104445666b.67.2026.10.24.09.14.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Oct 2026 09:14:53 -0700 (PDT)
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
Subject: Re: ksmbd: AES-GMAC signing support?
In-Reply-To: <D0F05F9A-5097-4A2D-9235-AE395961F456@gmail.com>
Date: Sat, 24 Oct 2026 18:14:43 +0200
Cc: Tom Talpey <tom@talpey.com>,
 Enzo Matsumiya <ematsumiya@suse.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <17D8C477-341E-4D81-B585-56629E155153@gmail.com>
References: <20261023174821.17552-1-mike.michalo@gmail.com>
 <atugaviJxR8nzHQO@suse.de> <47ec7610-9013-4c4b-ae37-f6d88556e59a@talpey.com>
 <F6CE78FA-AA06-4F00-BAE0-80B0819CE6DE@gmail.com>
 <CAKYAXd_zM0K9oAjEMzYinBeZEF=0=ozsd3+LRY6gy_O95btzRw@mail.gmail.com>
 <D0F05F9A-5097-4A2D-9235-AE395961F456@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hi all,

A short addition for question 1: x86 numbers and a Windows test.

Setup: 2 cloud VMs (AMD EPYC Milan, 4 vCPUs), 3.56 Gbit/s network,
ksmbd-for-next + the 2 patches.

Windows Server 2025 offered GMAC first and ksmbd answered AES-GMAC;
a 1 GiB copy to and from the share came back identical.

On x86 the slow part of the library is CBC-MAC, not GHASH:
aes_cbcmac_blocks() has an arch hook only on arm64, so x86 takes
the FPU for every 16-byte block. Signing 1 MiB, MB/s:

                    HMAC-SHA256   AES-CMAC      AES-GMAC
  library today            1494        207                  1174
  with experiment       1670      757 (3.7x)          2475 (2.1x)

(experiment: the arm64 GHASH approach ported to x86, plus one FPU
section per 4 KiB in CBC-MAC; lib/crypto KUnit tests pass.)

End to end, 1M reads: HMAC 449, CMAC 341, GMAC 469 MB/s today
(HMAC and GMAC at the network limit); CMAC 400 with the experiment.


Thanks,
Michalis

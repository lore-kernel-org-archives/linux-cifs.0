Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795185362;
	b=BgDFaog/2U/GQA71/WjpC4yU3n68hgNQ2luSKraJQe413IBclkjdnHk0/HbB0B44Doqk
	 WW8vjM6rh74zF03lfalChRV3vB29vR3zezor/u530trI9kduEKGyeljtTwEuK+fO8/PMH
	 ZuamAOhfoNc1nz8EBAiMBXZOBiRb1nuOk7xr98fgyZfanBw7GGazl1vCiEft97HZPWYi/
	 E45DDvt/1P8n9cGlrdLQWrP5tqnKwd3S4wPbJwV56KSUzJHe5c8l6YUI/R0TzdMvb1FxT
	 4XTN7Qv+Rxr528eEZ1cpWe2LxFBq9j2NqfJ5A8dYtJ2s4PMP6we+XwNr93RlwnNAQfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
	b=vCsq3JECBuAX7Fmxuit62BcF71QfGboNKUuT6YnbYIytQ9URpxkVV4YNg+PvLM0eDiUI
	 ttARuDIrnwe2tCA37e9hzAjJh//JwL8XVuz1NVVW940UiVq1wCtYuHa5BdoRZWxepVf2M
	 6gC8jPBxUaEUSS2v5mmz38UxRp1CwN5xAA8iX02QkiaJ8FNGNQafCKIE9nWEvLcxXajYa
	 gptwxjvl6N1ARs88DQGA9YNqyZ380YCoO8ODoK3ljduSs3B6AE8omE6kfoq50e/prgWKc
	 RNAQ/p1GWzKpuZsaVm9rNpahbUfpYy8ODUfuWdokw6oM6F3ESspAvM9WnOtRRX9y33A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmlktTxO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97C3606A330
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 14:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A97C3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmlktTxO
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b47c1a3c74so1230252a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 06:36:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795185360; cv=none;
        d=google.com; s=arc-20260327;
        b=XG7yiVPha30EonV7A9Mjo80b1Cd01zyo7wkQZmUAvX3uFTjCZIjnHAgTzCAX7dgNL/
         5+Ho/g/xfqL+00cPnhQt6czGwNlwxX3OOOT0O68r9eBUhGtVo/3TFI6b5Ae8ptBWpsFC
         YDZUKAnc92WnxAgtr8nH08G2zC+9yIu75ILbwIyIOZSgQFd7CSJfwpmqcGAMzKFZai97
         rVz8CKxt5Nd6jsWlnSxRku+HrTJtSMrk59JhQ2urmEUCpkcMWJDGJhF2w9f3eP/2Hwpk
         HcFnkvtVFso/ClS2T6yKsDqZV9uAbxIgTOTmxXbW1/TzhuOW0VC2FiF6gueefllFXAr+
         6SuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        fh=6zVzrSaLDF3UOs4Eq9UbxmKMz1TSS6qH/k6fqfeZteQ=;
        b=I8sc1ueTGa4zK7wqiKON87K4pFTd3jLmqrViEl3W9jVYyc0ASE0oaIfOAzAVdbt3Ws
         rmWqb+bGqZFz94OlDvIOnFwfL1SBtNIMeDef2i2p0b6w+DdQdAGMMuRJX5sflPcZ3jKP
         4a1SRFZFcDBOK12ToT00417FL/zi82JXksT3rg1RM4GUGvG/GNYSmu5Y59OSqKQ/qGNg
         r7lZYofHTzw89hdWPzNhJCHqfhzuOZelYonSbRb/5JKs+G2ppsYTC6K39Qy0fb34ZejJ
         0qgxh1NLKZK3sFr3HqN7MK/SBC5GNfsip6EQ7bF8Vm7HNmE3fZEBvAywM+T2J3ffH/mZ
         LjSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185360; x=1795790160; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=ZmlktTxOJqc0gUgZkQM8tVXb/Y0XP5vIjBlg31tczPuc6Q95f4xzDo/jLK66eDcTRR
         yQXNy421kiJhT7oH9vLVwxVroKGeg4J9z03nrEStYvsVMA3xboXgWcwA2+JIMTGITaZ1
         038E81NLDLzYcW4o0qQ4SonrTGr0vzYZ8MzGW8HkM5d16we7L+/rT4b4KMUSsfEHVibx
         uS8nmmaGxZ1wTgmldg9y07wcPtmMKFly5bIu+HgpUAR6RPvU1IG7Ma4/oDa4cuosYPJr
         k7UPz9VVFyx4nQjmDqMOy5HZQrVCpdYWfBCELvWA6ZL08iBITG0L9mhiTPT1o4IF12kK
         cWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185360; x=1795790160;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=vS2tydiU/MTFeg68siQx2R/5oQ6X6de7SMU86Dmdi0sUAhsitiC/x4tCGo6acSu3SO
         qpXAsgSi+Cvm7YXDMhoke9ZbbnXUHN9scs4HI1EtKINXHvLx5SDk463hZy8pIvM7/OPZ
         VJ4Mt2VeH/LvEg/a4+BLOeUSuf+C8xMVgBNYLYS0fT97qlIvxcqYhgU26e855kNSyF6G
         +xJTzEApeYw4TOJzrLQL77gH3X1O1R3ihR8FPu455MHFaiwlJLAlPhWxtPJOR2Wj6aBl
         CUVrkoB4h16ebIF55udO+OOUAfjUH+1gE6HFRHln34omSzusBw+Ofn2fkB9WVavK2fIv
         NxeA==
X-Forwarded-Encrypted: i=1; AL+hErERSz8Y+YUgJ5Kh3yyDy/mGcry5v7R9Hh5q7Jm9M4PUO+vwfVlAsmoYaFkcc7zqZUS1emYFFEtOBYQc@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZR9Pgshj3A9cMvVkPwdZyo0QCfQuVvwbEK4VezSew/iuKqmhj
	BtNpNbwb1W7T1eNWaelgL/N6bASi6WZj8TMaJfx233AwD1ycRH4HxaCmCCqYF1gPG2Ccv5lPwYz
	MjUEcESB5UCOhSiZa/MUn6HXNYpH+ji8=
X-Gm-Gg: AZFdTZc0Bc0vi4S+JAXroNKpgiCDiISqUhW4tW+b4gmOkh/rijB2t3flHaDSv/XUDht
	8xiJ9PMu11SM1xvngrVVOXL34IabzHXU6UVOChMkkKY1j3OQ/AXAh/l89TlshVnBjAkSawQWRZx
	Mzj2GPZsyYtYYdf8TXTbvVbH6yp5VQrTrzjI5rwZbO7UdSQP3kuSUHzDOqgTPuEzva9jVQgxGHQ
	8UK2V9u0zGIzKLYojrPjvwMPVJz77fjPCLyEBKDzmPKF0H1IBk/JoAmmt3nkhaZi2t03vB+BjJc
	CFwXOQ0+0ljJKMU/vUCNEikDGr4XqiNFIRDLv99mdrESGy61bRXjkpuVWCnP1cqdFRAHk5W8E27
	Fcp5l6n52OeYQ5d7CBLP7oAUducwHzkcF1vrJfiOKUxm6FGKlQh3ArOJkUkdER2+WVrWojg==
X-Received: by 2002:a05:6402:448e:b0:6b8:7769:ffea with SMTP id
 4fb4d7f45d1cf-6ba37ece3efmr2475801a12.45.1795185359456; Fri, 20 Nov 2026
 06:35:59 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <av4Hn9u80fs8iHZ6@dread> <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com> <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
In-Reply-To: <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 15:35:47 +0100
X-Gm-Features: Aa3M54oxXjJW5NIYEP5VP8q0nzSYgFKLfJAws7Wa7snJYDGBmmJmUUUXbQQ7PSo
Message-ID: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
> > With non-zero xflags_mask, internal contact masks
> > can be used for -EINVAL not for silent ignoring.
>
> What do you mean by "internal contact masks"?
>

I mean that users do file_setattr() with a bunch of flags
some of them are just ignored randomly without any any way
for user to know about it, because this logic is some internal kernel const=
ant,
which cannot and should not be documented in the API.

Thanks,
Amir.

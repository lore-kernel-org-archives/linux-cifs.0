Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970479;
	b=KF/gyQjNoJiF6TIG7fhokY58D2A6aiZeuRIcr7I5fEZpkcmlyiSMV7sXWnM6Dt3aPWtb
	 rBVpUN3r1oFptYSEnqv8BRAn8pfxaGkN6+D0ZJnyn9yr0OF0IhIrJsMlGJ2DB1G2CKkTB
	 Zk+KH3KUGdO7j2SoTDitE4ti2Cha70X4foJIDmFWr/b2IEsVbyYxorbvPCenOPifqNPsD
	 KNH5RuKZAsiF4LRw+Rlw1w6+zMiDTh0vhwNcV+7AlniXZ1LZV4PFffY3Jy/lLQULdq/7l
	 HXhQcl/nzUFu1xvOM5Zi1aY8ke0+CtJ4MBpC+qoxKsjr/eMBdYQ9ccSYei08tf796nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970479;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=uDc/LaJHkfDT+RuC4ygk/L2U7lArOkaZD3mluMfE4wg=;
	b=bqfLr0i7MCacoEYStYeCc4Qev7Wsp9DWAVg1M3vpEIYr90ahYCVMPkpGFrN+U1XU2jk6
	 oyPWNJ55y4pc96xsMkVe3zoAhwr1Z2azWonzs4wEyjU4DMn8d7SWovlTujiTeUzIVr8xG
	 U4gdD/h1F76zHhKpW2CZUZFDBBjVSfFjMaOy6JIpLAi7lr8LGY2HUC5BFBOKsCTSPl4XW
	 i7v03nl1OLJxLPCUzMwmcofYgUs1itB/rpALp2C6eUpggC548WwHSxihE7VedrBkZJmna
	 qEPX2OagmL5LTwVIKrzfMICANhAYGV826NoDK3ISxCNqhwn2RdKAvPCK7EusHgrcFZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OvXkJ++Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A2A606A32D
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OvXkJ++Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1CF1F0089F
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 13:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793970478;
	bh=uDc/LaJHkfDT+RuC4ygk/L2U7lArOkaZD3mluMfE4wg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OvXkJ++QLDcq2nfaFOjPjxVUzsijDKGslNiGwrYv8CeUE/ft5xXNYBwr44ZALMi2e
	 f3yPAefE5U+/BRPMWqFG+0c8v+D9Ce1Lg/8HGrW9fIwQs2qr1V4lnKHFtkUyNq5ppV
	 /w83Pzw2a3+IkW2wa6wW1sSogxP7Autqar2oYeItPPYNHszqnCTuPSzJd4iXnWdPnV
	 GgFt+1IUkGGNnlyPMCfxTBQZ/RpXEHa6NsL+clWZHWaNIb1nxLpSmrMoTEvin92RgH
	 WtgkuJTPlkiCadyPzWv1Cyf6e8J40axpJHrCdzdpMftVMGe94XPaJec80d3REBl2Bp
	 5VTnhNiR4DREQ==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-679965fb848so594084d50.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 05:07:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFZ+J4UOyurwUzYeOd26YJntnY1Dj6ynLfE9E3wuNK9Z1RbtmuyeRmoyK3cXK8N//nkHH3BwsFxG3Ku@vger.kernel.org
X-Gm-Message-State: APuU4Z8gn/Y5zTLZha9+g/+bMzXSCY80FmNeimcvsk06GcwbdY66MuXJ
	5gcLgeYb1MRO6jwwfdVT6te5+KWZLnQfBjOxoL2L3BbfAj7jNLq2E+Cg7kHCMCNLhvjVhUzIv1Y
	zEVUj9MZaRaAC7GhF65ITOylApiiOPto=
X-Received: by 2002:a05:690e:1488:b0:673:5042:76f5 with SMTP id
 956f58d0204a3-67c1461786emr1295872d50.91.1793970473041; Fri, 06 Nov 2026
 05:07:53 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106104842.441067-1-pkfxxxing@gmail.com>
In-Reply-To: <20261106104842.441067-1-pkfxxxing@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 6 Nov 2026 22:07:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-vcfTwiXkAU85=+jz3T0Y4nfxuhcEcqP9ZCdzLE+soDQ@mail.gmail.com>
X-Gm-Features: AclHuK-ZNY_mwZOQF_e98A8heV7DdZ8uvP9gqOWB-8hU1qZCDIy4ykpSRDAcVbU
Message-ID: <CAKYAXd-vcfTwiXkAU85=+jz3T0Y4nfxuhcEcqP9ZCdzLE+soDQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] smb: client: validate ACL lengths and compare encoded SIDs
To: liuyong <pkfxxxing@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

> liuyong (2):
>   smb: client: validate descriptor headers before query result
>     allocation
>   smb: client: compare owner and group SIDs using their encoded lengths
Looks good to me.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

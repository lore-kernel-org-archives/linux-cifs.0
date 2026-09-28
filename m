Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6319339847
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 05:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572657; cv=none; b=JtC3SI/owp2xruw+6oNluLjcPnVQFs1Kn486yQnCTHLRgcjE6m4kaqwtPBsF+gkGCgj5xEjQNHJ/dYgxKb2eEU9lcqdQb+oP/s43j3RUqmPq0hANHLmXe+HVmkWE/gasZXQwvV/m1o8gxkZ2WoJwRt78eF8dqT7jGrPJARzj7UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572657; c=relaxed/simple;
	bh=Ubl5ahUt9+d6TQXqOz4LsOJJBWLKc6J82Tnd8BSHv9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLR9iHxJzKiMV3U6g+f9YQms6gRHrAIrUCaCehvQ58IjslUkM+/TG/jA+7of+D0+e4/VmrpOjIDyK1jRVakBwb83kBJ1zLmOZMMaF/MVgHr9uEqQbTV2Axa0/ARzYJwj1TrgKuzcZrHX/+417HjffN1q+EV9PlPwn4gpPqTWb9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cY8LUbSZ; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cY8LUbSZ"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-340fbf9c1c6so1560571eec.3
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 22:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790572655; x=1791177455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ubl5ahUt9+d6TQXqOz4LsOJJBWLKc6J82Tnd8BSHv9A=;
        b=cY8LUbSZsjku3hRLA95+giaU5tPzLN5JQ7hB1xVL+6KNgmgSQdzVOkX6r02sxKKJjL
         OYfsLcMJycJ+0TGzzzaO+jKIXvUm8uSDAuX5u0l1/52qKfFzTu7Iw18EsI++1ey1SsoH
         0TnlyLiwvFilnXRE4kW1o7M8BX5n/oZCNZY9R0VfyPKzutEQpFvOUwclxoiyjNCqMRJe
         coeTlMA+jbxqLGiS16ZDFsEz0z5+ur8Sp5+D/+ZzTFbp8AAMz1BFCH+TIEOvTvTtmigc
         4lxnJ61eUN2Zc9gYALr8yU4aLoQuuxvWzrf3VaHz0RAu3aIYYNAz2wd5pIivnnQGpUGD
         77sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790572655; x=1791177455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ubl5ahUt9+d6TQXqOz4LsOJJBWLKc6J82Tnd8BSHv9A=;
        b=wqCSCjXrDs9MN5owx8re3jWK12lc9xVKxyhwVIJKokGeyClkB6DqEwr0zUCBV2HqF1
         YdZuxkaf+U7tHI8kBbM6sZRKAGwCQ1AVIfZLVkmrPq/M415RX/SSd6T4vLMUTDJ+i8Jl
         1srXGgZWHJD896FFrdJvSUiqKwyz3MEWjArMM/HUVCPtHheHkpyYeLP2Y0feOzqKOiPN
         GUqWoxhJMihfqjV3OCjkk/bka1W9on6tXWSJV+jFrCpbADWizNRG5f650eIxC/piEdo+
         qoQx8aufLU+EGd3G+LllhBptXGp7LWoQBT0OyC3hlykZ7Rlya1u7IPt5v1nI0+3EOsvg
         Dxtw==
X-Gm-Message-State: AFq9FYJNx7bzHZhmfvufClqOOlZvaHMJw4aQknM1m+AES9hAboLvPlFA
	6sVXnRUp8ALXNkZv+Uft4oRSRbYzPBWjBCdkb1LeaKDAGICIs3itAmkGeVFLydUunZgwgA==
X-Gm-Gg: AYBFou3fFq9wdbmEUCAOKYlWHn880ZMQzYul2gn4ZIa+ghLXXqdT09KtUChmpE9WV74
	SsmuUG5yXH3CjacD1Bs6qyl/l4kpghIPwBW2w6mLICs9pcYptKDObNIzpO8NHeAlnDs55vo2VpT
	FT9GSLcSGygkCV5dcQLiIiNWF6YPt8+O9doSYU0Yzq28O4+U/kfcSK7NXS3g6N3z/e1mHU9YEfs
	2c+o8RqyDSDoDMe3P3Vul0y6SyI4b+0/YMPKA0LeQCq8MkTJu7vRdkD/rYX5CEC0IoIJSEoB1aU
	lwt6Z7C/2plTiJNyXAe6go04Hl1zQBuikmg5za2LH+G2xPBd3s0hGnRx2ESR4VklIglCox/cWSh
	ZwG5hUKAC3S1JVnmQpCSh6oMbUI3I4wDwVXRJVZ6hrIaZPT2gnFpvfFIewRS6L05w3+NTP6WMNx
	LjxagRhcodcv4cNnMbxg0m6pQ/dp1QZIqO2/fNULKlbRAlrWwwJMmHI3n3ju0pXCx757tLFNdJu
	cQ=
X-Received: by 2002:a05:7301:2224:b0:341:2466:2d68 with SMTP id 5a478bee46e88-3427304d4e6mr7925230eec.38.1790572654073;
        Sun, 27 Sep 2026 22:17:34 -0700 (PDT)
Received: from localhost ([8.219.88.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34571658054sm6999522eec.8.2026.09.27.22.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 22:17:33 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Dairui Zhang <zhangdairui@gmail.com>
Subject: Re: [PATCH] ksmbd: verify transform SessionId matches the decrypted header
Date: Mon, 28 Sep 2026 13:17:30 +0800
Message-ID: <20260928051730.1789636-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928031300.1782690-1-zhangdairui@gmail.com>
References: <20260928031300.1782690-1-zhangdairui@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Greg KH wrote:
> The "v3" isn't up in the Subject line for some reason :(

You're right, my mistake - I forgot the version marker when
respinning (all three went out as bare [PATCH] with the same
subject). Resending as [PATCH v3] now; no code changes.

Thanks,
Dairui Zhang

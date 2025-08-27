Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7082D0601
	for <linux-cifs@vger.kernel.org>; Wed, 27 Aug 2025 21:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756331936; cv=none; b=Mg8z4ADkXE+YKlD5fgK/nLYo6dXl5OOvCOdC07EkX2nzD0p7UqjaCmX4VmP2my0ORlc7c4gkd3GoBfG2an/J+v9eWDhymWaf/du4i65YvD9DP0HlAz0PzdEvqrBwfiAsSaPk7rrYa2/Q0HFQRcetUfgkJOz1LWo569BN0a0TEdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756331936; c=relaxed/simple;
	bh=JMen7NBAn82i+cQk+lt8r7DC5nLvXvmXVHIEN5KsKxI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=b7dPNE534IGSq+P26T+JcWtbxTTWi47gY4DfyjxGSqn8gPJJME9l7OXzY+4n7ZPVdoHM4WRqXailtwa1MuyyuCxaWtCkVWUGcitmCnO2hkkQKZXl8AKfccQECiuxrSMzLFjn2hSJIOA+GdBUbIjze+ag00CCDpJ9eYrDkh9kZ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AH7jITyd; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AH7jITyd"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-70ba7aa136fso3355686d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 27 Aug 2025 14:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756331934; x=1756936734; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yzIjV4c89S7ROlNCOSrQhiHr1PdqwszQTn/WOp2kg5M=;
        b=AH7jITydwOeeMYsR8hcFxGItTXypO+LRIkI7ge948psqX8U9OQQHA0a2FC2dlg1T22
         8PVnh1p2MorPQbmD5nDDce2fKd2GOfJQZqPsrbDGI0nQpsk9ran56H0FJxXM7Za+y4oY
         nnH/GPb/dUUQTYt8kvDOwte9rmPBZFDhm4PCv4XHDTz/lkcvSMs4dYlHFekvW6zUzo1m
         KqoHgbOogJuYGH3yWPZRpt8YZyh0yhXycO0IDGdpf7WU9OnTBb/nTk905KK8NxXYcjv2
         KupvGseobM3YEiXBa2xF3wLripPn0u1VAxbliHP+M16msBpWYdPvwAO2Wjj/cD9Aze0B
         J0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756331934; x=1756936734;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yzIjV4c89S7ROlNCOSrQhiHr1PdqwszQTn/WOp2kg5M=;
        b=uWr6GqhjHCHLMBhenBBhl/8CclpDl3ZokXn8pnCFALyOTZZZRwIyQu1vw8aQ49mWPU
         XemIVnq+4UZrHpFpruWc+Es+x1fNf2cukiwRFdfs4Ab7/9I02itHVLPLBma9G09aFTB+
         /cy/buvXCJTHdvovLuXbNL+e1od1l5AP6b1ePJRunq7n1qJZpkSADmnhjHLcELkgJFNO
         IjEElnYzOdDDh7mmxonNeWmnKlN6fCadrCq5KMMcENb5l9yy9xX/JcmY+2hqN3yfwMo+
         VUwobyWojVuT2+c0WxgxvPJkrOhi0ORMzTgqzhXmQaW01Ef4HLNnyh4ZlnI/x20IraRD
         uoWA==
X-Gm-Message-State: AOJu0YzjoU8yaphXh3qqlFaPr/4TrnUvnbXGPDAi5uHJJqdnEXez7FMA
	8uCxt/MSqyaJTspYwsRTM5yY3asWh1DjaYDnQhqsoXdDGUTsKwtf0UiwTQIHfNFW2gwhwc1UpQq
	94qmVsJ19I0LtKY2+aZ8VL0Q/5Hs2UeY=
X-Gm-Gg: ASbGncsg/Ols1GY3Zm+SQluYaMhGvGgZ0NrjcEl8OufXHc64uCn3BrZhNVx8D/R5Vd3
	B/xWpehO/+E3w307j1lSxniSgSh5DeZcRjCtFKzBs/ygc/fp8kGwkcAZP0IqtsHQwbzO/7rmDk6
	AfIO8vzOP18N+8jik6OOcHuzC1oRPxHoLuFiMeqKqZsoC2qef3Q35QgKnr8BjDqZKolr9gVx88L
	27sHQvUig8MryxmmLa5x2HLFEf1+QqzFMJlweBT/at35ozfmA23b6FxcZxqfbRoEXIT5ZcUssBn
	/qRRV4vs4vYpP4QPmQCgBg==
X-Google-Smtp-Source: AGHT+IFQGRy2dINZWM2cBm7b/gKQA3ZkUZHpgxrkb20v7dWYad9TbewPcF8RdfSiBrc3TXa7QaM1lsCOQxWqXifFIyE=
X-Received: by 2002:a05:6214:1c4b:b0:709:f2ed:bfec with SMTP id
 6a1803df08f44-70d9720cc01mr213882196d6.49.1756331933889; Wed, 27 Aug 2025
 14:58:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 27 Aug 2025 16:58:42 -0500
X-Gm-Features: Ac12FXyQEZbB7fOY79Kx6W1muMTDNT8p9OlXXf7csm10E5_huxhfwL6_5J2uj58
Message-ID: <CAH2r5muHpZOTU+CHrmG1OnpvXNmfia8CxAs8v_uEPOZrHFr-1w@mail.gmail.com>
Subject: smbdirect patches for 6.18
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	"Stefan (metze) Metzmacher" <metze@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

I have updated the cifs-2.6.git for-next-next branch with the 144
smbdirect client and server changesets (on top of for-next which is
6.17-rc2 plus a few cifs.ko patches unrelated to RDMA/smbdirect)

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next-next

Metze,
It also looks like there are at least two "Fixes" that qualify to be
merged earlier.
Do you want me to merge these two into for-next (so we can send it for
rc4 or rc5?)

8170223a650e smb: server: fix IRD/ORD negotiation with the client
5dd0894d057a smb: client: fix sending the iwrap custom IRD/ORD
negotiation messages

And if so presumably Meetakshi can do some additional tests with just those two?

-- 
Thanks,

Steve

Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902356996B
	for <linux-cifs@vger.kernel.org>; Fri,  1 Mar 2024 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709284188; cv=none; b=kdX5AvwZUduKf7TNbv0+ljWQlMk1qBbESxnD29f2DKYmdYtxKnaOJ0fkJcGxEQi9WPX0bytT+s1AqqATFyZTiwkkuFVImBDrroCyGtRA4LJN3etGPobArCUdPftjbEguDx831PQvNBABSxVWW8ivjEFVV5ieFnma+wF0NJGIqs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709284188; c=relaxed/simple;
	bh=hDzYKhMSWbNBLfb1J2p8CtGVR+E30bKhR3qh3oWcbfM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PdcFDxTnepHIEed6iZgXrUxe0NXldSP9Tct+bgSeLxL3Z3xHutC7KKs2hYa1TRlmP2dax105M0d6r5x+VUv0g2cmKjplwtUz/kJcg5hKpC/7UOYRnmJgrRZgjj/yk6YKSyOluOnvaW6Lrb2jeQPDFSwfRhRYj79A+YB/SEU2YYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7o6EjNH; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7o6EjNH"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a44ad785a44so2282566b.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 Mar 2024 01:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709284185; x=1709888985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fCAY8YOOr0G7a5Y1hz+CrL4ikWPMmndntBZOHcNQjNE=;
        b=B7o6EjNHSyQVrLCCyPUiEuY1WiEM1VQW9uAZLBa3Cdrf4tF0xFNN5rP/Tf6gcIO7tj
         rM1KYgkGrWjniK7NJU8w72MgI3ewZQi2cHMudmdzCx14nFHtBr+Ty/HmeWs7+gOz3sUo
         5OTyWI2YoqMgubkW9QhRl1B9wfTokYEphWHVePBfWaph5MoK7yucOwMBVFItS9mq+4tA
         aYcYxHXp6fxdLWKiynGL+HMkThfiYi9M4UpgfVSR8m6GJOuQgwEzSnEYXx596VaqZiME
         jWclgwTDO2FQ12Z3UlU2nD1MPTDsspW0V/KwUlhn7/z6k15CK//qEsUU6v8ySUxnZjU0
         PQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709284185; x=1709888985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fCAY8YOOr0G7a5Y1hz+CrL4ikWPMmndntBZOHcNQjNE=;
        b=rUMAl0M1ytU43i+B+50AGZ0ZKe7ef6nBJKJRBtLqy3xbZC2RnOCbVHe1YPcJKQZ6TI
         YUJxFzjK4hJPsUQYr2BkiqzGsqj/2HCEpYU75VgSOMzNdFQUY3IskQdgVBj+snB7kpnx
         j/ESIxWGNZZ1QHd+gI1bLqLql3kXX0/htGRYtctu4PYWCTzQScRmvw7f0zjqKDvWilRO
         bEKJn6ngumQjphEHd15z6nZF9d66oOfvLAUcvedHkhTU6shlj7rB8fwLIGRgRd3Ohq94
         KIU/wgqgmV2ekPslA7vdM3QQQSSNKAGbfQgLIkv2YbRO9m5SE+x1fZ4d896JRxObNq6v
         tGlQ==
X-Gm-Message-State: AOJu0Yz0O/ISTCrVbnqvb+6uZxqauHw71oA9Brj95QoFMqldO6AxcxnA
	TlqRb3C5+cH10dTdx6wGWbBg80XkpeCj2yQ/O4AREYOLWxzjSh9rj3JfnJ4=
X-Google-Smtp-Source: AGHT+IEULVplcWS/hTgOmJUqtZv9dqKDJ3FhKC3ERTSz/vRVvJLuLZkYNBIH2YsHBUdoS/EcViWVEw==
X-Received: by 2002:a17:906:844:b0:a44:442d:89b3 with SMTP id f4-20020a170906084400b00a44442d89b3mr768184ejd.48.1709284184458;
        Fri, 01 Mar 2024 01:09:44 -0800 (PST)
Received: from torus.fritz.box ([2a02:810d:b83f:e400:16a0:2f96:e202:fd52])
        by smtp.gmail.com with ESMTPSA id h17-20020a1709063c1100b00a42da3b6518sm1515737ejg.18.2024.03.01.01.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 01:09:44 -0800 (PST)
From: David Voit <david.voit@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: David Voit <david.voit@gmail.com>
Subject: [PATCH 0/1] cifs-utils: CLDAP-Ping to find the correct site
Date: Fri,  1 Mar 2024 10:09:20 +0100
Message-ID: <20240301090921.37353-1-david.voit@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi All,

we are using a global AD domain and all CIFS shares are only referenced
by DFS entries. As our AD has more then 30 DCs the default random lookup
on mounts sometimes leads to strange network timeouts and other
problems.

The IPv4 path is tested on our setup on multiple sites, but sadly we can't
test IPv6 code path here - I hope it's anyways correct.

My C skills are a little bit rusty, let's hope that I didn't overlook
some pointer-foo :-)

Kind Regards,
David

David Voit (1):
  Implement CLDAP Ping to find the closest site

 Makefile.am    |  15 ++-
 cldap_ping.c   | 331 +++++++++++++++++++++++++++++++++++++++++++++++++
 cldap_ping.h   |   9 ++
 mount.cifs.c   |   5 +-
 resolve_host.c | 270 +++++++++++++++++++++++++++++++++++-----
 resolve_host.h |   6 +-
 6 files changed, 598 insertions(+), 38 deletions(-)
 create mode 100644 cldap_ping.c
 create mode 100644 cldap_ping.h

-- 
2.44.0


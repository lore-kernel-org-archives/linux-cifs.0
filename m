Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1896E2AD3C
	for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 17:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358389; cv=none; b=JJ2pllip1Oqp+jLiDaoEJKYY6lisOY1LbDJMdO+CubYdEMf0zvXYu2o2TMOUbuJx253UHvWkfKkEmM3Hm6WTvlTFfx/d9JeoZRKyILe8Zq9Jpj8vVG37KSHWAB5CHgluiBiez+Bd2p3KBH29cBO6SieXF0Q8F07LoqvAHVZX8ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358389; c=relaxed/simple;
	bh=h2qiDpM5Erdzg6/XG4ZjQ6GeIrCfziRkuUmDwX4YjAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VNL3KjUyletGSW8jGR9lg4Bi943Cp44JnKCzaY7134/2b26xJDUrZWyF01Q6vOGkH19gD0vSH6JTJduEimC9EGC8QENKYWOIvWWy30lvnrx59BnVI2R0a1MSgn0PMcEIwGZDM73nLgUU1LWZO6dWEiXUebIOOQoZG+CAXe2GvjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOQqBOZi; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOQqBOZi"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so510591a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 10:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790358387; x=1790963187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J/1CUxZdPRLXVmg6FKXI21x9fNH8kiNaUWewQCMGukw=;
        b=bOQqBOZiDiVoRDd5tr5z4d6KMAN7Sx4NzCxTfmrsNqK0VWH/rFygwSiJd8b1Y0XtaW
         iNgdRkVLS/66WKRS4E8NNBm6kzGvfp8XibAq8qN6SpVfVzPqXnZkNk4pnaNjtE4vYeBi
         3bZRJPuKFFmCWdteyTwnz671azaHR7H1s5dkyNRw6CS+VDf3l49jF6Go8Q/0bk6ijNSc
         tYwtIqaiJX+0pjUkBAv90wOdiXGHElLDNrhsoMNgPIrtZv5oAXxM+h3+xKT6hrIJeUPR
         uRYAJ58BlaEeL0EBL+ADlVtNK/Xi1HN925uM/9ECOy9bNqQvWmBlIa2iUKUEs46tX5IJ
         8eoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790358387; x=1790963187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J/1CUxZdPRLXVmg6FKXI21x9fNH8kiNaUWewQCMGukw=;
        b=yxyMxHStNy0jefo/u3QGPrTPYp2RPgBzqcGAa98TJ+QrPLCZAmuyUzdAbQPrJ7Gj8S
         YwZr5oxA02bEYqTJS98+xWhDPMqxbkcCj7IeghgkhFJvkNPOTaKr0oy8K0vciE2F2gaQ
         +2wYU1rWCd2Cdfc+GiR8nJelSc0jDLhzry2cXcPMxCSepu04tpjh0t2J7OnJDSH695Mc
         FhZ32bRtWhj3sRsY+wKma6sYU+D7d+RsZghZeDGxuuxGfOTzJK5R+5DVQyypyZ2oOGDV
         jZevlDo6rOcXo9wPTWltCZsWe2BIPmGQTo1LJrscb/pYwZKPPCUZDrVE9K7xjaL3JYOp
         bgLA==
X-Gm-Message-State: AFuF++mCYpcoh7GlsoAdt8MGXRgvtKfwtL84IR0kV991wj/sTubcNf5/
	J2rBF8JcY/O6SSPSEoZtz3aUZEeWEU/Z9qhWhPYYG3bt3QuUOd10xuGj3VXz2Bwg
X-Gm-Gg: AYBFou3YGrgB1TB25SrcH4YMjxBULsGGaDobe5FIYIOF4aNIWhHHJGicMWycny4Dk/p
	HBLVXLz+FyyYa7Yi+QnGi0dOI/V2xx0p1WjpHBhb5k+K+RCkae4AOXFE/ezAqiVDrgbeLEQnasv
	2tfRyEB0P20pNaOsqp2h2jpnlv9D34835FHWnJ4LQArFcwcP+z4DQD0vGIJQvab8CvC12dkHzDz
	Vx95M2v+sfxIC+v/V3g/lg+/LxkWOARWVzQxwONzNMRE84ODDPqluxbUJZExZEi58Gk2bHIUsio
	UVyOj3bSMcrcuKtKdqIng6ywkqgLqTjYa3g2MH2MRBXXFJemqiPgpc9es2Ybn1IYAozET7Il0rA
	oW4/4rsOTPzn7tVGCC5s4sElajVYFDKj3EBC/Jf05HlDFXW8uyIgNH98sn17ba6rj66MPrXjiev
	SAdC2QT0pkQcRnFL+7gruo81l8oRBxenfyt/RwM8L+mgmidkBnpwJjtkK8DbQQVXXN0V83b0rMu
	v9de6yLfA==
X-Received: by 2002:a17:90b:1e47:b0:3a0:c72e:46d2 with SMTP id 98e67ed59e1d1-3a0c72e521fmr1654894a91.6.1790358387247;
        Fri, 25 Sep 2026 10:46:27 -0700 (PDT)
Received: from localhost ([101.126.86.154])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b7d11124sm6594498a91.10.2026.09.25.10.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 10:46:26 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [BUG] ksmbd: no check that transform SessionId matches inner one on encrypted requests
Date: Sat, 26 Sep 2026 01:46:23 +0800
Message-ID: <20260925174623.1640482-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I can't find any place where ksmbd checks that the SessionId in the
encryption transform header matches the SessionId in the decrypted
SMB2 header, and the two are used for different things:

  - the decryption key is selected by the transform SessionId:
    ksmbd_crypt_message() -> ksmbd_get_encryption_key(work,
    le64_to_cpu(tr_hdr->SessionId), ...) (auth.c:849)
  - the session that authorizes the request is selected by the
    decrypted inner header: smb2_check_user_session() ->
    ksmbd_session_lookup_all_states(conn,
    le64_to_cpu(req_hdr->SessionId)) (smb2pdu.c:938)

The only reader of tr_hdr->SessionId in the server directory is the
key lookup itself. And since encrypted requests are exempt from the
signing requirement (server.c:144), a valid AEAD tag is the only
proof of session identity - but it is checked against the wrong
session.

So on a connection carrying more than one session, a client can send
a request whose transform header names session A (decrypts with A's
key) while the inner header names session B. The command executes
with B's identity, tree connects and handles. The response is
encrypted with B's key (or sent plaintext if B's session has no enc
flag), so the sender learns nothing from it - but the write has
already happened as B.

The case I have in mind is a cifs multiuser mount, where one TCP
connection legitimately carries sessions of several users: a local
user with their own session key could act as another user on the same
connection. Session ids are allocated sequentially from 1
(ksmbd_ida.c:18), so they look enumerable. On a one-session-per-
connection setup I don't think this gains an attacker anything -
please correct me if I'm wrong.

As I read MS-SMB2, the server is supposed to verify the two
SessionIds match and treat a mismatch as a protocol error.

Suggested fix: compare the transform SessionId with the inner one
after decryption and drop the connection on mismatch. Happy to send
a patch if that approach sounds right.

This is my first report to this list, and it's from code reading
only - if I've misread the flow somewhere, please tell me.

Thanks,
Dairui Zhang

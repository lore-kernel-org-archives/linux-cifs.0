Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794327430;
	b=zKr6lFGPyZP8Vp2iwmcA/Nb+wl/QV/03L+L0GPyzbt/PqcihOoC9sJS+EjSE3ibHSwHp
	 18aEtuUIbmyK1W/B0X/mpmHGoP/zPdmMazwFF2+Ch8lq7K30UEmq6H/2lzNpK/gNp4uSi
	 ke1WSOE7j/KCE3LbwFZ/wE4i7v19EbkaNkwLa4dVaO5YQFLiSnhpbTij4tr7w5S6n4KkY
	 brfn5Ot1cX7zOcfs+cU02jisbF/+CuAuXgQTLysv4GoZPdqx/h5AjbTNk3C89q8mcP+Az
	 s19aEa324vylPk2irjyESgCqcPgqLU3uqaFIO1ceBqHu7DRrnZbKjHzMIXxgqYY6lfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794327430;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KaOAbVYlOcg6iQTUoIjRt0+mUMwQVsYG04xSb+9+Pkk=;
	b=eFMBGUslVt6oiMCtjfgi8Q1fa3kw1dFIuCiz8FyB1o8awYcj6GCee6lh+/435NypxEbi
	 qS8eS/7CLNto8uiJBhHS43hqUD7TUEMF/FVbJmwTvjd+s7lcZHsR2rhnC5uXYWZp5f0/S
	 yYZtC11n3KwwpyxMcpzlittmNM9JnQ0jguo49Vlu3mFuEIxzHw3DklPNynjD8ntvc5rVN
	 0yP696SW0YscsXuW/dpR08Hn2jQXDnuRxtBVnSEGRi9hcWiWNe9rwH92civVMuBIQj8F2
	 ej/IH/GC+yKDn3SRRxhFi/d0H0grLW943VsTTFE4vAzabf7bV0cAUW8RMv0xoUZSJJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wRC+Hyq2;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB59606A323
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 16:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BB59606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wRC+Hyq2
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-492f0a1b685so1503284f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 08:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794327429; x=1794932229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KaOAbVYlOcg6iQTUoIjRt0+mUMwQVsYG04xSb+9+Pkk=;
        b=wRC+Hyq2Wqv8c8vOHhlWvXMpZNKcJbIlzeNbWRpv5WhAAU+NlEMOJwUmRnbGnos8i7
         2JobI5Auq/SonZjQc32wUaLn43B/0dLZR+y3obSX6Mrt8mSEtSjmieK1K+HAC5DJf1aV
         1xNwXNY7srS8v5fErecT8wUeArk6LWporJQpYSj3759GMzfTzu3lSznYXbr7A1ivjfLf
         dwXv0kEIzxErWAn22+B3o8ev4MMwEUesGQF2hnd497aL9zqaYgfqnpRLdSrOTkOWT/re
         mWJXmzfv9hPToixbjkZrpwqzMxBR874MwPhCxqV34YW/8W2b+D9riI/HglDlXj1Zsupu
         WMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794327429; x=1794932229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KaOAbVYlOcg6iQTUoIjRt0+mUMwQVsYG04xSb+9+Pkk=;
        b=nVwn6MSpga8fPYUS91mfn4ghNzMtsOoF5C9169qyAD5Rggj1YmcRIKmnEaMXN3QE38
         4gbZn6Y8cgCjuA0kVhD+5PjJC1uHwCiD1npVxPJproBh9/vto/Hne53S7MJwXSDefOzm
         grYHSBQvLoWZJYQjfF7YsZziqN2Iq3G/X2yR7XQNBssiAzUIPGdVVOCLVV70a5J8/jZ1
         wTBOX+EOQu505EoyxE7JFHjLLw8vUSsO1EA8EyCHf1cl8MtjSx2pxg3He8WJ3mYZQyDt
         J9IZDMdydvrkExZ4MyZaPHLrUx36Stw+DeW45ENI5+2/lWKSLnp+kVaZRYTN909rH/sy
         EeWw==
X-Forwarded-Encrypted: i=1; AL+hErH/3hsk+GaUHPMUZJTIjurH5Na5E1oc9mrVFRkvSCTwYEpvAnixm3qH+ru6Fsybvv41P+ZhbHc3xuhT@vger.kernel.org
X-Gm-Message-State: APuU4Z8veVz8rNey5Lp6O6prgYul/q5dOspWxBGqIj006Kw0dsaWL0O8
	mf2UhxwNngL1u4dsyZSYLmVDoHX+rSB2Ou+xCu3qGAPtd3r6nFEE7LY4
X-Gm-Gg: AYBFou3/ZTJCVoN+lAnh+XNZlDtlUEW+ICc52BgEaxeIqJwc6DmwSIuelTlG90PN+AU
	EpaoxKNkiCYbabY0wN50bbjMCryextJIim/fbSCre+WpVJAj9Ud1zfW+Mke395hsIWXEA5/WkGI
	kKCUtdT4hFZgI4OfktCFazKVFfU+2DPo2fVYw3zi1N3ctMz7dOeKS8+4o/0WzWxIM/sGir6+3ct
	BDM2ZHVPPUQ5hcVLLwY6UU3hkQpkMFYE3BgSTqkcI8/xUVmlz/HEU7MIDa4kRoUZh0c36f3R+dT
	6x6peeYi1DvxmChjo1TqRVO48ijcuX1540qNxJnLrXOS52C5/cWl2gYMzsSgoWwWHSomixqBSyk
	d5i5r0FDhIXolRJs5Wsp9nDgk/9WgLx3nNAYTklmUBD4l5lIpYDUbxpGTXJcNQHl28SbVoce5Il
	1Fwneo2y1Dub/hInvsoqo74t6WtoRcRvkf9/x9O9vv4n0E33WdWTDl5KyJRmdwzk4u9pj5QlyEi
	35OfEXfUdNh3nKvm2totLdBcXj+NA07tHRXNHDQgSyJAjUSXPSezJC9Pg560CUfJX0chFxXRrSc
	QYxzmGXbVh1yD5ZcnXcnD032
X-Received: by 2002:a05:600c:6094:b0:4a8:cb23:f71b with SMTP id 5b1f17b1804b1-4ba0234759bmr52917285e9.18.1794327428636;
        Tue, 10 Nov 2026 08:17:08 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba02381034sm60851195e9.4.2026.11.10.08.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 08:17:08 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marios Makassikis <mmakassikis@freebox.fr>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH] ksmbd: set create_time to btime in ksmbd_vfs_fill_dentry_attrs()
Date: Tue, 10 Nov 2026 17:16:59 +0100
Message-ID: <20261110161659.481208-1-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_vfs_fill_dentry_attrs() queries vfs_getattr() with STATX_BTIME,
but discards ksmbd_kstat->kstat->btime and unconditionally initializes
ksmbd_kstat->create_time to ksmbd_kstat->kstat->ctime.

Check ksmbd_kstat->kstat->result_mask for STATX_BTIME and set
ksmbd_kstat->create_time to ksmbd_kstat->kstat->btime, only falling back
to ctime if btime isn't returned, matching the existing behavior in
smb2_open().

Fixes: 5614c8c487f6 ("ksmbd: replace generic_fillattr with vfs_getattr")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.3
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
Small fix I found while implementing ptime[1].
Thanks.

[1]: https://lore.kernel.org/all/20261101015551.786044-1-koray.fra@gmail.com/T/#t

 fs/smb/server/vfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index cb3f4f5fe9cf..0c95d4668370 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1914,7 +1914,10 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 	if (rc)
 		return rc;
 
-	time = ksmbd_UnixTimeToNT(ksmbd_kstat->kstat->ctime);
+	if (ksmbd_kstat->kstat->result_mask & STATX_BTIME)
+		time = ksmbd_UnixTimeToNT(ksmbd_kstat->kstat->btime);
+	else
+		time = ksmbd_UnixTimeToNT(ksmbd_kstat->kstat->ctime);
 	ksmbd_kstat->create_time = time;
 
 	/*

base-commit: b0af9a3e6b1534d353ca6ac23caaf46127f62e4a
-- 
2.56.0


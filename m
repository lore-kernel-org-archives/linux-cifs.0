Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795084707;
	b=cQo4qDq7ir+id5fQEe+VnKR7YoJb+ASmW46GdwKPWOR6wOFPuKWIksltRtA8tbF2fnpc
	 +UXgMapINkqZzvo4AbGnkbbfV09WS0JpfTco85zBy1oTKY138m1kUvvSiYRI8KJjk1wJ/
	 ghgcYzrVGeRm213p+gevdTS2MLSrtLP+dE26kFa+RKolm2G717OuoMvEuIEXq9YHmnRBh
	 ekQLmPvIIw9lQStiY+QgOs3MdD3+0pxF+LbyXOA+o1kFd7wD8bmoARbXDW/81VQ5YiGB1
	 4z8QPWGqk5BN66eoIw5JJ1k4HadbcGt+Z6pxR0ws3/72zXjPHb6DGmjoT2SVz6fnm3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084707;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FrC3taU4yKZZ1OmD/cq/hyMYcvwkgeVtQKYoK3LmINQ=;
	b=43iETK00sGwgUVBXTwS1WP/6IX2dWEwdCgt1FO9h3JveEmwwehMzkzxlNAyEPcDCvKOY
	 9dVDv8HuYl8Ak5Yz59GgIText6UhLVYadoCi2gwuA/IBeiiGSOUBJ2OTdf/GZtyZhOWZC
	 4lVW4DVAK/PCYCPCOydJTUo/AtpWnLeFSf/Q3M7l9tHQ5V1Ns75Gi6J2EoS4ni2XzyzCA
	 Nv97jp8FScbyDuDjdq8p7z4K5ksqSNvpA3lvTibhfLd5ewnAoHG5+NGcySdOHLq7o/1tA
	 N8GnGtDtbJOpAtRr3L4IcDPiauf/q/qHfnUA00j0+AiOLu0AcQ5fnc0nZk0XPPkgSXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=rgNIDPmu;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5572606A324
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 10:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5572606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=rgNIDPmu
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48dee593f18so1991526f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 02:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795084705; x=1795689505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FrC3taU4yKZZ1OmD/cq/hyMYcvwkgeVtQKYoK3LmINQ=;
        b=rgNIDPmujp2vgMR3qsqXZ3fVGj/Z531wsjRszTFbVUV7ExnNGgLy7gg8ItUyE6rg/6
         ob1K0sO3GUNT9OB3lxY4gc71GyDw4+CBhjki7LmKb0rDL7gsA0ujwcUNLTizJXdPRYsh
         tHmTipoNjELkah6buFGnA1frROxRY+WR3yA2/CnA85Nw+7dGFuYOI0jxJ97oMilJCA+6
         fR5vSfLiXKU+QzWNCQ5S6fLdgw38XrJAAC7vBXrJ+m7FyGiANj2atxrV14uOreOcO2yh
         n2zT6Co9cAMMMOgD5p84+ccGQkbFuZ5RDppnSNaYgrii/jG3UQIXvKpTBwuzhfyHsKf6
         kUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795084705; x=1795689505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FrC3taU4yKZZ1OmD/cq/hyMYcvwkgeVtQKYoK3LmINQ=;
        b=cHBS37KiybiJeDM3Fsf7Xe/71FTwuHK/K+VHICsXRmJxsTmDIay80OsdLJjsLQ6D/y
         StAhziFZjbqjgziUsZcr8E5uz2PTRpulnAMTuasZOIwfBLjoYyL0qfQdoeIyNTZp0zu9
         oF9NGIxDMd3iuI8sChz2fLT9/7oJGxyms+ouX6UgTsE8JMHgVpQDshFCRKVGrjKZlQNV
         RaLFIYMB+xWO/YE6+ubVV62ej6ClYThBLgyO5sdOZAlOtAecr1xROeMSXEaCrj9rAl0T
         FFOnhPYwcllHeOm+qWzWVGvG8WHg6akvSY3ZtlqdTKU6bwBZltMr24ImVQHjh4EnGCP2
         GsRA==
X-Forwarded-Encrypted: i=1; AL+hErGyJWS6zKsJA8+BcuJzgggMZ6VQNrm67RZiJBFWP7z7N81l+DoRqIYx13JjRlkDr/+pjuN7IGyx5FGI@vger.kernel.org
X-Gm-Message-State: APuU4Z9IM/lU3T/xjXeP0oA0Kzo5SjY5dOscLVENhRcSRPzRpHMtxFUb
	Hnky/dNW9MJ4jB8rFOmzRtgMyRu3eGyQKqjl2NHNLdoZ97XLoENvIsE+TLxBx2cd8riU
X-Gm-Gg: AZFdTZfrjzKTXKGe3tnRbeOnnpSQAr11OZjvYBiBQdWYZ9YFMFYScRNiS7G9cyQR2MV
	tUPSMdIUru2gU/x3BdWWN+sjbeNMCCK414gvshVPNLde74Widm7XiXjvXvayOdww82BO03WVaux
	VFbZtyd00eiAyEnrW7g76jFXfSARVGqd8N3lDC3IbVkr1a8D4bHvzGyA70GeykqkPj0LpaPYyaf
	kDegzZbITURH76R2H2WxmZAdSYTgsOCczrD6RaGzoB0u9W2+66VRi1dQVvvVi+X1bPWVdrSooID
	yvWRRrhgdoiqA0I6mrFC1LKzJ+lRkANvsepcvhNatzbreRZCDPodSNDQytbjujn7IbEQPNxFFag
	H1Nm3jJHjf3W8x617v59slqV15bgij4TJHLTZuWkSK0FvGQSIzZ1wcAYafin0P0KzEtICgshKF7
	sPFBudUeFmdieD6YR6TfCon+7RJZQuvso7X+W1Xr0jTrwpSRD/eZ4H+r08jMlx4DnNZmFQjZMr0
	h0xAzUpe/8BW9rJKcfZ+D3D4H5Z8aDDKUl6dzQieCQJq380HHfftbgD2cGSh4zEwXbFqUQzELnI
	mdOYeq1cfbe7DDAmw2MqjQDI0TgogMXnKCvJeEUj7DByy1OeJR/usf4IdqOFYnGpPsIl
X-Received: by 2002:a05:6000:4812:b0:491:49c2:3b3 with SMTP id ffacd0b85a97d-4a63bea7c57mr11463163f8f.51.1795084704978;
        Thu, 19 Nov 2026 02:38:24 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655f9f4a7sm10030927f8f.34.2026.11.19.02.38.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:38:24 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
X-Google-Original-From: RootSys GmbH Research <research@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	mike.michalo@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/4] ksmbd: reject plaintext requests on sessions that must be encrypted
Date: Thu, 19 Nov 2026 11:38:03 +0100
Message-ID: <20261119103805.29514-3-research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119103805.29514-1-research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at>
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

With "smb3 encryption = mandatory" ksmbd sets
SMB2_SESSION_FLAG_ENCRYPT_DATA in the SESSION_SETUP response of every
session that negotiated a cipher, so the client encrypts all further
requests. Nothing on the request path checks this, though: a plaintext
request on such a session is executed like an encrypted one. Since
sess->sign is cleared for these sessions, it does not even have to be
signed. The only encryption check on the request path is the one for
shares carrying KSMBD_SHARE_FLAG_ENCRYPT_DATA.

An attacker on the path can therefore inject plaintext, unsigned
requests into a session that both sides believe to be encrypted.
MS-SMB2 3.3.5.2.9 requires the server to fail such a request with
STATUS_ACCESS_DENIED.

Record in the session that it was told to encrypt and refuse
unencrypted requests on it.

Found with AI-assisted code review and testing.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: RootSys GmbH Research <research@rootsys.at>
---
 fs/smb/server/mgmt/user_session.h | 2 ++
 fs/smb/server/server.c            | 6 ++++++
 fs/smb/server/smb2pdu.c           | 8 ++++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 423f0a10315a..81960f3334b6 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -62,6 +62,8 @@ struct ksmbd_session {
 	/* signing was required at setup; sign is cleared with encryption */
 	bool				sign_required;
 	bool				enc;
+	/* the session was told to encrypt (SMB2_SESSION_FLAG_ENCRYPT_DATA) */
+	bool				enc_required;
 	bool				tearing_down;
 
 	int				state;
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 5d94a3683f7f..b7fa39200352 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -202,6 +202,12 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 		return SERVER_HANDLER_ABORT;
 	}
 
+	/* MS-SMB2 3.3.5.2.9: a session that must encrypt takes no plaintext */
+	if (work->sess && work->sess->enc_required && !work->encrypted) {
+		conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
+		return SERVER_HANDLER_ABORT;
+	}
+
 	signed_req = conn->ops->is_sign_req && conn->ops->is_sign_req(work, command);
 	/*
 	 * sess->sign is cleared once encryption is negotiated, even when the
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 29750970f8da..05af8f196b17 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2407,8 +2407,10 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 			!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		conn->ops->generate_encryptionkey(conn, sess);
 		sess->enc = true;
-		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION) {
 			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+			sess->enc_required = true;
+		}
 		/*
 		 * signing is disable if encryption is enable
 		 * on this session
@@ -2513,8 +2515,10 @@ static int krb5_authenticate(struct ksmbd_work *work,
 	    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		conn->ops->generate_encryptionkey(conn, sess);
 		sess->enc = true;
-		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION) {
 			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+			sess->enc_required = true;
+		}
 		sess->sign = false;
 	}
 
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792506975;
	b=Asu+PmZzWHswKYkPPhF9HQmYUezdDBpiI+Fn0lMKLh/TPZPXeCwvgHYic5W6wKcD8YO+
	 aC/HJCcd+8FgGILqbC4bDMJdq7O+fSLhWvwA9tvwTGIpu/GtznfS9DhAZ7AuQAssf31eY
	 HrGIBReq+rgzxg8h4WCPtBqI1WNjfrn7I+rgy9n+J3nXHAgxQhnBBJxctKf8a9XazIytS
	 lY5ob3s6y56VsY9pdz0IOWf6aAlMNE7dA7G6c1TWGKWevUqBg0nKl56HfKnm71vCiR3lJ
	 4Ypg80eBwsgV8JMFuuE8HEItUuoXGTrt8C6Pvijo8JQbWEBoDHmSBfLLjt191s00wfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506975;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=58EM4/eUCWXYKgAAv92oJHvih90q+2lSB+oZ8grsLBc=;
	b=F5agD8I8K2NvXFORmO2S0J/TiXo0E2VosMp5QcdiL16pBDavBbyW8ZrB41ANclVyF+JZ
	 ae2g3Wl4jh7uGJsPzpZg4rJvmMayCFaznN+piE/54ixUPGbQkRD/0Xv2tjz2CCA4hAVpI
	 TUMvPPmBA95eN2sOwHCdoiilFLh7C32HEXlq4+/WW8AIf/h4Yfxe0L2qzXECBW7MMRPAS
	 xWtf3k+CYTAyMrSK37BGnpmoQf7e4yofUIyzW4cr2ovCWMqAeKAAkRaqLuQ6Wc9l5nkcY
	 AwjAgai5+i/SYMUBU3PO9333KcKLiaMoxw8+kDbqRZFDHoUSz985clWvhC6w68mMSeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hzikflMb;
	arc=none smtp.remote-ip=209.85.167.52
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF27606A31B
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 14:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CF27606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hzikflMb
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bb7ad2de6bso445864e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 07:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792506973; x=1793111773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=58EM4/eUCWXYKgAAv92oJHvih90q+2lSB+oZ8grsLBc=;
        b=hzikflMbvGyvPewqIHQOQwI6rPjfJ/e49GZ4qyA17j/LdJv/DbAUrWuoUJruBoy8K6
         jQ99uUB6pWQYRHTECJhlkUqljAohk7dXUl8o0JFLO/q5ULWB/J/xkIH8uvZY2gczuagt
         d/mWictAjAbyi4RDe/DGsFTKBXu+DuGx2P9u9SNohqEsGewqFf0RREvUl0rKi+MIHlwe
         hY82TTn4aYiSplQUDufcdVItP0/nJ78qdnsBPXRwai2JFCBeGuN8MYNgUSIkhQvqnvBn
         VCnxbABzYQRXUtTzPf6Y/pZXraXN2hgoR4+XE9xSm1gwrHh/5j6ClbEUEC4LMvIpgVMK
         G+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792506973; x=1793111773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=58EM4/eUCWXYKgAAv92oJHvih90q+2lSB+oZ8grsLBc=;
        b=GfUdu1WyA7r1FndRqalmG2Ig++L7jCr2G3P+GQMc0UuF5vLdJ3EBg4cpEmXRgdYGxm
         82PkNbgDHquv3YgW5LUE5RtCU7zUEDvf244j8fgWWSFFKEDMaPqL9YjqAk0J7ktGTkmS
         3s877VVvxoo+QIh4OqboY6xnmol7QrdV1s8AFuP2Z/zbKEHSCEtDftGYiAQWlOsKGApV
         ZGUHyja7hjBpU/dDw4ZkxW9Mopx/awnHdD7aKQBYLmniBrXjrY9A6C8Se7HA5NgZxPsD
         jvyXBUPUxm2uESzkE5NlGvModslt0n+iP0BQ/7lTnRMCdpAjNKVHpUlCBxlQmtgyX2NB
         nIrQ==
X-Forwarded-Encrypted: i=1; AKwUvBy3HU1dp6+Pbt68Na+majKtM9yI7B7WZkVxV7Eh2xFXbHIbaIvevJB+ofnAjhH6HzwYuFX1GDbna+Ns@vger.kernel.org
X-Gm-Message-State: AFq9FYK8EtiaGBDVH6hMn4T31dmGdFEdSCegY/68LnUmhc4E4+Z48KIv
	yi035sN7oTZQMJNcC4KSpK9V7RZAMHzl6nbhckNVQw15m3etV+MIN+kM
X-Gm-Gg: AYBFou1bMTgKhOnYvUZnOxygyaZapwRj9alK0nYJcNuiC7Bj4c+nl15TW7PTRMomanF
	ahaqsIuTLcTU6hkYpT+WuiCyqp7ro8kUGRTFg/4y3ACkaoFnicfZTy2qjq/oR8wi5ha0dziNVaw
	JzZxRZgCxqYGflKJsZC4ZihfrqlggN6i4M1tYIk7SqC/JhY/kRaZvK62DUNza11MS/v/Lbuhp2U
	rqKVT4kpNP9vWPL9bGShaFXaQBuoMLvO8p8f6YpFVBfpxdmytsOdh1fUSAbz25HQ34VB7ucg7Wq
	iwSA2p6DLdwjCx5bHIjJvGmQIM6lfCbMOEzBjXXkV7/WsppGmvtZqUr4VdYCRyqvJ/2LLbce6if
	EaPKUTIth1FdNC8ggC5P0mN3OTJL0Nxh0cSTkKHUb1CLsNzZCTZg5pGfKEQRfp+dGrzaImvLOjv
	/uWBXoUP0r9f+3Ji36hWbKw6idTkFYQx41KKzpe4bK35JkhLxdDPEQq8LpIgz+NK5S390xWkq4R
	FZAGQUItrTD
X-Received: by 2002:a05:6512:3e0e:b0:5bc:44d5:89e1 with SMTP id 2adb3069b0e04-5be5099bb10mr4092882e87.0.1792506972467;
        Tue, 20 Oct 2026 07:36:12 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ab16d7ddd0sm33890831fa.4.2026.10.20.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:36:12 -0700 (PDT)
From: Dmitriy Okunev <dokunevdmitriy@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: lvc-project@linuxtesting.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Steve French <stfrench@microsoft.com>,
	Ze Tan <tanze@kylinos.cn>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 3/3] ksmbd: do not release session id 0 on init failure
Date: Tue, 20 Oct 2026 17:35:53 +0300
Message-ID: <20261020143553.105014-3-dokunevdmitriy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020143553.105014-1-dokunevdmitriy@gmail.com>
References: <20261020143553.105014-1-dokunevdmitriy@gmail.com>
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

When __session_create() fails before __init_smb2_session() assigns an
id, sess->id remains 0 because the session was allocated with kzalloc.
ksmbd_session_destroy() then calls ksmbd_release_id(&session_ida,
sess->id), and since ida_alloc_min() has not yet been called,
ida_free(ida, 0) triggers:

  ida_free called for id=0 which is not allocated.
  WARNING: lib/idr.c:594 at ida_free+0x18c/0x250
  ...
  ksmbd_release_id+0xd/0x10
  ksmbd_session_destroy+0x2d5/0x380
  ksmbd_smb2_session_create+0x131/0x160
  ...

Add a check for sess->id > 0  before  the release,
since ids are allocated starting from 1
(ida_alloc_min(ida,1,...)).

Found by Linux Verification Center (linuxtesting.org).

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
---
 fs/smb/server/mgmt/user_session.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 386c8629e134..d46dc7b2c562 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -409,7 +409,8 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	ksmbd_session_rpc_clear_list(sess);
 	free_channel_list(sess);
 	kfree_sensitive(sess->Preauth_HashValue);
-	ksmbd_release_id(&session_ida, sess->id);
+	if (sess->id > 0)
+		ksmbd_release_id(&session_ida, sess->id);
 	ida_destroy(&sess->tree_conn_ida);
 	kfree_sensitive(sess);
 }
-- 
2.53.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792583646;
	b=rfH2ZulVgghcvNlSKG4DC8C9VAG3Ol/nauYat6xh2EofKWZwraKsHDMSckmPcgX+Rj1v
	 h3k+kqN+bgpAkf2adPXoP4Ae5+VQ2X1ypyTPKUbRe0SPNoV4Vt2LamUiyRI4p6GKy6shP
	 6Np0SxWNISAt43w9wBsvpnbbrhyjxqczmOwvZy0lbNH8SiPgkRnB+paxPzzTo2xfFFBM/
	 bAnMNj2bY85LEVcDAvR/6pOHhISH8XKm5/pdqbX22Ler2Iag9rHAFIVwBR5tQNAIggiV3
	 +ca2PukdIvEqG2Mrq6IEtE/4t7l/CvY7U5QuGJSN0arTLeCJ7Jo2jhiHwEwsLsgeeOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792583646;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=khbtvnCt8sXvEtX9fI1U36fFGjo7tER69Bnnl50Wz8Y=;
	b=5Vb+dmoS/EhoR/iqidyM4hp8fhwwMesANJlt9O2PQKQB3cSujnRGQSgza0xix8Md8Bm+
	 Ta1ZYDBFQhbJ0UUZTa/EfYy8NnuFIPE4YpnmauJElyFW/NfvF5SbIWq1jBcNLTBxW3YU2
	 dPJZQUgzrRN+Wrob8OIZ1Pe/Js9OslHICup9TN5sKA5Dy7/n7EN8Hr5+EWEiyDkr7Wa49
	 HYkY+8prTOnEiLXn4VXwRMPlriI9GUbgwlL5DRGvq1x106k5PVYj1q6mNjR+7KyWMEFPj
	 PGxIb/WsRnbGZXEknLbF6lLluFL9XE9nNOvWjum5UgyWuaZ7LorfVPbaHzHxcW3XisQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fQaHtPW3;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54A2606A338
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 11:54:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C54A2606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fQaHtPW3
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c38ac26cc5dso83436266b.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 04:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792583644; x=1793188444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=khbtvnCt8sXvEtX9fI1U36fFGjo7tER69Bnnl50Wz8Y=;
        b=fQaHtPW35SAPAX1ZgwjLawoatDbVxOsx2Nrww27dOU+l9jUgTNw2h4p0Ee0CHlhmld
         M3g4uY5JL08XETrxU++gX9/QYc9dUU+r/NKHUwTRuwvoBGOwUiRYHFONMNa903UmTl0a
         h2/HGLM1zng7GBtJpaxFGv+lGtmg4GNqeL/u1eY+iEqkaYStQtnJmScUNRl69GmgJaVX
         2CxYjzTOqliW1EE7znJ43U86Xo+rAEOHi2K+a6qXukSxWKvQZeE17k5uhhN9zhcHat7k
         MNckSt/t1InXV4UY87WOPesjJYIlwLwNrbWgMPoPGO66UzZsLu7sndNbfyNKnoXqDd7B
         ViOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792583644; x=1793188444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=khbtvnCt8sXvEtX9fI1U36fFGjo7tER69Bnnl50Wz8Y=;
        b=dRNevNeGyWf+n7HhiN8avGQSkv7zuFiTytglUmHMIyUZ7wyT3sPuJFdmKjyJeQeiRP
         vgAa016wATXQLPyQWgb/Dj/geJpND/unHv3930RjCbpcf8F+zcZPev8kY/KdRsTZrC0Y
         0HMERpAksaRFVtEoiPPHMPcChLgGDkBksiKx6ENLZWNBa8DJWLtZ9Q9r1PthcxIN7xGa
         yk70HRerqkvz82bskPjZ8HJxso/UtVTWjLuXIGz4RzFeU+T1nLugPAHzZRIJeCDlyzmc
         9DTzl89i4dUX8OhGhbJdM6q0XJHM8mFg5S7U3/lWB/27hf6dGgz4D/QZZRz78XlnfcQr
         aI7w==
X-Forwarded-Encrypted: i=1; AKwUvBw48c2W9BvsDRgxdmmmkb04VgnF/1iqo8UhAsqW+QGuH7bqekjTYalxgWuqkEj/emk9QcnBmIdPYXa+@vger.kernel.org
X-Gm-Message-State: AFq9FYLhfxi8l9L4Xrfg+GfmUo1jgtQej8JKrSJWtPRS9ajkRoDUMdOW
	dQFv1TEo5QtW/TD3Ert6xeUVpm5E23l+V3upHKHIpB6EZW+rd2jRAN+x
X-Gm-Gg: AYBFou2TFk1RJ/nnvjFUi5Cn16dDz5uAeYHZ2AlMGCdYisCzIhbPNuTIL+DraQb9mlp
	aZIbKDVj5Aty1xXaAKgaFHSj+LWIL4Gk0ut7xRDJ1rkBdwJPMCsyL4TbH3/bJN5kiqgYqi6RF5A
	K6z4ldOe0SjMnajzLLrRJdXVkEB9zKmfbVVIARWn84xohz4S3ZdttKq1gcZSsUnC6R79cZZe2T1
	kRh7Vf8k0OjeWSZwPNeiQS4aHK7fn+9G0QGHfoILM7Pj5YB+TPEVZtj2+yG/mDp6yqFm1duPy52
	Sygf5KGzrQkwo2cZJlEJoeG8dKzdDyOWrdUKDaY0rhk+MaYfCA2hL4wGPFg917awhajfzzDXbFx
	n5U5/yn65AEUPvRcsAsYHxK3ZZhhZjM9cubLlkbWZDRSNGLA6Op3Lz9Sjj0xISXyjcv1kHZqB+q
	hI83ZyllD6a/U+IBQBZzvPNa8NWuTD8+Xn+V7GMg57MO9uxSxsOc9wKK0VppUg9LLsGPIwB/w6F
	x4ZAXhZZh4StKXBCfnEBE/c2Csa7CFX5Z4EITsZsb2kXHyhZobUCRyQU5m5HhnTMdiIMxdWhbVr
	ofnnhuVh7//HTaYb77aCpLCccHeqQ6UZ5iTR8easBncuOvuLiSKB80TkxlPU52HRpp4K
X-Received: by 2002:a17:907:868c:b0:c29:f5d8:9c73 with SMTP id a640c23a62f3a-c467979bbffmr167724266b.34.1792583643843;
        Wed, 21 Oct 2026 04:54:03 -0700 (PDT)
Received: from wlan-199066.nbw.tue.nl (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4678f77ac4sm69316066b.28.2026.10.21.04.54.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 04:54:03 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: restore Kerberos logins with released ksmbd-tools
Date: Wed, 21 Oct 2026 13:54:00 +0200
Message-ID: <20261021115400.30885-1-mike.michalo@gmail.com>
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

Commit a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets
expire") added a __u64 session_expiry field to struct
ksmbd_spnego_authen_response, growing it from 156 to 168 bytes.
ipc_validate_msg() requires the response to have exactly that size, so
the 156-byte response of every released ksmbd-tools, up to 3.5.7, is
dropped and Kerberos session setup fails with STATUS_LOGON_FAILURE.
The other way round, kernels without that commit, including the stable
trees, drop the 168-byte response of current ksmbd-tools master, and
ksmbd-tools has no way to tell which layout a kernel expects.

Pass the expiry in the reserved area of the embedded struct
ksmbd_login_response instead. ksmbd-tools releases with that area
(3.4.4 and later) allocate the response zeroed and never write to it,
so they send an expiry of 0, which ksmbd already treats as no expiry.
The response is 156 bytes again, so it works with those releases, and
every kernel also accepts a response that sets the expiry. Use two
__u32 halves, as the reserved area is only 4-byte aligned.

Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets expire")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8xCgtA42XUkSsAeg@mail.gmail.com/
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
The matching ksmbd-tools change (struct layout and mountd/worker.c)
will follow as a pull request.

Tested with a local MIT KDC and smbclient --use-kerberos=required:

                    3.5.7      master     master + tools change
  7.2               login OK   fails      login OK
  7.3               fails      login OK   fails
  7.3 + this patch  login OK   fails      login OK

With this patch and the tools change, smbtorture smb2.session over
Kerberos (including expire1n/1s/1e, expire2s/2e and expire_disconnect)
and the 190 smbtorture tests run by the ksmbd CI over NTLM give the same
results as 7.3 with ksmbd-tools master, with no kernel warnings. NTLM
logins also work with 3.5.7. A test-only mountd that overrides the
expiry (including values above 2^32), the response size and the length
fields found no wrong session expiry and no kernel warnings in 313
logins.

Current ksmbd-tools master needs the tools change to work with this
patch. If you'd rather the kernel also kept accepting the 168-byte
layout, I can add that in a v2. Only tested with smbclient and
smbtorture on x86_64.

 fs/smb/server/auth.c          | 3 ++-
 fs/smb/server/ksmbd_netlink.h | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 1b24eb3f3998..8e5a1b10db6a 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -464,7 +464,8 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 	memcpy(out_blob, resp->payload + resp->session_key_len,
 	       resp->spnego_blob_len);
 	*out_len = resp->spnego_blob_len;
-	sess->kerberos_expiry = resp->session_expiry;
+	sess->kerberos_expiry = (u64)resp->login_response.session_expiry_hi << 32 |
+				resp->login_response.session_expiry_lo;
 	retval = 0;
 out:
 	kvfree_sensitive(resp, sizeof(*resp) + resp->session_key_len +
diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 2673522c76bc..fc6af757e45e 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -148,7 +148,9 @@ struct ksmbd_login_response {
 	__u16	status;
 	__u16	hash_sz;			/* hash size */
 	__s8	hash[KSMBD_REQ_MAX_HASH_SZ];	/* password hash */
-	__u32	reserved[16];			/* Reserved room */
+	__u32	session_expiry_lo;	/* Kerberos ticket expiry, SPNEGO only */
+	__u32	session_expiry_hi;
+	__u32	reserved[14];			/* Reserved room */
 };
 
 /*
@@ -286,7 +288,6 @@ struct ksmbd_spnego_authen_response {
 				  * stored in SecurityBuffer of SMB2 SESSION
 				  * SETUP response
 				  */
-	__u64	session_expiry;	/* Kerberos ticket expiry time */
 	__u8	payload[]; /* session key + AP_REP */
 };
 
-- 
2.56.0


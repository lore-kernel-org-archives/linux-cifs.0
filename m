Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA398F7D;
	Tue, 15 Apr 2025 17:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744738886; cv=none; b=TJN8lI9B42oWZzqGHHrlg1fd9dQ1L1SPp5U8nVcOj1/zqyQ1Z0s1NPUrrj59lz4AX5GFw4VarUU1anapQjCt2ZuLka4PMWmOLH1FeVG4zM7QcUjCZm5MKrJdvg00RAtbdveg/twhc7Zc2jBJfelzdO1AClT5CYHxouyNBacHjXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744738886; c=relaxed/simple;
	bh=R+u7Raqr1wH47gNA4jfCVwciRYoRGjsSb+B2q9lx440=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TwlCcCYyuqmNKJH+df6p6lLEYUer+l9pZqceE1YT1ALwW54SIOyLKFdm22cRfNWmURyXlbNV9+uauSC2TZB7BEK355filiKqNahXnowN+y0dlZ4xybhb+2/06OD4KfIt2MDDFlMM/YqEweDvVFHa/+qQs5MbHiaLqQT/vbQVBgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VH+9LVFV; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VH+9LVFV"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d0782d787so42504415e9.0;
        Tue, 15 Apr 2025 10:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744738883; x=1745343683; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cTXPAi6MOk7dtbnvu8pX0TutnX5nRreaYjpyTtvIq2M=;
        b=VH+9LVFVapeL2OI/QkB7PszceljfwGJpqCsWBvU42E09G0F8mgJnk1F+KcCWbgzSRi
         +nZIy1RAApIzzlSAHRzefNijUKtvu/fot5zl4LZOfNyKZ7R8VLLB0V4ldWBUyd2Urhlq
         USWZY0aYv0CKh/4ORBmTj2KP1j+Ei4pSI3Pcj6jBrBx8lxkkqsh+nb6ELboLlFcm3zDH
         OGlOHQFR1tWSi7IYpUyKtakb24p9hGO5rP6vG6H49J4fWeCJtXSbONG9mtN0DX0Rqyeu
         5MaIrhZLaaAf39sX1oKFXl9XgLmvkFYF0CuHu9s55+3vYj5Bsv+S0QPo8v0dReA2csov
         I4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744738883; x=1745343683;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTXPAi6MOk7dtbnvu8pX0TutnX5nRreaYjpyTtvIq2M=;
        b=RS3hTU0ZKItCcyUauObpwICfExxyZp6gTWxjlPHRYUZvEmtEbrwoYBVcI+w3g1i625
         KkTMFsTgJYUmH3MYsMZDLfWwz182rkJpJVDfQ1M/RsDGPMkVVdk4fdUzowQXC2Lt32Ut
         259rBhBQu0yhq7NQmj8dHesflA2dK/mbqZb6wkE4VAKWuI5WVkYjDNhUq6WF0hofN1ld
         /f+D/2Mr50CHPyqNKnqF+6YSnWrfjPIUACiWsdlIpi5Bi59OU3IZwjT7d549k8XXQ1oD
         /P+QFLPbij0Nuy0AapvjgFo6guYYmWMFqU3rlYq9cetjnoSNzXKAcd0QZB3YWCQoNu/x
         viTA==
X-Forwarded-Encrypted: i=1; AJvYcCVwEnaRKVT0vu+OZn/5zmqnfd3lCC4fJG6+RUbNttJ4ffIbhvhcX4btkiIuE02Ihta+t/kXAXGCI96J@vger.kernel.org, AJvYcCXI9PlRwEjyba0XzhN+ZVGguyxEgR1anwkLxM8hyY4P+SPP99lxH4/iVpdK4h5YQovnStk6vk3lGTXWFkT+@vger.kernel.org
X-Gm-Message-State: AOJu0YyVivRZIsktIyR0t51JWIf23OlGLNZ9pbNinDuQESEPuQcYCY+p
	R3IHyIOnAfGxBre6SHrc/hNJhfRbsMX1iJrc4LgoNOPT/pI2COJh
X-Gm-Gg: ASbGncuHWBUUHX6/dAvGJlU4E12CgRETDHcsH3kEcD0HPqLQRAW+p32JAfd9wWnJgfU
	CQtXMZMMZBP2CXu76s7K8vURASxlnnPFu85ugwENuf2s07xNOXXfyhiP4gczAce7Rh2Z7NxIDT1
	fnuBMFEBwUd5kTp2M1sH7LNtNHyWygVtmhy/QW4VbnAJDhHn+xgLE4RrFy6qbZ9c7VHeEmf2mNn
	2m4iS4gTLhEbGzcHAhB//ZMKeLpeE9kE9yNYbQA2nuCrHe88wIEcamcgis7cjgbwnyW0PtUu7C4
	RSgqHzh2xKEyzoR1SQay66xvHFJ8vg==
X-Google-Smtp-Source: AGHT+IFFkHczMfWUBryQoEPMfRR49gHduMJO8eujnvBaQZWraQ8x1TmZx7EfHqV2ufIBghk74M0ZZA==
X-Received: by 2002:a5d:64e3:0:b0:39d:724f:a8a0 with SMTP id ffacd0b85a97d-39ee2763a76mr338132f8f.58.1744738882892;
        Tue, 15 Apr 2025 10:41:22 -0700 (PDT)
Received: from pc ([165.51.55.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eaf44572csm15473451f8f.90.2025.04.15.10.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 10:41:22 -0700 (PDT)
Date: Tue, 15 Apr 2025 18:41:19 +0100
From: Salah Triki <salah.triki@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: salah.triki@gmail.com
Subject: [PATCH v2] smb: server: smb2pdu: check return value of xa_store()
Message-ID: <Z_6aP_ZpEpxA5pfS@pc>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

xa_store() may fail so check its return value and return error code if
error occurred.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
Change in v2:
   - Free chann before returning the error.

 fs/smb/server/smb2pdu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d24d95d15d87..2219dc8e6740 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1445,7 +1445,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
-	struct channel *chann = NULL;
+	struct channel *chann = NULL, *old;
 	struct ksmbd_user *user;
 	u64 prev_id;
 	int sz, rc;
@@ -1557,7 +1557,10 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
-			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, KSMBD_DEFAULT_GFP);
+			old = xa_store(&sess->ksmbd_chann_list, (long)conn, chann,
+					KSMBD_DEFAULT_GFP);
+			if (xa_is_err(old))
+				goto free_channel;
 		}
 	}
 
@@ -1574,6 +1577,10 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 		return -ENOENT;
 	}
 	return 0;
+
+free_channel:
+	kfree(chann);
+	return xa_err(old);
 }
 
 #ifdef CONFIG_SMB_SERVER_KERBEROS5
-- 
2.43.0


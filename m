Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A1A289359;
	Mon, 14 Apr 2025 19:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744658703; cv=none; b=XTSl7lNJj7wpUHRdluLi2fawWxGocC9nGyzJ3YpfnIRQpcQJRbCRI4nwDk6fwmUuSAvWODFIzBq0Jt083sh4NoQ7Xl0bitABSflJdN1YWpfJT5BcfMikmEqRpICjNK3BXehBkWB3fSeltExIRXvcaSdCp7wtUUIE07QlIHeOPi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744658703; c=relaxed/simple;
	bh=n+JXe74/pWa3h8+FclaTGR7fTe2skjHHq6XttvEz1o4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=k4BpHJRbhj3pJikmpF4m51pV7mbpyGcRGEo28I7zia380b6Xh0ArLMnkBanzJYaYhaW65Zr7YLMeHe4BcthquiqwnNa2Dg1QegZCiLF92pxW2u+OAphbfAMT7wjdS03qDHPbNTzRfmv9bAi6L0PLPlee14tB7HHmSvKnuqP0rnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MHhl3WxM; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHhl3WxM"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39ac9aea656so4654990f8f.3;
        Mon, 14 Apr 2025 12:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744658700; x=1745263500; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mkoMwn5nKL5Ff2HZW5CyqilTcEtTEB1CBWPccvd+3ZE=;
        b=MHhl3WxMQwgt/kb9BapRYnH5IfUdAnQNdD2ZU2UN/zvbOa/L/XomOppNB++K0F/uFn
         KH4Tsgnv3MKTkq+41trRC42wG9TtAS6mMjShl4R27ElR2GhcIxGPC0clKRZHMb4SHjE5
         XkFW8JyZDbW3rd/th3rGMFBNy8sY+viX/iDPhtxcUdJZyOLkejlRZqU964VVLwr0AZFt
         6Xo4my60hSMfzTjAVMM/Hsu9/Pa8ZZZKgJUhAT5neKNmPsW77KWVQCJCQAV5gMP3mBr/
         2armLa+2gUvXUrNYCdViF+EPB46OBXw/wyaHFzMEl9luMKcR9LV/zAIkmsMD0CNhvcIr
         P/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744658700; x=1745263500;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mkoMwn5nKL5Ff2HZW5CyqilTcEtTEB1CBWPccvd+3ZE=;
        b=r2w8c6AQbLb16GOaFSlN24W1ppL3U7CR3qI28BerJxYiC92XSBURJtcWFNm59SZdRn
         gX34iIqxTxa3eMDneJBJXt4E2ykUsZ8U1AhJkSeaLnuzaUhwggBJ0/BPmdxMcvp0+vRe
         JQF1k+WGgv1e4KsIKoqdo8TG56DiKvGue3Srx2Cc2D10a/ZAKzzJGvveHGiejYb9FPE2
         bMVxdCCT7hbqnDfWHvmx5qEbMtK0Cl7adkOx6YdFyGzhdQUM6c5+07Ze09GQstfZ359o
         m4vpbJSFGchH1xWJ2RzhXmsbfQng3ptGQOZf9wgUiccdd+d6pNIc11qY97kza3NqlQZt
         O6WA==
X-Forwarded-Encrypted: i=1; AJvYcCVKaAsZn5D+7bTiDWJ+iKXjPUPnRiENUnZ0vGPs+Jn6hm4oEaEpygzSoycfsZmCtwPUwuW+tPSvEZU2@vger.kernel.org, AJvYcCVrkNtJdzwuLhecfP06OGV7XO4w94+PUZTLo0yPVexcuo4AviHIA7YPrz5zh9RTslj3sINQsylKF2kh1Ivs@vger.kernel.org
X-Gm-Message-State: AOJu0YzvDLDEdiShYfg9JT5KgU9wLPQ/2T7d6422gOCQCvUBgMqjR7IO
	f/GADcKfaBnEbOQ0h2TgFPwmv2rQKpzjNpvmG/bQ2BRGPftsfSrX
X-Gm-Gg: ASbGnct9YYhDmlQBCtba3s+rOi6adCYKZbVOpHS8b4ujynIwrpFWMBsZ8RmtQH2WlEn
	o1JYNtD6i3wxd5LHKKIssSdX2AcyOlVh2excjNutGmG61XaEJZnrzYy6YLQAMP5aG/Uxq5EjFtw
	hzw7x7EuqvO2mrdV+JFkDPCTjxr1O3V8Ru2TYZhS8Gb15pAfRPRTazbUi0/1WfeESf41AcUhoke
	fxBsC1+YD4+Lke0UDG8FwsUHLu4iIa1JUUUi/c6/2HO+3PVmDtknkt2y48NOBjVLGw9otKTrxAV
	+Yos932eyvmjPuU8aD7AyGnhDAwT0A==
X-Google-Smtp-Source: AGHT+IHRH5R+1QQWktZEz7kN+KXOYE1/H/jAFM/d0Au5By8OXDCi8qkPgDY390IcEISDH432vkev+g==
X-Received: by 2002:a5d:5f42:0:b0:38f:39e5:6b5d with SMTP id ffacd0b85a97d-39eaaed20d3mr10917629f8f.44.1744658700146;
        Mon, 14 Apr 2025 12:25:00 -0700 (PDT)
Received: from pc ([196.235.8.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2338dc13sm191775795e9.3.2025.04.14.12.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 12:24:59 -0700 (PDT)
Date: Mon, 14 Apr 2025 20:24:55 +0100
From: Salah Triki <salah.triki@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: salah.triki@gmail.com
Subject: [PATCH] smb: server: smb2pdu: check return value of xa_store()
Message-ID: <Z_1hB9GQL_Y7IAdA@pc>
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
 fs/smb/server/smb2pdu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d24d95d15d87..e32f8910e892 100644
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
+				return xa_err(old);
 		}
 	}
 
-- 
2.43.0


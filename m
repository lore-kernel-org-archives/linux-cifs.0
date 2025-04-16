Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4918217F2E;
	Wed, 16 Apr 2025 19:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744831594; cv=none; b=sOFXSqKOZ+sgLnEZGzYDR962LtorV+Cw+brkfWxEGr/JCRgdOqb3CwJOTM04qTV+3MYShvnkOlgN/aFfSmSPbK5mK1BGTp0+SpSwTljN6PS0HjEXhWK5Y4bAdsoiEbJutc+TdlQkQqpjPLRNdoEIR3fQL8S7zWvRiHqA0RfWojY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744831594; c=relaxed/simple;
	bh=TiJzWfUpw/4ebGzHwaZtZfb1VMMky0QpqODDkiJKXU4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=f7XimDNrtvrYoJGZb0XhTPhXMpxHeeK6CCvYwcJmPQGFvewbtsggPpddwrznYEUAeFQ/sW4cbZNW0t1Tgr3GMYGtvnclRy+CpqEKTjuamGVD0cXAjnkp+qQhrOkMxVPnDPdcfGUhdU7S7ck2RrbODTowwCS6W3KqI96dl8LZLyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3EZlFWQ; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3EZlFWQ"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaecf50578eso1218710266b.2;
        Wed, 16 Apr 2025 12:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744831590; x=1745436390; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2dDQnhAwBp0NzGo+fb5KQgNem9PsfVR7kbGDuplWRag=;
        b=A3EZlFWQ/RYOgT+LnpyugySjGajJIqLJ6TZOSoj8g2tU61/ZS/dxL/b7+76tctkHB6
         zdUja9ZhTgeQ6A1wWuT4RjipOOdyBD8l3gRZYLm6eoORXzBQtzkJ/ks2s/fuu4KZNEQZ
         7k5voUMt1mZvh4eWKmwh7uiXrobN64he0tVG4fRU5aJjIVArgRZhBmaz2ARrx3rNRBwZ
         2zTxUcpVnayDxWLk4IM5ssf5a+ybMgBJyemz22aWh41giTZs3UjG1DTPSylLAVvlWvB2
         uRC7eutby1GSi0GyzsMOwyxE47gASNelXg14TI9BpKvmZkUpRJwkamZOdfC1Tk4u8S3j
         4SSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744831590; x=1745436390;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2dDQnhAwBp0NzGo+fb5KQgNem9PsfVR7kbGDuplWRag=;
        b=Lr8XZc6Ro5IXsUYxUOSD9UiPUvZoK1KWhivr3G/O6Pa93WZWww/62/kRTe/zyZW6X2
         tW20pC4WaKIzdIRFWk8wigvVgvuPxbV7fxnKIM2F0kUzf/YntUwSWpXbIQLvppGyA9/W
         ga0jljhUrvUsYK5x1yGSzcc/zw9cWEKX7rDhMptHPKZWlQNG4JQ/5Jyqz9vPu/xvW7Zo
         +zTmaZ4tWRcsniZ3n7Hvx7QS3sPGbDfKEPmM6/e2eIFGD9U2PA5FjYp3BKGgcR9tGbmc
         z4JPW/iUIyN8Z9DAFVRcCIXFZBzSysAuT4ROcA2eIOx+uolIAWOSrK1mmBMYyjiTtOAv
         Lq0g==
X-Forwarded-Encrypted: i=1; AJvYcCWeAw6awxgPNWDwQ8OUq1eM8mTpjcwPGr9yNIANlmWgjkslsIVq5BYL1NjuYzAzuxuec8XSye4Y/2Hx4liD@vger.kernel.org, AJvYcCXtfnj3CzlJlZXbQuOlxrYYXyBrM/k7oFgwLsaVG5xFP/itP93iOkLFIeOyEuB8IK2l7TJlQLJ6JJB7@vger.kernel.org
X-Gm-Message-State: AOJu0YznpBZ2BTDQaxdCuOcE8al8FrxxYxzk0MI4LJcRkMtrAPvrymal
	SuL1rUqkHJxLVAgYeGW6mtk3NMnUqMTT5V5JtMR0/r79p2/W8Q5b
X-Gm-Gg: ASbGncte5MNvDJw41qbgPKglvhA7siXJ7e8s3XnQQSJ7OQCdraziZXr+Te0wFDvAqg4
	/zk+e+gOeifvhXs6/5uRea3exY/tRby7lsuPzm78cQAFWmzEqApK8OJiFUxGZDvVO2HbJ1aZx+D
	RNjgVsUx4Cqq0YoOAA5KDDE2VEi9//jNWXn3daZIc20DCxtH3YSx723I2lSoAF5Mg18irMwKd1P
	oEq5woxsaHSTtwKn6AtJcCEVsv1S0OzRl+6TPyAE0oykm/gc9rZ077hP5igal2i6dWjjeIODCSd
	mMbMenopE4Nflbw956KnylyWzTcX0Q==
X-Google-Smtp-Source: AGHT+IE01Fh4Pm4fSoPbdB7vv0HxWoF1V3rinXzKkN2fZo5o7aemEIyVOSA0U/L8gECrZ+xDY2Va6w==
X-Received: by 2002:a17:907:1c89:b0:aca:b720:f158 with SMTP id a640c23a62f3a-acb428ea989mr236982366b.13.1744831589717;
        Wed, 16 Apr 2025 12:26:29 -0700 (PDT)
Received: from pc ([165.51.118.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3cd61b4dsm177512566b.23.2025.04.16.12.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 12:26:29 -0700 (PDT)
Date: Wed, 16 Apr 2025 20:26:25 +0100
From: Salah Triki <salah.triki@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: salah.triki@gmail.com
Subject: [PATCH v3] smb: server: smb2pdu: check return value of xa_store()
Message-ID: <aAAEYYktAh0SOKzb@pc>
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
Change in v3:
   - Replace goto free_chann by kfree(chann) and return xa_err(old).

 fs/smb/server/smb2pdu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d24d95d15d87..4c3c092d8771 100644
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
@@ -1557,7 +1557,12 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
-			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, KSMBD_DEFAULT_GFP);
+			old = xa_store(&sess->ksmbd_chann_list, (long)conn, chann,
+					KSMBD_DEFAULT_GFP);
+			if (xa_is_err(old)) {
+				kfree(chann);
+				return xa_err(old);
+			}
 		}
 	}
 
-- 
2.43.0


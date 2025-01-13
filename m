Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E3B230D38
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jan 2025 06:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736749075; cv=none; b=nblvfajDVgWCGyR+StohgUrn4ATMfupyFR4KQCJGeyhVCukimMOwUKyhFsqWNc3UD5CNbm93tPqII0hzjHeqcChw3j3FJhfNAkEmuqYouLYR2R48rtJhkAPksNVlcrG7z/Q7H95PaK/ErovVK+ZNgOEHAhhII9/ePdMouZ7//mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736749075; c=relaxed/simple;
	bh=2hyLyxqgEQuOFRPPIkldlLRoQ2D7GpEe+bWnftksFps=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=loJymYLBbTyA2Cd1gW22lHDZxcHAVeICpATbfl3E+CZ1eYGOyMUNfgkV3XvZ/GccqycmNhm5jhBIaV/fM71LAa3uT8K1ZDxwd/mZfF342VI/z2loShrIn4R2UqgoQjsn/lipwwmYj7S5pK4cT/s42E1MkknP87GA4bo79kEyHmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ify6F0j4; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ify6F0j4"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d3d14336f0so6841164a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 12 Jan 2025 22:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736749072; x=1737353872; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MkXwd+QL2Kh8YlNXYCRtMVY2grTOlJbg6XaoetUEsR4=;
        b=ify6F0j4Kw2Qk3jEbTr0qizAizSEkg/i/+tW8GknUSvVbHma0PqvCoM+jTX7KQzyD1
         +PutMsuaadAnM8fNloBvbIEfYlSLEdDcKFZ70QKoGyYul5TRYum+oZKTiTeEf0kmAnWd
         z1tnkklLj/agbhKtWuEk1dZlnk0uPgC0Coor/sArk4gorEgu368pMaYhklDFOCzbtoWD
         5zOLh5EZy8/0kcGYxZGbQOq7wPiKamqbTeQ4LgLpiuwZTFRQEpDuxl/SrWp9Gn6TTJ8L
         Xr3PpUdvQwGkDleNPO4jWfhzuQhxYNsel0eWPbymyLKOYhim34Ud+unzMQDveR9Wc31D
         nrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736749072; x=1737353872;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MkXwd+QL2Kh8YlNXYCRtMVY2grTOlJbg6XaoetUEsR4=;
        b=JuNUM6fzBMhLMg7FnO+7h6o3ZR7YNjX2w5+0GSMEyv4O9tAhkv01CcUbykatc5CcKF
         g/y30hPFWfEyea9km88xwd+QSTQoSeZb+Hv8T8sRimhaL+TRDmkes2nV40b4d+d2tPw6
         F24T5FKQ7pYpTyQp/CIz4+c+re7U58gNadE1+ZjDk/OhYLiiFjThvfAnSLDwxRs+fiQ9
         csAKRPGI1IdcdSmY2sy6M2yqCDRXd0bMYwgaco75V7Db3LPV8+1uw13vjC09tGdIKRpa
         r+7HIt6kGeD0w3wP5FtAjRN0WmfPN9oSPn1aDH9V9axlzuzKwq42rkpwW+B3s+rwLypA
         XO6w==
X-Forwarded-Encrypted: i=1; AJvYcCU7Xm5E4R56xO2kcuPpO2aWeRCYIdjEECJw2gtFxpZdoDYSdJhPcDLyftDDUJe7vl2pEz65lH16SBah@vger.kernel.org
X-Gm-Message-State: AOJu0YwmbspBAvLoW+XsSK/2/NjpdW5vOvbrjA9GV+uEkj2AjUR78Dnm
	C/GwpAjmTBgSy67is2eNlrfg9U3zDbrN3EqRJKCwhgq4szYxH/d/mKHxc3QB2W8=
X-Gm-Gg: ASbGncvO9z8HIMEAyjobWj8u9F2tH8nlAuCcnrHJUlg4DGQzFHGJNUbrlxPapCdreho
	Onxr50Sv80+wl2WILWL/ieIYC0c2eQ3mFStJ/bxWySXkXFBSnuhFs3TpkcuyVhV7N02xtFNtYOi
	JkKqI8ZPXRJPXg4GarbQCIusc5zFBkKoeXMQ0A2N9GSl7CqHfoAc+VMz+gl764whErbPmL6+bTz
	uNuVvzTZxy2NohFIZ6faMUZX+nVvbVwGOs2y5LDjIdbFviiOZFNXWlJvb62dQ==
X-Google-Smtp-Source: AGHT+IE6o2oMqn4i4PZo5uwOu6yYXtGWuoZjEmJZTnAJh6jtN+9sKXPFjKIkhQh8/wWA4MXHx10beg==
X-Received: by 2002:a05:6402:5255:b0:5d9:b8b:e347 with SMTP id 4fb4d7f45d1cf-5d972e722e6mr18754412a12.32.1736749071540;
        Sun, 12 Jan 2025 22:17:51 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99046a195sm4310659a12.57.2025.01.12.22.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 22:17:51 -0800 (PST)
Date: Mon, 13 Jan 2025 09:17:48 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH RESEND] ksmbd: fix integer overflows on 32 bit systems
Message-ID: <b00cd043-7e52-4462-8bb7-b067095bd5fd@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

On 32bit systems the addition operations in ipc_msg_alloc() can
potentially overflow leading to memory corruption.  Fix this using
size_add() which will ensure that the invalid allocations do not succeed.
In the callers, move the two constant values
"sizeof(struct ksmbd_rpc_command) + 1" onto the same side and use
size_add() for the user controlled values.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
I sent this patch in Oct 2023 but it wasn't applied.
https://lore.kernel.org/all/205c4ec1-7c41-4f5d-8058-501fc1b5163c@moroto.mountain/
I reviewed this code again today and it is still an issue.

 fs/smb/server/transport_ipc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index befaf42b84cc..ec72c97b2f0b 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -242,7 +242,7 @@ static void ipc_update_last_active(void)
 static struct ksmbd_ipc_msg *ipc_msg_alloc(size_t sz)
 {
 	struct ksmbd_ipc_msg *msg;
-	size_t msg_sz = sz + sizeof(struct ksmbd_ipc_msg);
+	size_t msg_sz = size_add(sz, sizeof(struct ksmbd_ipc_msg));
 
 	msg = kvzalloc(msg_sz, KSMBD_DEFAULT_GFP);
 	if (msg)
@@ -626,8 +626,8 @@ ksmbd_ipc_spnego_authen_request(const char *spnego_blob, int blob_len)
 	struct ksmbd_spnego_authen_request *req;
 	struct ksmbd_spnego_authen_response *resp;
 
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) +
-			blob_len + 1);
+	msg = ipc_msg_alloc(size_add(sizeof(struct ksmbd_spnego_authen_request) + 1,
+				     blob_len));
 	if (!msg)
 		return NULL;
 
@@ -805,7 +805,8 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
+	msg = ipc_msg_alloc(size_add(sizeof(struct ksmbd_rpc_command) + 1,
+				     payload_sz));
 	if (!msg)
 		return NULL;
 
@@ -853,7 +854,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
+	msg = ipc_msg_alloc(size_add(sizeof(struct ksmbd_rpc_command) + 1, payload_sz));
 	if (!msg)
 		return NULL;
 
@@ -878,7 +879,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_rap(struct ksmbd_session *sess, void *payloa
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
+	msg = ipc_msg_alloc(size_add(sizeof(struct ksmbd_rpc_command) + 1, payload_sz));
 	if (!msg)
 		return NULL;
 
-- 
2.45.2


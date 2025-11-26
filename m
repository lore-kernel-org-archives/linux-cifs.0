Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92571D5CC7
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 01:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121792; cv=none; b=NN6jqe/UcdaZaDWXRgkIIaqtWwJdsGSZ1G1aF6kVTPjr/npqikcBRfWZlqhisbOmovYslH9pOcncsUEXTVBFBK8EhjoqNEwsLeci18UddMbKQ4OL2KfgRxujhFN/N28PV16n8OfW7ytHtGXAc/cjQOLWAwF8I9IpuTc5dvSneng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121792; c=relaxed/simple;
	bh=pWKdAtmbcjOBC/rjEzN8Ynk6y/vXR4p9htT1qe9JR4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xs9IdcoBaiXUX2ZDpowI0N74QdGEkRZrpzZyYxhzUVdIYcy0Y/VwyoJwn8afXDLAzcksMPRug7pURLKjt5We962l1R6Y3cdUUae9EsEi21E8xQ9nCvQ2ScTWfAKqSoAc+36KgRkYirv/PFA30NWhq3cdhA5ZPcwvMO1vcDZRcNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcQ5ODI+; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcQ5ODI+"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-299e43c1adbso7429505ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764121790; x=1764726590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2JIwhg1M/+/Us4TNcrvjEWCQJJcUG3hiuOxKjzzsq8=;
        b=jcQ5ODI+PFrMXzjVV/SSc+gsg6lDKiqqPtAwlNgmH5En1koBOf40KLSaLk8OrCppUl
         qTnA4qNS7yI56q8cCfisfrKWzPJ+ceW+O4xYxUHloRZrdRR8oZvuW1zlmVWpFwotlrDt
         RvzgcwW25xn8mIrOlL2S6Uy53z5lF9sll3cVAzs8Y0INZ9iMYBsRgnkFHStSYO5Rw8+N
         2za0owNybyNhRcPMntkALozfH5ERHcOR0qXVceJhBpVpV98lkk4XJdjz5IBDfrx6mZhL
         uqmA70mgFrMnYJYdsgcRp4/OqLQfZay/YEpZBNPG7RihRuQ762RCzAs6dsIz0b0ebM4L
         Vm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121790; x=1764726590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c2JIwhg1M/+/Us4TNcrvjEWCQJJcUG3hiuOxKjzzsq8=;
        b=hUPLs26Qa+GU+bWAgt2tlwHItrHWV9Yn2Nf5DgeQEmtVQ4gVEDvbMGy+mTtVfeQRyA
         Y0sSAcTdxJgbtRxbJcuyEhwP9ch11zSGaVPRhm13GnC6Klh9ByugzlQbHz04Fcq8ndZf
         JVK7xWHn2xYT6VfA/TpUP/9RNk+fhs/yG1bh+bFdQOFE9vRZsXUamBcNrLU5xHJCEYhq
         NHFAziXrxeVR2AeGCMEv+S/tCByJUCZJSM13mnvJ8oksIPNS7DtxFnUggcdG0Bp7DXym
         qgCdYv5n6LXD0Q1U6NO0RkR0WwkfsMwpcA3hRIAu9AK4SloMoJ2MrCZoqZ267Bwm8whU
         llbA==
X-Forwarded-Encrypted: i=1; AJvYcCXNN8o6cZAfXUYsPU5B0QnvuZCvK+88EUHCAS6RsyEAQrZS1I39KOTrmbYSZ7qPNK6CTUz9l58fE6vM@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6XMABTAxW4OVfTGpQi1NiQnYH6CV6YFdDRQyqNAR9wjuCZTMs
	70LZvqH7d9VLoT5za2x0DWbUkYybKu7++Hn0M4M7Eoi4RjIgP1EsEINN
X-Gm-Gg: ASbGncujDO4Q0pf17CdK1InQ4pnplFM/12VTXygsbvxd4BR3xdL4YpXNH6O2Mtnw+BN
	RMt3hFDR7e2+NChw6pSMG8Hcf6AONqAJjl024ZqEox0GDtl/kTDfF/Hx8HvwfKx0vh1FJDYO7/v
	vJhEoUDw1z2SmTSgK18q1Wigr4xTXfMwMCbxw5gDIoM9MS40aYgDfM/yMEfsl/fGmgIfzVbvKFo
	2HEzoVynafEqN5e2/83SXEYsQ3oEFhxZ3CFmFoUZ5Pb/AizNPR5QWcFdYEUi7APLINY10s4rK0g
	MxUPJLDxTSX6wHtR5msyDIeNf2TQgyGQ7N4a/Z0qRTg8OZsEYBci5+HgBbDmDbDjzw1OU2CuU/+
	vDIAot+xCXr0uXQ8zQkbQkcLnCxmrIhhH4po/AQdf6RRRomTCE+zprWy9xsMb81m+ligOysKYr/
	zoSAqRk+FtcwY9dNaFhVTR21oNVRKPNRf3WfXHE18AFXR1juhSiLkxTU1pijRGLUgSZ5mNNGJR
X-Google-Smtp-Source: AGHT+IHrljL275fXtsXNqEjG58xd1IF8GPPmptkpdwAzH5JqK8ILh0LAGkZo45N/WI2fpgRCE5WxoQ==
X-Received: by 2002:a17:903:1ae3:b0:290:c94a:f4c8 with SMTP id d9443c01a7336-29b6be83ec2mr109629045ad.1.1764121790102;
        Tue, 25 Nov 2025 17:49:50 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138c08sm174994755ad.25.2025.11.25.17.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 17:49:49 -0800 (PST)
From: Qianchang Zhao <pioooooooooip@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: gregkh@linuxfoundation.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: ipc: fix use-after-free in ipc_msg_send_request
Date: Wed, 26 Nov 2025 10:49:33 +0900
Message-Id: <20251126014933.10085-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAKYAXd8=buKQRve+pdBFp9ce+5MiR02ZnHtGHy-hYDfhGWn=pQ@mail.gmail.com>
References: <CAKYAXd8=buKQRve+pdBFp9ce+5MiR02ZnHtGHy-hYDfhGWn=pQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ipc_msg_send_request() waits for a generic netlink reply using an
ipc_msg_table_entry on the stack. The generic netlink handler
(handle_generic_event()/handle_response()) fills entry->response under
ipc_msg_table_lock, but ipc_msg_send_request() used to validate and free
entry->response without holding the same lock.

Under high concurrency this allows a race where handle_response() is
copying data into entry->response while ipc_msg_send_request() has just
freed it, leading to a slab-use-after-free reported by KASAN in
handle_generic_event():

  BUG: KASAN: slab-use-after-free in handle_generic_event+0x3c4/0x5f0 [ksmbd]
  Write of size 12 at addr ffff888198ee6e20 by task pool/109349
  ...
  Freed by task:
    kvfree
    ipc_msg_send_request [ksmbd]
    ksmbd_rpc_open -> ksmbd_session_rpc_open [ksmbd]

Fix by:
- Taking ipc_msg_table_lock in ipc_msg_send_request() while validating
  entry->response, freeing it when invalid, and removing the entry from
  ipc_msg_table.
- Returning the final entry->response pointer to the caller only after
  the hash entry is removed under the lock.
- Returning NULL in the error path, preserving the original API
  semantics.

This makes all accesses to entry->response consistent with
handle_response(), which already updates and fills the response buffer
under ipc_msg_table_lock, and closes the race that allowed the UAF.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
---
 fs/smb/server/transport_ipc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 46f87fd1c..7b1a060da 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -532,6 +532,7 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 static void *ipc_msg_send_request(struct ksmbd_ipc_msg *msg, unsigned int handle)
 {
 	struct ipc_msg_table_entry entry;
+	void *response = NULL;
 	int ret;
 
 	if ((int)handle < 0)
@@ -553,6 +554,8 @@ static void *ipc_msg_send_request(struct ksmbd_ipc_msg *msg, unsigned int handle
 	ret = wait_event_interruptible_timeout(entry.wait,
 					       entry.response != NULL,
 					       IPC_WAIT_TIMEOUT);
+
+	down_write(&ipc_msg_table_lock);
 	if (entry.response) {
 		ret = ipc_validate_msg(&entry);
 		if (ret) {
@@ -560,11 +563,19 @@ static void *ipc_msg_send_request(struct ksmbd_ipc_msg *msg, unsigned int handle
 			entry.response = NULL;
 		}
 	}
+
+	response = entry.response;
+	hash_del(&entry.ipc_table_hlist);
+	up_write(&ipc_msg_table_lock);
+
+	return response;
+
 out:
 	down_write(&ipc_msg_table_lock);
 	hash_del(&entry.ipc_table_hlist);
 	up_write(&ipc_msg_table_lock);
-	return entry.response;
+
+	return NULL;
 }
 
 static int ksmbd_ipc_heartbeat_request(void)
-- 
2.34.1


Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF4ED7E
	for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:45:57 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1cf80a7be0aso5288755ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:45:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700729156; x=1701333956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/H4uhDHa0idRrSe5CrpxSJMtuYJEE+MCymo3rSjqvA=;
        b=IuQDrQoGJo5RALlAX4V4E3mNYr5guLWe9jWvt+TTKe2xNAt8E9x0tdRWeDz0k3ypuZ
         ttDw75QQm7kFkOUdBqReW2ubekKJkdfjGZoGYq+KwziVqtmNky1P8IibcoJQA8Et8P7c
         AZy0eikCDN9p9KL8mUba08Dq9OZwjv69AzWJZHSJrdKQtzqPHkMsoRav5+ETqdF8z9lr
         MW7WAJ4pejlCCa+kByw6VbuXaLeUxPY8BQABHkepXBOOYlHaPC4OTv3gIJbm6rkJKX0B
         7wGC5TwVGLuK+6BexQpRbxta28y65bmlXlSzyC2IcvMwWE33+fumCt3TZfxBrZ5ldzCd
         7xCg==
X-Gm-Message-State: AOJu0YwAGYK1iqAuwHp/jnNB4LvnOdBbaTK/9xORWhfPFGwT1LcDssgb
	sVblMrkcPMZrJoRKvjjrjtEj7XzdP6E=
X-Google-Smtp-Source: AGHT+IHTW369SY1IE+TK6N74ZOPf49OLCI2FGWv3zF42robYhBpRG5sXk99k/wLuBAzYauW/0RH91Q==
X-Received: by 2002:a17:903:234d:b0:1c9:ff46:163d with SMTP id c13-20020a170903234d00b001c9ff46163dmr5080268plh.38.1700729156318;
        Thu, 23 Nov 2023 00:45:56 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b001bc675068e2sm810208plf.111.2023.11.23.00.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 00:45:55 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/6] ksmbd: release interim response after sending status pending response
Date: Thu, 23 Nov 2023 17:45:05 +0900
Message-Id: <20231123084507.35584-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231123084507.35584-1-linkinjeon@kernel.org>
References: <20231123084507.35584-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing release async id and delete interim response entry after
sending status pending response. This only cause when smb2 lease is enable.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 3 +++
 fs/smb/server/oplock.c     | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 2510b9f3c8c1..d7c676c151e2 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -56,6 +56,9 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 	kfree(work->tr_buf);
 	kvfree(work->request_buf);
 	kfree(work->iov);
+	if (!list_empty(&work->interim_entry))
+		list_del(&work->interim_entry);
+
 	if (work->async_id)
 		ksmbd_release_id(&work->conn->async_ida, work->async_id);
 	kmem_cache_free(work_cache, work);
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 9bc0103720f5..50c68beb71d6 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -833,7 +833,8 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 					     interim_entry);
 			setup_async_work(in_work, NULL, NULL);
 			smb2_send_interim_resp(in_work, STATUS_PENDING);
-			list_del(&in_work->interim_entry);
+			list_del_init(&in_work->interim_entry);
+			release_async_work(in_work);
 		}
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
-- 
2.25.1


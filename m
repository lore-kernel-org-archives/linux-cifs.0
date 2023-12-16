Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A82D15EA6
	for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 12:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-35d77fb7d94so7473025ab.0
        for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 04:30:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702729812; x=1703334612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=94ZYoySqk1WSJl1E6lTo6AJmLWXCNzB6iHYBc9rOWRo=;
        b=NMcJB1EcWgecYuCa0e5bTFbvgu6pLtcSUcHmlhySTrpEvCc0MnR58oCaPaNymKweRW
         EkHLXEPF/1fdDL6McYaHbIos1pW8w78vVD+XrgxaBKev1CnTiwOwwappGw2+vfnGQCFv
         +76C59z/gNMGNm7NH6ar6gmyn5MmedUi2tLdCINy3IOJOdKePesTgm04uhKj85EYTZVD
         vkWmvqB1DxlwW/aBCNtSmyg0fp7kFGlGdJftynCxOgs2iDESyofzP868cu1Lk6Y9DboB
         Bs+gxN+fhKh2aklZvUNAqBNUuyDZPC9zr1N+5ilAcuUsqBady59K/H9kLVkgA6H6CaXX
         ss3g==
X-Gm-Message-State: AOJu0YxGQGvVWDUoK6uTrY0hkyk0luI6FaO7nvJ4DGk1lGJsH1YWatqJ
	Y8ZZabDbfdkeDuwu2xyDoWEEDSSAo8o=
X-Google-Smtp-Source: AGHT+IE3Dbx3eqtKrFuFM079/dZD1G+yU5kpl068IunbNOEkdPpUAnw1fYazIcC1XxW4YGXR44i9RQ==
X-Received: by 2002:a05:6e02:1808:b0:35f:a560:2f01 with SMTP id a8-20020a056e02180800b0035fa5602f01mr519569ilv.62.1702729812098;
        Sat, 16 Dec 2023 04:30:12 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d6-20020a170903230600b001d347a98e7asm6887843plh.260.2023.12.16.04.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 04:30:11 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: fix potential circular locking issue in smb2_set_ea()
Date: Sat, 16 Dec 2023 21:29:37 +0900
Message-Id: <20231216122938.4511-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231216122938.4511-1-linkinjeon@kernel.org>
References: <20231216122938.4511-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_set_ea() can be called in parent inode lock range.
So add get_write argument to smb2_set_ea() not to call nested
mnt_want_write().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 652ab429bf2e..a2f729675183 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2311,11 +2311,12 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
  * @eabuf:	set info command buffer
  * @buf_len:	set info command buffer length
  * @path:	dentry path for get ea
+ * @get_write:	get write access to a mount
  *
  * Return:	0 on success, otherwise error
  */
 static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
-		       const struct path *path)
+		       const struct path *path, bool get_write)
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	char *attr_name = NULL, *value;
@@ -3003,7 +3004,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = smb2_set_ea(&ea_buf->ea,
 					 le32_to_cpu(ea_buf->ccontext.DataLength),
-					 &path);
+					 &path, false);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5992,7 +5993,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 			return -EINVAL;
 
 		return smb2_set_ea((struct smb2_ea_info *)req->Buffer,
-				   buf_len, &fp->filp->f_path);
+				   buf_len, &fp->filp->f_path, true);
 	}
 	case FILE_POSITION_INFORMATION:
 	{
-- 
2.25.1


Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A6523EA8E
	for <linux-cifs@vger.kernel.org>; Sat, 22 Nov 2025 22:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763849270; cv=none; b=aw61tQS52H7yfjekuXthlLVXMlYmLsrRX7WyXLn/8VMmj5HbmBlpYmBLMHY3+fs/ANMoHWETlqT3x4R9z4CA48qRr91XDp3cHq7AQy2uAMnMSLTXaD/TSJNE0NhatSFIAmVl1kg0OUV4PsBYJMesLZvoGsyllVX9ct4yjQUwN0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763849270; c=relaxed/simple;
	bh=Sgkr3BOkoHvoC42Qcdk9BLlrCQr8EPVLd18SJJTdxYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=faOY7TV4pfY4vjtiohMWF3lc4Plj0bnzNg2+X5kFoDFXsLHpHqsYTpdV5viSZRlcCQX/ld7z1QhUs40LloBl+LVF3EFZTAKHzGGTQq1/hrwLdOjPG+YNtIfba56S+pGLq6KA8jLhF53F2FH5pJlBz5BiIrNydLga6TwDgRqDCi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gu5KK6EF; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gu5KK6EF"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-345658375c7so415431a91.2
        for <linux-cifs@vger.kernel.org>; Sat, 22 Nov 2025 14:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763849267; x=1764454067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lc4NuB1MYbl0Ec1tEVOR4gMOjb6I7UKXp2m54dbfHfM=;
        b=Gu5KK6EFRS0Li15dPZ+Jt+zKn1L50MRkjx7SpP18rebvRh5irhPjM2ub687NNBMcEi
         LBQbLf3w0PJpg+dc7FQFXBcdvM4hWujiPR+cuHofC3cbJfhFt2vMoI2M4fdwOtjtQZVT
         vqjdB0r66SN8AVjb5VMQ2qgJCzGJKJBij6ZIuJ6Z8J1UwkpJpS4moRKf9jcu8aabAvTD
         gEh2C4AzhWG2a9dYPnr2yUrUyqWvctj9sUPE680eUNjo29LF7tM1C78lKYPVVcULfeXc
         Rvgq/uWXTt5kst8T9eQAaTBHnZBa0eASp2EFsytSljWkz05YTjzYCG2jYoo0/fAw/QL/
         rZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763849267; x=1764454067;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lc4NuB1MYbl0Ec1tEVOR4gMOjb6I7UKXp2m54dbfHfM=;
        b=PHM0gQMLTdMKE8Q3IwNNHn9Oz83CeN02GJt2BMG/LpwBjVl2P+GEf3WjvmEBNGCqba
         dW+yV2X13uMmKz2UjFAjAdBwHYkuRbxKQQXoE8GWT/u2YCS1WmjfgPHgf398lYYdwCCd
         gIMLlTFZP5H5TgGh9/OsHcWCd//8+G+SfjKhkxdT/N2/jMvD24prCo5ydojC+1RaCHaU
         +BpnpWDtE+nqrcsPAC1wAvk4bY3/onh1Z6yZMQxy+JHhdFJKlRBJ54erg5AgfpUDhrs7
         SZVl8/DTexw2WJOvH1kvM6Mw63SdgWqHgmGz4GLI8gb4LbDwP8hK93XJVIWTSCMD+dun
         wVvQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8/2be7DRPbjnof9Pi6FK26TRdY56vpB3U81KHvdrpSaah4OSSjm86y/9Y4k23q+ogp/2tGxREHpu3@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf1/0uJypvwCGQ+XDmLJPEehn2Hfqa9UhwFbHxkYbngKpnm9R9
	adF2TkZZaiKn6VjIoowzVPIjG1nlxGaSfLgphEilgIUHJgrzdFQYlwwb
X-Gm-Gg: ASbGncs0l77oDh5Gi86gLIjaSMcQmqO0412U4c/EoFmvxP/ijMdsULcfllKXriW9WWr
	shYNCNRV4F+edtLdvq7hM9xB0FfAPyQlhTYEOoXIPI/q+lVEjAGh1JcFsH6l+hqaKTniTQDrypn
	WHP/kwIqK2OigJBpQivTPOOnuLdyWDxhrc8QaFSYX9Bh2fFj+HFswXCrVKnRA2kzu2GUaIoaiJm
	eYFHZJLHbKPiHaAygvSKFjAmRmOvn40Ex4kahw+TI/jrPv9zS9UzxGjtPJAKT78FDfw215RKsAV
	PFccyhrLGfK8jxSVCOmfAMpLwXcyCO8L3Be0axqMSFVvwuHOoXZBUccyGveeMln6KZTVJbGmtz3
	wqn04W7bFaZVcLgUTe2Ux1ar++NjZN/XHEQW0k6rIsFteI3cdyvCAoOf2J/DFUX0IvdSIt6oJtr
	YxPB2BFXfUroOdO/Q=
X-Google-Smtp-Source: AGHT+IEWBysY+tsF4Q0xGNDkQZz4zc0jDJqwP3kVBZl5BGnIucalazm+kJyDRt2WsgTaeiK5Hwju7g==
X-Received: by 2002:a17:903:13ce:b0:298:529b:85d7 with SMTP id d9443c01a7336-29b6bf1f7admr45954295ad.5.1763849267490;
        Sat, 22 Nov 2025 14:07:47 -0800 (PST)
Received: from morax ([2405:201:4039:48b0:c6f2:57d3:9f1d:7d73])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29b5b138628sm93344715ad.31.2025.11.22.14.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:07:46 -0800 (PST)
From: Aaditya Kansal <aadityakansal390@gmail.com>
To: sfrench@samba.org,
	pc@manguebit.org
Cc: ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Aaditya Kansal <aadityakansal390@gmail.com>
Subject: [PATCH] ksmb: add ipv6 support in parse_srvaddr() in smb client
Date: Sun, 23 Nov 2025 03:37:32 +0530
Message-ID: <20251122220732.3203444-1-aadityakansal390@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add ipv6 support in parse_srvaddr() in fs/smb/client/cifsroot.c. The
existing parser filters out ipv4 out of the given string. The updated
implementation identifies the ip version by checking the characters used
and filters out the ip.

Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
---
 fs/smb/client/cifsroot.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsroot.c b/fs/smb/client/cifsroot.c
index 56ec1b233f52..d957db8b2efe 100644
--- a/fs/smb/client/cifsroot.c
+++ b/fs/smb/client/cifsroot.c
@@ -24,13 +24,20 @@ static char root_opts[1024] __initdata = DEFAULT_MNT_OPTS;
 
 static __be32 __init parse_srvaddr(char *start, char *end)
 {
-	/* TODO: ipv6 support */
-	char addr[sizeof("aaa.bbb.ccc.ddd")];
+	char addr[sizeof("aaaa.bbbb.cccc.dddd.eeee.ffff.gggg.hhhh")];
 	int i = 0;
+	int ipv6 = -1;
 
 	while (start < end && i < sizeof(addr) - 1) {
-		if (isdigit(*start) || *start == '.')
+		if (isdigit(*start))
 			addr[i++] = *start;
+		else if (*start == '.' && ipv6 != 1) {
+			addr[i++] = *start;
+			ipv6 = 0;
+		} else if ((isalpha(*start) || *start == ':') && ipv6 != 0) {
+			addr[i++] = *start;
+			ipv6 = 1;
+		}
 		start++;
 	}
 	addr[i] = '\0';
-- 
2.51.1


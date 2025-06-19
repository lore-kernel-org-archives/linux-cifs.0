Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62754230D2B
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 15:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750347366; cv=none; b=H/bsEy3v8bBt2UCSrP0P39JFQFzAh6W8q6bsQcw7qX38tlauABb3jCIeMHKgXUhNrTQLGuKpQGOmgh28DHJjCH2lmhfbAFI6sdQHmT8WRByDVBA7JR0Cl32adXbzxRE6xqEngiYtjaPDB39K7YKTDEqDOZI3SXllC1/LJN1Ngqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750347366; c=relaxed/simple;
	bh=xwk0eTDAOpZyUNjApNyy22uEAgjpbHpUiEGETFADd38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seweEPWIZyvDXOUvfnpSkyge0K5l5xoaWgbwqfvaVostl1QNWZXtAzFtMHq0ZyeByOtizUeOlaQW3trY0g1GzxFwvSCOxR4XA18UwqUeJwhjVbgUcddTExjUi7/kb8wHZZipXGBLPNaNDNZKGCtptsu81Wfv8krQYsihtg1XKFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bc9u/OiF; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bc9u/OiF"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-748ece799bdso560157b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 08:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750347364; x=1750952164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRS5Kyl2q3cLJLihzFRkXSQVn55eac134r7059wCugI=;
        b=Bc9u/OiFf0DUvXyAtcpQ1IEuvNZ6jZ6WTNbv0nUOML4sLhstClFHhICcbKzJRj+yBO
         0CWQ2cA14uc6QPBwloE+niwINtQB5MYFpIxlmTj5Lb+lfNPrMqnI5X/qcdVv/8i7Lt9Y
         t+xGnJOyR8DeWO8i1uS0RyxIKFBKlbE33UiCcdb+K1OeuTKIElIy6E5gL+6pl/kkqM1S
         mPdLtDq1E67vwCwBzIPzz/sxl58kks+AUB0UdNvuJQp856lcpMjXNE0ec9gc5tLPBfCL
         bJoOswHWqdQorgA17L9S7ouLbJqwP9wb0K4ywQQZpHmnLj5Rv+wqdEwzOuCfArgqJ4d2
         aipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750347364; x=1750952164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRS5Kyl2q3cLJLihzFRkXSQVn55eac134r7059wCugI=;
        b=R+BlVJ88sSKoGtvYYVa0pPmEYc4DgZ1X3Jabm37HzXODmcCq/zZ0JtnOowHOAsz9V0
         glkB7hxoFKepZC0KUUImRhvTQygyqoGIFhgCGKpKYC5V5P95wMS8HwAtgwxr3XOAm45k
         v+g/QIFMHttao2mWrvdza0HVsJFk2opDQh+KP3pKqe52XZ/o2eV7SCG9t+rWbPAhjQpQ
         1jIenIGUDqFN0/7m89L87hJeQlP/19XE915F1zQOLlxEi7w/p6ZgTZYBYHLxIhogM/sF
         2Bkmp4p780lV8ecynYQTvI/iMdQhCUlM/2zZDdqFWDn9qjZsatIvHIwYHiLAAazqTBTU
         YOLA==
X-Gm-Message-State: AOJu0YyxE+3XRMe7PnvBsfH9piKPzQwoJCECTnquZQ49ylyvj7iidAXl
	kW7LM/M7JaSFUu+DpxYcuzn1EgZ7ySDwLlg5sJ8ejkYJtxTXlYhDbH1gf1fEiotM
X-Gm-Gg: ASbGncuI8F+NBcggbrHmQh+ewRf7yU3lhdm7wvqq1IeWTRwbeQduY+fav8iX4jrahFG
	r62L2mikerrLAXvBFoIyeIIt1ZHe+XCIN27/LwtLxGCN8ku+L8Oc9rWvETp96j257xC2/g7V5tG
	nRmrHn0mgBlYss+rqBzlhsGR4tg4uspYopfhVi9xWOnAhIcLbWc4BypUe1VhrKvDCACq91UiN/+
	1TcPKPApBOsVXro0QZE+Z1WLtI3w8RGlDgM7ZEhJWL5nHvViLrPj029/UxU41tiIx6orNyfuzmf
	M+dtW0TS+kdU0E6t238NRjkmF2mg/0jR86A3nPPpqeWA5/4FGVlI275vDKsCLDUf7bhonbSt/Ja
	uadF/yEr2nvuXvrgRkxL1pZE=
X-Google-Smtp-Source: AGHT+IHvEbwRWzkBa4jNkGjsaohL9fWQtyAhGdCGMktjxLrlTpcNMUxZzW6arRRuU1zY4SnbfgGLYQ==
X-Received: by 2002:a05:6a00:35cc:b0:748:e1e4:71e7 with SMTP id d2e1a72fcca58-748e1e477d8mr11860237b3a.23.1750347364523;
        Thu, 19 Jun 2025 08:36:04 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.253])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7490a46b574sm162838b3a.15.2025.06.19.08.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:36:04 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 2/7] smb: minor fix to use sizeof to initialize flags_string buffer
Date: Thu, 19 Jun 2025 21:05:33 +0530
Message-ID: <20250619153538.1600500-2-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250619153538.1600500-1-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replaced hardcoded length with sizeof(flags_string).

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index c0196be0e65f..3fdf75737d43 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -1105,7 +1105,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	if ((count < 1) || (count > 11))
 		return -EINVAL;
 
-	memset(flags_string, 0, 12);
+	memset(flags_string, 0, sizeof(flags_string));
 
 	if (copy_from_user(flags_string, buffer, count))
 		return -EFAULT;
-- 
2.43.0


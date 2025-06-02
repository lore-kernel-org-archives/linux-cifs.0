Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8272814C5B0;
	Mon,  2 Jun 2025 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748884145; cv=none; b=QUqOW1pYsAjUq7sGopmFtW1sOr+24bBKx1BUX/ORyKBVZ3eHgj2ZHgNIchG8p5+dsLzg2ZKtv11cZljWxPXSxkourDiTBN9fyZ+b1qheeeN5Jvnrv9HrXIa4PDEZ7TWt6F1mrwHGTEJlR5XWIwKljJx3+5HLRbSplox7zL0bXHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748884145; c=relaxed/simple;
	bh=y7q4p22etlpIz1MP/YjzrYfd1j0rCzYU2JGzxKpICgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ji4Rp/O/Hc3Ws78j4XTzKaRYq3j2DkUUOsPvmWrhTJMCSWP9JwQ2BsOfQHaUkt2p9NlT8bVYsZeV7XlFqPowiczmFrg+i+R6tdzOzHf1X5/vDKVzcs3WAd9btlUuY/3wfmVJdmumSc+BP+S6808AYxK8PNZVozqvEP83YxlnMJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GuT+4cX1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GuT+4cX1"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-234b9dfb842so43200155ad.1;
        Mon, 02 Jun 2025 10:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748884143; x=1749488943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9Of77aPlJOuGbGGMA/P66SunJZSI6L+xZsdMKEYIKs=;
        b=GuT+4cX11EmhtRbsyGDpB4SZZBRkm1bMIEtMtLB6uRWR27/DspUA/aRLOkH2rGcxNq
         PANEsQ6fkfMA8Hw0goIPpHffrGCO0GP3gYsqQFQIOOc8NQWLRcAC/5By8//C+OnROm9g
         7TgjQ4kG65CrwJBid48p27215J5nPlg6aexg9FOPeO4QLvUAV95ssINIxum8coQ8QooG
         q7/z3TIHMLcRczDgR4zH7F0hVMIj1x3v05O9VY3vRl/zbaVLvyjRayddmvArP68QExtG
         FdGM+qbJLspk1/NYW9iVD3yIl8o9HCHY2QIXdiTOq3FcvIs/k/KWn4zbbaWRKHvsTwyk
         0Ywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748884143; x=1749488943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n9Of77aPlJOuGbGGMA/P66SunJZSI6L+xZsdMKEYIKs=;
        b=hfagWFdWmOjM1jZY10o8twNAr5LnSIIrnfh/e4HxQL7haBER3xDmAnz5ZecXyF4v7a
         0NZB1djvJwS9u6h2XHrCHlN2iBHus+k0egPpDwjgH2JhMhqg3oMaPyANsoAtk5kvYni5
         VXTUx+SJSN87JgvUvwSQPw7A1KZVcuRtlezSnerjdRjlr3riOQYAcAlKidKmADeoqHis
         c6Mlgq4BH2JQoFSuoylGqn6ZogQvjyo3WQsLYmGpVIH3yEDGVL4KdlmaogUVPRRL8gzo
         d+LrklCuc6ZpJCTIKVqfDabqLjDd/YwLNb/qwA+qRXtjtt1X31BSg2/YXHizaRePrYcv
         bCqQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1IF6VqjZPRfae/RaaR3Cz3jp3NkGEjV6DFTSNnmtCTVZGJFtwYZy/vJagoZ85LapS+/usBPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO+bZDwMhwj/mFA8OF7DyUA3+npOfnNW77Dy9XcDkqSHW3iRPX
	Rqf75oWzvKp+l+wmD1dBAHAPGlaYOvAIbbUXy23s64bPk7Ha/bB2dHSIcYj8LA==
X-Gm-Gg: ASbGncvg0e7By49Eopp9RB9UG5/E6tHa73sPa27St2H3MMBRMs9jjVUQKGSIE9XUqAQ
	oAXwROTwgYZ77Ui6tBuNprT8E4GiV/D4jIVENt1wXjXHHJV/UZ0tWAleGq2ZV4zdf+7VLU9tWmL
	cC72nsvGsw45/0YFBIeUfLYvT42yNYd00bqahq+9gidYZ2rzB3jn9V/WB21brlZaeVRwdBoHg7n
	LZhHCzVmUMlnQPQ7/2PTDapRvmA16929OIZ01fUpGW2Jo3qxBEQ3h1nNiYR2lHJVz3nJRLnrN0B
	f/ujZuCw16XBvq0CtZLzCb5vPIdWM0k+49l4WBLPOb57QsMNA/J0uR5MffQuIfj84UDY/p+scPQ
	TcNSrDQ==
X-Google-Smtp-Source: AGHT+IEaATh383vw+vxjXbDmLwC8QysGuKgX26d31r4RMU8I2R5gg++PcxRJlLfawV6AmZQ54bmA0g==
X-Received: by 2002:a17:902:dad2:b0:235:be0:db6b with SMTP id d9443c01a7336-2355f7960c6mr128254155ad.45.1748884143268;
        Mon, 02 Jun 2025 10:09:03 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2355c58ecd0sm40319625ad.25.2025.06.02.10.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 10:09:02 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/6] cifs: reset connections for all channels when reconnect requested
Date: Mon,  2 Jun 2025 22:37:13 +0530
Message-ID: <20250602170842.809099-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250602170842.809099-1-sprasad@microsoft.com>
References: <20250602170842.809099-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

cifs_reconnect can be called with a flag to mark the session as needing
reconnect too. When this is done, we expect the connections of all
channels to be reconnected too, which is not happening today.

Without doing this, we have seen bad things happen when primary and
secondary channels are connected to different servers (in case of cloud
services like Azure Files SMB).

This change would force all connections to reconnect as well, not just
the sessions and tcons.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 6bf04d9a5491..ca1cb01c6ef8 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -377,6 +377,13 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 	if (!cifs_tcp_ses_needs_reconnect(server, 1))
 		return 0;
 
+	/*
+	 * if smb session has been marked for reconnect, also reconnect all
+	 * connections. This way, the other connections do not end up bad.
+	 */
+	if (mark_smb_session)
+		cifs_signal_cifsd_for_reconnect(server, mark_smb_session);
+
 	cifs_mark_tcp_ses_conns_for_reconnect(server, mark_smb_session);
 
 	cifs_abort_connection(server);
-- 
2.43.0


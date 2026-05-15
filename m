Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065CB44D018
	for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 10:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778841852; cv=none; b=IO+jufi+yzmuG6U8xZACMRpdlj7c5t5DkYo2TKzA15gKgjHF9dGg+T5Ob5XBYGznppLWtnRuYsIYZWgicJG4rQ33gc7LC54Ehooq23gA3FD+mTGWLYsQBml2K4wnU8eGPBEo5vpjTZ9SjnbCehMNOrlH/W/eECAnj0Q489b6FBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778841852; c=relaxed/simple;
	bh=KY2AsiNurTVnvLiWPzPFhGLyjj1bek8yErHVAyYOqSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPLCJmTQUBajlLd/yWBZB8Kh+gbDZz5Li2WKMLRcT+8rtaKdK7b5bVVTdmw+Hq1Fr6V+iKjUFtST66PI/7YsEHcNJGGID/UgTrFkSrsKb0trsVYo/rsyqb5H/8UwklXnxtMIiSTLkDw9faYmMII2YNbn8/zGD+edFVB1k7oH7uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XrGAiYwI; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XrGAiYwI"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso55531535e9.3
        for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 03:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778841849; x=1779446649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY2AsiNurTVnvLiWPzPFhGLyjj1bek8yErHVAyYOqSw=;
        b=XrGAiYwIr2dKY1PTNS/stITMQcIC5apkmZKM4j+SZEBrGnt3hd2uuy8T5VMvCM67hX
         SmD0wdaMoNmXJ0oUsX8drTgiZNr+vDPvzau4W5tx9LDYbBdUsx+MRV/wMlieHjqsghQF
         Fn+4CLFtsYTJVKuoJKUYsKJroP+/2CoFyH/m6CLFyMBTE6+QPrmCg1KJ9VeHZyKQ9Orm
         3gDQawO8bHr18pAvn9U6V53O1bkz2Zsqmgn7EyXUbdNpKxOBRxlWBfZJCMFDPUEjYK87
         upY1jeEOiw9+PbbG2T+qsn3idQY61rcICgSxbPgUMrXBhePIjBEAlQfMtfQcrK805aMh
         XgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778841849; x=1779446649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KY2AsiNurTVnvLiWPzPFhGLyjj1bek8yErHVAyYOqSw=;
        b=IS/t05J6hy+jbxrgAOVeASIoa+6IcJyqOwL3jTDxO8oo8IUmSn/w/Oaz9cLgyBDNp1
         azk6qIJzjHl2qenBaH99VRnRKRO2Jt6pGK1nDEYXZp2FPFxbHuAN5VKUw+l9+qw9z7le
         42NJ8aSoBnubnTn0I7MF2TsuBFZmpdkjnR067XNo+PgwGX1jXZ2v0TAVRgJ7HEOm0d1o
         XcSqlJH2o+PU/Q8rRk6GuqC1giQBZSTXv1dMddHlw+37Zq5wOYB8JQcy848KJLujCs5G
         l1RM8bmrlzqR4bDTHD7yBF1YZkSjFDmn4JB+5TUFDUQxR8Ij1/A6CBPvEVS+BU9Cm5Va
         DTBg==
X-Forwarded-Encrypted: i=1; AFNElJ9+9eD9VO0aKxxLkEiFZ0cijE2gZVwm2q0jZoWH0/tynKMBM1+Bm8ag1Im7q9SOVlyei75CLw5DwVL2@vger.kernel.org
X-Gm-Message-State: AOJu0YwDtgGOEN8thuLeIOwR46+5HT4qIlnx5uAgPLNEGqSBq9qI13q2
	iEuLYMwhLU4JXVeLVykpqViiq+mh/721ODRh57VZd8OeVj4X/DDLjkYsQemMrHmCNZ0=
X-Gm-Gg: Acq92OHpP0Q6pHq+QNhXMNwexQcjph834pD4iRbUCB8JKSWzqIjK6tqMJCOwiXWMRo7
	BAm0d818Rlh7oPEyXO5ijMt0W85mx0CN+OEyQcNoeoCOcwKjyJFvHiyeZ0QA1/XUWYM8C+9Xsjc
	dwiHYJvPhHED4DxsTi3pgvQF5EM3haE+B27we+pwGNv3RyAR8wAW121gt/K6g9IscXeQK8wlsl4
	oBsSTNKkSCVniA+5dlqp1ezPhheQLQPS3wr47VbHm2cruKKHkcgnrUjPeLl2B4IF/tK5QPx6w2X
	cvEjnr6gAqR9rwN0tsMiwBGd86w8Asfoi365B76UCI/5U/qd8eEE5x0Q604th6Z0QhpxYzVKASZ
	vYHw37mCJ09EOQIPyKmnWDpV8x/C6A1NDXNAbPdyQF7QQI3wU+ND7vUYzNBMrse0mXZXwpjHyDq
	Q/yRCfrXj/muMHx+hgZGyJ7eNutyKLbEsFU28NQnwXu5+iBzit0yfEJ/69ZB7lGnCm9eNEgOXT6
	cQW
X-Received: by 2002:a05:600c:2d09:b0:48f:e1ac:c96d with SMTP id 5b1f17b1804b1-48fe61f2bcemr25319745e9.20.1778841849271;
        Fri, 15 May 2026 03:44:09 -0700 (PDT)
Received: from precision (ppp-88-217-117-152.dynamic.mnet-online.de. [88.217.117.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5ab52a6sm50484945e9.10.2026.05.15.03.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 03:44:09 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linkinjeon@kernel.org
Cc: corbet@lwn.net,
	ematsumiya@suse.de,
	henrique.carvalho@suse.com,
	linux-cifs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	metze@samba.org,
	sfrench@samba.org
Subject: Re: [PATCH v2 11/11] docs: smb: document SMB3 over QUIC setup for cifs.ko and ksmbd.ko
Date: Fri, 15 May 2026 07:44:05 -0300
Message-ID: <20260515104406.10075-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CAKYAXd9QWJFB8oPGZaDjWhEPYJXiDRmiKZgVUwmKKUjeQPDiFw@mail.gmail.com>
References: <CAKYAXd9QWJFB8oPGZaDjWhEPYJXiDRmiKZgVUwmKKUjeQPDiFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sure, will do.

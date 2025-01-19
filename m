Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0E2182D9
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 19:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737313462; cv=none; b=ryV/5Xd05LmftWZ0why6ni9Z4yJpgrdJZrP8qD9cObrUzfx8l7/FftSSp943RX6wU3NlX4hz8zL8Tzzd0yyH1PxF3IXxpNHRN5c/I3nTHesNyFilSKUqAZjWCc95oLcltq8MLq+losmQHdCLwcVH8SyM5VBO8FJBW2Pr+Mdryho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737313462; c=relaxed/simple;
	bh=6+VcKfRPwg1PigOcvc/LR06R5qD3B5IWONe5ExAGKkE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=KRfGOfbk7nllLOH1DzEfVdBmgm2OXYcPHQcwX5yn+A0mW0DOK+dEcShQn/ZN7moiY/RDUTE4Qx5PTGam3gFmDSHjf9U5ZOY3yXrEolirv/xjQx1EU5E2xcQtJu1vCJVGIFyslXVe+0kvmtrMDsDZYcgYLnxLL9MaCpWdBQSzbGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FsAyrsJv; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FsAyrsJv"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3047818ac17so34250631fa.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 11:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737313459; x=1737918259; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1zQrUjx3XDEgrLpra3qczgdv4anQL1EIwxFYubXawUw=;
        b=FsAyrsJvHWy+YWGuSZxNORBefuGAlZoHBPdZX/LvFmjJCav1lBtqoOFjjZGz7mtRWD
         KCDF6+M7W+dtNeQbAZ5/etm0rD70MH4CLeE2nJcd5kdIB8/DzUkM/SaWMoCKmpP+SOOq
         Y3q7+k2uLJwXgQ1imWlA8XhbNN2bj79j9s0KJxsbbd38wx13KoWEE4Tls5qKPneoVHkT
         O3QkFlfYSq1Ws5q7zPEtTA0hJhkFLtJ/mxRLYHATmzseO+pLv2lxC8nj56CqIQAuM77U
         RYE+gUMVjmQbyKXcNRIgJ1I/McO8ap5kVzdHZSFgURhUVGyVzSkIvounwG6O/zUD98pN
         Aw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737313459; x=1737918259;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1zQrUjx3XDEgrLpra3qczgdv4anQL1EIwxFYubXawUw=;
        b=aRE1KdDz9Kv5uxPQQ+Ar4WSASDI6MEf0FZRaCSC53OmwuOCK6/0vDk2l6M2HmMT76Q
         QcapfWwpz3500zQNHGosMMfSB4PNduwHvLocCRRAwQoPHe59rBkTYk5wSdXTEMeSP3W+
         7cpuoDDllNmdLP3sV2mZfhLIQYUA80DGCjkbJba/7uRimwkmkVRNSb0l7jJi7I4/LP4D
         IKokM0AcHwhhCr1RlJlxMcstHi86KGXqPTye09tYQN2SBfknYY8y0o7WDvpQeJZ0wPRZ
         uAieRix7u2tFYG08zA75PPcm/wCHmAq6qtiATID60tLlrO9j/KTDv5Gsi6piZrt3DGsB
         1jXw==
X-Gm-Message-State: AOJu0YyMezW+jPMU8JpKYhKZ6OUMiKdIVWchsInQh9OCIvJ7dAFmy4XY
	CSX7gGbzAziz45zj1LxbFD44crIz3u1Pgp4OqRifFMLz4BEr4vGJXzGOrnTMOkv/+TGXL993CD5
	xuHCwMsA/D7YZU8DagOG6doTrfo80L4u0
X-Gm-Gg: ASbGncutpbRA7XNVRXfRsWkXf0kKkF3QTwc09MdUviEA0qN7RAa1SIJZHpGY42e9F3Z
	E1aUB/ITzObtgsjTKpE9Fe5RIaTsIRvXX8tKRU4vPqVgrC21ZT9wR58bUm4OZLhBGzrFArWicw1
	m7zj3VVw0=
X-Google-Smtp-Source: AGHT+IHoESiCCiOZJN1nBmsB4WkWpqj3jCGsB9HDT8er/nh40NELQotkvDvp5LRjhOai7g42QXekCUSC7opAv1R72Uo=
X-Received: by 2002:a19:c214:0:b0:542:2a8b:d577 with SMTP id
 2adb3069b0e04-5439c22d822mr2880721e87.8.1737313458806; Sun, 19 Jan 2025
 11:04:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 19 Jan 2025 13:04:05 -0600
X-Gm-Features: AbW1kvbC0BI3EmVZa-GJCr0lZxukUO6MAM3Mn5YzP-mfLlSRGHYjhYu8VQn9Qlk
Message-ID: <CAH2r5msxj7Bwn1uB4di=EChVjU=DxULmJT+QsU+xwcxDGiyHQA@mail.gmail.com>
Subject: [PATCH 28/71] cifs: Allow to disable or force initialization of
 NetBIOS session
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

"This allows Linux SMB client to connect to older SMB1 server listening on
non-standard port"

Pali,
Are there examples you have seen of a case where SMB1 server was
listening on something other than port 139?

-- 
Thanks,

Steve

Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD744CA4B
	for <linux-cifs@vger.kernel.org>; Tue,  1 Apr 2025 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743501399; cv=none; b=Yid5rJD++wT7MzbplBiXD2TQZML6HbpuceW1beM+W+TwGpPTREn7VhLjWum6EpnGX/Ot5lpb37AebZL+GIDix/gGPGhIwxYi4lAHzni+x53R/dVaIMqyjrRQr2R7qR99qYkqMSn9uAB4zmp7R2h1lsI3HGJBbpzfQFij0a5d2cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743501399; c=relaxed/simple;
	bh=N+Z3PZhnz7/SMjVF74U9JysS6nKsJ2tmf/kP4oOfxbw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=DhDcqvF/1hZJqZl6JPrqvsFvXcv02bNHj8omucWDrtNkEQhElZsyUrcQYIQGS7yRLbwnkM/lMLdX6NBJJqRFjqWedWvLcwmKC5MrYxiMep35h0qq5/K2d3ViPFXKPqBkVhToWqm8nFdzKbllg9nI195I3Z4SxmoAg7La3qgs/LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kvCwYGcg; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvCwYGcg"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-549b159c84cso3672079e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 01 Apr 2025 02:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743501396; x=1744106196; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yW6aRfCm/5F4NqJVwesCPE4L5Gtn5UPLS/4NoxsYokI=;
        b=kvCwYGcgLoDPdjgyxRU3pcgXeHsxXHEmZ8WvO3Wdqh2JUOLGgrXLcSF/Ko6P6J6sVs
         luH0sTyygWNxzTmOnFeOBhMTEBNMQU+kFUrkc+6zA37V/UATbxgMZSvi/WAhck5sv7P1
         MIxhuduEhijjx0wQDd43RRt81lbTsZCj9wzr2WIOa40srI15bKRm9kAtQMzEwy/m4GBW
         +xOtvofldpU9p0MUh9vGvwEvMlT32wohArsBbHcu46h3BfexAJ8k0QE1XaNcrPQtHbfZ
         j/Kb2foYRwJh8C7fflxbxUMundXLygpPKR9N/MrC+UXPC92qjZO7vBc4N797uXZovgJ0
         UJSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743501396; x=1744106196;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yW6aRfCm/5F4NqJVwesCPE4L5Gtn5UPLS/4NoxsYokI=;
        b=aMChDs7iGg10JDhMIKFnCQVrcLVwBmRa51UlFFd9KjWtmzEFB9pzpPEWXTEsOC+QNp
         dYkWGT9P3tlJDtyF9ow3zLUvyE9fB/WRWWCXXqlLmfK8CSghCLMCIxdYB7MP7gYq9G9u
         z4yRAm9nV04JDXou04mpwlAFmJdy8fwyL5j2XRK++enkYFiuqwMbOLri8rL42fDA2C7l
         a4M2lNhEsBluQkVuIv21VVECwkspmZpg2XO3VEu9juQeC/HRLq8VWFSPqydhxU/QWybM
         zqXDKhf3EWI9lEk3gZfScqWrhPYfD/ihreyPTnhEUdWOulHrVusoKipJIEgQRXy6NwvT
         qg3g==
X-Gm-Message-State: AOJu0Yyuoq+eNMWxViFSbS6+ANrkk2qtq8mawQ9A+yrZj7lLShwL18uP
	1qWFU2bJ1hQdc3CnNpIaKzRixPS4skvuhwiz3/9QVq6lJAtlazzlh1QHObFG7TEV/EFyyJv0iZ+
	RrJdSB8JPgUOOk15Ufbbg2tet3V0=
X-Gm-Gg: ASbGncvV31X1FP9wtkpryH+10C+F8dRL+yoZtMTeP5MAEUihaoK1bqbLH8GTLAH2xP+
	lTXXD95FM8BrQgczvVerzvkARk6Yl0gvbEMoytvfdt6VzGpQPsmN7sH7iXqeJNFKBf2aE5cHd+L
	NirfCVAVXySPpdQ26cZz26j7OIM6Orm3XPMC6MTm83o8qJs/IAJnOIjLqDkdbEkqSRwdtdEB0=
X-Google-Smtp-Source: AGHT+IH1SnGPcUU1K1O6MeJZlWkYiLQUK6PLujR7cQM+Y466B5nJjDhykIyQPGVJc+7jqx7WtNPgt50V8aGvP4r6TLs=
X-Received: by 2002:a05:6512:334f:b0:54b:117c:1355 with SMTP id
 2adb3069b0e04-54b117c1437mr2481620e87.55.1743501395714; Tue, 01 Apr 2025
 02:56:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 1 Apr 2025 04:56:24 -0500
X-Gm-Features: AQ5f1JrGjjrgg37e5irbxUacoTeJCLeGceoVDiQXFFVx4wOyi6CYYDyZ70lDqBI
Message-ID: <CAH2r5mtEYHzvgv09ofhSyRmhZt=VsWtOpDvtSsPy=D=aHx7OdA@mail.gmail.com>
Subject: Re:[PATCH] cifs: Improve SMB2+ stat() to work also without FILE_READ_ATTRIBUTES
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Pali,
Do you have a reproduction example for "cifs: Improve SMB2+ stat() to
work also without
 FILE_READ_ATTRIBUTES"   ?

-- 
Thanks,

Steve

Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FB813A24D
	for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2024 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727373902; cv=none; b=BilacPTZ0wRd5uY9hQ3P54CI8QIPcHNxW7M7HAbvVo4/5v7RZWeKiBqIjADuop2EWpM5JfVRGs0VFml4EuoZOD9/yPmXtCzgKT1YnTLFLBdJd73cXyF5REEw4GxJUGYYTmcRCwlXCqTl8NuXKcJ9allzjOXYwH9tJPfMQ38/uUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727373902; c=relaxed/simple;
	bh=P90jAMQnEj/JjSSn1UAesaGS/P8Nt1LtqX27I3+ikAY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rIqdTN5crnmG4dj5Am5CLBi07m4Pn7wIBjdrZnJAB1/yNestq2106sWjvi8IgLVkq6uBAwdV57dAbW2jseDqL/8gG9vZRbJT4UkkttdGFZbJZ/+1U6buy2pSj1lW3fL8uZxRvtY2q70MrH8xIIMzyOKgJfgxxi+HN7XXeWYcLvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JeRhJ9Ll; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JeRhJ9Ll"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53661ac5ba1so1470528e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2024 11:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727373895; x=1727978695; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bs8IHiR919/FmXobmmAaNiBkTBDzJNr6RBd6L6vrKcA=;
        b=JeRhJ9LlSkzloF0nYy5hxiEVNOJfpu65vRslbVxAICMXWrDQ1StCc1PB/sha1J6fol
         w7Wo3UglM6RR7K8c7pz4BAsAagBX6ItSM6O3lZi0ZlEYjjKqqwz/H+ojnSqJdpTpnRib
         B6TtqtxA8SU3qY6ZiCklqDMFCpkSeydQdrgZoZ1oZz1bk4dnonDuoTus2zrHqcUD0H5A
         68M2lCjrGng1yE7/uffmdAx/TYJPSYuWlXHE2CWE8lUVted9ZC1ID5ZdZHeRo9pGfZkk
         tFZl8qulRh3E36drqzTXXLyKXwNoCSk0B5P7KnVVsAceGGC4DQpJA0J4XYoaCUntoadd
         hZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727373895; x=1727978695;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bs8IHiR919/FmXobmmAaNiBkTBDzJNr6RBd6L6vrKcA=;
        b=YtopliZDwU+qY+D5Ru2eAvDontUvkw12FHSc+PryL4L5VGcHgLgSB+tuwTMuD9WX34
         Z2TWSb75996jutiWhLlbiFvGWu5fsMS2qM62pYmHGvJ28j9n554wQxAmkp2O+BlPLiFP
         vav5uTwiHkL8THvdHqW8FkUP0hE1zBBC/1gbvnMZ/7INAjLHf92U30CuLnFv/9f95FIz
         PZHO/XEI0H8kzktq+kqpnYnI9Yi5JyTs5ezffYviekKWSPHenVYX8uE5d09vawa2IZ6L
         1fh4sW+zSRi8vufg4FO1xk5YaA/Z+wRkOIzUnyD4vkQzgBXdiRxv/Bl1z7NvtiZLgd9g
         Ycwg==
X-Gm-Message-State: AOJu0YwUuOT8DEhT7IjGWxyvjNCXkmvY1Ql1tsnZv9CabyHiWGD3blBe
	A5aBxLt7D+yl9hCoT2W6PcA8X+WFAakNiVeXGJGd5oa+WOab9MRAbCLzeC5wYuFNfBxE8RwpH+n
	RnyZ5Fo1WhCdpEmfS01Rt9wmWHu0ILKKI
X-Google-Smtp-Source: AGHT+IHvcBRmoubQjek5cmVRCLNHBrZR44XAcf1o7WRXnfcJ59CatrzOXmXxidsEzMRNHCL0Fqnk4yFzx9gr9oPOSxo=
X-Received: by 2002:a05:6512:3d93:b0:538:9eb8:c4a2 with SMTP id
 2adb3069b0e04-5389fc30edcmr336701e87.6.1727373895122; Thu, 26 Sep 2024
 11:04:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 26 Sep 2024 13:04:43 -0500
Message-ID: <CAH2r5msbBYdqe=2HQqrceJSCYLXhyBRemYwXMjrmXWvq_y9VkA@mail.gmail.com>
Subject: default value of esize (min_encrypt_offload size)
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, Shyam Prasad N <nspmangalore@gmail.com>, 
	Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Does anyone have perf data on enabling esize (minimum size to
determine if worth offloading for decryption) and what size (e.g. I
was thinking 256K or 512K minimum encryption offload size)?

Does setting esize help any workloads you have tried - and which ones?



-- 
Thanks,

Steve

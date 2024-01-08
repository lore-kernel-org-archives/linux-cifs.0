Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901A9537E9
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jan 2024 16:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPy4S1AW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704730430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=lFQMv9XwK9ej+tAG2vSPh6/ex1rfcZMiQqZcNXWZROs=;
	b=NPy4S1AW3BsEa85Tok/3ZAqrxAO30dTQrWDBmvEkbYAmhQPfRFW8HN34j4HzNhlyjdYCVf
	nOiBcU7/1mmgTZ/dqPdWggdhlccKvP1CzWGj0MF/nQZUwnGakakm+dFba3XiO2fVr50Rw4
	9ybNuKsuzBKkbr6zJkn5qMkHfeQZddU=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-Zj7gtdEPMGKxNCdLnVNkog-1; Mon, 08 Jan 2024 11:13:48 -0500
X-MC-Unique: Zj7gtdEPMGKxNCdLnVNkog-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5e73e6a17d5so32174907b3.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jan 2024 08:13:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704730428; x=1705335228;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lFQMv9XwK9ej+tAG2vSPh6/ex1rfcZMiQqZcNXWZROs=;
        b=n9FlnEDqX1TYzY6kcXdqOG3gclI8wCIOIdKNn7VATIzT9LlqCnnJ1joW4D3Ul6uM72
         GsUc5SLLFa7KbARZm0yUcAybo93t4u4OFqlhJV2BbOjXffRSvPpTArn832FagT2xoAg1
         cv/SUoMJ5BOKFg+dL05NWS/zT7oHm9k7eL3nB5P0WEM2a8iAaBgcnnAYWeFDsxSjx7RQ
         dhhR4c2peCuBn7SVCNlh4YO+5fnasWWdQEBf4rRjfbsXnNYMGM6g2Ok10FijPYhmoCZI
         salFAacroiXzL0oSbIuhF9HVaUQRYSvHLJV0wqZHLwhAfqheuYV+YxxZlQevCkGtCvZg
         pg/g==
X-Gm-Message-State: AOJu0Yy81XgzwOetwPbCn8S13A7sGtMS8+eU/lBecL4EZzvqtizm8kFn
	bZT1EJsCeB2Y1pJzF0pavDfrStTDE2LIqeNqmNrNnqgC5F+FOSGqGmcYjs1ZvJcJiuAL+HkNeBS
	hPytJ4y0q60YExvK294ZIwm9NXYICZ8KV8mN4TwYJRr9WxFLf1EGj48Tk
X-Received: by 2002:a81:a0cb:0:b0:5f5:ca34:c1d with SMTP id x194-20020a81a0cb000000b005f5ca340c1dmr2469045ywg.49.1704730428143;
        Mon, 08 Jan 2024 08:13:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeEMgaCZVBx0ixfeLvGAxJPO59TIbNQsubdgH3bNAFRgaSAlSLNFmVBSOZWkzfm0AOQ03fJlmlNmG4ZoHECNI=
X-Received: by 2002:a81:a0cb:0:b0:5f5:ca34:c1d with SMTP id
 x194-20020a81a0cb000000b005f5ca340c1dmr2469038ywg.49.1704730427923; Mon, 08
 Jan 2024 08:13:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jacob Shivers <jshivers@redhat.com>
Date: Mon, 8 Jan 2024 11:13:11 -0500
Message-ID: <CALe0_77CgEXNiXrM4oQ47sfHnDoML18oz5rmEu-_57Av0KRTkg@mail.gmail.com>
Subject: Linux client SMB and DFS site awareness
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

Hello,

I have a use-case for a Linux SMB client to mount DFS replicated
shares, with a preference for sites that are closer geographically.
DNS site discovery/awareness exists within DFS[0], but I have not read
of any work currently under investigation.

Is anyone actively working on this issue in any capacity? If so, would
they like help in some capacity whether testing/coding?

If this issue is not being actively engaged is there a reason for
this, e.g. low priority, technical complexity/implementation issues,
or some other reason?


I had searched through mailing list archives and found no prior
mention, but I do apologize if this has been discussed and is a
broadly known discussion point.

Thanks for any feedback,

Jacob Shivers

[0] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/7fcdce70-5205-44d6-9c3a-260e616a2f04?redirectedfrom=MSDN


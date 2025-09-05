Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBBB275AED
	for <linux-cifs@vger.kernel.org>; Fri,  5 Sep 2025 05:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757051686; cv=none; b=ieYvlzDWJeWLr5YrwNqq9T35KFuGmPLPXR413yVP5Cx5VPbOvw7mQRCyaHL+S7U4kyaF8T5NSTCrLM3zvnJP/YXuS2KJvWfnYqDYbh4v5jtXocgj8yo6p1tghXfXqbKBGa5tzJ7++UAHCmi3Tkt2+xthT++X0TeyIxS4FQPlZkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757051686; c=relaxed/simple;
	bh=ytUC7WdhYn4kfjz1RxstAK0awHverDIHhKoNmeXZeyo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dU3us7X8tLKwlcSegDxuea4w3PNqoqm+CeWlhQNn8DIs7cHvP5UuIWgugl2tr98VLYUobUORB/McS/V5cHwWvBkUarEmXNn3/28/B6vrr1KO6N+HGTlFZVug1nuKmL9FM5jq+lB9Ir3kAaUsTLdNyAdlY0leTlHhtsaFIoA4Xx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XaKnTFRM; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaKnTFRM"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61cb4370e7bso2855853a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 04 Sep 2025 22:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757051683; x=1757656483; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0cJohvp9kS6Dy0gG3oznzgKLJkz7v0dZiOFGidq8CSI=;
        b=XaKnTFRMWAeNBfgb+QorgdKO0r/EubAMee0BDRISvN537l3wgA67IE0vUr8QH4I+a2
         DXtBlzX0ThmtKZL9BZSKhhoj5f1vRCvUM1pb+EKlbgWxci/sU/oNe55rxNlvL9pIdHjv
         NQYTNttdSh5UCL7YYCCkbQahj8YhlIPDdfbS9klVcUASXHRerNKWsKCkf5R2dbPRXv9K
         tKXWxwCdIlsS2wRlrcFOjn0ubxOGPPoHu5y8Xf0QM4UwckF8+EuQUGUoh5uR4oRFohdY
         l9xhtHutBzYcABa2lDo6dPZSCVw1/pRk0eGql1lmGT6povoktnhiUmw0+/cRbqmq8k0J
         HWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757051683; x=1757656483;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0cJohvp9kS6Dy0gG3oznzgKLJkz7v0dZiOFGidq8CSI=;
        b=fAm1k8bf4pC49BFteTDQXcAwjGV+74CuW+lzIO2Wu2413zrGbu1wdsdKSWjbgcUV4A
         3g29yfnO4R4Q8LZbBDOfvpOgQMIkGyqowoAAcPkRBGrR+HPUbae4UkPZV4v9GYjHnLBg
         NxB1/0okr6thRvpC/vDvF3WMGSKv5UxF7nOsbDIuQw9dieuU5SWKG/cB4aW/Qxp9VfNl
         OMg/Z7Hzf5HErAnlMvosKuxcdgOMl8twqbNQLYCcVkQJjhurExAEcLVb++qjs4KUkcbi
         gVNAwqhX181JZ+WUlI/P1j1cLUPlP5PJvtFoBsBndUBGDkBjgZ8j5NShI8ZV4/qzzHwK
         W7vQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXq9nB7XbirovYu+CEskvvky9+fFBRdpPgQq/yNbwCEIyXoaEMkpkivMd/g0pzMYKUyUPcXhKxycNv@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0mjQgVK//i74r3TDX/hplNcQDZNFMf5rsZXNRwaBef+uW5VdQ
	rKIu68JgFZjOG78mbivWO11mkxUgS4mH67Ht+eNGei3QwVOxCmrh2c1/vnhTmLR5aDU0JizDxvy
	vu+pWmUHvMzIwkPxtUfc3EKJHo06brRU=
X-Gm-Gg: ASbGncs6HJLzUQ0nqpMusBbpHmYWFLqzrKFjx8j9mKOKDMPK3PnHak6ggF4L1z0xSQt
	JrRc8WoU0D1EDPyxLAQgd1seDV0jnJDJIX3irfSqPUyARjZEhHimfSqeSh/HW0q3J+1DHSlD2Km
	ycJnbRmPJGy0RmdKzy6QmV04rst50JjqZMwzUm6YA6UDjTjbfVXfKh4QLcRptSpGrDX2tFO2Ezz
	DzluA==
X-Google-Smtp-Source: AGHT+IEsb+6PIQYB5bzo4CJE38rhvp2aU7Z33D0BM4wu1ZQLqQ+SQj7/CxAt6OcVcf27PuOTz2Ng2YFWfNlvodNf70Y=
X-Received: by 2002:a05:6402:2349:b0:61a:9385:c77e with SMTP id
 4fb4d7f45d1cf-61d26ec4d13mr19995000a12.35.1757051682673; Thu, 04 Sep 2025
 22:54:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 5 Sep 2025 11:24:30 +0530
X-Gm-Features: Ac12FXwqLdDE0bvQHIU1ffwLKNN7Ozy85An8wpwpFj7csuU9HXrIEvZY0FbFthU
Message-ID: <CANT5p=ofG-CQF_Rmv15+HAe0Jd1u1r=uqa-nYyDFOBOJ-0-jng@mail.gmail.com>
Subject: Growing memory usage on 6.6 kernel
To: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.com>, 
	Matthew Wilcox <willy@infradead.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi David / Paulo / Matthew,

We have a customer who is reporting a behaviour change in the way that
cifs.ko manages pages with Azure Linux running 6.6 kernel. This kernel
is generally on par with stable 6.6 tree.
They have a test program which simply opens a file, writes to it and
closes it (it chooses one of 100 files at random). It spawns multiple
threads which do this in parallel.
They reported that the memory usage keeps growing and that at some
point, the VM becomes unusable.

I checked what's going on, I see that there is no memory being leaked.
The output of free command reports approximately the same available
memory as it runs. However, I see that the "Inactive" section of
/proc/meminfo keeps growing:
https://man7.org/linux/man-pages/man5/proc_meminfo.5.html

              Active %lu
                     Memory that has been used more recently and usually
                     not reclaimed unless absolutely necessary.

              Inactive %lu
                     Memory which has been less recently used.  It is
                     more eligible to be reclaimed for other purposes.

I see that this behaviour is not the same on Ubuntu's 6.8 kernel. The
inactive memory does not grow.
And on the same 6.6 kernel, a trial on ext4 filesystem also shows
similar results. The inactive count does not grow.

My understanding is that these are reclaimable pages, which is why
free is not showing a growth in memory.
But the customer is claiming that they can consistently reproduce this
issue and that the VM goes unresponsive as this memory keeps growing.

Any idea what may be causing this?
Is there a known fix in more recent kernels that you're aware of which
needs to be backported?

-- 
Regards,
Shyam

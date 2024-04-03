Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A652BB02
	for <linux-cifs@vger.kernel.org>; Wed,  3 Apr 2024 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712178921; cv=none; b=h0R1ZjQ+opGuXL2EylCpj+GwVxbJevYRpJ0VuM3Zu3KuTQXIrqN5jT5XVJgRNygeB6bcmrd+sJjJDGIbT2blOghUZQRauOnRaWoBECyId26CAamsyv1X/aOeyAYLEnStoloVLMhcYUyb5qZjovtBjmNoCJU2W7gGTaxYmg5kjek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712178921; c=relaxed/simple;
	bh=R5gq2gmY7GfzrBYw8bWw+BivjlGtH7nliFf8+RBOGSs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=CZGmBUFmDwrgqelcqmUejNeJuNpr0m3OutRTgYTmbbyQK3z8zOnV+Pe8K2wZA8xu7OzpvI79bImnHvYNvGOJ9DS534KUc4viKLZyTGa8T5OoW8UTh1V5EFIqzLyM9YpD2VHeYfnuzuQazq5u8A/qrGrnRFdByNR6Ephq+XRgLmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fdCE9dA0; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fdCE9dA0"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d4360ab3daso3532051fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 03 Apr 2024 14:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712178918; x=1712783718; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jXLySa9ZjE24j5W5IpVSMJvF0Af3YmWqp0iAMH7T89c=;
        b=fdCE9dA0lXZYPnXldHrP0WEX6S9VB8xpG7PRVV9/ZBW/V4sXKi/MGy86XE0E9dfy7s
         0BtCtld2vr33pXPY5JNpma4lbdxTC1P1ruI7fK69ZY0HoMnRy8WTT2ax3Bso41KF1/QN
         QtZaQdlQkCSIkRgn4kuSCSCUJgjc9P0qDgldJY3o7+JB8UiUyYUC7i+ioliAhrF/90I4
         gWUFyt100WMNIq1WBggv9BRyvZnl9DsIQHw9kXak7tbq8dIbQAFjQMtzy9nh5/4ztIdg
         H870gvn6RgfZ8LB1tklwTTLEj2RkA2av0Eys0ImJ8q1WY+wqEF3JIe5PwAXRft6yCddL
         OVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712178918; x=1712783718;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jXLySa9ZjE24j5W5IpVSMJvF0Af3YmWqp0iAMH7T89c=;
        b=qwhDrDyjhyIPdCQOSpZDBG13KrfiYEjkFPAPxNCIHAQ2kdHeA8Ne0XdanNlJH9Uv0K
         VefZqGeQYJVIFq8Qh5CZYvAtQoune/c/dB83yV1V3g7muRRnTi2QOLCuuDvK4PnLXpWm
         IL5kE7w+ABiCbbxvd/GUixL9nqmX4RtMrWr+R6l2xyR4j0WbuBwGzmC1mQcLG/o5z94k
         ycHOmPnvtecFGEoMBXRtIJKbRa7X3AyF8eOFRalQkjG7HzFN2Uva7NzwDABQvNPBiesA
         KCdrsrhvchNIoIvuiJNRyY5vN+PVE/guNFr1x6ChoGxqx7/yxgJhbI2wnyVoSCa8YuWW
         6YbA==
X-Gm-Message-State: AOJu0Yz/9/ToZB1a8FMJc0d+nEX1S7PzyaEzJ5yKfSe5OidhxDuC0ZlX
	GC8uQfPa9b19Se0bpBwDwM6AWaPVKjMotG15G4VkGMARrQnlNIEDHdsQUIjNmMF30RxukI41RHJ
	b/lLJtg7qL2NszeKPdHLU2EEokGtlCNIzRCg=
X-Google-Smtp-Source: AGHT+IGwDG44vgovUjPcuJZpTvvTS06F3r/lOJNV22yvxQH9VpuLhslQgJbQ6x67voDvHoPyMr/evh0qIdst90Q+Gns=
X-Received: by 2002:a05:651c:78e:b0:2d6:a5f6:c8d3 with SMTP id
 g14-20020a05651c078e00b002d6a5f6c8d3mr486469lje.27.1712178917784; Wed, 03 Apr
 2024 14:15:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 3 Apr 2024 16:15:06 -0500
Message-ID: <CAH2r5mtcPD8i=pcnqysrdAcag-n_PTdr0Y=h99Ku=Z2u3UVA8A@mail.gmail.com>
Subject: negative open file count
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Ritvik,
I can can see the negative open file count on running xfstest
generic/047 followed by generic/048 (to Windows target)

Do you also see this? Do you see it without your close retry patch as well?

1) \\win16.vm.test\Scratch
SMBs: 1795 since 2024-04-03 21:11:08 UTC
Bytes read: 0  Bytes written: 1235222528
Open files: 3 total (local), -155 open on server

-- 
Thanks,

Steve

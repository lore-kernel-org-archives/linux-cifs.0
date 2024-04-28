Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9912AEE4
	for <linux-cifs@vger.kernel.org>; Sun, 28 Apr 2024 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714333285; cv=none; b=CePGCxnqTxRItQg1F1v971tqoPLt++gjegbcJGt2/kvAwrYpBy/mJH1A9fINw9HGc5gfglDpAcB9YjdeAFhZqzJ5xo0L8Geh2zdd0qhWucqreHBCtxAQKNmLRMzWfycPIt3v454Lq3gP7o597YAN8O8tcgdNVbNQxGzVdg1b6e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714333285; c=relaxed/simple;
	bh=aJfDMKieQEkz+V7tye59TJk604kCrJkbcDXjCQWHBMQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=RILd9yWcHPNEH/SoehkKAL2DDgGDCUe7rGsZIw2t3a9BaKh3ATG8vR3CKquwjHDEStcvpJsWSCY/bk0A91oTFjckWesqRnhRSDKWdRDgJoqsYX2qpsFudU1dYAnANcMJLTQfNksBpzy7HxHgq/oE18hFIfaLo7gJfsWQtQ4i6AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NE2ejl4R; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NE2ejl4R"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-516d1ecaf25so5191375e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 28 Apr 2024 12:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714333282; x=1714938082; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W7B77MMYlzqldg99ccBq2wH+c+UxOC4I7BCkF7uClEg=;
        b=NE2ejl4RdNOubZ3vgVOHfjtksfC8iSFgvaVa3VRfbgWDIoJYNIYVkBKIQDVyPQK2dJ
         I1N4+x353pmp1VruaQewL5zpeNJSccFuANM4dLBcgL6JGLeiYf3CYDADl6yBU9USKOv4
         ciTxVh9EC6YMBzp81uWWF92LSfpSXNSvYv3Gc4KuAx0VyDU/1viYsxqh8N8SbFofwfvB
         sC0NqZhxB+oXu8R37Xb5H584P3hGKIjiUPSxLxD/TVBQ0VVsIlooGw8kLsRDgAEOLPIm
         rT48sJLcg5Jt7v/XV01v2uHQU/EFwgmxbFXwgt4Gl5TMsMupOVohLQ7md1Fa9mGI2Qnn
         J1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714333282; x=1714938082;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7B77MMYlzqldg99ccBq2wH+c+UxOC4I7BCkF7uClEg=;
        b=VHdhcaMSilVINjjoRWUn6QwGvb7unwzpFg5FCsgdOgtvEqvf0c7CuCEVzLXZOoPRAM
         JK13dEiSTnH5XbxMlvgFIo8OHew/fImaAHxmo8yfktM50F5U0O5qFEMhO2jQZq3IM/l4
         PAIf+SyW5H9iOOGCFMkls5gkGzh5uXG5Syfd+nty+RmPb4dsY+8+stazWnYNeUINcqbF
         YwohL6ODqF23pzE6TJUvUVfkcsMNF3FuC3Cmo9NtSt3YMsUBBmdMToF1j2Fmc+u8WobZ
         nquysrxntD0q9UQLU9DuQyGZArZU26zMPO1C6B0qOZDM7bR37eLq3R3cOYRoTxmtreSo
         0RAg==
X-Gm-Message-State: AOJu0Ywqr33B882E80wjDU7Vt8RQtIFNkktmYorOCKKe0a3DVt+BZtKo
	l996JKe4A/EZdAX8cv2l54A6VJeuvgSV5s0tBQvNi1+uXKf69LrF1WFVOZPMZ7n3PPk1odudKMX
	pV0Zfoe6T+SMzwIvIledFC5Ls8TC/a5NX
X-Google-Smtp-Source: AGHT+IE6VvUGnTLqRBWdNKVOHLHKEmUQk6ZMzPtL7KAkCL9afFg8yqmmf1rDIsuZT3TRSqXP0LgsV5wU/W3tc2+AnUA=
X-Received: by 2002:ac2:46cd:0:b0:519:2828:c284 with SMTP id
 p13-20020ac246cd000000b005192828c284mr4667717lfo.65.1714333281863; Sun, 28
 Apr 2024 12:41:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 28 Apr 2024 14:41:10 -0500
Message-ID: <CAH2r5muXqpZN1mu=WAhaxXe0yRB7Rib_CaoGo3h15wwcSPZFuw@mail.gmail.com>
Subject: Samba ctime still reported incorrectly
To: samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I did another test of the Samba server ctime bug on Samba master
(4.21.0pre1) and Samba server is still broken in how it reports ctime.
An example scenario is simple, creating a hardlink is supposed to
update ctime on a file (and this works fine to Windows server and
ksmbd etc) but Samba server mistakenly reports ctime as mtime (unless
you mount with the "posix" mount option).  This e.g. breaks xfstest
generic/236 when run to Samba

More information is at:
https://bugzilla.samba.org/show_bug.cgi?id=10883

-- 
Thanks,

Steve

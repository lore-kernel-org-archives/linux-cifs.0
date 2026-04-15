Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F0E1E5207
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 02:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776220520; cv=none; b=SqHnlwsj7IbRkCxny79eOD5uFc/coCdcbWrN/vUDU4ACSPOV5uDFCBH1fYPhxsRSH2hBcXjX8VEGM6qmLAYHUgeN3n/UmVnxAVVCvMcigAXoVqvJ5Rapa7lR8dy7bHJz8dcjQU2YGttytG7lfifTuYPvQ5wYKEN82p+/fRPZBJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776220520; c=relaxed/simple;
	bh=xeka0KvmW0KAbHvVDC8a32jlEsRKOARSuGKLT5F++WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7sUiUdd9rm9o6VMHDRHgGOhoyODPhrQxNkKPgroLG8eHV1keKPPw+mLH5MtH6p4jeWgFU1lo9/9sdW6EMJk4XT1fnmC/D30SSgTBhC9yrj8zmkNwML38M0unSOPz6cumQtIngj79H9p+CpdktPFx1TIADFlCUVwnHFSSlcqZlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SoH9tTD3; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SoH9tTD3"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cb40149037so587930385a.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 19:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776220519; x=1776825319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9Ioi6yU5A1uj8bvMFYiWNJa9cXrvuP7hFHZqg7DVp0=;
        b=SoH9tTD3/2DPXifS1TJTxhDPmfHMKMXZZISEiQDuFxepqYU6UpRQiFV1qnmxXW+Vfj
         RsopHXJZ3zIs15n/AgPUtu6TqhaobGl/yhaUD46g6g2BMEb5446e/7Yn0+AKWjh5Fruj
         tVRj+SOKzmKlG/PJe5t3+aYh4xcIXtsitBEqKLZbJFGc5RBt2rfpysbxnY5DU37lIQnO
         FdWX1WKlLIIc4pH++qUdr355QCD0iG48ts1j2bbO/yb5fNf5h6FGAc5I3Blve+6b5xH2
         0ykxlIFetIbOndQxjQ5TlUuCijgvDXcG6XU8CnL1+nylnnmveFjCV9t1uk1eseYtvmCa
         wUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776220519; x=1776825319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X9Ioi6yU5A1uj8bvMFYiWNJa9cXrvuP7hFHZqg7DVp0=;
        b=BP49jUHPhgurN+w1uhZtzDMlG0SFidq2BYNRVi6gaegw66ayN1H8J4QgnNMKmS3XnT
         wZfxM04/bS9vp2KG6rTFjEIy3VXAS06pY+a6bhAhvWSFNuskeU8JFBQ6OdxBDLnshT9O
         7RQYLlEl5wtxy2PLMlxSs/jtJrmhUskvz/LxbP2WsOxPHq3ktzRd3TjkCDYfHEwR+tcD
         6sZ2ys3TXkXrqacR6JvLXLVtgkJS0xyzZp8BcnvKAHSbiek1rOW5616MkIhhhYc+2h9A
         KSl9mnZ3NsGDZDIBn3iwNDRkhbOosLu6R7aKQtq4Zvbsq/SjozDxXWBxVFtSU2tgJWdI
         Ny9Q==
X-Gm-Message-State: AOJu0YzTgJr/N4qLHHRJIq3osVFoN3ZHiTBfUZWDE1YqO7MNXMUUy5mP
	fB6MANUnCd0nem9EvXjI+MUPwNUw6mto/9c5UDaZsrNxX51gZ8TcZNpZ
X-Gm-Gg: AeBDietKxcXQdLpTSIULQ5G+y9UVDNfU7K2FW1EBL+gMxJHLIwjQHOp3oHd25TSfevN
	XxWl+Lz9rM/8Bec96xR02Dh9iChbmEqAChV7QodZ8Cxt8xKRbN4Ci8zb07hf7EM9vuxb22C9XRe
	WpJlH8LggVfYp03N9rujSnv1qaaVFdK9RBwvoL2mrFGKihDjjSYlN39hr8aQ6qFE61nCLKcrP+q
	oWDDwqGXXtSLQiH5louMaBlHEQMRbTTCeTu4mbi4GsVCf0jSlnVTwgcyDzL6KSO/F5Up0osE5Nw
	9DJt3jn6pWV9GEWBYGuMOqOdcExVUWdh0f/3Zx/Y/sKLwD2FbeM9uzJYClBoERfBmQAEn4W9JOJ
	HbZcY/nOtpmY4nHSRLKVbMpMAA7IcNr4BGla+ixq0kWMkefVnZ0Dln6bHc8B0TLtOho13LXLCay
	uSQu0QRIJd7gdy+5k4j23MU6R3DCcgEndmVqokIRAQbL7i9K7rh2jBASYJOUGmGlEWaoc/4M25m
	2bsxAxf+b8NlChzLJ26+hzq0drOSvQ=
X-Received: by 2002:a05:620a:4606:b0:8cd:7271:65f0 with SMTP id af79cd13be357-8ddcfbafb9fmr2772166985a.44.1776220518435;
        Tue, 14 Apr 2026 19:35:18 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e4ef33bc4csm23957085a.12.2026.04.14.19.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 19:35:17 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ksmbd: cap response sizes in ipc_validate_msg()
Date: Tue, 14 Apr 2026 22:35:10 -0400
Message-ID: <20260415023510.2659606-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAKYAXd-zwPuES8PdV+XQjuQUemVKejayqY_0aYS=88uZ=FG9+w@mail.gmail.com>
References: <20260414191533.1467353-1-michael.bommarito@gmail.com> <20260414191533.1467353-2-michael.bommarito@gmail.com> <CAKYAXd-zwPuES8PdV+XQjuQUemVKejayqY_0aYS=88uZ=FG9+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Apr 15, 2026 at 11:00:58AM +0900, Namjae Jeon wrote:
> However, on the userspace side (ksmbd-tools/mountd/rpc.c), the DCE/RPC
> response builder (try_realloc_payload() and ndr_write_bytes())
> dynamically grows the payload by 4096 bytes using g_try_realloc() when
> preparing responses for calls such as NetShareEnumAll, etc..
> This can cause share enumeration failures on servers with many shares.

OK, thanks for explaining.  Sorry for missing that context.  If you
are OK with it, I will send a v2 that drops the cap on RPC_REQUEST
and SHARE_CONFIG_REQUEST and uses check_add_overflow() to just
prevent msg_sz from wrapping.  The [0, NGROUPS_MAX] bound stays on
LOGIN_REQUEST_EXT.

> You don't add the check for KSMBD_EVENT_SPNEGO_AUTHEN_REQUEST case.
> We don't need to check resp->session_key_len and resp->spnego_blob_len?

They're both __u16 so the sum can't wrap the unsigned int msg_sz,
which is why I skipped them.  Happy to add check_add_overflow() there
too for symmetry and clarity in case anyone refactors.  Just let me
know which you prefer.

Thanks,
Mike

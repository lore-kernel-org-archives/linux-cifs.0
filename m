Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EE5345ED4
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 00:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785544177; cv=pass; b=O5UN1vahRv76TQGuZUp4zI3LF8ZhgoW1VkBpRkdO0ZPJ6KMtoV588OxdyDnuhaePN8yXKlA7Viywo2ZD3HOCZOZeIFD1hRyV+Omh0fjMSMUXKfe2s1cEeJIUQ4I9wqYP9pHugVkfH0ByJL8xR0DMwQqSfrQbKrYdZ//H+cM2Rg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785544177; c=relaxed/simple;
	bh=iauVUNO+Nbics8m4rx6NvcHPKxz7LKF4u1b9cC6/60I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=HZ1EKXfycHE64EYtomhKZzm7cPIZRg3/WMo5QTOULOJM9ledTnMK6Dp0y8arSsAHCnnuuOw0B6UbOJofWZU3m5dHwOWh41oy6z74C1ptwHznEawXA5UVtsybE3xZctxL627t3mB/xnpGtNTeHrXMZIKrxivKJZ3O7S8izCOwnT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORPYG4a/; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORPYG4a/"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93108a3c326so157139385a.1
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 17:29:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785544173; cv=none;
        d=google.com; s=arc-20260327;
        b=hiImsjyv39+by8Rpi5UKdXLib3FvjaviELmWr3TZ5cxaonSFxnKvCcUTL2DT0ciV9e
         eh01NWsI7UzRuXNerHZmQo/Xzz/wOHa+BiAIPiX2mdw+wNW/ppvqo/B139lzwYDx6i72
         nD7aXaMnXwLn6BEnlf7gMtnzLBU8GRZa88O2kI7i0Xfwj4mqBSSLtyyvnWIRiwvQAm4r
         0BYJXRlcGWlgOR6ruYSPIbnolqwiQTMa5Z0MEGpXUcEV9QrsSgcTqebf6Wi7QZoHAAmu
         gOlgT5+sD634pLfv+Mp++pgR/eu92DDBUSVx7BBz5rKjOfd3wEZOKE1vz/5TEM1WJ17F
         ufVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=VAhA0T7QZV2lDdEHY1dwArXhoIxsc2RN768HRp8dPk4=;
        fh=oQ/Y0vR6+jPyXkefXR8Bw6Z5kTieimZ3VL92IkjEPRw=;
        b=GPgz3j/s8HxKjSqvr4gVMXwC6ROqJ/6SvgoEOF8kqGVWE9Y1U8RBysl2Nd9HWRV+hK
         AbQMw7iFQUmj3+HuxdzY0YeoiMRyJoTahhSLGB7LkVWw4ijG0LsW+SzUV4b8AYQNHuu9
         0vJS65fkruZJfL/xqY0YmAnujVgxwy4/v7U3pHNWd60ErCrB0jt/VKoFbUQRM+8yrqBF
         Gsl3sAj0tKtSrc6SbvvrSK5sPHBv/MfNuYyz7ScxnJgwkjzfEqZpitCTTW2Pf7RWX+T1
         zTpjP7K6LSC1VEa4Do4scf+nEEv+IEIFRQDdgv/bEvh4/ZLxwk3RdJEdrPfUomOdyqVR
         ++ww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785544173; x=1786148973; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VAhA0T7QZV2lDdEHY1dwArXhoIxsc2RN768HRp8dPk4=;
        b=ORPYG4a/fCbC9Lp92f4UJZr7HqVSC/2Oh+Z5Fj9sx9ZBr3P2HKzQoc02txgHwYGvPu
         1QgcBYWGEUDwZ8BlZtKs3NYxS4u5IYaso6XB6ka4iTknCJSDNczHfjs9+xMfINjqfUcf
         50elctO8JbIq6nPIJQ6OQHmN/KSt6lKCmE/aEFH6DYCKnpNAYS6I5Q8nM3WOg/5uudeq
         CAMx/0tw877u3mFVJ60yj5skrw8674S19IZgfWwr3TlyDz5McosN0zxGkG2vGf7K1+iZ
         wrvhOXT+sZ02wJIDzAfH76WTnJ1QmDRJOqyT/LZ4YDEPlYmeW9SVCnRP7O3qZrEEP6ds
         QB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785544173; x=1786148973;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VAhA0T7QZV2lDdEHY1dwArXhoIxsc2RN768HRp8dPk4=;
        b=gAA5n7/v38u9YVIBYBM8YOOqoLAVhukx/QIrIyLNGiGAC5F3wcu6AwZIwGUofK+5w0
         IhFypY3zG53wsFNMI92WTQlepGNsvvqeuppdqVydzvyQXpKwylY2nFZ2D9RcQ+5rOhYM
         dlQXJiJco+rfB742D8JOLu0vqtQ3GFJ+Yx69+Qy29USGf0H2LA4zIngds+EIR97RYSFP
         euT/xup1ntPWQffLTnlFrTJKJR5hucGppJL+VgV7C5cKrC1LoAEqpGP858/5IlQkH2DV
         SVxUB1ON2EqB+IXRfRZrMaRdIGuLJgyXBEJwIHG+SXp4ScDyiLxY2KedRCupAmBs38ZF
         zi9w==
X-Forwarded-Encrypted: i=1; AHgh+RqXBwNbnUuXD3yxoA5WxowGlmlJJGtEgU7m1bTK06RUSL1ouhSEUqfIe5XZcXqbafTTUOfFFZRwnPK1@vger.kernel.org
X-Gm-Message-State: AOJu0YyFf/gevgF+e3+5xhAyGLGKRLnzzXyuTqJviSYg3gC6xt2nyJXC
	U6rEtcMW6YBT7lATgbAEzdE5gjuIcXsfpLG0Bm1S42G7AgLuuuJ7qu9rkpb9EttvdVO3SLK0tTQ
	X6oCQYYIhR9h7cgiQvW3FISIryQ+v0UqQTqkN428=
X-Gm-Gg: AR+sD117lloKMOnrNQgQaXY638lyqVAOmbvu9XciVeNkNvE+TjU7w2mvUZpUkAoBh5W
	TgD3ROnwdiNvmZubTKHxriutXQcLnoUJPy3vr5zC+hi7dyvcXU+h5FmIyM7KUBrYWs6wE1jt/Oi
	ANLPZaQTKBfBucGdmTAe8OsU7zTkk6iVtnkNmt4yGQovdRK4FO+O/hAH5Bp4BHhJ0rLs+4afgXs
	mArt+Woky3ROqHYIyLK2oNLwJiXorIQ61Q4y6g6/dxDTyrl0cyYCEOu3R6zdigEhJS7tfHqOV7R
	pjkW5FuE9KAZMBLO5nuiewuLXc4btd+9gK1ZJ4bjQCQj4BI/bAB/OyzdY0/NRGFAAtGZhPbX9+P
	KUrSRYTT9h2fTDVl8SMjqgFHgF70LzGw+VIjqGTBhg0Dc8zOUCElSqJDF1AKbumViaZZES6YJoO
	vEnGfuO8APZmF0svEf3S6yQr4RlxdyRZ5hQBLeKxhgg6zDl439TR73E2Dy4Yw=
X-Received: by 2002:a05:622a:1e10:b0:51b:f992:9e18 with SMTP id
 d75a77b69052e-52b4c434166mr70742761cf.2.1785544173133; Fri, 31 Jul 2026
 17:29:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 31 Jul 2026 19:29:21 -0500
X-Gm-Features: AUfX_mzdq8MvhwSLTfarZ9nnffCHS3ALJcSg6jt8gIuCAqzrF2nn7RLSE21iz-w
Message-ID: <CAH2r5ms7t38Yx5ryMJtMSH28Neh+sKQPL0vmW_3hHROVYmqehQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f5098b6bae761e346ebcd9da7f95622c04733cff:

  Linux 7.2-rc5 (2026-07-26 14:45:48 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.2-rc5-smb3-server-fixes

for you to fetch changes up to e8bb506e6ef749ac0336f3e579d8d02396b7d832:

  ksmbd: use memcmp() to compare ClientGUIDs (2026-07-30 18:45:57 -0500)

----------------------------------------------------------------
Three ksmbd server fixes:
 - Use memcmp() when comparing fixed-size binary ClientGUIDs, so
   embedded NUL bytes are handled correctly.
 - Reject repeated SMB2 NEGOTIATE requests after dialect selection.
   This prevents preauth_info leaks, enforces the SMB2 protocol
    requirements, and serializes negotiation state updates.
 - Fix a use-after-free in __close_file_table_ids() by removing the
   volatile file ID from the owning IDR before dropping the IDR reference.
----------------------------------------------------------------
Namjae Jeon (3):
      ksmbd: fix use-after-free in __close_file_table_ids()
      ksmbd: reject repeated SMB2 NEGOTIATE requests
      ksmbd: use memcmp() to compare ClientGUIDs

 fs/smb/server/connection.h |  5 +++++
 fs/smb/server/smb2pdu.c    | 14 ++++----------
 fs/smb/server/smb_common.c | 37 ++++++++++++++++++++++++++++++-------
 fs/smb/server/vfs_cache.c  |  2 ++
 4 files changed, 41 insertions(+), 17 deletions(-)

-- 
Thanks,

Steve

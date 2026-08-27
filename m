Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C23D5C15
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 22:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787870310; cv=pass; b=dM6+w1DfZzMu2DebXJUiRGf5Gz+UNRzwSkImHTv1Z5DFyswUWQ30Qpzm+/EJ0pdk+1ygKzpRD2Vz/4mHKbwKNyNsqOXApalWblK1z4bEnVMS4G6wExqT4Aj7iXSbXCEF+5141cWjXyY+Cw2jZXIgETeFuyQlJX61yWDRE/sv7IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787870310; c=relaxed/simple;
	bh=k69LAyUd2EhfERePMxgNBmw6XQPxeDXOi+XkvEPB+oo=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=tzLS4E+Z+5XN5GZAQ265KJzKoeZqynmfHII9hz9K8hQgs1skZbKtRPfm9Xs02k6pqx2rI9J93cqGSS1WB4vFh7F9b/TaAQh0Zj9EGK97bzLZSJ0uPKBEbE4pVrXAy4uv3vc8Gr9QRLSPMWFmneQaxun8nKwgzxPLFmCbW0PiWLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=ij+mDDEG; arc=pass smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="ij+mDDEG"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d712281f8bso4361105ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 15:38:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787870298; cv=none;
        d=google.com; s=arc-20260327;
        b=NRq2l7oVtXqKAUZoehJHr0ApXYXtfFVkGsq+78FIVoE3o5tQVsBz12D7gR8kZoDK3f
         H1HLk/aM0Gn0pIfQgEZFSUWeU6USQcwld729xGYBfiNYcdU+scfs5lwy4TAjxFldOGac
         IHFn8ExrY7CAcknViFot5cfWRqWkLvMyNzfdOf+7lIwgAafIrZMR28tol0wp85X/9bYQ
         LOnmLzn1bzB5CaV7XB42SHKUnqtnuiGy9lUU1p6nnZ2YJZ5RLZNEzBoiC/J+gWvXbY8E
         5KTUE4qrVCvl3TxnNX38mtP693Ty97FNbk3Qi8wUWIpajYeUBrhqHuO6z56eiBTjrrDk
         iddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=ATd3DQpfc46IHXiTuWBZnYKSQ7jENEHOCpn+E5KjLkU=;
        fh=dXBjrL3ZqQdWljphbtEVJYKnVzh7tzrkQL4EiV8/e0s=;
        b=eHV1O5BPMi0yNo3afw1SeHzT3p1q1xOoTpiKCoP6a9WNgTrcUj0jh/LsqjqiZ1fJmz
         NzCerznJfbOSkocnhW0D3u0EJcbgzkBiUsHVArwlhdKgkbVrhi1kyPYrGR+i7bzxcuRj
         IaOnwzuC+h+HkiKmqi7uSTGOy1bY5QEEb9ljATh9D6qGNlpSaWE+r8Fex02AoVc5E3vI
         6Mwn+Blceu5CXtg+WSNyOOqvbk8JGVp79KerH8NAnpEh36zIk6azUlzHINetBoOrENdD
         Bo8FyZuHFU1kkPLgC/0DFQQ5u4wHgf+eTclvk3Md8rLw1YTsobwO0XMiOLbwJlCXYhkq
         dN9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787870298; x=1788475098; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ATd3DQpfc46IHXiTuWBZnYKSQ7jENEHOCpn+E5KjLkU=;
        b=ij+mDDEGDmB0CRfIdIkuya9CI6xedmKvRuaq/eICaP+6RY8cqwyRbtauC+2gVAVqH6
         4EnU+LVTbsUnSjwTYJMsnZ048yMCqZMEpegXDN8HHQhIqWaJpOzhsRY8YKEjIxwYcCuu
         IBItHhbk+Op3ewhqAogCL6rMBF2t5Lc+HYF8zZlDkNZJws5a11immEXKl8cZf/HCgYFs
         5LgXvS+0a4D0I7BuLzBLcUErbLCiI2LWY7OU8cZsAep1In0Ky6nzwrhNgKbFk1Rzb+WS
         xbYRnGhWViX6k/RAYrs+SUZ8EbynOQRLx1Kfuzi+V8ahriV4KdF/Vv+PNnrhkR9urcC0
         e/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787870298; x=1788475098;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ATd3DQpfc46IHXiTuWBZnYKSQ7jENEHOCpn+E5KjLkU=;
        b=WPchHWKtIfH4ZRAc9zMIF/xTC0P0DqASjuO5fZU519ju+uTWucBZcV2yndNom4acO+
         ZdsybxyJIc+M40mmLEeOWhjSpYTl7HZOZ6KTsBMbbfOV/bv7ZPlnT4s5q4/E8DMXpIBO
         A85r4Y8NjrF99AlkqmegI4fZNMdbBIzDdd/X18+jPCdj4PbK2zZy4upwY0PBzp/4QA9r
         nwBrE+KPJpen9m7dQxd7HXRxxf7ctFdOg7jFsz6Tm/ETi/HzkQJxVF2hHQzrCFTFF2/i
         QCh56lazJdbA0jeWHXvbYiEq05HVm5df67fPaU2ZEkb1bMo7bJVKiS0dfKV0Lpv3GApN
         yhsQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqyk83bowpQa7k9yMHaZ31Sl49/LshKBNyOEOk9Lebljax4mNMTVTJk1Bwdl+kXlU1trZ2v3jQKgREZ@vger.kernel.org
X-Gm-Message-State: AFuF++kuvQZFotCA6AUUiJdrhOWqNIc/AP993W1Rbjm4fL3unOR1wA+v
	5MC4VikFjVMsXz887lc7TcbB0yFywLthDtd0Kbj2Ps1h/Lmv5kN/UNfPTaGrQbF7YfoE0ovuFuR
	JGlhn1l4W/8De2AXqcZmGjSYJKeEKk8kqf3VQeO4h
X-Gm-Gg: AR+sD13VOCM6R/odkOC/qCICTD6eOIV038nj8e3CaM8gJxJyh0w8Ll4rWu+kzuI8gkJ
	voPQxh9NoknWZ9m487Cur9BdUB+uOplZaWnHu6HiCzy9KEVpoEqlJxok+ocEZPqU9k1SkOk+hEK
	pOiMi/xj7Bup0DNbVo7oXHLTkkFTcPen7z7LyIfcGb7aHbURF2tEQmoCEFae2Th8d9bC5tx/lem
	sCd5VEyYwX6269y+X14b7V7XHZae/LhMR9/4AYf5lrxSy522BFdtxFJ0dBTHwWkECU3T6KWJH9F
	L3CpK3InKTvkuA+FAcKy398FBB/3/aKkgWbAxgzk+w/6VWsiZxk2bkT5nA6wSovvNxNtoa8uNiK
	Sg0GqwyjdmGzpQsOFk6Zr+n/0Unab5J0mV2ocEh6dJsc=
X-Received: by 2002:a17:902:e549:b0:2ca:6eca:492f with SMTP id
 d9443c01a7336-2d74df5f87cmr33868235ad.14.1787870297349; Thu, 27 Aug 2026
 15:38:17 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 15:38:16 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 15:38:16 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 15:38:16 -0700
X-Gm-Features: AcwNN1WcfJSCKizV-B518BBEnL0-ITVAR6eruLTssxxs2Tj1TY8SkIhO61iSE8A
Message-ID: <CA+0ovCiMX1XFqCf0z=tPOb2nnQaqsxG=FEf2X6CshAQ86gAYMg@mail.gmail.com>
Subject: [BUG] ksmbd: OOB read in share_config_request() when payload_sz == 0
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: falemi@asu.edu, Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Namjae and Steve,

While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU's
SEFCOM lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/106-ksmbd-oob-read-share_config_request/

  BUG: KASAN: slab-out-of-bounds in strnlen+0x66/0x90 lib/string.c:432
  kstrndup+0x2d/0x160 mm/util.c:120
  share_config_request fs/smb/server/mgmt/share_config.c:168 [inline]
  ksmbd_share_config_get+0x5e0/0x1190
       fs/smb/server/mgmt/share_config.c:243
  smb2_tree_connect+0x2f4/0x1320 fs/smb/server/smb2pdu.c:2015

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,

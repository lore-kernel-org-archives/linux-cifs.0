Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E722185BC
	for <linux-cifs@vger.kernel.org>; Tue,  8 Apr 2025 22:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744150102; cv=none; b=nI7uJ0Jex2YJ4JBJax7hp6uRusZSPKo5irDoQza/EAAvzipc3GkelMITsqjzm8CbkIomR7hxl8NV1TZvJ8mNYTFyUNT7BxcJz7fdXoghUGmr2RtDLs/M8vq98/Ah+YCI7jpHXPS6JdjwUYOYAbCoqwThUBrQC/lfaLuR1dNT/sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744150102; c=relaxed/simple;
	bh=WQBN5BFFk0whPtg5z+x8VMnaBtS758+y9LKBNOv7iZU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SnT5fAv+2GkkeXnR1daSBf/Q9wEsm5Trk47VMcl3Lx1vz9FjFTdSOjrLanlPgcm053xFpXYpZqZlDZFSTvNCYTKcLBWzSZVtTjAxqa+W42vxHOwTu8meqDm4+Ivy9TXeZXkSU6G1e2FqjRrZW16FoyZyaPBD07/PKPf/o19FCe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEFrlthg; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEFrlthg"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-30bee1cb370so54130801fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 08 Apr 2025 15:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744150094; x=1744754894; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RGGGrrn8dkMW8Ig/LN/TRCJZBhhvtDzsXxmdoNkJsX4=;
        b=GEFrlthgyTN7CLxyRkfDDeqCXeSXbmgHa+zGHWVFfRrYWWR4qw4ly4APYhi4S1P+2Q
         EU6fHQbGvGkNn8gEBar9mDGstdaIN2/vSO7o+YvcoRQBRDcy2/8XU2GrBYRHdTTsXALk
         GFjI6ld5eSraQ77cBFlOknqi2BUh4Zy6SfaOZnTeQeDc5J3h5lE3AqmCsfNKPGnRsjvK
         EF3lztPNh7CD5TPsAKht4lAETMMhTT73cATxAy73K0MlygQI1GeJjfCi7CtyHyRLBWrh
         btv+Wr3ZggT2jbZtWCddTXjobJ75sTxvZDuhRi7xSzwbBfZiXytA+rE0jpJoKT5Hnvob
         33XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744150094; x=1744754894;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RGGGrrn8dkMW8Ig/LN/TRCJZBhhvtDzsXxmdoNkJsX4=;
        b=utJv6il8Al6Rd69RzzkR0mralx9xOr5WeM9jW86CpRAIfu5dM+lt9cPjxinS4fMhtH
         HjOcyDBHBGIlUcXRExg9W6jBJGi6RDTEVX+EAINQdbSBMBBcEKXwdb81LGpWPw9WBRo0
         KV8rTmTjoE+0W/8qFI9fYyRApw7Eyldigwor4TF7Ezmsv+mtqpU0iucblT95kzOouljD
         mbAsVX6R3m8NRR7oDL9KB4jGmvCw88d+XBDpqyyAoeoUSl9c/01jwnlFiPNrQBkvMhXg
         /2zC7CqjU3gw7C8cBSuQizNOPkrMmJPMdZnEfX/PuZvNo3wj2BaWEVmVAYcmYcmj8IWq
         84gQ==
X-Gm-Message-State: AOJu0Yyk9uRIwJO+S9//mZjchDsy2p7EsiuggevWkHwoDvPzZA58FOJ+
	CR3Bu642jSd3NMNFZ+4NH3C2MsH/1F7Jtaxa5sD0/0DPrVUFbKqifVo+XxEr2ASPu7FyLnKzyz9
	quylPtJdRMhxjeSFBxFueJ1YM9tXRNQQa
X-Gm-Gg: ASbGncsrVibokmtE5fXBgqwG+1GYhvXwMH4vNpcb9jzchvpEpXbmTBTDi3o5lQ1N99m
	7u/VfngcwJv1DWVfTYKZDDB96HvWUSvHgubXOoYsK2PObVdltAxLd0nziDCMuYGOKp4uEJ/e06i
	eLU7R0Fvu3o+2Vx5dKv9maeQ5yR/jc7xOJwivl1YX7xCVw6QmeDkLc1x5m4oIL
X-Google-Smtp-Source: AGHT+IHu8l7CaCpd5GAL8kGUXhKhWVdfUzypYrBa0WwrOr5FX0Uy9xH1gMkQ7cH1VzLDDlY+Za2wgq7zJ4/8gYsdtvs=
X-Received: by 2002:a2e:ad07:0:b0:30d:b328:8394 with SMTP id
 38308e7fff4ca-30f437e7456mr1704991fa.13.1744150094228; Tue, 08 Apr 2025
 15:08:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 8 Apr 2025 17:08:02 -0500
X-Gm-Features: ATxdqUF1Nr0rQIHpQKAkGqI_Gwi0EX5Kt_SUVKjDg3nTWwz8gTY8ztm1PrqnuUE
Message-ID: <CAH2r5mvSBqF1uW+hZ+1syN=bZsqn6RPPfDgsho6FxpMgJRBHzw@mail.gmail.com>
Subject: directory lease handling perf bug
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>, =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"

In doing some additional testing of directory leases to Samba, I
noticed that to various servers (not just Samba) we are not caching
directory contents (e.g. a pattern like "ls /mnt ; ls /mnt") even
though we are getting the directory lease.   Digging deeper into this,
I noticed a performance bug -
e.g. look at this function in readdir.c: called from cifs_readdir() for "ls"

static void finished_cached_dirents_count(struct cached_dirents *cde,
                                        struct dir_context *ctx)
{
        if (cde->ctx != ctx)
                return;
        if (cde->is_valid || cde->is_failed)
                return;
        if (ctx->pos != cde->pos)
                return;

        cde->is_valid = 1;
}

The dir_context passed into cifs_readdir() never seems to match the
cached dir_ctxt pointer so we won't set cde->is_valid. On each call to
cifs_readdir (for the same directory) it looks like ctx is different.
 This doesn't break any tests but it seems like a huge hit for
performance that we are incorrectly checking whether to cache the
directory.   I couldn't find a recent change that broke this, but it
looks like it will be a HUGE help to perf when we fix this.

--
Thanks,

Steve

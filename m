Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CE1186E4A
	for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724425320; cv=none; b=a8rxUgQbqMXFDnypy25LHRT8+OhZq1sMNTHwMUJuzMXomHNsWAgtrBFejGDCWnjS/tn5ayivnI9Yo5rnK1mdh/7JAdVWx18g6cyNNkK42cL8a+PU3q9zC2vwoO90kntF2nPTyEJ0YcUfGEnfND/bahg9GUXKljmDsbkQjrJdW0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724425320; c=relaxed/simple;
	bh=AotfykdH6CKrf25Me5a3RqP7AScBl1FcxNNwjZirlmo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=lomCb5KNkLI0OB86rX8SfolL11eMEjuBqwNkqeYPEMXodthESGzGfYFB8WBQjmMK8WA5lRYfXs1iIvcxk5y77/IVgvkrBx91WLyfVXmYXisyMJOJqmqPouGPF7iU3+SRaCAhLFt/ueC4s1B6tPxmNvRLN2bzLnoB2FSuZhBnMCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dOxVTVBI; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOxVTVBI"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-533463f6b16so2438563e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 08:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724425316; x=1725030116; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AotfykdH6CKrf25Me5a3RqP7AScBl1FcxNNwjZirlmo=;
        b=dOxVTVBIPh10p1rrO7iSbJF1FMdraFIVdaF8gh8b3urtiLAiBGkIAM+C9g5ZZk7KIc
         ba2AJVM+TQNK1oO3c0RvOZgTdvF6m5eOuWhcmEziXpQF7UfRrPE2WvCJyOmFilU+zOtX
         o4dzk2IfMocpLWIaOUZYygoKWA2eh/xYC793YXTc1Vrq8XOREuhuxvXpp7UoG6uFFAF1
         krQKXN/y2iKDWfJBk7bgaZ+999yA8fGFgZa+0dLgSsIS+YZKJSoSk+GwCMF58klpHM0O
         L2MJKQ/exijXo4bG9SOu246f5/QQvdXGp8wVxZoPt4ODVHC+7i6lerEWNBUpD1EqYHni
         kwbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724425316; x=1725030116;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AotfykdH6CKrf25Me5a3RqP7AScBl1FcxNNwjZirlmo=;
        b=TfcW/G5tqMW8CYnFpXq8pmC1duEoBx71PoguNJjt5qu/AqTvkBNviuSzRWpgcAgtej
         z7dyTjULhrGJBwzSEfaFfr6MDccVaXrJ9IkgspNAv2/3x9kHhL7rQX2ec8PABKNOXSDn
         LM3TipJniaYE2YSiJjfsgr9ncff4yrR8g5T+Rj/gWgvL6cwCvFO1XTPZ9BucW6UIX9yD
         CMC2DsUrNV2sCkwFHK17J/Wwu7ZinACoq2g3f+BdtG1UP3so7GCqs9C1FpslxafKGQBj
         MEDfBhdtEqPMaYOZNeg7cAARnZx9vRSQeNNWc/AT4ZvketAlhYpve+F3kzNqiyYIR+Y3
         ZiTQ==
X-Gm-Message-State: AOJu0YwkekUAneAHsfJnMHfpbR6CbnQjS0E15fAFKg35xJaWHQex5x8+
	fHxqQptFgoqpEpGBcExPIJOjK+kFm4Da7ofLb7g4CuxFhXfPWPF8OmmEzRqeQspz/hI7ybG+t9g
	22K/YkbT/0rgKTd6bkQDFMK+OEd0=
X-Google-Smtp-Source: AGHT+IHrvIpg2noO5D/1wTXEdifs5bOXdvqHcgrECnz5AlTrdN022uTG7N9ftXqUGPpOjDnYGL30O1q72MNINzuhLJY=
X-Received: by 2002:a05:6512:39ca:b0:52f:228:cf80 with SMTP id
 2adb3069b0e04-534387be63bmr1987882e87.40.1724425315501; Fri, 23 Aug 2024
 08:01:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 23 Aug 2024 10:01:44 -0500
Message-ID: <CAH2r5mssjjgO3hmNXhb12H1q+ccTV4P+LzaL6kMwxpip6u6kjg@mail.gmail.com>
Subject: regression in xfstests generic/075 and generic/112
To: David Howells <dhowells@redhat.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Fails when these three patches are applied:
2e4fe7d5fac8 (HEAD -> netfs-fixes, origin/netfs-fixes) netfs, cifs:
Fix handling of short DIO read
e965eccae3d4 cifs: Fix lack of credit renegotiation on read retry
18993747be65 netfs: Fix trimming of streaming-write folios in
netfs_inval_folio()

See generic/075 an generic/112
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/9/builds/114

But works fine so far with those three removed, ie including just the
previous changesets:

e84d671df44d (HEAD -> for-next, origin/for-next, origin/HEAD) Revert
"9p: Fix DIO read through netfs"
4ac70f4d3323 netfs: Fix netfs_release_folio() to say no if folio dirty
e995f6d333ee afs: Fix post-setattr file edit to do truncation correctly
d1e81ad2af8d mm: Fix missing folio invalidation calls during truncation
e889c9a8a77f netfs, ceph: Partially revert "netfs: Replace PG_fscache
by setting folio->private and marking dirty"
e8d6539a578f (tmp1) smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock
0ba54fcc7453 smb: client: ignore unhandled reparse tags
bb483cdec3dd smb3: fix problem unloading module due to leaked refcount
on shutdown
e4be320eeca8 smb3: fix broken cached reads when posix locks
47ac09b91bef Linux 6.11-rc4

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/9/builds/115

--
Thanks,

Steve

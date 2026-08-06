Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F011042BEB1
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 23:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786059800; cv=none; b=CHeUksNXqLyqcJSy2pFbwEk8xqxC0oDsRezSEMFgUxpDeygYUAw7Tmf7p8MoRlx3le2ZA82IFaC2DC3mYwoNfyTum4lUtPORjGseU+BowNteA5plqEBAfWa1JwkdysOJ+++aCz3gRz0M8HaJLvmvSxgiqpmCAx5D2IdHi+QBPuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786059800; c=relaxed/simple;
	bh=/mJD4JiR+hPpQtvlsYVhs3du4R4pItBcKeIko5AxpPQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lRjZxCQgTjorQxuIvKWLDpYNddYPiuyfCSdy0y7Q/gRfGgytv6EXGuJkyusB0Y0NQnlD+1M8lbKOUmZ/8PyKosDou2Aq728W+CvD2VCfCDugtmEqPwzfQYYpFl0Lgsw9S+J1dbA6Nmy1PqcPn1LRDB0R21efm2TTByCN9mN0tWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R1g+cEXo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=htg/T90y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1g+cEXo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="htg/T90y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786059797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jYfDxbUs51G2n1rskXrCPOql52yi2LQO2hL82ijvsU4=;
	b=R1g+cEXoJPo53myvTTFlCvbZcJ+Q7abZ5DJBNFcIpR1V+BA0wSswcwGIeDb8p8tcA05j1N
	3j2K1/hjuhJHE9KPgD1YKAdY7QlYsAH6/n///Hn3E/l6vJ7UgtuWmu7gOQSA6yHHK8eVC0
	cx+XkD/y+2CO6IvUR2c1RoROMCHpQHg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-GObfLdCDNk6Hj_M9C6hhlA-1; Thu, 06 Aug 2026 19:43:10 -0400
X-MC-Unique: GObfLdCDNk6Hj_M9C6hhlA-1
X-Mimecast-MFC-AGG-ID: GObfLdCDNk6Hj_M9C6hhlA_1786059790
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-934956beec8so504983885a.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 16:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786059790; x=1786664590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jYfDxbUs51G2n1rskXrCPOql52yi2LQO2hL82ijvsU4=;
        b=htg/T90yGuCFKmH8FsgIqFxLVFh9ho8zXwKv/n5MoVqbU4rFGhcTNImhuY1RrGO2oe
         +cSa5q7q23LicVbRiF+PXKSQJJrxFGj/7yGMAIYjqXvfZofwjXs+IivoC5+KgRShxKaf
         L8LVeshT/ar0zSTiREeMJWwt6YrPwWG9lPdVRYJZ2+CoMCiB5dhH1ieympx8sE+e4Fvn
         fv/IdlC8fN8TdejJrowrikMLv8IHCAWMnz+U0Lu9wTE6ojxYPhIw30ZCnv/zCTQzt4fx
         34cbN9dN0Vy8Xe1B5BHarYrIuDPv7bUYGB7udvxsfxUTFmIyyOZN7y9pLVjTeK/VVh40
         F9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786059790; x=1786664590;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jYfDxbUs51G2n1rskXrCPOql52yi2LQO2hL82ijvsU4=;
        b=aO5uO9uv34LxU+rQqkK+geFYO4EYR/MnlMlzT98+WmcqHjEL+kKtrdkprwMl3UoqkO
         B2REL+WLAK/A+wxWiCcqUCIJIhs1BLxBTq6yF4Cs3ni00ka4M2dH+/RQBDAvIn+a3fTR
         N3qHquO5gucJ8iS9hN+KwrSJYihOOyzGxCpxtR4kYsFjTeRNmeDqaVZUpW2ZrBDnfIJV
         qLn/JuKsF4q7ffgb3sdvICsn7cua6zqdia06tqvk3ts5YkgVAWbdgK/Gk67XMhttMmIH
         RLruaEiwl6Nq8pStR3ppcxanLPlwsF2NAEwgLxC1RX98FSzjM/yKs2Vc2vAIyawqrUWx
         Pmwg==
X-Gm-Message-State: AOJu0YxP1xtaQiwl9vyfMyIk/R/LcYvlRlxJO9CW+56Ur5ChTgnELfXj
	a4S0MDbIaBMP7NG6ppph5F7erS37Z8TXrYoMvbyynO3QJ9kp2cmVJBuQzNSw9BO2D8TUNMsgTXF
	8NuFjc9BdrTpvLA7b/0KyGkKC9f713MwhNNHj+fRFZOj5t/akS2nT5MJ3iH6NzRH5MxyPtmf6pn
	1z/5WZs3tsWf6pDC3Q+xpJw+PzXY1TZwr37AzcjqtCYGI5n/M=
X-Gm-Gg: AR+sD10zHOmVQb0rcoUG9cJvaWA9sKLjPGipMp400LzBJl9Zzds4nkVm9IW3Yben3WX
	uFdcLlr40GgKV0IFXSjO/SR6sY/HyQKQzilrHmk9X3fB4OvAhIKFEs7onh9Y3Lnr7lQr6osYhSu
	/KlrkF3ezdCd7H9BuKR7rP9P9loxMc1zHVH9cgXx7VUYFPo6wK6CF2SOjF7pgMGioPcIzEJdVUG
	ZTvs2MEC7nIpaUbf4F/9tR+DwKl4k91U6RbzYmA2Z0PK+zwi9XWSDf8ExAjI+BIg37wCsfrYgvO
	kHSohytz00F9UoNMciF/Rc7xXqKyuTnWdouviKa+bxp/TUP0IXm02OIOy172bDxYSplBVPIS700
	LZKjlAZmlPb5K7HjrtkP/HhJIXuqku7uQ+ICoFvPQYU4I7lGZvhPtHiuvZ6P2Zx/RKA==
X-Received: by 2002:a05:620a:f07:b0:92b:32d4:4af5 with SMTP id af79cd13be357-9366640244dmr577637285a.5.1786059789909;
        Thu, 06 Aug 2026 16:43:09 -0700 (PDT)
X-Received: by 2002:a05:620a:f07:b0:92b:32d4:4af5 with SMTP id af79cd13be357-9366640244dmr577634985a.5.1786059789433;
        Thu, 06 Aug 2026 16:43:09 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e03f05bsm26891485a.2.2026.08.06.16.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 16:43:09 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	pc@manguebit.org
Subject: [PATCH 0/3] cifs: three size-management bug fixes
Date: Thu,  6 Aug 2026 18:43:03 -0500
Message-ID: <20260806234306.3662175-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches fix three independent bugs in cifs file size and handle
management.

Patch 1 fixes a use-after-free in cifs_file_set_size(): when the
handle-based set_file_size() call fails and falls through to the
path-based fallback, tcon is reused from the cifsFileInfo that was
already released by cifsFileInfo_put().  If that put drops the last
reference on a tlink that has been removed from the tlink tree, the
subsequent set_path_size() call is a use-after-free.

Patch 2 fixes a premature i_size update in cifs_do_truncate(): when
no cached writable handle is available, the server truncation happens
implicitly via the O_TRUNC flag in the following cifs_open() request,
but the current code sets i_size to 0 locally beforehand.  If the
subsequent open fails, other processes sharing the inode observe a
spuriously zero-sized file.

Patch 3 fixes a loff_t underflow in cifs_remap_file_range() when
len == 0 and off >= i_size.  The computed length is negative, which
corrupts downstream arithmetic and sends a huge ByteCount in the
FSCTL_DUPLICATE_EXTENTS_TO_FILE request.

Patches 1 and 2 fix regressions introduced by commit 110fee6b9bb5
("smb: client: fix missing timestamp updates with O_TRUNC").

Frank Sorenson (3):
  cifs: clear tcon after cifsFileInfo_put() in cifs_file_set_size()
  cifs: don't update i_size in cifs_do_truncate() without a cached
    handle
  cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0

 fs/smb/client/cifsfs.c |  7 ++++++-
 fs/smb/client/file.c   | 17 +++++++++++++----
 fs/smb/client/inode.c  |  1 +
 3 files changed, 20 insertions(+), 5 deletions(-)

--
2.55.0


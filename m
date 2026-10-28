Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211158;
	b=OdgqV3M1m3OutEDVXzZ/G0/wV7pthFeoRUEbztV6/KYxXcYV+uSfBZeINCfJfcacFnYs
	 yPIQasNkXSf7EEgJQTNg4M+KuEOm/2/FKnZ3N0xyAuVDNg0XgMPa/k0bwyB38l67QerwI
	 qoGoriN/v3YyKH5Uj3Yh5F5bRBdNp96b0gx4tOuk685plVLX8HuqWzW5HHL4UVzJ5+y4M
	 ZRVL38B8kSMrQy+7q3na/KdIN5ASHrR2nTR98jmjwIKRaM7U0FKrAcstGMvpvHF6MY+6T
	 g0O1dYfCMT8hNAFJAihtdU3vaHHZDaduxMGu/lXUTYQZPU5/OXW4ARuMDaaSLQXE6Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211158;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=q0d6qWi5B+qlp69DsFDkPKiAVkLkzeJOiKS+6AQfdW8=;
	b=0JaKMA3sx+7jEo8bQU0wgRK9tyxu4rIF4iZJiRCEG/cFH8vnjxFaf0p027xEqTbMGoGc
	 k8tnLLlNTF0tyj00O750DhIFY8FbW+/fhezZudEOOL2xnWS2YCZ1iJ4hZfKwiSgQCkkXw
	 b8C7/TRJiXCvoHzF00zddbM+yp8JNw2G3QgCHdz/+NiIVid2fnpvkVUIsgZK1EdPrbGrD
	 0kQdbCRHV75WOck49V9VVrSQzrfqK0HXvWZhJ7ARO7RyH5jw4NiY+xWW0QLxLD/3/QTcZ
	 IF6ZkU2dPJg/Yd06y/mKXydM0aQkaY/eA9GWXFxNLS+2Wgz2M30JXoAJmao3vVQGByg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MiYCVVyd;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E197C60A2612
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 18:12:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E197C60A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MiYCVVyd
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3514b90bb89so2459096eec.1
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 11:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793211157; x=1793815957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q0d6qWi5B+qlp69DsFDkPKiAVkLkzeJOiKS+6AQfdW8=;
        b=MiYCVVyd0iUPLIbBaMBLfjLz9Pyk+GNlyEwErmRvOBMFSxaTqWEMpXfsAAUmbQKZWi
         IgkOLYW4JN/ahhmD2MJ8B1ZoXPhIdvr+R2VqdkldusRPsQw8FRvE9//JsMF+XG41kPOZ
         7E66ijleJQzigTjB4riNeiSPqAAoD949EqH959h6pptjo62UWrauiSITdVT9caxTxoht
         dGBKljUrs1X470XcmMSpgxWJ7MzFfdueUQF8sA4tcnhaYdy4gr5a1AWh65NiWfvygbC+
         oIfgJ2HUxC28k7uBmSqBj3uyXqcX+SwOTfbJRzuJ4uKGjU67wrX8G+4i3R4QSFL200uz
         WN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793211157; x=1793815957;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q0d6qWi5B+qlp69DsFDkPKiAVkLkzeJOiKS+6AQfdW8=;
        b=h3ypbW28MvejKtcgaLexdwzLj7Y7ClNHTyFNzZTdqR0F8bpeqE5bq2e6VC4ik93qiG
         N2XuryCyTioQ0fHzlyVDDNMlH1Dc8I27MP61PCYxEpTjPAFfqIW3S5+KHQ1NI7dCCuqu
         qrnhBxcu3Pch2U0aTW/HNn+ygWgpy8kdMpH+WfjPwlfO97B91c21XWbiEBie1UgFE9Sy
         EJuI8Px35pkJRkPB2Um2DOx07UyDYarJr7bpKyvcpwyqpY6ChXLrbbLWAeaqdG3Vz6Zi
         GAr5KkMZ38l9lJ+7Z9aaZLuCqrJpylJFZZHzECvqwp9Y3IYxn5il+A1TQOUSP8QhIz5O
         Klag==
X-Forwarded-Encrypted: i=1; AKwUvBz0y4ibGCWxhRtQ4ahOtbCYch3iRfCEHZbvJFNJmWalZKyPVDbGjO3/j1qZwmd10bhRkYFV0KprtvPL@vger.kernel.org
X-Gm-Message-State: AFq9FYJfGoT2mHEJkRUgB1RMQFgGChv7sOpe5pTbNx1H7c9X8cu1DFll
	/l/7zVqxF4pznLNTDxs3cVZWrMoXqudni7mWL4pEyRxEcL8fj93lo7OH
X-Gm-Gg: AYBFou0ThcBnZLSRF5FI9WkUWZmDNFOVIK93QyDEIHYX+npjy4Z8ePYFjC+J0SFmFJj
	/FtRNK59gn8ARHxVhgEP0Ubc+4zdxpvzpRJb0ppSoU/XcdovMQXEpCCgjpD8kk5QRvmSEIHsTzt
	tU7GPBh4oS9C+8sRCyp5h2ayOjiv+Ct/UNRXcPeWX1cGIJPIXVZkIfEZgopOlgx3pGOUrS2yn6p
	8uSvTGcOCNpnGZFR1P//d+c2X+64um9JSOQxJr69EbvWEhmjiRp8YUMVZ3pYnVQIDR+z1lYbX6F
	5u5On/qCTZijVepY7jNkbLOnVAq+SofaHdyeh0+eNzMj0tpDnPjqi7RFxSZFhzI4XYghhqLsuQT
	9RWjA/95lNE0dNrDkJEiGQPVNxTVR9BDdlgfEHirch/jl520qh+vqWhYBunr0kQKSQOK+9LVV9/
	BwYwu27Lmp2tmhmHisCWpGLV3ms0WXKCjwRboR/0T0RdKDWNoLfmZ7LHv2fQgJWJOhK81xtXgNg
	TutwNhh4eGdXlGAEccgRIJvTeIMEpdTBi0Fc3ULQOFtSktS1ZzsS389B9u1W5y5qgSrq3oQgxtr
	ELlZWq47HvKEMlSnfDyQb9L0
X-Received: by 2002:a05:7300:a230:b0:369:a113:7578 with SMTP id 5a478bee46e88-36a1ff4734emr3881706eec.1.1793211156240;
        Wed, 28 Oct 2026 11:12:36 -0700 (PDT)
Received: from unix.. ([181.229.23.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238da675sm8309394eec.5.2026.10.28.11.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 11:12:33 -0700 (PDT)
From: =?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH netfs v1 0/2] preserve prepare_write errno across write reissue
Date: Wed, 28 Oct 2026 15:12:27 -0300
Message-ID: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

cifs (and others) may fail in prepare_write() with
netfs_prepare_write_failed() before write_retry calls
netfs_reissue_write().  Since 82e8885bd763, reissue clears
subreq->error to 0 for a clean I/O retry, so a FAILED subreq is
terminated with 0.  The collector then does mapping_set_error(0),
which is a no-op — writeback errno is lost (not an infinite retry).

Patch 1 skips that clear when FAILED is already set.
Patch 2 adds a KUnit stub test: FAIL unpatched, PASS patched.

  ./tools/testing/kunit/kunit.py run --kunitconfig=fs/netfs/.kunitconfig \
	netfs_reissue_write*

No prior lore report found for this interaction; surfaces on top of
Shyam's NEED_RETRY change.

Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Steve French <stfrench@microsoft.com>
Cc: netfs@lists.linux.dev
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org

Iván Ezequiel Rodriguez (2):
  netfs: preserve prepare_write errno on reissue
  netfs: add KUnit coverage for reissue prepare_write errno

 fs/netfs/.kunitconfig          |  3 ++
 fs/netfs/Kconfig               |  9 +++++
 fs/netfs/Makefile              |  2 +
 fs/netfs/write_collect.c       |  4 ++
 fs/netfs/write_issue.c         |  4 +-
 fs/netfs/write_reissue_kunit.c | 73 ++++++++++++++++++++++++++++++++++
 6 files changed, 94 insertions(+), 1 deletion(-)
 create mode 100644 fs/netfs/.kunitconfig
 create mode 100644 fs/netfs/write_reissue_kunit.c

-- 
2.43.0


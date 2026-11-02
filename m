Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632026;
	b=HjRCo1ceM393aOClSy3S6/JWugPdCqHyxXuHeYLsicAkhf9IHGdTO8qIuclMjK545zir
	 e+tXdM5miWQIBpnvYPLB/OKI6nOKqGvZYxQk1ZawR3w5f2a78jkrAE+FIf2j/4WAY2/aH
	 bpC/+K5Hz2WxI8Q01gsD/e0jmxnxhzWNo9QrNWaE7YSbIYjTuG54nhzw9coFPvIDwJy4X
	 YMm7xsPQOAKg965xI08GXKH6VKv/+L4CmyxaBP7KZZZPTY8MJcxBUEY+4KHyfUH76urFc
	 v/7HHcvh8igNEYUVra5EzxRhYIt5vhLdA60tzWapnvQVrMJxckNqce+PPxNaecy+/Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632026;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dylFydTJD2AJSyC001lOFTgMCOP2ZnGzBFoGx74ahLY=;
	b=IpOktEB0mOT2lD36DoCS5JhDc0+iYwT3wbKnY8vp2VhJITcAOn3tKhVka4+nK/0FJIp7
	 c1pCUC3Qfv79CW1jJtmN8BUKIVRhuvABTsNIUdxmrDnhtAGOp01UDcKGBDvCRoTJMVMux
	 dcypgps/Jum8+chdfgA5F9BMAbmp3EtzdEpMqamCdQ4biMNHdkJnHOlY30GyoST8Xahac
	 l2x1MK1bRiuHjrC1gmXw+1qfPD5CgeGCpwZJF0IdHATPXSZtfWmBxBzIHZ9fPX0LXwgft
	 3/Y8hNBDo4tNwwpC7ZkS/exqr0bfUzrm21Ik9igyyQdOK/eSqTcCXr7B2CKse6dHLMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wIFPv+69;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2336072C42
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 15:07:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F2336072C42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wIFPv+69
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso24659585e9.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 07:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793632024; x=1794236824; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dylFydTJD2AJSyC001lOFTgMCOP2ZnGzBFoGx74ahLY=;
        b=wIFPv+694wyrg9+1XM8aOK8Wx39dCR+nB6fK+nMApN+7HUpoJctTfpVbDN4G/0e6Gf
         Ah5qfgFWxlmfXMnQSLEI/YRxyDPVKlJm2VSdx0MUI2IzTjd6MYmWs4odw6r+1RqvJ111
         oyjvS/JGjcAYvxtCDBjClRA54yveUkLx9JixEtSNtDW+n4MlrlTKOTULAgm7yUGXv8bO
         XjBFEs/aMJzunIzvTdeb8KX2sTiZseANC1TpH2dObLB+5tib4H3Jdz64+38hMxYSDkSX
         hVCkE2V0tU8fxfUcNr4jlbsmSuX0dMWkdJhcqFM5DX/xalEWo0VTvPyie618MiG85XnR
         wWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793632024; x=1794236824;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dylFydTJD2AJSyC001lOFTgMCOP2ZnGzBFoGx74ahLY=;
        b=WkesUd3/pB1g1idBbvjcgxq1nKAbN8KOH8wNSZR41oAn/w4b5klX8XfcH5MANHEdij
         S82AtcozQ9GPymGoHTeJ8phZR4gMfn5ijR4wt1fnspSYNJD4/N79hkgBJoeYF5u1H+eH
         IgiCUUvUOAoWirDlZLR5zTYumRUgV7vTqki0yicsqDB314gdvF7MRwiBcKdqWs6ZeDEg
         iANmSY6s3ErleCFDdORYRTEqA5JHjSrvZo9/k5Edr5lVSIaTP7iMfdyNKr232WZqhEC3
         BvriiZAPcDsB+u0RzxkOJyQte9HumCdY6PnuIeINC8nt/ElUPxX6YP58dsEppq/kaL40
         yZ8g==
X-Forwarded-Encrypted: i=1; AKwUvBw6TAWV21+ZoNY3VjZe/Mk0qrTcgdwqG5CMZcLw2U3RaxDD9OnPP/VhkSp9PLRWkzd0aJhZyeqw7trm@vger.kernel.org
X-Gm-Message-State: AFq9FYJC58kkILf9jRp/KG87BsvgBGIJIWelbYe0IduRZkHr9B9NKFlw
	JMAu7Gq6enw+e7dOrTU5hDWTi7ZgJ/l2lS9bl3FxSucYnEtoVIlxhUhS
X-Gm-Gg: AYBFou1sR10wi8e/Bki1rk3W1xIlNC4uM1C1jCN08vOg1/ZURvdRsMwsfz0COm+UVtV
	NXn2KaCzDB6UUQfAjRE0eLDP2rx7SMPpOEDMboG1ygusNRjqjMFCCJI7UAwh2G/Uo7BHaraZQGF
	dkpAMOk3V7pmCfqZoQClgK/6cAYNsdNs2fGCikKUoxZ8nwByx66U0pRcqBz9WEizXr2QcQAHhJ9
	KqIA0rIEW2KWIqkY9YJNUxPQHyxPebLUd3U1SVcRqVgBgNKfP9xoH/84xIAUUHDsm1N77rdom6F
	9XTcfLK5I2XQtSppn626Thm7ocR0bTxJdBNiylM1GjG3waIEuYxZxJgiR5KdBMmZwgRMBj8sxSX
	tj0pFNZN72EF6hlMsdjo19Y49biznAfk3jTk9SRW0jw4c4wbXCCY5110ob2k+sfGIce9o7KqVP5
	DyrURLKzWlQX5ew3nt39ayCSIvBhHX8Fmoc+xcapyze+P/jamM2QZJdxKtZhSzHarY/rmhOkOtu
	eWjwi/ng46RquOb38lOwVPemGi5Oxw0qhVCORIYSAXpKH2CtyXrL91oBf52FXwIGyrmCT7e4ERT
	tQgXVwUfmJMmwBVdOyTDPnnweke8ACcbrteZzmLpzvnGMg==
X-Received: by 2002:a05:600c:1f8d:b0:4a2:c9b:9b98 with SMTP id 5b1f17b1804b1-4ac177539f6mr227554115e9.17.1793632024294;
        Mon, 02 Nov 2026 07:07:04 -0800 (PST)
Received: from localhost.localdomain ([2800:810:84a:dc6d:d32b:1515:b2a9:c74e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm395629535e9.11.2026.11.02.07.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:07:03 -0800 (PST)
From: =?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH netfs v2 0/2] preserve prepare_write errno across write reissue
Date: Mon,  2 Nov 2026 12:06:53 -0300
Message-ID: <20261102150656.207612-1-ivanrwcm25@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
References: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
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

Changes in v2:
- KUnit: allocate netfs_io_request / netfs_io_subrequest with
  kunit_kzalloc() to fix ARM allyesconfig -Wframe-larger-than=
  (kernel test robot).

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
 fs/netfs/Kconfig               |  9 ++++
 fs/netfs/Makefile              |  2 +
 fs/netfs/write_collect.c       |  4 ++
 fs/netfs/write_issue.c         |  4 +-
 fs/netfs/write_reissue_kunit.c | 80 ++++++++++++++++++++++++++++++++++
 6 files changed, 101 insertions(+), 1 deletion(-)
 create mode 100644 fs/netfs/.kunitconfig
 create mode 100644 fs/netfs/write_reissue_kunit.c

-- 
2.43.0


Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D857826F28D
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174984; cv=none; b=EbjZkxxhDcaxpb6nRHsnqiZOEB0W7mL277/lwhKdkmnlN5zupWOxGuY7kn6XK+4AX+yeX6qShszDKp82DqBhIs3MEjzwpZ+sFTbO0LfbWRpbe639o2dEcX8/m4DjTHNc9mV4l/p3Wwfp1tPrO/M1RRhSM3mMt82S8q13mWopCTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174984; c=relaxed/simple;
	bh=cffpT+ClcETmeFDXDiJYX4TocGYmxcybFqyiQ46U5L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/bQkURo4C+gcqjl9yjEdDeXo9I6tICHy+/n29/PDaww+ueizYTcsfBlXv76xxd09Qn0N2d0j6pW+q8tRW+Eep59ty5VGEsVqFJ2XnhYqTfvLnoVejLXsw0MepEqeHAcEoAaXY2jn85ueanWv5+rwTuNL1u2PPIEJfLg/PJYEP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mArSdsxo; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mArSdsxo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEIoCohFtyWpN3WiMSKV++RVY/4/aatau75H8ph0GQE=;
	b=mArSdsxokF4n8yP0LJYfSLVAwxGWPYY34E2SS3TdRakNDgoGLhDWhYwR5HmZrHrvRo+cac
	sbhQ0QZX8d1dv5ogBqj9FWBib0aWashD1b5/as42SPh3pvajkmjs4etML2ZGCnjaEUm9Zg
	GuOhDh9UXu5a59yZH7ujIPVtYvggcFM=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 10/30] smb/client: introduce KUnit test to check sort result of ntstatus_to_dos_map array
Date: Mon,  8 Dec 2025 14:20:40 +0800
Message-ID: <20251208062100.3268777-11-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The KUnit test are executed when cifs.ko is loaded.

The ntstatus_to_dos_map_check_sort() checks whether the array is properly
sorted.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index f937b7b3d3f2..a08011621742 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -28,11 +28,16 @@ static void __array ## _check_sort(struct kunit *test)			\
 	KUNIT_EXPECT_EQ(test, true, is_sorted);				\
 }
 
+/* ntstatus_to_dos_map_check_sort */
+DEFINE_CHECK_SORT_FUNC(ntstatus_to_dos_map, ntstatus_to_dos_num, ntstatus);
+
 /*
  * Before running these test cases, the smb_init_maperror()
  * function is called first.
  */
 static struct kunit_case maperror_test_cases[] = {
+	/* check sort */
+	KUNIT_CASE(ntstatus_to_dos_map_check_sort),
 	{}
 };
 
-- 
2.43.0


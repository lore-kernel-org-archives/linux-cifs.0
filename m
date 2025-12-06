Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FE523ABA7
	for <linux-cifs@vger.kernel.org>; Sat,  6 Dec 2025 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034405; cv=none; b=PXjo8qgwKe4u6+MmBsVeqQ5VsuhN0wMz1JkO+jyNz6FBpnBOQe7lN4n0+famoT53VQc/NbNTGvixqa4Oqn3Q+YGHkoq0Nf4Ac2rVkzrCzh4+zAo6rm36KqDYCJlDCBFGmOGs6Jc3Q0F61rdysy78SO7h/sgsvfIgTtr5KkCeHg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034405; c=relaxed/simple;
	bh=E1YExuk82a9Q4OvIwYFDaG/xXMWBAAcBjW7rneNPsb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcg989xF8HB8dylMnhvLjJgG+nMjjfhTMvIeIqNDEvOajVgMTXI2WXJ59jXQcs9srQ6gS3rCSbabYTf6+vZa0OqKRrYD4PFjDIV/5edtTbV4KGC9CfRcOiwEX6KM5Cf3mI2WVBryq4R4tv7JRVw+pnjolRbVJxsQH+UVaPTfX1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PGSh/XIa; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PGSh/XIa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765034402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zav3wgE+OQtF7H4Xjem2OgD1ss6KrR9JsCNQm3ywnu4=;
	b=PGSh/XIarCu6xj3ls6zor93GH+w0m/tfeFLmVa/Hbhq5e0ZV7WNDE+EBfY85ckX9Pr3jmj
	bqhHfMbRVKCz/8RH7oeGC4LhNa6Kmex/gTlAy6tAu6kbMYd7cHOaBH3jy0IzfpDCTg/XJ4
	QcgsprFMz6AZZANtF0EyBuSFI0N52X0=
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
Subject: [PATCH v4 09/10] smb/client: update some SMB2 status strings
Date: Sat,  6 Dec 2025 23:18:25 +0800
Message-ID: <20251206151826.2932970-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The smb2maperror KUnit tests reported the following errors:

  KTAP version 1
  1..1
      KTAP version 1
      # Subtest: smb2_maperror
      # module: cifs
      1..2
      ok 1 maperror_test_check_sort
      # maperror_test_check_search: EXPECTATION FAILED at fs/smb/client/smb2maperror_test.c:40
      Expected expect->status_string == result->status_string, but
          expect->status_string == "STATUS_ABANDONED_WAIT_0"
          result->status_string == "STATUS_ABANDONED"
      # maperror_test_check_search: EXPECTATION FAILED at fs/smb/client/smb2maperror_test.c:40
      Expected expect->status_string == result->status_string, but
          expect->status_string == "STATUS_FWP_TOO_MANY_CALLOUTS"
          result->status_string == "STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS"
      not ok 2 maperror_test_check_search
  # smb2_maperror: pass:1 fail:1 skip:0 total:2
  # Totals: pass:1 fail:1 skip:0 total:2
  not ok 1 smb2_maperror

These status codes have duplicate values, so update the status strings to
make the log messages more explicit.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index dc2edeafc93b..e54b5871ecc9 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -22,8 +22,9 @@ static struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_WAIT_2, -EIO, "STATUS_WAIT_2"},
 	{STATUS_WAIT_3, -EIO, "STATUS_WAIT_3"},
 	{STATUS_WAIT_63, -EIO, "STATUS_WAIT_63"},
-	{STATUS_ABANDONED, -EIO, "STATUS_ABANDONED"},
-	{STATUS_ABANDONED_WAIT_0, -EIO, "STATUS_ABANDONED_WAIT_0"},
+	{STATUS_ABANDONED, -EIO, "STATUS_ABANDONED or STATUS_ABANDONED_WAIT_0"},
+	{STATUS_ABANDONED_WAIT_0, -EIO,
+	"STATUS_ABANDONED or STATUS_ABANDONED_WAIT_0"},
 	{STATUS_ABANDONED_WAIT_63, -EIO, "STATUS_ABANDONED_WAIT_63"},
 	{STATUS_USER_APC, -EIO, "STATUS_USER_APC"},
 	{STATUS_KERNEL_APC, -EIO, "STATUS_KERNEL_APC"},
@@ -2292,8 +2293,9 @@ static struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_FWP_LIFETIME_MISMATCH, -EIO, "STATUS_FWP_LIFETIME_MISMATCH"},
 	{STATUS_FWP_BUILTIN_OBJECT, -EIO, "STATUS_FWP_BUILTIN_OBJECT"},
 	{STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS, -EIO,
-	"STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS"},
-	{STATUS_FWP_TOO_MANY_CALLOUTS, -EIO, "STATUS_FWP_TOO_MANY_CALLOUTS"},
+	"STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS or STATUS_FWP_TOO_MANY_CALLOUTS"},
+	{STATUS_FWP_TOO_MANY_CALLOUTS, -EIO,
+	"STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS or STATUS_FWP_TOO_MANY_CALLOUTS"},
 	{STATUS_FWP_NOTIFICATION_DROPPED, -EIO,
 	"STATUS_FWP_NOTIFICATION_DROPPED"},
 	{STATUS_FWP_TRAFFIC_MISMATCH, -EIO, "STATUS_FWP_TRAFFIC_MISMATCH"},
-- 
2.43.0


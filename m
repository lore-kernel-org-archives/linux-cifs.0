Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD9A2857CD
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174979; cv=none; b=Ez1igEn2WKiwuj7A/LQ8AWksImjOK4hVTOenMa1egS3CSm2CFnQiLA7ylojvBLmCSiC3x4qjwVYRz0l43OcU9mT9Juwrj1gLf878WHYgX0/XbqkH1lQFwXnQkWQaYdYRJO+oTjkOPc/GpdYacYLa5X73VSYxu5Tk1HDl/5gKF3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174979; c=relaxed/simple;
	bh=fKS+U1mJaVzlw8uXfIlfZi8G1HAdNP7FKnWjrfzKfQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIAeY5wnKJSOxvE/XsK5JRjVp7UYx46Itm4eZPLs//SZNOVXa9wXpbkXQu+3peEGMljYAifw48hrS4zAvKOo5zGzTToBlMyZBNi1I1rzoKGhIufL9weNI09D6bOAoBIm+R4Y2Juu7m6wsca2w7YGQe0KnvO4EBTdg757SUZj+xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ar8GPVUN; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ar8GPVUN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sp0Fz8CbZFpfKpsDmGee+Y1J5MG5yvjRZvwAWlnxrSc=;
	b=Ar8GPVUN+V6ad+LG73E90RR8AX1tiQs+qH9kqmYroWCMgM66LQbYV49uwP/9UAZigJSlsD
	t5/Z95m0FkejK/RLMJxZ48If3Yz6h3o33Ub81WvM1BdvOETmAz6b1ycxAWshvdAoAUZ9aC
	w0SRrIRT4Dk7jX5kCq4xYccAjXRU2q0=
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
Subject: [PATCH 08/30] smb/client: sort ntstatus_to_dos_map array
Date: Mon,  8 Dec 2025 14:20:38 +0800
Message-ID: <20251208062100.3268777-9-chenxiaosong.chenxiaosong@linux.dev>
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

Sort the array in ascending order, and then we can use binary search
algorithm to quickly find the target NT error code.

The array is sorted only once in smb1_init_maperror() when cifs.ko
is loaded.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c    |  2 ++
 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/netmisc.c   | 20 ++++++++++++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 77d14b3dd650..3e3affce585e 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -49,6 +49,7 @@
 #endif
 #include "fs_context.h"
 #include "cached_dir.h"
+#include "cifsproto.h"
 #include "smb2proto.h"
 
 /*
@@ -1909,6 +1910,7 @@ static int __init
 init_cifs(void)
 {
 	int rc = 0;
+	smb_init_maperror();
 	smb2_init_maperror();
 	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 3528c365a452..675413d701b3 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -188,6 +188,7 @@ extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
 extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
 extern int map_smb_to_linux_error(char *buf, bool logErr);
 extern int map_and_check_smb_error(struct mid_q_entry *mid, bool logErr);
+extern void smb_init_maperror(void);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifs_tcon *, int /* length of
 			    fixed section (word count) in two byte units */);
diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 73c40ae91607..54ede1db2c7f 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -16,6 +16,7 @@
 #include <asm/div64.h>
 #include <asm/byteorder.h>
 #include <linux/inet.h>
+#include <linux/sort.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
@@ -216,11 +217,13 @@ cifs_set_port(struct sockaddr *addr, const unsigned short int port)
 convert a NT status code to a dos class/code
  *****************************************************************************/
 /* NT status -> dos error map */
-static const struct {
+struct ntstatus_to_dos {
 	__u8 dos_class;
 	__u16 dos_code;
 	__u32 ntstatus;
-} ntstatus_to_dos_map[] = {
+};
+
+static struct ntstatus_to_dos ntstatus_to_dos_map[] = {
 	{
 	ERRDOS, ERRgeneral, NT_STATUS_UNSUCCESSFUL}, {
 	ERRDOS, ERRbadfunc, NT_STATUS_NOT_IMPLEMENTED}, {
@@ -778,6 +781,12 @@ static const struct {
 	0, 0, 0 }
 };
 
+static unsigned int ntstatus_to_dos_num = sizeof(ntstatus_to_dos_map) /
+					  sizeof(struct ntstatus_to_dos);
+
+/* cmp_ntstatus_to_dos */
+DEFINE_CMP_FUNC(ntstatus_to_dos, ntstatus);
+
 /*****************************************************************************
  Print an error message from the status code
  *****************************************************************************/
@@ -1040,3 +1049,10 @@ struct timespec64 cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 	ts.tv_nsec = 0;
 	return ts;
 }
+
+void smb_init_maperror(void)
+{
+	/* Sort in ascending order */
+	sort(ntstatus_to_dos_map, ntstatus_to_dos_num,
+	     sizeof(struct ntstatus_to_dos), cmp_ntstatus_to_dos, NULL);
+}
-- 
2.43.0


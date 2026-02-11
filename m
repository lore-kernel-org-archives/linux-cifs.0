Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED5C26290;
	Wed, 11 Feb 2026 04:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770785269; cv=none; b=O9aQn5u84FkVKpHRRnOAEgkDNZYA2Q8S1VyPWpnUrTX4miplvdsuNZJzl7l1/qDtzqT/XuzUln9m98m4LzzarrBpA3H+xl7Suh1o+PHKCjBbMIe5KDap9N3Ryzu9HS+KbIrJAVeAa/hf7ozoJVgHmn2xG5m2NmdzNsDW+S/tsn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770785269; c=relaxed/simple;
	bh=HT9W7yDITFKALVK2NfYo4ZzoIAsxwYaenSYIPfnbSfw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EBIHIaFovaPLaCtlDPtetBUgCk8RKMbssJlVrxBp/yy9TMUas8fjwhH/ITxfnBhZaeME13yBgsBLO9tlz0ctYmL+7DzTtAqhBlHFuVnllCYyJt4h2SCVF99bE0a0YUT+iDEYo5NfAXg8N1i02XhwpW3YmqU+ykGWGpNcK/fJqyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAD3hAjeCYxp4LwJCA--.6438S2;
	Wed, 11 Feb 2026 12:47:26 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] cifs: SMB1 split: Remove duplicate include of cifs_debug.h
Date: Wed, 11 Feb 2026 12:46:44 +0800
Message-Id: <20260211044644.2935921-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3hAjeCYxp4LwJCA--.6438S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKry5KFyUXw1kKrW8Gr15urg_yoWxCrb_Aw
	1fZrW8CFyUJFsxt3WUKr1jqF4j9r1rtw48ZFnIgw1vk3WDJF4kAw4DXwn7ZF429rW5ZFWx
	W3sru3sYyr43GjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8XwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU-SdkUUUUU=
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Remove duplicate inclusion of cifs_debug.h in smb1transport.c to
clean up redundant code.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/smb/client/smb1transport.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 0b8b852cfc0d..93731b00ca5d 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -29,7 +29,6 @@
 #include "cifs_debug.h"
 #include "smbdirect.h"
 #include "compress.h"
-#include "cifs_debug.h"
 
 /* Max number of iovectors we can use off the stack when sending requests. */
 #define CIFS_MAX_IOV_SIZE 8
-- 
2.25.1


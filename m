Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533631C4A13
	for <linux-cifs@vger.kernel.org>; Mon,  8 Sep 2025 12:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757333311; cv=none; b=k1KDwqrkSPLkfzgrRRDTmiUCVJXKiXg58ZeRj0zZWmJ6dv9/XeauYNdmsv6sk6kh1qWmMZvFSKdUhh9ZpQccyh3GtmAZVS/PNr4C0PzkgMd90Kkjs6/YckOCjWsVhy+GtCEH+Q/t/KptAfQ7a3X8cnBCU/NjRkJ9EIk75VFEJNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757333311; c=relaxed/simple;
	bh=mHCYpz6IxNvgdVopf/5ZKJR8E14cluHsC5WO+lKQ2UY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=leptqkNeqEM7DCnr49BsQ+vxW8yZ6g+V2Niq5nRXDkOiP1etnlC3qcyratErj6K/FvyVLh2Q9y/jcS6iXCqsY/QAw8R6hPYi4ahcEJ41mT7gS3hQlIOgaPseTDe4ER8OSMgBcSi9ic+hRoK4TuLow2TOMdxQUvpgvZeby30Dnd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-01 (Coremail) with SMTP id qwCowACnAqUKx75oFtOmAQ--.37134S2;
	Mon, 08 Sep 2025 20:07:38 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org,
	Chen Yufeng <chenyufeng@iie.ac.cn>
Subject: [PATCH] smb: validate command payload size in smb2_check_message
Date: Mon,  8 Sep 2025 20:07:23 +0800
Message-ID: <20250908120723.1614-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACnAqUKx75oFtOmAQ--.37134S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFyxXw15WF4rGFy3GryUKFg_yoW5Jw4Upr
	y3Xr43ArZYq3ZxCrn7Jrs8Za4rZwnYkwsrJrsFv3WSqF97Xr97AFyvyas09ayYgryrGw1x
	KFs0vrnFvF17u3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvq14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0x
	ZFpf9x0JUc189UUUUU=
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiDAgTEmi+slUj4AABs2

The vulnerability addressed in the patch for smb2_check_message shares 
similarities with the previously identified issue in ksmbd_smb2_check_message 
from 2b9b8f3b68ed("ksmbd: validate command payload size").
Both functions are responsible for validating SMB2 messages, and the core 
issue lies in the improper or insufficient validation of the StructureSize2 
field, which indicates the command payload size.

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
---
 fs/smb/client/smb2misc.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index cddf273c14ae..2b5f42adc401 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -143,6 +143,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 	int command;
 	__u32 calc_len; /* calculated length */
 	__u64 mid;
+	__u32 req_struct_size;
 
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
@@ -209,16 +210,9 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 	}
 
 	if (smb2_rsp_struct_sizes[command] != pdu->StructureSize2) {
-		if (command != SMB2_OPLOCK_BREAK_HE && (shdr->Status == 0 ||
-		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE)) {
-			/* error packets have 9 byte structure size */
-			cifs_dbg(VFS, "Invalid response size %u for command %d\n",
-				 le16_to_cpu(pdu->StructureSize2), command);
-			return 1;
-		} else if (command == SMB2_OPLOCK_BREAK_HE
-			   && (shdr->Status == 0)
-			   && (le16_to_cpu(pdu->StructureSize2) != 44)
-			   && (le16_to_cpu(pdu->StructureSize2) != 36)) {
+		if (!(command == SMB2_OPLOCK_BREAK_HE &&
+		    (le16_to_cpu(pdu->StructureSize2) == 44 ||
+		    le16_to_cpu(pdu->StructureSize2) == 36))) {
 			/* special case for SMB2.1 lease break message */
 			cifs_dbg(VFS, "Invalid response size %d for oplock break\n",
 				 le16_to_cpu(pdu->StructureSize2));
@@ -226,6 +220,14 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 		}
 	}
 
+	req_struct_size = le16_to_cpu(pdu->StructureSize2) +
+		__SMB2_HEADER_STRUCTURE_SIZE;
+	if (command == SMB2_LOCK_HE)
+		req_struct_size -= sizeof(struct smb2_lock_element);
+
+	if (req_struct_size > len + 1)
+		return 1;
+
 	calc_len = smb2_calc_size(buf);
 
 	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
-- 
2.34.1


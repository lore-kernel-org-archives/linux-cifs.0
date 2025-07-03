Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE842E7192;
	Thu,  3 Jul 2025 13:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751549407; cv=none; b=khhriJX6mORZj26+2xHgDwakVo7McZZcEv4ptGSXA1riHR3gYNyfwXkJnE5tgWkeHVIy/0x4Jvb/OHiu5PetrymEOSx4k8MYXbwKtzbzbJDxkLNET65IOG6EK08vPhaosGRdFWKZ/zSd96hQXbepRs7yqI8a5i5fnQ4MGeaSzJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751549407; c=relaxed/simple;
	bh=EDqJyxY9KJ4DcWJ/BoKaSms1bDYxPEWBtMxBlWGwfzk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o6UJNI4Yo+h3LVcfUGQdD1NkCEKL3btF4xee9TDnbjRrD82fS1rjJVd/wkPvyPFZG46anCNZxKb5tFex7EoKNRtWL5Tcq3o2+dMz/SOgcyVnk1/EP9Sw/H6xcGAskcVKEOh0PmJAYjCWIQPAAlTbJsVN9MCbOfKiqfMaS8aPFH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bXyLC2QKqzYQtv8;
	Thu,  3 Jul 2025 21:29:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 318201A0F55;
	Thu,  3 Jul 2025 21:29:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
	by APP3 (Coremail) with SMTP id _Ch0CgBnxyTQhWZo+J4eAg--.8868S4;
	Thu, 03 Jul 2025 21:29:54 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	wangzhaolong1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com
Subject: [PATCH] smb: client: fix race condition in negotiate timeout by using more precise timing
Date: Thu,  3 Jul 2025 21:29:52 +0800
Message-Id: <20250703132952.2354098-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.34.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBnxyTQhWZo+J4eAg--.8868S4
X-Coremail-Antispam: 1UD129KBjvJXoWxurWUXry5urW5Xr4xuFy7Awb_yoWrur43pF
	WfKayfKF18XF18W3yDAa4kX348Zr1Duw45Gwn2qw1xZ3yDCr17XFs2yryvgay7WFW8K34F
	grsFvw40va1UZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

When the SMB server reboots and the client immediately accesses the mount
point, a race condition can occur that causes operations to fail with
"Host is down" error.

Reproduction steps:
  # Mount SMB share
  mount -t cifs //192.168.245.109/TEST /mnt/ -o xxxx
  ls /mnt

  # Reboot server
  ssh root@192.168.245.109 reboot
  ssh root@192.168.245.109 /path/to/cifs_server_setup.sh
  ssh root@192.168.245.109 systemctl stop firewalld

  # Immediate access fails
  ls /mnt
  ls: cannot access '/mnt': Host is down

  # But works if there is a delay

The issue is caused by a race condition between negotiate and reconnect.
The 20-second negotiate timeout mechanism can interfere with the normal
recovery process when both are triggered simultaneously.

  ls                              cifsd
---------------------------------------------------
 cifs_getattr
 cifs_revalidate_dentry
 cifs_get_inode_info
 cifs_get_fattr
 smb2_query_path_info
 smb2_compound_op
 SMB2_open_init
 smb2_reconnect
 cifs_negotiate_protocol
  smb2_negotiate
   cifs_send_recv
    smb_send_rqst
    wait_for_response
                            cifs_demultiplex_thread
                              cifs_read_from_socket
                              cifs_readv_from_socket
                                server_unresponsive
                                cifs_reconnect
                                  __cifs_reconnect
                                  cifs_abort_connection
                                    mid->mid_state = MID_RETRY_NEEDED
                                    cifs_wake_up_task
    cifs_sync_mid_result
     // case MID_RETRY_NEEDED
     rc = -EAGAIN;
   // In smb2_negotiate()
   rc = -EHOSTDOWN;

The server_unresponsive() timeout triggers cifs_reconnect(), which aborts
ongoing mid requests and causes the ls command to receive -EAGAIN, leading
to -EHOSTDOWN.

Fix this by introducing a dedicated `neg_start` field to
precisely tracks when the negotiate process begins. The timeout check
now uses this accurate timestamp instead of `lstrp`, ensuring that:

1. Timeout is only triggered after negotiate has actually run for 20s
2. The mechanism doesn't interfere with concurrent recovery processes
3. Uninitialized timestamps (value 0) don't trigger false timeouts

Fixes: 515ccdbe9b2f ("[Backport] smb: client: fix hang in wait_for_response() for negproto")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/connect.c  | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 318a8405d475..22060a28bc61 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -775,10 +775,11 @@ struct TCP_Server_Info {
 	__u32 sequence_number; /* for signing, protected by srv_mutex */
 	__u32 reconnect_instance; /* incremented on each reconnect */
 	__le32 session_key_id; /* retrieved from negotiate response and send in session setup request */
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
+	unsigned long neg_start; /* when negotiate started (jiffies) */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 #define	CIFS_NEGFLAVOR_UNENCAP	1	/* wct == 17, but no ext_sec */
 #define	CIFS_NEGFLAVOR_EXTENDED	2	/* wct == 17, ext_sec bit set */
 	char	negflavor;	/* NEGOTIATE response flavor */
 	/* extended security flavors that server supports */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 685c65dcb8c4..2f49e1872729 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -677,16 +677,16 @@ static bool
 server_unresponsive(struct TCP_Server_Info *server)
 {
 	/*
 	 * If we're in the process of mounting a share or reconnecting a session
 	 * and the server abruptly shut down (e.g. socket wasn't closed, packet
-	 * had been ACK'ed but no SMB response), don't wait longer than 20s to
-	 * negotiate protocol.
+	 * had been ACK'ed but no SMB response), don't wait longer than 20s from
+	 * when negotiate actually started.
 	 */
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsInNegotiate &&
-	    time_after(jiffies, server->lstrp + 20 * HZ)) {
+	    time_after(jiffies, server->neg_start + 20 * HZ)) {
 		spin_unlock(&server->srv_lock);
 		cifs_reconnect(server, false);
 		return true;
 	}
 	/*
@@ -4213,10 +4213,11 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 		return 0;
 	}
 
 	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
+	server->neg_start = jiffies;
 	spin_unlock(&server->srv_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
 	if (rc == -EAGAIN) {
 		/* Allow one retry attempt */
-- 
2.34.3


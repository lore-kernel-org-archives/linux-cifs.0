Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3246F52845A;
	Thu, 17 Sep 2026 16:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662899; cv=none; b=nNxXsz5gQL6jBP8DfEyM8jSBfr5xipPShZMwusflKEXCxtlqH8rinGL2j05lQcRQmmzHeDagM0BenukoOMIKk7cN0zlmaa2d9t/T7u9GTeMNw1C89BYARSNRlJ4CKjpjwFF1HefxgHS2kbNEMNFlG8MFJWnnku6uU3zhS1F/iKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662899; c=relaxed/simple;
	bh=WL33Y42nIYwQDnqCTIKBZ4BA1khv9nabZhRlPNj7qes=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aiXb4Xr0Q+gKrmDr0kIs4Mw2PcOg3Ww2NgUWnclOCsHLwmeTKkbKG+t6GvDMqBBvF7Zb7UK4VUgncdm7IQTJYxUBL7WF3th1ePmT4UhZEkmABSSgLamLUG0K1j5RQLKzdZ4SNUe236opyrUQ/Lkj0OqP9vejLT0Hs2URlaFxxRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADnF0KfFqxqQpKECA--.6825S2;
	Fri, 18 Sep 2026 00:34:39 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	samba-technical@lists.samba.org,
	sfrench@samba.org,
	sprasad@microsoft.com,
	tom@talpey.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] cifs: Fix server use-after-free in cifs_chan_skip_or_disable()
Date: Thu, 17 Sep 2026 16:34:39 +0000
Message-Id: <20260917163439.2162539-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADnF0KfFqxqQpKECA--.6825S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1UZw4ftr1xZr4DAr43ZFb_yoW8Zw43pr
	W7KrWj9F95GFnxZFWkAFWUXFyY9F47W3WF93yDAw1xuws5Aay7WF4jqw1vg3Wak395GFZ0
	grnIq3yvvayUJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzx
	vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x02
	62kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48ZrWUJr
	1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267
	AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUgXocUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgcNA2qr889TtwAAsW

When a secondary channel is no longer supported by the server,
cifs_chan_skip_or_disable() drops the channel reference with
cifs_put_tcp_session() and then continues to use the server pointer by
calling cifs_signal_cifsd_for_reconnect() on it and reading its
primary_server pointer. cifs_put_tcp_session() can drop the last
reference of the channel and tear it down, so both the channel and the
primary server (whose reference is also dropped by
cifs_put_tcp_session()) can be freed before they are signaled for
reconnect.

Signal the channel and the primary server and capture the primary
server pointer before dropping the channel reference with
cifs_put_tcp_session().

Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/smb/client/smb2pdu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3bd300347f16..a33f9b9ed32b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -189,18 +189,19 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		spin_unlock(&ses->chan_lock);
 
 		/*
-		 * the above reference of server by channel
-		 * needs to be dropped without holding chan_lock
-		 * as cifs_put_tcp_session takes a higher lock
-		 * i.e. cifs_tcp_ses_lock
+		 * signal the channel and its primary server to
+		 * reconnect before dropping the above reference of
+		 * server by channel, which is done without holding
+		 * chan_lock as cifs_put_tcp_session takes a higher
+		 * lock i.e. cifs_tcp_ses_lock
 		 */
-		cifs_put_tcp_session(server, from_reconnect);
-
 		cifs_signal_cifsd_for_reconnect(server, false);
 
 		/* mark primary server as needing reconnect */
 		pserver = server->primary_server;
 		cifs_signal_cifsd_for_reconnect(pserver, false);
+
+		cifs_put_tcp_session(server, from_reconnect);
 skip_terminate:
 		return -EHOSTDOWN;
 	}
-- 
2.34.1


Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6FC79FE;
	Wed, 28 May 2025 03:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748402277; cv=none; b=WC5T6xehQqCmVexw4pR7P1NgeiJOs4JjM89jhJR7Y3BAcm8NFR6jI8/eYue0ssyRpZ6OLKmgvNcLN0ZUfhUpbATXNA0g3EKVq2ghofn2tFkmUAiM9ex6K0SwlRVG7eVxaBcLWjzKJywrBKTIw1jWESh0t3g89NGeSdCmFvy0pRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748402277; c=relaxed/simple;
	bh=mzfW20sFFR6D/60o4wNJyAxellP62F05rai/LV6m27o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IiOcFioFU5pMbhwbrjpmsklIe1OlxVUaDkhzLnJ2y5v8w75r7U4KRd7mBreSwt726zqBYa3hrvTF3XAoUphERlmpdVUH1a7PdLjuux/V71EdeD1D6qIbWAVNvhhrKrE2zOZJFT77U23aVR/1Qogj6n9COmM4Km4NEolEETP+PBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpsz6t1748402170t6248cb72
X-QQ-Originating-IP: rpHufvYFYUJ0bTcomXzGOi8T7Xf90nx7Je9QKh+gAm8=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 28 May 2025 11:16:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13204632789230215609
From: chenxiaosong@chenxiaosong.com
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/client: use sock_create_kern() in generic_ip_connect()
Date: Wed, 28 May 2025 11:15:31 +0800
Message-Id: <20250528031531.171356-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MFdGPHhuqhNoOWNRcEyLWJrL0qUXQ3qT5D5wx9m9puYNGgcNX7WDrIde
	tGaNwEqrTnQ0H8TwUPhIdP84AE6PDxCup4Qn+9812XVGpHJUyPhvAAoe1SDCzxNlpXmemXh
	CdVj6a4ye8i4w4+l7Mr9VTv3ErR+LC5Vl7QhoaN0jRFdAC0rRtoxqtb3cTspGTi8ddivmGz
	TkTBVzIlJznwcOItOwaW1QGcj34EsiKxwMh0a3I3N3BV6lw6d/JxzQE8kz/WU1gOFccFQFk
	CVN+E8wAMb1WDXMHL5X02URyweeWvXjZhW0jw/fDT6ZaX7T9N/uwYtVdt+JHjE61m1tjFse
	rwYQaWkvKbZ8hFzGw/Xd7NgWnvI8POe+wO6s3drekwdQ9pdlMT2Zjmm0Ud5CjBFPCtcyCmV
	asMcbfrd9XIPLZaWM9oHn2Mnuz223oddrbnPJ46KbXBnKeSUua7sZGGqSc0BDdxe9TnKbrt
	8UckOOfnAxl+IV2dkS388/IQPKI3kx4oMoOqG2YRjNK4MCJivA+hYmasLJqDlPXmVY+4m6c
	ROO1M0IIsLA8PCCvrBe+iJQSl5k0+yDJERj5etgBUSmITQKiijQXsZ+Woqh4JvN4jPtxZU4
	UftMYDh913DvsxdcQNo5zbFWT8xM4k+a+rOvjmwvPp7Is7PtZwcpprQ5pRXacmrnEiA0am5
	FUhBr5A7PSU91Wd5Y9inIZqpSfBlsfPd7k1GsZu4KF1IYgN3l9orJ6svb4Xzj9xItV4+P9Z
	m7ILVyyBaDZuH3UL/aJBrmRBJAL1NyIdV4x7wesVFK1EY/66DNuG7T+eWCg2lEHMspGekEf
	N2Toet4ogmlG6LhD1RV1Q7JX8SmLYRjUGQlN5CxarGbUsyrHd/B2fs4p1m7skBl6mYE5Pr+
	kHws3JYDW3qYrp0Dm3anK+rqQA/R7U6Ha8Z3N5CvQitPMsIS0OP+8CRN1mlnmuEA5heXg+u
	icMqxmcP9bPcfStimvnX8ST26fe0nux16nNBtXJ5Xlo7ab3a9f7/m/mp2mQrglKm7VPc=
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Change __sock_create() to sock_create_kern() for explicitness.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/connect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 6bf04d9a5491..3275f2ff84cb 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3350,8 +3350,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		struct net *net = cifs_net_ns(server);
 		struct sock *sk;
 
-		rc = __sock_create(net, sfamily, SOCK_STREAM,
-				   IPPROTO_TCP, &server->ssocket, 1);
+		rc = sock_create_kern(net, sfamily, SOCK_STREAM, IPPROTO_TCP, &server->ssocket);
 		if (rc < 0) {
 			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
 			return rc;
-- 
2.34.1


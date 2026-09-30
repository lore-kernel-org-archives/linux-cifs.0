Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82BC3BE642;
	Wed, 30 Sep 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793499; cv=none; b=NdOZ4f7i9Uuv4rPNhvSYEv8m1W41nNb/L9EfjU1vNhEk/uPVD+US3XrkD/I+jvzFRBdklGy7FHx170LNKPaU4Uj1l8glysGFtyj4pOdIoOpgbgNfxBMpgcpoNw4Sk9FHXD+v/0XBdwY8FStB2FGBSKawkmMG5HZ2mMJlkHKwaNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793499; c=relaxed/simple;
	bh=2nv/pV3vXGKQwEwQEEv0upnDod20APJRLr0rKVEHp/A=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=BlmXdUCyYfbX+aLJSz/gJhiqC/2OxIs08gvcRk96UIP1vbpoyKPtvFW6ak7DUoPHqI0uB2HXJKrpz+Voz90R35opZJdHktA39qLjmKogYUyFAGM3s1kOeROBhT6vJcqJ5Yr0pR9ul6WCFBgmYL5RKXorO5Q4kd9UswO5ssoNV94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=VhOx18UJ; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="VhOx18UJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790793485; bh=WlBgE8pnPDkXqQZZ34n5Byapb2EAMYahNs5UYROSlpw=;
	h=From:To:Cc:Subject:Date;
	b=VhOx18UJfqmxtIqe8m1NRz7g81ZbEuizPbScQLbBYbreRMc3QBaHAdboZEFUhQNGA
	 NqetMPAAUYEhmxG0YabKwylssheJNA6p589qyRAFNGa+PKUcJaDm6Jc2EW8kG/rd/0
	 OcfP0D3ji6VxNY20TBvVJu2riIWaT7/B/+OoEuqw=
Received: from archlinux ([36.28.2.0])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 981B3829; Thu, 01 Oct 2026 02:38:01 +0800
X-QQ-mid: xmsmtpt1790793481tak01bgkl
Message-ID: <tencent_238A42C6350C25F55AFAA340BCE35A0D3B08@qq.com>
X-QQ-XMAILINFO: OJK4x0bF/s2jPp7nZgf2LShJu7hEz6XFY9BJSBo8E+EOl5Ll3FGuT+kk5q3BIs
	 E5tZ31rYJ7OGaHmEOY99jBwkkJdozlO4z30UcplnzezP+90oXUPxTbPKXxksGyAMAOIR6jOkB3dz
	 4lVVqOvrCLhUdKfgw3/oPjQPD7BjDtj0Py1HQaSI88ksfWR+sjtfyeaP020DGJhMjcfzii3rEltO
	 UccYfobjs203Xp7bOCMfgO5b+oVVj1UBvKtvdeohnjmJh9BS+TujRbTAEDnLug/vfoo1mvasLkHL
	 mKWMAWP3huTe5JfAcJkSBTjY9vFZH5t0EhN6i7HyUGdhGMUGvrbauw5d8oH8bUfJ4i39BFUur65j
	 dooUhKkZaeTZHjxfGIjuS8gciwIjl5siyGKSlji/cSSkROMZXSGLXwv5YMxY1kyNjh3VRmaClWzA
	 r5wdGtCJs0g5V4Tvq035QlNeaWmsp9FHmJjRAyzJZibY5HyzNynU9JfjbncYrXdN+9DdDNnnbbMx
	 wKkzAOmmZIA3HMI0mr0hNXl0Nf+RH8iku5aJU28y0AKlat4IEGbCH/agq56A7+lneplqDkAZ3+69
	 WMLbJZY5Rc61480YKDwtVWLju1rP0GH8J7Dp8yWlgI1Jy5+yB3oxR8PCevQsYXRFwmkpc1mQuXLT
	 c3mhkksJejrp5AhuVMCDAijaqo+o0d15d9rRpMlPUUEDGmqCbllQiHYfS0/CXJOvNF3/wizeHHfz
	 7xAinK3tYsCZm2DpH0+yBX9t0/776oJpjeWz4I9pYC9mNcg0HpH8hJ8ORBOrDkKoqwbxID21DbCk
	 aprzr2g3onVQVu9KemPcBmagDUbGwosxxMt4N4dJCuabPwcurd3rDtpBkTyvYjyh5CtCUyU2iKIF
	 dGJCCHlZZnv/pJ0m8ITAE4/CwRmPY09t1GLeB6u0kUmEGif9L1HikbprqDNTbeOLWN8G4zVXX3y4
	 dFHmKCvCvOYVnnejqrHklvceoofoCmO1gX/2uvjlANo2R/IhZPbEBjiH7CcfTa9KPEBjHnrP/PUN
	 FRTsdcU+U4kS/ssmHmg+VwDd9hHBGbiOgEDLBAECGJ851flT6gj0tpPFikzjseEQ1CnyjOz77XNa
	 /YBKUzTYgUJrMX12AziKH554L9gg==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Daijiamu <3058704216@qq.com>
To: linkinjeon@kernel.org,
	sergey.senozhatsky@gmail.com,
	tom@talpey.com
Cc: chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daijiamu <3058704216@qq.com>
Subject: [PATCH] ksmbd: use clear_and_wake_up_bit() in wake_up_oplock_break()
Date: Thu,  1 Oct 2026 02:37:58 +0800
X-OQ-MSGID: <20260930183758.32342-1-3058704216@qq.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

clear_and_wake_up_bit() was introduced by commit 8236b0ae31c8 ("bdi:
wake up concurrent wb_shutdown() callers.") to replace the open-coded
clear_bit_unlock() + smp_mb__after_atomic() + wake_up_bit() sequence.

Use the helper in wake_up_oplock_break() to standardize the code path.

Signed-off-by: Daijiamu <3058704216@qq.com>
---
 fs/smb/server/oplock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 1b8c3482d1e4..bbf84b05dcf7 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -765,10 +765,7 @@ static bool wait_for_break_ack(struct oplock_info *opinfo)
 
 static void wake_up_oplock_break(struct oplock_info *opinfo)
 {
-	clear_bit_unlock(0, &opinfo->pending_break);
-	/* memory barrier is needed for wake_up_bit() */
-	smp_mb__after_atomic();
-	wake_up_bit(&opinfo->pending_break, 0);
+	clear_and_wake_up_bit(0, &opinfo->pending_break);
 }
 
 static bool oplock_break_set_ack_wait(struct oplock_info *opinfo)
-- 
2.55.0


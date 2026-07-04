Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6863D25F7A9
	for <linux-cifs@vger.kernel.org>; Sat,  4 Jul 2026 02:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783132521; cv=none; b=bEm6cxrYeYpGNXOIHyAoeaEwOu9s/SkSEMGRWgiwwFSOgemH/Fvc9uJZm96Gq4p5KHpzn391KBHqmD8rIr6HovfrA8ZSzmJa/w6TavfpSzvokvOZ6f2/GksUhjrLz7wAme+JqAiryeJ3V/M42XnLEeH7CAuuj09gEhV+uDdtpyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783132521; c=relaxed/simple;
	bh=vRURYw/UgmSJ2oWyKiAHu2f7S5MhPsVVav8QXUWuwrA=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=NW9sk15Ppv3Xn0shbF5kyGALeIlyj4Q7hRQ5WirwvpoLAw7rw/KF2d+gjZftPRrDHYfxNrgv8guz0QhaufYIbJSU8n/6OP458GYZXg7aXZPtXpTScdCiHHQPMZllTpfGJin1kNYzvzgcME63H/U73FMlDgMTysrxXTXSMeMD1Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=I7rZXVr8; arc=none smtp.client-ip=185.70.43.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="I7rZXVr8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1783132511; x=1783391711;
	bh=fe4tNaExgKYyvny277bkenqpd+2kmvyVX/K6cxCZ26U=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=I7rZXVr8hyyVkahyifOmKwgx3quWWVEoVqT/pE4cJSM0jndEGfjZ1xHhQL66qEQZq
	 CjnGBb36e++emILWY9X0L5Zwkj47hgu4WrrCOZ7go4eja8voghY+1JwxV+qUkO9CEh
	 m5WxVK9SPRXHQoTjGn01zfGdFgQ3FnnEbRywo1DsAMq5sZdBEUgP2VW2EZ9PXffK+a
	 Dw3oKPJJdgnN5ERjbmtrYfTYsKrWNQ9wUGxI/IVFYIZiRh8aTDBOqDPrgRkPHbdk81
	 ujwa9uBNzny1vDUtcrTQtVmjl7Knp3s0XJpebN4bjkV9ztKS//v5/3DxiMslV99Pg8
	 fMxumoFn2K2kg==
Date: Sat, 04 Jul 2026 02:35:06 +0000
To: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
From: Mehdi Hassan <mehdi.h.business@pm.me>
Cc: Mehdi Hassan <mehdi.h.business@pm.me>, Agatha Isabelle Moreira <code@agatha.dev>
Subject: [PATCH] smb: client: refactor cifs_revalidate_mapping() to use clear_and_wake_up_bit()
Message-ID: <20260704023458.131044-1-mehdi.h.business@pm.me>
Feedback-ID: 109794122:user:proton
X-Pm-Message-ID: e65586c78ddc131a52cb530e369a1152739df8bd
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

In the `skip_invalidate:` path under `cifs_revalidate_mapping()`, the
sequence of calls:
        clear_bit_unlock();
        smp_mb__after_atomic();
        wake_up_bit();
can be replaced exactly by `clear_and_wake_up_bit()`.

The `clear_and_wake_up_bit()` helper function was introduced in
'commit 8236b0ae31c83 ("bdi: wake up concurrent wb_shutdown()
callers.")' to replace equivalent instances of this sequence of
operations. This substitution has been applied in multiple subsystems.

Compile-tested with CONFIG_CIFS=3Dy on x86_64, no new warnings present.

Suggested-by: Agatha Isabelle Moreira <code@agatha.dev>
Link: https://kernelnewbies.org/Beginner%20Cleanup%20and%20Refactor%20Tasks=
%20by%20Agatha%20Isabelle%20Moreira#task_010
Cc: Agatha Isabelle Moreira <code@agatha.dev>
Signed-off-by: Mehdi Hassan <mehdi.h.business@pm.me>
---
 fs/smb/client/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1dbcfd163ff0..2ed1c79c1132 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2812,9 +2812,7 @@ cifs_revalidate_mapping(struct inode *inode)
 =09}
=20
 skip_invalidate:
-=09clear_bit_unlock(CIFS_INO_LOCK, flags);
-=09smp_mb__after_atomic();
-=09wake_up_bit(flags, CIFS_INO_LOCK);
+=09clear_and_wake_up_bit(CIFS_INO_LOCK, flags);
=20
 =09return rc;
 }
--=20
2.54.0



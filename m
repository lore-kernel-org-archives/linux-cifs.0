Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0021312CDA5
	for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 09:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757496678; cv=none; b=ePEkz3rjD33LsWWOT5zu642kIEp8evwzQMZVpmOFLUNIHaO8PeacajqmlqdMetLhjhGMdTN7e70YNu53Gu/fMTPNygP29ZI+Rm8gTYNQX6hUzMGYcKcu2YZcBZAxAI7nOFmrk0A6cKsXGlocAQPutRodxoZTXb68w9KzBTwIKf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757496678; c=relaxed/simple;
	bh=GRSzaGpG/1Xr/xQMzkU/cR7wAlBMfgRGNzsp1bxaV/s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=HsN/JoKftPMUQHLzj+80RZPkSoe5dwVbWNUp1pd7RZJf64V5ryneWHEqipqyIFY5awCupTeVt1tp7zLkKIlehtp3ZkAkPD5AZSTfZOBI8/YwikViQwM7w7MA52EeNCdO+Lzo69mTeZ6x5tHDWI3gnidpi6o74O4Scyv3PvGLCQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=meltin.net; spf=pass smtp.mailfrom=meltin.net; dkim=pass (2048-bit key) header.d=meltin.net header.i=@meltin.net header.b=FKu7Pfls; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=meltin.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meltin.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meltin.net header.i=@meltin.net header.b="FKu7Pfls"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meltin.net;
	s=202409; t=1757496673;
	bh=l4Wc7wiJDcgKf4QsZpzLLHYgzcGBGhYMkF50CJwWq/Y=;
	h=Date:From:To:Subject:From;
	b=FKu7PflsCzYl80vkxmsiaIQddzgfNWfYFYLNPXN6UrdWedpdQsVT9xbbyRPBWrjk0
	 mf4u3riurTtfYUqwhfbrX/ZNYYmrRKohxXcQHhVC7yUhJxtB/h+bUYU2C9LefUSoKB
	 W8IqPNKbDGgt4q3YOXlvowLPYlPb0jDLcEXgit6HymBGnp8RuAztKtoLjTW4py+4HY
	 wtOcmPP4UBB4k8hRmHvPvoDaHWVehAvNIxYVkVCGH8OYFmuQHhdBGq3F51YVzPd912
	 kF0ahC616jG5k7pCwdT/vl+HpxRpC0tSr6qqo0RB/ethl4+NwMm7Q+hz3N0WqayqgX
	 4nL4JHCC0Y1Hw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4cMFmx1Wyqz4wB1;
	Wed, 10 Sep 2025 19:31:13 +1000 (AEST)
Date: Wed, 10 Sep 2025 19:31:10 +1000
From: Martin Schwenke <martin@meltin.net>
To: linux-cifs@vger.kernel.org
Subject: [PATCH] docs: update username= option to drop invalid examples
Message-ID: <20250910193110.6978809d@martins.ozlabs.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/5c/aLaCHl1AnSsHOUw/NeJC"

--MP_/5c/aLaCHl1AnSsHOUw/NeJC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When hurrying and scanning the documentation, my eye was drawn to the
examples ``user%password`` or ``workgroup/user`` and
``workgroup/user%password``, especially because they were rendered in
bold in my terminal.  I didn't read them in the context of them being
deprecated and experienced a non-zero amount of frustration when they
didn't work.  Given that these no longer work at all, remove them and
add clarity.

peace & happiness,
martin

--MP_/5c/aLaCHl1AnSsHOUw/NeJC
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-docs-update-username-option-to-drop-invalid-examples.patch

From 036719fde9b55a07831bf015e0e58ed2fbf7bc05 Mon Sep 17 00:00:00 2001
From: Martin Schwenke <martin@meltin.net>
Date: Wed, 10 Sep 2025 19:07:48 +1000
Subject: [PATCH] docs: update username= option to drop invalid examples

When hurrying and scanning the documentation, my eye was drawn to the
examples ``user%password`` or ``workgroup/user`` and
``workgroup/user%password``, especially because they were rendered in
bold in my terminal.  I didn't read them in the context of them being
deprecated and experienced a non-zero amount of frustration when they
didn't work.  Given that these no longer work at all, remove them and
add clarity.

Signed-off-by: Martin Schwenke <martin@meltin.net>
---
 mount.cifs.rst | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index d489070..936cacb 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -57,17 +57,14 @@ username=arg|user=arg
   specifies the username to connect as. If this is not
   given, then the environment variable USER is used.
 
-  Earlier versions of mount.cifs also allowed one to specify the
-  username in a ``user%password`` or ``workgroup/user`` or
-  ``workgroup/user%password`` to allow the password and workgroup to
-  be specified as part of the username. Support for those alternate
-  username formats is now deprecated and should no longer be
-  used. Users should use the discrete ``password=`` and ``domain=`` to
-  specify those values. While some versions of the cifs kernel module
-  accept ``user=`` as an abbreviation for this option, its use can
-  confuse the standard mount program into thinking that this is a
-  non-superuser mount. It is therefore recommended to use the full
-  ``username=`` option name.
+  Users must use the discrete ``password=`` and ``domain=`` options to
+  specify relevant values. Including these in the ``username=`` option
+  is no longer supported.
+
+  While some versions of the cifs kernel module accept ``user=`` as an
+  abbreviation for this option, its use can confuse the standard mount
+  program into thinking that this is a non-superuser mount. It is
+  therefore recommended to use the full ``username=`` option name.
 
 password=arg|pass=arg
   specifies the CIFS password. If this option is not given then the
-- 
2.47.3


--MP_/5c/aLaCHl1AnSsHOUw/NeJC--

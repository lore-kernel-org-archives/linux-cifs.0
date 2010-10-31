From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] Add strict cache mode (try #2)
Date: Sun, 31 Oct 2010 22:46:29 +0300
Message-ID: <AANLkTikQtf_z4AC_29L12rV60t6M99FOjmRuTrG6qN18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Here are the set of patches that introduce strict cache semantic into
the cifs client.

1. Add strictcache mount option.
2. Invalidate inode pages on the last close.
3. Add cifs_set_oplock_level.
3. New read logic.
4. New write logic.

--
Best regards,
Pavel Shilovsky.



-- 
Best regards,
Pavel Shilovsky.

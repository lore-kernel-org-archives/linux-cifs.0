From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] Add strict cache mode
Date: Tue, 26 Oct 2010 16:58:40 +0400
Message-ID: <AANLkTi=6Z=r_J+e+8oksTK3Jc6wcreU--NnB3JzXysJ4@mail.gmail.com>
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
3. New read logic.
4. New write logic.

-- 
Best regards,
Pavel Shilovsky.

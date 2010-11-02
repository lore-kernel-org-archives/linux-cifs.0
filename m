From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] Add strict cache mode (try #3)
Date: Tue, 2 Nov 2010 11:59:32 +0300
Message-ID: <AANLkTinEQ_vJrP7TPH63R5H0eh74g+a950XMMvkjHBs=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

New variants of the patches in the oder like Jeff suggested.

1. Add cifs_set_oplock_level.
2. Invalidate inode pages on the last close.
3. New read logic.
4. New write logic.
5. Add strictcache mount option.

-- 
Best regards,
Pavel Shilovsky.

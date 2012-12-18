From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: setting crypto signing key
Date: Tue, 18 Dec 2012 13:25:38 -0600
Message-ID: <CAH2r5mtDOhCiAi9yJMYDyj8C_eKDLVVH8e1ZHPMdGaH3PGBtJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs calls crypto_shash_setkey repeatedly (every time we do
smb2_calc_signature in fs/cifs/transport.c).  Shouldn't this only be
called only once (at sesion establishment time, or whenever the
session key changes due to network reconnection) not on every request?

-- 
Thanks,

Steve

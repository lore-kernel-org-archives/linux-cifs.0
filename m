From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs-2.6.git for-next branch rebased on current mainline
Date: Wed, 5 Dec 2012 13:33:20 -0600
Message-ID: <CAH2r5murbv-ozTEh-J=WJRF0kvK7D5+zMxgQHfN0F1CMUfK=GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs-2.6.git for-next branch now is rebased on more current mainline
(Al had merged a cifs fix into mainline very recently and I want to
reduce upcoming merge conflicts).   A good chunk of Pavel's and Jeff's
fixes are in, but will be merging more.  smb2.02 dialect is enabled.
smb3 mounts should work (although SMB3 signing is not working yet).
Let me know if others for 3.8 are missing that are acked/reviewed

-- 
Thanks,

Steve

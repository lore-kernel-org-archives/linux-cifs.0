From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][SMB3] New structs and defines from MS-SMB2
Date: Mon, 5 Feb 2018 14:54:05 -0600
Message-ID: <CAH2r5mtATZn8gTiO0j8wdsPFXjbEFJnVNrTzXq+Yn-i4iRzz4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I checking through the structs and defines for the new tcon related
features in MS-SMB2 protocol documentation, I also noticed a few
missing flags so updated smb2pdu.h to include them.

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=022bdb0c463ea4df4ab5039b1685fe54b6810a61

If you notice any additional missing ones (I focused on the last three
revs to MS-SMB2 over the last couple days so might have missed some
older ones) or errors, let me know.

-- 
Thanks,

Steve

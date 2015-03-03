From: "pisymbol ." <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How does mounting with BACKUP INTENT work in CIFS?
Date: Tue, 3 Mar 2015 14:52:17 -0500
Message-ID: <CAPpy_fGs693BzGS3-pjtKvvkFo+Lwgqjgwq+4WmUthcUMRM0uA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A colleague and I just witnessed that we could not write an access
time of a file on a CIFS mount using CentOS 6.5 despite the fact we
mounted it with "Backup Intent."

My current theory is that via CIFS, the DACL checks still apply
because Window backup clients use a different API to access files.
However, I'm not 100% sure.

Notes:

- The machine was joined to AD
- The account we used to mount was in the domain's Backup Operators group.
- We used backupuid=0 (root) when we mounted the share.

After adding the the Backup Operators group to the share, we were able
to successfully restore access times and everything just worked.

Is it true that via purely SMB/CIFS, you don't entirely get around
normal DACLs checks via mount.cifs? How does this work within CIFS?

Thanks!

-aps (Alex)

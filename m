From: Kai Blin <kai-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add rwpidforward mount option (try #2)
Date: Mon, 2 May 2011 14:54:55 +0000 (UTC)
Message-ID: <loom.20110502T163337-799@post.gmane.org>
References: <1303129252-7006-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovsky <piastry@...> writes:

Hi Pavel,

> 
> Add rwpidforward mount option that switches on a mode when we forward
> pid of a process who opened a file to any read and write operation.
> 
> This can prevent applications like WINE from failing on read or write
> operation on a previously locked file region from the same netfd from
> another process if we use mandatory brlock style.
> It is actual for WINE because during a run of WINE program two processes
> work on the same netfd - share the same file struct between several VFS
> fds:
> 1) WINE-server does open and lock;
> 2) WINE-application does read and write.

I'm not sure I fully understand what problem you're trying to solve here.
The Wine server should take care of all the locking-related operations and make 
sure the application process should have access to the file. I'm not familiar 
with exactly how this happens, but I'm not sure how this would be any different 
for CIFS-based file systems opposed to local file systems. I'm pretty sure it 
works fine for local file systems.

Can you elaborate what problem you're seeing that your patches fix?

Cheers,
Kai

PS: I'm not subscribed to this list, so please CC me :)

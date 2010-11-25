From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Make cifsFileInfo_put work with strict cache mode
 (try #3)
Date: Thu, 25 Nov 2010 13:51:29 +0300
Message-ID: <AANLkTikhDHcSK2p6UJKtTS4rNq-bMWDarYd=PTHg-TUN@mail.gmail.com>
References: <1290368618-12918-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290368618-12918-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/21 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On strict cache mode when we close the last file handle of the inode we
> should set invalid_mapping flag on this inode to prevent data coherency
> problem when we open it again but it has been modified by other clients.
>

What's about this patch and other strictcache mode related things?

-- 
Best regards,
Pavel Shilovsky.

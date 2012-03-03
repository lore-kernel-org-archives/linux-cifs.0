From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Do not kmalloc under the flocks spinlock
Date: Sat, 3 Mar 2012 11:53:40 +0400
Message-ID: <CAKywueRcPg3==V3boO7CX8XnTooVH+Faw9pALNJyP+tkDbybEw@mail.gmail.com>
References: <1330759240-7459-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330759240-7459-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/3/3 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Reorganize the code to make the memory already allocated before
> spinlock'ed loop.
>

Forgot to change patch version - reposted.

-- 
Best regards,
Pavel Shilovsky.

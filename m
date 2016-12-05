From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] CIFS: Fix missing nls unload in smb2_reconnect()
Date: Mon, 5 Dec 2016 11:03:55 -0800
Message-ID: <CAKywueROW-494MfgyAo_8OHc0UOZxX510dGjk9DEDG-Fx1K-hQ@mail.gmail.com>
References: <1480467416-13636-1-git-send-email-pshilov@microsoft.com>
 <1480467416-13636-3-git-send-email-pshilov@microsoft.com> <1480920506.3464.3.camel@redhat.com>
 <CAH2r5msBN2Gh==g5BOC5Woe0WaNvXxug38tfvG4cGUvUo7MovA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msBN2Gh==g5BOC5Woe0WaNvXxug38tfvG4cGUvUo7MovA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-12-05 0:02 GMT-08:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Pavel,
> I couldn't find the original for this patch.
>
> Do you have a git tree I can pull them from?  I wanted to merge this
> and your verbosity ioctl patch, and look to see if I had missed others
> which are already reviewed and ready to merge into for-next
>

Steve,

You can pull from https://github.com/piastry/linux/commits/stable-fixes.

-- 
Best regards,
Pavel Shilovsky

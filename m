From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Patch review for Jeff's UNC path processing series
Date: Mon, 10 Dec 2012 15:37:35 +0400
Message-ID: <CAKywueT4_DWmXb67eAnsiAezegQLFRExx=5VwLvS3iMfjVCMSg@mail.gmail.com>
References: <CAH2r5mtX7NjRaKdrW9sagfsN+SxsQyHvuYOp4kYODSPTwDJCuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtX7NjRaKdrW9sagfsN+SxsQyHvuYOp4kYODSPTwDJCuQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/12/10 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Any one able to review Jeff's last 4 unmerged cifs patches?
>
> See:
> http://git.samba.org/?p=jlayton/linux.git;a=shortlog;h=refs/heads/cifs-next
>
> cifs: parse the device name into UNC and prepath
> cifs: fix up handling of prefixpath= option     commit | commitdiff | tree
> cifs: clean up handling of unc= option  commit | commitdiff | tree
> cifs: fix SID binary to string conversion

Patches looks ok to me. Acked-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>.

Also, there is still one pending patch in my for-next branch: "CIFS:
Fix write after setting a read lock for read oplock files" (I delayed
O_DENY series for now - need more thoughts and feedback).

-- 
Best regards,
Pavel Shilovsky.

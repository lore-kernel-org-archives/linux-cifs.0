From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][CIFS] Fix problem incorrectly closing file during query
 of reparse points
Date: Thu, 2 Oct 2014 21:01:28 +0400
Message-ID: <CAKywueSBtVJC1DbEvH_u86BUgd1unhi7jnkAF5+dh2q5cWqBag@mail.gmail.com>
References: <CAH2r5mvqGrTvFs7cTOOovTGbRXNRgOuwXbS29NV8R5hnrWCRvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvqGrTvFs7cTOOovTGbRXNRgOuwXbS29NV8R5hnrWCRvA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-09-25 11:14 GMT+04:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> [PATCH] Fix problem recognizing symlinks
>
> Changeset eb85d94bd introduced a problem where if a cifs open
> fails during query info of a file we
> will still try to close the file (happens with certain types
> of reparse points) even though the file handle is not valid.
>
> In addition for SMB2/SMB3 we were not mapping the return code returned
> by Windows when trying to open a file (like a Windows NFS symlink)
> which is a reparse point.
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> CC: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v3.13+
>
> See attached or git tree at
> http://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next

Looks correct.

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.

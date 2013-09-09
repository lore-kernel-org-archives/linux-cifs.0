From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs patch merge status
Date: Mon, 9 Sep 2013 11:33:43 +0400
Message-ID: <CAKywueQfb=RQh01hghqbD+PqCAekCw9CsrbUKHL3unJT2yPR+Q@mail.gmail.com>
References: <CAH2r5mucFP3i6NNt78-iLcp8AuEBaN35CbA2WXvonn7SV7RDUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mucFP3i6NNt78-iLcp8AuEBaN35CbA2WXvonn7SV7RDUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/9/9 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Have merged the rest of Pavel's patches into cifs-2.6.git for-next,
> but had to do various minor changes to avoid merge conflicts.
>
> If anyone sees any problems with that series let me know.  I will do
> some additional testing on it this week.

Steve,

I have rebased my patches (since #3 to #8) on top of your for-next
branch with some changes (new comments, epoch value initialization for
smb2.0/2.1). You can found new versions in my for-next branch at
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-next.
Also I can post it to the list if it is needed.

-- 
Best regards,
Pavel Shilovsky.

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: fix wsize patch
Date: Sun, 22 Jun 2014 20:46:18 +0400
Message-ID: <CAKywueQ1Np0ZUEUzYofNjtfhSfvXcEWn0Y0+pPfK+hMThL4S9g@mail.gmail.com>
References: <CAH2r5mvKO7J_zD2vBH=Jmp-OU3=bNm4PLN+KVBHGnrobr8m-Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvKO7J_zD2vBH=Jmp-OU3=bNm4PLN+KVBHGnrobr8m-Gg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-06-22 3:21 GMT+04:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Pavel,
> Does this patch of yours, which fixes the problem if server shrinks
> negotiated wsize on rsmb2/smb3 econnect, need to go in this merge
> window?
>
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commit;h=4c88ec0bc8275898fb6111171e7c0428294e6b78
>
> --
> Thanks,
>
> Steve

I have another smaller version of this patch
(http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commitdiff;h=c4a91bd069bd0cf176544398b8815adf429f7989;hp=d0e0c3c471acda3f96196ac54632748946471f0a),
but as the previous one it applies on top of another changes in my
branch (http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev-5).

Anyway I think it's too risky to apply it during this stage because
this problem is also addressed by "CIFS: Fix cifs_writev_requeue when
wsize changes" and "CIFS: Fix wsize usage in iovec write" patches that
more complicated.

I am going to give the mentioned branch a little more testing and post
to the list in a short time.

-- 
Best regards,
Pavel Shilovsky.

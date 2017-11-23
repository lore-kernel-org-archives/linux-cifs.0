From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SMB3] Updates for 4.15
Date: Thu, 23 Nov 2017 00:39:16 -0600
Message-ID: <CAH2r5mt2JJaXaEOJ=ymQ9CV1kwop+qi05+hkuxyEunMQ3cnHug@mail.gmail.com>
References: <CAH2r5msieYWn-5_9OX+OYpvVOdsEAjG8aCuSFzi1Mcb3A+x9gg@mail.gmail.com>
 <CA+55aFwkz4kScTmkjBkZ-v5yf57h2Vt8t1X8EsT9yLMLwRExnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwkz4kScTmkjBkZ-v5yf57h2Vt8t1X8EsT9yLMLwRExnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

OK.

I had to deal with some minor merge conflicts between the two patch
series so the normal integration, xfstesting took longer than
expected.

On Thu, Nov 23, 2017 at 12:31 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, Nov 22, 2017 at 10:35 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Please pull the following changes since commit
>> ed30b147e1f6e396e70a52dbb6c7d66befedd786:
>
> No.
>
> I asked people to send me pull requests early due to my travels, and
> I'm letting stuff slide that was at least in linux-next.
>
> But this hasn't been in next, and it got sent late in the merge
> window, so it has gotten absolutely zero integration testing, and
> because of my travels I don't do even my regular "full modular build".
>
> So I'm not pulling this, and I expect that I'm not going to pull this either:
>
>> I expect to have another set of SMB3 RDMA patches from Long Li and Pavel in
>> a few days after additional testing, as well as a few SMB3.1.1 fixes
>> (improve security).
>
> unless it has magically been in linux-next, or it is clearly _just_ an
> actual bug-fix.
>
>                 Linus



-- 
Thanks,

Steve

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Samba client problem
Date: Tue, 25 Sep 2012 16:32:25 -0400
Message-ID: <CAH2r5mvyS8FYYeuUFtzC_T9KuHQ2XRGHvoazQee43PqGGu0f2w@mail.gmail.com>
References: <CABFBh7j7rfRG0n2OC93aS7k7231zpvCwXD_uE4T5UUkhHyiOTw@mail.gmail.com>
	<CAH2r5msiu1ojey5ZNdYo15UOVcy9sXSRTsjT=OZbGULuEhL-tg@mail.gmail.com>
	<CABFBh7iJtQi3=MiKcXtNYYqNXMmYf0jWbKSVT=tt+fffN60pwQ@mail.gmail.com>
	<CAH2r5mvE03BW29nisR9ZPHJ2Qxo9R45GakJkrM0Dki_X9Y8+Hg@mail.gmail.com>
	<CABFBh7j7kBBH_czxEUh=tRhdwZ5nAkRpr-+TL=dBt66aRtTifA@mail.gmail.com>
	<CAH2r5msnQ49P=ayxf6atC731P4TevkAQUF5qnibzZK+6C9Tvtg@mail.gmail.com>
	<CABFBh7gBNUX7FbFZWugAUVootCdvh7bsOH6H2NOTTG1TCpi1Ew@mail.gmail.com>
	<CABFBh7hESnn=tUPeKxgCeoLAEO_7NqF8122O7+gmiYGxzWVi5A@mail.gmail.com>
	<CAH2r5mvstLa_Z+xrHYQbAVUvVYV1Q54-=vBtaxoizSy0ijpAbA@mail.gmail.com>
	<6A27F53C-77A3-4FB9-9EBA-79BB4663A0AD@gmail.com>
	<CAH2r5mvSTNLoiB4qjnQO_C5ZMtNcKj6mee3M5ZLDGjGRKyH6cQ@mail.gmail.com>
	<CABFBh7ixb0OsGsoaP=2-LYC76xt14fRABu4KvLvakN9OUZarug@mail.gmail.com>
	<CAH2r5muXjwn8_LPf3HDDC8WOXdThY68H9fE212VJLigmh1gu-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muXjwn8_LPf3HDDC8WOXdThY68H9fE212VJLigmh1gu-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I understand that this will be easier with SMB2 than with cifs but
have to wait another release of the kernel for SMB2 support to be
included.

On Tue, Sep 25, 2012 at 4:21 PM, Jun Yi <yi.jun.mail-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Steve,
>
> In what linux version, the cifs.ko support SMB2?  Does ubuntu 12.04 support
> SMB2?

In Linux kernel 3.6 you can mount smb2 (with mount option "vers=2.1",
but it requires enabling CONFIG_BROKEN) but few file/inode operations
work.  In 3.7 you will be able to mount with "vers=2.1" and "vers=3.0"
(with CONFIG_EXPERIMENTAL)


--
Thanks,

Steve


-- 
Thanks,

Steve

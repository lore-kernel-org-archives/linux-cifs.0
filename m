From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: new for-3.6/for-next branches
Date: Mon, 10 Sep 2012 15:09:22 -0500
Message-ID: <CAH2r5mtv=t7ED+=3PC+w8AQdN_=bEDAdzbh_zw+RbQQpTP28rg@mail.gmail.com>
References: <CAKywueS9Y+Lv_-_pDXRguGVS5jp0CVOqZJc67+GHoS8+y-gtvQ@mail.gmail.com>
	<CAH2r5ms0MrAps2AXdokNx8pJJwdR2Pk4sWaWBtcu0HRH_8PU9g@mail.gmail.com>
	<20120910085821.6584004d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120910085821.6584004d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Sep 10, 2012 at 7:58 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 4 Sep 2012 12:06:25 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I plan to put these back in cifs-2.6.git for-next branch after
>> rescanning through them.  for-next branch is resynced with linus's
>> tree as of yesterday.

Sorry about that ... was out much of last three weeks (death in the family).

> We're at -rc5 now and Pavel's and my patches are *still* not in
> linux-next. Any ETA on getting that done?

They are in for-next now (the first 47 patches, am still looking more
at the next 23).  I also sent a merge request for the two patches for
3.6 that had
been sitting for a week in the cifs-2.6.git tree (now in for-linus branch).

> Steve, I'm still willing to maintain the linux-next branch if you don't
> have the time to deal with it.

What would really help ... is a test automation process similar to
Samba (and Ganesha etc) for the kernel cifs.ko so we can make sure the
obvious (connectathon, fsx etc.) pass before we put in changes to
for-next.  What does nfs kernel client do?
-- 
Thanks,

Steve

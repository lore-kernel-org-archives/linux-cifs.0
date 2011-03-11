From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: revalidate inode before generic_file_aio_read
Date: Fri, 11 Mar 2011 12:01:26 +0300
Message-ID: <AANLkTik2JJaxZxhwv+gUYCo+L+=t2siELbSYE1kkTqby@mail.gmail.com>
References: <AANLkTinfzBXvfNmerWHoMuZ8NkeZLJxNE=MJYcFhA8Nu@mail.gmail.com>
	<4D78A476.7050800@suse.de>
	<AANLkTinVkxs9vO9QP_BdmFfRcK5duVWviFAbgg6NoSHw@mail.gmail.com>
	<20110310154933.1fa017a0@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110310154933.1fa017a0-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 10 Mar 2011 13:33:32 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2011/3/10 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
>> > Did you mean while using strict cache along with actimeo? Conceptually
>> > one should not be needing to use them together, right?
>>
>> I don't mean strict cache mode and suggested to do it for
>> non-strictcache mounts. Sorry for didn't make it clear in the first
>> email.
>>
>
> I think it's a reasonable thing to do. I proposed something similar
> about a year ago, but Steve NAK'ed it. It was part of this patchset,
> some of which made it in:
>
> http://lists.samba.org/archive/linux-cifs-client/2010-February/005548.html
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Steve, can you comment, please?

-- 
Best regards,
Pavel Shilovsky.

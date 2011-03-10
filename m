From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: revalidate inode before generic_file_aio_read
Date: Thu, 10 Mar 2011 13:33:32 +0300
Message-ID: <AANLkTinVkxs9vO9QP_BdmFfRcK5duVWviFAbgg6NoSHw@mail.gmail.com>
References: <AANLkTinfzBXvfNmerWHoMuZ8NkeZLJxNE=MJYcFhA8Nu@mail.gmail.com>
	<4D78A476.7050800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D78A476.7050800-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/10 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> Did you mean while using strict cache along with actimeo? Conceptually
> one should not be needing to use them together, right?

I don't mean strict cache mode and suggested to do it for
non-strictcache mounts. Sorry for didn't make it clear in the first
email.

-- 
Best regards,
Pavel Shilovsky.

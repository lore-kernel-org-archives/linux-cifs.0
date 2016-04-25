From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Design of fsnotify for FUSE, nfs and cifs: when/how to send a watch.
Date: Sun, 24 Apr 2016 22:32:44 -0500
Message-ID: <CAH2r5mvahP1Vkp+=84O3BntjwNvu4k498S1CjxZ2mhKu8GhDKg@mail.gmail.com>
References: <CANXojcz-U4YzgUhDRgvoVX=n756oVg4nvvvwpimmpBJyLkkmoQ@mail.gmail.com>
 <CANXojcwF1ePzsLjpVbPZNdQTO6wG3xh2GQe6fPNJ5H4sZur-mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcwF1ePzsLjpVbPZNdQTO6wG3xh2GQe6fPNJ5H4sZur-mA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It is an interesting idea to enable fsnotify on the mount level.  Do
you have any data on performance impact of fsnotify in your testing
with fuse?

On Thu, Apr 21, 2016 at 2:26 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> the links does not work. The trailing dot causes this. Goto the wiki
> and select the right page:
>
> https://github.com/libfuse/libfuse/wiki
>
> Stef



-- 
Thanks,

Steve

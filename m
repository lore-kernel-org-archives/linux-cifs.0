From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about notify.
Date: Mon, 25 Apr 2011 09:53:58 -0500
Message-ID: <BANLkTin-osWCeYMAmmRACkVUWqmu2R9Hfg@mail.gmail.com>
References: <BANLkTimAs2y121N6RZbzgmKC1+St4xuHrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimAs2y121N6RZbzgmKC1+St4xuHrA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Apr 25, 2011 at 4:06 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> some of you may already know I'm busy with this, I've posted here
> before and at other places about this topic.
>
> see:
>
> http://marc.info/?l=linux-fsdevel&m=130052497829681&w=2
>
>
> In short, I want to make fs's like my FUSE fs and cifs handle inotify
> request, done on userspace.

Interesting.  I think notify support is particularly important for network
file systems (to enable user space file managers to see
when files are added/deleted - without having to poll).  Windows
desktop (and even years ago OS/2) have used SMB/CIFS
notifications to refresh open directory listings automatically.


-- 
Thanks,

Steve

From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: missing inotify CREATE event
Date: Thu, 13 Jun 2013 17:33:38 +0200
Message-ID: <CANXojcwVJK_8FY3-3hn-k8L73c-O-RXAh1YqNF7S96vHYJC-Kg@mail.gmail.com>
References: <CD0910ABB15D264A8E7AB76074385B0F6C838000@EXC11.ads.krz.uni-heidelberg.de>
	<CANXojcx0GpBWoCJ_9-x4gt_m4A1yV7MVhKVWL2MWdMFiXuBK=g@mail.gmail.com>
	<CANXojcxQDoa5wT_8o0XZ+QesQHYgRvPbzZvNdOrfhMkWQbXCng@mail.gmail.com>
	<CD0910ABB15D264A8E7AB76074385B0F6C838AD6@EXC11.ads.krz.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Parzer, Peter" <Peter.Parzer-A1rZ2h3LdSKdPOQpRHQ53DeJuz7u0hKX@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD0910ABB15D264A8E7AB76074385B0F6C838AD6-NnIz8ZQ0gOcQbKGhsapLvJu/t5deHUVybHZAlb1YOWo@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

well touch is not the only app which does this.

I think that the bottleneck is the fs event watcher used by nautlus.

It should check an open call is possibly a create call (by using the
right flags), and it does that probably not. Do you have tested this
behaviour using another filemanager?

It's weird since all futher calls like ATTRIB test (on the second
file) should also result in action in the filemanager. It should find
out that has not yet this entry in it's view, and should thus create
it, correcting earlier errors.

I'm writing a fsevent monitor (notifyfs) which uses inotify as backed
on linux. Clients can connect to notifyfs and receive fsevents when
something happens. I had to tackle this problem myself.

Stef Bon

From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: missing inotify CREATE event
Date: Thu, 13 Jun 2013 15:15:30 +0200
Message-ID: <CANXojcxQDoa5wT_8o0XZ+QesQHYgRvPbzZvNdOrfhMkWQbXCng@mail.gmail.com>
References: <CD0910ABB15D264A8E7AB76074385B0F6C838000@EXC11.ads.krz.uni-heidelberg.de>
	<CANXojcx0GpBWoCJ_9-x4gt_m4A1yV7MVhKVWL2MWdMFiXuBK=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcx0GpBWoCJ_9-x4gt_m4A1yV7MVhKVWL2MWdMFiXuBK=g@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: 2013/6/13
Subject: Re: missing inotify CREATE event
To: "Parzer, Peter" <Peter.Parzer-A1rZ2h3LdSKdPOQpRHQ53DeJuz7u0hKX@public.gmane.org>


Hi,

maybe I can help you.

The utility touch does sometimes create a file using the syscall
create, sometimes using open, with the right flags.
In fact acoording to:

http://pubs.opengroup.org/onlinepubs/7908799/xsh/creat.html

the create call is actually an open call.

So maybe there are reasons for touch to call create in the first case,
and only open in the second.
Did the second one already exist??

Stef

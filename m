From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs ignores sysct setting
Date: Tue, 11 Oct 2011 09:20:17 -0500
Message-ID: <CAH2r5mtRASfeMGJj+Bq596QmkasroatfhFxxGNsYbh_8kNEj0Q@mail.gmail.com>
References: <CAH2r5mu49o4o-zc_1Yg7BG3i9nya3WfxBttMm-W-w755t=UtmQ@mail.gmail.com>
	<a743c035-7baa-4fbf-afd3-957812e2ac70@absint.swen.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
To: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a743c035-7baa-4fbf-afd3-957812e2ac70-VJN6hnAnNNsoZRmjwiK4Kw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 11, 2011 at 9:14 AM, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org> wrote:
> Hi Steve,
>
> thanks for your response.
>
> no, we do permanently turn off oplocks due to some performance issues (with
> some NAS device where our colleagues can't (don't want) configure nfs
> apparently ;-(.
> we do this on several (>20) servers and across reboots...

Isn't it easier just to turn this (oplocks) off on the server?  At
least with Linux cifs.ko
you can turn off oplocks at runtime, with some clients it is much harder.


-- 
Thanks,

Steve

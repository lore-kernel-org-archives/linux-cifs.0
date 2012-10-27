From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] CIFS: Use OID registry facility
Date: Sat, 27 Oct 2012 14:04:21 +0100
Message-ID: <11913.1351343061@warthog.procyon.org.uk>
References: <CADT32eK73Y9dxsGJba1Nuxyp7_4iYk_yeQe_GY1ztCDVwZT04g@mail.gmail.com> <20121022142318.6989.5077.stgit@warthog.procyon.org.uk> <20121022142326.6989.45552.stgit@warthog.procyon.org.uk> <CADT32eKTZTQw70Wu2gvqF6yorKqEoA=1m0SP=QkGqieaSEFbQQ@mail.gmail.com> <12049.1350933186@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eK73Y9dxsGJba1Nuxyp7_4iYk_yeQe_GY1ztCDVwZT04g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> >> How do I incorporate/add OID_REGISTRY as a config option?
> >> I do not see that in my .config (3.7)
> >
> > What do you mean?
> >
> > David
> 
> David, I do not see CONFIG_OID_RRGISTRY in .config.

Do you see OID_REGISTRY in lib/Kconfig (probably near the end)?

David

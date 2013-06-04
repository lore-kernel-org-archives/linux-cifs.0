From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/11] locks: scalability improvements for file
 locking
Date: Tue, 4 Jun 2013 08:15:17 -0400
Message-ID: <20130604081517.0ad9f983@corrin.poochiereds.net>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
	<20130603213101.GC2109@fieldses.org>
	<20130604065417.46080a57@tlielax.poochiereds.net>
	<20130604115644.GA4180@umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	matthew-Ztpu424NOJ8@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130604115644.GA4180-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 4 Jun 2013 07:56:44 -0400
Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:

> Jeff Layton wrote:
> 
>   > Might be nice to look at some profiles to confirm all of that.  I'd also
>   > be curious how much variation there was in the results above, as they're
>   > pretty close.
>   > 
>   
>   The above is just a random representative sample. The results are
>   pretty close when running this test, but I can average up several runs
>   and present the numbers. I plan to get a bare-metal test box on which
>   to run some more detailed testing and maybe some profiling this week.
> 
> Just contributing more runs into the mean doesn't tell us anything about the
> variance. With numbers that close you need the variance to tell whether it's
> a significant change.

Thanks. I'll see if I can get some standard deviation numbers here, and
I'll do it on some bare metal to ensure that virtualization doesn't
skew any results.

FWIW, they were all consistently very close to one another when I ran
these tests, and the times were all consistently shorter than the
unpatched kernel.

That said, this test is pretty rough. Doing this with "time" measures
other things that aren't related to locking. So I'll also see if I
can come up with a way to measure the actual locking performance more
accurately too.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

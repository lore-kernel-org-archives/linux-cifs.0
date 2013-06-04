From: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH v1 00/11] locks: scalability improvements for file locking
Date: Tue, 4 Jun 2013 07:56:44 -0400
Message-ID: <20130604115644.GA4180@umich.edu>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
 <20130603213101.GC2109@fieldses.org>
 <20130604065417.46080a57@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	matthew-Ztpu424NOJ8@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130604065417.46080a57-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Jeff Layton wrote:

  > Might be nice to look at some profiles to confirm all of that.  I'd also
  > be curious how much variation there was in the results above, as they're
  > pretty close.
  > 
  
  The above is just a random representative sample. The results are
  pretty close when running this test, but I can average up several runs
  and present the numbers. I plan to get a bare-metal test box on which
  to run some more detailed testing and maybe some profiling this week.

Just contributing more runs into the mean doesn't tell us anything about the
variance. With numbers that close you need the variance to tell whether it's
a significant change.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

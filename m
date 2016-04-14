From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 1/8] cifs: Fix xattr name checks
Date: Thu, 14 Apr 2016 05:37:18 +0100
Message-ID: <20160414043718.GS25498@ZenIV.linux.org.uk>
References: <20160413182026.GR25498@ZenIV.linux.org.uk>
 <1460586620-5717-1-git-send-email-agruenba@redhat.com>
 <1460586620-5717-2-git-send-email-agruenba@redhat.com>
 <CAH2r5mumJ22+Q0bASFcXp5fK39Ubh+sznfOpVUtSJ94_c5gkxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mumJ22+Q0bASFcXp5fK39Ubh+sznfOpVUtSJ94_c5gkxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 13, 2016 at 11:26:24PM -0500, Steve French wrote:
> Thanks for spotting this - merged into cifs-2.6.git.   checkpatch
> spotted and old indentation issue so I cleaned that up in a followon
> patch that I will send.

*ugh*

And in the meanwhile I'd picked those into my queue...  Could you put that
stuff on a separate branch so that both cifs-2.6.git and vfs.git could
merge it?

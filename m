From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Lsf] [RFC] writeback and cgroup
Date: Sun, 15 Apr 2012 20:25:30 -0500
Message-ID: <CAH2r5msT-PgA5gqFTFBgDUQbPKzyEohKQ_auKX1jZLtivUJmxg@mail.gmail.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120404145134.GC12676@redhat.com>
	<20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
	<1334404423.2528.75.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334404423.2528.75.camel@twins>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This long thread on linux-mm and linux-fsdevel has been discussing
writeback, throttling, cgroups etc.=A0 This post reminded me that we
should look more carefully at the cifs bdi implementation, compare to
nfs, and also check what needs to be improved in the bdi
implementation to handle smb2 credits.=A0 It will be interesting to see
if that will help writeback.

On Sat, Apr 14, 2012 at 6:53 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
>
> On Wed, 2012-04-04 at 11:49 -0700, Tejun Heo wrote:
> > > - How to handle NFS.
> >
> > As said above, maybe through network based bdi pressure propagation=
,
> > Maybe some other special case mechanism. =A0Unsure but I don't thin=
k
> > this concern should dictate the whole design.
>
> NFS has a custom bdi implementation and implements congestion control
> based on the number of outstanding writeback pages.
>
> See fs/nfs/write.c:nfs_{set,end}_page_writeback
>
> All !block based filesystems have their own BDI implementation, I'm n=
ot
> sure on the congestion implementation of anything other than NFS thou=
gh.
> _______________________________________________
> Lsf mailing list
> Lsf-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/lsf




--
Thanks,

Steve

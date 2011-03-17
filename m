From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Allocating SMB2 mids (multiplex identifier structures)
Date: Thu, 17 Mar 2011 09:54:48 -0500
Message-ID: <AANLkTikfxS=5E2QvSS6V-52cdjPKOKN2kd_PBQJnTSbo@mail.gmail.com>
References: <AANLkTi=oYKfaOP-oHbBKODddGkzAWg7bBsY2_ZT9e-W8@mail.gmail.com>
	<20110317143514.GB3295@infradead.org>
	<AANLkTin-YWNgvdNpZQx28hXR9ZdhQciCLgEhUwqZf3-C@mail.gmail.com>
	<20110317104734.534a2ee4@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110317104734.534a2ee4-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 17, 2011 at 9:47 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Thu, 17 Mar 2011 09:41:34 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Mar 17, 2011 at 9:35 AM, Christoph Hellwig <hch-wEGCiKHe2LouzsEnZMApLA@public.gmane.org=
g> wrote:
>> > Btw, what branch are these commits for? =A0I dearly hope you're no=
t trying
>> > to push half-assed code to mainline. =A0Please do your development=
 on a
>> > branch first, and once there is a useable implementation it can be
>> > reviewed and synced over. =A0Take a look at pnfs development for e=
xample.
>>
>> We have an implementation that was in the test tree for a year, went
>> through 3 test events that is being ported. =A0I don't think it will
>> take more than a week or so to get enough of it in. =A0Unless it get=
s
>> upstream, it is not going to get much wider review than from the
>> original group (Pavel, Jeremy etc). =A0Note that all code is marked =
as
>> "broken" and the majority in distinct c files - this is not that
>> different than pNFS, which only recently got usable in mainline but
>> was checked in many releases back.
>>
>
> I agree with Christoph here. If the code is marked "broken" then
> merging it seems premature. I'd like to see the majority of this code
> in a branch that we can test before it goes in anywhere.
>
> The exception would be targeted patches that prepare the existing
> code to work with the new SMB2 code. Those can be reviewed and we can
> should be able to take those prior to merging the smb2 code wholesale=
=2E

The code to prepare for SMB2 should be mostly in place in
tree now:
- error mapping
- transport
- mount
- stats

=2E  The sendrcv2 routine was the last part of that and
was waiting on the bigendian change.   I can defer
all inode/file/address routines if you prefer until they are reviewed
together, but the existing version in smb2.git could be used
as a base depending on how much commonality people prefer.


We have had over a year, including work by 4 developers in a distinct
tree and got little meaningful feeback on features though until
recently when it started showing up in cifs-2.6.git  In over a year,
the mainline code diverged in multiple trivial ways that made the port =
harder
because the code was not visible to those outside the small number
of developers who understand smb2.


--=20
Thanks,

Steve

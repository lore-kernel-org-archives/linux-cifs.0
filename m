From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Allocating SMB2 mids (multiplex identifier structures)
Date: Thu, 17 Mar 2011 11:21:29 -0500
Message-ID: <AANLkTikfV20jYmNYu-6RGDyRndGjgy42RPGZLLqqG6h6@mail.gmail.com>
References: <AANLkTi=oYKfaOP-oHbBKODddGkzAWg7bBsY2_ZT9e-W8@mail.gmail.com>
	<20110317143514.GB3295@infradead.org>
	<AANLkTin-YWNgvdNpZQx28hXR9ZdhQciCLgEhUwqZf3-C@mail.gmail.com>
	<20110317104734.534a2ee4@barsoom.rdu.redhat.com>
	<AANLkTikfxS=5E2QvSS6V-52cdjPKOKN2kd_PBQJnTSbo@mail.gmail.com>
	<20110317110406.06388256@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110317110406.06388256-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 17, 2011 at 10:04 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Thu, 17 Mar 2011 09:54:48 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Mar 17, 2011 at 9:47 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Thu, 17 Mar 2011 09:41:34 -0500
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Thu, Mar 17, 2011 at 9:35 AM, Christoph Hellwig <hch@infradead=
=2Eorg> wrote:
>> >> > Btw, what branch are these commits for? =A0I dearly hope you're=
 not trying
>> >> > to push half-assed code to mainline. =A0Please do your developm=
ent on a
>> >> > branch first, and once there is a useable implementation it can=
 be
>> >> > reviewed and synced over. =A0Take a look at pnfs development fo=
r example.
>> >>
>> >> We have an implementation that was in the test tree for a year, w=
ent
>> >> through 3 test events that is being ported. =A0I don't think it w=
ill
>> >> take more than a week or so to get enough of it in. =A0Unless it =
gets
>> >> upstream, it is not going to get much wider review than from the
>> >> original group (Pavel, Jeremy etc). =A0Note that all code is mark=
ed as
>> >> "broken" and the majority in distinct c files - this is not that
>> >> different than pNFS, which only recently got usable in mainline b=
ut
>> >> was checked in many releases back.
>> >>
>> >
>> > I agree with Christoph here. If the code is marked "broken" then
>> > merging it seems premature. I'd like to see the majority of this c=
ode
>> > in a branch that we can test before it goes in anywhere.
>> >
>> > The exception would be targeted patches that prepare the existing
>> > code to work with the new SMB2 code. Those can be reviewed and we =
can
>> > should be able to take those prior to merging the smb2 code wholes=
ale.
>>
>> The code to prepare for SMB2 should be mostly in place in
>> tree now:
>> - error mapping
>> - transport
>> - mount
>> - stats
>>
>> . =A0The sendrcv2 routine was the last part of that and
>> was waiting on the bigendian change. =A0 I can defer
>> all inode/file/address routines if you prefer until they are reviewe=
d
>> together, but the existing version in smb2.git could be used
>> as a base depending on how much commonality people prefer.
>>
>>
>> We have had over a year, including work by 4 developers in a distinc=
t
>> tree and got little meaningful feeback on features though until
>> recently when it started showing up in cifs-2.6.git =A0In over a yea=
r,
>> the mainline code diverged in multiple trivial ways that made the po=
rt harder
>> because the code was not visible to those outside the small number
>> of developers who understand smb2.
>>
>
> One of the stated goals here is to minimize disruption to the existin=
g
> cifs codebase. The best way to do that is to break out the changes
> needed to the existing codebase into a separate set of patches and po=
st
> those for review. The endianness change for the smb_buf_length is a
> good example of this sort of change. Once those changes have reviewed
> and merged, then we can start discussing how to merge the rest of the
> SMB2 support.
>
> I really don't think this approach is at all unreasonable. It may mea=
n
> a little more work on your end to break out these changes logically,
> but I think it really needs to be done that way.

Whatever makes it easier to get broader review is good.   It is
frustrating of course that some of these changes we are discussing have
been brought up before, and weren't high priority until the discussion
of how to make smb2 transport patch as small as possible
(smaller than what was in smb2.git).

As requested, I will put  the smbtransport patch into a new smb2
specific branch on cifs-2.6.git.   Since the smb2 related
code which touches core cifs files has already been
discussed, and should be ok  now (with the bigendian
change for smb_buf_length), with no disruption to
cifs code expected - the five new smb2 files (which don't
get compiled in for default cifs) could be removed via
a single patch, and moved to the smb2 specific branch.
The major area I expect review comments on is not
these but rather the final stage of the port of the smb2 code
- how to minimize the file_ops, inode_ops, aops
and having a distinct smb2 branch while these get discussed
would be helpful.

--
Thanks,

Steve

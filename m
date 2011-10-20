From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: allow cifs to do readpages larger and
 asynchronously (try #7)
Date: Wed, 19 Oct 2011 21:38:46 -0500
Message-ID: <CAH2r5mv1NGX3hAdzi-dsx=JmPr_mjEjFi5m8WVNWVv1fQUNR4w@mail.gmail.com>
References: <1319030695-4115-1-git-send-email-jlayton@redhat.com>
	<CAKywueTEa-fDK5edm44+OamNMcmyCQWSDNxMWQc_c2Os9-N8UA@mail.gmail.com>
	<20111019153328.4eb81795@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111019153328.4eb81795-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged, although I had to fixup one checkpatch warning with a trivial
followon patch to freezer.h

WARNING: please, no space before tabs
#97: FILE: include/linux/freezer.h:146:
+^I^I__retval =3D wait_event_killable(wq, ^I^I^I\$


On Wed, Oct 19, 2011 at 2:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 19 Oct 2011 23:22:09 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2011/10/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > This patchset is a respin to fix a bug that Pavel identified in th=
e
>> > readv error handling, and to also fix up some merge conflicts that=
 crept
>> > in with some other patches that Steve merged recently. Other than =
those
>> > changes, this is essentially the same patchset as the earlier vers=
ions
>> > in this series.
>> >
>> > This set is also available via my git tree on samba.org:
>> >
>> > =A0 =A0http://git.samba.org/?p=3Djlayton/linux.git;a=3Dsummary
>> >
>> > Jeff Layton (5):
>> > =A0cifs: fix protocol definition for READ_RSP
>> > =A0cifs: add cifs_async_readv
>> > =A0cifs: convert cifs_readpages to use async reads
>> > =A0cifs: allow for larger rsize=3D options and change defaults
>> > =A0cifs: tune bdi.ra_pages in accordance with the rsize
>> >
>> > =A0fs/cifs/cifspdu.h =A0 | =A0 =A04 +-
>> > =A0fs/cifs/cifsproto.h | =A0 24 ++++
>> > =A0fs/cifs/cifssmb.c =A0 | =A0359 ++++++++++++++++++++++++++++++++=
+++++++++++++++++++
>> > =A0fs/cifs/connect.c =A0 | =A0167 +++++++++++++++---------
>> > =A0fs/cifs/file.c =A0 =A0 =A0| =A0293 ++++++++++++++++++----------=
--------------
>> > =A05 files changed, 612 insertions(+), 235 deletions(-)
>> >
>> > --
>> > 1.7.6.4
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>> Reviewed-and-Tested-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>
>
> Thanks for the review and testing, Pavel.
>
> I've gone ahead and added this to the patches in my git repo and
> re-pushed it. If Steve pulls from there, it should show up with those
> tags in mainline.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve

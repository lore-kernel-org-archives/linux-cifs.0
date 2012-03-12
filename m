From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 00/17] Preparations before SMB2 protocol support
Date: Tue, 13 Mar 2012 01:18:46 +0400
Message-ID: <CAKywueTRbO99gsth-Ed5K5f4PqrCy9-CEw9KadgbVr_CdOnY-g@mail.gmail.com>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
	<20120312112010.1f5eb0ba@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120312112010.1f5eb0ba-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

12 =CD=C1=D2=D4=C1 2012=9A=C7. 19:20 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Sat, =9A3 Mar 2012 12:37:01 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> The goal of this patchset is to reorganize existing CIFS code to mak=
e it
>> easily expandable when SMB2 specific code come into the tree. This l=
et us
>> avoid a code dublication and reduce the whole number of changes comi=
ng
>> with SMB2 code.
>>
>> Pavel Shilovsky (17):
>> =9A CIFS: Simplify inFlight logic
>> =9A CIFS: Introduce credit-based flow control
>> =9A CIFS: Count blocking lock command
>> =9A CIFS: Delete echo_retries module parm
>> =9A CIFS: Make wait_for_free_request killable
>> =9A CIFS: Respect MaxMpxCount field
>> =9A CIFS: Separate protocol-specific code from transport routines
>> =9A CIFS: Separate protocol-specific code from demultiplex code
>> =9A CIFS: Separate protocol-specific code from cifs_readv_receive co=
de
>> =9A CIFS: Expand CurrentMid field
>> =9A CIFS: Change mid_q_entry structure fields
>
> nit: It seems like the above patches ought to be one set and the lowe=
r
> patches ought to be another. No objection to merging them both in 3.3=
,
> however but it's generally easier to get small sets merged than bigge=
r
> ones.
>
>> =9A CIFS: Move locks to file structure
>> =9A CIFS: Fix VFS locks usage
>> =9A CIFS: Convert lock type to 32 bit variable
>> =9A CIFS: Separate protocol specific lock type handling
>> =9A CIFS: Separate protocol specific part from getlk
>> =9A CIFS: Separate protocol specific part from setlk
>>
>> =9Afs/cifs/README =9A =9A =9A | =9A =9A6 +-
>> =9Afs/cifs/cifs_debug.c | =9A 28 ++--
>> =9Afs/cifs/cifs_debug.h | =9A =9A4 +-
>> =9Afs/cifs/cifsfs.c =9A =9A | =9A 18 ---
>> =9Afs/cifs/cifsglob.h =9A | =9A 98 +++++++++++----
>> =9Afs/cifs/cifsproto.h =9A| =9A 18 ++-
>> =9Afs/cifs/cifssmb.c =9A =9A| =9A107 ++++++++++-------
>> =9Afs/cifs/connect.c =9A =9A| =9A123 +++++++++----------
>> =9Afs/cifs/dir.c =9A =9A =9A =9A| =9A =9A5 +-
>> =9Afs/cifs/file.c =9A =9A =9A | =9A254 ++++++++++++++++++++++++++++-=
----------
>> =9Afs/cifs/misc.c =9A =9A =9A | =9A152 +++++++++++++++++-------
>> =9Afs/cifs/netmisc.c =9A =9A| =9A =9A3 +-
>> =9Afs/cifs/transport.c =9A| =9A327 +++++++++++++++++++++++++++++----=
-----------------
>> =9A13 files changed, 702 insertions(+), 441 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =9Ahttp://vger.kernel.org/majordomo-info.html
>
> I like this set overall, but we obviously have some unanswered
> questions about SMB1 behavior.
>
> Here's what I'd suggest for 3.3:
>
> Let's plan to take this patchset or something very similar to it, but
> do it in such a way that we do substantially alter the SMB1 behavior
> yet. IOW, integrate the existing behavior of the SMB1 code into this
> patchset.
>
> You should be fine to change the echo behavior and get rid of
> echo_retries. What we don't want to change yet is the behavior of
> blocking locks, oplock breaks, etc...
>
> Once we have a clearer picture of how we want the SMB1 code to behave=
,
> we can then do a (hopefully small) set of patches to change the SMB1
> behavior for the better.
>
> Does that sound reasonable?
>

That looks right for me - going to change the patchset (leave SMB1
code behavior as it is now) and repost asap. Thanks for reviewing!

--=20
Best regards,
Pavel Shilovsky.

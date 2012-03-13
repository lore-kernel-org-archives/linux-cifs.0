From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/17] Preparations before SMB2 protocol support
Date: Tue, 13 Mar 2012 13:14:05 -0500
Message-ID: <CAH2r5mt5H1-J18+Hy2res3ewf1bx9cs1FGnGfNsYG8Gh51GbaQ@mail.gmail.com>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
	<20120312112010.1f5eb0ba@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120312112010.1f5eb0ba-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Mar 12, 2012 at 10:20 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Sat, =A03 Mar 2012 12:37:01 +0300
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
>> =A0 CIFS: Simplify inFlight logic
>> =A0 CIFS: Introduce credit-based flow control
>> =A0 CIFS: Count blocking lock command
>> =A0 CIFS: Delete echo_retries module parm
>> =A0 CIFS: Make wait_for_free_request killable
>> =A0 CIFS: Respect MaxMpxCount field
>> =A0 CIFS: Separate protocol-specific code from transport routines
>> =A0 CIFS: Separate protocol-specific code from demultiplex code
>> =A0 CIFS: Separate protocol-specific code from cifs_readv_receive co=
de
>> =A0 CIFS: Expand CurrentMid field
>> =A0 CIFS: Change mid_q_entry structure fields
>
> nit: It seems like the above patches ought to be one set and the lowe=
r
> patches ought to be another. No objection to merging them both in 3.3=
,
> however but it's generally easier to get small sets merged than bigge=
r
> ones.
>
>> =A0 CIFS: Move locks to file structure
>> =A0 CIFS: Fix VFS locks usage
>> =A0 CIFS: Convert lock type to 32 bit variable
>> =A0 CIFS: Separate protocol specific lock type handling
>> =A0 CIFS: Separate protocol specific part from getlk
>> =A0 CIFS: Separate protocol specific part from setlk
>>
>> =A0fs/cifs/README =A0 =A0 =A0 | =A0 =A06 +-
>> =A0fs/cifs/cifs_debug.c | =A0 28 ++--
>> =A0fs/cifs/cifs_debug.h | =A0 =A04 +-
>> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 18 ---
>> =A0fs/cifs/cifsglob.h =A0 | =A0 98 +++++++++++----
>> =A0fs/cifs/cifsproto.h =A0| =A0 18 ++-
>> =A0fs/cifs/cifssmb.c =A0 =A0| =A0107 ++++++++++-------
>> =A0fs/cifs/connect.c =A0 =A0| =A0123 +++++++++----------
>> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 =A05 +-
>> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0254 ++++++++++++++++++++++++++++-=
----------
>> =A0fs/cifs/misc.c =A0 =A0 =A0 | =A0152 +++++++++++++++++-------
>> =A0fs/cifs/netmisc.c =A0 =A0| =A0 =A03 +-
>> =A0fs/cifs/transport.c =A0| =A0327 +++++++++++++++++++++++++++++----=
-----------------
>> =A013 files changed, 702 insertions(+), 441 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
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

If we can get agreement on a simple patch to block outgoing requests at
maxmpx (similar to earlier patch) which would be suitable for stable
and address the Windows Vista/7 client (running as a server) - that
would make sense to consider separately.  For that
patch we would avoid the complexity of touching blocking lock behavior.


--=20
Thanks,

Steve

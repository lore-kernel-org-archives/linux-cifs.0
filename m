From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Sat, 21 May 2011 06:34:28 -0500
Message-ID: <BANLkTi=GCdPNTFEqL-r+i8rQv0LDJdgJ0g@mail.gmail.com>
References: <BANLkTin1aphq5JHJkTOVjgSAaPWWYBuYYw@mail.gmail.com>
	<20110521103105.GA20409@infradead.org>
	<BANLkTi=VAnis_mH7GbRr+aH-bNm8uVpWLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=VAnis_mH7GbRr+aH-bNm8uVpWLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, May 21, 2011 at 6:30 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Sat, May 21, 2011 at 5:31 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org=
> wrote:
>> On Fri, May 20, 2011 at 12:41:33PM -0500, Steve French wrote:
>>> Sent the following request up, but plan to send another big set of
>>> changes up with Jeff's aync set (would like help reviewing patches =
3,
>>> 5 and 6 in particular of Jeff's set) and some of Pavel's SMB2 prep
>>> patches in a few days.
>>
>> Steve, as said numours times before: please don't introduce the half
>> baked smb2 bits into mainline yet. =A0Prepare a separate git tree th=
at
>> can actually be reviewed properly for it.
>
> Pavel is reordering the smb2 code and doing cleanup now and this smb2
> code will be in a distinct branch (actually is in a distinct branch o=
n
> his etersoft git server at the moment). =A0 =A0So far, the smb2 pdu w=
orker
> functions, and new error handling function and some misc. functions
> have been multiply reviewed. =A0 The transport handling will need mor=
e
> changes and vfs operations are apparently not ready for review yet.
> I expect the vfs operations to be

Sorry didn't finish the sentence - I expect discussion of vfs
operations for smb2 pretty soon (obviously on list, and in a distinct
branch) but he was doing cleanup and resolving merge conflicts of
other prereqs first.

> Only some minor prep pieces for SMB2 are checked in at this stage.
> None of the new smb2 C =A0files are checked in =A0yet (nor obviously =
is
> CONFIG_CIFS_SMB2 being built). =A0 There are a few more prep patches =
for
> smb2 that affect cifs C files (cleanup of the mid for example) that
> Pavel has updated to 2.6.40 and posted to his server.
>
>
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve

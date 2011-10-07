From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Add mount options for backup intent and their
 manpages (try #6)
Date: Fri, 7 Oct 2011 10:39:23 -0500
Message-ID: <CAH2r5mvKYAA1tm=T5gYH3srkAoppNTce36XB=tDXZovNVaYsrQ@mail.gmail.com>
References: <1317149929-1206-1-git-send-email-shirishpargaonkar@gmail.com>
	<20111003074953.06f8eb5d@tlielax.poochiereds.net>
	<CADT32eJVVHPtva-0pfY+D242sN_EvinoQQGnUn9Yh64fXBTA4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJVVHPtva-0pfY+D242sN_EvinoQQGnUn9Yh64fXBTA4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 7, 2011 at 10:29 AM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Oct 3, 2011 at 6:49 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
>> On Tue, 27 Sep 2011 13:58:49 -0500
>> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>
>>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>>
>>> Add mount options backupuid and backugid and their manpage contents=
=2E
>>> Check for either a valid uid/gid or valid user/group name.
>>>
>>>
>>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> =A0mount.cifs.8 | =A0 14 +++++++++
>>> =A0mount.cifs.c | =A0 85 ++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++-
>>> =A02 files changed, 97 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mount.cifs.8 b/mount.cifs.8
>>> index 81ebdbe..d7eb2dd 100644
>>> --- a/mount.cifs.8
>>> +++ b/mount.cifs.8
>>> @@ -282,6 +282,20 @@ See sections on
>>> =A0for more information\&.
>>> =A0.RE
>>> =A0.PP
>>> +backupuid
>>> +.RS 4
>>> +Allow access to files with the intent to back them up for a user\&=
=2E
>>> +.sp
>>> +An authenticated user at the server with a privilege can access fi=
le system objects with the intent to back them up to which it otherwise=
 may not have access permissions. =A0As an example, a privilege would b=
e "Backup files and directories user right" granted by the server by ma=
king that user a part of the built-in group Backup Operators. This moun=
t option restricts to the specified user on the client, as such an auth=
enticated user, privilege to access files with the intent to back them =
up.
>>
>> Better, but this is still pretty awkward and confusing. This manpage
>> needs to answer 3 things:
>>
>> 1. what this option does (turn on the backup intent bit in open call=
s)
>
> Not sure if implentation specifics need to be mentioned in a man page=
=2E
>
>>
>> 2. what the backup intent bit does (allows a user to open files to
>> which he wouldn't ordinarily have access)
>
> So IMHO, this can be phrased as
>
> 1. what this option does (allows a user to open files to
> which he wouldn't ordinarily have access)
>
>>
>> 3. when should (or shouldn't) the user enable it?
>>

Be specific - list a case, a specific example, when a user couldn't ope=
n a file,
and where such a mount would help them copy (backup, archive)
the file.  In particular, if you have files on a server with ACL of
[give example]
and you have a regular user (even one who is a member of the backup
operator group)
it would fail, but if the user were a member of the backup operator
group and you specify the mount option it would work ...
--=20
Thanks,

Steve

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: cifs and win2k8
Date: Sun, 23 Oct 2011 23:10:01 +0400
Message-ID: <CAKywueSZzVmXvzB+PhTyxitrKTWL-o=4qqhRqcdzw=wfaj_wtw@mail.gmail.com>
References: <4EA154FC.3090601@gmail.com>
	<20111023103003.GA6132@cobija.connexer.com>
	<20111023065534.566a0aad@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>,
	Terrence Shipclark <terrence.shipclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111023065534.566a0aad-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/23 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Sun, 23 Oct 2011 12:30:03 +0200
> sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:
>
>> Hello Terrence,
>>
>> On Fri, Oct 21, 2011 at 07:18:20AM -0400, Terrence Shipclark wrote:
>> > I have been attempting to get the cifs kernel modules to mount the
>> > win2k8 dfs at my workplace. =A0 I did finally manage to get
>> > the dfs to mount after modifying the kernel module with this small=
 patch
>>
>> I believe this should already be fixed (in a more correct fashion) i=
n >=3D 3.0.
>>
>> > Within the dfs tree there is a referral to //server/share$/folder.
>> > My user has access to //server/share$/folder, however do not have
>> > access to
>> > //server/$share. =A0While following the referral the cifs module d=
oes a
>> > QUERY_PATH_INFO on \\server\share$\folder, and then is followed up
>> > by a QUERY_PATH_INFO on \\server\share$\ which rightfully returns =
a
>> > STATUS_ACCESS_DENIED from the server.
>>
>> I've also noticed that the mounting process seems to query more than
>> it should, but I've taken the easy way out and asked the local windo=
ws
>> admin to add "traverse filesystem" and "read attributes" permissions=
 on
>> the parent folders, which should be enough. =A0I suspect that there =
is a
>> "real fix" to avoid this, but haven't looked too hard myself.
>>
>>
>
> I believe this is a known bug...
>
> 3.0 got a patchset to allow superblocks to be shared, but that
> regressed the above use case (mounting a directory that you have acce=
ss
> to but not the stuff below it).
>
> Pavel had some patches that he was going to propose to fix it, but
> discussion of them sort of fell off. Pavel, did you ever come up with
> something that worked here?
>

We had the discussion in "[PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED
for mounts with prefixpath option" thread in this list where I
proposed a patch that fixes it. Later I found two bugs in it but
didn't send another (right) version because we decided to fix the
permission problem another way.

After that I didn't have time to work on it. So, I am going to give it
more time when we finished with merging lock patchset and SMB2 patches
for 3.2.

Also, if you are interested, I can send you the right version of the
patch I've already posted.

--=20
Best regards,
Pavel Shilovsky.

From: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problems with CVS on CIFS since kernel 2.6.30
Date: Mon, 2 Aug 2010 16:56:10 +0100
Message-ID: <AANLkTikqgFHX=9quJmJyQvkX-3ZreLGoF0k5YKCFq+WW@mail.gmail.com>
References: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>
	<4C56DBDD.4070501@suse.de>
	<AANLkTin9uwwDaw+nvAiDKnPxPbbBXycVS3rLvhCaoJxQ@mail.gmail.com>
	<4C56E564.3020508@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C56E564.3020508-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2 August 2010 16:33, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> On 08/02/2010 08:38 PM, Jon Bramley wrote:
>>
>>> The samba version you are using seem to be quite old.. Does better =
POSIX
>>> support/conformance sound like a good enough reason..?
>>
>> I doubt it. The problem I have is that it is working fine for Ubuntu
>> users (which is the vast majority) so they will not want to risk
>> breaking things. Of course that means I cannot currently update my
>> kernel (which they are less concerned about).
>
> If upgrading is not feasible, could you try patching Samba server wit=
h
> this patch (relatively very less risk):
> =A0 =A0http://www.mail-archive.com/samba-cvs-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org/msg55843=
=2Ehtml
>
> I think that should help resolving the bug with posix opens against
> older server.
>
>>>> strange thing, is that some of my colleagues run Ubuntu 10.04, whi=
ch
>>>> uses the 2.6.32 kernel, and they can use the share without problem=
=2E
>>
>>> What is the server version in this case?
>>
>> Exactly the same server that I'm connecting to (3.0.28a).
>>
>
> Strange.. Any idea whether the Ubuntu kernel is the released 2.6.32
> kernel or any -rc version of 2.6.32?

Just checked on a colleagues machine, and uname -r reports 2.6.32-24-ge=
neric

Also checked the dmesg on the Ubuntu 10.04 box:

[  964.362027]  CIFS VFS: Autodisabling the use of server inode
numbers on \\shared.openbet\shared. This server doesn't seem to
support them properly. Hardlinks will not be recognized on this mount.
Consider mounting with the "noserverino" option to silence this
message.
[  964.368470]  CIFS VFS: server 10.194.0.105 of type Samba 3.0.28a
returned unexpected error on SMB posix open, disabling posix open
support. Check if server update available.

The exact same errors that I get appear, which leads me to believe
that this in itself is not the cause of my issue.

Any other ideas to debug further?

Thanks,

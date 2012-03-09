From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 9 Mar 2012 14:16:51 -0600
Message-ID: <CAH2r5mvMWOVrKXYJjcKYwUR+yaJpzYysDoc+TvPmfN+RDHAQ5g@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
	<20120303070921.5ce2bb10@tlielax.poochiereds.net>
	<CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com>
	<20120309073930.3a79fa10@redhat.com>
	<CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw@mail.gmail.com>
	<4F5A543D.2040808@samba.org>
	<20120309201439.GH9348@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120309201439.GH9348@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 9, 2012 at 2:14 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, Mar 09, 2012 at 01:04:29PM -0600, Christopher R. Hertel wrote=
:
>>
>> The folks at Microsoft (who are, of course, well ahead in their
>> SMB2.x implementations) are very surprised that we are trying to
>> maintain a single codebase for both protocols. =A0(I heard the same
>> thing from several Microsoft engineers during separate
>> conversations.)
>
> That's just a misunderstanding of how our codebase is
> structured, that's all.
>
> The SMB1 parser/protocol engine is completely different code from the=
 SMB2
> parser/protocol engine in Samba.
>
> What is in common (as is also in common in Microsoft's codebase)
> is the code that implements the underlying file system functionality.
>
> They have a common NTFS (and now ReFS) codebase, we have a common
> map POSIX to Windows semantics layer.

On the client side, as a compromise with those who wanted one module,
(ie in Pavel's tree) we keep the majority of the smb2 specific code in
distinct c files
which are not linked in by default to cifs.ko.   Sharing the same trans=
port code
does have headaches though as the discussion above mentions with regard
to "credits" vs. "maxmpx" but it has turned out better than I originall=
y
expected (ie the changes to common code)

--=20
Thanks,

Steve

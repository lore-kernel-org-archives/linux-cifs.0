From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: packed attribute
Date: Mon, 16 Jan 2012 07:09:07 -0600
Message-ID: <CAH2r5mu49inWDNA_tVx2UW81ZPeMiBufa+8K2_z0fXUmmX4FbQ@mail.gmail.com>
References: <CAKywueSu=S-VkqS5K7=PYpt0a2hxR8Q=tmQrTEXSOvrKe=__Nw@mail.gmail.com>
	<20120116075723.2a4d30bd@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120116075723.2a4d30bd-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jan 16, 2012 at 6:57 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 16 Jan 2012 16:35:27 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I noticed that when I run checkpatch.pl over my smb2 patches it fail=
s on
>>
>> struct example {
>> ...
>> } __attribute__((packed));
>>
>> and suggests to use
>>
>> struct example {
>> ...
>> } __packed;
>>
>> Also we already have many such "style broken" structures in cifsdpu.=
h.
>>
>> What do you think about it? Should we fix them all?
>>
>
> Hmm interesting...there's some discussion of this a few months ago he=
re:
>
> =A0 =A0https://lkml.org/lkml/2011/6/22/25
>
> ...looks like __packed is a shortcut in the kernel's compiler-gcc.h
> header. Looks like using __packed is fine in new code as long as the
> header will never be used by userspace (which may not have that
> shortcut defined).
>

=46or new code it is good to make sure it is checkpatch clean
or reasonably close.   I doubt it is worth the trouble to
go through cifspdu.h and change existing defines for something
like ihis, but for smb2pdu.h might as well make it clean.

--=20
Thanks,

Steve

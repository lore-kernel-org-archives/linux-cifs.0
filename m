From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: packed attribute
Date: Tue, 17 Jan 2012 00:26:33 +0400
Message-ID: <CAKywueST9AEjZLWCMsMuvBaN9t73BNXPoFpBGwW3F=tYQQfBmg@mail.gmail.com>
References: <CAKywueSu=S-VkqS5K7=PYpt0a2hxR8Q=tmQrTEXSOvrKe=__Nw@mail.gmail.com>
	<20120116075723.2a4d30bd@tlielax.poochiereds.net>
	<CAH2r5mu49inWDNA_tVx2UW81ZPeMiBufa+8K2_z0fXUmmX4FbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu49inWDNA_tVx2UW81ZPeMiBufa+8K2_z0fXUmmX4FbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/1/16 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Mon, Jan 16, 2012 at 6:57 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On Mon, 16 Jan 2012 16:35:27 +0400
>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> I noticed that when I run checkpatch.pl over my smb2 patches it fai=
ls on
>>>
>>> struct example {
>>> ...
>>> } __attribute__((packed));
>>>
>>> and suggests to use
>>>
>>> struct example {
>>> ...
>>> } __packed;
>>>
>>> Also we already have many such "style broken" structures in cifsdpu=
=2Eh.
>>>
>>> What do you think about it? Should we fix them all?
>>>
>>
>> Hmm interesting...there's some discussion of this a few months ago h=
ere:
>>
>> =A0 =A0https://lkml.org/lkml/2011/6/22/25
>>
>> ...looks like __packed is a shortcut in the kernel's compiler-gcc.h
>> header. Looks like using __packed is fine in new code as long as the
>> header will never be used by userspace (which may not have that
>> shortcut defined).
>>
>
> For new code it is good to make sure it is checkpatch clean
> or reasonably close. =A0 I doubt it is worth the trouble to
> go through cifspdu.h and change existing defines for something
> like ihis, but for smb2pdu.h might as well make it clean.
>

Ok, I will change my smb2 patches appropriately.

--=20
Best regards,
Pavel Shilovsky.

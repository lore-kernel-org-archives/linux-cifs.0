From: Steve French <smfrench@gmail.com>
Subject: Re: 3.0-rc+git OOPS losetup on cifs
Date: Sat, 9 Jul 2011 12:53:04 -0500
Message-ID: <CAH2r5ms_5VBD+2c-6Tv+7KzU3NEN9ZHt4Q2nPgxZktn7dbcKxA@mail.gmail.com>
References: <alpine.DEB.2.02.1107042132500.18300@aurora>
	<4E155F6F.6070506@suse.de>
	<alpine.DEB.2.02.1107090250240.5791@aurora>
	<alpine.DEB.2.02.1107091541080.17541@aurora>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>
To: Sven-Haegar Koch <haegar@sdinet.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1107091541080.17541@aurora>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

ok - will review today and plan to merge if ok

On Sat, Jul 9, 2011 at 8:42 AM, Sven-Haegar Koch <haegar@sdinet.de> wrote:
> On Sat, 9 Jul 2011, Sven-Haegar Koch wrote:
>
>> On Thu, 7 Jul 2011, Suresh Jayaraman wrote:
>>
>> > On 07/05/2011 01:18 AM, Sven-Haegar Koch wrote:
>> > > Since a short while (I know it worked with 3.0-rc1) loopback-mounting an
>> > > image on a samba server mounted with cifs oopses the kernel.
>> ...
>> > I couldn't reproduce this with 3.0-rc6 with a smaller image file (1GB).
>> > But I see no relevant fixes between -rc5 and -rc6.
>> >
>> > Can you try to reproduce the same problem with a smaller non-encrypted file?
>>
>> I can, and it seems something even more fundamental.
>
>
> Update for the list (archive) readers:
>
> The patch in https://bugzilla.kernel.org/show_bug.cgi?id=38972#c12 fixes
> the problem for me completely.
>
> Thanks Jeff Layton
>
> c'ya
> sven-haegar
>
> --
> Three may keep a secret, if two of them are dead.
> - Ben F.
>



-- 
Thanks,

Steve

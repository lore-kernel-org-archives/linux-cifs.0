From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/09] cifs: local caching support using FS-Cache
Date: Thu, 15 Jul 2010 18:23:19 +0200
Message-ID: <4C3F35F7.8060408@suse.de>
References: <1278333663-30464-1-git-send-email-sjayaraman@suse.de>	<4C3DF6BF.3070001@gmail.com> <AANLkTin2tKtkWTflrrzBMYBEd6SFr35uYUl1SmfYlj9W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin2tKtkWTflrrzBMYBEd6SFr35uYUl1SmfYlj9W-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/14/2010 08:09 PM, Steve French wrote:
> On Wed, Jul 14, 2010 at 12:41 PM, Scott Lovenberg
> <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On 7/5/2010 8:41 AM, Suresh Jayaraman wrote:
>>>
>>> This patchset is a second try at adding persistent, local caching f=
acility
>>> for
>>> CIFS using the FS-Cache interface.
>>>
>>>
>>
>> Just wondering, have you bench marked this at all? =EF=BF=BDI'd be i=
nterested to see
>> how this compares (performance and scaling) to an oplock-centric des=
ign.
>>

Yes, I have done a few performance benchmarks with the cifs client (and
not SMB2) and I'll post them early nextweek when I'm back (as I'm
travelling now).

However, I have never done scalability tests (not sure whether there is
a way to simulate a number of cifs clients).

>> I'd hazard a guess that with pipelining support in SMB2 the performa=
nce will
>> be even better since you can have a hot cache and more requests in f=
light.
>=20
> Yes - very plausibly
>=20

I have not tried the new SMB2 client. But, it seems the pipelining
support, Oplocks (only Level II kind) could help improve performance.


Thanks,

--=20
Suresh Jayaraman

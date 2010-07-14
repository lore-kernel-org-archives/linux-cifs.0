From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/09] cifs: local caching support using FS-Cache
Date: Wed, 14 Jul 2010 13:09:40 -0500
Message-ID: <AANLkTin2tKtkWTflrrzBMYBEd6SFr35uYUl1SmfYlj9W@mail.gmail.com>
References: <1278333663-30464-1-git-send-email-sjayaraman@suse.de>
	<4C3DF6BF.3070001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3DF6BF.3070001-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 14, 2010 at 12:41 PM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 7/5/2010 8:41 AM, Suresh Jayaraman wrote:
>>
>> This patchset is a second try at adding persistent, local caching fa=
cility
>> for
>> CIFS using the FS-Cache interface.
>>
>>
>
> Just wondering, have you bench marked this at all? =A0I'd be interest=
ed to see
> how this compares (performance and scaling) to an oplock-centric desi=
gn.
>
> I'd hazard a guess that with pipelining support in SMB2 the performan=
ce will
> be even better since you can have a hot cache and more requests in fl=
ight.

Yes - very plausibly



--=20
Thanks,

Steve

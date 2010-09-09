From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs tree updated to back out crypto/ntlmv2/ntlmssp change to
 2.6.37 - but now has the cifsd fixes
Date: Thu, 9 Sep 2010 10:34:03 -0500
Message-ID: <AANLkTikW3oJ-xWJWR4meJrnGnA3zTa6a4c_J_2xtJyGV@mail.gmail.com>
References: <AANLkTimraXF9gVC-o5qb2mfDfrq6=9-CTtyGeew27ne6@mail.gmail.com>
	<20100909075242.11d03854@barsoom.rdu.redhat.com>
	<4C88CC9B.9040904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C88CC9B.9040904-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 9, 2010 at 7:01 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> w=
rote:
> On 09/09/2010 05:22 PM, Jeff Layton wrote:
>> On Wed, 8 Sep 2010 16:25:09 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> CIFS tree updated to back out the crypto/ntlmv2/ntlmssp change
>>> (included patch 2/8 because it was reviewed and independent). =A0 A=
dded
>>> to the cifs tree the fixes to prevent premature exit to cifsd and t=
o
>>> prevent the possibly ip address memory corruption.
>>>
>>> --
>>> Thanks,
>>>
>>
>> Looks good to me.
>>
>> BTW, when you send the pull request to Linus, could you also cc
>> linux-cifs? It's helpful to know when you send these out so that we =
know
>> to keep a closer eye on mainline.
>>
>
> Yes, please. It would help to know when pull request is being sent.

OK - let's give it one day in linux-next and to see if anything broken

--=20
Thanks,

Steve

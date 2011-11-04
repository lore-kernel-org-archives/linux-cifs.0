From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to test multiusermount?
Date: Fri, 4 Nov 2011 00:56:16 -0500
Message-ID: <CAH2r5mtAbBhRj6SSB5TNWW4OtTJhno7szPH7FR6tn0rS1FB6=w@mail.gmail.com>
References: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA@mail.gmail.com>
	<20111101060428.5d474bb9@tlielax.poochiereds.net>
	<4EB37983.3080607@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EB37983.3080607-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 4, 2011 at 12:34 AM, Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>=
 wrote:
> On 11/01/2011 03:34 PM, Jeff Layton wrote:
>> On Tue, 1 Nov 2011 00:12:21 +0100
>> Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> Hi,
>>>
>>> I would like to test the multiusermounts?
>>>
>>> I know to set:
>>>
>>> =A0echo 1 > /proc/fs/cifs/MultiuserMount
>>>
>>> and add an option to the mount command, but I can remember/read som=
ewhere
>>> that one have to add some mapping somehwere:
>>>
>>> local user : remote user
>>> ...
>>>
>>> Is this correct?
>>>
>>
>> No. The MultiuserMount code that the above switch activates is
>> basically deprecated (and never worked very well in the first place)=
=2E
>
> So, time for planning its good riddance?

Mainly waiting for some way to have ntlmv2 enablement of multiuser
mount (krb5 only is too restrictive).



--=20
Thanks,

Steve

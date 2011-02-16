From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix broken lanman (lm) auth code (try #3)
Date: Wed, 16 Feb 2011 17:51:55 -0600
Message-ID: <AANLkTi=YchF+yE6fhNnHwCSoac13SErOZ_wp6keB3vSV@mail.gmail.com>
References: <1297888050-15736-1-git-send-email-shirishpargaonkar@gmail.com>
	<AANLkTimu6hEEVgDq9qwpivJR3mZEAwHuKxbzaTCGESM+@mail.gmail.com>
	<AANLkTikMtKgzUuPUvqdmR0dJz-6N2JSyVsE1-PCfA7QC@mail.gmail.com>
	<AANLkTikd+kkzHsOQw=EZGSx7SqqMX49sa1wi_DCBYtn6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikd+kkzHsOQw=EZGSx7SqqMX49sa1wi_DCBYtn6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Feb 16, 2011 at 3:15 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Wed, Feb 16, 2011 at 3:05 PM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Feb 16, 2011 at 2:53 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>> On Wed, Feb 16, 2011 at 2:27 PM, =A0<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>
>>>>
>>>> Fix lanman (lm) authentication code.
>>>>
>>>> Change lm response length back to 24 from 16.
>>>> Parse lanmani mount option.
>>>
>>> lanman21 (and earlier dialects) did not support packet signing
>>> (requires NTLM12 or later dialect. =A0I don't know what happens if
>>> you try to set sec=3Dlanmani with your patch
>>> but I would not expect it to ever force signing and work.
>>>
>>>
>>> We note this in our readme e.g.
>>> =A0sign =A0 =A0 =A0 =A0 =A0 Must use packet signing (helps avoid un=
wanted data modification
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0by intermediate systems in the route=
). =A0Note that signing
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0does not work with lanman or plainte=
xt authentication.
>>
>> Steve, is that a limitation within cifs client or protocol limitatio=
n?
>> I think there is a session key calculation associated with lanman
>> authentication.
>
> The protocol first defined packet signing in NTLM12 dialect. =A0The f=
lag
> was undefined before then, and the fields for the signature itself
> in the header were reserved.
>
> Remember that LANMAN dialect uses an older format of SMB SessionSetup=
X
> as well.
>
> I am not opposed to adding the new mount option lanmani if you can
> demonstrate it working to Windows or Samba, but it is likely signing
> won't work if you force the older dialect and try the new sec=3Dlamna=
mi

yes, it is not working on either. Will remove adding parsing for
lanmani mount option
and resubmit the patch.

>
>
>
> --
> Thanks,
>
> Steve
>

From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: I would like to work on removing GlobalMid_Lock as my first task ...
Date: Thu, 31 May 2012 06:21:31 -0700
Message-ID: <CACyXjPyG8FUk-A_nmq79VKzagSxs=qjnhEu26nk2T560pk1j1A@mail.gmail.com>
References: <CACyXjPxLq_3tVNvxUbv9+npEv7xB2MhThnKVMe-9E=ExgHrcJQ@mail.gmail.com>
	<CAKywueQEw25p16T2=DAHi9zRHvKR3ueW=0U6Fp9WYLdOxFH0jQ@mail.gmail.com>
	<CACyXjPwCGNzW9sTSPYuW54652YzVruGAua4Qu7J15=dKCmn5-g@mail.gmail.com>
	<CAKywueQUGHxRmZMphZ0aTt=Q6b6nHN9UC5UanQOYipjq=YDFQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQUGHxRmZMphZ0aTt=Q6b6nHN9UC5UanQOYipjq=YDFQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 30, 2012 at 9:46 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> 2012/5/30 Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> On Wed, May 30, 2012 at 8:00 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>>> 2012/5/30 Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>>> Hi folks,
>>>>
>>>> I find it easier to get to know a body of code if I have a specifi=
c goal.
>>>>
>>>> If no one has any objections I would like to work on removing
>>>> GlobalMid_Lock (or at least, moving it into struct TCP_Server_Info=
=2E)
>>>>
>>>> Which branch should I work in? I can see:
>>>>
>>>>  master
>>>> * smb2-dev
>>>>  remotes/origin/HEAD -> origin/master
>>>>  remotes/origin/cifs-patches
>>>>  remotes/origin/for-next
>>>>  remotes/origin/master
>>>>  remotes/origin/smb2-3.4
>>>>  remotes/origin/smb2-dev
>>>>  remotes/origin/smb2-dev-prev
>>>>  remotes/origin/smb2-dev2
>>>
>>> [Deletia]
>>>
>>> Hi!
>>>
>>> That's good point to start with - no objections from my side.
>>>
>>> I think you should create your own branch based on Steve's master. =
As
>>> soon as we come to agreement with a change (from any author - yours=
,
>>> Jeff's, etc) it will go to Steve's for-next branch and each of us
>>> should rebase his own work branch(es) - from my side they are
>>> 'cifs-patches' and 'smb2-dev'.
>>>
>>> Let the list know about your branch as your create it and if it wil=
l
>>> be available online, please.
>>
>> Hmmm, where is the best place to host my stuff. At the moment it is
>> just on my laptop. Would github object if I have a large repos there=
?
>> :-) Maybe I should create one on git.samba.org ...
>>
>>> P.S. It seems that your remote 'origin' here is my git repo on
>>> git.altlinux.ru. You should refetch it often enough if you want to =
get
>>> my latest version (smb2-dev-prev, smb2-dev2, smb2-3.4 no longer exi=
st)
>>>>  master
>>
>> Yeah, I do fetch regularly and rebase all the time ...
>
> Ok, the old names of my branches just confused me a little :)

I needed to do a 'git remote prune origin' and they went away :-)

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)

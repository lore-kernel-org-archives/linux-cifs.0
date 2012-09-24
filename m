From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot
 allocate memory
Date: Sun, 23 Sep 2012 19:03:01 -0500
Message-ID: <CAH2r5msLRvtFOzEVR3g8Tq+j+k9D4SurBPOeez=DOL7d3_uTDg@mail.gmail.com>
References: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com>
	<4EC269FC.1060104@suse.com>
	<004b01cca3cc$932e4240$b98ac6c0$@lucidpixels.com>
	<4EC334D6.9020208@suse.com>
	<loom.20120922T005738-960@post.gmane.org>
	<CAH2r5msw6r9N2WQAVX+iHGMy++=wp4qUU1k_F+N93xLsZ9i1zg@mail.gmail.com>
	<CAPJ9Yc-FKLzH_BK++iL4uV59gy-dVCDGYs=ZFfsJVimWfGKdbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?David_Bala=C5=BEic?= <xerces9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPJ9Yc-FKLzH_BK++iL4uV59gy-dVCDGYs=ZFfsJVimWfGKdbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If it still fails with max_pending set to 9 or 10 (on the client) -
then you are stuck with having to fix the server (there were a couple
of registry parms which can be set in Windows, mentioned in earlier
posts which apparently resolve this).  ( had trouble reproducing this
with max pending set low.

We may want to enable SMB2 dialect (SMB2.1 dialect is currently
enabled in linux-next, but not SMB2.0 dialect which Vista uses) if
Vista fails (was this Vista or Windows 7) - since SMB2 uses a
different crediting mechanism?

On Sun, Sep 23, 2012 at 11:02 AM, David Bala=C5=BEic <xerces9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
> On 22 September 2012 02:02, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>
>> On Fri, Sep 21, 2012 at 6:05 PM, David Bala=C5=BEic <xerces9@gmail.c=
om> wrote:
>>>
>>> Suresh Jayaraman <sjayaraman@...> writes:
>>>
>>> > Ah, ok. In case if you have not figured out how to overcome this
>>> > problem, take a look at
>>> >
>>> >
>>> > http://alan.lamielle.net/2009/09/03/windows-7-nonpaged-pool-srv-e=
rror-2017
>>>
>>> (I'm not subscribed, so please CC me)
>>>
>>> Hi!
>>>
>>> I also encountered this error 12 accessing a shared folder on a Win=
dows 7
>>> Pro
>>> SP1 64-bit "server", client being SystemRescueCd 3.0.0 with kernel =
version
>>> 3.2.28 32 bit. It also happens with other kernels (RipLinux 13.7, k=
ernel
>>> 3.2.1).
>>>
>>>
>>> I got the error when copying a single large file to the shared fold=
er.
>>> The registry tweaks at that URL mitigates the problem.
>>> But I changed it back to do some research.
>>> When accessing the same shared folder from a Windows 7 Home Premium=
 SP1
>>> x64
>>> client, there is no problem.
>>>
>>> When I tried with Linux just before posting this, I got error 12 ri=
ght
>>> when
>>> mounting, before doing any file operations.
>>>
>>> Is this because linux-cifs does not respect the MaxReq parm that th=
e
>>> server
>>> sends, as suggested in this post:
>>> http://article.gmane.org/gmane.linux.kernel.cifs/4294 ?
>>>
>>
>> We were able to reproduce this problem to Windows, even when
>> the (Windows Vista/Windows 7) server was configured for 50 requests,
>> but current cifs.ko (3.4 kernels and later) does respect the servers
>> MaxReq parameter (maximum simultaneous requests limit).
>>
>> To servers, like Samba, which can handle much more than 50
>> simultaneous requests, note that the server's limit can be configure=
d
>> (increased) in the server's smb.conf file beyond the typical default
>> (50 for most server's and clients - thus the reason cifs client
>> simply defaulted to 50 prior to 3.4).
>
> I tried setting the cifs_max_pending module parameter, also kernel 3.=
4.9
>
> It is better, but there are still some errors 12.
>
> Any recommendations? (besides trying a newer kernel)
>
> Regards,
> David



--=20
Thanks,

Steve

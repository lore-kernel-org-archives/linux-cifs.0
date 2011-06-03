From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix the kernel release version in the default
 security warning message
Date: Fri, 3 Jun 2011 12:41:14 -0500
Message-ID: <BANLkTik4izyUy_4=8iAs2zFDzU_HgW-Wng@mail.gmail.com>
References: <4DE880E3.8020502@suse.de>
	<20110603091119.7596fade@corrin.poochiereds.net>
	<4DE90669.5020108@suse.de>
	<20110603123739.4875a6e5@corrin.poochiereds.net>
	<4DE91C33.4040307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE91C33.4040307-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 3, 2011 at 12:38 PM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 6/3/2011 12:37 PM, Jeff Layton wrote:
>>
>> On Fri, 03 Jun 2011 21:36:01 +0530
>> Suresh Jayaraman<sjayaraman-l3A5Bk7waGM@public.gmane.org> =A0wrote:
>>
>>> On 06/03/2011 06:41 PM, Jeff Layton wrote:
>>>>
>>>> On Fri, 03 Jun 2011 12:06:19 +0530
>>>> Suresh Jayaraman<sjayaraman-l3A5Bk7waGM@public.gmane.org> =A0wrote:
>>>>
>>>>> When ntlm security mechanim is used, the message that warns about=
 the
>>>>> upgrade
>>>>> to ntlmv2 got the kernel release version wrong (Blame it on Linus=
 :).
>>>>> Fix it.
>>>>>
>>>>> Signed-off-by: Suresh Jayaraman<sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>>>> ---
>>>>> =A0fs/cifs/connect.c | =A0 =A02 +-
>>>>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>>>> index 6d88b82..84c7307 100644
>>>>> --- a/fs/cifs/connect.c
>>>>> +++ b/fs/cifs/connect.c
>>>>> @@ -1976,7 +1976,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *se=
rver,
>>>>> struct smb_vol *volume_info)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0warned_on_ntlm =3D true;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "default security mechan=
ism requested. =A0The
>>>>> default "
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"security mechanis=
m will be upgraded from ntlm
>>>>> to "
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ntlmv2 in kernel r=
elease 2.6.41");
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ntlmv2 in kernel r=
elease 3.1");
>>>>> =A0 =A0 =A0 =A0}
>>>>> =A0 =A0 =A0 =A0ses->overrideSecFlg =3D volume_info->secFlg;
>>>>>
>>>> Looks good. Though I'm not sure whether we should call it 3.1.0?
>>>> Regardless...
>>>
>>> I thought about this. But, as Linus has already said:
>>>
>>> "Now, my alpha-maleness sadly does not actually extend to all the
>>> scripts and Makefile rules, so the kernel is fighting back, and is
>>> calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle=
 it
>>> into submission, and get scripts etc cleaned up, and the final rele=
ase
>>> should be just "3.0". The -stable team can use the third number for
>>> their versioning."
>>>
>>> I think 3.1 should be ok?
>>>
>> Pity -- would have been sort of nice to always use a 3 field version
>> number since the stable kernels will need that, but...not my call.
>> Either way, patch is fine.
>
> I think 3.0 was being called 3.0.0 officially because some scripts br=
oke
> without a "major.minor.revision" scheme. =A0At least for the moment, =
according
> to Linus' commit message.
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D55922c9d1b84b89cb946c777fddccb3247e7df2c

It won't matter for an informational message fortunately and 3.1 > 3.0.=
1

--=20
Thanks,

Steve
